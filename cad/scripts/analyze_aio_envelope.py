"""Conservative interval bounds plus adverse witnesses; no sampling-only fit claim."""
import hashlib
import itertools
import json
import math
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
INPUT=ROOT/'cad/components/aio-envelope-inputs.json'

def rect_distance(point,side,angle):
    c,s=math.cos(angle),math.sin(angle)
    x,y=point
    u,v=c*x+s*y,-s*x+c*y
    return math.hypot(max(abs(u)-side/2,0),max(abs(v)-side/2,0))

def main():
    e=json.loads(INPUT.read_text())
    source=json.loads((ROOT/'cad/components/aio-screen.json').read_text())
    center=source['adapter_center_x_mm']
    points=[(x-center,y) for x,y in source['standoff_centers_xy_mm']]
    error=e['relative_xy_error_per_axis_mm']
    assert abs(sum(e['relative_xy_error_budget_mm'].values())-error)<1e-12
    shift=math.sqrt(2)*error
    yaw=math.radians(e['assembly_yaw_error_deg'])
    radius=e['standoff_od_max_mm']/2
    candidates=[]
    for side in e['adapter_side_candidates_mm']:
        size=side+e['adapter_side_total_size_tolerance_mm']
        rotation_loss=size/math.sqrt(2)*2*math.sin(yaw/2)
        # Distance is 1-Lipschitz under translation and bounded Hausdorff rotation.
        nominal=min(rect_distance(p,size,0) for p in points)
        lower=nominal-radius-shift-rotation_loss
        # Adverse realizable endpoint cases are failure witnesses, not the proof of the lower bound.
        cases=[]
        for p in points:
            for dx,dy,a in itertools.product((-error,error),(-error,error),(-yaw,0,yaw)):
                gap=rect_distance((p[0]+dx,p[1]+dy),size,a)-radius
                cases.append((gap,p,dx,dy,math.degrees(a)))
        witness=min(cases)
        candidates.append({'side_mm':side,'guaranteed_planar_gap_lower_bound_mm':lower,
                           'adverse_case_gap_mm':witness[0],'adverse_case':list(witness[1:]),
                           'meets_1mm_bound':lower>=e['minimum_hard_clearance_mm']})
    board=e['aio_design_max_mm'][0]
    board_rot_loss=board/math.sqrt(2)*2*math.sin(yaw/2)
    board_gap=min(rect_distance(p,board,math.pi/4) for p in points)-radius-shift-board_rot_loss
    service_side=board+2*e['service_radial_expansion_trial_mm']
    service_gap=min(rect_distance(p,service_side,math.pi/4) for p in points)-radius-shift-service_side/math.sqrt(2)*2*math.sin(yaw/2)
    chosen=next(c for c in candidates if c['meets_1mm_bound'])
    tilt=math.radians(e['assembly_tilt_error_deg'])
    adapter_tilt=(chosen['side_mm']+e['adapter_side_total_size_tolerance_mm'])/math.sqrt(2)*math.sin(tilt)
    board_tilt=board/math.sqrt(2)*math.sin(tilt)
    support_lo,support_hi=e['adapter_support_gap_mm']
    # P=upper mounting-plate bearing face. Using the minimum of both support stacks
    # also screens mismatched stacks; it does not authorize forcing them coplanar.
    mount_plate_hi=e['arm_spacer_with_allowance_mm'][1]+e['plate_nominal_2mm_with_allowance_mm'][1]
    ceiling=min(e['standoff_22_with_allowance_mm'][0],e['standoff_30_with_allowance_mm'][0]-mount_plate_hi)-e['plate_bow_allowance_mm']
    z_results={
       'topology_B_ceiling_above_P_lower_mm':ceiling,
       'adapter_underside_to_P_lower_mm':support_lo-adapter_tilt-e['plate_bow_allowance_mm'],
       'under_fastener_to_P_lower_mm':support_lo-adapter_tilt-e['plate_bow_allowance_mm']-e['mount_fastener_bottom_projection_max_mm'],
       'aio_to_adapter_lower_mm':e['isolator_effective_rise_mm'][0]-board_tilt,
       'aio_top_to_ceiling_lower_mm':ceiling-support_hi-e['adapter_thickness_mm'][1]-e['isolator_effective_rise_mm'][1]-e['aio_design_max_mm'][2]-board_tilt-adapter_tilt,
    }
    z_results['top_fastener_to_ceiling_lower_mm']=z_results['aio_top_to_ceiling_lower_mm']-e['mount_fastener_top_projection_max_mm']
    # A continuum proof for Z: all terms are monotonic; extrema at endpoints.
    z_cases=[]
    for b,arm,plate,front,rear in itertools.product(e['bottom_thickness_with_design_allowance_mm'],e['arm_spacer_with_allowance_mm'],e['plate_nominal_2mm_with_allowance_mm'],e['standoff_22_with_allowance_mm'],e['standoff_30_with_allowance_mm']):
        P=arm+plate
        z_cases.append({'bottom_mm':b,'arm_mm':arm,'plate_mm':plate,'front_mm':front,'rear_mm':rear,
                        'ceiling_above_P_mm':min(front,rear-P)-e['plate_bow_allowance_mm'],
                        'support_height_mismatch_mm':P+front-rear})
    assert abs(min(c['ceiling_above_P_mm'] for c in z_cases)-ceiling)<1e-9
    assert rect_distance((0,0),10,0)==0
    assert abs(rect_distance((8,9),10,0)-5)<1e-12
    assert chosen['side_mm']==45
    report={'status':'PARTIAL_ROBUST_BOUNDS_NOT_COMPLETE_ADAPTER_QUALIFICATION',
            'input_sha256':hashlib.sha256(INPUT.read_bytes()).hexdigest(),
            'method':'Continuum translation/rotation distance lower bounds; monotonic Z interval extrema. Finite XY cases provide adverse witnesses only.',
            'candidate_results':candidates,'recommended_outer_side_mm':chosen['side_mm'],
            'aio_body_standoff_gap_lower_mm':board_gap,'trial_service_envelope_standoff_gap_lower_mm':service_gap,
            'trial_wire_bend_outer_radius_mm':e['power_wire_bend_radius_trial_mm']+e['power_wire_od_trial_max_mm']/2+e['power_wire_keepout_gap_mm'],
            'z_results':z_results,'z_endpoint_cases':z_cases,
            'topology_A_result':'MOUNT_COLUMNS_BLOCKED_BY_INTERVENING_DRAW14; no robustness across unresolved topology claimed',
            'unknown_minima':['actual USB/SD and connector access','actual wire bend/route clearance','bus/harness and guard clearance','thread engagement and load capacity','airflow/thermal suitability'],
            'fabrication_release':False}
    out=ROOT/'cad/components/aio-envelope-results.json'
    out.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:v for k,v in report.items() if k not in ('z_endpoint_cases',)},indent=2))

if __name__=='__main__':main()
