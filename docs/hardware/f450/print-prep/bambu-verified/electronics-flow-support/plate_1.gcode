; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 19m 24s; total estimated time: 28m 36s
; total layer number: 27
; total filament length [mm] : 1459.27
; total filament volume [cm^3] : 3509.94
; total filament weight [g] : 4.56
; filament_density: 1.3
; filament_diameter: 1.75
; max_z_height: 5.40
; filament: 1
; support_material_on_wipe_tower: 0
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 1
; accel_to_decel_factor = 50%
; activate_air_filtration = 0
; additional_cooling_fan_speed = 0
; additional_fan_full_speed_layer = 0
; alternate_extra_wall = 0
; ams_filament_load_time_ams = 0
; ams_filament_load_time_ams_lite = 0
; ams_filament_load_time_n3f_s = 0
; ams_filament_unload_time_ams = 0
; ams_filament_unload_time_ams_lite = 0
; ams_filament_unload_time_n3f_s = 0
; apply_scarf_seam_on_circles = 1
; auxiliary_fan = 1
; avoid_crossing_wall_includes_support = 0
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 0x0,18x0,18x28,0x28
; bed_heat_soak_area = 
; bed_temperature_formula = by_first_filament
; before_layer_change_gcode = 
; best_object_pos = 0.5,0.5
; bottom_color_penetration_layers = 3
; bottom_shell_layers = 5
; bottom_shell_thickness = 0
; bottom_surface_density = 100%
; bottom_surface_pattern = monotonic
; bridge_angle = 0
; bridge_flow = 1
; bridge_no_support = 0
; bridge_speed = 25
; brim_object_gap = 0.2
; brim_type = outer_only
; brim_width = 3
; chamber_temperatures = 0
; change_filament_gcode = ;=X1E 20250822=\nM620 S[next_extruder]A\nM204 S9000\nG1 Z{max_layer_z + 3.0} F1200\n\nG1 X70 F21000\nG1 Y245\nG1 Y265 F3000\nM400\nM106 P1 S0\nM106 P2 S0\n{if nozzle_temperature[previous_extruder] > 142 && next_extruder < 255}\nM104 S{nozzle_temperature[previous_extruder]}\n{endif}\nG1 X90 F3000\nG1 Y255 F4000\nG1 X100 F5000\nG1 X120 F15000\n{if long_retraction_when_cut && retraction_distance_when_cut > 2}\nG1 E-[retraction_distance_when_cut] F200\nM400\n{endif}\nG1 X20 Y50 F21000\nG1 Y-3\n{if toolchange_count == 2}\n; get travel path for change filament\nM620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0\nM620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1\nM620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2\n{endif}\nM620.1 E F{flush_volumetric_speeds[previous_extruder]/2.4053*60} T{flush_temperatures[previous_extruder]}\nT[next_extruder]\nM620.1 E F{flush_volumetric_speeds[next_extruder]/2.4053*60} T{flush_temperatures[next_extruder]}\n\n{if next_extruder < 255}\nM400\n{if long_retraction_when_cut && retraction_distance_when_cut > 2}\nG1 E{retraction_distance_when_cut - 2} F200\nG1 E2 F20\nM400\n{endif}\nG92 E0\n{if flush_length_1 > 1}\nM83\n; FLUSH_START\n; always use highest temperature to flush\nM400\n{if filament_type[next_extruder] == \"PETG\"}\nM109 S260\n{elsif filament_type[next_extruder] == \"PVA\"}\nM109 S210\n{else}\nM109 S{flush_temperatures[next_extruder]}\n{endif}\n{if flush_length_1 > 23.7}\nG1 E23.7 F{flush_volumetric_speeds[previous_extruder]/2.4053*60} ; do not need pulsatile flushing for start part\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{(flush_length_1 - 23.7) * 0.02} F50\nG1 E{(flush_length_1 - 23.7) * 0.23} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\n{else}\nG1 E{flush_length_1} F{flush_volumetric_speeds[previous_extruder]/2.4053*60}\n{endif}\n; FLUSH_END\nG1 E-[old_retract_length_toolchange] F1800\nG1 E[old_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_2 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\nG1 E{flush_length_2 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_2 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_3 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\nG1 E{flush_length_3 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_3 * 0.02} F50\n; FLUSH_END\nG1 E-[new_retract_length_toolchange] F1800\nG1 E[new_retract_length_toolchange] F300\n{endif}\n\n{if flush_length_4 > 1}\n\nG91\nG1 X3 F12000; move aside to extrude\nG90\nM83\n\n; FLUSH_START\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\nG1 E{flush_length_4 * 0.18} F{flush_volumetric_speeds[next_extruder]/2.4053*60}\nG1 E{flush_length_4 * 0.02} F50\n; FLUSH_END\n{endif}\n; FLUSH_START\nM400\nM109 S{nozzle_temperature[next_extruder]}\nG1 E2 F{flush_volumetric_speeds[next_extruder]/2.4053*60} ;Compensate for filament spillage during waiting temperature\n; FLUSH_END\nM400\nG92 E0\nG1 E-[new_retract_length_toolchange] F1800\nM106 P1 S255\nM400 S3\n\nG1 X70 F5000\nG1 X90 F3000\nG1 Y255 F4000\nG1 X105 F5000\nG1 Y265 F5000\nG1 X70 F10000\nG1 X100 F5000\nG1 X70 F10000\nG1 X100 F5000\n\nG1 X70 F10000\nG1 X80 F15000\nG1 X60\nG1 X80\nG1 X60\nG1 X80 ; shake to put down garbage\nG1 X100 F5000\nG1 X165 F15000; wipe and shake\nG1 Y256 ; move Y to aside, prevent collision\nM400\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\nM621 S[next_extruder]A\n
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200
; close_additional_fan_first_x_layers = 3
; close_fan_the_first_x_layers = 3
; compatible_printers_condition = 
; complete_print_exhaust_fan_speed = 70
; cool_plate_temp = 0
; cool_plate_temp_initial_layer = 0
; cooling_filter_enabled = 0
; cooling_perimeter_transition_distance = 10
; cooling_slowdown_logic = uniform_cooling
; counter_coef_1 = 0
; counter_coef_2 = 0.025
; counter_coef_3 = -0.11
; counter_limit_max = 0.05
; counter_limit_min = -0.04
; counterbore_hole_bridging = none
; curr_bed_type = Textured PEI Plate
; default_acceleration = 10000
; default_ams_type = -1
; default_filament_colour = ""
; default_filament_profile = "Bambu PLA Basic @BBL X1C"
; default_jerk = 0
; default_nozzle_volume_type = Standard
; default_print_profile = 0.20mm Standard @BBL X1C
; deretraction_speed = 30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50
; different_settings_to_system = ;;
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70
; elefant_foot_compensation = 0.15
; embedding_wall_into_infill = 0
; enable_arc_fitting = 0
; enable_circle_compensation = 0
; enable_filament_dynamic_map = 0
; enable_height_slowdown = 0
; enable_long_retraction_when_cut = 1
; enable_mixed_color_sublayer = 0
; enable_order_independent_overlap_carving = 0
; enable_overhang_bridge_fan = 1
; enable_overhang_speed = 1
; enable_pre_heating = 0
; enable_pressure_advance = 0
; enable_prime_tower = 0
; enable_support = 0
; enable_support_ironing = 0
; enable_tower_interface_features = 0
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 70
; eng_plate_temp_initial_layer = 70
; ensure_vertical_shell_thickness = enabled
; exclude_object = 0
; extruder_ams_count = 
; extruder_clearance_dist_to_rod = 40
; extruder_clearance_height_to_lid = 90
; extruder_clearance_height_to_rod = 34
; extruder_clearance_max_radius = 68
; extruder_colour = #018001
; extruder_max_nozzle_count = 1
; extruder_nozzle_stats = 
; extruder_offset = 0x2
; extruder_printable_area = 
; extruder_printable_height = 0
; extruder_type = Direct Drive
; extruder_variant_list = "Direct Drive Standard,Direct Drive High Flow"
; fan_cooling_layer_time = 30
; fan_direction = undefine
; fan_max_speed = 60
; fan_min_speed = 20
; farthest_point_timelapse = 0
; filament_adaptive_volumetric_speed = 0
; filament_adhesiveness_category = 300
; filament_bridge_speed = 25
; filament_change_length = 10
; filament_change_length_nc = 10
; filament_colour = #F2754E
; filament_cooling_before_tower = 10
; filament_cost = 30
; filament_density = 1.3
; filament_dev_ams_drying_ams_limitations = ""
; filament_dev_ams_drying_heat_distortion_temperature = 0
; filament_dev_ams_drying_temperature = 0
; filament_dev_ams_drying_time = 0
; filament_dev_chamber_drying_bed_temperature = 0
; filament_dev_chamber_drying_time = 0
; filament_dev_drying_cooling_temperature = 0
; filament_dev_drying_softening_temperature = 0
; filament_diameter = 1.75
; filament_enable_overhang_speed = 1
; filament_end_gcode = "; filament end gcode \n\n"
; filament_extruder_compatibility = 0
; filament_extruder_variant = "Direct Drive Standard"
; filament_flow_ratio = 0.95
; filament_flush_temp = 0
; filament_flush_temp_fast = 0
; filament_flush_volumetric_speed = 0
; filament_ids = GFG99
; filament_is_mixed = 0
; filament_is_support = 0
; filament_map = 1
; filament_map_2 = 0
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 8
; filament_metal_stickiness = None
; filament_minimal_purge_on_wipe_tower = 15
; filament_mixed_components = ""
; filament_mixed_gradient = 0
; filament_mixed_gradient_curve = ""
; filament_mixed_gradient_per_part = 0
; filament_mixed_gradient_range = ""
; filament_mixed_sublayer_ratios = ""
; filament_notes = 
; filament_nozzle_map = 0
; filament_overhang_1_4_speed = 0
; filament_overhang_2_4_speed = 0
; filament_overhang_3_4_speed = 0
; filament_overhang_4_4_speed = 0
; filament_overhang_totally_speed = 10
; filament_pre_cooling_temperature = 0
; filament_pre_cooling_temperature_nc = 0
; filament_preheat_temperature_delta = 0
; filament_prime_volume = 45
; filament_prime_volume_nc = 60
; filament_printable = 3
; filament_ramming_travel_time = 0
; filament_ramming_travel_time_nc = 0
; filament_ramming_volumetric_speed = -1
; filament_ramming_volumetric_speed_nc = -1
; filament_retract_length_nc = 10
; filament_scarf_gap = 0
; filament_scarf_height = 10%
; filament_scarf_length = 10
; filament_scarf_seam_type = none
; filament_self_index = 1
; filament_settings_id = "BGD Polymaker PETG provisional"
; filament_shrink = 100%
; filament_soluble = 0
; filament_start_gcode = "; filament start gcode\n{if (bed_temperature[current_extruder] >80)||(bed_temperature_initial_layer[current_extruder] >80)}M106 P3 S255\n{elsif (bed_temperature[current_extruder] >60)||(bed_temperature_initial_layer[current_extruder] >60)}M106 P3 S180\n{endif}\n\n{if activate_air_filtration[current_extruder] && support_air_filtration}\nM106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} \n{endif}"
; filament_tower_interface_pre_extrusion_dist = 10
; filament_tower_interface_pre_extrusion_length = 0
; filament_tower_interface_print_temp = -1
; filament_tower_interface_purge_volume = 20
; filament_tower_ironing_area = 4
; filament_type = PETG
; filament_velocity_adaptation_factor = 1
; filament_vendor = Generic
; filament_volume_map = 0
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; fill_multiline = 1
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; first_x_layer_fan_speed = 0
; first_x_layer_part_fan_speed = 0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 0.3
; flush_multiplier_fast = 1.2
; flush_volumes_matrix = 0,280,280,280,280,0,280,280,280,280,0,280,280,280,280,0
; flush_volumes_vector = 140,140,140,140,140,140,140,140
; full_fan_speed_layer = 0
; fuzzy_skin = disabled_fuzzy
; fuzzy_skin_first_layer = 0
; fuzzy_skin_mode = displacement
; fuzzy_skin_noise_type = classic
; fuzzy_skin_octaves = 4
; fuzzy_skin_persistence = 0.5
; fuzzy_skin_point_distance = 0.3
; fuzzy_skin_scale = 1
; fuzzy_skin_thickness = 0.2
; gap_infill_speed = 250
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 0
; group_algo_with_time = 0
; has_filament_switcher = 0
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 
; hole_coef_1 = 0
; hole_coef_2 = -0.025
; hole_coef_3 = 0.28
; hole_limit_max = 0.25
; hole_limit_min = 0.08
; hot_plate_temp = 70
; hot_plate_temp_initial_layer = 70
; hotend_cooling_rate = 2
; hotend_heating_rate = 2
; impact_strength_z = 0
; independent_support_layer_height = 1
; infill_combination = 0
; infill_direction = 45
; infill_instead_top_bottom_surfaces = 0
; infill_jerk = 9
; infill_lock_depth = 1
; infill_rotate_step = 0
; infill_shift_step = 0.4
; infill_wall_overlap = 15%
; inherits_group = ;;
; initial_layer_acceleration = 500
; initial_layer_flow_ratio = 1
; initial_layer_infill_speed = 30
; initial_layer_jerk = 9
; initial_layer_line_width = 0.5
; initial_layer_print_height = 0.2
; initial_layer_speed = 20
; initial_layer_travel_acceleration = 6000
; inner_wall_acceleration = 0
; inner_wall_jerk = 9
; inner_wall_line_width = 0.45
; inner_wall_speed = 60
; interface_shells = 0
; interlocking_beam = 0
; interlocking_beam_layer_count = 2
; interlocking_beam_width = 0.8
; interlocking_boundary_avoidance = 2
; interlocking_depth = 2
; interlocking_orientation = 22.5
; internal_bridge_support_thickness = 0
; internal_solid_infill_line_width = 0.42
; internal_solid_infill_pattern = monotonic
; internal_solid_infill_speed = 60
; ironing_direction = 45
; ironing_fan_speed = -1
; ironing_flow = 10%
; ironing_inset = 0.21
; ironing_pattern = zig-zag
; ironing_spacing = 0.15
; ironing_speed = 30
; ironing_type = no ironing
; is_infill_first = 0
; layer_change_gcode = ; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change
; layer_height = 0.2
; line_width = 0.42
; locked_skeleton_infill_pattern = zigzag
; locked_skin_infill_pattern = crosszag
; long_retractions_when_cut = 0
; long_retractions_when_ec = 0
; machine_bed_mass_Y = 0
; machine_end_gcode = ;===== date: 20240402 =====================\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nG1 E-0.8 F1800 ; retract\nG1 Z{max_layer_z + 0.5} F900 ; lower z a little\nG1 X65 Y245 F12000 ; move to safe pos \nG1 Y265 F3000\n\nG1 X65 Y245 F12000\nG1 Y265 F3000\nM141 S0 ; turn off chamber \nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\n\nG1 X100 F12000 ; wipe\n; pull back filament to AMS\nM620 S255\nG1 X20 Y50 F12000\nG1 Y-3\nT255\nG1 X65 F12000\nG1 Y265\nG1 X100 F12000 ; wipe\nM621 S255\nM104 S0 ; turn off hotend\n\nM622.1 S1 ; for prev firmware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    M400 ; wait all motion done\n    M991 S0 P-1 ;end smooth timelapse at safe pos\n    M400 S3 ;wait for last picture to be taken\nM623; end of \"timelapse_record_flag\"\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (max_layer_z + 100.0) < 250}\n    G1 Z{max_layer_z + 100.0} F600\n    G1 Z{max_layer_z +98.0}\n{else}\n    G1 Z250 F600\n    G1 Z248\n{endif}\nM400 P100\nM17 R ; restore z current\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 0\n\nM17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power\nM960 S5 P0 ; turn off logo lamp\n\n
; machine_hotend_change_time = 0
; machine_load_filament_time = 29
; machine_max_acceleration_e = 5000,5000
; machine_max_acceleration_extruding = 20000,20000
; machine_max_acceleration_retracting = 5000,5000
; machine_max_acceleration_travel = 9000,9000
; machine_max_acceleration_x = 20000,20000
; machine_max_acceleration_y = 20000,20000
; machine_max_acceleration_z = 500,200
; machine_max_force_Y = 0
; machine_max_jerk_e = 2.5,2.5
; machine_max_jerk_x = 9,9
; machine_max_jerk_y = 9,9
; machine_max_jerk_z = 3,3
; machine_max_printed_mass = 0
; machine_max_speed_e = 30,30
; machine_max_speed_x = 500,200
; machine_max_speed_y = 500,200
; machine_max_speed_z = 20,20
; machine_min_extruding_rate = 0
; machine_min_travel_rate = 0
; machine_pause_gcode = M400 U1
; machine_prepare_compensation_time = 260
; machine_start_gcode = ;===== machine: X1E-0.4 =========================\n;===== date: 20250909 =====================\n;===== turn on the HB fan =================\nM104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle\n;===== reset machine status =================\nG91\nM17 Z0.4 ; lower the z-motor current\nG380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed\nG380 S2 Z-25 F300 ;\nG1 Z5 F300;\nG90\nM17 X1.2 Y1.2 Z0.75 ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\nM1002 set_gcode_claim_speed_level : 5\nM221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem\nG29.1 Z{+0.0} ; clear z-trim value first\nM204 S10000 ; init ACC set to 10m/s^2\n\n;==== if Chamber Cooling is necessary ====\n\n{if (filament_type[initial_no_support_extruder]==\"PLA\") || (filament_type[initial_no_support_extruder]==\"PETG\") || (filament_type[initial_no_support_extruder]==\"TPU\") || (filament_type[initial_no_support_extruder]==\"PVA\") || (filament_type[initial_no_support_extruder]==\"PLA-CF\") || (filament_type[initial_no_support_extruder]==\"PETG-CF\")}\nM1002 gcode_claim_action : 29\nG28\nG90\nG1 X60 F12000\nG1 Y245\nG1 Y265 F3000\nG1 Z75\nM140 S0 ; stop heatbed from heating\nM106 P2 S255 ; open auxiliary fan for cooling\nM106 P3 S255 ; open chamber fan for cooling\nM191 S0 ; wait for chamber temp\nM106 P3 S0 ; reset chamber fan cmd\nM106 P2 S0; reset auxiliary fan cmd\n{endif}\n\n;===== heatbed preheat ====================\nM1002 gcode_claim_action : 2\nM140 S[bed_temperature_initial_layer_single] ;set bed temp\nM190 S[bed_temperature_initial_layer_single] ;wait for bed temp\n\n{if scan_first_layer}\n;=========register first layer scan=====\nM977 S1 P60\n{endif}\n\n;=============turn on fans to prevent PLA jamming=================\n{if filament_type[initial_no_support_extruder]==\"PLA\"}\n    {if (bed_temperature[initial_no_support_extruder] >50)||(bed_temperature_initial_layer[initial_no_support_extruder] >50)}\n    M106 P3 S255\n    {elsif (bed_temperature[initial_no_support_extruder] >45)||(bed_temperature_initial_layer[initial_no_support_extruder] >45)}\n    M106 P3 S180\n    {endif};Prevent PLA from jamming\n    M142 P1 R35 S40\n{endif}\nM106 P2 S100 ; turn on big fan ,to cool down toolhead\n\n;===== prepare print temperature and material ==========\nM104 S[nozzle_temperature_initial_layer] ;set extruder temp\nG91\nG0 Z10 F1200\nG90\nG28 X\nM975 S1 ; turn on\nG1 X60 F12000\nG1 Y245\nG1 Y265 F3000\nM620 M\nM620 S[initial_no_support_extruder]A   ; switch material if AMS exist\n    M109 S[nozzle_temperature_initial_layer]\n    G1 X120 F12000\n\n    G1 X20 Y50 F12000\n    G1 Y-3\n    T[initial_no_support_extruder]\n    G1 X54 F12000\n    G1 Y265\n    M400\nM621 S[initial_no_support_extruder]A\nM620.1 E F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60} T{flush_temperatures[initial_no_support_extruder]}\n\nM412 S1 ; ===turn on filament runout detection===\n\nM109 S290 ;set nozzle to common flush temp\nM106 P1 S0\nG92 E0\nG1 E50 F200\nM400\nM104 S[nozzle_temperature_initial_layer]\nG92 E0\nG1 E50 F200\nM400\nM106 P1 S255\nG92 E0\nG1 E5 F300\nM109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20} ; drop nozzle temp, make filament shink a bit\nG92 E0\nG1 E-0.5 F300\n\nG1 X70 F9000\nG1 X76 F15000\nG1 X65 F15000\nG1 X76 F15000\nG1 X65 F15000; shake to put down garbage\nG1 X80 F6000\nG1 X95 F15000\nG1 X80 F15000\nG1 X165 F15000; wipe and shake\nM400\nM106 P1 S0\n\n;===== set chamber temperature ==========\n{if (overall_chamber_temperature >= 40)}\nM106 P2 S255 ; open big fan to help heating\nM141 S[overall_chamber_temperature] ; Let Chamber begin to heat\n{endif}\n\n;===== prepare print temperature and material end =====\n\n\n;===== wipe nozzle ===============================\nM1002 gcode_claim_action : 14\nM975 S1\nM106 S255\nG1 X65 Y230 F18000\nG1 Y264 F6000\nM109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20}\nG1 X100 F18000 ; first wipe mouth\n\nG0 X135 Y253 F20000  ; move to exposed steel surface edge\nG28 Z P0 T300; home z with low precision,permit 300deg temperature\nG29.2 S0 ; turn off ABL\nG0 Z5 F20000\n\nG1 X60 Y265\nG92 E0\nG1 E-0.5 F300 ; retrack more\nG1 X100 F5000; second wipe mouth\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X100 F5000\nG1 X70 F15000\nG1 X90 F5000\nG0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle\nM104 S140 ; set temp down to heatbed acceptable\nM106 S255 ; turn on fan (G28 has turn off fan)\n\nM221 S; push soft endstop status\nM221 Z0 ;turn off Z axis endstop\nG0 Z0.5 F20000\nG0 X125 Y259.5 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y262.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y260.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y262.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y260.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y261.5\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 Z0.5 F20000\nG0 X125 Y261.0\nG0 Z-1.01\nG0 X131 F211\nG0 X124\nG0 X128\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\nG2 I0.5 J0 F300\n\nM109 S140 ; wait nozzle temp down to heatbed acceptable\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\nG2 I0.5 J0 F3000\n\nM221 R; pop softend status\nG1 Z10 F1200\nM400\nG1 Z10\nG1 F30000\nG1 X128 Y128\nG29.2 S1 ; turn on ABL\n;G28 ; home again after hard wipe mouth\nM106 S0 ; turn off fan , too noisy\n;===== wipe nozzle end ================================\n\n;===== check scanner clarity ===========================\nG1 X128 Y128 F24000\nG28 Z P0\nM972 S5 P0\nG1 X230 Y15 F24000\n;===== check scanner clarity end =======================\n\n;===== bed leveling ==================================\nM1002 judge_flag g29_before_print_flag\nM622 J1\n\n    M1002 gcode_claim_action : 1\n    G29 A X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    M400\n    M500 ; save cali data\n\nM623\n;===== bed leveling end ================================\n\n;===== home after wipe mouth============================\nM1002 judge_flag g29_before_print_flag\nM622 J0\n\n    M1002 gcode_claim_action : 13\n    G28\n\nM623\n;===== home after wipe mouth end =======================\n\nM975 S1 ; turn on vibration supression\n\n;=============turn on fans to prevent PLA jamming=================\n{if filament_type[initial_no_support_extruder]==\"PLA\"}\n    {if (bed_temperature[initial_no_support_extruder] >50)||(bed_temperature_initial_layer[initial_no_support_extruder] >50)}\n    M106 P3 S255\n    {elsif (bed_temperature[initial_no_support_extruder] >45)||(bed_temperature_initial_layer[initial_no_support_extruder] >45)}\n    M106 P3 S180\n    {endif};Prevent PLA from jamming\n    M142 P1 R35 S40\n{endif}\nM106 P2 S100 ; turn on big fan ,to cool down toolhead\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]} ; set extrude temp earlier, to reduce wait time\n\n;===== mech mode fast check============================\nG1 X128 Y128 Z10 F20000\nM400 P200\nM970.3 Q1 A7 B30 C80  H15 K0\nM974 Q1 S2 P0\n\nG1 X128 Y128 Z10 F20000\nM400 P200\nM970.3 Q0 A7 B30 C90 Q0 H15 K0\nM974 Q0 S2 P0\n\nM975 S1\nG1 F30000\nG1 X230 Y15\nG28 X ; re-home XY\n;===== mech mode fast check============================\n\n{if scan_first_layer}\n;start heatbed  scan====================================\nM976 S2 P1\nG90\nG1 X128 Y128 F20000\nM976 S3 P2  ;register void printing detection\n{endif}\n\n;===== noozle load line ===============================\nM975 S1\nG90\nM83\nT1000\nG1 X18.0 Y1.0 Z0.8 F18000;Move to start position\nM109 S{nozzle_temperature[initial_no_support_extruder]}\nG1 Z0.2\nG0 E2 F300\nG0 X240 E15 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nG0 Y11 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\nG0 X239.5\nG0 E0.2\nG0 Y1.5 E0.700\nG0 X231 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nM400\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n;curr_bed_type={curr_bed_type}\n{if curr_bed_type==\"Textured PEI Plate\"}\nG29.1 Z{-0.04} ; for Textured PEI Plate\n{endif}\n\n;===== draw extrinsic para cali paint =================\nM1002 judge_flag extrude_cali_flag\nM622 J1\n\n    M1002 gcode_claim_action : 8\n\n    T1000\n\n    G0 F1200.0 X231 Y12   Z0.2 E0.577\n    G0 F1200.0 X226 Y12   Z0.2 E0.275\n    G0 F1200.0 X226 Y1.5  Z0.2 E0.577\n    G0 F1200.0 X220 Y1.5  Z0.2 E0.330\n    G0 F1200.0 X220 Y8    Z0.2 E0.358\n    G0 F1200.0 X210 Y8    Z0.2 E0.549\n    G0 F1200.0 X210 Y1.5  Z0.2 E0.357\n\n    G0 X48.0 E11.9 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\n    G0 X48.0 Y12 E0.772 F1200.0\n    G0 X45.0 E0.22 F1200.0\n    G0 X35.0 Y6.0 E0.86 F1200.0\n\n    ;=========== extruder cali extrusion ==================\n    T1000\n    M83\n    {if default_acceleration > 0}\n        {if outer_wall_acceleration > 0}\n            M204 S[outer_wall_acceleration]\n        {else}\n            M204 S[default_acceleration]\n        {endif}\n    {endif}\n    G0 X35.000 Y6.000 Z0.300 F30000 E0\n    G1 F1500.000 E0.800\n    M106 S0 ; turn off fan\n    G0 X185.000 E9.35441 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G0 X187 Z0\n    G1 F1500.000 E-0.800\n    G0 Z1\n    G0 X180 Z0.3 F18000\n\n    M900 L1000.0 M1.0\n    M900 K0.040\n    G0 X45.000 F30000\n    G0 Y8.000 F30000\n    G1 F1500.000 E0.800\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 F1500.000 E-0.800\n    G1 X183 Z0.15 F30000\n    G1 X185\n    G1 Z1.0\n    G0 Y6.000 F30000 ; move y to clear pos\n    G1 Z0.3\n    M400\n\n    G0 X45.000 F30000\n    M900 K0.020\n    G0 X45.000 F30000\n    G0 Y10.000 F30000\n    G1 F1500.000 E0.800\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 F1500.000 E-0.800\n    G1 X183 Z0.15 F30000\n    G1 X185\n    G1 Z1.0\n    G0 Y6.000 F30000 ; move y to clear pos\n    G1 Z0.3\n    M400\n\n    G0 X45.000 F30000\n    M900 K0.000\n    G0 X45.000 F30000\n    G0 Y12.000 F30000\n    G1 F1500.000 E0.800\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 F1500.000 E-0.800\n    G1 X183 Z0.15 F30000\n    G1 X185\n    G1 Z1.0\n    G0 Y6.000 F30000 ; move y to clear pos\n    G1 Z0.3\n\n    G0 X45.000 F30000 ; move to start point\n\nM623 ; end of \"draw extrinsic para cali paint\"\n\n\nM1002 judge_flag extrude_cali_flag\nM622 J0\n    G0 X231 Y1.5 F30000\n    G0 X18 E14.3 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}\nM623\n\nM104 S140\n\n\n;=========== laser and rgb calibration ===========\nM400\nM18 E\nM500 R\n\nM973 S3 P14\n\nG1 X120 Y1.0 Z0.3 F18000.0;Move to first extrude line pos\nT1100\nG1 X235.0 Y1.0 Z0.3 F18000.0;Move to first extrude line pos\nM400 P100\nM960 S1 P1\nM400 P100\nM973 S6 P0; use auto exposure for horizontal laser by xcam\nM960 S0 P0\n\nG1 X240.0 Y6.0 Z0.3 F18000.0;Move to vertical extrude line pos\nM960 S2 P1\nM400 P100\nM973 S6 P1; use auto exposure for vertical laser by xcam\nM960 S0 P0\n\n;=========== handeye calibration ======================\nM1002 judge_flag extrude_cali_flag\nM622 J1\n\n    M973 S3 P1 ; camera start stream\n    M400 P500\n    M973 S1\n    G0 F6000 X228.500 Y4.750 Z0.000\n    M960 S0 P1\n    M973 S1\n    M400 P800\n    M971 S6 P0\n    M973 S2 P0\n    M400 P500\n    G0 Z0.000 F12000\n    M960 S0 P0\n    M960 S1 P1\n    G0 X215.00 Y4.750\n    M400 P200\n    M971 S5 P1\n    M973 S2 P1\n    M400 P500\n    M960 S0 P0\n    M960 S2 P1\n    G0 X228.5 Y6.75\n    M400 P200\n    M971 S5 P3\n    G0 Z0.500 F12000\n    M960 S0 P0\n    M960 S2 P1\n    G0 X228.5 Y6.75\n    M400 P200\n    M971 S5 P4\n    M973 S2 P0\n    M400 P500\n    M960 S0 P0\n    M960 S1 P1\n    G0 X215.00 Y4.750\n    M400 P500\n    M971 S5 P2\n    M963 S1\n    M400 P1500\n    M964\n    T1100\n    G1 Z3 F3000\n\n    M400\n    M500 ; save cali data\n\n    M104 S{nozzle_temperature[initial_no_support_extruder]} ; rise nozzle temp now ,to reduce temp waiting time.\n\n    T1100\n    M400 P400\n    M960 S0 P0\n    G0 F30000.000 Y10.000 X65.000 Z0.000\n    M400 P400\n    M960 S1 P1\n    M400 P50\n\n    M969 S1 N3 A2000\n    G0 F360.000 X181.000 Z0.000\n    M980.3 A70.000 B{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*60/4} C5.000 D{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*60} E5.000 F175.000 H1.000 I0.000 J0.020 K0.040\n    M400 P100\n    G0 F20000\n    G0 Z1 ; rise nozzle up\n    T1000 ; change to nozzle space\n    G0 X45.000 Y4.000 F30000 ; move to test line pos\n    M969 S0 ; turn off scanning\n    M960 S0 P0\n\n\n    G1 Z2 F20000\n    T1000\n    G0 X45.000 Y4.000 F30000 E0\n    M109 S{nozzle_temperature[initial_no_support_extruder]}\n    G0 Z0.3\n    G1 F1500.000 E3.600\n    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n\n    ; see if extrude cali success, if not ,use default value\n    M1002 judge_last_extrude_cali_success\n    M622 J0\n        M400\n        M900 K0.02 M{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*0.02}\n    M623\n\n    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X185.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X190.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X195.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X200.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X205.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X210.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X215.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    G1 X220.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}\n    G1 X225.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\n    M973 S4\n\nM623\n\n;===== wait chamber temperature reaching the reference value =======\n{if (overall_chamber_temperature >= 40)}\nM104 S140\nM191 S[overall_chamber_temperature] ; wait for chamber temp\nM106 P2 S0 ; reset chamber fan cmd\nM109 S{nozzle_temperature[initial_no_support_extruder]}\n{endif}\n\n;========turn off light and wait extrude temperature =============\nM1002 gcode_claim_action : 0\nM973 S4 ; turn off scanner\nM400 ; wait all motion done before implement the emprical L parameters\n;M900 L500.0 ; Empirical parameters\nM109 S[nozzle_temperature_initial_layer]\nM960 S1 P0 ; turn off laser\nM960 S2 P0 ; turn off laser\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off big fan\nM106 P3 S0 ; turn off chamber fan\n\nM975 S1 ; turn on mech mode supression\nG90\nM83\nT1000\n;===== purge line to wipe the nozzle ============================\nG1 E{-retraction_length[initial_no_support_extruder]} F1800\nG1 X18.0 Y2.5 Z0.8 F18000.0;Move to start position\nG1 E{retraction_length[initial_no_support_extruder]} F1800\nM109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\nG1 Z0.2\nG0 X239 E15 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}\nG0 Y12 E0.7 F{outer_wall_volumetric_speed/(0.3*0.5)/4* 60}\n
; machine_switch_extruder_time = 5
; machine_unload_filament_time = 28
; master_extruder_id = 1
; max_bridge_length = 0
; max_layer_height = 0.28
; max_travel_detour_distance = 0
; min_bead_width = 85%
; min_feature_size = 25%
; min_layer_height = 0.08
; minimum_sparse_infill_area = 15
; mmu_segmented_region_interlocking_depth = 0
; mmu_segmented_region_max_width = 0
; monotonic_travel_into_wall = 0%
; no_slow_down_for_cooling_on_outwalls = 0
; nozzle_diameter = 0.4
; nozzle_flush_dataset = 0
; nozzle_height = 4.2
; nozzle_temperature = 250
; nozzle_temperature_initial_layer = 250
; nozzle_temperature_range_high = 270
; nozzle_temperature_range_low = 220
; nozzle_type = hardened_steel
; nozzle_volume = 107
; nozzle_volume_type = Standard
; only_one_wall_first_layer = 0
; ooze_prevention = 0
; other_layers_print_sequence = 0
; other_layers_print_sequence_nums = 0
; outer_wall_acceleration = 5000
; outer_wall_jerk = 9
; outer_wall_line_width = 0.42
; outer_wall_speed = 40
; overhang_1_4_speed = 0
; overhang_2_4_speed = 50
; overhang_3_4_speed = 30
; overhang_4_4_speed = 10
; overhang_fan_speed = 60
; overhang_fan_threshold = 10%
; overhang_threshold_participating_cooling = 95%
; overhang_totally_speed = 10
; override_filament_scarf_seam_setting = 0
; override_process_overhang_speed = 0
; physical_extruder_map = 0
; post_process = 
; pre_start_fan_time = 0
; precise_outer_wall = 1
; precise_z_height = 0
; pressure_advance = 0.02
; prime_tower_brim_width = 3
; prime_tower_enable_framework = 0
; prime_tower_extra_rib_length = 0
; prime_tower_fillet_wall = 1
; prime_tower_flat_ironing = 0
; prime_tower_infill_gap = 150%
; prime_tower_lift_height = -1
; prime_tower_lift_speed = 90
; prime_tower_max_speed = 90
; prime_tower_rib_wall = 1
; prime_tower_rib_width = 8
; prime_tower_skip_points = 1
; prime_tower_width = 35
; prime_volume_mode = Default
; print_compatible_printers = "Bambu Lab X1 Carbon 0.4 nozzle";"Bambu Lab X1 0.4 nozzle";"Bambu Lab P1S 0.4 nozzle";"Bambu Lab X1E 0.4 nozzle"
; print_extruder_id = 1
; print_extruder_variant = "Direct Drive Standard"
; print_flow_ratio = 1
; print_in_clockwise = 0
; print_sequence = by layer
; print_settings_id = BGD PETG fit prototype 0.20
; printable_area = 0x0,256x0,256x256,0x256
; printable_height = 250
; printer_extruder_id = 1
; printer_extruder_variant = "Direct Drive Standard"
; printer_model = Bambu Lab X1E
; printer_notes = 
; printer_settings_id = Bambu Lab X1E 0.4 nozzle
; printer_structure = corexy
; printer_technology = FFF
; printer_variant = 0.4
; printing_by_object_gcode = 
; process_notes = 
; raft_contact_distance = 0.1
; raft_expansion = 1.5
; raft_first_layer_density = 90%
; raft_first_layer_expansion = 2
; raft_layers = 0
; reduce_crossing_wall = 0
; reduce_fan_stop_start_freq = 1
; reduce_infill_retraction_mode = Auto
; required_nozzle_HRC = 3
; resolution = 0.012
; retract_before_wipe = 0%
; retract_length_toolchange = 2
; retract_lift_above = 0
; retract_lift_below = 249
; retract_restart_extra = 0
; retract_restart_extra_toolchange = 0
; retract_when_changing_layer = 1
; retraction_distances_when_cut = 18
; retraction_distances_when_ec = 0
; retraction_length = 0.8
; retraction_minimum_travel = 1
; retraction_speed = 30
; role_base_wipe_speed = 1
; scan_first_layer = 1
; scarf_angle_threshold = 155
; seam_gap = 10%
; seam_placement_away_from_overhangs = 0
; seam_position = aligned
; seam_slope_conditional = 0
; seam_slope_entire_loop = 0
; seam_slope_gap = 0
; seam_slope_inner_walls = 0
; seam_slope_min_length = 10
; seam_slope_start_height = 10%
; seam_slope_steps = 10
; seam_slope_type = none
; silent_mode = 0
; single_extruder_multi_material = 1
; skeleton_infill_density = 15%
; skeleton_infill_line_width = 0.45
; skin_infill_density = 15%
; skin_infill_depth = 2
; skin_infill_line_width = 0.45
; skirt_distance = 2
; skirt_height = 1
; skirt_loops = 0
; skirt_per_object = 0
; slice_closing_radius = 0.049
; slicing_mode = regular
; slow_down_for_layer_cooling = 1
; slow_down_layer_time = 12
; slow_down_min_speed = 20
; slowdown_end_acc = 100000
; slowdown_end_height = 400
; slowdown_end_speed = 1000
; slowdown_start_acc = 100000
; slowdown_start_height = 0
; slowdown_start_speed = 1000
; small_perimeter_speed = 50%
; small_perimeter_threshold = 0
; smooth_coefficient = 80
; smooth_speed_discontinuity_area = 1
; solid_infill_filament = 0
; sparse_infill_acceleration = 100%
; sparse_infill_anchor = 400%
; sparse_infill_anchor_max = 20
; sparse_infill_density = 30%
; sparse_infill_filament = 0
; sparse_infill_lattice_angle_1 = -45
; sparse_infill_lattice_angle_2 = 45
; sparse_infill_line_width = 0.45
; sparse_infill_pattern = gyroid
; sparse_infill_speed = 70
; spiral_mode = 0
; spiral_mode_max_xy_smoothing = 200%
; spiral_mode_smooth = 0
; standby_temperature_delta = -5
; start_end_points = 30x-3,54x245
; supertack_plate_temp = 70
; supertack_plate_temp_initial_layer = 70
; support_air_filtration = 1
; support_angle = 0
; support_base_pattern = default
; support_base_pattern_spacing = 2.5
; support_bottom_interface_spacing = 0.5
; support_bottom_z_distance = 0.2
; support_chamber_temp_control = 1
; support_cooling_filter = 0
; support_critical_regions_only = 0
; support_expansion = 0
; support_fast_purge_mode = 0
; support_filament = 0
; support_interface_bottom_layers = 2
; support_interface_filament = 0
; support_interface_loop_pattern = 0
; support_interface_not_for_body = 1
; support_interface_pattern = auto
; support_interface_spacing = 0.5
; support_interface_speed = 30
; support_interface_top_layers = 2
; support_ironing_direction = 0
; support_ironing_flow = 10%
; support_ironing_inset = 0
; support_ironing_pattern = zig-zag
; support_ironing_spacing = 0.1
; support_ironing_speed = 20
; support_line_width = 0.42
; support_object_first_layer_gap = 0.2
; support_object_skip_flush = 0
; support_object_xy_distance = 0.4
; support_on_build_plate_only = 0
; support_remove_small_overhang = 1
; support_speed = 50
; support_style = grid
; support_threshold_angle = 30
; support_top_z_distance = 0.2
; support_type = normal(auto)
; symmetric_infill_y_axis = 0
; temperature_vitrification = 70
; template_custom_gcode = 
; textured_plate_temp = 65
; textured_plate_temp_initial_layer = 65
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;========Date 20250206========\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firmware, default turned on\nM1002 judge_flag timelapse_record_flag\nM622 J1\n{if timelapse_type == 0} ; timelapse without wipe tower\nM971 S11 C10 O0\nM1004 S5 P1  ; external shutter\n{elsif timelapse_type == 1} ; timelapse with wipe tower\nG92 E0\nG1 X65 Y245 F20000 ; move to safe pos\nG17\nG2 Z{layer_z} I0.86 J0.86 P1 F20000\nG1 Y265 F3000\nM400\nM1004 S5 P1  ; external shutter\nM400 P300\nM971 S11 C10 O0\nG92 E0\nG1 X100 F5000\nG1 Y255 F20000\n{endif}\nM623\n; SKIPPABLE_END
; timelapse_type = 0
; top_area_threshold = 200%
; top_color_penetration_layers = 4
; top_one_wall_type = all top
; top_shell_layers = 5
; top_shell_thickness = 1
; top_solid_infill_flow_ratio = 1
; top_surface_acceleration = 2000
; top_surface_density = 100%
; top_surface_jerk = 9
; top_surface_line_width = 0.42
; top_surface_pattern = monotonicline
; top_surface_speed = 40
; top_z_overrides_xy_distance = 0
; travel_acceleration = 10000
; travel_jerk = 12
; travel_short_distance_acceleration = 250
; travel_speed = 500
; travel_speed_z = 0
; tree_support_branch_angle = 45
; tree_support_branch_diameter = 2
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = 0
; upward_compatible_machine = "Bambu Lab P1S 0.4 nozzle";"Bambu Lab P1P 0.4 nozzle";"Bambu Lab X1 0.4 nozzle";"Bambu Lab X1 Carbon 0.4 nozzle";"Bambu Lab A1 0.4 nozzle";"Bambu Lab H2D 0.4 nozzle";"Bambu Lab H2D Pro 0.4 nozzle";"Bambu Lab H2S 0.4 nozzle";"Bambu Lab P2S 0.4 nozzle"
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; vertical_shell_speed = 80%
; volumetric_speed_coefficients = "0 0 0 0 0 0"
; wall_distribution_count = 1
; wall_filament = 0
; wall_generator = classic
; wall_loops = 4
; wall_sequence = inner wall/outer wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 1
; wipe_distance = 2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 15
; wipe_tower_y = 220
; wrapping_detection_gcode = 
; wrapping_detection_layers = 20
; wrapping_exclude_area = 
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_direction_outwall_speed_continuous = 0
; z_hop = 0.4
; z_hop_types = Auto Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START
M73 P0 R28
M201 X20000 Y20000 Z500 E5000
M203 X500 Y500 Z20 E30
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: X1E-0.4 =========================
;===== date: 20250909 =====================
;===== turn on the HB fan =================
M104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle
;===== reset machine status =================
G91
M17 Z0.4 ; lower the z-motor current
G380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed
G380 S2 Z-25 F300 ;
G1 Z5 F300;
G90
M17 X1.2 Y1.2 Z0.75 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 5
M221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem
G29.1 Z0 ; clear z-trim value first
M204 S10000 ; init ACC set to 10m/s^2

;==== if Chamber Cooling is necessary ====


M1002 gcode_claim_action : 29
G28
G90
G1 X60 F12000
G1 Y245
G1 Y265 F3000
G1 Z75
M140 S0 ; stop heatbed from heating
M106 P2 S255 ; open auxiliary fan for cooling
M106 P3 S255 ; open chamber fan for cooling
M191 S0 ; wait for chamber temp
M106 P3 S0 ; reset chamber fan cmd
M106 P2 S0; reset auxiliary fan cmd


;===== heatbed preheat ====================
M1002 gcode_claim_action : 2
M140 S65 ;set bed temp
M190 S65 ;wait for bed temp


;=========register first layer scan=====
M977 S1 P60


;=============turn on fans to prevent PLA jamming=================

M106 P2 S100 ; turn on big fan ,to cool down toolhead

;===== prepare print temperature and material ==========
M104 S250 ;set extruder temp
G91
G0 Z10 F1200
G90
G28 X
M975 S1 ; turn on
G1 X60 F12000
G1 Y245
G1 Y265 F3000
M620 M
M620 S0A   ; switch material if AMS exist
    M109 S250
    G1 X120 F12000

    G1 X20 Y50 F12000
    G1 Y-3
    T0
    G1 X54 F12000
    G1 Y265
    M400
M621 S0A
M620.1 E F199.559 T270

M412 S1 ; ===turn on filament runout detection===

M109 S290 ;set nozzle to common flush temp
M106 P1 S0
G92 E0
G1 E50 F200
M400
M104 S250
G92 E0
M73 P2 R27
G1 E50 F200
M400
M106 P1 S255
G92 E0
M73 P17 R23
G1 E5 F300
M109 S230 ; drop nozzle temp, make filament shink a bit
G92 E0
G1 E-0.5 F300

M73 P18 R23
G1 X70 F9000
M73 P19 R23
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
G1 X165 F15000; wipe and shake
M400
M106 P1 S0

;===== set chamber temperature ==========


;===== prepare print temperature and material end =====


;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14
M975 S1
M106 S255
G1 X65 Y230 F18000
G1 Y264 F6000
M109 S230
G1 X100 F18000 ; first wipe mouth

G0 X135 Y253 F20000  ; move to exposed steel surface edge
G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
G0 Z5 F20000

G1 X60 Y265
G92 E0
G1 E-0.5 F300 ; retrack more
M73 P19 R22
G1 X100 F5000; second wipe mouth
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X90 F5000
G0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle
M104 S140 ; set temp down to heatbed acceptable
M106 S255 ; turn on fan (G28 has turn off fan)

M221 S; push soft endstop status
M221 Z0 ;turn off Z axis endstop
G0 Z0.5 F20000
G0 X125 Y259.5 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 X128
M73 P20 R22
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300

M109 S140 ; wait nozzle temp down to heatbed acceptable
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000

M221 R; pop softend status
G1 Z10 F1200
M400
G1 Z10
G1 F30000
G1 X128 Y128
G29.2 S1 ; turn on ABL
;G28 ; home again after hard wipe mouth
M106 S0 ; turn off fan , too noisy
;===== wipe nozzle end ================================

;===== check scanner clarity ===========================
G1 X128 Y128 F24000
G28 Z P0
M972 S5 P0
G1 X230 Y15 F24000
;===== check scanner clarity end =======================

;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag
M622 J1

    M1002 gcode_claim_action : 1
    G29 A X99.0576 Y106.058 I57.8848 J43.8848
    M400
    M500 ; save cali data

M623
;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623
;===== home after wipe mouth end =======================

M975 S1 ; turn on vibration supression

;=============turn on fans to prevent PLA jamming=================

M106 P2 S100 ; turn on big fan ,to cool down toolhead

M104 S250 ; set extrude temp earlier, to reduce wait time

;===== mech mode fast check============================
G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q1 A7 B30 C80  H15 K0
M974 Q1 S2 P0

G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q0 A7 B30 C90 Q0 H15 K0
M974 Q0 S2 P0

M975 S1
G1 F30000
G1 X230 Y15
G28 X ; re-home XY
;===== mech mode fast check============================


;start heatbed  scan====================================
M976 S2 P1
G90
G1 X128 Y128 F20000
M976 S3 P2  ;register void printing detection


;===== noozle load line ===============================
M975 S1
G90
M83
T1000
G1 X18.0 Y1.0 Z0.8 F18000;Move to start position
M109 S250
G1 Z0.2
G0 E2 F300
G0 X240 E15 F1206.65
G0 Y11 E0.700 F301.664
G0 X239.5
G0 E0.2
G0 Y1.5 E0.700
G0 X231 E0.700 F1206.65
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type=Textured PEI Plate

G29.1 Z-0.04 ; for Textured PEI Plate


;===== draw extrinsic para cali paint =================
M1002 judge_flag extrude_cali_flag
M622 J1

    M1002 gcode_claim_action : 8

    T1000

    G0 F1200.0 X231 Y12   Z0.2 E0.577
    G0 F1200.0 X226 Y12   Z0.2 E0.275
    G0 F1200.0 X226 Y1.5  Z0.2 E0.577
    G0 F1200.0 X220 Y1.5  Z0.2 E0.330
    G0 F1200.0 X220 Y8    Z0.2 E0.358
    G0 F1200.0 X210 Y8    Z0.2 E0.549
    G0 F1200.0 X210 Y1.5  Z0.2 E0.357

    G0 X48.0 E11.9 F1206.65
    G0 X48.0 Y12 E0.772 F1200.0
    G0 X45.0 E0.22 F1200.0
    G0 X35.0 Y6.0 E0.86 F1200.0

    ;=========== extruder cali extrusion ==================
    T1000
    M83
    
        
            M204 S5000
        
    
    G0 X35.000 Y6.000 Z0.300 F30000 E0
    G1 F1500.000 E0.800
    M106 S0 ; turn off fan
    G0 X185.000 E9.35441 F1206.65
    G0 X187 Z0
    G1 F1500.000 E-0.800
    G0 Z1
    G0 X180 Z0.3 F18000

    M900 L1000.0 M1.0
    M900 K0.040
    G0 X45.000 F30000
    G0 Y8.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F301.664
    G1 X70.000 E0.31181 F301.664
M73 P21 R22
    G1 X75.000 E0.31181 F1206.65
    G1 X80.000 E0.31181 F301.664
    G1 X85.000 E0.31181 F1206.65
    G1 X90.000 E0.31181 F301.664
    G1 X95.000 E0.31181 F1206.65
    G1 X100.000 E0.31181 F301.664
    G1 X105.000 E0.31181 F1206.65
    G1 X110.000 E0.31181 F301.664
    G1 X115.000 E0.31181 F1206.65
    G1 X120.000 E0.31181 F301.664
    G1 X125.000 E0.31181 F1206.65
    G1 X130.000 E0.31181 F301.664
    G1 X135.000 E0.31181 F1206.65
    G1 X140.000 E0.31181 F301.664
    G1 X145.000 E0.31181 F1206.65
    G1 X150.000 E0.31181 F301.664
    G1 X155.000 E0.31181 F1206.65
    G1 X160.000 E0.31181 F301.664
    G1 X165.000 E0.31181 F1206.65
    G1 X170.000 E0.31181 F301.664
    G1 X175.000 E0.31181 F1206.65
    G1 X180.000 E0.31181 F1206.65
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3
    M400

    G0 X45.000 F30000
    M900 K0.020
    G0 X45.000 F30000
    G0 Y10.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F301.664
    G1 X70.000 E0.31181 F301.664
M73 P22 R22
    G1 X75.000 E0.31181 F1206.65
    G1 X80.000 E0.31181 F301.664
    G1 X85.000 E0.31181 F1206.65
    G1 X90.000 E0.31181 F301.664
    G1 X95.000 E0.31181 F1206.65
    G1 X100.000 E0.31181 F301.664
    G1 X105.000 E0.31181 F1206.65
    G1 X110.000 E0.31181 F301.664
    G1 X115.000 E0.31181 F1206.65
    G1 X120.000 E0.31181 F301.664
    G1 X125.000 E0.31181 F1206.65
    G1 X130.000 E0.31181 F301.664
    G1 X135.000 E0.31181 F1206.65
M73 P23 R22
    G1 X140.000 E0.31181 F301.664
    G1 X145.000 E0.31181 F1206.65
    G1 X150.000 E0.31181 F301.664
M73 P23 R21
    G1 X155.000 E0.31181 F1206.65
    G1 X160.000 E0.31181 F301.664
    G1 X165.000 E0.31181 F1206.65
    G1 X170.000 E0.31181 F301.664
    G1 X175.000 E0.31181 F1206.65
    G1 X180.000 E0.31181 F1206.65
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3
    M400

    G0 X45.000 F30000
    M900 K0.000
    G0 X45.000 F30000
    G0 Y12.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F301.664
    G1 X70.000 E0.31181 F301.664
    G1 X75.000 E0.31181 F1206.65
M73 P24 R21
    G1 X80.000 E0.31181 F301.664
    G1 X85.000 E0.31181 F1206.65
    G1 X90.000 E0.31181 F301.664
    G1 X95.000 E0.31181 F1206.65
    G1 X100.000 E0.31181 F301.664
    G1 X105.000 E0.31181 F1206.65
    G1 X110.000 E0.31181 F301.664
    G1 X115.000 E0.31181 F1206.65
    G1 X120.000 E0.31181 F301.664
    G1 X125.000 E0.31181 F1206.65
    G1 X130.000 E0.31181 F301.664
    G1 X135.000 E0.31181 F1206.65
    G1 X140.000 E0.31181 F301.664
    G1 X145.000 E0.31181 F1206.65
    G1 X150.000 E0.31181 F301.664
    G1 X155.000 E0.31181 F1206.65
    G1 X160.000 E0.31181 F301.664
    G1 X165.000 E0.31181 F1206.65
    G1 X170.000 E0.31181 F301.664
M73 P25 R21
    G1 X175.000 E0.31181 F1206.65
    G1 X180.000 E0.31181 F1206.65
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3

    G0 X45.000 F30000 ; move to start point

M623 ; end of "draw extrinsic para cali paint"


M1002 judge_flag extrude_cali_flag
M622 J0
    G0 X231 Y1.5 F30000
    G0 X18 E14.3 F1206.65
M623

M104 S140


;=========== laser and rgb calibration ===========
M400
M18 E
M500 R

M973 S3 P14

G1 X120 Y1.0 Z0.3 F18000.0;Move to first extrude line pos
T1100
G1 X235.0 Y1.0 Z0.3 F18000.0;Move to first extrude line pos
M400 P100
M960 S1 P1
M400 P100
M973 S6 P0; use auto exposure for horizontal laser by xcam
M960 S0 P0

G1 X240.0 Y6.0 Z0.3 F18000.0;Move to vertical extrude line pos
M960 S2 P1
M400 P100
M973 S6 P1; use auto exposure for vertical laser by xcam
M960 S0 P0

;=========== handeye calibration ======================
M1002 judge_flag extrude_cali_flag
M622 J1

    M973 S3 P1 ; camera start stream
    M400 P500
    M973 S1
    G0 F6000 X228.500 Y4.750 Z0.000
    M960 S0 P1
    M973 S1
    M400 P800
    M971 S6 P0
    M973 S2 P0
    M400 P500
    G0 Z0.000 F12000
    M960 S0 P0
    M960 S1 P1
    G0 X215.00 Y4.750
    M400 P200
    M971 S5 P1
    M973 S2 P1
    M400 P500
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y6.75
    M400 P200
    M971 S5 P3
    G0 Z0.500 F12000
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y6.75
    M400 P200
    M971 S5 P4
    M973 S2 P0
    M400 P500
    M960 S0 P0
    M960 S1 P1
    G0 X215.00 Y4.750
    M400 P500
    M971 S5 P2
    M963 S1
    M400 P1500
    M964
    T1100
    G1 Z3 F3000

    M400
    M500 ; save cali data

    M104 S250 ; rise nozzle temp now ,to reduce temp waiting time.

    T1100
    M400 P400
    M960 S0 P0
    G0 F30000.000 Y10.000 X65.000 Z0.000
    M400 P400
    M960 S1 P1
    M400 P50

    M969 S1 N3 A2000
    G0 F360.000 X181.000 Z0.000
    M980.3 A70.000 B18.8221 C5.000 D75.2885 E5.000 F175.000 H1.000 I0.000 J0.020 K0.040
    M400 P100
    G0 F20000
    G0 Z1 ; rise nozzle up
    T1000 ; change to nozzle space
    G0 X45.000 Y4.000 F30000 ; move to test line pos
    M969 S0 ; turn off scanning
    M960 S0 P0


    G1 Z2 F20000
    T1000
    G0 X45.000 Y4.000 F30000 E0
    M109 S250
    G0 Z0.3
    G1 F1500.000 E3.600
    G1 X65.000 E1.24726 F301.664
    G1 X70.000 E0.31181 F301.664
    G1 X75.000 E0.31181 F1206.65
    G1 X80.000 E0.31181 F301.664
    G1 X85.000 E0.31181 F1206.65
    G1 X90.000 E0.31181 F301.664
    G1 X95.000 E0.31181 F1206.65
    G1 X100.000 E0.31181 F301.664
    G1 X105.000 E0.31181 F1206.65
    G1 X110.000 E0.31181 F301.664
    G1 X115.000 E0.31181 F1206.65
    G1 X120.000 E0.31181 F301.664
    G1 X125.000 E0.31181 F1206.65
    G1 X130.000 E0.31181 F301.664
    G1 X135.000 E0.31181 F1206.65

    ; see if extrude cali success, if not ,use default value
    M1002 judge_last_extrude_cali_success
    M622 J0
        M400
        M900 K0.02 M0.0250962
    M623

    G1 X140.000 E0.31181 F301.664
    G1 X145.000 E0.31181 F1206.65
    G1 X150.000 E0.31181 F301.664
    G1 X155.000 E0.31181 F1206.65
M73 P26 R21
    G1 X160.000 E0.31181 F301.664
    G1 X165.000 E0.31181 F1206.65
    G1 X170.000 E0.31181 F301.664
    G1 X175.000 E0.31181 F1206.65
    G1 X180.000 E0.31181 F301.664
    G1 X185.000 E0.31181 F1206.65
    G1 X190.000 E0.31181 F301.664
    G1 X195.000 E0.31181 F1206.65
    G1 X200.000 E0.31181 F301.664
    G1 X205.000 E0.31181 F1206.65
    G1 X210.000 E0.31181 F301.664
    G1 X215.000 E0.31181 F1206.65
    G1 X220.000 E0.31181 F301.664
    G1 X225.000 E0.31181 F1206.65
    M973 S4

M623

;===== wait chamber temperature reaching the reference value =======


;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M973 S4 ; turn off scanner
M400 ; wait all motion done before implement the emprical L parameters
;M900 L500.0 ; Empirical parameters
M109 S250
M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000
;===== purge line to wipe the nozzle ============================
G1 E-0.8 F1800
G1 X18.0 Y2.5 Z0.8 F18000.0;Move to start position
G1 E0.8 F1800
M109 S250
G1 Z0.2
G0 X239 E15 F1206.65
G0 Y12 E0.7 F301.664
; MACHINE_START_GCODE_END
; filament start gcode
M106 P3 S180


;VT0 H-1
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.8 F1800
; layer num/total_layer_count: 1/27
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
M204 S6000
G1 Z.4 F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X99.989 Y105.18
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
; LINE_WIDTH: 0.5
G1 F1200
M204 S500
G1 X100.342 Y104.858 E.01726
M73 P26 R20
G1 X100.942 Y104.52 E.02487
G1 X101.403 Y104.359 E.0176
G1 X102.014 Y104.286 E.02222
G1 X133.989 Y104.286 E1.15451
G1 X134.476 Y104.333 E.01767
G1 X135.002 Y104.491 E.01981
G1 X135.436 Y104.702 E.01744
M73 P27 R20
G1 X135.82 Y104.989 E.01731
G1 X136.023 Y105.211 E.01087
G1 X136.192 Y105.286 E.00668
G1 X153.989 Y105.286 E.64259
G1 X154.476 Y105.333 E.01767
G1 X155.002 Y105.491 E.01981
G1 X155.436 Y105.702 E.01744
G1 X155.82 Y105.989 E.01731
G1 X156.142 Y106.342 E.01726
G1 X156.416 Y106.804 E.0194
G1 X156.641 Y107.405 E.02316
G1 X156.714 Y108.014 E.02213
G1 X156.714 Y143.989 E1.29892
G1 X156.667 Y144.476 E.01768
G1 X156.509 Y145.002 E.01981
G1 X156.298 Y145.436 E.01744
G1 X156.011 Y145.82 E.01731
G1 X155.658 Y146.142 E.01726
G1 X155.058 Y146.48 E.02487
G1 X154.597 Y146.641 E.0176
G1 X153.986 Y146.714 E.02223
G1 X136.205 Y146.714 E.64199
G1 X136.049 Y146.775 E.00605
G1 X135.656 Y147.143 E.01942
G1 X135.058 Y147.48 E.02481
M73 P28 R20
G1 X134.597 Y147.641 E.0176
G1 X133.986 Y147.714 E.02223
G1 X102.011 Y147.714 E1.1545
G1 X101.524 Y147.667 E.01768
G1 X100.998 Y147.509 E.01981
G1 X100.564 Y147.298 E.01744
G1 X100.18 Y147.011 E.01731
G1 X99.858 Y146.658 E.01726
G1 X99.52 Y146.058 E.02487
G1 X99.359 Y145.597 E.0176
G1 X99.286 Y144.986 E.02222
G1 X99.286 Y107.011 E1.37114
G1 X99.333 Y106.524 E.01767
M73 P29 R20
G1 X99.491 Y105.998 E.01981
G1 X99.702 Y105.564 E.01744
G1 X99.965 Y105.212 E.01586
M204 S6000
G1 X100.321 Y105.499 F30000
G1 F1200
M204 S500
G1 X100.625 Y105.223 E.01483
G1 X101.143 Y104.934 E.02141
G1 X101.521 Y104.806 E.01441
M73 P30 R19
G1 X102.049 Y104.743 E.01921
G1 X133.974 Y104.744 E1.15267
G1 X134.401 Y104.787 E.01549
G1 X134.845 Y104.923 E.01676
G1 X135.208 Y105.102 E.01463
G1 X135.501 Y105.321 E.01319
G1 X135.675 Y105.508 E.00924
G1 X135.851 Y105.635 E.00783
G1 X135.994 Y105.698 E.00564
G1 X136.206 Y105.743 E.00784
G1 X153.961 Y105.743 E.64105
G1 X154.374 Y105.782 E.015
G1 X154.825 Y105.915 E.01695
G1 X155.208 Y106.102 E.01541
G1 X155.501 Y106.321 E.01319
G1 X155.763 Y106.605 E.01398
G1 X155.996 Y106.992 E.01631
G1 X156.188 Y107.499 E.01955
G1 X156.257 Y108.049 E.02004
G1 X156.257 Y143.961 E1.29662
G1 X156.213 Y144.401 E.01597
G1 X156.085 Y144.825 E.01598
G1 X155.912 Y145.186 E.01447
M73 P31 R19
G1 X155.679 Y145.501 E.01413
G1 X155.375 Y145.777 E.01483
G1 X154.857 Y146.066 E.02141
G1 X154.479 Y146.194 E.01441
G1 X153.951 Y146.257 E.01922
G1 X136.218 Y146.257 E.64025
G1 X136.026 Y146.293 E.00708
G1 X135.894 Y146.345 E.00512
G1 X135.728 Y146.45 E.00708
G1 X135.37 Y146.779 E.01756
G1 X134.857 Y147.066 E.02121
G1 X134.479 Y147.194 E.01441
G1 X133.951 Y147.257 E.01922
G1 X102.039 Y147.257 E1.15219
M73 P32 R19
G1 X101.599 Y147.213 E.01597
G1 X101.175 Y147.085 E.01598
G1 X100.814 Y146.912 E.01447
G1 X100.499 Y146.679 E.01413
G1 X100.223 Y146.375 E.01483
G1 X99.934 Y145.857 E.02141
G1 X99.806 Y145.479 E.01441
G1 X99.743 Y144.951 E.01921
G1 X99.743 Y107.039 E1.36884
G1 X99.787 Y106.599 E.01597
G1 X99.915 Y106.175 E.01598
G1 X100.088 Y105.814 E.01447
G1 X100.297 Y105.531 E.01269
M204 S6000
G1 X100.653 Y105.818 F30000
G1 F1200
M204 S500
G1 X100.907 Y105.589 E.01235
G1 X101.341 Y105.349 E.01791
G1 X101.636 Y105.252 E.01121
G1 X102.084 Y105.2 E.01628
G1 X133.944 Y105.201 E1.15032
G1 X134.323 Y105.241 E.01377
G1 X134.686 Y105.354 E.01373
G1 X134.979 Y105.501 E.01182
G1 X135.199 Y105.667 E.00997
G1 X135.415 Y105.884 E.01103
G1 X135.674 Y106.056 E.01124
G1 X135.908 Y106.147 E.00906
G1 X136.218 Y106.2 E.01136
G1 X153.946 Y106.201 E.64008
G1 X154.3 Y106.237 E.01286
G1 X154.648 Y106.339 E.01309
G1 X154.958 Y106.488 E.0124
G1 X155.183 Y106.654 E.0101
G1 X155.386 Y106.871 E.01072
G1 X155.577 Y107.182 E.01318
G1 X155.743 Y107.626 E.01711
G1 X155.8 Y108.086 E.01676
G1 X155.8 Y143.931 E1.2942
G1 X155.764 Y144.298 E.01332
G1 X155.661 Y144.649 E.0132
G1 X155.524 Y144.938 E.01154
G1 X155.347 Y145.182 E.01088
G1 X155.093 Y145.411 E.01235
G1 X154.659 Y145.651 E.01791
G1 X154.364 Y145.748 E.01121
G1 X153.916 Y145.8 E.01628
G1 X136.229 Y145.8 E.6386
G1 X135.951 Y145.843 E.01016
G1 X135.641 Y145.965 E.01204
G1 X135.411 Y146.121 E.01001
G1 X135.086 Y146.415 E.01583
G1 X134.659 Y146.651 E.01762
G1 X134.364 Y146.748 E.01122
G1 X133.916 Y146.8 E.01628
G1 X102.069 Y146.8 E1.14985
G1 X101.702 Y146.764 E.01332
G1 X101.351 Y146.661 E.0132
G1 X101.062 Y146.524 E.01154
G1 X100.818 Y146.347 E.01088
G1 X100.589 Y146.093 E.01235
G1 X100.349 Y145.659 E.01791
G1 X100.252 Y145.364 E.01121
G1 X100.2 Y144.916 E.01628
G1 X100.2 Y107.069 E1.3665
G1 X100.236 Y106.702 E.01332
G1 X100.339 Y106.351 E.0132
G1 X100.476 Y106.062 E.01154
G1 X100.63 Y105.851 E.00944
M204 S6000
G1 X100.991 Y106.15 F30000
G1 F1200
M204 S500
G1 X101.069 Y106.056 E.00446
G1 X101.301 Y105.875 E.01058
G1 X101.513 Y105.767 E.00862
G1 X102.023 Y105.657 E.01883
G1 X133.977 Y105.657 E1.15371
G1 X134.421 Y105.745 E.01634
G1 X134.561 Y105.8 E.00545
G1 X134.752 Y105.909 E.00795
G1 X135.014 Y106.148 E.01279
G1 X135.178 Y106.393 E.01064
G1 X135.254 Y106.573 E.00708
G1 X135.381 Y106.657 E.00548
G1 X153.977 Y106.657 E.67143
G1 X154.421 Y106.745 E.01634
M73 P33 R19
G1 X154.559 Y106.799 E.00535
G1 X154.85 Y106.982 E.01244
G1 X155.013 Y107.147 E.00837
G1 X155.185 Y107.411 E.01137
G1 X155.308 Y107.756 E.01321
G1 X155.343 Y108.02 E.00961
G1 X155.343 Y143.977 E1.29827
G1 X155.255 Y144.421 E.01634
G1 X155.201 Y144.559 E.00535
G1 X155.018 Y144.85 E.01244
G1 X154.853 Y145.013 E.00837
G1 X154.589 Y145.185 E.01137
G1 X154.244 Y145.308 E.01321
G1 X153.98 Y145.343 E.00961
G1 X135.382 Y145.343 E.67151
G1 X135.255 Y145.428 E.00551
G1 X135.202 Y145.558 E.00508
G1 X135.018 Y145.85 E.01248
G1 X134.85 Y146.016 E.0085
G1 X134.702 Y146.123 E.00664
G1 X134.389 Y146.266 E.01241
G1 X133.98 Y146.343 E.01502
G1 X102.023 Y146.343 E1.15382
G1 X101.579 Y146.255 E.01634
G1 X101.441 Y146.201 E.00535
G1 X101.15 Y146.018 E.01244
G1 X100.987 Y145.853 E.00838
G1 X100.815 Y145.589 E.01137
G1 X100.692 Y145.244 E.01322
G1 X100.657 Y144.98 E.0096
G1 X100.657 Y107.023 E1.37048
G1 X100.745 Y106.579 E.01634
G1 X100.8 Y106.439 E.00545
G1 X100.907 Y106.251 E.0078
G1 X100.965 Y106.181 E.00328
M204 S6000
G1 X101.31 Y106.468 F30000
G1 F1200
M204 S500
G1 X101.409 Y106.361 E.00526
G1 X101.575 Y106.241 E.00739
G1 X101.708 Y106.18 E.00527
G1 X102.011 Y106.114 E.0112
G1 X133.99 Y106.114 E1.15465
G1 X134.326 Y106.192 E.01244
G1 X134.532 Y106.31 E.0086
G1 X134.639 Y106.409 E.00526
G1 X134.759 Y106.575 E.00739
G1 X134.82 Y106.708 E.00527
G1 X134.885 Y106.999 E.01078
G1 X134.949 Y107.094 E.00413
G1 X135.02 Y107.114 E.00269
G1 X153.99 Y107.114 E.68492
G1 X154.326 Y107.192 E.01244
G1 X154.532 Y107.31 E.0086
G1 X154.639 Y107.409 E.00526
G1 X154.757 Y107.572 E.00728
G1 X154.855 Y107.815 E.00943
G1 X154.886 Y108.011 E.00716
G1 X154.886 Y143.99 E1.29907
G1 X154.808 Y144.326 E.01244
G1 X154.69 Y144.532 E.0086
G1 X154.591 Y144.639 E.00526
G1 X154.428 Y144.757 E.00728
G1 X154.185 Y144.855 E.00943
G1 X153.989 Y144.886 E.00716
G1 X135.019 Y144.886 E.68493
G1 X134.915 Y144.933 E.00413
G1 X134.808 Y145.326 E.01469
G1 X134.69 Y145.532 E.0086
G1 X134.591 Y145.639 E.00526
M73 P33 R18
G1 X134.425 Y145.759 E.00739
G1 X134.295 Y145.819 E.00515
G1 X133.993 Y145.886 E.0112
G1 X102.01 Y145.886 E1.15476
G1 X101.674 Y145.808 E.01244
G1 X101.468 Y145.69 E.0086
G1 X101.361 Y145.591 E.00526
G1 X101.243 Y145.428 E.00728
G1 X101.145 Y145.185 E.00943
G1 X101.114 Y144.989 E.00716
G1 X101.114 Y107.01 E1.37128
G1 X101.192 Y106.674 E.01244
G1 X101.29 Y106.502 E.00715
M204 S6000
G1 X101.634 Y106.79 F30000
G1 F1200
M204 S500
G1 X101.753 Y106.662 E.00632
G1 X101.905 Y106.592 E.00602
G1 X102 Y106.571 E.00352
G1 X134 Y106.571 E1.15539
G1 X134.21 Y106.634 E.00791
G1 X134.338 Y106.753 E.00632
G1 X134.408 Y106.905 E.00602
G1 X134.429 Y107 E.00352
G1 X134.429 Y107.571 E.02063
G1 X154 Y107.571 E.70665
G1 X154.21 Y107.634 E.00791
G1 X154.338 Y107.753 E.00632
G1 X154.408 Y107.905 E.00602
G1 X154.429 Y108 E.00352
G1 X154.429 Y144 E1.29982
G1 X154.366 Y144.21 E.00791
G1 X154.247 Y144.338 E.00632
M73 P34 R18
G1 X154.095 Y144.408 E.00602
G1 X154 Y144.429 E.00352
G1 X134.429 Y144.429 E.70665
G1 X134.429 Y145 E.02063
G1 X134.366 Y145.21 E.00791
G1 X134.247 Y145.338 E.00632
G1 X134.095 Y145.408 E.00602
G1 X134 Y145.429 E.00352
G1 X102 Y145.429 E1.15539
G1 X101.79 Y145.366 E.00791
G1 X101.662 Y145.247 E.00632
G1 X101.592 Y145.095 E.00602
G1 X101.571 Y145 E.00352
G1 X101.571 Y107 E1.37203
G1 X101.623 Y106.828 E.00647
; WIPE_START
G1 X101.753 Y106.662 E-.08038
G1 X101.905 Y106.592 E-.06336
G1 X102 Y106.571 E-.03706
G1 X103.524 Y106.571 E-.57921
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X108.336 Y112.496 Z.6 F30000
G1 X133.6 Y143.6 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X133.6 Y144.6 E.03611
G1 X102.4 Y144.6 E1.12651
G1 X102.4 Y107.4 E1.34314
G1 X133.6 Y107.4 E1.12651
G1 X133.6 Y108.4 E.03611
G1 X153.6 Y108.4 E.72212
G1 X153.6 Y143.6 E1.27093
G1 X133.64 Y143.6 E.72068
; WIPE_START
G1 X133.6 Y144.6 E-.3803
G1 X132.601 Y144.6 E-.3797
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X125.01 Y143.803 Z.6 F30000
G1 X106.9 Y141.9 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X103.1 Y141.9 E.1372
G1 X103.1 Y137.1 E.17331
G1 X106.9 Y137.1 E.1372
G1 X106.9 Y141.86 E.17186
; WIPE_START
G1 X104.9 Y141.881 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X105.379 Y134.264 Z.6 F30000
G1 X106.9 Y110.1 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X106.9 Y114.9 E.17331
G1 X103.1 Y114.9 E.1372
G1 X103.1 Y110.1 E.17331
G1 X106.86 Y110.1 E.13576
; WIPE_START
G1 X106.877 Y112.1 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X111.806 Y117.927 Z.6 F30000
G1 X133.1 Y143.1 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X133.1 Y144.1 E.03611
G1 X102.9 Y144.1 E1.0904
G1 X102.9 Y142.4 E.06138
G1 X107.4 Y142.4 E.16248
G1 X107.4 Y136.6 E.20941
G1 X102.9 Y136.6 E.16248
G1 X102.9 Y115.4 E.76545
G1 X107.4 Y115.4 E.16248
G1 X107.4 Y109.6 E.20941
G1 X102.9 Y109.6 E.16248
G1 X102.9 Y107.9 E.06138
G1 X133.1 Y107.9 E1.0904
G1 X133.1 Y108.9 E.03611
G1 X153.1 Y108.9 E.72212
G1 X153.1 Y143.1 E1.23483
G1 X133.14 Y143.1 E.72068
; WIPE_START
G1 X133.1 Y144.1 E-.3803
G1 X132.101 Y144.1 E-.3797
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X131.218 Y136.519 Z.6 F30000
G1 X128.143 Y110.1 Z.6
G1 Z.2
M73 P35 R18
G1 E.8 F1800
G1 F1200
M204 S500
G1 X128.143 Y115.857 E.20786
G1 X133.857 Y115.857 E.20631
G1 X133.857 Y109.357 E.23469
G1 X152.643 Y109.357 E.67828
G1 X152.643 Y142.643 E1.20182
G1 X133.857 Y142.643 E.67828
G1 X133.857 Y136.143 E.23469
G1 X128.143 Y136.143 E.20631
G1 X128.143 Y142.857 E.24242
G1 X132.643 Y142.857 E.16248
G1 X132.643 Y143.643 E.02837
G1 X103.357 Y143.643 E1.0574
G1 X103.357 Y142.857 E.02837
G1 X107.857 Y142.857 E.16248
G1 X107.857 Y136.143 E.24242
G1 X103.357 Y136.143 E.16248
G1 X103.357 Y115.857 E.73244
G1 X107.857 Y115.857 E.16248
G1 X107.857 Y109.143 E.24242
G1 X103.357 Y109.143 E.16248
G1 X103.357 Y108.357 E.02837
G1 X132.643 Y108.357 E1.0574
G1 X132.643 Y109.143 E.02837
G1 X128.143 Y109.143 E.16248
G1 X128.143 Y110.06 E.03311
; WIPE_START
G1 X128.143 Y112.06 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X123.781 Y118.323 Z.6 F30000
G1 X109.1 Y139.4 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X109.1 Y112.6 E.96764
G1 X126.9 Y112.6 E.64269
G1 X126.9 Y139.4 E.96764
G1 X109.14 Y139.4 E.64124
M204 S6000
G1 X109.1 Y139.9 F30000
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X108.6 Y139.9 E.01805
G1 X108.6 Y112.1 E1.00375
G1 X127.4 Y112.1 E.67879
G1 X127.4 Y139.9 E1.00375
G1 X109.14 Y139.9 E.6593
M204 S6000
G1 X109.1 Y140.357 F30000
M73 P36 R18
G1 F1200
M204 S500
G1 X108.143 Y140.357 E.03456
G1 X108.143 Y111.643 E1.03675
G1 X127.857 Y111.643 E.7118
G1 X127.857 Y140.357 E1.03675
G1 X109.14 Y140.357 E.6758
; WIPE_START
G1 X108.143 Y140.357 E-.37889
G1 X108.143 Y139.354 E-.38111
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X106.9 Y135.686 Z.6 F30000
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X103.814 Y135.686 E.11142
G1 X103.814 Y116.314 E.69944
G1 X107.686 Y116.314 E.13979
G1 X107.686 Y135.686 E.69944
G1 X106.94 Y135.686 E.02693
; WIPE_START
G1 X104.94 Y135.686 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X112.303 Y137.697 Z.6 F30000
G1 X127.686 Y141.9 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X127.686 Y143.186 E.04643
G1 X108.314 Y143.186 E.69944
G1 X108.314 Y140.814 E.08563
G1 X127.686 Y140.814 E.69944
G1 X127.686 Y141.86 E.03776
; WIPE_START
G1 X127.686 Y143.186 E-.50383
G1 X127.012 Y143.186 E-.25617
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X132.695 Y138.091 Z.6 F30000
G1 X145.814 Y126.328 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X145.814 Y120.814 E.19909
G1 X150.814 Y120.814 E.18053
G1 X150.814 Y109.814 E.39717
G1 X152.186 Y109.814 E.04953
G1 X152.186 Y142.186 E1.16881
G1 X150.814 Y142.186 E.04953
G1 X150.814 Y131.186 E.39717
G1 X145.814 Y131.186 E.18053
G1 X145.814 Y126.368 E.17395
; WIPE_START
G1 X145.814 Y124.368 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X143.768 Y131.721 Z.6 F30000
G1 X143.186 Y133.814 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X143.186 Y142.186 E.30227
G1 X134.314 Y142.186 E.32032
G1 X134.314 Y135.686 E.23469
G1 X128.314 Y135.686 E.21664
G1 X128.314 Y116.314 E.69944
G1 X134.314 Y116.314 E.21664
M73 P37 R18
G1 X134.314 Y109.814 E.23469
G1 X143.186 Y109.814 E.32032
G1 X143.186 Y118.186 E.30227
G1 X132.186 Y118.186 E.39717
G1 X132.186 Y133.814 E.56427
G1 X143.146 Y133.814 E.39572
; WIPE_START
M73 P37 R17
G1 X143.155 Y135.814 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X149.4 Y132.6 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X149.4 Y141.4 E.31773
G1 X144.6 Y141.4 E.17331
G1 X144.6 Y132.6 E.31773
G1 X149.36 Y132.6 E.17186
; WIPE_START
G1 X149.369 Y134.6 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X149.379 Y126.968 Z.6 F30000
G1 X149.4 Y110.6 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X149.4 Y119.4 E.31773
G1 X144.6 Y119.4 E.17331
G1 X144.6 Y110.6 E.31773
G1 X149.36 Y110.6 E.17186
; WIPE_START
G1 X149.369 Y112.6 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X147.511 Y120.003 Z.6 F30000
G1 X144.4 Y132.4 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X133.6 Y132.4 E.38994
G1 X133.6 Y119.6 E.46216
G1 X144.4 Y119.6 E.38994
M73 P38 R17
G1 X144.4 Y132.36 E.46071
; WIPE_START
G1 X142.4 Y132.367 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X144.689 Y125.086 Z.6 F30000
G1 X149.4 Y110.1 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X149.9 Y110.1 E.01805
G1 X149.9 Y119.9 E.35384
G1 X144.9 Y119.9 E.18053
G1 X144.9 Y132.1 E.44049
G1 X149.9 Y132.1 E.18053
G1 X149.9 Y141.9 E.35384
G1 X144.1 Y141.9 E.20941
G1 X144.1 Y132.9 E.32495
G1 X133.1 Y132.9 E.39717
G1 X133.1 Y119.1 E.49826
G1 X144.1 Y119.1 E.39717
G1 X144.1 Y110.1 E.32495
G1 X149.36 Y110.1 E.18992
; WIPE_START
G1 X149.9 Y110.1 E-.2052
G1 X149.9 Y111.56 E-.5548
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X145.162 Y117.544 Z.6 F30000
G1 X132.643 Y133.357 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X132.643 Y118.643 E.53127
G1 X143.643 Y118.643 E.39717
G1 X143.643 Y109.643 E.32495
G1 X150.357 Y109.643 E.24242
G1 X150.357 Y120.357 E.38684
G1 X145.357 Y120.357 E.18053
G1 X145.357 Y131.643 E.40749
G1 X150.357 Y131.643 E.18053
G1 X150.357 Y142.357 E.38684
G1 X143.643 Y142.357 E.24242
G1 X143.643 Y133.357 E.32495
G1 X132.683 Y133.357 E.39572
; WIPE_START
G1 X132.677 Y131.357 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X126.878 Y126.395 Z.6 F30000
G1 X109.1 Y111.186 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X108.314 Y111.186 E.02837
G1 X108.314 Y108.814 E.08563
G1 X127.686 Y108.814 E.69944
G1 X127.686 Y111.186 E.08563
G1 X109.14 Y111.186 E.66962
; WIPE_START
G1 X108.314 Y111.186 E-.31383
G1 X108.314 Y110.012 E-.44617
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X115.947 Y110.044 Z.6 F30000
G1 X129.1 Y110.1 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
M73 P39 R17
G1 F1200
M204 S500
G1 X132.9 Y110.1 E.1372
G1 X132.9 Y114.9 E.17331
G1 X129.1 Y114.9 E.1372
G1 X129.1 Y110.14 E.17186
M204 S6000
G1 X128.6 Y110.1 F30000
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X128.6 Y109.6 E.01805
G1 X133.4 Y109.6 E.17331
G1 X133.4 Y115.4 E.20941
G1 X128.6 Y115.4 E.17331
G1 X128.6 Y110.14 E.18992
; WIPE_START
G1 X128.6 Y109.6 E-.2052
G1 X130.06 Y109.6 E-.5548
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X129.833 Y117.229 Z.6 F30000
G1 X129.1 Y141.9 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X129.1 Y137.1 E.17331
G1 X132.9 Y137.1 E.1372
G1 X132.9 Y141.9 E.17331
G1 X129.14 Y141.9 E.13576
M204 S6000
G1 X128.6 Y141.9 F30000
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X128.6 Y136.6 E.19136
G1 X133.4 Y136.6 E.17331
G1 X133.4 Y142.4 E.20941
G1 X128.6 Y142.4 E.17331
G1 X128.6 Y141.94 E.01661
; WIPE_START
G1 X128.6 Y139.94 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X127.503 Y141.94 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50925
M204 S500
G1 X126.765 Y141.203 E.03844
G1 X126.106 Y141.203 E.02429
G1 X127.297 Y142.394 E.06208
G1 X127.297 Y142.797 E.01485
G1 X127.041 Y142.797 E.00944
G1 X125.446 Y141.203 E.08309
G1 X124.787 Y141.203 E.02429
G1 X126.382 Y142.797 E.08309
G1 X125.722 Y142.797 E.02429
G1 X124.127 Y141.203 E.08309
G1 X123.468 Y141.203 E.02429
G1 X125.063 Y142.797 E.08309
G1 X124.403 Y142.797 E.02429
G1 X122.808 Y141.203 E.08309
G1 X122.149 Y141.203 E.02429
G1 X123.744 Y142.797 E.08309
G1 X123.084 Y142.797 E.02429
G1 X121.489 Y141.203 E.08309
G1 X120.83 Y141.203 E.02429
G1 X122.425 Y142.797 E.08309
G1 X121.765 Y142.797 E.02429
G1 X120.17 Y141.203 E.08309
G1 X119.511 Y141.203 E.02429
G1 X121.106 Y142.797 E.08309
G1 X120.446 Y142.797 E.02429
G1 X118.851 Y141.203 E.08309
G1 X118.192 Y141.203 E.02429
G1 X119.787 Y142.797 E.08309
G1 X119.127 Y142.797 E.02429
G1 X117.532 Y141.203 E.08309
G1 X116.873 Y141.203 E.02429
G1 X118.468 Y142.797 E.08309
G1 X117.808 Y142.797 E.02429
M73 P40 R17
G1 X116.213 Y141.203 E.08309
G1 X115.554 Y141.203 E.02429
G1 X117.149 Y142.797 E.08309
G1 X116.489 Y142.797 E.02429
G1 X114.894 Y141.203 E.08309
G1 X114.235 Y141.203 E.02429
G1 X115.83 Y142.797 E.08309
G1 X115.17 Y142.797 E.02429
G1 X113.575 Y141.203 E.08309
G1 X112.916 Y141.203 E.02429
G1 X114.511 Y142.797 E.08309
G1 X113.851 Y142.797 E.02429
G1 X112.256 Y141.203 E.08309
G1 X111.597 Y141.203 E.02429
G1 X113.192 Y142.797 E.08309
G1 X112.532 Y142.797 E.02429
G1 X110.937 Y141.203 E.08309
G1 X110.278 Y141.203 E.02429
G1 X111.873 Y142.797 E.08309
G1 X111.213 Y142.797 E.02429
G1 X109.618 Y141.203 E.08309
G1 X108.959 Y141.203 E.02429
G1 X110.554 Y142.797 E.08309
G1 X109.894 Y142.797 E.02429
G1 X108.703 Y141.606 E.06209
G1 X108.703 Y142.265 E.02429
G1 X109.441 Y143.003 E.03845
; WIPE_START
G1 X108.703 Y142.265 E-.39662
G1 X108.703 Y141.606 E-.25061
G1 X108.912 Y141.815 E-.11278
; WIPE_END
G1 E-.04
M204 S6000
G1 X108.085 Y143.25 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.37172
G1 F1200
M204 S500
G1 X103.586 Y143.25 E.11688
; WIPE_START
G1 X105.586 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X102.75 Y142.15 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.24293
G1 F1200
M204 S500
G1 X102.75 Y136.85 E.08373
; WIPE_START
G1 X102.75 Y138.85 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X104.03 Y131.326 Z.6 F30000
G1 X106.552 Y116.497 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.51301
M204 S500
G1 X107.297 Y117.243 E.03917
G1 X107.297 Y117.908 E.02469
G1 X106.092 Y116.703 E.06328
G1 X105.428 Y116.703 E.02469
M73 P40 R16
G1 X107.297 Y118.572 E.09819
G1 X107.297 Y119.237 E.02469
G1 X104.763 Y116.703 E.13311
G1 X104.203 Y116.703 E.0208
G1 X104.203 Y116.807 E.00388
G1 X107.297 Y119.902 E.16253
G1 X107.297 Y120.567 E.02469
G1 X104.203 Y117.472 E.16253
G1 X104.203 Y118.137 E.02469
G1 X107.297 Y121.232 E.16253
G1 X107.297 Y121.896 E.02469
G1 X104.203 Y118.802 E.16253
G1 X104.203 Y119.466 E.02469
G1 X107.297 Y122.561 E.16253
G1 X107.297 Y123.226 E.02469
G1 X104.203 Y120.131 E.16253
G1 X104.203 Y120.796 E.02469
G1 X107.297 Y123.891 E.16253
G1 X107.297 Y124.556 E.02469
G1 X104.203 Y121.461 E.16253
G1 X104.203 Y122.126 E.02469
G1 X107.297 Y125.22 E.16253
G1 X107.297 Y125.885 E.02469
G1 X104.203 Y122.79 E.16253
G1 X104.203 Y123.455 E.02469
G1 X107.297 Y126.55 E.16253
G1 X107.297 Y127.215 E.02469
G1 X104.203 Y124.12 E.16253
G1 X104.203 Y124.785 E.02469
G1 X107.297 Y127.88 E.16253
G1 X107.297 Y128.544 E.02469
G1 X104.203 Y125.45 E.16253
G1 X104.203 Y126.114 E.02469
G1 X107.297 Y129.209 E.16253
G1 X107.297 Y129.874 E.02469
G1 X104.203 Y126.779 E.16253
G1 X104.203 Y127.444 E.02469
G1 X107.297 Y130.539 E.16253
G1 X107.297 Y131.204 E.02469
G1 X104.203 Y128.109 E.16253
G1 X104.203 Y128.774 E.02469
G1 X107.297 Y131.869 E.16253
G1 X107.297 Y132.533 E.02469
G1 X104.203 Y129.438 E.16253
G1 X104.203 Y130.103 E.02469
G1 X107.297 Y133.198 E.16253
G1 X107.297 Y133.863 E.02469
G1 X104.203 Y130.768 E.16253
G1 X104.203 Y131.433 E.02469
G1 X107.297 Y134.528 E.16253
G1 X107.297 Y135.193 E.02469
G1 X104.203 Y132.098 E.16253
G1 X104.203 Y132.762 E.02469
G1 X106.738 Y135.297 E.13312
G1 X106.073 Y135.297 E.02469
G1 X104.203 Y133.427 E.09821
G1 X104.203 Y134.092 E.02469
G1 X105.408 Y135.297 E.0633
G1 X104.743 Y135.297 E.02469
G1 X103.997 Y134.551 E.03919
; WIPE_START
G1 X104.743 Y135.297 E-.40103
G1 X105.408 Y135.297 E-.25263
G1 X105.21 Y135.1 E-.10634
; WIPE_END
G1 E-.04
M204 S6000
G1 X104.276 Y127.524 Z.6 F30000
G1 X102.75 Y115.15 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.24293
G1 F1200
M204 S500
G1 X102.75 Y109.85 E.08373
; WIPE_START
G1 X102.75 Y111.85 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X103.586 Y108.75 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.37172
G1 F1200
M204 S500
G1 X108.085 Y108.75 E.11688
; WIPE_START
G1 X106.085 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X113.717 Y108.842 Z.6 F30000
G1 X126.56 Y108.997 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50925
M204 S500
G1 X127.297 Y109.735 E.03844
G1 X127.297 Y110.394 E.02429
G1 X126.106 Y109.203 E.06208
G1 X125.446 Y109.203 E.02429
G1 X127.041 Y110.797 E.08309
G1 X126.382 Y110.797 E.02429
G1 X124.787 Y109.203 E.08309
G1 X124.127 Y109.203 E.02429
G1 X125.722 Y110.797 E.08309
M73 P41 R16
G1 X125.063 Y110.797 E.02429
G1 X123.468 Y109.203 E.08309
G1 X122.808 Y109.203 E.02429
G1 X124.403 Y110.797 E.08309
G1 X123.744 Y110.797 E.02429
G1 X122.149 Y109.203 E.08309
G1 X121.489 Y109.203 E.02429
G1 X123.084 Y110.797 E.08309
G1 X122.425 Y110.797 E.02429
G1 X120.83 Y109.203 E.08309
G1 X120.17 Y109.203 E.02429
G1 X121.765 Y110.797 E.08309
G1 X121.106 Y110.797 E.02429
G1 X119.511 Y109.203 E.08309
G1 X118.851 Y109.203 E.02429
G1 X120.446 Y110.797 E.08309
G1 X119.787 Y110.797 E.02429
G1 X118.192 Y109.203 E.08309
G1 X117.532 Y109.203 E.02429
G1 X119.127 Y110.797 E.08309
G1 X118.468 Y110.797 E.02429
G1 X116.873 Y109.203 E.08309
G1 X116.213 Y109.203 E.02429
G1 X117.808 Y110.797 E.08309
G1 X117.149 Y110.797 E.02429
G1 X115.554 Y109.203 E.08309
G1 X114.894 Y109.203 E.02429
G1 X116.489 Y110.797 E.08309
G1 X115.83 Y110.797 E.02429
G1 X114.235 Y109.203 E.08309
G1 X113.575 Y109.203 E.02429
G1 X115.17 Y110.797 E.08309
G1 X114.511 Y110.797 E.02429
G1 X112.916 Y109.203 E.08309
G1 X112.256 Y109.203 E.02429
G1 X113.851 Y110.797 E.08309
G1 X113.192 Y110.797 E.02429
G1 X111.597 Y109.203 E.08309
G1 X110.937 Y109.203 E.02429
G1 X112.532 Y110.797 E.08309
G1 X111.873 Y110.797 E.02429
G1 X110.278 Y109.203 E.08309
G1 X109.618 Y109.203 E.02429
G1 X111.213 Y110.797 E.08309
G1 X110.554 Y110.797 E.02429
G1 X108.959 Y109.203 E.08309
G1 X108.703 Y109.203 E.00945
G1 X108.703 Y109.606 E.01485
G1 X109.894 Y110.797 E.06209
G1 X109.235 Y110.797 E.02429
G1 X108.497 Y110.059 E.03845
; WIPE_START
G1 X109.235 Y110.797 E-.39663
G1 X109.894 Y110.797 E-.25061
G1 X109.685 Y110.588 E-.11276
; WIPE_END
G1 E-.04
M204 S6000
G1 X117.279 Y109.822 Z.6 F30000
G1 X127.914 Y108.75 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.37172
G1 F1200
M204 S500
G1 X132.414 Y108.75 E.11688
M204 S6000
G1 X132.872 Y109.25 F30000
; LINE_WIDTH: 0.28586
G1 F1200
M204 S500
G1 X133.628 Y109.25 E.01452
; WIPE_START
G1 X132.872 Y109.25 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X140.401 Y110.501 Z.6 F30000
G1 X143.003 Y110.934 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.506
M204 S500
G1 X142.272 Y110.203 E.03782
G1 X141.617 Y110.203 E.02396
G1 X142.797 Y111.383 E.06106
G1 X142.797 Y112.038 E.02396
G1 X140.962 Y110.203 E.09493
G1 X140.307 Y110.203 E.02396
G1 X142.797 Y112.693 E.12881
G1 X142.797 Y113.347 E.02396
G1 X139.653 Y110.203 E.16269
G1 X138.998 Y110.203 E.02396
G1 X142.797 Y114.002 E.19657
G1 X142.797 Y114.657 E.02396
G1 X138.343 Y110.203 E.23045
G1 X137.688 Y110.203 E.02396
G1 X142.797 Y115.312 E.26433
G1 X142.797 Y115.967 E.02396
G1 X137.033 Y110.203 E.29821
G1 X136.378 Y110.203 E.02396
G1 X142.797 Y116.622 E.33209
G1 X142.797 Y117.277 E.02396
G1 X135.723 Y110.203 E.36597
G1 X135.068 Y110.203 E.02396
G1 X142.663 Y117.797 E.3929
G1 X142.008 Y117.797 E.02396
G1 X134.703 Y110.492 E.37794
G1 X134.703 Y111.147 E.02396
G1 X141.353 Y117.797 E.34406
G1 X140.699 Y117.797 E.02396
G1 X134.703 Y111.801 E.31018
G1 X134.703 Y112.456 E.02396
G1 X140.044 Y117.797 E.2763
G1 X139.389 Y117.797 E.02396
G1 X134.703 Y113.111 E.24242
G1 X134.703 Y113.766 E.02396
G1 X138.734 Y117.797 E.20855
G1 X138.079 Y117.797 E.02396
G1 X134.703 Y114.421 E.17467
G1 X134.703 Y115.076 E.02396
G1 X137.424 Y117.797 E.14079
G1 X136.769 Y117.797 E.02396
G1 X134.703 Y115.731 E.10691
G1 X134.703 Y116.386 E.02396
G1 X136.114 Y117.797 E.07303
G1 X135.459 Y117.797 E.02396
G1 X134.364 Y116.703 E.05664
G1 X133.71 Y116.703 E.02396
G1 X134.804 Y117.797 E.05664
G1 X134.15 Y117.797 E.02396
G1 X133.055 Y116.703 E.05664
G1 X132.4 Y116.703 E.02396
G1 X133.495 Y117.797 E.05664
G1 X132.84 Y117.797 E.02396
G1 X131.745 Y116.703 E.05664
G1 X131.09 Y116.703 E.02396
G1 X132.185 Y117.797 E.05664
G1 X131.797 Y117.797 E.01417
G1 X131.797 Y118.065 E.00978
G1 X130.435 Y116.703 E.07048
G1 X129.78 Y116.703 E.02396
G1 X131.797 Y118.72 E.10436
G1 X131.797 Y119.375 E.02396
G1 X129.125 Y116.703 E.13824
G1 X128.703 Y116.703 E.01546
G1 X128.703 Y116.935 E.00849
G1 X131.797 Y120.03 E.16011
G1 X131.797 Y120.684 E.02396
G1 X128.703 Y117.59 E.16011
G1 X128.703 Y118.244 E.02396
G1 X131.797 Y121.339 E.16011
G1 X131.797 Y121.994 E.02396
G1 X128.703 Y118.899 E.16011
G1 X128.703 Y119.554 E.02396
G1 X131.797 Y122.649 E.16011
G1 X131.797 Y123.304 E.02396
G1 X128.703 Y120.209 E.16011
G1 X128.703 Y120.864 E.02396
G1 X131.797 Y123.959 E.16011
G1 X131.797 Y124.614 E.02396
G1 X128.703 Y121.519 E.16011
G1 X128.703 Y122.174 E.02396
G1 X131.797 Y125.269 E.16011
G1 X131.797 Y125.924 E.02396
G1 X128.703 Y122.829 E.16011
G1 X128.703 Y123.484 E.02396
G1 X131.797 Y126.579 E.16011
G1 X131.797 Y127.233 E.02396
G1 X128.703 Y124.139 E.16011
G1 X128.703 Y124.793 E.02396
G1 X131.797 Y127.888 E.16011
G1 X131.797 Y128.543 E.02396
G1 X128.703 Y125.448 E.16011
G1 X128.703 Y126.103 E.02396
G1 X131.797 Y129.198 E.16011
G1 X131.797 Y129.853 E.02396
G1 X128.703 Y126.758 E.16011
G1 X128.703 Y127.413 E.02396
G1 X131.797 Y130.508 E.16011
G1 X131.797 Y131.163 E.02396
G1 X128.703 Y128.068 E.16011
G1 X128.703 Y128.723 E.02396
G1 X131.797 Y131.818 E.16011
G1 X131.797 Y132.473 E.02396
G1 X128.703 Y129.378 E.16011
G1 X128.703 Y130.033 E.02396
G1 X132.003 Y133.333 E.17075
; WIPE_START
G1 X130.589 Y131.919 E-.76
; WIPE_END
G1 E-.04
M204 S6000
G1 X138.108 Y133.232 Z.6 F30000
G1 X142.49 Y133.997 Z.6
G1 Z.2
G1 E.8 F1800
M204 S500
G1 X142.797 Y134.304 E.01589
G1 X142.797 Y134.959 E.02396
G1 X142.041 Y134.203 E.03913
G1 X141.386 Y134.203 E.02396
G1 X142.797 Y135.614 E.07301
G1 X142.797 Y136.269 E.02396
G1 X140.731 Y134.203 E.10689
G1 X140.076 Y134.203 E.02396
G1 X142.797 Y136.924 E.14077
G1 X142.797 Y137.579 E.02396
G1 X139.421 Y134.203 E.17465
G1 X138.767 Y134.203 E.02396
G1 X142.797 Y138.233 E.20852
G1 X142.797 Y138.888 E.02396
G1 X138.112 Y134.203 E.2424
G1 X137.457 Y134.203 E.02396
G1 X142.797 Y139.543 E.27628
G1 X142.797 Y140.198 E.02396
G1 X136.802 Y134.203 E.31016
M73 P42 R16
G1 X136.147 Y134.203 E.02396
G1 X142.797 Y140.853 E.34404
G1 X142.797 Y141.508 E.02396
G1 X135.492 Y134.203 E.37792
G1 X134.837 Y134.203 E.02396
G1 X142.432 Y141.797 E.3929
G1 X141.777 Y141.797 E.02396
G1 X134.182 Y134.203 E.3929
G1 X133.527 Y134.203 E.02396
G1 X141.122 Y141.797 E.3929
G1 X140.467 Y141.797 E.02396
G1 X134.703 Y136.033 E.29823
G1 X134.703 Y136.687 E.02396
G1 X139.813 Y141.797 E.26435
G1 X139.158 Y141.797 E.02396
G1 X134.703 Y137.342 E.23047
G1 X134.703 Y137.997 E.02396
G1 X138.503 Y141.797 E.19659
G1 X137.848 Y141.797 E.02396
G1 X134.703 Y138.652 E.16271
G1 X134.703 Y139.307 E.02396
G1 X137.193 Y141.797 E.12883
G1 X136.538 Y141.797 E.02396
G1 X134.703 Y139.962 E.09495
G1 X134.703 Y140.617 E.02396
G1 X135.883 Y141.797 E.06108
G1 X135.228 Y141.797 E.02396
G1 X134.497 Y141.066 E.03784
; WIPE_START
G1 X135.228 Y141.797 E-.39306
G1 X135.883 Y141.797 E-.24886
G1 X135.663 Y141.578 E-.11809
; WIPE_END
G1 E-.04
M204 S6000
G1 X134.173 Y135.503 Z.6 F30000
G1 Z.2
G1 E.8 F1800
M204 S500
G1 X132.667 Y133.997 E.07792
; WIPE_START
G1 X134.081 Y135.411 E-.76
; WIPE_END
G1 E-.04
M204 S6000
G1 X133.518 Y135.503 Z.6 F30000
G1 Z.2
G1 E.8 F1800
M204 S500
G1 X132.218 Y134.203 E.06728
G1 X131.797 Y134.203 E.01537
G1 X131.797 Y133.782 E.01537
G1 X128.703 Y130.687 E.16011
G1 X128.703 Y131.342 E.02396
G1 X132.658 Y135.297 E.20461
G1 X132.003 Y135.297 E.02396
G1 X128.703 Y131.997 E.17073
G1 X128.703 Y132.652 E.02396
G1 X131.348 Y135.297 E.13685
G1 X130.693 Y135.297 E.02396
G1 X128.703 Y133.307 E.10297
G1 X128.703 Y133.962 E.02396
G1 X130.038 Y135.297 E.06909
G1 X129.383 Y135.297 E.02396
G1 X128.703 Y134.617 E.03521
G1 X128.703 Y135.272 E.02396
G1 X128.934 Y135.503 E.01197
; WIPE_START
G1 X128.703 Y135.272 E-.12437
G1 X128.703 Y134.617 E-.24886
G1 X129.383 Y135.297 E-.36578
G1 X129.438 Y135.297 E-.021
; WIPE_END
G1 E-.04
M204 S6000
G1 X128.002 Y142.794 Z.6 F30000
G1 X127.914 Y143.25 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.37172
G1 F1200
M204 S500
G1 X132.414 Y143.25 E.11688
M204 S6000
G1 X132.872 Y142.75 F30000
; LINE_WIDTH: 0.28586
G1 F1200
M204 S500
G1 X133.628 Y142.75 E.01452
; WIPE_START
G1 X132.872 Y142.75 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X136.804 Y136.209 Z.6 F30000
G1 X152.003 Y110.925 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.5019
M204 S500
G1 X151.281 Y110.203 E.03704
G1 X151.203 Y110.203 E.00284
G1 X151.203 Y110.773 E.0207
G1 X151.797 Y111.368 E.0305
G1 X151.797 Y112.017 E.02353
G1 X151.203 Y111.422 E.0305
G1 X151.203 Y112.072 E.02353
G1 X151.797 Y112.666 E.0305
G1 X151.797 Y113.316 E.02353
G1 X151.203 Y112.721 E.0305
G1 X151.203 Y113.37 E.02353
G1 X151.797 Y113.965 E.0305
G1 X151.797 Y114.614 E.02353
G1 X151.203 Y114.019 E.0305
G1 X151.203 Y114.668 E.02353
G1 X151.797 Y115.263 E.0305
G1 X151.797 Y115.912 E.02353
G1 X151.203 Y115.317 E.0305
G1 X151.203 Y115.966 E.02353
G1 X151.797 Y116.561 E.0305
G1 X151.797 Y117.21 E.02353
G1 X151.203 Y116.615 E.0305
G1 X151.203 Y117.264 E.02353
G1 X151.797 Y117.859 E.0305
G1 X151.797 Y118.508 E.02353
G1 X151.203 Y117.913 E.0305
G1 X151.203 Y118.563 E.02353
G1 X151.797 Y119.157 E.0305
G1 X151.797 Y119.807 E.02353
G1 X151.203 Y119.212 E.0305
G1 X151.203 Y119.861 E.02353
G1 X151.797 Y120.456 E.0305
G1 X151.797 Y121.105 E.02353
G1 X151.203 Y120.51 E.0305
G1 X151.203 Y121.159 E.02353
G1 X151.797 Y121.754 E.0305
G1 X151.797 Y122.403 E.02353
G1 X150.597 Y121.203 E.06155
G1 X149.948 Y121.203 E.02353
G1 X151.797 Y123.052 E.09483
G1 X151.797 Y123.701 E.02353
G1 X149.299 Y121.203 E.12811
G1 X148.65 Y121.203 E.02353
G1 X151.797 Y124.35 E.16139
G1 X151.797 Y124.999 E.02353
G1 X148.001 Y121.203 E.19467
G1 X147.352 Y121.203 E.02353
G1 X151.797 Y125.648 E.22796
G1 X151.797 Y126.297 E.02353
G1 X146.703 Y121.203 E.26124
G1 X146.203 Y121.203 E.01813
G1 X146.203 Y121.352 E.00541
G1 X151.797 Y126.947 E.28687
G1 X151.797 Y127.596 E.02353
G1 X146.203 Y122.001 E.28687
G1 X146.203 Y122.65 E.02353
G1 X151.797 Y128.245 E.28687
G1 X151.797 Y128.894 E.02353
G1 X146.203 Y123.299 E.28687
G1 X146.203 Y123.948 E.02353
G1 X151.797 Y129.543 E.28687
G1 X151.797 Y130.192 E.02353
G1 X146.203 Y124.597 E.28687
G1 X146.203 Y125.246 E.02353
G1 X151.797 Y130.841 E.28687
G1 X151.797 Y131.49 E.02353
G1 X146.203 Y125.895 E.28687
G1 X146.203 Y126.544 E.02353
G1 X150.456 Y130.797 E.21807
G1 X149.806 Y130.797 E.02353
G1 X146.203 Y127.194 E.18479
G1 X146.203 Y127.843 E.02353
G1 X149.157 Y130.797 E.15151
G1 X148.508 Y130.797 E.02353
G1 X146.203 Y128.492 E.11822
G1 X146.203 Y129.141 E.02353
G1 X147.859 Y130.797 E.08494
G1 X147.21 Y130.797 E.02353
G1 X146.203 Y129.79 E.05166
G1 X146.203 Y130.439 E.02353
G1 X146.767 Y131.003 E.02892
; WIPE_START
G1 X146.203 Y130.439 E-.30316
G1 X146.203 Y129.79 E-.24666
G1 X146.594 Y130.181 E-.21018
; WIPE_END
G1 E-.04
M204 S6000
G1 X150.997 Y131.339 Z.6 F30000
G1 Z.2
G1 E.8 F1800
M204 S500
G1 X151.797 Y132.139 E.04105
G1 X151.797 Y132.788 E.02353
G1 X151.203 Y132.194 E.0305
G1 X151.203 Y132.843 E.02353
G1 X151.797 Y133.438 E.0305
G1 X151.797 Y134.087 E.02353
G1 X151.203 Y133.492 E.0305
G1 X151.203 Y134.141 E.02353
G1 X151.797 Y134.736 E.0305
G1 X151.797 Y135.385 E.02353
G1 X151.203 Y134.79 E.0305
G1 X151.203 Y135.439 E.02353
G1 X151.797 Y136.034 E.0305
G1 X151.797 Y136.683 E.02353
G1 X151.203 Y136.088 E.0305
G1 X151.203 Y136.737 E.02353
G1 X151.797 Y137.332 E.0305
G1 X151.797 Y137.981 E.02353
G1 X151.203 Y137.386 E.0305
G1 X151.203 Y138.035 E.02353
G1 X151.797 Y138.63 E.0305
G1 X151.797 Y139.279 E.02353
G1 X151.203 Y138.684 E.0305
G1 X151.203 Y139.334 E.02353
G1 X151.797 Y139.928 E.0305
G1 X151.797 Y140.578 E.02353
G1 X151.203 Y139.983 E.0305
G1 X151.203 Y140.632 E.02353
G1 X151.797 Y141.227 E.0305
G1 X151.797 Y141.797 E.02069
G1 X151.719 Y141.797 E.00284
G1 X150.997 Y141.075 E.03703
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F1800
G1 X151.719 Y141.797 E-.38814
M73 P43 R16
G1 X151.797 Y141.797 E-.02976
G1 X151.797 Y141.227 E-.2169
G1 X151.564 Y140.994 E-.1252
; WIPE_END
G1 E-.03999
; layer num/total_layer_count: 2/27
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
; open powerlost recovery
M1003 S1
M976 S1 P1 ; scan model before printing 2nd layer
M400 P100
G1 E.8
G1 E-.8
M204 S10000
G17
G3 Z.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X129.29 Y142.552
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y142.552 E.02708
G1 X128.448 Y136.448 E.19629
G1 X133.552 Y136.448 E.16413
G1 X133.552 Y142.552 E.19629
G1 X129.33 Y142.552 E.13577
G1 X128.855 Y141.71 F30000
G1 F3600
G1 X128.855 Y136.855 E.15612
G1 X133.145 Y136.855 E.13795
G1 X133.145 Y142.145 E.17011
G1 X128.855 Y142.145 E.13795
G1 X128.855 Y141.75 E.0127
M204 S250
G1 X129.29 Y141.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y141.71 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y142.959 E.04017
G1 X132.541 Y142.959 E.1447
G1 X132.541 Y143.541 E.01871
G1 X103.459 Y143.541 E.93516
G1 X103.459 Y142.959 E.01871
G1 X107.959 Y142.959 E.1447
G1 X107.959 Y140.459 E.08039
G1 X128.041 Y140.459 E.64576
G1 X128.041 Y141.67 E.03894
; WIPE_START
G1 X128.041 Y142.959 E-.48987
G1 X128.752 Y142.959 E-.27013
; WIPE_END
G1 E-.04 F1800
G1 X121.47 Y140.673 Z.8 F30000
G1 X106.71 Y136.041 Z.8
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X103.459 Y136.041 E.10454
G1 X103.459 Y115.959 E.64576
G1 X108.041 Y115.959 E.14733
G1 X108.041 Y136.041 E.64576
G1 X106.75 Y136.041 E.04151
; WIPE_START
G1 X104.75 Y136.041 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y140.052 Z.8 F30000
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X108.448 Y140.052 E.02708
G1 X108.448 Y111.948 E.90373
G1 X127.552 Y111.948 E.61432
G1 X127.552 Y140.052 E.90373
G1 X109.33 Y140.052 E.58595
G1 X109.29 Y139.645 F30000
G1 F3600
G1 X108.855 Y139.645 E.01399
G1 X108.855 Y112.355 E.87755
G1 X127.145 Y112.355 E.58814
G1 X127.145 Y139.645 E.87755
G1 X109.33 Y139.645 E.57287
M204 S250
G1 X109.29 Y139.21 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.747 Y130.987 Z.8 F30000
G1 X128.448 Y110.29 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y109.448 E.02708
G1 X133.552 Y109.448 E.16413
G1 X133.552 Y115.552 E.19629
G1 X128.448 Y115.552 E.16413
G1 X128.448 Y110.33 E.16792
G1 X129.29 Y109.855 F30000
G1 F3600
G1 X133.145 Y109.855 E.12396
G1 X133.145 Y115.145 E.17011
G1 X128.855 Y115.145 E.13795
G1 X128.855 Y109.855 E.17011
G1 X129.25 Y109.855 E.0127
M204 S250
G1 X129.29 Y110.29 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y110.29 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y111.541 E.04022
G1 X107.959 Y111.541 E.64576
G1 X107.959 Y109.041 E.08039
G1 X103.459 Y109.041 E.1447
G1 X103.459 Y108.459 E.01871
G1 X132.541 Y108.459 E.93516
G1 X132.541 Y109.041 E.01871
G1 X128.041 Y109.041 E.1447
G1 X128.041 Y110.25 E.03888
; WIPE_START
G1 X128.041 Y111.541 E-.49053
G1 X127.332 Y111.541 E-.26947
; WIPE_END
G1 E-.04 F1800
G1 X134.944 Y110.987 Z.8 F30000
G1 X149.21 Y109.948 Z.8
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X150.052 Y109.948 E.02708
G1 X150.052 Y120.052 E.32491
G1 X145.052 Y120.052 E.16078
G1 X145.052 Y131.948 E.38253
G1 X150.052 Y131.948 E.16078
G1 X150.052 Y142.052 E.32491
G1 X143.948 Y142.052 E.19629
G1 X143.948 Y133.052 E.28941
G1 X132.948 Y133.052 E.35372
G1 X132.948 Y118.948 E.45354
G1 X143.948 Y118.948 E.35372
G1 X143.948 Y109.948 E.28941
G1 X149.17 Y109.948 E.16792
G1 X149.21 Y110.355 F30000
G1 F3600
G1 X149.645 Y110.355 E.01399
G1 X149.645 Y119.645 E.29873
G1 X144.645 Y119.645 E.16078
G1 X144.645 Y132.355 E.40871
G1 X149.645 Y132.355 E.16078
G1 X149.645 Y141.645 E.29873
G1 X144.355 Y141.645 E.17011
G1 X144.355 Y132.645 E.28941
G1 X133.355 Y132.645 E.35372
G1 X133.355 Y119.355 E.42736
G1 X144.355 Y119.355 E.35372
G1 X144.355 Y110.355 E.28941
G1 X149.17 Y110.355 E.15483
; WIPE_START
G1 X149.645 Y110.355 E-.1805
G1 X149.645 Y111.88 E-.5795
; WIPE_END
G1 E-.04 F1800
G1 X147.674 Y119.253 Z.8 F30000
G1 X144.21 Y132.21 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X144.584 Y124.924 Z.8 F30000
G1 X149.21 Y110.79 Z.8
G1 Z.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P44 R16
G1 X149.191 Y120.422 Z.8 F30000
G1 X149.21 Y132.79 Z.8
G1 Z.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.541 Y133.459 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X143.541 Y142.541 E.29204
G1 X133.959 Y142.541 E.30811
G1 X133.959 Y136.041 E.20902
G1 X127.959 Y136.041 E.19294
G1 X127.959 Y115.959 E.64576
G1 X133.959 Y115.959 E.19294
G1 X133.959 Y109.459 E.20902
G1 X143.541 Y109.459 E.30811
G1 X143.541 Y118.541 E.29204
G1 X132.541 Y118.541 E.35372
G1 X132.541 Y133.459 E.47972
G1 X143.501 Y133.459 E.35243
; WIPE_START
G1 X143.51 Y135.459 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.238 Y128.025 Z.8 F30000
M73 P44 R15
G1 X145.459 Y127.074 Z.8
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X145.459 Y120.459 E.21272
G1 X150.459 Y120.459 E.16078
G1 X150.459 Y109.459 E.35372
G1 X152.541 Y109.459 E.06694
G1 X152.541 Y142.541 E1.06379
G1 X150.459 Y142.541 E.06694
G1 X150.459 Y131.541 E.35372
G1 X145.459 Y131.541 E.16078
G1 X145.459 Y127.114 E.14234
; WIPE_START
G1 X145.459 Y125.114 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.076 Y131.362 Z.8 F30000
G1 X132.948 Y142.948 Z.8
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X132.948 Y143.948 E.03216
G1 X103.052 Y143.948 E.96134
G1 X103.052 Y142.552 E.04489
G1 X107.552 Y142.552 E.1447
G1 X107.552 Y136.448 E.19629
G1 X103.052 Y136.448 E.1447
G1 X103.052 Y115.552 E.67194
G1 X107.552 Y115.552 E.1447
G1 X107.552 Y109.448 E.19629
G1 X103.052 Y109.448 E.1447
G1 X103.052 Y108.052 E.04489
G1 X132.948 Y108.052 E.96134
G1 X132.948 Y109.052 E.03216
G1 X152.948 Y109.052 E.64313
G1 X152.948 Y142.948 E1.08997
G1 X132.988 Y142.948 E.64184
G1 X133.355 Y143.355 F30000
G1 F3600
G1 X133.355 Y144.355 E.03216
G1 X102.645 Y144.355 E.98752
G1 X102.645 Y142.145 E.07107
G1 X107.145 Y142.145 E.1447
G1 X107.145 Y136.855 E.17011
G1 X102.645 Y136.855 E.1447
G1 X102.645 Y115.145 E.69812
G1 X107.145 Y115.145 E.1447
G1 X107.145 Y109.855 E.17011
G1 X102.645 Y109.855 E.1447
G1 X102.645 Y107.645 E.07107
G1 X133.355 Y107.645 E.98752
G1 X133.355 Y108.645 E.03216
G1 X153.355 Y108.645 E.64313
G1 X153.355 Y143.355 E1.11615
G1 X133.395 Y143.355 E.64184
; WIPE_START
G1 X133.355 Y144.355 E-.3803
G1 X132.356 Y144.355 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X127.765 Y138.257 Z.8 F30000
G1 X106.71 Y110.29 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.694 Y119.922 Z.8 F30000
G1 X106.71 Y141.71 Z.8
G1 Z.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.323 Y142.242 Z.8 F30000
G1 X133.79 Y143.79 Z.8
G1 Z.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
G1 X132.791 Y144.79 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X132.337 Y143.25 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y143.25 E.06208
; WIPE_START
G1 X129.837 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128 Y140.256 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y136.245 E.15488
; WIPE_START
G1 X128 Y138.245 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.456 Y139.874 Z.8 F30000
G1 X143.377 Y141.606 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42443
G1 F3600
G1 X142.775 Y142.208 E.02566
G1 X142.236 Y142.208 E.01626
G1 X143.208 Y141.236 E.04142
G1 X143.208 Y140.696 E.01626
G1 X141.696 Y142.208 E.06441
G1 X141.157 Y142.208 E.01626
G1 X143.208 Y140.157 E.08741
G1 X143.208 Y139.617 E.01626
G1 X140.617 Y142.208 E.1104
G1 X140.078 Y142.208 E.01626
G1 X143.208 Y139.078 E.1334
G1 X143.208 Y138.538 E.01626
G1 X139.538 Y142.208 E.15639
G1 X138.999 Y142.208 E.01626
G1 X143.208 Y137.999 E.17939
G1 X143.208 Y137.459 E.01626
G1 X138.459 Y142.208 E.20238
G1 X137.92 Y142.208 E.01626
G1 X143.208 Y136.92 E.22538
G1 X143.208 Y136.38 E.01626
G1 X137.38 Y142.208 E.24837
G1 X136.84 Y142.208 E.01626
G1 X143.208 Y135.84 E.27137
G1 X143.208 Y135.301 E.01626
M73 P45 R15
G1 X136.301 Y142.208 E.29436
G1 X135.761 Y142.208 E.01626
G1 X143.208 Y134.761 E.31736
G1 X143.208 Y134.222 E.01626
G1 X135.222 Y142.208 E.34035
G1 X134.682 Y142.208 E.01626
G1 X143.098 Y133.792 E.35866
G1 X142.558 Y133.792 E.01626
G1 X134.292 Y142.058 E.35229
G1 X134.292 Y141.519 E.01626
G1 X142.019 Y133.792 E.3293
G1 X141.479 Y133.792 E.01626
G1 X134.292 Y140.979 E.3063
G1 X134.292 Y140.44 E.01626
G1 X140.94 Y133.792 E.28331
G1 X140.4 Y133.792 E.01626
G1 X134.292 Y139.9 E.26031
G1 X134.292 Y139.361 E.01626
G1 X139.861 Y133.792 E.23732
G1 X139.321 Y133.792 E.01626
G1 X134.292 Y138.821 E.21432
G1 X134.292 Y138.281 E.01626
G1 X138.781 Y133.792 E.19133
G1 X138.242 Y133.792 E.01626
G1 X134.292 Y137.742 E.16833
G1 X134.292 Y137.202 E.01626
G1 X137.702 Y133.792 E.14534
G1 X137.163 Y133.792 E.01626
G1 X134.292 Y136.663 E.12234
G1 X134.292 Y136.123 E.01626
G1 X136.623 Y133.792 E.09935
G1 X136.084 Y133.792 E.01626
G1 X134.168 Y135.708 E.08163
G1 X133.629 Y135.708 E.01626
G1 X135.544 Y133.792 E.08163
G1 X135.005 Y133.792 E.01626
G1 X133.089 Y135.708 E.08163
G1 X132.55 Y135.708 E.01626
G1 X134.465 Y133.792 E.08163
G1 X133.926 Y133.792 E.01626
G1 X132.01 Y135.708 E.08163
G1 X131.471 Y135.708 E.01626
G1 X133.386 Y133.792 E.08163
G1 X132.847 Y133.792 E.01626
G1 X130.931 Y135.708 E.08163
G1 X130.392 Y135.708 E.01626
G1 X132.307 Y133.792 E.08163
G1 X132.208 Y133.792 E.00299
G1 X132.208 Y133.352 E.01327
G1 X129.852 Y135.708 E.1004
G1 X129.313 Y135.708 E.01626
G1 X132.208 Y132.813 E.12339
G1 X132.208 Y132.273 E.01626
G1 X128.773 Y135.708 E.14639
G1 X128.292 Y135.708 E.01449
G1 X128.292 Y135.649 E.00177
G1 X132.208 Y131.733 E.16687
G1 X132.208 Y131.194 E.01626
G1 X128.292 Y135.109 E.16687
G1 X128.292 Y134.57 E.01626
G1 X132.208 Y130.654 E.16687
G1 X132.208 Y130.115 E.01626
G1 X128.292 Y134.03 E.16687
G1 X128.292 Y133.491 E.01626
G1 X132.208 Y129.575 E.16687
G1 X132.208 Y129.036 E.01626
G1 X128.292 Y132.951 E.16687
G1 X128.292 Y132.412 E.01626
G1 X132.208 Y128.496 E.16687
G1 X132.208 Y127.957 E.01626
G1 X128.292 Y131.872 E.16687
G1 X128.292 Y131.333 E.01626
G1 X132.208 Y127.417 E.16687
G1 X132.208 Y126.878 E.01626
G1 X128.292 Y130.793 E.16687
G1 X128.292 Y130.254 E.01626
G1 X132.208 Y126.338 E.16687
G1 X132.208 Y125.799 E.01626
G1 X128.292 Y129.714 E.16687
G1 X128.292 Y129.174 E.01626
G1 X132.208 Y125.259 E.16687
G1 X132.208 Y124.719 E.01626
G1 X128.292 Y128.635 E.16687
G1 X128.292 Y128.095 E.01626
G1 X132.208 Y124.18 E.16687
G1 X132.208 Y123.64 E.01626
G1 X128.292 Y127.556 E.16687
G1 X128.292 Y127.016 E.01626
G1 X132.208 Y123.101 E.16687
G1 X132.208 Y122.561 E.01626
G1 X128.292 Y126.477 E.16687
G1 X128.292 Y125.937 E.01626
G1 X132.208 Y122.022 E.16687
G1 X132.208 Y121.482 E.01626
G1 X128.292 Y125.398 E.16687
G1 X128.292 Y124.858 E.01626
G1 X132.208 Y120.943 E.16687
G1 X132.208 Y120.403 E.01626
G1 X128.292 Y124.319 E.16687
G1 X128.292 Y123.779 E.01626
G1 X132.208 Y119.864 E.16687
G1 X132.208 Y119.324 E.01626
G1 X128.292 Y123.24 E.16687
G1 X128.292 Y122.7 E.01626
G1 X132.377 Y118.615 E.1741
; WIPE_START
G1 X130.963 Y120.029 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.523 Y118.98 Z.8 F30000
G1 X142.866 Y118.377 Z.8
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X143.208 Y118.036 E.01456
G1 X143.208 Y117.496 E.01626
G1 X142.496 Y118.208 E.03032
G1 X141.957 Y118.208 E.01626
G1 X143.208 Y116.957 E.05332
G1 X143.208 Y116.417 E.01626
G1 X141.417 Y118.208 E.07631
G1 X140.878 Y118.208 E.01626
G1 X143.208 Y115.878 E.09931
G1 X143.208 Y115.338 E.01626
G1 X140.338 Y118.208 E.1223
G1 X139.799 Y118.208 E.01626
G1 X143.208 Y114.799 E.1453
G1 X143.208 Y114.259 E.01626
G1 X139.259 Y118.208 E.16829
G1 X138.72 Y118.208 E.01626
G1 X143.208 Y113.719 E.19129
G1 X143.208 Y113.18 E.01626
G1 X138.18 Y118.208 E.21428
G1 X137.64 Y118.208 E.01626
G1 X143.208 Y112.64 E.23727
G1 X143.208 Y112.101 E.01626
G1 X137.101 Y118.208 E.26027
G1 X136.561 Y118.208 E.01626
G1 X143.208 Y111.561 E.28326
G1 X143.208 Y111.022 E.01626
G1 X136.022 Y118.208 E.30626
G1 X135.482 Y118.208 E.01626
G1 X143.208 Y110.482 E.32925
G1 X143.208 Y109.943 E.01626
G1 X134.943 Y118.208 E.35225
G1 X134.403 Y118.208 E.01626
G1 X142.819 Y109.792 E.35866
G1 X142.279 Y109.792 E.01626
G1 X133.864 Y118.208 E.35866
G1 X133.324 Y118.208 E.01626
G1 X141.74 Y109.792 E.35866
G1 X141.2 Y109.792 E.01626
G1 X132.615 Y118.377 E.36589
G1 X128.123 Y122.33 F30000
G1 F3600
G1 X140.66 Y109.792 E.53436
G1 X140.121 Y109.792 E.01626
G1 X134.292 Y115.621 E.24841
G1 X134.292 Y115.081 E.01626
G1 X139.581 Y109.792 E.22542
G1 X139.042 Y109.792 E.01626
G1 X134.292 Y114.542 E.20242
G1 X134.292 Y114.002 E.01626
G1 X138.502 Y109.792 E.17943
G1 X137.963 Y109.792 E.01626
G1 X134.292 Y113.463 E.15643
G1 X134.292 Y112.923 E.01626
G1 X137.423 Y109.792 E.13344
G1 X136.884 Y109.792 E.01626
G1 X134.292 Y112.384 E.11045
G1 X134.292 Y111.844 E.01626
G1 X136.344 Y109.792 E.08745
G1 X135.805 Y109.792 E.01626
G1 X134.292 Y111.305 E.06446
G1 X134.292 Y110.765 E.01626
G1 X135.265 Y109.792 E.04146
G1 X134.726 Y109.792 E.01626
G1 X134.123 Y110.395 E.0257
; WIPE_START
G1 X134.726 Y109.792 E-.32403
G1 X135.265 Y109.792 E-.20502
G1 X134.835 Y110.222 E-.23095
; WIPE_END
G1 E-.04 F1800
G1 X133.791 Y116.123 Z.8 F30000
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X128.292 Y121.621 E.23434
G1 X128.292 Y121.081 E.01626
G1 X133.081 Y116.292 E.20411
G1 X132.542 Y116.292 E.01626
G1 X128.292 Y120.542 E.18112
G1 X128.292 Y120.002 E.01626
G1 X132.002 Y116.292 E.15812
G1 X131.463 Y116.292 E.01626
G1 X128.292 Y119.463 E.13513
G1 X128.292 Y118.923 E.01626
G1 X130.923 Y116.292 E.11213
G1 X130.384 Y116.292 E.01626
G1 X128.292 Y118.384 E.08914
G1 X128.292 Y117.844 E.01626
G1 X129.844 Y116.292 E.06614
G1 X129.305 Y116.292 E.01626
G1 X128.292 Y117.305 E.04315
G1 X128.292 Y116.765 E.01626
G1 X128.935 Y116.123 E.02738
; WIPE_START
G1 X128.292 Y116.765 E-.34528
G1 X128.292 Y117.305 E-.20503
G1 X128.682 Y116.914 E-.20969
; WIPE_END
G1 E-.04 F1800
G1 X128 Y115.755 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y111.744 E.15488
; WIPE_START
G1 X128 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.837 Y108.75 Z.8 F30000
M73 P46 R15
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X132.337 Y108.75 E.06208
; WIPE_START
G1 X130.337 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.958 Y109.176 Z.8 F30000
G1 X143.745 Y109.5 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X150.256 Y109.5 E.2514
; WIPE_START
G1 X148.256 Y109.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.227 Y117.07 Z.8 F30000
G1 X152.377 Y141.604 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42503
G1 F3600
G1 X151.774 Y142.208 E.02575
G1 X151.234 Y142.208 E.01631
G1 X152.208 Y141.234 E.04158
G1 X152.208 Y140.693 E.01631
G1 X150.792 Y142.109 E.06042
G1 X150.792 Y141.568 E.01631
G1 X152.208 Y140.153 E.06042
G1 X152.208 Y139.613 E.01631
G1 X150.792 Y141.028 E.06042
G1 X150.792 Y140.488 E.01631
G1 X152.208 Y139.072 E.06042
G1 X152.208 Y138.532 E.01631
G1 X150.792 Y139.947 E.06042
G1 X150.792 Y139.407 E.01631
G1 X152.208 Y137.991 E.06042
G1 X152.208 Y137.451 E.01631
G1 X150.792 Y138.866 E.06042
G1 X150.792 Y138.326 E.01631
G1 X152.208 Y136.911 E.06042
G1 X152.208 Y136.37 E.01631
G1 X150.792 Y137.786 E.06042
G1 X150.792 Y137.245 E.01631
G1 X152.208 Y135.83 E.06042
G1 X152.208 Y135.29 E.01631
G1 X150.792 Y136.705 E.06042
G1 X150.792 Y136.165 E.01631
G1 X152.208 Y134.749 E.06042
G1 X152.208 Y134.209 E.01631
G1 X150.792 Y135.624 E.06042
G1 X150.792 Y135.084 E.01631
G1 X152.208 Y133.668 E.06042
G1 X152.208 Y133.128 E.01631
G1 X150.792 Y134.543 E.06042
G1 X150.792 Y134.003 E.01631
G1 X152.208 Y132.588 E.06042
G1 X152.208 Y132.047 E.01631
G1 X150.792 Y133.463 E.06042
G1 X150.792 Y132.922 E.01631
G1 X152.208 Y131.507 E.06042
G1 X152.208 Y130.966 E.01631
G1 X150.792 Y132.382 E.06042
G1 X150.792 Y131.841 E.01631
G1 X152.208 Y130.426 E.06042
G1 X152.208 Y129.886 E.01631
G1 X150.792 Y131.301 E.06042
G1 X150.792 Y131.208 E.00282
G1 X150.345 Y131.208 E.01349
G1 X152.208 Y129.345 E.0795
G1 X152.208 Y128.805 E.01631
G1 X149.805 Y131.208 E.10257
G1 X149.264 Y131.208 E.01631
G1 X152.208 Y128.264 E.12564
G1 X152.208 Y127.724 E.01631
G1 X148.724 Y131.208 E.1487
G1 X148.184 Y131.208 E.01631
G1 X152.208 Y127.184 E.17177
G1 X152.208 Y126.643 E.01631
G1 X147.643 Y131.208 E.19484
G1 X147.103 Y131.208 E.01631
G1 X152.208 Y126.103 E.2179
G1 X152.208 Y125.563 E.01631
G1 X146.563 Y131.208 E.24097
G1 X146.022 Y131.208 E.01631
G1 X152.208 Y125.022 E.26404
G1 X152.208 Y124.482 E.01631
G1 X145.792 Y130.897 E.27385
G1 X145.792 Y130.357 E.01631
G1 X152.208 Y123.941 E.27385
G1 X152.208 Y123.401 E.01631
G1 X145.792 Y129.816 E.27385
G1 X145.792 Y129.276 E.01631
G1 X152.208 Y122.861 E.27385
G1 X152.208 Y122.32 E.01631
G1 X145.792 Y128.736 E.27385
G1 X145.792 Y128.195 E.01631
G1 X152.208 Y121.78 E.27385
G1 X152.208 Y121.239 E.01631
G1 X145.792 Y127.655 E.27385
G1 X145.792 Y127.115 E.01631
G1 X152.208 Y120.699 E.27385
G1 X152.208 Y120.159 E.01631
G1 X145.792 Y126.574 E.27385
G1 X145.792 Y126.034 E.01631
G1 X152.208 Y119.618 E.27385
G1 X152.208 Y119.078 E.01631
G1 X145.792 Y125.493 E.27385
G1 X145.792 Y124.953 E.01631
G1 X149.953 Y120.792 E.17761
G1 X149.413 Y120.792 E.01631
G1 X145.792 Y124.413 E.15454
G1 X145.792 Y123.872 E.01631
G1 X148.872 Y120.792 E.13147
G1 X148.332 Y120.792 E.01631
G1 X145.792 Y123.332 E.1084
G1 X145.792 Y122.791 E.01631
G1 X147.791 Y120.792 E.08534
G1 X147.251 Y120.792 E.01631
G1 X145.792 Y122.251 E.06227
G1 X145.792 Y121.711 E.01631
G1 X146.711 Y120.792 E.0392
G1 X146.17 Y120.792 E.01631
G1 X145.623 Y121.34 E.02338
; WIPE_START
G1 X146.17 Y120.792 E-.29433
G1 X146.711 Y120.792 E-.20534
G1 X146.226 Y121.277 E-.26033
; WIPE_END
G1 E-.04 F1800
G1 X150.623 Y120.123 Z.8 F30000
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X152.208 Y118.538 E.06766
G1 X152.208 Y117.997 E.01631
G1 X150.792 Y119.413 E.06042
G1 X150.792 Y118.872 E.01631
G1 X152.208 Y117.457 E.06042
G1 X152.208 Y116.916 E.01631
G1 X150.792 Y118.332 E.06042
G1 X150.792 Y117.791 E.01631
G1 X152.208 Y116.376 E.06042
G1 X152.208 Y115.836 E.01631
G1 X150.792 Y117.251 E.06042
G1 X150.792 Y116.711 E.01631
G1 X152.208 Y115.295 E.06042
G1 X152.208 Y114.755 E.01631
G1 X150.792 Y116.17 E.06042
G1 X150.792 Y115.63 E.01631
G1 X152.208 Y114.214 E.06042
G1 X152.208 Y113.674 E.01631
G1 X150.792 Y115.09 E.06042
G1 X150.792 Y114.549 E.01631
G1 X152.208 Y113.134 E.06042
G1 X152.208 Y112.593 E.01631
G1 X150.792 Y114.009 E.06042
G1 X150.792 Y113.468 E.01631
G1 X152.208 Y112.053 E.06042
G1 X152.208 Y111.513 E.01631
G1 X150.792 Y112.928 E.06042
G1 X150.792 Y112.388 E.01631
G1 X152.208 Y110.972 E.06042
G1 X152.208 Y110.432 E.01631
G1 X150.792 Y111.847 E.06042
G1 X150.792 Y111.307 E.01631
G1 X152.208 Y109.891 E.06042
G1 X152.208 Y109.792 E.00299
G1 X151.766 Y109.792 E.01332
G1 X150.792 Y110.766 E.04158
G1 X150.792 Y110.226 E.01631
G1 X151.396 Y109.623 E.02576
; WIPE_START
G1 X150.792 Y110.226 E-.32429
G1 X150.792 Y110.766 E-.20534
G1 X151.221 Y110.338 E-.23036
; WIPE_END
G1 E-.04 F1800
G1 X150.992 Y117.967 Z.8 F30000
G1 X150.256 Y142.5 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X143.745 Y142.5 E.2514
; WIPE_START
G1 X145.745 Y142.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.113 Y142.395 Z.8 F30000
G1 X109.5 Y142 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y142 E.55165
G1 X126.895 Y141.605 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X109.105 Y141.605 E.52987
G1 X109.105 Y142.363 E.02256
G1 X109.169 Y142.395 E.00212
G1 X126.873 Y142.395 E.52733
G1 X126.895 Y141.665 E.02173
G1 X127.272 Y141.228 F30000
G1 F3600
G1 X108.728 Y141.228 E.55233
G1 X108.728 Y142.552 E.03944
G1 X108.817 Y142.597 E.00296
G1 X108.876 Y142.772 E.0055
G1 X127.124 Y142.772 E.54353
G1 X127.183 Y142.597 E.0055
G1 X127.272 Y142.552 E.00297
G1 X127.272 Y141.288 E.03765
G1 X127.649 Y140.851 F30000
G1 F3600
G1 X108.351 Y140.851 E.5748
G1 X108.351 Y142.749 E.05653
G1 X108.517 Y142.824 E.00541
G1 X108.555 Y143.149 E.00974
G1 X127.445 Y143.149 E.56268
G1 X127.483 Y142.824 E.00974
G1 X127.649 Y142.734 E.0056
G1 X127.649 Y140.911 E.0543
G1 X108.163 Y143.25 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y143.25 E.06208
; WIPE_START
G1 X105.663 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y141.927 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y137.073 E.24736
; WIPE_START
G1 X102.75 Y139.073 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X105.75 Y133.75 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4469
G1 F3600
G1 X105.75 Y118.31 E.49271
G1 X106.141 Y118.25 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X106.141 Y117.859 E.01163
G1 X105.359 Y117.859 E.02326
G1 X105.359 Y134.141 E.48494
G1 X106.141 Y134.141 E.02326
G1 X106.141 Y118.31 E.47153
G1 X106.518 Y118.25 F30000
G1 F3600
G1 X106.518 Y117.482 E.02286
G1 X104.982 Y117.482 E.04573
G1 X104.982 Y134.518 E.50741
G1 X106.518 Y134.518 E.04573
G1 X106.518 Y118.31 E.48276
G1 X106.895 Y118.25 F30000
G1 F3600
G1 X106.895 Y117.105 E.03409
G1 X104.605 Y117.105 E.06819
G1 X104.605 Y134.895 E.52987
G1 X106.895 Y134.895 E.06819
G1 X106.895 Y118.31 E.49399
G1 X107.272 Y118.25 F30000
G1 F3600
G1 X107.272 Y116.728 E.04533
G1 X104.228 Y116.728 E.09065
G1 X104.228 Y135.272 E.55233
G1 X107.272 Y135.272 E.09065
G1 X107.272 Y118.31 E.50522
G1 X107.649 Y118.25 F30000
G1 F3600
G1 X107.649 Y116.351 E.05656
G1 X103.851 Y116.351 E.11311
G1 X103.851 Y135.649 E.5748
G1 X107.649 Y135.649 E.11311
G1 X107.649 Y118.31 E.51645
; WIPE_START
G1 X107.649 Y120.31 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108 Y115.755 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y111.744 E.15487
; WIPE_START
G1 X108 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.5 Y110 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y110 E.55165
G1 X126.895 Y110.395 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X126.895 Y109.637 E.02256
G1 X126.831 Y109.605 E.00212
G1 X109.127 Y109.605 E.52733
G1 X109.105 Y110.395 E.02352
G1 X126.835 Y110.395 E.52808
G1 X127.272 Y110.772 F30000
G1 F3600
G1 X127.272 Y109.448 E.03944
G1 X127.183 Y109.403 E.00297
G1 X127.124 Y109.228 E.0055
G1 X108.876 Y109.228 E.54353
G1 X108.817 Y109.403 E.0055
G1 X108.728 Y109.448 E.00296
G1 X108.728 Y110.772 E.03944
G1 X127.212 Y110.772 E.55055
G1 X127.649 Y111.149 F30000
G1 F3600
G1 X127.649 Y109.266 E.05609
G1 X127.483 Y109.176 E.0056
G1 X127.445 Y108.851 E.00974
G1 X108.555 Y108.851 E.56268
G1 X108.517 Y109.176 E.00974
G1 X108.351 Y109.266 E.0056
G1 X108.351 Y111.149 E.05609
G1 X127.589 Y111.149 E.57301
G1 X108.163 Y108.75 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y108.75 E.06208
; WIPE_START
G1 X105.663 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y110.073 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y114.927 E.24736
; WIPE_START
G1 X102.75 Y112.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X104.427 Y120.373 Z.8 F30000
G1 X108 Y136.245 Z.8
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y140.256 E.15487
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F4909.984
G1 X108 Y138.256 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 3/27
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
G17
G3 Z.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X129.29 Y142.552
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y142.552 E.02708
G1 X128.448 Y136.448 E.19629
G1 X133.552 Y136.448 E.16413
G1 X133.552 Y142.552 E.19629
G1 X129.33 Y142.552 E.13577
G1 X128.855 Y141.71 F30000
G1 F3600
G1 X128.855 Y136.855 E.15612
G1 X133.145 Y136.855 E.13795
G1 X133.145 Y142.145 E.17011
G1 X128.855 Y142.145 E.13795
G1 X128.855 Y141.75 E.0127
M204 S250
G1 X129.29 Y141.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
M73 P47 R15
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y141.71 Z1 F30000
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y142.959 E.04017
G1 X132.541 Y142.959 E.1447
G1 X132.541 Y143.541 E.01871
G1 X103.459 Y143.541 E.93516
G1 X103.459 Y142.959 E.01871
G1 X107.959 Y142.959 E.1447
G1 X107.959 Y140.459 E.08039
G1 X128.041 Y140.459 E.64576
G1 X128.041 Y141.67 E.03894
; WIPE_START
G1 X128.041 Y142.959 E-.48987
G1 X128.752 Y142.959 E-.27013
; WIPE_END
G1 E-.04 F1800
G1 X121.47 Y140.673 Z1 F30000
G1 X106.71 Y136.041 Z1
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X103.459 Y136.041 E.10454
G1 X103.459 Y115.959 E.64576
G1 X108.041 Y115.959 E.14733
G1 X108.041 Y136.041 E.64576
G1 X106.75 Y136.041 E.04151
; WIPE_START
G1 X104.75 Y136.041 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y140.052 Z1 F30000
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X108.448 Y140.052 E.02708
G1 X108.448 Y111.948 E.90373
G1 X127.552 Y111.948 E.61432
G1 X127.552 Y140.052 E.90373
G1 X109.33 Y140.052 E.58595
G1 X109.29 Y139.645 F30000
G1 F3600
G1 X108.855 Y139.645 E.01399
G1 X108.855 Y112.355 E.87755
G1 X127.145 Y112.355 E.58814
G1 X127.145 Y139.645 E.87755
G1 X109.33 Y139.645 E.57287
M204 S250
G1 X109.29 Y139.21 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.747 Y130.987 Z1 F30000
G1 X128.448 Y110.29 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y109.448 E.02708
G1 X133.552 Y109.448 E.16413
G1 X133.552 Y115.552 E.19629
G1 X128.448 Y115.552 E.16413
G1 X128.448 Y110.33 E.16792
G1 X129.29 Y109.855 F30000
G1 F3600
G1 X133.145 Y109.855 E.12396
G1 X133.145 Y115.145 E.17011
G1 X128.855 Y115.145 E.13795
G1 X128.855 Y109.855 E.17011
G1 X129.25 Y109.855 E.0127
M204 S250
G1 X129.29 Y110.29 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y110.29 Z1 F30000
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y111.541 E.04022
G1 X107.959 Y111.541 E.64576
G1 X107.959 Y109.041 E.08039
G1 X103.459 Y109.041 E.1447
G1 X103.459 Y108.459 E.01871
G1 X132.541 Y108.459 E.93516
G1 X132.541 Y109.041 E.01871
G1 X128.041 Y109.041 E.1447
G1 X128.041 Y110.25 E.03888
; WIPE_START
G1 X128.041 Y111.541 E-.49053
G1 X127.332 Y111.541 E-.26947
; WIPE_END
G1 E-.04 F1800
G1 X134.944 Y110.987 Z1 F30000
G1 X149.21 Y109.948 Z1
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X150.052 Y109.948 E.02708
G1 X150.052 Y120.052 E.32491
G1 X145.052 Y120.052 E.16078
G1 X145.052 Y131.948 E.38253
G1 X150.052 Y131.948 E.16078
G1 X150.052 Y142.052 E.32491
G1 X143.948 Y142.052 E.19629
G1 X143.948 Y133.052 E.28941
G1 X132.948 Y133.052 E.35372
G1 X132.948 Y118.948 E.45354
G1 X143.948 Y118.948 E.35372
G1 X143.948 Y109.948 E.28941
G1 X149.17 Y109.948 E.16792
G1 X149.21 Y110.355 F30000
G1 F3600
G1 X149.645 Y110.355 E.01399
G1 X149.645 Y119.645 E.29873
G1 X144.645 Y119.645 E.16078
G1 X144.645 Y132.355 E.40871
G1 X149.645 Y132.355 E.16078
G1 X149.645 Y141.645 E.29873
G1 X144.355 Y141.645 E.17011
G1 X144.355 Y132.645 E.28941
G1 X133.355 Y132.645 E.35372
G1 X133.355 Y119.355 E.42736
G1 X144.355 Y119.355 E.35372
G1 X144.355 Y110.355 E.28941
G1 X149.17 Y110.355 E.15483
; WIPE_START
G1 X149.645 Y110.355 E-.1805
G1 X149.645 Y111.88 E-.5795
; WIPE_END
G1 E-.04 F1800
G1 X147.674 Y119.253 Z1 F30000
G1 X144.21 Y132.21 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
M73 P47 R14
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X144.584 Y124.924 Z1 F30000
G1 X149.21 Y110.79 Z1
G1 Z.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.191 Y120.422 Z1 F30000
G1 X149.21 Y132.79 Z1
G1 Z.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.541 Y133.459 Z1 F30000
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X143.541 Y142.541 E.29204
G1 X133.959 Y142.541 E.30811
G1 X133.959 Y136.041 E.20902
G1 X127.959 Y136.041 E.19294
G1 X127.959 Y115.959 E.64576
G1 X133.959 Y115.959 E.19294
G1 X133.959 Y109.459 E.20902
G1 X143.541 Y109.459 E.30811
G1 X143.541 Y118.541 E.29204
G1 X132.541 Y118.541 E.35372
G1 X132.541 Y133.459 E.47972
G1 X143.501 Y133.459 E.35243
; WIPE_START
G1 X143.51 Y135.459 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.238 Y128.025 Z1 F30000
G1 X145.459 Y127.074 Z1
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X145.459 Y120.459 E.21272
G1 X150.459 Y120.459 E.16078
G1 X150.459 Y109.459 E.35372
G1 X152.541 Y109.459 E.06694
G1 X152.541 Y142.541 E1.06379
G1 X150.459 Y142.541 E.06694
G1 X150.459 Y131.541 E.35372
M73 P48 R14
G1 X145.459 Y131.541 E.16078
G1 X145.459 Y127.114 E.14234
; WIPE_START
G1 X145.459 Y125.114 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.076 Y131.362 Z1 F30000
G1 X132.948 Y142.948 Z1
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X132.948 Y143.948 E.03216
G1 X103.052 Y143.948 E.96134
G1 X103.052 Y142.552 E.04489
G1 X107.552 Y142.552 E.1447
G1 X107.552 Y136.448 E.19629
G1 X103.052 Y136.448 E.1447
G1 X103.052 Y115.552 E.67194
G1 X107.552 Y115.552 E.1447
G1 X107.552 Y109.448 E.19629
G1 X103.052 Y109.448 E.1447
G1 X103.052 Y108.052 E.04489
G1 X132.948 Y108.052 E.96134
G1 X132.948 Y109.052 E.03216
G1 X152.948 Y109.052 E.64313
G1 X152.948 Y142.948 E1.08997
G1 X132.988 Y142.948 E.64184
G1 X133.355 Y143.355 F30000
G1 F3600
G1 X133.355 Y144.355 E.03216
G1 X102.645 Y144.355 E.98752
G1 X102.645 Y142.145 E.07107
G1 X107.145 Y142.145 E.1447
G1 X107.145 Y136.855 E.17011
G1 X102.645 Y136.855 E.1447
G1 X102.645 Y115.145 E.69812
G1 X107.145 Y115.145 E.1447
G1 X107.145 Y109.855 E.17011
G1 X102.645 Y109.855 E.1447
G1 X102.645 Y107.645 E.07107
G1 X133.355 Y107.645 E.98752
G1 X133.355 Y108.645 E.03216
G1 X153.355 Y108.645 E.64313
G1 X153.355 Y143.355 E1.11615
G1 X133.395 Y143.355 E.64184
; WIPE_START
G1 X133.355 Y144.355 E-.3803
G1 X132.356 Y144.355 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X127.765 Y138.257 Z1 F30000
G1 X106.71 Y110.29 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.694 Y119.922 Z1 F30000
G1 X106.71 Y141.71 Z1
G1 Z.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.323 Y142.242 Z1 F30000
G1 X133.79 Y143.79 Z1
G1 Z.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
G1 X132.791 Y144.79 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X132.337 Y143.25 Z1 F30000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y143.25 E.06208
; WIPE_START
G1 X129.837 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128 Y140.256 Z1 F30000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y136.245 E.15488
; WIPE_START
G1 X128 Y138.245 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.368 Y140.236 Z1 F30000
G1 X143.745 Y142.5 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X150.256 Y142.5 E.2514
; WIPE_START
G1 X148.256 Y142.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.227 Y134.93 Z1 F30000
G1 X152.377 Y110.396 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42503
G1 F3600
G1 X151.774 Y109.792 E.02575
G1 X151.234 Y109.792 E.01631
G1 X152.208 Y110.766 E.04157
G1 X152.208 Y111.307 E.01631
G1 X150.792 Y109.891 E.06042
G1 X150.792 Y110.432 E.01631
G1 X152.208 Y111.847 E.06042
G1 X152.208 Y112.387 E.01631
G1 X150.792 Y110.972 E.06042
G1 X150.792 Y111.512 E.01631
G1 X152.208 Y112.928 E.06042
G1 X152.208 Y113.468 E.01631
G1 X150.792 Y112.053 E.06042
G1 X150.792 Y112.593 E.01631
G1 X152.208 Y114.009 E.06042
G1 X152.208 Y114.549 E.01631
G1 X150.792 Y113.134 E.06042
G1 X150.792 Y113.674 E.01631
G1 X152.208 Y115.089 E.06042
G1 X152.208 Y115.63 E.01631
G1 X150.792 Y114.214 E.06042
G1 X150.792 Y114.755 E.01631
G1 X152.208 Y116.17 E.06042
G1 X152.208 Y116.71 E.01631
G1 X150.792 Y115.295 E.06042
G1 X150.792 Y115.835 E.01631
G1 X152.208 Y117.251 E.06042
G1 X152.208 Y117.791 E.01631
G1 X150.792 Y116.376 E.06042
G1 X150.792 Y116.916 E.01631
M73 P49 R14
G1 X152.208 Y118.332 E.06042
G1 X152.208 Y118.872 E.01631
G1 X150.792 Y117.457 E.06042
G1 X150.792 Y117.997 E.01631
G1 X152.208 Y119.412 E.06042
G1 X152.208 Y119.953 E.01631
G1 X150.792 Y118.537 E.06042
G1 X150.792 Y119.078 E.01631
G1 X152.208 Y120.493 E.06042
G1 X152.208 Y121.034 E.01631
G1 X150.792 Y119.618 E.06042
G1 X150.792 Y120.159 E.01631
G1 X152.208 Y121.574 E.06042
G1 X152.208 Y122.114 E.01631
G1 X150.792 Y120.699 E.06042
G1 X150.792 Y120.792 E.00282
G1 X150.345 Y120.792 E.01349
G1 X152.208 Y122.655 E.0795
G1 X152.208 Y123.195 E.01631
G1 X149.805 Y120.792 E.10257
G1 X149.264 Y120.792 E.01631
G1 X152.208 Y123.735 E.12564
G1 X152.208 Y124.276 E.01631
G1 X148.724 Y120.792 E.1487
G1 X148.184 Y120.792 E.01631
G1 X152.208 Y124.816 E.17177
G1 X152.208 Y125.357 E.01631
G1 X147.643 Y120.792 E.19484
G1 X147.103 Y120.792 E.01631
G1 X152.208 Y125.897 E.2179
G1 X152.208 Y126.437 E.01631
G1 X146.563 Y120.792 E.24097
G1 X146.022 Y120.792 E.01631
G1 X152.208 Y126.978 E.26404
G1 X152.208 Y127.518 E.01631
G1 X145.792 Y121.103 E.27385
G1 X145.792 Y121.643 E.01631
G1 X152.208 Y128.059 E.27385
G1 X152.208 Y128.599 E.01631
G1 X145.792 Y122.184 E.27385
G1 X145.792 Y122.724 E.01631
G1 X152.208 Y129.139 E.27385
G1 X152.208 Y129.68 E.01631
G1 X145.792 Y123.264 E.27385
G1 X145.792 Y123.805 E.01631
G1 X152.208 Y130.22 E.27385
G1 X152.208 Y130.76 E.01631
G1 X145.792 Y124.345 E.27385
G1 X145.792 Y124.885 E.01631
G1 X152.208 Y131.301 E.27385
G1 X152.208 Y131.841 E.01631
G1 X145.792 Y125.426 E.27385
G1 X145.792 Y125.966 E.01631
G1 X152.208 Y132.382 E.27385
G1 X152.208 Y132.922 E.01631
G1 X145.792 Y126.507 E.27385
G1 X145.792 Y127.047 E.01631
G1 X149.953 Y131.208 E.17761
G1 X149.413 Y131.208 E.01631
G1 X145.792 Y127.587 E.15454
G1 X145.792 Y128.128 E.01631
G1 X148.872 Y131.208 E.13147
G1 X148.332 Y131.208 E.01631
G1 X145.792 Y128.668 E.1084
G1 X145.792 Y129.209 E.01631
G1 X147.791 Y131.208 E.08534
G1 X147.251 Y131.208 E.01631
G1 X145.792 Y129.749 E.06227
G1 X145.792 Y130.289 E.01631
G1 X146.711 Y131.208 E.0392
G1 X146.17 Y131.208 E.01631
G1 X145.623 Y130.66 E.02338
; WIPE_START
G1 X146.17 Y131.208 E-.29432
G1 X146.711 Y131.208 E-.20534
G1 X146.226 Y130.723 E-.26034
; WIPE_END
G1 E-.04 F1800
G1 X150.623 Y131.877 Z1 F30000
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X152.208 Y133.462 E.06766
G1 X152.208 Y134.003 E.01631
G1 X150.792 Y132.587 E.06042
G1 X150.792 Y133.128 E.01631
G1 X152.208 Y134.543 E.06042
G1 X152.208 Y135.084 E.01631
G1 X150.792 Y133.668 E.06042
G1 X150.792 Y134.209 E.01631
G1 X152.208 Y135.624 E.06042
G1 X152.208 Y136.164 E.01631
G1 X150.792 Y134.749 E.06042
G1 X150.792 Y135.289 E.01631
G1 X152.208 Y136.705 E.06042
G1 X152.208 Y137.245 E.01631
G1 X150.792 Y135.83 E.06042
G1 X150.792 Y136.37 E.01631
G1 X152.208 Y137.786 E.06042
G1 X152.208 Y138.326 E.01631
G1 X150.792 Y136.91 E.06042
G1 X150.792 Y137.451 E.01631
G1 X152.208 Y138.866 E.06042
G1 X152.208 Y139.407 E.01631
G1 X150.792 Y137.991 E.06042
G1 X150.792 Y138.532 E.01631
G1 X152.208 Y139.947 E.06042
G1 X152.208 Y140.487 E.01631
G1 X150.792 Y139.072 E.06042
G1 X150.792 Y139.612 E.01631
G1 X152.208 Y141.028 E.06042
G1 X152.208 Y141.568 E.01631
G1 X150.792 Y140.153 E.06042
G1 X150.792 Y140.693 E.01631
G1 X152.208 Y142.109 E.06042
G1 X152.208 Y142.208 E.00299
G1 X151.766 Y142.208 E.01332
G1 X150.792 Y141.234 E.04158
G1 X150.792 Y141.774 E.01631
G1 X151.396 Y142.377 E.02576
; WIPE_START
G1 X150.792 Y141.774 E-.32429
G1 X150.792 Y141.234 E-.20535
G1 X151.221 Y141.662 E-.23037
; WIPE_END
G1 E-.04 F1800
G1 X150.992 Y134.033 Z1 F30000
G1 X150.256 Y109.5 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X143.745 Y109.5 E.2514
G1 X143.377 Y110.394 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42443
G1 F3600
G1 X142.775 Y109.792 E.02566
G1 X142.236 Y109.792 E.01626
G1 X143.208 Y110.764 E.04142
G1 X143.208 Y111.304 E.01626
G1 X141.696 Y109.792 E.06441
G1 X141.157 Y109.792 E.01626
G1 X143.208 Y111.843 E.08741
G1 X143.208 Y112.383 E.01626
G1 X140.617 Y109.792 E.1104
G1 X140.078 Y109.792 E.01626
G1 X143.208 Y112.922 E.1334
G1 X143.208 Y113.462 E.01626
G1 X139.538 Y109.792 E.15639
G1 X138.999 Y109.792 E.01626
G1 X143.208 Y114.001 E.17939
G1 X143.208 Y114.541 E.01626
G1 X138.459 Y109.792 E.20238
G1 X137.92 Y109.792 E.01626
G1 X143.208 Y115.08 E.22538
G1 X143.208 Y115.62 E.01626
G1 X137.38 Y109.792 E.24837
G1 X136.84 Y109.792 E.01626
G1 X143.208 Y116.159 E.27137
G1 X143.208 Y116.699 E.01626
G1 X136.301 Y109.792 E.29436
G1 X135.761 Y109.792 E.01626
G1 X143.208 Y117.239 E.31736
G1 X143.208 Y117.778 E.01626
G1 X135.222 Y109.792 E.34035
G1 X134.682 Y109.792 E.01626
G1 X143.098 Y118.208 E.35866
G1 X142.558 Y118.208 E.01626
G1 X134.292 Y109.942 E.35229
G1 X134.292 Y110.481 E.01626
G1 X142.019 Y118.208 E.3293
G1 X141.479 Y118.208 E.01626
G1 X134.292 Y111.021 E.3063
G1 X134.292 Y111.56 E.01626
G1 X140.94 Y118.208 E.28331
G1 X140.4 Y118.208 E.01626
G1 X134.292 Y112.1 E.26031
G1 X134.292 Y112.639 E.01626
G1 X139.861 Y118.208 E.23732
G1 X139.321 Y118.208 E.01626
G1 X134.292 Y113.179 E.21432
G1 X134.292 Y113.719 E.01626
G1 X138.781 Y118.208 E.19133
G1 X138.242 Y118.208 E.01626
G1 X134.292 Y114.258 E.16833
G1 X134.292 Y114.798 E.01626
G1 X137.702 Y118.208 E.14534
G1 X137.163 Y118.208 E.01626
G1 X134.292 Y115.337 E.12234
G1 X134.292 Y115.877 E.01626
G1 X136.623 Y118.208 E.09935
G1 X136.084 Y118.208 E.01626
G1 X134.168 Y116.292 E.08163
G1 X133.629 Y116.292 E.01626
G1 X135.544 Y118.208 E.08163
G1 X135.005 Y118.208 E.01626
G1 X133.089 Y116.292 E.08163
G1 X132.55 Y116.292 E.01626
G1 X134.465 Y118.208 E.08163
G1 X133.926 Y118.208 E.01626
G1 X132.01 Y116.292 E.08163
G1 X131.471 Y116.292 E.01626
G1 X133.386 Y118.208 E.08163
G1 X132.847 Y118.208 E.01626
G1 X130.931 Y116.292 E.08163
G1 X130.392 Y116.292 E.01626
G1 X132.307 Y118.208 E.08163
G1 X132.208 Y118.208 E.00299
G1 X132.208 Y118.648 E.01327
G1 X129.852 Y116.292 E.1004
G1 X129.313 Y116.292 E.01626
G1 X132.208 Y119.187 E.12339
G1 X132.208 Y119.727 E.01626
G1 X128.773 Y116.292 E.14639
G1 X128.292 Y116.292 E.01449
G1 X128.292 Y116.351 E.00177
G1 X132.208 Y120.267 E.16687
G1 X132.208 Y120.806 E.01626
G1 X128.292 Y116.891 E.16687
G1 X128.292 Y117.43 E.01626
G1 X132.208 Y121.346 E.16687
G1 X132.208 Y121.885 E.01626
G1 X128.292 Y117.97 E.16687
G1 X128.292 Y118.509 E.01626
G1 X132.208 Y122.425 E.16687
G1 X132.208 Y122.964 E.01626
G1 X128.292 Y119.049 E.16687
G1 X128.292 Y119.588 E.01626
G1 X132.208 Y123.504 E.16687
G1 X132.208 Y124.043 E.01626
G1 X128.292 Y120.128 E.16687
G1 X128.292 Y120.667 E.01626
G1 X132.208 Y124.583 E.16687
G1 X132.208 Y125.122 E.01626
G1 X128.292 Y121.207 E.16687
G1 X128.292 Y121.746 E.01626
G1 X132.208 Y125.662 E.16687
G1 X132.208 Y126.201 E.01626
G1 X128.292 Y122.286 E.16687
G1 X128.292 Y122.826 E.01626
G1 X132.208 Y126.741 E.16687
G1 X132.208 Y127.28 E.01626
G1 X128.292 Y123.365 E.16687
G1 X128.292 Y123.905 E.01626
G1 X132.208 Y127.82 E.16687
G1 X132.208 Y128.36 E.01626
G1 X128.292 Y124.444 E.16687
G1 X128.292 Y124.984 E.01626
G1 X132.208 Y128.899 E.16687
G1 X132.208 Y129.439 E.01626
G1 X128.292 Y125.523 E.16687
G1 X128.292 Y126.063 E.01626
G1 X132.208 Y129.978 E.16687
G1 X132.208 Y130.518 E.01626
G1 X128.292 Y126.602 E.16687
G1 X128.292 Y127.142 E.01626
G1 X132.208 Y131.057 E.16687
G1 X132.208 Y131.597 E.01626
G1 X128.292 Y127.681 E.16687
G1 X128.292 Y128.221 E.01626
G1 X132.208 Y132.136 E.16687
G1 X132.208 Y132.676 E.01626
G1 X128.292 Y128.76 E.16687
G1 X128.292 Y129.3 E.01626
G1 X132.377 Y133.385 E.1741
; WIPE_START
G1 X130.963 Y131.971 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.523 Y133.02 Z1 F30000
G1 X142.866 Y133.623 Z1
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X143.208 Y133.964 E.01456
G1 X143.208 Y134.504 E.01626
G1 X142.496 Y133.792 E.03032
G1 X141.957 Y133.792 E.01626
G1 X143.208 Y135.043 E.05332
G1 X143.208 Y135.583 E.01626
G1 X141.417 Y133.792 E.07631
G1 X140.878 Y133.792 E.01626
G1 X143.208 Y136.122 E.09931
G1 X143.208 Y136.662 E.01626
G1 X140.338 Y133.792 E.1223
G1 X139.799 Y133.792 E.01626
G1 X143.208 Y137.201 E.1453
G1 X143.208 Y137.741 E.01626
G1 X139.259 Y133.792 E.16829
G1 X138.72 Y133.792 E.01626
G1 X143.208 Y138.28 E.19128
G1 X143.208 Y138.82 E.01626
G1 X138.18 Y133.792 E.21428
G1 X137.64 Y133.792 E.01626
G1 X143.208 Y139.36 E.23727
G1 X143.208 Y139.899 E.01626
G1 X137.101 Y133.792 E.26027
G1 X136.561 Y133.792 E.01626
M73 P50 R14
G1 X143.208 Y140.439 E.28326
G1 X143.208 Y140.978 E.01626
G1 X136.022 Y133.792 E.30626
G1 X135.482 Y133.792 E.01626
G1 X143.208 Y141.518 E.32925
G1 X143.208 Y142.057 E.01626
G1 X134.943 Y133.792 E.35225
G1 X134.403 Y133.792 E.01626
G1 X142.819 Y142.208 E.35866
G1 X142.279 Y142.208 E.01626
G1 X133.864 Y133.792 E.35866
G1 X133.324 Y133.792 E.01626
G1 X141.74 Y142.208 E.35866
G1 X141.2 Y142.208 E.01626
G1 X132.615 Y133.623 E.36589
G1 X128.123 Y129.67 F30000
G1 F3600
G1 X140.66 Y142.208 E.53436
G1 X140.121 Y142.208 E.01626
G1 X134.292 Y136.379 E.24841
G1 X134.292 Y136.919 E.01626
G1 X139.581 Y142.208 E.22542
G1 X139.042 Y142.208 E.01626
G1 X134.292 Y137.458 E.20242
G1 X134.292 Y137.998 E.01626
G1 X138.502 Y142.208 E.17943
G1 X137.963 Y142.208 E.01626
G1 X134.292 Y138.537 E.15643
G1 X134.292 Y139.077 E.01626
G1 X137.423 Y142.208 E.13344
G1 X136.884 Y142.208 E.01626
G1 X134.292 Y139.616 E.11045
G1 X134.292 Y140.156 E.01626
G1 X136.344 Y142.208 E.08745
G1 X135.805 Y142.208 E.01626
G1 X134.292 Y140.695 E.06446
G1 X134.292 Y141.235 E.01626
G1 X135.265 Y142.208 E.04146
G1 X134.726 Y142.208 E.01626
G1 X134.123 Y141.605 E.0257
; WIPE_START
G1 X134.726 Y142.208 E-.32403
G1 X135.265 Y142.208 E-.20503
G1 X134.835 Y141.778 E-.23095
; WIPE_END
G1 E-.04 F1800
G1 X133.791 Y135.877 Z1 F30000
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X128.292 Y130.379 E.23434
G1 X128.292 Y130.919 E.01626
G1 X133.081 Y135.708 E.20411
G1 X132.542 Y135.708 E.01626
G1 X128.292 Y131.458 E.18112
G1 X128.292 Y131.998 E.01626
G1 X132.002 Y135.708 E.15812
G1 X131.463 Y135.708 E.01626
G1 X128.292 Y132.537 E.13513
G1 X128.292 Y133.077 E.01626
G1 X130.923 Y135.708 E.11213
G1 X130.384 Y135.708 E.01626
G1 X128.292 Y133.616 E.08914
G1 X128.292 Y134.156 E.01626
G1 X129.844 Y135.708 E.06614
G1 X129.305 Y135.708 E.01626
G1 X128.292 Y134.695 E.04315
G1 X128.292 Y135.235 E.01626
G1 X128.935 Y135.877 E.02738
; WIPE_START
G1 X128.292 Y135.235 E-.34528
G1 X128.292 Y134.695 E-.20503
G1 X128.682 Y135.086 E-.20969
; WIPE_END
G1 E-.04 F1800
G1 X128.413 Y127.458 Z1 F30000
G1 X128 Y115.755 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y111.744 E.15488
; WIPE_START
G1 X128 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.837 Y108.75 Z1 F30000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X132.337 Y108.75 E.06208
G1 X109.5 Y110 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y110 E.55165
G1 X126.895 Y110.395 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X126.895 Y109.637 E.02256
G1 X126.831 Y109.605 E.00212
G1 X109.127 Y109.605 E.52733
G1 X109.105 Y110.395 E.02352
G1 X126.835 Y110.395 E.52808
G1 X127.272 Y110.772 F30000
G1 F3600
G1 X127.272 Y109.448 E.03944
G1 X127.183 Y109.403 E.00297
G1 X127.124 Y109.228 E.0055
G1 X108.876 Y109.228 E.54353
G1 X108.817 Y109.403 E.0055
G1 X108.728 Y109.448 E.00296
G1 X108.728 Y110.772 E.03944
G1 X127.212 Y110.772 E.55055
G1 X127.649 Y111.149 F30000
G1 F3600
G1 X127.649 Y109.266 E.05609
G1 X127.483 Y109.176 E.0056
G1 X127.445 Y108.851 E.00974
G1 X108.555 Y108.851 E.56268
G1 X108.517 Y109.176 E.00974
G1 X108.351 Y109.266 E.0056
G1 X108.351 Y111.149 E.05609
G1 X127.589 Y111.149 E.57301
G1 X108.163 Y108.75 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y108.75 E.06208
; WIPE_START
G1 X105.663 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y110.073 Z1 F30000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y114.927 E.24736
; WIPE_START
G1 X102.75 Y112.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108 Y115.755 Z1 F30000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y111.744 E.15487
; WIPE_START
G1 X108 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X107.147 Y121.329 Z1 F30000
G1 X105.75 Y133.75 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4469
G1 F3600
G1 X105.75 Y118.31 E.49271
G1 X106.141 Y118.25 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X106.141 Y117.859 E.01163
G1 X105.359 Y117.859 E.02326
G1 X105.359 Y134.141 E.48494
G1 X106.141 Y134.141 E.02326
G1 X106.141 Y118.31 E.47153
G1 X106.518 Y118.25 F30000
G1 F3600
G1 X106.518 Y117.482 E.02286
G1 X104.982 Y117.482 E.04573
G1 X104.982 Y134.518 E.50741
G1 X106.518 Y134.518 E.04573
G1 X106.518 Y118.31 E.48276
G1 X106.895 Y118.25 F30000
G1 F3600
G1 X106.895 Y117.105 E.03409
G1 X104.605 Y117.105 E.06819
G1 X104.605 Y134.895 E.52987
G1 X106.895 Y134.895 E.06819
G1 X106.895 Y118.31 E.49399
G1 X107.272 Y118.25 F30000
G1 F3600
G1 X107.272 Y116.728 E.04533
G1 X104.228 Y116.728 E.09065
G1 X104.228 Y135.272 E.55233
G1 X107.272 Y135.272 E.09065
G1 X107.272 Y118.31 E.50522
G1 X107.649 Y118.25 F30000
G1 F3600
G1 X107.649 Y116.351 E.05656
G1 X103.851 Y116.351 E.11311
G1 X103.851 Y135.649 E.5748
G1 X107.649 Y135.649 E.11311
G1 X107.649 Y118.31 E.51645
; WIPE_START
G1 X107.649 Y120.31 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X107.817 Y127.941 Z1 F30000
G1 X108 Y136.245 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y140.256 E.15487
; WIPE_START
G1 X108 Y138.256 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.5 Y142 Z1 F30000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y142 E.55165
G1 X126.895 Y141.605 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X109.105 Y141.605 E.52987
G1 X109.105 Y142.363 E.02256
G1 X109.169 Y142.395 E.00212
G1 X126.873 Y142.395 E.52733
G1 X126.895 Y141.665 E.02173
G1 X127.272 Y141.228 F30000
G1 F3600
G1 X108.728 Y141.228 E.55233
G1 X108.728 Y142.552 E.03944
G1 X108.817 Y142.597 E.00296
G1 X108.876 Y142.772 E.0055
G1 X127.124 Y142.772 E.54353
G1 X127.183 Y142.597 E.0055
G1 X127.272 Y142.552 E.00297
G1 X127.272 Y141.288 E.03765
G1 X127.649 Y140.851 F30000
G1 F3600
G1 X108.351 Y140.851 E.5748
G1 X108.351 Y142.749 E.05653
G1 X108.517 Y142.824 E.00541
G1 X108.555 Y143.149 E.00974
G1 X127.445 Y143.149 E.56268
G1 X127.483 Y142.824 E.00974
G1 X127.649 Y142.734 E.0056
G1 X127.649 Y140.911 E.0543
G1 X108.163 Y143.25 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y143.25 E.06208
; WIPE_START
G1 X105.663 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y141.927 Z1 F30000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y137.073 E.24736
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3720.872
G1 X102.75 Y139.073 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 4/27
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
M106 S51
G17
G3 Z1 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X129.29 Y142.552
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y142.552 E.02708
G1 X128.448 Y136.448 E.19629
G1 X133.552 Y136.448 E.16413
G1 X133.552 Y142.552 E.19629
G1 X129.33 Y142.552 E.13577
G1 X128.855 Y141.71 F30000
G1 F3600
G1 X128.855 Y136.855 E.15612
G1 X133.145 Y136.855 E.13795
G1 X133.145 Y142.145 E.17011
G1 X128.855 Y142.145 E.13795
G1 X128.855 Y141.75 E.0127
M204 S250
G1 X129.29 Y141.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y141.71 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y142.959 E.04017
G1 X132.541 Y142.959 E.1447
G1 X132.541 Y143.541 E.01871
G1 X103.459 Y143.541 E.93516
G1 X103.459 Y142.959 E.01871
G1 X107.959 Y142.959 E.1447
G1 X107.959 Y140.459 E.08039
G1 X128.041 Y140.459 E.64576
G1 X128.041 Y141.67 E.03894
; WIPE_START
G1 X128.041 Y142.959 E-.48987
G1 X128.752 Y142.959 E-.27013
; WIPE_END
G1 E-.04 F1800
G1 X121.47 Y140.673 Z1.2 F30000
G1 X106.71 Y136.041 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X103.459 Y136.041 E.10454
G1 X103.459 Y115.959 E.64576
G1 X108.041 Y115.959 E.14733
G1 X108.041 Y136.041 E.64576
G1 X106.75 Y136.041 E.04151
; WIPE_START
G1 X104.75 Y136.041 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y140.052 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X108.448 Y140.052 E.02708
G1 X108.448 Y111.948 E.90373
G1 X127.552 Y111.948 E.61432
G1 X127.552 Y140.052 E.90373
G1 X109.33 Y140.052 E.58595
G1 X109.29 Y139.645 F30000
G1 F3600
M73 P51 R14
G1 X108.855 Y139.645 E.01399
G1 X108.855 Y112.355 E.87755
G1 X127.145 Y112.355 E.58814
G1 X127.145 Y139.645 E.87755
G1 X109.33 Y139.645 E.57287
M204 S250
G1 X109.29 Y139.21 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.747 Y130.987 Z1.2 F30000
G1 X128.448 Y110.29 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y109.448 E.02708
G1 X133.552 Y109.448 E.16413
G1 X133.552 Y115.552 E.19629
G1 X128.448 Y115.552 E.16413
M73 P51 R13
G1 X128.448 Y110.33 E.16792
G1 X129.29 Y109.855 F30000
G1 F3600
G1 X133.145 Y109.855 E.12396
G1 X133.145 Y115.145 E.17011
G1 X128.855 Y115.145 E.13795
G1 X128.855 Y109.855 E.17011
G1 X129.25 Y109.855 E.0127
M204 S250
G1 X129.29 Y110.29 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y110.29 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y111.541 E.04022
G1 X107.959 Y111.541 E.64576
G1 X107.959 Y109.041 E.08039
G1 X103.459 Y109.041 E.1447
G1 X103.459 Y108.459 E.01871
G1 X132.541 Y108.459 E.93516
G1 X132.541 Y109.041 E.01871
G1 X128.041 Y109.041 E.1447
G1 X128.041 Y110.25 E.03888
; WIPE_START
G1 X128.041 Y111.541 E-.49053
G1 X127.332 Y111.541 E-.26947
; WIPE_END
G1 E-.04 F1800
G1 X134.944 Y110.987 Z1.2 F30000
G1 X149.21 Y109.948 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X150.052 Y109.948 E.02708
G1 X150.052 Y120.052 E.32491
G1 X145.052 Y120.052 E.16078
G1 X145.052 Y131.948 E.38253
G1 X150.052 Y131.948 E.16078
G1 X150.052 Y142.052 E.32491
G1 X143.948 Y142.052 E.19629
G1 X143.948 Y133.052 E.28941
G1 X132.948 Y133.052 E.35372
G1 X132.948 Y118.948 E.45354
G1 X143.948 Y118.948 E.35372
G1 X143.948 Y109.948 E.28941
G1 X149.17 Y109.948 E.16792
G1 X149.21 Y110.355 F30000
G1 F3600
G1 X149.645 Y110.355 E.01399
G1 X149.645 Y119.645 E.29873
G1 X144.645 Y119.645 E.16078
G1 X144.645 Y132.355 E.40871
G1 X149.645 Y132.355 E.16078
G1 X149.645 Y141.645 E.29873
G1 X144.355 Y141.645 E.17011
G1 X144.355 Y132.645 E.28941
G1 X133.355 Y132.645 E.35372
G1 X133.355 Y119.355 E.42736
G1 X144.355 Y119.355 E.35372
G1 X144.355 Y110.355 E.28941
G1 X149.17 Y110.355 E.15483
; WIPE_START
G1 X149.645 Y110.355 E-.1805
G1 X149.645 Y111.88 E-.5795
; WIPE_END
G1 E-.04 F1800
G1 X147.674 Y119.253 Z1.2 F30000
G1 X144.21 Y132.21 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X144.584 Y124.924 Z1.2 F30000
G1 X149.21 Y110.79 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.191 Y120.422 Z1.2 F30000
G1 X149.21 Y132.79 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.541 Y133.459 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X143.541 Y142.541 E.29204
G1 X133.959 Y142.541 E.30811
G1 X133.959 Y136.041 E.20902
G1 X127.959 Y136.041 E.19294
G1 X127.959 Y115.959 E.64576
G1 X133.959 Y115.959 E.19294
G1 X133.959 Y109.459 E.20902
G1 X143.541 Y109.459 E.30811
G1 X143.541 Y118.541 E.29204
G1 X132.541 Y118.541 E.35372
G1 X132.541 Y133.459 E.47972
G1 X143.501 Y133.459 E.35243
; WIPE_START
G1 X143.51 Y135.459 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.238 Y128.025 Z1.2 F30000
G1 X145.459 Y127.074 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X145.459 Y120.459 E.21272
G1 X150.459 Y120.459 E.16078
G1 X150.459 Y109.459 E.35372
G1 X152.541 Y109.459 E.06694
G1 X152.541 Y142.541 E1.06379
G1 X150.459 Y142.541 E.06694
G1 X150.459 Y131.541 E.35372
G1 X145.459 Y131.541 E.16078
G1 X145.459 Y127.114 E.14234
; WIPE_START
G1 X145.459 Y125.114 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.076 Y131.362 Z1.2 F30000
G1 X132.948 Y142.948 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X132.948 Y143.948 E.03216
G1 X103.052 Y143.948 E.96134
G1 X103.052 Y142.552 E.04489
G1 X107.552 Y142.552 E.1447
G1 X107.552 Y136.448 E.19629
G1 X103.052 Y136.448 E.1447
G1 X103.052 Y115.552 E.67194
G1 X107.552 Y115.552 E.1447
G1 X107.552 Y109.448 E.19629
G1 X103.052 Y109.448 E.1447
G1 X103.052 Y108.052 E.04489
G1 X132.948 Y108.052 E.96134
G1 X132.948 Y109.052 E.03216
G1 X152.948 Y109.052 E.64313
G1 X152.948 Y142.948 E1.08997
G1 X132.988 Y142.948 E.64184
G1 X133.355 Y143.355 F30000
G1 F3600
M73 P52 R13
G1 X133.355 Y144.355 E.03216
G1 X102.645 Y144.355 E.98752
G1 X102.645 Y142.145 E.07107
G1 X107.145 Y142.145 E.1447
G1 X107.145 Y136.855 E.17011
G1 X102.645 Y136.855 E.1447
G1 X102.645 Y115.145 E.69812
G1 X107.145 Y115.145 E.1447
G1 X107.145 Y109.855 E.17011
G1 X102.645 Y109.855 E.1447
G1 X102.645 Y107.645 E.07107
G1 X133.355 Y107.645 E.98752
G1 X133.355 Y108.645 E.03216
G1 X153.355 Y108.645 E.64313
G1 X153.355 Y143.355 E1.11615
G1 X133.395 Y143.355 E.64184
; WIPE_START
G1 X133.355 Y144.355 E-.3803
G1 X132.356 Y144.355 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X127.765 Y138.257 Z1.2 F30000
G1 X106.71 Y110.29 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.694 Y119.922 Z1.2 F30000
G1 X106.71 Y141.71 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.323 Y142.242 Z1.2 F30000
G1 X133.79 Y143.79 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
G1 X132.791 Y144.79 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X132.337 Y143.25 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y143.25 E.06208
; WIPE_START
G1 X129.837 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128 Y140.256 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y136.245 E.15488
; WIPE_START
G1 X128 Y138.245 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.456 Y139.874 Z1.2 F30000
G1 X143.377 Y141.606 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42443
G1 F3600
G1 X142.775 Y142.208 E.02566
G1 X142.236 Y142.208 E.01626
G1 X143.208 Y141.236 E.04142
G1 X143.208 Y140.696 E.01626
G1 X141.696 Y142.208 E.06441
G1 X141.157 Y142.208 E.01626
G1 X143.208 Y140.157 E.08741
G1 X143.208 Y139.617 E.01626
G1 X140.617 Y142.208 E.1104
G1 X140.078 Y142.208 E.01626
G1 X143.208 Y139.078 E.1334
G1 X143.208 Y138.538 E.01626
G1 X139.538 Y142.208 E.15639
G1 X138.999 Y142.208 E.01626
G1 X143.208 Y137.999 E.17939
G1 X143.208 Y137.459 E.01626
G1 X138.459 Y142.208 E.20238
G1 X137.92 Y142.208 E.01626
G1 X143.208 Y136.92 E.22538
G1 X143.208 Y136.38 E.01626
G1 X137.38 Y142.208 E.24837
G1 X136.84 Y142.208 E.01626
G1 X143.208 Y135.84 E.27137
G1 X143.208 Y135.301 E.01626
G1 X136.301 Y142.208 E.29436
G1 X135.761 Y142.208 E.01626
G1 X143.208 Y134.761 E.31736
G1 X143.208 Y134.222 E.01626
G1 X135.222 Y142.208 E.34035
G1 X134.682 Y142.208 E.01626
G1 X143.098 Y133.792 E.35866
G1 X142.558 Y133.792 E.01626
G1 X134.292 Y142.058 E.35229
G1 X134.292 Y141.519 E.01626
G1 X142.019 Y133.792 E.3293
G1 X141.479 Y133.792 E.01626
G1 X134.292 Y140.979 E.3063
G1 X134.292 Y140.44 E.01626
G1 X140.94 Y133.792 E.28331
G1 X140.4 Y133.792 E.01626
G1 X134.292 Y139.9 E.26031
G1 X134.292 Y139.361 E.01626
G1 X139.861 Y133.792 E.23732
G1 X139.321 Y133.792 E.01626
G1 X134.292 Y138.821 E.21432
G1 X134.292 Y138.281 E.01626
G1 X138.781 Y133.792 E.19133
G1 X138.242 Y133.792 E.01626
G1 X134.292 Y137.742 E.16833
G1 X134.292 Y137.202 E.01626
G1 X137.702 Y133.792 E.14534
G1 X137.163 Y133.792 E.01626
G1 X134.292 Y136.663 E.12234
G1 X134.292 Y136.123 E.01626
G1 X136.623 Y133.792 E.09935
G1 X136.084 Y133.792 E.01626
G1 X134.168 Y135.708 E.08163
G1 X133.629 Y135.708 E.01626
G1 X135.544 Y133.792 E.08163
G1 X135.005 Y133.792 E.01626
G1 X133.089 Y135.708 E.08163
G1 X132.55 Y135.708 E.01626
G1 X134.465 Y133.792 E.08163
G1 X133.926 Y133.792 E.01626
G1 X132.01 Y135.708 E.08163
G1 X131.471 Y135.708 E.01626
G1 X133.386 Y133.792 E.08163
G1 X132.847 Y133.792 E.01626
G1 X130.931 Y135.708 E.08163
G1 X130.392 Y135.708 E.01626
G1 X132.307 Y133.792 E.08163
M73 P53 R13
G1 X132.208 Y133.792 E.00299
G1 X132.208 Y133.352 E.01327
G1 X129.852 Y135.708 E.1004
G1 X129.313 Y135.708 E.01626
G1 X132.208 Y132.813 E.12339
G1 X132.208 Y132.273 E.01626
G1 X128.773 Y135.708 E.14639
G1 X128.292 Y135.708 E.01449
G1 X128.292 Y135.649 E.00177
G1 X132.208 Y131.733 E.16687
G1 X132.208 Y131.194 E.01626
G1 X128.292 Y135.109 E.16687
G1 X128.292 Y134.57 E.01626
G1 X132.208 Y130.654 E.16687
G1 X132.208 Y130.115 E.01626
G1 X128.292 Y134.03 E.16687
G1 X128.292 Y133.491 E.01626
G1 X132.208 Y129.575 E.16687
G1 X132.208 Y129.036 E.01626
G1 X128.292 Y132.951 E.16687
G1 X128.292 Y132.412 E.01626
G1 X132.208 Y128.496 E.16687
G1 X132.208 Y127.957 E.01626
G1 X128.292 Y131.872 E.16687
G1 X128.292 Y131.333 E.01626
G1 X132.208 Y127.417 E.16687
G1 X132.208 Y126.878 E.01626
G1 X128.292 Y130.793 E.16687
G1 X128.292 Y130.254 E.01626
G1 X132.208 Y126.338 E.16687
G1 X132.208 Y125.799 E.01626
G1 X128.292 Y129.714 E.16687
G1 X128.292 Y129.174 E.01626
G1 X132.208 Y125.259 E.16687
G1 X132.208 Y124.719 E.01626
G1 X128.292 Y128.635 E.16687
G1 X128.292 Y128.095 E.01626
G1 X132.208 Y124.18 E.16687
G1 X132.208 Y123.64 E.01626
G1 X128.292 Y127.556 E.16687
G1 X128.292 Y127.016 E.01626
G1 X132.208 Y123.101 E.16687
G1 X132.208 Y122.561 E.01626
G1 X128.292 Y126.477 E.16687
G1 X128.292 Y125.937 E.01626
G1 X132.208 Y122.022 E.16687
G1 X132.208 Y121.482 E.01626
G1 X128.292 Y125.398 E.16687
G1 X128.292 Y124.858 E.01626
G1 X132.208 Y120.943 E.16687
G1 X132.208 Y120.403 E.01626
G1 X128.292 Y124.319 E.16687
G1 X128.292 Y123.779 E.01626
G1 X132.208 Y119.864 E.16687
G1 X132.208 Y119.324 E.01626
G1 X128.292 Y123.24 E.16687
G1 X128.292 Y122.7 E.01626
G1 X132.377 Y118.615 E.1741
; WIPE_START
G1 X130.963 Y120.029 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.523 Y118.98 Z1.2 F30000
G1 X142.866 Y118.377 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X143.208 Y118.036 E.01456
G1 X143.208 Y117.496 E.01626
G1 X142.496 Y118.208 E.03032
G1 X141.957 Y118.208 E.01626
G1 X143.208 Y116.957 E.05332
G1 X143.208 Y116.417 E.01626
G1 X141.417 Y118.208 E.07631
G1 X140.878 Y118.208 E.01626
G1 X143.208 Y115.878 E.09931
G1 X143.208 Y115.338 E.01626
G1 X140.338 Y118.208 E.1223
G1 X139.799 Y118.208 E.01626
G1 X143.208 Y114.799 E.1453
G1 X143.208 Y114.259 E.01626
G1 X139.259 Y118.208 E.16829
G1 X138.72 Y118.208 E.01626
G1 X143.208 Y113.719 E.19129
G1 X143.208 Y113.18 E.01626
G1 X138.18 Y118.208 E.21428
G1 X137.64 Y118.208 E.01626
G1 X143.208 Y112.64 E.23727
G1 X143.208 Y112.101 E.01626
G1 X137.101 Y118.208 E.26027
G1 X136.561 Y118.208 E.01626
G1 X143.208 Y111.561 E.28326
G1 X143.208 Y111.022 E.01626
G1 X136.022 Y118.208 E.30626
G1 X135.482 Y118.208 E.01626
G1 X143.208 Y110.482 E.32925
G1 X143.208 Y109.943 E.01626
G1 X134.943 Y118.208 E.35225
G1 X134.403 Y118.208 E.01626
G1 X142.819 Y109.792 E.35866
G1 X142.279 Y109.792 E.01626
G1 X133.864 Y118.208 E.35866
G1 X133.324 Y118.208 E.01626
G1 X141.74 Y109.792 E.35866
G1 X141.2 Y109.792 E.01626
G1 X132.615 Y118.377 E.36589
G1 X128.123 Y122.33 F30000
G1 F3600
G1 X140.66 Y109.792 E.53436
G1 X140.121 Y109.792 E.01626
G1 X134.292 Y115.621 E.24841
G1 X134.292 Y115.081 E.01626
G1 X139.581 Y109.792 E.22542
G1 X139.042 Y109.792 E.01626
G1 X134.292 Y114.542 E.20242
G1 X134.292 Y114.002 E.01626
G1 X138.502 Y109.792 E.17943
G1 X137.963 Y109.792 E.01626
G1 X134.292 Y113.463 E.15643
G1 X134.292 Y112.923 E.01626
G1 X137.423 Y109.792 E.13344
G1 X136.884 Y109.792 E.01626
G1 X134.292 Y112.384 E.11045
G1 X134.292 Y111.844 E.01626
G1 X136.344 Y109.792 E.08745
G1 X135.805 Y109.792 E.01626
G1 X134.292 Y111.305 E.06446
G1 X134.292 Y110.765 E.01626
G1 X135.265 Y109.792 E.04146
G1 X134.726 Y109.792 E.01626
G1 X134.123 Y110.395 E.0257
; WIPE_START
G1 X134.726 Y109.792 E-.32403
G1 X135.265 Y109.792 E-.20502
G1 X134.835 Y110.222 E-.23095
; WIPE_END
G1 E-.04 F1800
G1 X133.791 Y116.123 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X128.292 Y121.621 E.23434
G1 X128.292 Y121.081 E.01626
G1 X133.081 Y116.292 E.20411
G1 X132.542 Y116.292 E.01626
G1 X128.292 Y120.542 E.18112
G1 X128.292 Y120.002 E.01626
G1 X132.002 Y116.292 E.15812
G1 X131.463 Y116.292 E.01626
G1 X128.292 Y119.463 E.13513
G1 X128.292 Y118.923 E.01626
G1 X130.923 Y116.292 E.11213
G1 X130.384 Y116.292 E.01626
G1 X128.292 Y118.384 E.08914
G1 X128.292 Y117.844 E.01626
G1 X129.844 Y116.292 E.06614
G1 X129.305 Y116.292 E.01626
G1 X128.292 Y117.305 E.04315
G1 X128.292 Y116.765 E.01626
G1 X128.935 Y116.123 E.02738
; WIPE_START
G1 X128.292 Y116.765 E-.34528
G1 X128.292 Y117.305 E-.20503
G1 X128.682 Y116.914 E-.20969
; WIPE_END
G1 E-.04 F1800
G1 X128 Y115.755 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y111.744 E.15488
; WIPE_START
G1 X128 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.837 Y108.75 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X132.337 Y108.75 E.06208
; WIPE_START
G1 X130.337 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.958 Y109.176 Z1.2 F30000
G1 X143.745 Y109.5 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X150.256 Y109.5 E.2514
; WIPE_START
G1 X148.256 Y109.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.227 Y117.07 Z1.2 F30000
G1 X152.377 Y141.604 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42503
G1 F3600
G1 X151.774 Y142.208 E.02575
G1 X151.234 Y142.208 E.01631
G1 X152.208 Y141.234 E.04158
G1 X152.208 Y140.693 E.01631
G1 X150.792 Y142.109 E.06042
G1 X150.792 Y141.568 E.01631
G1 X152.208 Y140.153 E.06042
G1 X152.208 Y139.613 E.01631
G1 X150.792 Y141.028 E.06042
G1 X150.792 Y140.488 E.01631
G1 X152.208 Y139.072 E.06042
G1 X152.208 Y138.532 E.01631
G1 X150.792 Y139.947 E.06042
G1 X150.792 Y139.407 E.01631
G1 X152.208 Y137.991 E.06042
G1 X152.208 Y137.451 E.01631
G1 X150.792 Y138.866 E.06042
G1 X150.792 Y138.326 E.01631
G1 X152.208 Y136.911 E.06042
G1 X152.208 Y136.37 E.01631
G1 X150.792 Y137.786 E.06042
G1 X150.792 Y137.245 E.01631
G1 X152.208 Y135.83 E.06042
G1 X152.208 Y135.29 E.01631
G1 X150.792 Y136.705 E.06042
G1 X150.792 Y136.165 E.01631
G1 X152.208 Y134.749 E.06042
G1 X152.208 Y134.209 E.01631
G1 X150.792 Y135.624 E.06042
G1 X150.792 Y135.084 E.01631
G1 X152.208 Y133.668 E.06042
G1 X152.208 Y133.128 E.01631
G1 X150.792 Y134.543 E.06042
G1 X150.792 Y134.003 E.01631
G1 X152.208 Y132.588 E.06042
G1 X152.208 Y132.047 E.01631
G1 X150.792 Y133.463 E.06042
G1 X150.792 Y132.922 E.01631
G1 X152.208 Y131.507 E.06042
G1 X152.208 Y130.966 E.01631
G1 X150.792 Y132.382 E.06042
G1 X150.792 Y131.841 E.01631
G1 X152.208 Y130.426 E.06042
G1 X152.208 Y129.886 E.01631
G1 X150.792 Y131.301 E.06042
G1 X150.792 Y131.208 E.00282
G1 X150.345 Y131.208 E.01349
G1 X152.208 Y129.345 E.0795
G1 X152.208 Y128.805 E.01631
G1 X149.805 Y131.208 E.10257
G1 X149.264 Y131.208 E.01631
G1 X152.208 Y128.264 E.12564
G1 X152.208 Y127.724 E.01631
G1 X148.724 Y131.208 E.1487
G1 X148.184 Y131.208 E.01631
G1 X152.208 Y127.184 E.17177
G1 X152.208 Y126.643 E.01631
G1 X147.643 Y131.208 E.19484
G1 X147.103 Y131.208 E.01631
G1 X152.208 Y126.103 E.2179
G1 X152.208 Y125.563 E.01631
G1 X146.563 Y131.208 E.24097
G1 X146.022 Y131.208 E.01631
G1 X152.208 Y125.022 E.26404
G1 X152.208 Y124.482 E.01631
G1 X145.792 Y130.897 E.27385
G1 X145.792 Y130.357 E.01631
G1 X152.208 Y123.941 E.27385
G1 X152.208 Y123.401 E.01631
G1 X145.792 Y129.816 E.27385
G1 X145.792 Y129.276 E.01631
G1 X152.208 Y122.861 E.27385
G1 X152.208 Y122.32 E.01631
G1 X145.792 Y128.736 E.27385
G1 X145.792 Y128.195 E.01631
G1 X152.208 Y121.78 E.27385
G1 X152.208 Y121.239 E.01631
G1 X145.792 Y127.655 E.27385
G1 X145.792 Y127.115 E.01631
G1 X152.208 Y120.699 E.27385
G1 X152.208 Y120.159 E.01631
G1 X145.792 Y126.574 E.27385
G1 X145.792 Y126.034 E.01631
G1 X152.208 Y119.618 E.27385
G1 X152.208 Y119.078 E.01631
G1 X145.792 Y125.493 E.27385
G1 X145.792 Y124.953 E.01631
G1 X149.953 Y120.792 E.17761
G1 X149.413 Y120.792 E.01631
G1 X145.792 Y124.413 E.15454
G1 X145.792 Y123.872 E.01631
G1 X148.872 Y120.792 E.13147
G1 X148.332 Y120.792 E.01631
G1 X145.792 Y123.332 E.1084
M73 P54 R13
G1 X145.792 Y122.791 E.01631
G1 X147.791 Y120.792 E.08534
G1 X147.251 Y120.792 E.01631
G1 X145.792 Y122.251 E.06227
G1 X145.792 Y121.711 E.01631
G1 X146.711 Y120.792 E.0392
G1 X146.17 Y120.792 E.01631
G1 X145.623 Y121.34 E.02338
; WIPE_START
G1 X146.17 Y120.792 E-.29433
G1 X146.711 Y120.792 E-.20534
G1 X146.226 Y121.277 E-.26033
; WIPE_END
G1 E-.04 F1800
G1 X150.623 Y120.123 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X152.208 Y118.538 E.06766
G1 X152.208 Y117.997 E.01631
G1 X150.792 Y119.413 E.06042
G1 X150.792 Y118.872 E.01631
G1 X152.208 Y117.457 E.06042
G1 X152.208 Y116.916 E.01631
G1 X150.792 Y118.332 E.06042
G1 X150.792 Y117.791 E.01631
G1 X152.208 Y116.376 E.06042
G1 X152.208 Y115.836 E.01631
G1 X150.792 Y117.251 E.06042
G1 X150.792 Y116.711 E.01631
G1 X152.208 Y115.295 E.06042
G1 X152.208 Y114.755 E.01631
G1 X150.792 Y116.17 E.06042
G1 X150.792 Y115.63 E.01631
G1 X152.208 Y114.214 E.06042
G1 X152.208 Y113.674 E.01631
G1 X150.792 Y115.09 E.06042
G1 X150.792 Y114.549 E.01631
G1 X152.208 Y113.134 E.06042
G1 X152.208 Y112.593 E.01631
G1 X150.792 Y114.009 E.06042
G1 X150.792 Y113.468 E.01631
G1 X152.208 Y112.053 E.06042
G1 X152.208 Y111.513 E.01631
G1 X150.792 Y112.928 E.06042
G1 X150.792 Y112.388 E.01631
G1 X152.208 Y110.972 E.06042
G1 X152.208 Y110.432 E.01631
G1 X150.792 Y111.847 E.06042
G1 X150.792 Y111.307 E.01631
G1 X152.208 Y109.891 E.06042
G1 X152.208 Y109.792 E.00299
G1 X151.766 Y109.792 E.01332
G1 X150.792 Y110.766 E.04158
G1 X150.792 Y110.226 E.01631
G1 X151.396 Y109.623 E.02576
; WIPE_START
G1 X150.792 Y110.226 E-.32429
G1 X150.792 Y110.766 E-.20534
G1 X151.221 Y110.338 E-.23036
; WIPE_END
G1 E-.04 F1800
G1 X150.992 Y117.967 Z1.2 F30000
G1 X150.256 Y142.5 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X143.745 Y142.5 E.2514
; WIPE_START
G1 X145.745 Y142.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.113 Y142.395 Z1.2 F30000
G1 X109.5 Y142 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y142 E.55165
G1 X126.895 Y141.605 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X109.105 Y141.605 E.52987
G1 X109.105 Y142.363 E.02256
G1 X109.169 Y142.395 E.00212
G1 X126.873 Y142.395 E.52733
G1 X126.895 Y141.665 E.02173
G1 X127.272 Y141.228 F30000
G1 F3600
G1 X108.728 Y141.228 E.55233
G1 X108.728 Y142.552 E.03944
G1 X108.817 Y142.597 E.00296
G1 X108.876 Y142.772 E.0055
G1 X127.124 Y142.772 E.54353
G1 X127.183 Y142.597 E.0055
G1 X127.272 Y142.552 E.00297
G1 X127.272 Y141.288 E.03765
G1 X127.649 Y140.851 F30000
G1 F3600
G1 X108.351 Y140.851 E.5748
G1 X108.351 Y142.749 E.05653
G1 X108.517 Y142.824 E.00541
G1 X108.555 Y143.149 E.00974
G1 X127.445 Y143.149 E.56268
G1 X127.483 Y142.824 E.00974
G1 X127.649 Y142.734 E.0056
G1 X127.649 Y140.911 E.0543
G1 X108.163 Y143.25 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y143.25 E.06208
; WIPE_START
G1 X105.663 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y141.927 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y137.073 E.24736
; WIPE_START
G1 X102.75 Y139.073 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X105.75 Y133.75 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4469
G1 F3600
G1 X105.75 Y118.31 E.49271
G1 X106.141 Y118.25 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X106.141 Y117.859 E.01163
G1 X105.359 Y117.859 E.02326
G1 X105.359 Y134.141 E.48494
G1 X106.141 Y134.141 E.02326
G1 X106.141 Y118.31 E.47153
G1 X106.518 Y118.25 F30000
G1 F3600
G1 X106.518 Y117.482 E.02286
G1 X104.982 Y117.482 E.04573
G1 X104.982 Y134.518 E.50741
G1 X106.518 Y134.518 E.04573
G1 X106.518 Y118.31 E.48276
G1 X106.895 Y118.25 F30000
G1 F3600
G1 X106.895 Y117.105 E.03409
G1 X104.605 Y117.105 E.06819
G1 X104.605 Y134.895 E.52987
G1 X106.895 Y134.895 E.06819
G1 X106.895 Y118.31 E.49399
G1 X107.272 Y118.25 F30000
G1 F3600
G1 X107.272 Y116.728 E.04533
G1 X104.228 Y116.728 E.09065
G1 X104.228 Y135.272 E.55233
G1 X107.272 Y135.272 E.09065
G1 X107.272 Y118.31 E.50522
G1 X107.649 Y118.25 F30000
G1 F3600
G1 X107.649 Y116.351 E.05656
G1 X103.851 Y116.351 E.11311
G1 X103.851 Y135.649 E.5748
G1 X107.649 Y135.649 E.11311
G1 X107.649 Y118.31 E.51645
; WIPE_START
G1 X107.649 Y120.31 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108 Y115.755 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y111.744 E.15487
; WIPE_START
G1 X108 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.5 Y110 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y110 E.55165
G1 X126.895 Y110.395 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X126.895 Y109.637 E.02256
G1 X126.831 Y109.605 E.00212
G1 X109.127 Y109.605 E.52733
G1 X109.105 Y110.395 E.02352
G1 X126.835 Y110.395 E.52808
G1 X127.272 Y110.772 F30000
G1 F3600
G1 X127.272 Y109.448 E.03944
G1 X127.183 Y109.403 E.00297
G1 X127.124 Y109.228 E.0055
G1 X108.876 Y109.228 E.54353
G1 X108.817 Y109.403 E.0055
G1 X108.728 Y109.448 E.00296
G1 X108.728 Y110.772 E.03944
G1 X127.212 Y110.772 E.55055
G1 X127.649 Y111.149 F30000
G1 F3600
G1 X127.649 Y109.266 E.05609
G1 X127.483 Y109.176 E.0056
G1 X127.445 Y108.851 E.00974
G1 X108.555 Y108.851 E.56268
G1 X108.517 Y109.176 E.00974
G1 X108.351 Y109.266 E.0056
G1 X108.351 Y111.149 E.05609
G1 X127.589 Y111.149 E.57301
G1 X108.163 Y108.75 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y108.75 E.06208
; WIPE_START
G1 X105.663 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y110.073 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y114.927 E.24736
; WIPE_START
G1 X102.75 Y112.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X104.427 Y120.373 Z1.2 F30000
G1 X108 Y136.245 Z1.2
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y140.256 E.15487
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F4909.984
G1 X108 Y138.256 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 5/27
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
G17
G3 Z1.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X129.29 Y142.552
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y142.552 E.02708
G1 X128.448 Y136.448 E.19629
G1 X133.552 Y136.448 E.16413
G1 X133.552 Y142.552 E.19629
G1 X129.33 Y142.552 E.13577
G1 X128.855 Y141.71 F30000
G1 F3600
M73 P54 R12
G1 X128.855 Y136.855 E.15612
G1 X133.145 Y136.855 E.13795
G1 X133.145 Y142.145 E.17011
G1 X128.855 Y142.145 E.13795
G1 X128.855 Y141.75 E.0127
M204 S250
G1 X129.29 Y141.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y141.71 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y142.959 E.04017
G1 X132.541 Y142.959 E.1447
G1 X132.541 Y143.541 E.01871
G1 X103.459 Y143.541 E.93516
G1 X103.459 Y142.959 E.01871
G1 X107.959 Y142.959 E.1447
G1 X107.959 Y140.459 E.08039
G1 X128.041 Y140.459 E.64576
G1 X128.041 Y141.67 E.03894
; WIPE_START
G1 X128.041 Y142.959 E-.48987
G1 X128.752 Y142.959 E-.27013
; WIPE_END
G1 E-.04 F1800
G1 X121.47 Y140.673 Z1.4 F30000
G1 X106.71 Y136.041 Z1.4
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X103.459 Y136.041 E.10454
G1 X103.459 Y115.959 E.64576
G1 X108.041 Y115.959 E.14733
G1 X108.041 Y136.041 E.64576
G1 X106.75 Y136.041 E.04151
; WIPE_START
G1 X104.75 Y136.041 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y140.052 Z1.4 F30000
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X108.448 Y140.052 E.02708
G1 X108.448 Y111.948 E.90373
G1 X127.552 Y111.948 E.61432
G1 X127.552 Y140.052 E.90373
G1 X109.33 Y140.052 E.58595
G1 X109.29 Y139.645 F30000
G1 F3600
G1 X108.855 Y139.645 E.01399
G1 X108.855 Y112.355 E.87755
G1 X127.145 Y112.355 E.58814
G1 X127.145 Y139.645 E.87755
G1 X109.33 Y139.645 E.57287
M204 S250
G1 X109.29 Y139.21 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.747 Y130.987 Z1.4 F30000
G1 X128.448 Y110.29 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y109.448 E.02708
G1 X133.552 Y109.448 E.16413
G1 X133.552 Y115.552 E.19629
G1 X128.448 Y115.552 E.16413
G1 X128.448 Y110.33 E.16792
G1 X129.29 Y109.855 F30000
G1 F3600
G1 X133.145 Y109.855 E.12396
G1 X133.145 Y115.145 E.17011
G1 X128.855 Y115.145 E.13795
G1 X128.855 Y109.855 E.17011
G1 X129.25 Y109.855 E.0127
M204 S250
G1 X129.29 Y110.29 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y110.29 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y111.541 E.04022
G1 X107.959 Y111.541 E.64576
G1 X107.959 Y109.041 E.08039
G1 X103.459 Y109.041 E.1447
G1 X103.459 Y108.459 E.01871
M73 P55 R12
G1 X132.541 Y108.459 E.93516
G1 X132.541 Y109.041 E.01871
G1 X128.041 Y109.041 E.1447
G1 X128.041 Y110.25 E.03888
; WIPE_START
G1 X128.041 Y111.541 E-.49053
G1 X127.332 Y111.541 E-.26947
; WIPE_END
G1 E-.04 F1800
G1 X134.944 Y110.987 Z1.4 F30000
G1 X149.21 Y109.948 Z1.4
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X150.052 Y109.948 E.02708
G1 X150.052 Y120.052 E.32491
G1 X145.052 Y120.052 E.16078
G1 X145.052 Y131.948 E.38253
G1 X150.052 Y131.948 E.16078
G1 X150.052 Y142.052 E.32491
G1 X143.948 Y142.052 E.19629
G1 X143.948 Y133.052 E.28941
G1 X132.948 Y133.052 E.35372
G1 X132.948 Y118.948 E.45354
G1 X143.948 Y118.948 E.35372
G1 X143.948 Y109.948 E.28941
G1 X149.17 Y109.948 E.16792
G1 X149.21 Y110.355 F30000
G1 F3600
G1 X149.645 Y110.355 E.01399
G1 X149.645 Y119.645 E.29873
G1 X144.645 Y119.645 E.16078
G1 X144.645 Y132.355 E.40871
G1 X149.645 Y132.355 E.16078
G1 X149.645 Y141.645 E.29873
G1 X144.355 Y141.645 E.17011
G1 X144.355 Y132.645 E.28941
G1 X133.355 Y132.645 E.35372
G1 X133.355 Y119.355 E.42736
G1 X144.355 Y119.355 E.35372
G1 X144.355 Y110.355 E.28941
G1 X149.17 Y110.355 E.15483
; WIPE_START
G1 X149.645 Y110.355 E-.1805
G1 X149.645 Y111.88 E-.5795
; WIPE_END
G1 E-.04 F1800
G1 X147.674 Y119.253 Z1.4 F30000
G1 X144.21 Y132.21 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X144.584 Y124.924 Z1.4 F30000
G1 X149.21 Y110.79 Z1.4
G1 Z1
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.191 Y120.422 Z1.4 F30000
G1 X149.21 Y132.79 Z1.4
G1 Z1
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.541 Y133.459 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X143.541 Y142.541 E.29204
G1 X133.959 Y142.541 E.30811
G1 X133.959 Y136.041 E.20902
G1 X127.959 Y136.041 E.19294
G1 X127.959 Y115.959 E.64576
G1 X133.959 Y115.959 E.19294
G1 X133.959 Y109.459 E.20902
G1 X143.541 Y109.459 E.30811
G1 X143.541 Y118.541 E.29204
G1 X132.541 Y118.541 E.35372
G1 X132.541 Y133.459 E.47972
G1 X143.501 Y133.459 E.35243
; WIPE_START
G1 X143.51 Y135.459 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.238 Y128.025 Z1.4 F30000
G1 X145.459 Y127.074 Z1.4
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X145.459 Y120.459 E.21272
G1 X150.459 Y120.459 E.16078
G1 X150.459 Y109.459 E.35372
G1 X152.541 Y109.459 E.06694
G1 X152.541 Y142.541 E1.06379
G1 X150.459 Y142.541 E.06694
G1 X150.459 Y131.541 E.35372
G1 X145.459 Y131.541 E.16078
G1 X145.459 Y127.114 E.14234
; WIPE_START
G1 X145.459 Y125.114 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.076 Y131.362 Z1.4 F30000
G1 X132.948 Y142.948 Z1.4
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X132.948 Y143.948 E.03216
G1 X103.052 Y143.948 E.96134
G1 X103.052 Y142.552 E.04489
G1 X107.552 Y142.552 E.1447
G1 X107.552 Y136.448 E.19629
G1 X103.052 Y136.448 E.1447
G1 X103.052 Y115.552 E.67194
G1 X107.552 Y115.552 E.1447
G1 X107.552 Y109.448 E.19629
G1 X103.052 Y109.448 E.1447
G1 X103.052 Y108.052 E.04489
G1 X132.948 Y108.052 E.96134
G1 X132.948 Y109.052 E.03216
G1 X152.948 Y109.052 E.64313
G1 X152.948 Y142.948 E1.08997
G1 X132.988 Y142.948 E.64184
G1 X133.355 Y143.355 F30000
G1 F3600
G1 X133.355 Y144.355 E.03216
G1 X102.645 Y144.355 E.98752
G1 X102.645 Y142.145 E.07107
G1 X107.145 Y142.145 E.1447
G1 X107.145 Y136.855 E.17011
G1 X102.645 Y136.855 E.1447
G1 X102.645 Y115.145 E.69812
G1 X107.145 Y115.145 E.1447
G1 X107.145 Y109.855 E.17011
G1 X102.645 Y109.855 E.1447
G1 X102.645 Y107.645 E.07107
G1 X133.355 Y107.645 E.98752
G1 X133.355 Y108.645 E.03216
G1 X153.355 Y108.645 E.64313
G1 X153.355 Y143.355 E1.11615
G1 X133.395 Y143.355 E.64184
; WIPE_START
G1 X133.355 Y144.355 E-.3803
G1 X132.356 Y144.355 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X127.765 Y138.257 Z1.4 F30000
G1 X106.71 Y110.29 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
M73 P56 R12
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.694 Y119.922 Z1.4 F30000
G1 X106.71 Y141.71 Z1.4
G1 Z1
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.323 Y142.242 Z1.4 F30000
G1 X133.79 Y143.79 Z1.4
G1 Z1
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
G1 X132.791 Y144.79 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X132.337 Y143.25 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y143.25 E.06208
; WIPE_START
G1 X129.837 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128 Y140.256 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y136.245 E.15488
; WIPE_START
G1 X128 Y138.245 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.368 Y140.236 Z1.4 F30000
G1 X143.745 Y142.5 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X150.256 Y142.5 E.2514
; WIPE_START
G1 X148.256 Y142.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.227 Y134.93 Z1.4 F30000
G1 X152.377 Y110.396 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42503
G1 F3600
G1 X151.774 Y109.792 E.02575
G1 X151.234 Y109.792 E.01631
G1 X152.208 Y110.766 E.04157
G1 X152.208 Y111.307 E.01631
G1 X150.792 Y109.891 E.06042
G1 X150.792 Y110.432 E.01631
G1 X152.208 Y111.847 E.06042
G1 X152.208 Y112.387 E.01631
G1 X150.792 Y110.972 E.06042
G1 X150.792 Y111.512 E.01631
G1 X152.208 Y112.928 E.06042
G1 X152.208 Y113.468 E.01631
G1 X150.792 Y112.053 E.06042
G1 X150.792 Y112.593 E.01631
G1 X152.208 Y114.009 E.06042
G1 X152.208 Y114.549 E.01631
G1 X150.792 Y113.134 E.06042
G1 X150.792 Y113.674 E.01631
G1 X152.208 Y115.089 E.06042
G1 X152.208 Y115.63 E.01631
G1 X150.792 Y114.214 E.06042
G1 X150.792 Y114.755 E.01631
G1 X152.208 Y116.17 E.06042
G1 X152.208 Y116.71 E.01631
G1 X150.792 Y115.295 E.06042
G1 X150.792 Y115.835 E.01631
G1 X152.208 Y117.251 E.06042
G1 X152.208 Y117.791 E.01631
G1 X150.792 Y116.376 E.06042
G1 X150.792 Y116.916 E.01631
G1 X152.208 Y118.332 E.06042
G1 X152.208 Y118.872 E.01631
G1 X150.792 Y117.457 E.06042
G1 X150.792 Y117.997 E.01631
G1 X152.208 Y119.412 E.06042
G1 X152.208 Y119.953 E.01631
G1 X150.792 Y118.537 E.06042
G1 X150.792 Y119.078 E.01631
G1 X152.208 Y120.493 E.06042
G1 X152.208 Y121.034 E.01631
G1 X150.792 Y119.618 E.06042
G1 X150.792 Y120.159 E.01631
G1 X152.208 Y121.574 E.06042
G1 X152.208 Y122.114 E.01631
G1 X150.792 Y120.699 E.06042
G1 X150.792 Y120.792 E.00282
G1 X150.345 Y120.792 E.01349
G1 X152.208 Y122.655 E.0795
G1 X152.208 Y123.195 E.01631
G1 X149.805 Y120.792 E.10257
G1 X149.264 Y120.792 E.01631
G1 X152.208 Y123.735 E.12564
G1 X152.208 Y124.276 E.01631
G1 X148.724 Y120.792 E.1487
G1 X148.184 Y120.792 E.01631
G1 X152.208 Y124.816 E.17177
G1 X152.208 Y125.357 E.01631
G1 X147.643 Y120.792 E.19484
G1 X147.103 Y120.792 E.01631
G1 X152.208 Y125.897 E.2179
G1 X152.208 Y126.437 E.01631
G1 X146.563 Y120.792 E.24097
G1 X146.022 Y120.792 E.01631
G1 X152.208 Y126.978 E.26404
G1 X152.208 Y127.518 E.01631
G1 X145.792 Y121.103 E.27385
G1 X145.792 Y121.643 E.01631
M73 P57 R12
G1 X152.208 Y128.059 E.27385
G1 X152.208 Y128.599 E.01631
G1 X145.792 Y122.184 E.27385
G1 X145.792 Y122.724 E.01631
G1 X152.208 Y129.139 E.27385
G1 X152.208 Y129.68 E.01631
G1 X145.792 Y123.264 E.27385
G1 X145.792 Y123.805 E.01631
G1 X152.208 Y130.22 E.27385
G1 X152.208 Y130.76 E.01631
G1 X145.792 Y124.345 E.27385
G1 X145.792 Y124.885 E.01631
G1 X152.208 Y131.301 E.27385
G1 X152.208 Y131.841 E.01631
G1 X145.792 Y125.426 E.27385
G1 X145.792 Y125.966 E.01631
G1 X152.208 Y132.382 E.27385
G1 X152.208 Y132.922 E.01631
G1 X145.792 Y126.507 E.27385
G1 X145.792 Y127.047 E.01631
G1 X149.953 Y131.208 E.17761
G1 X149.413 Y131.208 E.01631
G1 X145.792 Y127.587 E.15454
G1 X145.792 Y128.128 E.01631
G1 X148.872 Y131.208 E.13147
G1 X148.332 Y131.208 E.01631
G1 X145.792 Y128.668 E.1084
G1 X145.792 Y129.209 E.01631
G1 X147.791 Y131.208 E.08534
G1 X147.251 Y131.208 E.01631
G1 X145.792 Y129.749 E.06227
G1 X145.792 Y130.289 E.01631
G1 X146.711 Y131.208 E.0392
G1 X146.17 Y131.208 E.01631
G1 X145.623 Y130.66 E.02338
; WIPE_START
G1 X146.17 Y131.208 E-.29432
G1 X146.711 Y131.208 E-.20534
G1 X146.226 Y130.723 E-.26034
; WIPE_END
G1 E-.04 F1800
G1 X150.623 Y131.877 Z1.4 F30000
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X152.208 Y133.462 E.06766
G1 X152.208 Y134.003 E.01631
G1 X150.792 Y132.587 E.06042
G1 X150.792 Y133.128 E.01631
G1 X152.208 Y134.543 E.06042
G1 X152.208 Y135.084 E.01631
G1 X150.792 Y133.668 E.06042
G1 X150.792 Y134.209 E.01631
G1 X152.208 Y135.624 E.06042
G1 X152.208 Y136.164 E.01631
G1 X150.792 Y134.749 E.06042
G1 X150.792 Y135.289 E.01631
G1 X152.208 Y136.705 E.06042
G1 X152.208 Y137.245 E.01631
G1 X150.792 Y135.83 E.06042
G1 X150.792 Y136.37 E.01631
G1 X152.208 Y137.786 E.06042
G1 X152.208 Y138.326 E.01631
G1 X150.792 Y136.91 E.06042
G1 X150.792 Y137.451 E.01631
G1 X152.208 Y138.866 E.06042
G1 X152.208 Y139.407 E.01631
G1 X150.792 Y137.991 E.06042
G1 X150.792 Y138.532 E.01631
G1 X152.208 Y139.947 E.06042
G1 X152.208 Y140.487 E.01631
G1 X150.792 Y139.072 E.06042
G1 X150.792 Y139.612 E.01631
G1 X152.208 Y141.028 E.06042
G1 X152.208 Y141.568 E.01631
G1 X150.792 Y140.153 E.06042
G1 X150.792 Y140.693 E.01631
G1 X152.208 Y142.109 E.06042
G1 X152.208 Y142.208 E.00299
G1 X151.766 Y142.208 E.01332
G1 X150.792 Y141.234 E.04158
G1 X150.792 Y141.774 E.01631
G1 X151.396 Y142.377 E.02576
; WIPE_START
G1 X150.792 Y141.774 E-.32429
G1 X150.792 Y141.234 E-.20535
G1 X151.221 Y141.662 E-.23037
; WIPE_END
G1 E-.04 F1800
G1 X150.992 Y134.033 Z1.4 F30000
G1 X150.256 Y109.5 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X143.745 Y109.5 E.2514
G1 X143.377 Y110.394 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42443
G1 F3600
G1 X142.775 Y109.792 E.02566
G1 X142.236 Y109.792 E.01626
G1 X143.208 Y110.764 E.04142
G1 X143.208 Y111.304 E.01626
G1 X141.696 Y109.792 E.06441
G1 X141.157 Y109.792 E.01626
G1 X143.208 Y111.843 E.08741
G1 X143.208 Y112.383 E.01626
G1 X140.617 Y109.792 E.1104
G1 X140.078 Y109.792 E.01626
G1 X143.208 Y112.922 E.1334
G1 X143.208 Y113.462 E.01626
G1 X139.538 Y109.792 E.15639
G1 X138.999 Y109.792 E.01626
G1 X143.208 Y114.001 E.17939
G1 X143.208 Y114.541 E.01626
G1 X138.459 Y109.792 E.20238
G1 X137.92 Y109.792 E.01626
G1 X143.208 Y115.08 E.22538
G1 X143.208 Y115.62 E.01626
G1 X137.38 Y109.792 E.24837
G1 X136.84 Y109.792 E.01626
G1 X143.208 Y116.159 E.27137
G1 X143.208 Y116.699 E.01626
G1 X136.301 Y109.792 E.29436
G1 X135.761 Y109.792 E.01626
G1 X143.208 Y117.239 E.31736
G1 X143.208 Y117.778 E.01626
G1 X135.222 Y109.792 E.34035
G1 X134.682 Y109.792 E.01626
G1 X143.098 Y118.208 E.35866
G1 X142.558 Y118.208 E.01626
G1 X134.292 Y109.942 E.35229
G1 X134.292 Y110.481 E.01626
G1 X142.019 Y118.208 E.3293
G1 X141.479 Y118.208 E.01626
G1 X134.292 Y111.021 E.3063
G1 X134.292 Y111.56 E.01626
G1 X140.94 Y118.208 E.28331
G1 X140.4 Y118.208 E.01626
G1 X134.292 Y112.1 E.26031
G1 X134.292 Y112.639 E.01626
G1 X139.861 Y118.208 E.23732
G1 X139.321 Y118.208 E.01626
G1 X134.292 Y113.179 E.21432
G1 X134.292 Y113.719 E.01626
G1 X138.781 Y118.208 E.19133
G1 X138.242 Y118.208 E.01626
G1 X134.292 Y114.258 E.16833
G1 X134.292 Y114.798 E.01626
G1 X137.702 Y118.208 E.14534
G1 X137.163 Y118.208 E.01626
G1 X134.292 Y115.337 E.12234
G1 X134.292 Y115.877 E.01626
G1 X136.623 Y118.208 E.09935
G1 X136.084 Y118.208 E.01626
G1 X134.168 Y116.292 E.08163
G1 X133.629 Y116.292 E.01626
G1 X135.544 Y118.208 E.08163
G1 X135.005 Y118.208 E.01626
G1 X133.089 Y116.292 E.08163
G1 X132.55 Y116.292 E.01626
G1 X134.465 Y118.208 E.08163
G1 X133.926 Y118.208 E.01626
G1 X132.01 Y116.292 E.08163
G1 X131.471 Y116.292 E.01626
G1 X133.386 Y118.208 E.08163
G1 X132.847 Y118.208 E.01626
G1 X130.931 Y116.292 E.08163
G1 X130.392 Y116.292 E.01626
G1 X132.307 Y118.208 E.08163
G1 X132.208 Y118.208 E.00299
G1 X132.208 Y118.648 E.01327
G1 X129.852 Y116.292 E.1004
G1 X129.313 Y116.292 E.01626
G1 X132.208 Y119.187 E.12339
G1 X132.208 Y119.727 E.01626
G1 X128.773 Y116.292 E.14639
G1 X128.292 Y116.292 E.01449
G1 X128.292 Y116.351 E.00177
G1 X132.208 Y120.267 E.16687
G1 X132.208 Y120.806 E.01626
G1 X128.292 Y116.891 E.16687
G1 X128.292 Y117.43 E.01626
G1 X132.208 Y121.346 E.16687
G1 X132.208 Y121.885 E.01626
G1 X128.292 Y117.97 E.16687
G1 X128.292 Y118.509 E.01626
G1 X132.208 Y122.425 E.16687
G1 X132.208 Y122.964 E.01626
G1 X128.292 Y119.049 E.16687
G1 X128.292 Y119.588 E.01626
G1 X132.208 Y123.504 E.16687
G1 X132.208 Y124.043 E.01626
G1 X128.292 Y120.128 E.16687
G1 X128.292 Y120.667 E.01626
G1 X132.208 Y124.583 E.16687
G1 X132.208 Y125.122 E.01626
G1 X128.292 Y121.207 E.16687
G1 X128.292 Y121.746 E.01626
G1 X132.208 Y125.662 E.16687
G1 X132.208 Y126.201 E.01626
G1 X128.292 Y122.286 E.16687
G1 X128.292 Y122.826 E.01626
G1 X132.208 Y126.741 E.16687
G1 X132.208 Y127.28 E.01626
G1 X128.292 Y123.365 E.16687
G1 X128.292 Y123.905 E.01626
G1 X132.208 Y127.82 E.16687
G1 X132.208 Y128.36 E.01626
G1 X128.292 Y124.444 E.16687
G1 X128.292 Y124.984 E.01626
G1 X132.208 Y128.899 E.16687
G1 X132.208 Y129.439 E.01626
G1 X128.292 Y125.523 E.16687
G1 X128.292 Y126.063 E.01626
G1 X132.208 Y129.978 E.16687
G1 X132.208 Y130.518 E.01626
G1 X128.292 Y126.602 E.16687
G1 X128.292 Y127.142 E.01626
G1 X132.208 Y131.057 E.16687
G1 X132.208 Y131.597 E.01626
G1 X128.292 Y127.681 E.16687
G1 X128.292 Y128.221 E.01626
G1 X132.208 Y132.136 E.16687
G1 X132.208 Y132.676 E.01626
G1 X128.292 Y128.76 E.16687
G1 X128.292 Y129.3 E.01626
G1 X132.377 Y133.385 E.1741
; WIPE_START
G1 X130.963 Y131.971 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.523 Y133.02 Z1.4 F30000
G1 X142.866 Y133.623 Z1.4
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X143.208 Y133.964 E.01456
G1 X143.208 Y134.504 E.01626
G1 X142.496 Y133.792 E.03032
G1 X141.957 Y133.792 E.01626
G1 X143.208 Y135.043 E.05332
G1 X143.208 Y135.583 E.01626
G1 X141.417 Y133.792 E.07631
G1 X140.878 Y133.792 E.01626
G1 X143.208 Y136.122 E.09931
G1 X143.208 Y136.662 E.01626
G1 X140.338 Y133.792 E.1223
G1 X139.799 Y133.792 E.01626
G1 X143.208 Y137.201 E.1453
G1 X143.208 Y137.741 E.01626
G1 X139.259 Y133.792 E.16829
G1 X138.72 Y133.792 E.01626
G1 X143.208 Y138.28 E.19128
G1 X143.208 Y138.82 E.01626
G1 X138.18 Y133.792 E.21428
G1 X137.64 Y133.792 E.01626
G1 X143.208 Y139.36 E.23727
G1 X143.208 Y139.899 E.01626
G1 X137.101 Y133.792 E.26027
G1 X136.561 Y133.792 E.01626
G1 X143.208 Y140.439 E.28326
G1 X143.208 Y140.978 E.01626
G1 X136.022 Y133.792 E.30626
G1 X135.482 Y133.792 E.01626
G1 X143.208 Y141.518 E.32925
G1 X143.208 Y142.057 E.01626
G1 X134.943 Y133.792 E.35225
G1 X134.403 Y133.792 E.01626
G1 X142.819 Y142.208 E.35866
G1 X142.279 Y142.208 E.01626
G1 X133.864 Y133.792 E.35866
G1 X133.324 Y133.792 E.01626
G1 X141.74 Y142.208 E.35866
G1 X141.2 Y142.208 E.01626
G1 X132.615 Y133.623 E.36589
G1 X128.123 Y129.67 F30000
G1 F3600
G1 X140.66 Y142.208 E.53436
G1 X140.121 Y142.208 E.01626
G1 X134.292 Y136.379 E.24841
G1 X134.292 Y136.919 E.01626
G1 X139.581 Y142.208 E.22542
G1 X139.042 Y142.208 E.01626
G1 X134.292 Y137.458 E.20242
G1 X134.292 Y137.998 E.01626
G1 X138.502 Y142.208 E.17943
G1 X137.963 Y142.208 E.01626
G1 X134.292 Y138.537 E.15643
G1 X134.292 Y139.077 E.01626
G1 X137.423 Y142.208 E.13344
G1 X136.884 Y142.208 E.01626
G1 X134.292 Y139.616 E.11045
G1 X134.292 Y140.156 E.01626
G1 X136.344 Y142.208 E.08745
G1 X135.805 Y142.208 E.01626
G1 X134.292 Y140.695 E.06446
G1 X134.292 Y141.235 E.01626
G1 X135.265 Y142.208 E.04146
G1 X134.726 Y142.208 E.01626
G1 X134.123 Y141.605 E.0257
; WIPE_START
G1 X134.726 Y142.208 E-.32403
G1 X135.265 Y142.208 E-.20503
G1 X134.835 Y141.778 E-.23095
; WIPE_END
G1 E-.04 F1800
G1 X133.791 Y135.877 Z1.4 F30000
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X128.292 Y130.379 E.23434
G1 X128.292 Y130.919 E.01626
G1 X133.081 Y135.708 E.20411
G1 X132.542 Y135.708 E.01626
G1 X128.292 Y131.458 E.18112
G1 X128.292 Y131.998 E.01626
G1 X132.002 Y135.708 E.15812
G1 X131.463 Y135.708 E.01626
G1 X128.292 Y132.537 E.13513
G1 X128.292 Y133.077 E.01626
G1 X130.923 Y135.708 E.11213
G1 X130.384 Y135.708 E.01626
G1 X128.292 Y133.616 E.08914
G1 X128.292 Y134.156 E.01626
G1 X129.844 Y135.708 E.06614
G1 X129.305 Y135.708 E.01626
G1 X128.292 Y134.695 E.04315
G1 X128.292 Y135.235 E.01626
G1 X128.935 Y135.877 E.02738
; WIPE_START
G1 X128.292 Y135.235 E-.34528
G1 X128.292 Y134.695 E-.20503
G1 X128.682 Y135.086 E-.20969
; WIPE_END
G1 E-.04 F1800
G1 X128.413 Y127.458 Z1.4 F30000
G1 X128 Y115.755 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y111.744 E.15488
; WIPE_START
G1 X128 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.837 Y108.75 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X132.337 Y108.75 E.06208
G1 X109.5 Y110 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y110 E.55165
G1 X126.895 Y110.395 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X126.895 Y109.637 E.02256
G1 X126.831 Y109.605 E.00212
G1 X109.127 Y109.605 E.52733
G1 X109.105 Y110.395 E.02352
G1 X126.835 Y110.395 E.52808
G1 X127.272 Y110.772 F30000
G1 F3600
G1 X127.272 Y109.448 E.03944
G1 X127.183 Y109.403 E.00297
G1 X127.124 Y109.228 E.0055
G1 X108.876 Y109.228 E.54353
G1 X108.817 Y109.403 E.0055
G1 X108.728 Y109.448 E.00296
G1 X108.728 Y110.772 E.03944
G1 X127.212 Y110.772 E.55055
G1 X127.649 Y111.149 F30000
G1 F3600
G1 X127.649 Y109.266 E.05609
G1 X127.483 Y109.176 E.0056
G1 X127.445 Y108.851 E.00974
M73 P58 R12
G1 X108.555 Y108.851 E.56268
G1 X108.517 Y109.176 E.00974
G1 X108.351 Y109.266 E.0056
G1 X108.351 Y111.149 E.05609
G1 X127.589 Y111.149 E.57301
G1 X108.163 Y108.75 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y108.75 E.06208
; WIPE_START
G1 X105.663 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y110.073 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y114.927 E.24736
; WIPE_START
G1 X102.75 Y112.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108 Y115.755 Z1.4 F30000
G1 Z1
M73 P58 R11
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y111.744 E.15487
; WIPE_START
G1 X108 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X107.147 Y121.329 Z1.4 F30000
G1 X105.75 Y133.75 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4469
G1 F3600
G1 X105.75 Y118.31 E.49271
G1 X106.141 Y118.25 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X106.141 Y117.859 E.01163
G1 X105.359 Y117.859 E.02326
G1 X105.359 Y134.141 E.48494
G1 X106.141 Y134.141 E.02326
G1 X106.141 Y118.31 E.47153
G1 X106.518 Y118.25 F30000
G1 F3600
G1 X106.518 Y117.482 E.02286
G1 X104.982 Y117.482 E.04573
G1 X104.982 Y134.518 E.50741
G1 X106.518 Y134.518 E.04573
G1 X106.518 Y118.31 E.48276
G1 X106.895 Y118.25 F30000
G1 F3600
G1 X106.895 Y117.105 E.03409
G1 X104.605 Y117.105 E.06819
G1 X104.605 Y134.895 E.52987
G1 X106.895 Y134.895 E.06819
G1 X106.895 Y118.31 E.49399
G1 X107.272 Y118.25 F30000
G1 F3600
G1 X107.272 Y116.728 E.04533
G1 X104.228 Y116.728 E.09065
G1 X104.228 Y135.272 E.55233
G1 X107.272 Y135.272 E.09065
G1 X107.272 Y118.31 E.50522
G1 X107.649 Y118.25 F30000
G1 F3600
G1 X107.649 Y116.351 E.05656
G1 X103.851 Y116.351 E.11311
G1 X103.851 Y135.649 E.5748
G1 X107.649 Y135.649 E.11311
G1 X107.649 Y118.31 E.51645
; WIPE_START
G1 X107.649 Y120.31 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X107.817 Y127.941 Z1.4 F30000
G1 X108 Y136.245 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y140.256 E.15487
; WIPE_START
G1 X108 Y138.256 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.5 Y142 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y142 E.55165
G1 X126.895 Y141.605 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X109.105 Y141.605 E.52987
G1 X109.105 Y142.363 E.02256
G1 X109.169 Y142.395 E.00212
G1 X126.873 Y142.395 E.52733
G1 X126.895 Y141.665 E.02173
G1 X127.272 Y141.228 F30000
G1 F3600
G1 X108.728 Y141.228 E.55233
G1 X108.728 Y142.552 E.03944
G1 X108.817 Y142.597 E.00296
G1 X108.876 Y142.772 E.0055
G1 X127.124 Y142.772 E.54353
G1 X127.183 Y142.597 E.0055
G1 X127.272 Y142.552 E.00297
G1 X127.272 Y141.288 E.03765
G1 X127.649 Y140.851 F30000
G1 F3600
G1 X108.351 Y140.851 E.5748
G1 X108.351 Y142.749 E.05653
G1 X108.517 Y142.824 E.00541
G1 X108.555 Y143.149 E.00974
G1 X127.445 Y143.149 E.56268
G1 X127.483 Y142.824 E.00974
G1 X127.649 Y142.734 E.0056
G1 X127.649 Y140.911 E.0543
G1 X108.163 Y143.25 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y143.25 E.06208
; WIPE_START
G1 X105.663 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y141.927 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y137.073 E.24736
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3720.872
G1 X102.75 Y139.073 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 6/27
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
G17
G3 Z1.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X129.29 Y142.552
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y142.552 E.02708
G1 X128.448 Y136.448 E.19629
G1 X133.552 Y136.448 E.16413
G1 X133.552 Y142.552 E.19629
G1 X129.33 Y142.552 E.13577
G1 X128.855 Y141.71 F30000
G1 F3600
G1 X128.855 Y136.855 E.15612
G1 X133.145 Y136.855 E.13795
G1 X133.145 Y142.145 E.17011
G1 X128.855 Y142.145 E.13795
G1 X128.855 Y141.75 E.0127
M204 S250
G1 X129.29 Y141.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y141.71 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y142.959 E.04017
G1 X132.541 Y142.959 E.1447
G1 X132.541 Y143.541 E.01871
G1 X103.459 Y143.541 E.93516
G1 X103.459 Y142.959 E.01871
G1 X107.959 Y142.959 E.1447
G1 X107.959 Y140.459 E.08039
G1 X128.041 Y140.459 E.64576
G1 X128.041 Y141.67 E.03894
; WIPE_START
G1 X128.041 Y142.959 E-.48987
G1 X128.752 Y142.959 E-.27013
; WIPE_END
G1 E-.04 F1800
G1 X121.47 Y140.673 Z1.6 F30000
G1 X106.71 Y136.041 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F3600
G1 X103.459 Y136.041 E.10454
G1 X103.459 Y115.959 E.64576
G1 X108.041 Y115.959 E.14733
G1 X108.041 Y136.041 E.64576
G1 X106.75 Y136.041 E.04151
; WIPE_START
G1 X104.75 Y136.041 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y140.052 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
G1 F3600
G1 X108.448 Y140.052 E.02708
G1 X108.448 Y111.948 E.90373
G1 X127.552 Y111.948 E.61432
G1 X127.552 Y140.052 E.90373
G1 X109.33 Y140.052 E.58595
G1 X109.29 Y139.645 F30000
G1 F3600
G1 X108.855 Y139.645 E.01399
G1 X108.855 Y112.355 E.87755
G1 X127.145 Y112.355 E.58814
G1 X127.145 Y139.645 E.87755
G1 X109.33 Y139.645 E.57287
M204 S250
G1 X109.29 Y139.21 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.747 Y130.987 Z1.6 F30000
G1 X128.448 Y110.29 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y109.448 E.02708
G1 X133.552 Y109.448 E.16413
G1 X133.552 Y115.552 E.19629
G1 X128.448 Y115.552 E.16413
G1 X128.448 Y110.33 E.16792
G1 X129.29 Y109.855 F30000
G1 F3600
G1 X133.145 Y109.855 E.12396
G1 X133.145 Y115.145 E.17011
G1 X128.855 Y115.145 E.13795
G1 X128.855 Y109.855 E.17011
G1 X129.25 Y109.855 E.0127
M204 S250
G1 X129.29 Y110.29 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y110.29 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y111.541 E.04022
G1 X107.959 Y111.541 E.64576
G1 X107.959 Y109.041 E.08039
G1 X103.459 Y109.041 E.1447
G1 X103.459 Y108.459 E.01871
G1 X132.541 Y108.459 E.93516
G1 X132.541 Y109.041 E.01871
G1 X128.041 Y109.041 E.1447
G1 X128.041 Y110.25 E.03888
; WIPE_START
G1 X128.041 Y111.541 E-.49053
G1 X127.332 Y111.541 E-.26947
; WIPE_END
G1 E-.04 F1800
G1 X134.944 Y110.987 Z1.6 F30000
G1 X149.21 Y109.948 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F3600
G1 X150.052 Y109.948 E.02708
G1 X150.052 Y120.052 E.32491
G1 X145.052 Y120.052 E.16078
G1 X145.052 Y131.948 E.38253
G1 X150.052 Y131.948 E.16078
G1 X150.052 Y142.052 E.32491
G1 X143.948 Y142.052 E.19629
G1 X143.948 Y133.052 E.28941
G1 X132.948 Y133.052 E.35372
G1 X132.948 Y118.948 E.45354
G1 X143.948 Y118.948 E.35372
G1 X143.948 Y109.948 E.28941
G1 X149.17 Y109.948 E.16792
G1 X149.21 Y110.355 F30000
G1 F3600
G1 X149.645 Y110.355 E.01399
G1 X149.645 Y119.645 E.29873
G1 X144.645 Y119.645 E.16078
G1 X144.645 Y132.355 E.40871
G1 X149.645 Y132.355 E.16078
G1 X149.645 Y141.645 E.29873
G1 X144.355 Y141.645 E.17011
G1 X144.355 Y132.645 E.28941
G1 X133.355 Y132.645 E.35372
G1 X133.355 Y119.355 E.42736
M73 P59 R11
G1 X144.355 Y119.355 E.35372
G1 X144.355 Y110.355 E.28941
G1 X149.17 Y110.355 E.15483
; WIPE_START
G1 X149.645 Y110.355 E-.1805
G1 X149.645 Y111.88 E-.5795
; WIPE_END
G1 E-.04 F1800
G1 X147.674 Y119.253 Z1.6 F30000
G1 X144.21 Y132.21 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X144.584 Y124.924 Z1.6 F30000
G1 X149.21 Y110.79 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.191 Y120.422 Z1.6 F30000
G1 X149.21 Y132.79 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.541 Y133.459 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X143.541 Y142.541 E.29204
G1 X133.959 Y142.541 E.30811
G1 X133.959 Y136.041 E.20902
G1 X127.959 Y136.041 E.19294
G1 X127.959 Y115.959 E.64576
G1 X133.959 Y115.959 E.19294
G1 X133.959 Y109.459 E.20902
G1 X143.541 Y109.459 E.30811
G1 X143.541 Y118.541 E.29204
G1 X132.541 Y118.541 E.35372
G1 X132.541 Y133.459 E.47972
G1 X143.501 Y133.459 E.35243
; WIPE_START
G1 X143.51 Y135.459 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.238 Y128.025 Z1.6 F30000
G1 X145.459 Y127.074 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F3600
G1 X145.459 Y120.459 E.21272
G1 X150.459 Y120.459 E.16078
G1 X150.459 Y109.459 E.35372
G1 X152.541 Y109.459 E.06694
G1 X152.541 Y142.541 E1.06379
G1 X150.459 Y142.541 E.06694
G1 X150.459 Y131.541 E.35372
G1 X145.459 Y131.541 E.16078
G1 X145.459 Y127.114 E.14234
; WIPE_START
G1 X145.459 Y125.114 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.076 Y131.362 Z1.6 F30000
G1 X132.948 Y142.948 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F3600
G1 X132.948 Y143.948 E.03216
G1 X103.052 Y143.948 E.96134
G1 X103.052 Y142.552 E.04489
G1 X107.552 Y142.552 E.1447
G1 X107.552 Y136.448 E.19629
G1 X103.052 Y136.448 E.1447
G1 X103.052 Y115.552 E.67194
G1 X107.552 Y115.552 E.1447
G1 X107.552 Y109.448 E.19629
G1 X103.052 Y109.448 E.1447
G1 X103.052 Y108.052 E.04489
G1 X132.948 Y108.052 E.96134
G1 X132.948 Y109.052 E.03216
G1 X152.948 Y109.052 E.64313
G1 X152.948 Y142.948 E1.08997
G1 X132.988 Y142.948 E.64184
G1 X133.355 Y143.355 F30000
G1 F3600
G1 X133.355 Y144.355 E.03216
G1 X102.645 Y144.355 E.98752
G1 X102.645 Y142.145 E.07107
G1 X107.145 Y142.145 E.1447
G1 X107.145 Y136.855 E.17011
G1 X102.645 Y136.855 E.1447
G1 X102.645 Y115.145 E.69812
G1 X107.145 Y115.145 E.1447
G1 X107.145 Y109.855 E.17011
G1 X102.645 Y109.855 E.1447
G1 X102.645 Y107.645 E.07107
G1 X133.355 Y107.645 E.98752
G1 X133.355 Y108.645 E.03216
G1 X153.355 Y108.645 E.64313
G1 X153.355 Y143.355 E1.11615
G1 X133.395 Y143.355 E.64184
; WIPE_START
G1 X133.355 Y144.355 E-.3803
G1 X132.356 Y144.355 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X127.765 Y138.257 Z1.6 F30000
G1 X106.71 Y110.29 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.694 Y119.922 Z1.6 F30000
G1 X106.71 Y141.71 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.323 Y142.242 Z1.6 F30000
G1 X133.79 Y143.79 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
M73 P60 R11
G1 X132.791 Y144.79 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X132.337 Y143.25 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y143.25 E.06208
; WIPE_START
G1 X129.837 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128 Y140.256 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y136.245 E.15488
; WIPE_START
G1 X128 Y138.245 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.546 Y134.32 Z1.6 F30000
G1 X135.4 Y133.807 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X133.776 Y133.807 E.05224
G1 X134.115 Y134.267 E.01837
G1 X134.552 Y134.458 E.01533
G1 X134.988 Y134.35 E.01447
G1 X135.425 Y134.05 E.01704
G1 X135.604 Y133.807 E.00969
G1 X137.27 Y133.807 E.05357
G1 X137.609 Y134.267 E.01837
G1 X138.046 Y134.458 E.01533
G1 X138.483 Y134.35 E.01447
G1 X138.919 Y134.05 E.01704
G1 X139.098 Y133.807 E.00969
G1 X140.764 Y133.807 E.05357
G1 X141.103 Y134.267 E.01837
G1 X141.54 Y134.458 E.01533
G1 X141.977 Y134.35 E.01447
G1 X142.414 Y134.05 E.01704
G1 X142.592 Y133.807 E.00969
G1 X143.193 Y133.807 E.0193
G1 X143.193 Y134.835 E.03306
; WIPE_START
G1 X143.193 Y133.807 E-.39066
G1 X142.592 Y133.807 E-.2281
G1 X142.414 Y134.05 E-.11453
G1 X142.356 Y134.09 E-.02671
; WIPE_END
G1 E-.04 F1800
G1 X142.698 Y126.465 Z1.6 F30000
G1 X143.07 Y118.193 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F4200
G1 X141.442 Y118.193 E.05236
G1 X141.103 Y117.734 E.01834
G1 X140.666 Y117.543 E.01533
G1 X140.23 Y117.651 E.01447
G1 X139.793 Y117.951 E.01704
G1 X139.615 Y118.193 E.00967
G1 X137.948 Y118.193 E.0536
G1 X137.609 Y117.734 E.01834
G1 X137.172 Y117.543 E.01533
G1 X136.735 Y117.651 E.01447
G1 X136.299 Y117.951 E.01704
G1 X136.12 Y118.193 E.00967
G1 X134.453 Y118.193 E.0536
G1 X134.115 Y117.734 E.01834
G1 X133.678 Y117.543 E.01533
G1 X133.241 Y117.651 E.01447
G1 X132.805 Y117.951 E.01704
G1 X132.626 Y118.193 E.00967
G1 X132.193 Y118.193 E.01394
G1 X132.193 Y118.62 E.01373
G1 X131.931 Y118.734 E.00918
G1 X131.494 Y118.626 E.01447
G1 X131.057 Y118.326 E.01704
G1 X130.621 Y117.734 E.02367
G1 X130.184 Y117.543 E.01533
G1 X129.747 Y117.651 E.01447
G1 X129.31 Y117.951 E.01704
G1 X128.874 Y118.543 E.02367
G1 X128.437 Y118.734 E.01533
G1 X128.307 Y118.702 E.00429
G1 X128.307 Y120.162 E.04695
G1 X128.437 Y120.073 E.00505
G1 X128.874 Y119.481 E.02367
G1 X129.31 Y119.29 E.01533
G1 X129.747 Y119.398 E.01447
G1 X130.184 Y119.698 E.01704
G1 X130.621 Y120.29 E.02367
G1 X131.057 Y120.481 E.01533
G1 X131.494 Y120.373 E.01447
G1 X131.931 Y120.073 E.01704
G1 X132.193 Y119.718 E.01418
G1 X132.193 Y121.346 E.05236
G1 X128.307 Y120.568 F30000
G1 F4200
G1 X128.307 Y122.196 E.05236
G1 X128.437 Y122.228 E.00429
G1 X128.874 Y122.037 E.01533
G1 X129.31 Y121.445 E.02367
G1 X129.747 Y121.145 E.01704
G1 X130.184 Y121.037 E.01447
G1 X130.621 Y121.228 E.01533
G1 X131.057 Y121.82 E.02367
G1 X131.494 Y122.12 E.01704
G1 X131.931 Y122.228 E.01447
G1 X132.193 Y122.114 E.00918
G1 X132.193 Y123.212 E.03533
G1 X131.931 Y123.567 E.01418
G1 X131.494 Y123.867 E.01704
G1 X131.057 Y123.975 E.01447
G1 X130.621 Y123.784 E.01533
G1 X130.184 Y123.192 E.02367
G1 X129.747 Y122.892 E.01704
G1 X129.31 Y122.784 E.01447
G1 X128.874 Y122.975 E.01533
G1 X128.437 Y123.567 E.02367
G1 X128.307 Y123.656 E.00505
G1 X128.307 Y125.69 E.06541
G1 X128.437 Y125.722 E.00429
G1 X128.874 Y125.532 E.01533
G1 X129.31 Y124.939 E.02367
G1 X129.747 Y124.639 E.01704
G1 X130.184 Y124.531 E.01447
G1 X130.621 Y124.722 E.01533
G1 X131.057 Y125.314 E.02367
G1 X131.494 Y125.614 E.01704
G1 X131.931 Y125.722 E.01447
G1 X132.193 Y125.608 E.00918
G1 X132.193 Y126.707 E.03533
G1 X131.931 Y127.061 E.01418
G1 X131.494 Y127.361 E.01704
G1 X131.057 Y127.469 E.01447
G1 X130.621 Y127.279 E.01533
G1 X130.184 Y126.686 E.02367
G1 X129.747 Y126.386 E.01704
G1 X129.31 Y126.278 E.01447
G1 X128.874 Y126.469 E.01533
G1 X128.437 Y127.061 E.02367
G1 X128.307 Y127.15 E.00505
G1 X128.307 Y129.184 E.06541
G1 X128.437 Y129.216 E.00429
G1 X128.874 Y129.026 E.01533
G1 X129.31 Y128.433 E.02367
G1 X129.747 Y128.134 E.01704
G1 X130.184 Y128.025 E.01447
G1 X130.621 Y128.216 E.01533
G1 X131.057 Y128.809 E.02367
G1 X131.494 Y129.108 E.01704
G1 X131.931 Y129.216 E.01447
G1 X132.193 Y129.102 E.00918
G1 X132.193 Y130.201 E.03533
G1 X131.931 Y130.556 E.01418
G1 X131.494 Y130.855 E.01704
G1 X131.057 Y130.964 E.01447
G1 X130.621 Y130.773 E.01533
G1 X130.184 Y130.18 E.02367
G1 X129.747 Y129.881 E.01704
G1 X129.31 Y129.773 E.01447
G1 X128.874 Y129.963 E.01533
G1 X128.437 Y130.556 E.02367
G1 X128.307 Y130.645 E.00505
G1 X128.307 Y132.679 E.06541
G1 X128.437 Y132.711 E.00429
G1 X128.874 Y132.52 E.01533
G1 X129.31 Y131.928 E.02367
G1 X129.747 Y131.628 E.01704
G1 X130.184 Y131.52 E.01447
G1 X130.621 Y131.71 E.01533
G1 X131.057 Y132.303 E.02367
G1 X131.494 Y132.603 E.01704
G1 X131.931 Y132.711 E.01447
G1 X132.193 Y132.596 E.00918
G1 X132.193 Y133.695 E.03533
G1 X131.931 Y134.05 E.01418
G1 X131.494 Y134.35 E.01704
G1 X131.057 Y134.458 E.01447
G1 X130.621 Y134.267 E.01533
G1 X130.184 Y133.675 E.02367
G1 X129.747 Y133.375 E.01704
G1 X129.31 Y133.267 E.01447
G1 X128.874 Y133.458 E.01533
G1 X128.437 Y134.05 E.02367
G1 X128.307 Y134.139 E.00505
G1 X128.307 Y135.693 E.04997
G1 X129.111 Y135.693 E.02583
G1 X129.31 Y135.422 E.01083
G1 X129.747 Y135.122 E.01704
G1 X130.184 Y135.014 E.01447
G1 X130.621 Y135.205 E.01533
G1 X130.981 Y135.693 E.0195
G1 X132.605 Y135.693 E.05223
G1 X132.805 Y135.422 E.01083
G1 X133.241 Y135.122 E.01704
G1 X133.678 Y135.014 E.01447
G1 X134.115 Y135.205 E.01533
G1 X134.552 Y135.797 E.02367
G1 X134.988 Y136.097 E.01704
G1 X135.425 Y136.205 E.01447
G1 X135.862 Y136.014 E.01533
G1 X136.299 Y135.422 E.02367
G1 X136.735 Y135.122 E.01704
G1 X137.172 Y135.014 E.01447
G1 X137.609 Y135.205 E.01533
G1 X138.046 Y135.797 E.02367
G1 X138.483 Y136.097 E.01704
G1 X138.919 Y136.205 E.01447
G1 X139.356 Y136.014 E.01533
G1 X139.793 Y135.422 E.02367
G1 X140.23 Y135.122 E.01704
G1 X140.666 Y135.014 E.01447
G1 X141.103 Y135.205 E.01533
G1 X141.54 Y135.797 E.02367
G1 X141.977 Y136.097 E.01704
G1 X142.414 Y136.205 E.01447
G1 X142.85 Y136.014 E.01533
G1 X143.193 Y135.55 E.01855
G1 X143.193 Y136.802 E.04027
G1 X142.85 Y136.952 E.01201
G1 X142.414 Y137.544 E.02367
G1 X141.977 Y137.844 E.01704
G1 X141.54 Y137.952 E.01447
G1 X141.103 Y137.761 E.01533
G1 X140.666 Y137.169 E.02367
G1 X140.23 Y136.869 E.01704
G1 X139.793 Y136.761 E.01447
G1 X139.356 Y136.952 E.01533
G1 X138.919 Y137.544 E.02367
G1 X138.483 Y137.844 E.01704
G1 X138.046 Y137.952 E.01447
G1 X137.609 Y137.761 E.01533
G1 X137.172 Y137.169 E.02367
G1 X136.735 Y136.869 E.01704
G1 X136.299 Y136.761 E.01447
G1 X135.862 Y136.952 E.01533
G1 X135.425 Y137.544 E.02367
G1 X134.988 Y137.844 E.01704
G1 X134.552 Y137.952 E.01447
G1 X134.307 Y137.845 E.00857
G1 X134.307 Y138.96 E.03584
G1 X134.552 Y139.291 E.01324
G1 X134.988 Y139.591 E.01704
G1 X135.425 Y139.699 E.01447
G1 X135.862 Y139.508 E.01533
G1 X136.299 Y138.916 E.02367
G1 X136.735 Y138.616 E.01704
G1 X137.172 Y138.508 E.01447
G1 X137.609 Y138.699 E.01533
G1 X138.046 Y139.291 E.02367
G1 X138.483 Y139.591 E.01704
M73 P61 R11
G1 X138.919 Y139.699 E.01447
G1 X139.356 Y139.508 E.01533
G1 X139.793 Y138.916 E.02367
G1 X140.23 Y138.616 E.01704
G1 X140.666 Y138.508 E.01447
G1 X141.103 Y138.699 E.01533
G1 X141.54 Y139.291 E.02367
G1 X141.977 Y139.591 E.01704
G1 X142.414 Y139.699 E.01447
G1 X142.85 Y139.508 E.01533
G1 X143.193 Y139.044 E.01855
G1 X143.193 Y140.296 E.04027
G1 X142.85 Y140.446 E.01201
G1 X142.414 Y141.038 E.02367
G1 X141.977 Y141.338 E.01704
G1 X141.54 Y141.446 E.01447
G1 X141.103 Y141.255 E.01533
G1 X140.666 Y140.663 E.02367
G1 X140.23 Y140.363 E.01704
G1 X139.793 Y140.255 E.01447
G1 X139.356 Y140.446 E.01533
G1 X138.919 Y141.038 E.02367
G1 X138.483 Y141.338 E.01704
G1 X138.046 Y141.446 E.01447
G1 X137.609 Y141.255 E.01533
G1 X137.172 Y140.663 E.02367
G1 X136.735 Y140.363 E.01704
G1 X136.299 Y140.255 E.01447
G1 X135.862 Y140.446 E.01533
G1 X135.425 Y141.038 E.02367
G1 X134.988 Y141.338 E.01704
G1 X134.552 Y141.446 E.01447
G1 X134.307 Y141.339 E.00857
G1 X134.307 Y142.193 E.02744
G1 X136.616 Y142.193 E.07422
G1 X136.735 Y142.11 E.00468
G1 X137.172 Y142.002 E.01447
G1 X137.608 Y142.193 E.0153
G1 X140.11 Y142.193 E.08044
G1 X140.23 Y142.11 E.00468
G1 X140.666 Y142.002 E.01447
G1 X141.102 Y142.193 E.0153
G1 X142.731 Y142.193 E.05236
; WIPE_START
G1 X141.102 Y142.193 E-.61876
G1 X140.762 Y142.044 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X143.745 Y142.5 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X150.256 Y142.5 E.2514
; WIPE_START
G1 X148.256 Y142.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.807 Y140.632 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X150.807 Y142.087 E.04677
G1 X151.149 Y142.002 E.01131
G1 X151.585 Y142.193 E.0153
G1 X152.193 Y142.193 E.01955
G1 X152.193 Y141.404 E.02536
G1 X152.022 Y141.446 E.00564
G1 X151.586 Y141.255 E.01533
G1 X151.149 Y140.663 E.02367
G1 X150.807 Y140.429 E.01332
G1 X150.807 Y138.593 E.05904
G1 X151.149 Y138.508 E.01131
G1 X151.586 Y138.699 E.01533
G1 X152.022 Y139.291 E.02367
G1 X152.193 Y139.408 E.00665
G1 X152.193 Y137.91 E.04818
G1 X152.022 Y137.952 E.00564
G1 X151.586 Y137.761 E.01533
G1 X151.149 Y137.169 E.02367
G1 X150.807 Y136.934 E.01332
G1 X150.807 Y135.098 E.05904
G1 X151.149 Y135.014 E.01131
G1 X151.586 Y135.205 E.01533
G1 X152.022 Y135.797 E.02367
G1 X152.193 Y135.914 E.00665
G1 X152.193 Y134.416 E.04818
G1 X152.022 Y134.458 E.00564
G1 X151.586 Y134.267 E.01533
G1 X151.149 Y133.675 E.02367
G1 X150.807 Y133.44 E.01332
G1 X150.807 Y131.604 E.05904
G1 X151.149 Y131.52 E.01131
G1 X151.586 Y131.71 E.01533
G1 X152.022 Y132.303 E.02367
G1 X152.193 Y132.42 E.00665
G1 X152.193 Y130.921 E.04818
G1 X152.022 Y130.964 E.00564
G1 X151.586 Y130.773 E.01533
G1 X151.149 Y130.18 E.02367
G1 X150.712 Y129.881 E.01704
G1 X150.275 Y129.773 E.01447
G1 X149.838 Y129.963 E.01533
G1 X149.402 Y130.556 E.02367
G1 X148.965 Y130.855 E.01704
G1 X148.528 Y130.964 E.01447
G1 X148.091 Y130.773 E.01533
G1 X147.655 Y130.18 E.02367
G1 X147.218 Y129.881 E.01704
G1 X146.781 Y129.773 E.01447
G1 X146.344 Y129.963 E.01533
G1 X145.907 Y130.556 E.02367
G1 X145.807 Y130.624 E.00391
G1 X145.807 Y129.192 E.04607
G1 X145.907 Y129.216 E.00332
G1 X146.344 Y129.026 E.01533
G1 X146.781 Y128.433 E.02367
G1 X147.218 Y128.134 E.01704
G1 X147.655 Y128.025 E.01447
G1 X148.091 Y128.216 E.01533
G1 X148.528 Y128.809 E.02367
G1 X148.965 Y129.108 E.01704
G1 X149.402 Y129.216 E.01447
G1 X149.838 Y129.026 E.01533
G1 X150.275 Y128.433 E.02367
G1 X150.712 Y128.134 E.01704
G1 X151.149 Y128.025 E.01447
G1 X151.586 Y128.216 E.01533
G1 X152.022 Y128.809 E.02367
G1 X152.193 Y128.926 E.00665
G1 X152.193 Y127.427 E.04818
G1 X152.022 Y127.469 E.00564
G1 X151.586 Y127.279 E.01533
G1 X151.149 Y126.686 E.02367
G1 X150.712 Y126.386 E.01704
G1 X150.275 Y126.278 E.01447
G1 X149.838 Y126.469 E.01533
G1 X149.402 Y127.061 E.02367
G1 X148.965 Y127.361 E.01704
G1 X148.528 Y127.469 E.01447
G1 X148.091 Y127.279 E.01533
G1 X147.655 Y126.686 E.02367
G1 X147.218 Y126.386 E.01704
G1 X146.781 Y126.278 E.01447
G1 X146.344 Y126.469 E.01533
G1 X145.907 Y127.061 E.02367
G1 X145.807 Y127.13 E.00391
G1 X145.807 Y125.697 E.04607
G1 X145.907 Y125.722 E.00332
G1 X146.344 Y125.532 E.01533
G1 X146.781 Y124.939 E.02367
G1 X147.218 Y124.639 E.01704
G1 X147.655 Y124.531 E.01447
G1 X148.091 Y124.722 E.01533
G1 X148.528 Y125.314 E.02367
G1 X148.965 Y125.614 E.01704
G1 X149.402 Y125.722 E.01447
G1 X149.838 Y125.532 E.01533
G1 X150.275 Y124.939 E.02367
G1 X150.712 Y124.639 E.01704
G1 X151.149 Y124.531 E.01447
G1 X151.586 Y124.722 E.01533
G1 X152.022 Y125.314 E.02367
G1 X152.193 Y125.431 E.00665
G1 X152.193 Y123.933 E.04818
G1 X152.022 Y123.975 E.00564
G1 X151.586 Y123.784 E.01533
G1 X151.149 Y123.192 E.02367
G1 X150.712 Y122.892 E.01704
G1 X150.275 Y122.784 E.01447
G1 X149.838 Y122.975 E.01533
G1 X149.402 Y123.567 E.02367
G1 X148.965 Y123.867 E.01704
G1 X148.528 Y123.975 E.01447
G1 X148.091 Y123.784 E.01533
G1 X147.655 Y123.192 E.02367
G1 X147.218 Y122.892 E.01704
G1 X146.781 Y122.784 E.01447
G1 X146.344 Y122.975 E.01533
G1 X145.907 Y123.567 E.02367
G1 X145.807 Y123.636 E.00391
G1 X145.807 Y122.203 E.04607
G1 X145.907 Y122.228 E.00332
G1 X146.344 Y122.037 E.01533
G1 X146.781 Y121.445 E.02367
G1 X147.218 Y121.145 E.01704
G1 X147.655 Y121.037 E.01447
G1 X148.091 Y121.228 E.01533
G1 X148.528 Y121.82 E.02367
G1 X148.965 Y122.12 E.01704
G1 X149.402 Y122.228 E.01447
G1 X149.838 Y122.037 E.01533
G1 X150.275 Y121.445 E.02367
G1 X150.712 Y121.145 E.01704
G1 X151.149 Y121.037 E.01447
G1 X151.586 Y121.228 E.01533
G1 X152.022 Y121.82 E.02367
G1 X152.193 Y121.937 E.00665
G1 X152.193 Y120.439 E.04818
G1 X152.022 Y120.481 E.00564
G1 X151.586 Y120.29 E.01533
G1 X151.149 Y119.698 E.02367
G1 X150.807 Y119.463 E.01332
G1 X150.807 Y117.627 E.05904
G1 X151.149 Y117.543 E.01131
G1 X151.586 Y117.734 E.01533
G1 X152.022 Y118.326 E.02367
G1 X152.193 Y118.443 E.00665
G1 X152.193 Y116.945 E.04818
G1 X152.022 Y116.987 E.00564
G1 X151.586 Y116.796 E.01533
G1 X151.149 Y116.204 E.02367
G1 X150.807 Y115.969 E.01332
G1 X150.807 Y114.133 E.05904
G1 X151.149 Y114.049 E.01131
G1 X151.586 Y114.239 E.01533
G1 X152.022 Y114.832 E.02367
G1 X152.193 Y114.949 E.00665
G1 X152.193 Y113.45 E.04818
G1 X152.022 Y113.493 E.00564
G1 X151.586 Y113.302 E.01533
G1 X151.149 Y112.709 E.02367
G1 X150.807 Y112.475 E.01332
G1 X150.807 Y110.639 E.05904
G1 X151.149 Y110.554 E.01131
G1 X151.586 Y110.745 E.01533
G1 X152.022 Y111.338 E.02367
G1 X152.193 Y111.455 E.00665
G1 X152.193 Y109.956 E.04818
G1 X152.022 Y109.998 E.00564
G1 X151.585 Y109.807 E.01534
G1 X150.807 Y109.807 E.02502
G1 X150.807 Y110.435 E.0202
; WIPE_START
G1 X150.807 Y109.807 E-.23868
G1 X151.585 Y109.807 E-.29565
G1 X152.022 Y109.998 E-.18123
G1 X152.136 Y109.97 E-.04444
; WIPE_END
G1 E-.04 F1800
G1 X150.256 Y109.5 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X143.745 Y109.5 E.2514
; WIPE_START
G1 X145.745 Y109.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.193 Y110.341 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X143.193 Y109.807 E.01715
G1 X142.098 Y109.807 E.03521
G1 X141.977 Y109.89 E.00471
G1 X141.54 Y109.998 E.01447
G1 X141.103 Y109.807 E.01534
G1 X138.603 Y109.807 E.08038
G1 X138.483 Y109.89 E.00472
G1 X138.046 Y109.998 E.01447
G1 X137.609 Y109.807 E.01534
G1 X135.109 Y109.807 E.08038
G1 X134.988 Y109.89 E.00472
G1 X134.552 Y109.998 E.01447
G1 X134.307 Y109.892 E.00857
G1 X134.307 Y111.006 E.03584
G1 X134.552 Y111.338 E.01324
G1 X134.988 Y111.637 E.01704
G1 X135.425 Y111.745 E.01447
G1 X135.862 Y111.555 E.01533
G1 X136.299 Y110.962 E.02367
G1 X136.735 Y110.663 E.01704
G1 X137.172 Y110.554 E.01447
G1 X137.609 Y110.745 E.01533
G1 X138.046 Y111.338 E.02367
G1 X138.483 Y111.637 E.01704
G1 X138.919 Y111.745 E.01447
G1 X139.356 Y111.555 E.01533
G1 X139.793 Y110.962 E.02367
G1 X140.23 Y110.663 E.01704
G1 X140.666 Y110.554 E.01447
G1 X141.103 Y110.745 E.01533
G1 X141.54 Y111.338 E.02367
G1 X141.977 Y111.637 E.01704
G1 X142.414 Y111.745 E.01447
G1 X142.85 Y111.555 E.01533
G1 X143.193 Y111.09 E.01855
G1 X143.193 Y112.343 E.04027
G1 X142.85 Y112.492 E.01201
G1 X142.414 Y113.085 E.02367
G1 X141.977 Y113.384 E.01704
G1 X141.54 Y113.493 E.01447
G1 X141.103 Y113.302 E.01533
G1 X140.666 Y112.709 E.02367
G1 X140.23 Y112.41 E.01704
G1 X139.793 Y112.302 E.01447
G1 X139.356 Y112.492 E.01533
G1 X138.919 Y113.085 E.02367
G1 X138.483 Y113.384 E.01704
G1 X138.046 Y113.493 E.01447
G1 X137.609 Y113.302 E.01533
G1 X137.172 Y112.709 E.02367
G1 X136.735 Y112.41 E.01704
G1 X136.299 Y112.302 E.01447
G1 X135.862 Y112.492 E.01533
G1 X135.425 Y113.085 E.02367
G1 X134.988 Y113.384 E.01704
G1 X134.552 Y113.493 E.01447
G1 X134.307 Y113.386 E.00857
G1 X134.307 Y114.5 E.03584
G1 X134.552 Y114.832 E.01324
G1 X134.988 Y115.132 E.01704
G1 X135.425 Y115.24 E.01447
G1 X135.862 Y115.049 E.01533
G1 X136.299 Y114.457 E.02367
G1 X136.735 Y114.157 E.01704
G1 X137.172 Y114.049 E.01447
G1 X137.609 Y114.239 E.01533
G1 X138.046 Y114.832 E.02367
G1 X138.483 Y115.132 E.01704
G1 X138.919 Y115.24 E.01447
G1 X139.356 Y115.049 E.01533
G1 X139.793 Y114.457 E.02367
G1 X140.23 Y114.157 E.01704
G1 X140.666 Y114.049 E.01447
G1 X141.103 Y114.239 E.01533
G1 X141.54 Y114.832 E.02367
G1 X141.977 Y115.132 E.01704
G1 X142.414 Y115.24 E.01447
G1 X142.85 Y115.049 E.01533
G1 X143.193 Y114.585 E.01855
G1 X143.193 Y115.837 E.04027
G1 X142.85 Y115.986 E.01201
G1 X142.414 Y116.579 E.02367
G1 X141.977 Y116.879 E.01704
G1 X141.54 Y116.987 E.01447
G1 X141.103 Y116.796 E.01533
G1 X140.666 Y116.204 E.02367
G1 X140.23 Y115.904 E.01704
G1 X139.793 Y115.796 E.01447
G1 X139.356 Y115.986 E.01533
G1 X138.919 Y116.579 E.02367
G1 X138.483 Y116.879 E.01704
G1 X138.046 Y116.987 E.01447
G1 X137.609 Y116.796 E.01533
G1 X137.172 Y116.204 E.02367
G1 X136.735 Y115.904 E.01704
G1 X136.299 Y115.796 E.01447
G1 X135.862 Y115.986 E.01533
G1 X135.425 Y116.579 E.02367
G1 X134.988 Y116.879 E.01704
G1 X134.552 Y116.987 E.01447
G1 X134.115 Y116.796 E.01533
G1 X133.755 Y116.307 E.01952
G1 X132.131 Y116.307 E.0522
G1 X131.931 Y116.579 E.01085
G1 X131.494 Y116.879 E.01704
G1 X131.057 Y116.987 E.01447
G1 X130.621 Y116.796 E.01533
G1 X130.26 Y116.307 E.01952
G1 X128.637 Y116.307 E.0522
G1 X128.437 Y116.579 E.01085
G1 X128.307 Y116.668 E.00505
G1 X128.307 Y118.296 E.05236
; WIPE_START
G1 X128.307 Y116.668 E-.61876
G1 X128.437 Y116.579 E-.05967
G1 X128.564 Y116.406 E-.08156
; WIPE_END
G1 E-.04 F1800
G1 X128 Y115.755 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y111.744 E.15488
; WIPE_START
G1 X128 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.837 Y108.75 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X132.337 Y108.75 E.06208
; WIPE_START
G1 X130.337 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.889 Y110.418 Z1.6 F30000
G1 X102.75 Y114.927 Z1.6
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y110.073 E.24736
; WIPE_START
G1 X102.75 Y112.073 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X103.663 Y108.75 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X108.163 Y108.75 E.06208
G1 X108.307 Y109.364 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X108.307 Y110.993 E.05236
G1 X108.782 Y110.663 E.0186
G1 X109.219 Y110.554 E.01447
G1 X109.656 Y110.745 E.01533
G1 X110.002 Y111.193 E.01819
G1 X111.55 Y111.193 E.04979
G1 X111.84 Y110.962 E.0119
G1 X112.276 Y110.663 E.01704
G1 X112.713 Y110.554 E.01447
G1 X113.15 Y110.745 E.01533
G1 X113.496 Y111.193 E.01819
G1 X115.044 Y111.193 E.04979
G1 X115.334 Y110.962 E.0119
G1 X115.771 Y110.663 E.01704
G1 X116.207 Y110.554 E.01447
G1 X116.644 Y110.745 E.01533
G1 X116.99 Y111.193 E.01819
G1 X118.539 Y111.193 E.04979
G1 X118.828 Y110.962 E.0119
G1 X119.265 Y110.663 E.01704
G1 X119.702 Y110.554 E.01447
G1 X120.138 Y110.745 E.01533
G1 X120.485 Y111.193 E.01819
G1 X122.033 Y111.193 E.04979
G1 X122.322 Y110.962 E.0119
G1 X122.759 Y110.663 E.01704
G1 X123.196 Y110.554 E.01447
G1 X123.633 Y110.745 E.01533
G1 X123.979 Y111.193 E.01819
G1 X125.527 Y111.193 E.04979
G1 X125.816 Y110.962 E.0119
G1 X126.253 Y110.663 E.01704
G1 X126.69 Y110.554 E.01447
G1 X127.127 Y110.745 E.01533
G1 X127.473 Y111.193 E.01819
G1 X127.693 Y111.193 E.00707
G1 X127.693 Y109.966 E.03943
G1 X127.564 Y109.998 E.00428
G1 X127.127 Y109.808 E.01533
G1 X126.69 Y109.215 E.02367
G1 X126.253 Y108.915 E.01704
G1 X125.816 Y108.807 E.01447
G1 X125.38 Y108.998 E.01533
G1 X124.943 Y109.59 E.02367
G1 X124.506 Y109.89 E.01704
G1 X124.069 Y109.998 E.01447
G1 X123.633 Y109.808 E.01533
G1 X123.196 Y109.215 E.02367
G1 X122.759 Y108.915 E.01704
G1 X122.322 Y108.807 E.01447
G1 X121.886 Y108.998 E.01533
G1 X121.449 Y109.59 E.02367
G1 X121.012 Y109.89 E.01704
G1 X120.575 Y109.998 E.01447
G1 X120.138 Y109.808 E.01533
G1 X119.702 Y109.215 E.02367
G1 X119.265 Y108.915 E.01704
G1 X118.828 Y108.807 E.01447
G1 X118.391 Y108.998 E.01533
G1 X117.955 Y109.59 E.02367
G1 X117.518 Y109.89 E.01704
G1 X117.081 Y109.998 E.01447
G1 X116.644 Y109.808 E.01533
G1 X116.207 Y109.215 E.02367
G1 X115.771 Y108.915 E.01704
G1 X115.334 Y108.807 E.01447
G1 X114.897 Y108.998 E.01533
G1 X114.46 Y109.59 E.02367
G1 X114.024 Y109.89 E.01704
G1 X113.587 Y109.998 E.01447
G1 X113.15 Y109.808 E.01533
G1 X112.713 Y109.215 E.02367
G1 X112.276 Y108.915 E.01704
G1 X111.84 Y108.807 E.01447
G1 X111.403 Y108.998 E.01533
G1 X110.966 Y109.59 E.02367
G1 X110.529 Y109.89 E.01704
G1 X110.093 Y109.998 E.01447
G1 X109.656 Y109.808 E.01533
G1 X109.219 Y109.215 E.02367
G1 X108.782 Y108.915 E.01704
G1 X108.511 Y108.848 E.00899
G1 X108.511 Y108.807 E.00132
G1 X110.098 Y108.807 E.05104
; WIPE_START
G1 X108.511 Y108.807 E-.6032
G1 X108.511 Y108.848 E-.01556
G1 X108.782 Y108.915 E-.10629
G1 X108.858 Y108.967 E-.03495
; WIPE_END
G1 E-.04 F1800
G1 X108 Y111.744 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y115.755 E.15487
; WIPE_START
G1 X108 Y113.755 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X107.693 Y117.915 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X107.693 Y116.307 E.0517
G1 X107.672 Y116.307 E.00066
G1 X107.472 Y116.579 E.01084
G1 X107.035 Y116.879 E.01704
G1 X106.598 Y116.987 E.01447
G1 X106.162 Y116.796 E.01533
G1 X105.801 Y116.307 E.01952
G1 X104.178 Y116.307 E.05221
G1 X103.978 Y116.579 E.01084
G1 X103.807 Y116.696 E.00665
G1 X103.807 Y118.692 E.06418
G1 X103.978 Y118.734 E.00565
G1 X104.415 Y118.543 E.01533
G1 X104.851 Y117.951 E.02367
G1 X105.288 Y117.651 E.01704
G1 X105.725 Y117.543 E.01447
G1 X106.162 Y117.733 E.01533
G1 X106.598 Y118.326 E.02367
G1 X107.035 Y118.626 E.01704
G1 X107.472 Y118.734 E.01447
G1 X107.693 Y118.637 E.00774
G1 X107.693 Y119.774 E.03654
G1 X107.472 Y120.073 E.01196
G1 X107.035 Y120.373 E.01704
G1 X106.598 Y120.481 E.01447
G1 X106.162 Y120.29 E.01533
G1 X105.725 Y119.698 E.02367
G1 X105.288 Y119.398 E.01704
G1 X104.851 Y119.29 E.01447
G1 X104.415 Y119.481 E.01533
G1 X103.978 Y120.073 E.02367
G1 X103.807 Y120.19 E.00665
G1 X103.807 Y122.186 E.06418
G1 X103.978 Y122.228 E.00565
G1 X104.415 Y122.037 E.01533
G1 X104.851 Y121.445 E.02367
G1 X105.288 Y121.145 E.01704
G1 X105.725 Y121.037 E.01447
G1 X106.162 Y121.228 E.01533
G1 X106.598 Y121.82 E.02367
G1 X107.035 Y122.12 E.01704
G1 X107.472 Y122.228 E.01447
G1 X107.693 Y122.132 E.00774
G1 X107.693 Y123.268 E.03654
G1 X107.472 Y123.567 E.01196
G1 X107.035 Y123.867 E.01704
G1 X106.598 Y123.975 E.01447
G1 X106.162 Y123.784 E.01533
G1 X105.725 Y123.192 E.02367
G1 X105.288 Y122.892 E.01704
G1 X104.851 Y122.784 E.01447
G1 X104.415 Y122.975 E.01533
G1 X103.978 Y123.567 E.02367
G1 X103.807 Y123.684 E.00665
G1 X103.807 Y125.68 E.06418
G1 X103.978 Y125.722 E.00565
G1 X104.415 Y125.531 E.01533
G1 X104.851 Y124.939 E.02367
G1 X105.288 Y124.639 E.01704
G1 X105.725 Y124.531 E.01447
G1 X106.162 Y124.722 E.01533
G1 X106.598 Y125.314 E.02367
G1 X107.035 Y125.614 E.01704
G1 X107.472 Y125.722 E.01447
G1 X107.693 Y125.626 E.00774
G1 X107.693 Y126.762 E.03654
G1 X107.472 Y127.061 E.01196
G1 X107.035 Y127.361 E.01704
G1 X106.598 Y127.469 E.01447
G1 X106.162 Y127.278 E.01533
G1 X105.725 Y126.686 E.02367
G1 X105.288 Y126.386 E.01704
G1 X104.851 Y126.278 E.01447
G1 X104.415 Y126.469 E.01533
G1 X103.978 Y127.061 E.02367
G1 X103.807 Y127.178 E.00665
G1 X103.807 Y129.174 E.06418
G1 X103.978 Y129.216 E.00565
G1 X104.415 Y129.026 E.01533
G1 X104.851 Y128.433 E.02367
G1 X105.288 Y128.133 E.01704
G1 X105.725 Y128.025 E.01447
G1 X106.162 Y128.216 E.01533
G1 X106.598 Y128.808 E.02367
G1 X107.035 Y129.108 E.01704
G1 X107.472 Y129.216 E.01447
G1 X107.693 Y129.12 E.00774
G1 X107.693 Y130.256 E.03654
G1 X107.472 Y130.556 E.01196
G1 X107.035 Y130.855 E.01704
G1 X106.598 Y130.963 E.01447
G1 X106.162 Y130.773 E.01533
G1 X105.725 Y130.18 E.02367
G1 X105.288 Y129.88 E.01704
G1 X104.851 Y129.772 E.01447
G1 X104.415 Y129.963 E.01533
G1 X103.978 Y130.556 E.02367
G1 X103.807 Y130.673 E.00665
G1 X103.807 Y132.668 E.06418
G1 X103.978 Y132.711 E.00565
G1 X104.415 Y132.52 E.01533
G1 X104.851 Y131.927 E.02367
G1 X105.288 Y131.628 E.01704
G1 X105.725 Y131.52 E.01447
G1 X106.162 Y131.71 E.01533
G1 X106.598 Y132.303 E.02367
G1 X107.035 Y132.602 E.01704
G1 X107.472 Y132.711 E.01447
G1 X107.693 Y132.614 E.00774
G1 X107.693 Y133.75 E.03654
G1 X107.472 Y134.05 E.01196
G1 X107.035 Y134.35 E.01704
G1 X106.598 Y134.458 E.01447
G1 X106.162 Y134.267 E.01533
G1 X105.725 Y133.675 E.02367
G1 X105.288 Y133.375 E.01704
G1 X104.851 Y133.267 E.01447
G1 X104.415 Y133.457 E.01533
G1 X103.978 Y134.05 E.02367
G1 X103.807 Y134.167 E.00665
G1 X103.807 Y135.693 E.04907
G1 X104.651 Y135.693 E.02715
G1 X104.851 Y135.422 E.01083
G1 X105.288 Y135.122 E.01704
G1 X105.725 Y135.014 E.01447
G1 X106.162 Y135.204 E.01533
G1 X106.522 Y135.693 E.01951
G1 X107.693 Y135.693 E.03766
G1 X107.693 Y135.235 E.0147
; WIPE_START
G1 X107.693 Y135.693 E-.17376
G1 X106.522 Y135.693 E-.445
G1 X106.301 Y135.394 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X108 Y136.245 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y140.256 E.15487
G1 X108.307 Y140.833 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X108.307 Y142.461 E.05236
G1 X108.345 Y142.41 E.00207
G1 X108.782 Y142.11 E.01704
G1 X109.219 Y142.002 E.01447
G1 X109.656 Y142.192 E.01533
G1 X110.093 Y142.785 E.02367
G1 X110.529 Y143.085 E.01704
G1 X110.966 Y143.193 E.01447
G1 X111.403 Y143.002 E.01533
G1 X111.84 Y142.41 E.02367
G1 X112.276 Y142.11 E.01704
G1 X112.713 Y142.002 E.01447
G1 X113.15 Y142.192 E.01533
G1 X113.587 Y142.785 E.02367
G1 X114.024 Y143.085 E.01704
G1 X114.46 Y143.193 E.01447
G1 X114.897 Y143.002 E.01533
G1 X115.334 Y142.41 E.02367
G1 X115.771 Y142.11 E.01704
G1 X116.207 Y142.002 E.01447
G1 X116.644 Y142.192 E.01533
G1 X117.081 Y142.785 E.02367
G1 X117.518 Y143.085 E.01704
G1 X117.955 Y143.193 E.01447
G1 X118.391 Y143.002 E.01533
G1 X118.828 Y142.41 E.02367
G1 X119.265 Y142.11 E.01704
G1 X119.702 Y142.002 E.01447
G1 X120.138 Y142.192 E.01533
G1 X120.575 Y142.785 E.02367
G1 X121.012 Y143.085 E.01704
G1 X121.449 Y143.193 E.01447
G1 X121.886 Y143.002 E.01533
G1 X122.322 Y142.41 E.02367
G1 X122.759 Y142.11 E.01704
G1 X123.196 Y142.002 E.01447
G1 X123.633 Y142.192 E.01533
G1 X124.069 Y142.785 E.02367
G1 X124.506 Y143.085 E.01704
G1 X124.943 Y143.193 E.01447
G1 X125.38 Y143.002 E.01533
G1 X125.816 Y142.41 E.02367
G1 X126.253 Y142.11 E.01704
G1 X126.69 Y142.002 E.01447
G1 X127.127 Y142.192 E.01533
G1 X127.564 Y142.785 E.02367
G1 X127.693 Y142.793 E.00416
G1 X127.693 Y141.414 E.04435
G1 X127.564 Y141.446 E.00428
G1 X127.127 Y141.255 E.01533
G1 X126.797 Y140.807 E.01788
G1 X125.113 Y140.807 E.05415
G1 X124.943 Y141.038 E.00921
G1 X124.506 Y141.338 E.01704
G1 X124.069 Y141.446 E.01447
G1 X123.633 Y141.255 E.01533
G1 X123.303 Y140.807 E.01788
G1 X121.619 Y140.807 E.05415
G1 X121.449 Y141.038 E.00921
G1 X121.012 Y141.338 E.01704
G1 X120.575 Y141.446 E.01447
G1 X120.138 Y141.255 E.01533
G1 X119.808 Y140.807 E.01788
G1 X118.124 Y140.807 E.05415
G1 X117.955 Y141.038 E.00921
G1 X117.518 Y141.338 E.01704
G1 X117.081 Y141.446 E.01447
G1 X116.644 Y141.255 E.01533
G1 X116.314 Y140.807 E.01788
G1 X114.63 Y140.807 E.05415
G1 X114.46 Y141.038 E.00921
G1 X114.024 Y141.338 E.01704
G1 X113.587 Y141.446 E.01447
G1 X113.15 Y141.255 E.01533
G1 X112.82 Y140.807 E.01788
G1 X111.136 Y140.807 E.05415
G1 X110.966 Y141.038 E.00921
G1 X110.529 Y141.338 E.01704
G1 X110.093 Y141.446 E.01447
G1 X109.656 Y141.255 E.01533
G1 X109.326 Y140.807 E.01788
G1 X110.932 Y140.807 E.05166
G1 X108.163 Y143.25 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y143.25 E.06208
; WIPE_START
G1 X105.663 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y141.927 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y137.073 E.24736
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3720.872
G1 X102.75 Y139.073 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 7/27
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
G17
G3 Z1.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X129.29 Y142.552
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y142.552 E.02708
G1 X128.448 Y136.448 E.19629
G1 X133.552 Y136.448 E.16413
G1 X133.552 Y142.552 E.19629
G1 X129.33 Y142.552 E.13577
G1 X128.855 Y141.71 F30000
G1 F3600
G1 X128.855 Y136.855 E.15612
G1 X133.145 Y136.855 E.13795
G1 X133.145 Y142.145 E.17011
G1 X128.855 Y142.145 E.13795
G1 X128.855 Y141.75 E.0127
M204 S250
G1 X129.29 Y141.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P61 R10
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y141.71 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y142.959 E.04017
G1 X132.541 Y142.959 E.1447
G1 X132.541 Y143.541 E.01871
G1 X103.459 Y143.541 E.93516
G1 X103.459 Y142.959 E.01871
G1 X107.959 Y142.959 E.1447
G1 X107.959 Y140.459 E.08039
G1 X128.041 Y140.459 E.64576
G1 X128.041 Y141.67 E.03894
; WIPE_START
G1 X128.041 Y142.959 E-.48987
G1 X128.752 Y142.959 E-.27013
; WIPE_END
G1 E-.04 F1800
G1 X121.47 Y140.673 Z1.8 F30000
G1 X106.71 Y136.041 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F3600
G1 X103.459 Y136.041 E.10454
G1 X103.459 Y115.959 E.64576
G1 X108.041 Y115.959 E.14733
G1 X108.041 Y136.041 E.64576
G1 X106.75 Y136.041 E.04151
; WIPE_START
G1 X104.75 Y136.041 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y140.052 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
G1 F3600
G1 X108.448 Y140.052 E.02708
G1 X108.448 Y111.948 E.90373
G1 X127.552 Y111.948 E.61432
G1 X127.552 Y140.052 E.90373
G1 X109.33 Y140.052 E.58595
G1 X109.29 Y139.645 F30000
G1 F3600
G1 X108.855 Y139.645 E.01399
G1 X108.855 Y112.355 E.87755
G1 X127.145 Y112.355 E.58814
G1 X127.145 Y139.645 E.87755
G1 X109.33 Y139.645 E.57287
M204 S250
G1 X109.29 Y139.21 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.747 Y130.987 Z1.8 F30000
G1 X128.448 Y110.29 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y109.448 E.02708
G1 X133.552 Y109.448 E.16413
G1 X133.552 Y115.552 E.19629
G1 X128.448 Y115.552 E.16413
G1 X128.448 Y110.33 E.16792
G1 X129.29 Y109.855 F30000
G1 F3600
G1 X133.145 Y109.855 E.12396
G1 X133.145 Y115.145 E.17011
G1 X128.855 Y115.145 E.13795
G1 X128.855 Y109.855 E.17011
G1 X129.25 Y109.855 E.0127
M204 S250
G1 X129.29 Y110.29 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y110.29 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y111.541 E.04022
G1 X107.959 Y111.541 E.64576
G1 X107.959 Y109.041 E.08039
G1 X103.459 Y109.041 E.1447
G1 X103.459 Y108.459 E.01871
G1 X132.541 Y108.459 E.93516
G1 X132.541 Y109.041 E.01871
G1 X128.041 Y109.041 E.1447
G1 X128.041 Y110.25 E.03888
; WIPE_START
G1 X128.041 Y111.541 E-.49053
G1 X127.332 Y111.541 E-.26947
; WIPE_END
G1 E-.04 F1800
G1 X134.944 Y110.987 Z1.8 F30000
G1 X149.21 Y109.948 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F3600
G1 X150.052 Y109.948 E.02708
G1 X150.052 Y120.052 E.32491
G1 X145.052 Y120.052 E.16078
G1 X145.052 Y131.948 E.38253
G1 X150.052 Y131.948 E.16078
G1 X150.052 Y142.052 E.32491
G1 X143.948 Y142.052 E.19629
G1 X143.948 Y133.052 E.28941
G1 X132.948 Y133.052 E.35372
G1 X132.948 Y118.948 E.45354
G1 X143.948 Y118.948 E.35372
G1 X143.948 Y109.948 E.28941
G1 X149.17 Y109.948 E.16792
G1 X149.21 Y110.355 F30000
G1 F3600
G1 X149.645 Y110.355 E.01399
G1 X149.645 Y119.645 E.29873
G1 X144.645 Y119.645 E.16078
G1 X144.645 Y132.355 E.40871
G1 X149.645 Y132.355 E.16078
G1 X149.645 Y141.645 E.29873
G1 X144.355 Y141.645 E.17011
G1 X144.355 Y132.645 E.28941
G1 X133.355 Y132.645 E.35372
G1 X133.355 Y119.355 E.42736
G1 X144.355 Y119.355 E.35372
G1 X144.355 Y110.355 E.28941
G1 X149.17 Y110.355 E.15483
; WIPE_START
G1 X149.645 Y110.355 E-.1805
G1 X149.645 Y111.88 E-.5795
; WIPE_END
G1 E-.04 F1800
G1 X147.674 Y119.253 Z1.8 F30000
G1 X144.21 Y132.21 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
M73 P62 R10
G1 E-.04 F1800
G1 X144.584 Y124.924 Z1.8 F30000
G1 X149.21 Y110.79 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.191 Y120.422 Z1.8 F30000
G1 X149.21 Y132.79 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.541 Y133.459 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X143.541 Y142.541 E.29204
G1 X133.959 Y142.541 E.30811
G1 X133.959 Y136.041 E.20902
G1 X127.959 Y136.041 E.19294
G1 X127.959 Y115.959 E.64576
G1 X133.959 Y115.959 E.19294
G1 X133.959 Y109.459 E.20902
G1 X143.541 Y109.459 E.30811
G1 X143.541 Y118.541 E.29204
G1 X132.541 Y118.541 E.35372
G1 X132.541 Y133.459 E.47972
G1 X143.501 Y133.459 E.35243
; WIPE_START
G1 X143.51 Y135.459 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.238 Y128.025 Z1.8 F30000
G1 X145.459 Y127.074 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F3600
G1 X145.459 Y120.459 E.21272
G1 X150.459 Y120.459 E.16078
G1 X150.459 Y109.459 E.35372
G1 X152.541 Y109.459 E.06694
G1 X152.541 Y142.541 E1.06379
G1 X150.459 Y142.541 E.06694
G1 X150.459 Y131.541 E.35372
G1 X145.459 Y131.541 E.16078
G1 X145.459 Y127.114 E.14234
; WIPE_START
G1 X145.459 Y125.114 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.076 Y131.362 Z1.8 F30000
G1 X132.948 Y142.948 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F3600
G1 X132.948 Y143.948 E.03216
G1 X103.052 Y143.948 E.96134
G1 X103.052 Y142.552 E.04489
G1 X107.552 Y142.552 E.1447
G1 X107.552 Y136.448 E.19629
G1 X103.052 Y136.448 E.1447
G1 X103.052 Y115.552 E.67194
G1 X107.552 Y115.552 E.1447
G1 X107.552 Y109.448 E.19629
G1 X103.052 Y109.448 E.1447
G1 X103.052 Y108.052 E.04489
G1 X132.948 Y108.052 E.96134
G1 X132.948 Y109.052 E.03216
G1 X152.948 Y109.052 E.64313
G1 X152.948 Y142.948 E1.08997
G1 X132.988 Y142.948 E.64184
G1 X133.355 Y143.355 F30000
G1 F3600
G1 X133.355 Y144.355 E.03216
G1 X102.645 Y144.355 E.98752
G1 X102.645 Y142.145 E.07107
G1 X107.145 Y142.145 E.1447
G1 X107.145 Y136.855 E.17011
G1 X102.645 Y136.855 E.1447
G1 X102.645 Y115.145 E.69812
G1 X107.145 Y115.145 E.1447
G1 X107.145 Y109.855 E.17011
G1 X102.645 Y109.855 E.1447
G1 X102.645 Y107.645 E.07107
G1 X133.355 Y107.645 E.98752
G1 X133.355 Y108.645 E.03216
G1 X153.355 Y108.645 E.64313
G1 X153.355 Y143.355 E1.11615
G1 X133.395 Y143.355 E.64184
; WIPE_START
G1 X133.355 Y144.355 E-.3803
G1 X132.356 Y144.355 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X127.765 Y138.257 Z1.8 F30000
G1 X106.71 Y110.29 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.694 Y119.922 Z1.8 F30000
G1 X106.71 Y141.71 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.323 Y142.242 Z1.8 F30000
G1 X133.79 Y143.79 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
G1 X132.791 Y144.79 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X132.337 Y143.25 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y143.25 E.06208
G1 X126.406 Y143.193 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X127.489 Y143.193 E.03483
G1 X127.489 Y142.793 E.01285
G1 X127.635 Y142.793 E.00468
G1 X127.506 Y142.597 E.00754
G1 X127.383 Y142.16 E.01459
G1 X127.553 Y141.724 E.01508
G1 X127.693 Y141.625 E.0055
G1 X127.693 Y140.807 E.02628
G1 X126.717 Y140.807 E.03138
G1 X126.748 Y140.85 E.0017
G1 X126.871 Y141.287 E.01459
G1 X126.7 Y141.724 E.01508
G1 X126.074 Y142.16 E.02456
G1 X125.759 Y142.597 E.01732
G1 X125.646 Y142.955 E.01207
G1 X125.664 Y143.193 E.00766
G1 X124.56 Y143.193 E.03551
G1 X124.247 Y142.955 E.01261
M73 P63 R10
G1 X124.012 Y142.597 E.01378
G1 X123.888 Y142.16 E.01459
G1 X124.059 Y141.724 E.01508
G1 X124.686 Y141.287 E.02456
G1 X125.001 Y140.85 E.01732
G1 X125.013 Y140.807 E.00143
G1 X123.223 Y140.807 E.05756
G1 X123.254 Y140.85 E.0017
G1 X123.377 Y141.287 E.01459
G1 X123.206 Y141.724 E.01508
G1 X122.58 Y142.16 E.02456
G1 X122.265 Y142.597 E.01732
G1 X122.152 Y142.955 E.01207
G1 X122.17 Y143.193 E.00766
G1 X121.065 Y143.193 E.03551
G1 X120.753 Y142.955 E.01261
G1 X120.518 Y142.597 E.01378
G1 X120.394 Y142.16 E.01459
G1 X120.565 Y141.724 E.01508
G1 X121.191 Y141.287 E.02456
G1 X121.506 Y140.85 E.01732
G1 X121.518 Y140.807 E.00143
G1 X119.728 Y140.807 E.05756
G1 X119.759 Y140.85 E.0017
G1 X119.883 Y141.287 E.01459
G1 X119.712 Y141.724 E.01508
G1 X119.085 Y142.16 E.02456
G1 X118.77 Y142.597 E.01732
G1 X118.658 Y142.955 E.01207
G1 X118.675 Y143.193 E.00766
G1 X117.571 Y143.193 E.03551
G1 X117.259 Y142.955 E.01261
G1 X117.023 Y142.597 E.01378
G1 X116.9 Y142.16 E.01459
G1 X117.071 Y141.724 E.01508
G1 X117.697 Y141.287 E.02456
G1 X118.012 Y140.85 E.01732
G1 X118.024 Y140.807 E.00143
G1 X116.234 Y140.807 E.05756
G1 X116.265 Y140.85 E.0017
G1 X116.388 Y141.287 E.01459
G1 X116.218 Y141.724 E.01508
G1 X115.591 Y142.16 E.02456
G1 X115.276 Y142.597 E.01732
G1 X115.164 Y142.955 E.01207
G1 X115.181 Y143.193 E.00766
G1 X114.077 Y143.193 E.03551
G1 X113.765 Y142.955 E.01261
G1 X113.529 Y142.597 E.01378
G1 X113.406 Y142.16 E.01459
G1 X113.576 Y141.724 E.01508
G1 X114.203 Y141.287 E.02456
G1 X114.518 Y140.85 E.01732
G1 X114.53 Y140.807 E.00143
G1 X112.74 Y140.807 E.05756
G1 X112.771 Y140.85 E.0017
G1 X112.894 Y141.287 E.01459
G1 X112.724 Y141.724 E.01508
G1 X112.097 Y142.16 E.02456
G1 X111.782 Y142.597 E.01732
G1 X111.67 Y142.955 E.01207
G1 X111.687 Y143.193 E.00766
G1 X110.583 Y143.193 E.03551
G1 X110.271 Y142.955 E.01261
G1 X110.035 Y142.597 E.01378
G1 X109.912 Y142.16 E.01459
G1 X110.082 Y141.724 E.01508
G1 X110.709 Y141.287 E.02456
G1 X111.024 Y140.85 E.01732
G1 X111.036 Y140.807 E.00143
G1 X109.246 Y140.807 E.05756
G1 X109.277 Y140.85 E.0017
G1 X109.4 Y141.287 E.01459
G1 X109.229 Y141.724 E.01508
G1 X108.603 Y142.16 E.02456
G1 X108.307 Y142.57 E.01624
G1 X108.307 Y142.793 E.00716
G1 X108.511 Y142.793 E.00654
G1 X108.511 Y143.193 E.01285
G1 X109.313 Y143.193 E.0258
G1 X108.163 Y143.25 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y143.25 E.06208
; WIPE_START
G1 X105.663 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y141.927 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y137.073 E.24736
; WIPE_START
G1 X102.75 Y139.073 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X103.921 Y135.693 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X103.807 Y135.693 E.00367
G1 X103.807 Y134.179 E.04869
G1 X104.035 Y133.862 E.01254
G1 X104.159 Y133.425 E.01459
G1 X103.988 Y132.989 E.01508
G1 X103.807 Y132.812 E.00813
G1 X103.807 Y130.684 E.06842
G1 X104.035 Y130.368 E.01254
G1 X104.159 Y129.931 E.01459
G1 X103.988 Y129.494 E.01508
G1 X103.807 Y129.318 E.00813
G1 X103.807 Y127.19 E.06842
G1 X104.035 Y126.874 E.01254
G1 X104.159 Y126.437 E.01459
G1 X103.988 Y126 E.01508
G1 X103.807 Y125.823 E.00813
G1 X103.807 Y123.696 E.06841
G1 X104.035 Y123.38 E.01254
G1 X104.159 Y122.943 E.01459
G1 X103.988 Y122.506 E.01508
G1 X103.807 Y122.329 E.00813
G1 X103.807 Y120.202 E.06842
G1 X104.035 Y119.885 E.01254
G1 X104.159 Y119.449 E.01459
G1 X103.988 Y119.012 E.01508
G1 X103.807 Y118.835 E.00813
G1 X103.807 Y116.708 E.06842
G1 X104.035 Y116.391 E.01254
G1 X104.059 Y116.307 E.0028
G1 X105.722 Y116.307 E.05348
G1 X105.783 Y116.391 E.00332
G1 X105.906 Y116.828 E.01459
G1 X105.735 Y117.265 E.01508
G1 X105.109 Y117.701 E.02456
G1 X104.794 Y118.138 E.01732
G1 X104.67 Y118.575 E.01459
G1 X104.841 Y119.012 E.01508
G1 X105.468 Y119.449 E.02456
G1 X105.783 Y119.885 E.01732
G1 X105.906 Y120.322 E.01459
G1 X105.735 Y120.759 E.01508
G1 X105.109 Y121.196 E.02456
G1 X104.794 Y121.632 E.01732
G1 X104.67 Y122.069 E.01459
G1 X104.841 Y122.506 E.01508
G1 X105.468 Y122.943 E.02456
G1 X105.783 Y123.38 E.01732
G1 X105.906 Y123.816 E.01459
G1 X105.735 Y124.253 E.01508
G1 X105.109 Y124.69 E.02456
G1 X104.794 Y125.127 E.01732
G1 X104.67 Y125.563 E.01459
G1 X104.841 Y126 E.01508
G1 X105.468 Y126.437 E.02456
G1 X105.783 Y126.874 E.01732
G1 X105.906 Y127.311 E.01459
G1 X105.735 Y127.747 E.01508
G1 X105.109 Y128.184 E.02456
G1 X104.794 Y128.621 E.01732
G1 X104.67 Y129.058 E.01459
G1 X104.841 Y129.494 E.01508
G1 X105.468 Y129.931 E.02456
G1 X105.783 Y130.368 E.01732
G1 X105.906 Y130.805 E.01459
G1 X105.735 Y131.241 E.01508
G1 X105.109 Y131.678 E.02456
G1 X104.794 Y132.115 E.01732
G1 X104.67 Y132.552 E.01459
G1 X104.841 Y132.989 E.01508
G1 X105.468 Y133.425 E.02456
G1 X105.783 Y133.862 E.01732
G1 X105.906 Y134.299 E.01459
G1 X105.735 Y134.736 E.01508
G1 X105.109 Y135.172 E.02456
G1 X104.794 Y135.609 E.01732
G1 X104.77 Y135.693 E.00279
G1 X106.601 Y135.693 E.05887
G1 X106.541 Y135.609 E.00331
G1 X106.417 Y135.172 E.01459
G1 X106.588 Y134.736 E.01508
G1 X107.215 Y134.299 E.02456
G1 X107.53 Y133.862 E.01732
G1 X107.653 Y133.425 E.01459
G1 X107.482 Y132.989 E.01508
G1 X106.856 Y132.552 E.02456
G1 X106.541 Y132.115 E.01732
G1 X106.417 Y131.678 E.01459
G1 X106.588 Y131.241 E.01508
G1 X107.215 Y130.805 E.02456
G1 X107.53 Y130.368 E.01732
G1 X107.653 Y129.931 E.01459
G1 X107.482 Y129.494 E.01508
G1 X106.856 Y129.058 E.02456
G1 X106.541 Y128.621 E.01732
G1 X106.417 Y128.184 E.01459
G1 X106.588 Y127.747 E.01508
G1 X107.215 Y127.311 E.02456
G1 X107.53 Y126.874 E.01732
G1 X107.653 Y126.437 E.01459
G1 X107.482 Y126 E.01508
G1 X106.856 Y125.563 E.02456
G1 X106.541 Y125.127 E.01732
G1 X106.417 Y124.69 E.01459
G1 X106.588 Y124.253 E.01508
G1 X107.215 Y123.816 E.02456
G1 X107.53 Y123.38 E.01732
G1 X107.653 Y122.943 E.01459
G1 X107.482 Y122.506 E.01508
G1 X106.856 Y122.069 E.02456
G1 X106.541 Y121.632 E.01732
G1 X106.417 Y121.196 E.01459
G1 X106.588 Y120.759 E.01508
G1 X107.215 Y120.322 E.02456
G1 X107.53 Y119.885 E.01732
G1 X107.653 Y119.449 E.01459
G1 X107.482 Y119.012 E.01508
G1 X106.856 Y118.575 E.02456
G1 X106.541 Y118.138 E.01732
G1 X106.417 Y117.701 E.01459
G1 X106.588 Y117.265 E.01508
G1 X107.215 Y116.828 E.02456
G1 X107.53 Y116.391 E.01732
G1 X107.553 Y116.307 E.0028
G1 X107.693 Y116.307 E.00448
G1 X107.693 Y117.796 E.04788
; WIPE_START
G1 X107.693 Y116.307 E-.56581
G1 X107.553 Y116.307 E-.05295
G1 X107.53 Y116.391 E-.0331
G1 X107.363 Y116.622 E-.10814
; WIPE_END
G1 E-.04 F1800
G1 X108 Y115.755 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y111.744 E.15487
; WIPE_START
G1 X108 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y114.927 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y110.073 E.24736
; WIPE_START
G1 X102.75 Y112.073 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X103.663 Y108.75 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X108.163 Y108.75 E.06208
G1 X108.307 Y110.009 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X108.307 Y109.207 E.02579
G1 X108.511 Y109.207 E.00654
G1 X108.511 Y108.807 E.01285
G1 X108.734 Y108.807 E.00718
G1 X108.962 Y108.966 E.00893
G1 X109.277 Y109.403 E.01732
G1 X109.4 Y109.84 E.01459
G1 X109.229 Y110.276 E.01508
G1 X108.603 Y110.713 E.02456
G1 X108.307 Y111.123 E.01624
G1 X108.307 Y111.193 E.00224
G1 X110.058 Y111.193 E.05628
G1 X109.912 Y110.713 E.01612
G1 X110.082 Y110.276 E.01508
G1 X110.709 Y109.84 E.02456
G1 X111.024 Y109.403 E.01732
G1 X111.147 Y108.966 E.01459
G1 X111.085 Y108.807 E.00548
G1 X112.228 Y108.807 E.03676
G1 X112.456 Y108.966 E.00893
G1 X112.771 Y109.403 E.01732
G1 X112.894 Y109.84 E.01459
G1 X112.724 Y110.276 E.01508
G1 X112.097 Y110.713 E.02456
G1 X111.765 Y111.193 E.01875
G1 X113.552 Y111.193 E.05745
G1 X113.406 Y110.713 E.01612
G1 X113.576 Y110.276 E.01508
G1 X114.203 Y109.84 E.02456
G1 X114.518 Y109.403 E.01732
G1 X114.641 Y108.966 E.01459
G1 X114.579 Y108.807 E.00548
G1 X115.722 Y108.807 E.03676
G1 X115.95 Y108.966 E.00893
G1 X116.265 Y109.403 E.01732
G1 X116.388 Y109.84 E.01459
G1 X116.218 Y110.276 E.01508
G1 X115.591 Y110.713 E.02456
G1 X115.26 Y111.193 E.01875
G1 X117.046 Y111.193 E.05745
G1 X116.9 Y110.713 E.01612
G1 X117.071 Y110.276 E.01508
G1 X117.697 Y109.84 E.02456
G1 X118.012 Y109.403 E.01732
G1 X118.136 Y108.966 E.01459
G1 X118.074 Y108.807 E.00548
G1 X119.217 Y108.807 E.03676
G1 X119.444 Y108.966 E.00893
G1 X119.759 Y109.403 E.01732
G1 X119.883 Y109.84 E.01459
G1 X119.712 Y110.276 E.01508
G1 X119.085 Y110.713 E.02456
G1 X118.754 Y111.193 E.01875
G1 X120.54 Y111.193 E.05745
G1 X120.394 Y110.713 E.01612
G1 X120.565 Y110.276 E.01508
G1 X121.191 Y109.84 E.02456
G1 X121.506 Y109.403 E.01732
G1 X121.63 Y108.966 E.01459
G1 X121.568 Y108.807 E.00548
G1 X122.711 Y108.807 E.03676
G1 X122.939 Y108.966 E.00893
G1 X123.254 Y109.403 E.01732
G1 X123.377 Y109.84 E.01459
G1 X123.206 Y110.276 E.01508
G1 X122.58 Y110.713 E.02456
G1 X122.248 Y111.193 E.01875
G1 X124.034 Y111.193 E.05745
G1 X123.888 Y110.713 E.01612
G1 X124.059 Y110.276 E.01508
G1 X124.686 Y109.84 E.02456
G1 X125.001 Y109.403 E.01732
G1 X125.124 Y108.966 E.01459
G1 X125.062 Y108.807 E.00548
G1 X126.205 Y108.807 E.03676
G1 X126.433 Y108.966 E.00893
G1 X126.748 Y109.403 E.01732
G1 X126.871 Y109.84 E.01459
G1 X126.7 Y110.276 E.01508
G1 X126.074 Y110.713 E.02456
G1 X125.742 Y111.193 E.01875
G1 X127.529 Y111.193 E.05745
G1 X127.383 Y110.713 E.01612
G1 X127.553 Y110.276 E.01508
G1 X127.693 Y110.177 E.0055
G1 X127.693 Y109.207 E.0312
G1 X127.489 Y109.207 E.00654
G1 X127.489 Y108.807 E.01285
G1 X127.434 Y108.807 E.00177
G1 X127.837 Y108.75 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X132.337 Y108.75 E.06208
; WIPE_START
G1 X130.337 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.819 Y109.807 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X135.191 Y109.807 E.05236
G1 X135.168 Y109.84 E.00128
G1 X134.541 Y110.276 E.02456
G1 X134.371 Y110.713 E.01508
G1 X134.494 Y111.15 E.01459
G1 X134.809 Y111.587 E.01732
G1 X135.436 Y112.023 E.02456
G1 X135.606 Y112.46 E.01508
G1 X135.483 Y112.897 E.01459
G1 X135.168 Y113.334 E.01732
G1 X134.541 Y113.771 E.02456
G1 X134.371 Y114.207 E.01508
G1 X134.494 Y114.644 E.01459
G1 X134.809 Y115.081 E.01732
G1 X135.436 Y115.518 E.02456
G1 X135.606 Y115.954 E.01508
G1 X135.483 Y116.391 E.01459
G1 X135.168 Y116.828 E.01732
G1 X134.541 Y117.265 E.02456
G1 X134.371 Y117.702 E.01508
G1 X134.494 Y118.138 E.01459
G1 X134.533 Y118.193 E.00215
G1 X136.226 Y118.193 E.05443
G1 X136.241 Y118.138 E.00182
G1 X136.556 Y117.702 E.01732
G1 X137.183 Y117.265 E.02456
G1 X137.353 Y116.828 E.01508
G1 X137.23 Y116.391 E.01459
G1 X136.915 Y115.954 E.01732
G1 X136.288 Y115.518 E.02456
G1 X136.118 Y115.081 E.01508
G1 X136.241 Y114.644 E.01459
G1 X136.556 Y114.207 E.01732
G1 X137.183 Y113.771 E.02456
G1 X137.353 Y113.334 E.01508
G1 X137.23 Y112.897 E.01459
G1 X136.915 Y112.46 E.01732
G1 X136.288 Y112.023 E.02456
G1 X136.118 Y111.587 E.01508
G1 X136.241 Y111.15 E.01459
G1 X136.556 Y110.713 E.01732
G1 X137.183 Y110.276 E.02456
G1 X137.353 Y109.84 E.01508
G1 X137.344 Y109.807 E.00108
G1 X138.685 Y109.807 E.04313
G1 X138.662 Y109.84 E.00128
G1 X138.035 Y110.276 E.02456
G1 X137.865 Y110.713 E.01508
G1 X137.988 Y111.15 E.01459
G1 X138.303 Y111.587 E.01732
G1 X138.93 Y112.023 E.02456
G1 X139.1 Y112.46 E.01508
G1 X138.977 Y112.897 E.01459
G1 X138.662 Y113.334 E.01732
G1 X138.035 Y113.771 E.02456
G1 X137.865 Y114.207 E.01508
G1 X137.988 Y114.644 E.01459
G1 X138.303 Y115.081 E.01732
G1 X138.93 Y115.518 E.02456
G1 X139.1 Y115.954 E.01508
G1 X138.977 Y116.391 E.01459
G1 X138.662 Y116.828 E.01732
G1 X138.035 Y117.265 E.02456
M73 P64 R10
G1 X137.865 Y117.702 E.01508
G1 X137.988 Y118.138 E.01459
G1 X138.027 Y118.193 E.00215
G1 X139.72 Y118.193 E.05443
G1 X139.735 Y118.138 E.00182
G1 X140.05 Y117.702 E.01732
G1 X140.677 Y117.265 E.02456
G1 X140.847 Y116.828 E.01508
G1 X140.724 Y116.391 E.01459
G1 X140.409 Y115.954 E.01732
G1 X139.783 Y115.518 E.02456
G1 X139.612 Y115.081 E.01508
G1 X139.735 Y114.644 E.01459
G1 X140.05 Y114.207 E.01732
G1 X140.677 Y113.771 E.02456
G1 X140.847 Y113.334 E.01508
G1 X140.724 Y112.897 E.01459
G1 X140.409 Y112.46 E.01732
G1 X139.783 Y112.023 E.02456
G1 X139.612 Y111.587 E.01508
G1 X139.735 Y111.15 E.01459
G1 X140.05 Y110.713 E.01732
G1 X140.677 Y110.276 E.02456
G1 X140.847 Y109.84 E.01508
G1 X140.838 Y109.807 E.00108
G1 X142.18 Y109.807 E.04313
G1 X142.156 Y109.84 E.00128
G1 X141.53 Y110.276 E.02456
G1 X141.359 Y110.713 E.01508
G1 X141.482 Y111.15 E.01459
G1 X141.797 Y111.587 E.01732
G1 X142.424 Y112.023 E.02456
G1 X142.595 Y112.46 E.01508
G1 X142.471 Y112.897 E.01459
G1 X142.156 Y113.334 E.01732
G1 X141.53 Y113.771 E.02456
G1 X141.359 Y114.207 E.01508
G1 X141.482 Y114.644 E.01459
G1 X141.797 Y115.081 E.01732
G1 X142.424 Y115.518 E.02456
G1 X142.595 Y115.954 E.01508
G1 X142.471 Y116.391 E.01459
G1 X142.156 Y116.828 E.01732
G1 X141.53 Y117.265 E.02456
G1 X141.359 Y117.702 E.01508
G1 X141.482 Y118.138 E.01459
G1 X141.522 Y118.193 E.00215
G1 X143.193 Y118.193 E.05374
G1 X143.193 Y115.303 E.09294
G1 X143.106 Y115.081 E.00765
G1 X143.193 Y114.774 E.01024
G1 X143.193 Y111.808 E.09538
G1 X143.106 Y111.587 E.00765
G1 X143.193 Y111.28 E.01024
G1 X143.193 Y109.807 E.04736
G1 X143.037 Y109.807 E.005
G1 X143.745 Y109.5 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X150.256 Y109.5 E.2514
; WIPE_START
G1 X148.256 Y109.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X151.176 Y116.551 Z1.8 F30000
G1 X152.193 Y119.005 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X152.193 Y120.633 E.05236
G1 X152.012 Y120.759 E.00709
G1 X151.841 Y121.196 E.01508
G1 X151.965 Y121.633 E.01459
G1 X152.193 Y121.949 E.01254
G1 X152.193 Y124.127 E.07005
G1 X152.012 Y124.253 E.00709
G1 X151.841 Y124.69 E.01508
G1 X151.965 Y125.127 E.01459
G1 X152.193 Y125.443 E.01254
G1 X152.193 Y127.621 E.07005
G1 X152.012 Y127.747 E.00709
G1 X151.841 Y128.184 E.01508
G1 X151.965 Y128.621 E.01459
G1 X152.193 Y128.937 E.01254
G1 X152.193 Y131.116 E.07005
G1 X152.012 Y131.242 E.00709
G1 X151.841 Y131.678 E.01508
G1 X151.965 Y132.115 E.01459
G1 X152.193 Y132.431 E.01254
G1 X152.193 Y134.61 E.07005
G1 X152.012 Y134.736 E.00709
G1 X151.841 Y135.173 E.01508
G1 X151.965 Y135.609 E.01459
G1 X152.193 Y135.926 E.01254
G1 X152.193 Y138.104 E.07005
G1 X152.012 Y138.23 E.00709
G1 X151.841 Y138.667 E.01508
G1 X151.965 Y139.104 E.01459
G1 X152.193 Y139.42 E.01254
G1 X152.193 Y141.598 E.07005
G1 X152.012 Y141.724 E.00709
G1 X151.841 Y142.161 E.01508
G1 X151.85 Y142.193 E.00106
G1 X150.807 Y142.193 E.03354
G1 X150.807 Y141.969 E.00718
G1 X151.159 Y141.724 E.01379
G1 X151.33 Y141.287 E.01508
G1 X151.206 Y140.851 E.01459
G1 X150.891 Y140.414 E.01732
G1 X150.807 Y140.355 E.0033
G1 X150.807 Y138.475 E.06045
G1 X151.159 Y138.23 E.01379
G1 X151.33 Y137.793 E.01508
G1 X151.206 Y137.356 E.01459
G1 X150.891 Y136.92 E.01732
G1 X150.807 Y136.861 E.0033
G1 X150.807 Y134.981 E.06045
G1 X151.159 Y134.736 E.01379
G1 X151.33 Y134.299 E.01508
G1 X151.206 Y133.862 E.01459
G1 X150.891 Y133.425 E.01732
G1 X150.807 Y133.367 E.0033
G1 X150.807 Y131.487 E.06045
G1 X151.159 Y131.242 E.01379
G1 X151.33 Y130.805 E.01508
G1 X151.206 Y130.368 E.01459
G1 X150.891 Y129.931 E.01732
G1 X150.265 Y129.495 E.02456
G1 X150.094 Y129.058 E.01508
G1 X150.218 Y128.621 E.01459
G1 X150.533 Y128.184 E.01732
G1 X151.159 Y127.747 E.02456
G1 X151.33 Y127.311 E.01508
G1 X151.206 Y126.874 E.01459
G1 X150.891 Y126.437 E.01732
G1 X150.265 Y126 E.02456
G1 X150.094 Y125.564 E.01508
G1 X150.218 Y125.127 E.01459
G1 X150.533 Y124.69 E.01732
G1 X151.159 Y124.253 E.02456
G1 X151.33 Y123.816 E.01508
G1 X151.206 Y123.38 E.01459
G1 X150.891 Y122.943 E.01732
G1 X150.265 Y122.506 E.02456
G1 X150.094 Y122.069 E.01508
G1 X150.218 Y121.633 E.01459
G1 X150.533 Y121.196 E.01732
G1 X151.159 Y120.759 E.02456
G1 X151.33 Y120.322 E.01508
G1 X151.206 Y119.885 E.01459
G1 X150.891 Y119.449 E.01732
G1 X150.807 Y119.39 E.0033
G1 X150.807 Y117.51 E.06045
G1 X151.159 Y117.265 E.01379
G1 X151.33 Y116.828 E.01508
G1 X151.206 Y116.391 E.01459
G1 X150.891 Y115.954 E.01732
G1 X150.807 Y115.896 E.0033
G1 X150.807 Y114.016 E.06045
G1 X151.159 Y113.771 E.01379
G1 X151.33 Y113.334 E.01508
G1 X151.206 Y112.897 E.01459
G1 X150.891 Y112.46 E.01732
G1 X150.807 Y112.402 E.0033
G1 X150.807 Y110.522 E.06045
G1 X151.159 Y110.276 E.01379
G1 X151.33 Y109.84 E.01508
G1 X151.321 Y109.807 E.00108
G1 X152.193 Y109.807 E.02804
G1 X152.193 Y110.15 E.01103
G1 X152.012 Y110.276 E.00709
G1 X151.841 Y110.713 E.01508
G1 X151.965 Y111.15 E.01459
G1 X152.193 Y111.466 E.01254
G1 X152.193 Y113.645 E.07005
G1 X152.012 Y113.771 E.00709
G1 X151.841 Y114.207 E.01508
G1 X151.965 Y114.644 E.01459
G1 X152.193 Y114.96 E.01254
G1 X152.193 Y117.139 E.07005
G1 X152.012 Y117.265 E.00709
G1 X151.841 Y117.702 E.01508
G1 X151.965 Y118.138 E.01459
G1 X152.193 Y118.455 E.01254
G1 X152.193 Y119.005 E.01769
; WIPE_START
G1 X152.193 Y118.455 E-.20905
G1 X151.965 Y118.138 E-.14816
G1 X151.841 Y117.702 E-.17246
G1 X152.012 Y117.265 E-.17819
G1 X152.125 Y117.186 E-.05215
; WIPE_END
G1 E-.04 F1800
G1 X145.845 Y120.807 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
G1 F4200
G1 X145.807 Y120.807 E.00121
G1 X145.807 Y122.398 E.05116
G1 X145.918 Y122.506 E.00497
G1 X146.088 Y122.943 E.01508
G1 X145.965 Y123.38 E.01459
G1 X145.807 Y123.599 E.00868
G1 X145.807 Y125.892 E.07376
G1 X145.918 Y126 E.00497
G1 X146.088 Y126.437 E.01508
G1 X145.965 Y126.874 E.01459
G1 X145.807 Y127.093 E.00868
G1 X145.807 Y129.387 E.07376
G1 X145.918 Y129.495 E.00497
G1 X146.088 Y129.931 E.01508
G1 X145.965 Y130.368 E.01459
G1 X145.807 Y130.587 E.00868
G1 X145.807 Y131.193 E.01948
G1 X147.684 Y131.193 E.06035
G1 X147.836 Y130.805 E.01339
G1 X147.712 Y130.368 E.01459
G1 X147.397 Y129.931 E.01732
G1 X146.771 Y129.495 E.02456
G1 X146.6 Y129.058 E.01508
G1 X146.723 Y128.621 E.01459
G1 X147.038 Y128.184 E.01732
G1 X147.665 Y127.747 E.02456
G1 X147.836 Y127.311 E.01508
G1 X147.712 Y126.874 E.01459
G1 X147.397 Y126.437 E.01732
G1 X146.771 Y126 E.02456
G1 X146.6 Y125.564 E.01508
G1 X146.723 Y125.127 E.01459
G1 X147.038 Y124.69 E.01732
G1 X147.665 Y124.253 E.02456
G1 X147.836 Y123.816 E.01508
G1 X147.712 Y123.38 E.01459
G1 X147.397 Y122.943 E.01732
G1 X146.771 Y122.506 E.02456
G1 X146.6 Y122.069 E.01508
G1 X146.723 Y121.633 E.01459
G1 X147.038 Y121.196 E.01732
G1 X147.596 Y120.807 E.02185
G1 X148.499 Y120.807 E.02904
G1 X148.347 Y121.196 E.01341
G1 X148.47 Y121.633 E.01459
G1 X148.785 Y122.069 E.01732
G1 X149.412 Y122.506 E.02456
G1 X149.583 Y122.943 E.01508
G1 X149.459 Y123.38 E.01459
G1 X149.144 Y123.816 E.01732
G1 X148.518 Y124.253 E.02456
G1 X148.347 Y124.69 E.01508
G1 X148.47 Y125.127 E.01459
G1 X148.785 Y125.564 E.01732
G1 X149.412 Y126 E.02456
G1 X149.583 Y126.437 E.01508
G1 X149.459 Y126.874 E.01459
G1 X149.144 Y127.311 E.01732
G1 X148.518 Y127.747 E.02456
G1 X148.347 Y128.184 E.01508
G1 X148.47 Y128.621 E.01459
G1 X148.785 Y129.058 E.01732
G1 X149.412 Y129.495 E.02456
G1 X149.583 Y129.931 E.01508
G1 X149.459 Y130.368 E.01459
G1 X149.144 Y130.805 E.01732
G1 X148.588 Y131.193 E.02181
G1 X150.216 Y131.193 E.05236
; WIPE_START
G1 X148.588 Y131.193 E-.61876
G1 X148.893 Y130.98 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X149.789 Y138.56 Z1.8 F30000
G1 X150.256 Y142.5 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X143.745 Y142.5 E.2514
; WIPE_START
G1 X145.745 Y142.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.193 Y141.39 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X143.193 Y139.762 E.05236
G1 X143.106 Y139.54 E.00765
G1 X143.193 Y139.234 E.01024
G1 X143.193 Y136.268 E.09538
G1 X143.106 Y136.046 E.00765
G1 X143.193 Y135.74 E.01024
G1 X143.193 Y133.807 E.06213
G1 X142.487 Y133.807 E.0227
G1 X142.471 Y133.862 E.00184
G1 X142.156 Y134.299 E.01732
G1 X141.53 Y134.736 E.02456
G1 X141.359 Y135.173 E.01508
G1 X141.482 Y135.609 E.01459
G1 X141.797 Y136.046 E.01732
G1 X142.424 Y136.483 E.02456
G1 X142.595 Y136.92 E.01508
G1 X142.471 Y137.356 E.01459
G1 X142.156 Y137.793 E.01732
G1 X141.53 Y138.23 E.02456
G1 X141.359 Y138.667 E.01508
G1 X141.482 Y139.104 E.01459
G1 X141.797 Y139.54 E.01732
G1 X142.424 Y139.977 E.02456
G1 X142.595 Y140.414 E.01508
G1 X142.471 Y140.851 E.01459
G1 X142.156 Y141.287 E.01732
G1 X141.53 Y141.724 E.02456
G1 X141.359 Y142.161 E.01508
G1 X141.368 Y142.193 E.00106
G1 X140.027 Y142.193 E.04311
G1 X140.05 Y142.161 E.00126
G1 X140.677 Y141.724 E.02456
G1 X140.847 Y141.287 E.01508
G1 X140.724 Y140.851 E.01459
G1 X140.409 Y140.414 E.01732
G1 X139.783 Y139.977 E.02456
G1 X139.612 Y139.54 E.01508
G1 X139.735 Y139.104 E.01459
G1 X140.05 Y138.667 E.01732
G1 X140.677 Y138.23 E.02456
G1 X140.847 Y137.793 E.01508
G1 X140.724 Y137.356 E.01459
G1 X140.409 Y136.92 E.01732
G1 X139.783 Y136.483 E.02456
G1 X139.612 Y136.046 E.01508
G1 X139.735 Y135.609 E.01459
G1 X140.05 Y135.173 E.01732
G1 X140.677 Y134.736 E.02456
G1 X140.847 Y134.299 E.01508
G1 X140.724 Y133.862 E.01459
G1 X140.685 Y133.807 E.00218
G1 X138.993 Y133.807 E.05441
G1 X138.977 Y133.862 E.00184
G1 X138.662 Y134.299 E.01732
G1 X138.035 Y134.736 E.02456
G1 X137.865 Y135.173 E.01508
G1 X137.988 Y135.609 E.01459
G1 X138.303 Y136.046 E.01732
G1 X138.93 Y136.483 E.02456
G1 X139.1 Y136.92 E.01508
G1 X138.977 Y137.356 E.01459
G1 X138.662 Y137.793 E.01732
G1 X138.035 Y138.23 E.02456
G1 X137.865 Y138.667 E.01508
G1 X137.988 Y139.104 E.01459
G1 X138.303 Y139.54 E.01732
G1 X138.93 Y139.977 E.02456
G1 X139.1 Y140.414 E.01508
G1 X138.977 Y140.851 E.01459
G1 X138.662 Y141.287 E.01732
G1 X138.035 Y141.724 E.02456
G1 X137.865 Y142.161 E.01508
G1 X137.874 Y142.193 E.00106
G1 X136.533 Y142.193 E.04311
G1 X136.556 Y142.161 E.00126
G1 X137.183 Y141.724 E.02456
G1 X137.353 Y141.287 E.01508
G1 X137.23 Y140.851 E.01459
G1 X136.915 Y140.414 E.01732
G1 X136.288 Y139.977 E.02456
G1 X136.118 Y139.54 E.01508
G1 X136.241 Y139.104 E.01459
G1 X136.556 Y138.667 E.01732
G1 X137.183 Y138.23 E.02456
G1 X137.353 Y137.793 E.01508
G1 X137.23 Y137.356 E.01459
G1 X136.915 Y136.92 E.01732
G1 X136.288 Y136.483 E.02456
G1 X136.118 Y136.046 E.01508
G1 X136.241 Y135.609 E.01459
G1 X136.556 Y135.173 E.01732
G1 X137.183 Y134.736 E.02456
G1 X137.353 Y134.299 E.01508
G1 X137.23 Y133.862 E.01459
G1 X137.19 Y133.807 E.00218
G1 X135.498 Y133.807 E.05441
G1 X135.483 Y133.862 E.00184
G1 X135.168 Y134.299 E.01732
G1 X134.541 Y134.736 E.02456
G1 X134.371 Y135.173 E.01508
G1 X134.494 Y135.609 E.01459
G1 X134.809 Y136.046 E.01732
G1 X135.436 Y136.483 E.02456
G1 X135.606 Y136.92 E.01508
G1 X135.483 Y137.356 E.01459
G1 X135.168 Y137.793 E.01732
G1 X134.541 Y138.23 E.02456
G1 X134.371 Y138.667 E.01508
G1 X134.494 Y139.104 E.01459
G1 X134.809 Y139.54 E.01732
G1 X135.436 Y139.977 E.02456
G1 X135.606 Y140.414 E.01508
G1 X135.483 Y140.851 E.01459
G1 X135.168 Y141.287 E.01732
G1 X134.541 Y141.724 E.02456
G1 X134.371 Y142.161 E.01508
G1 X134.38 Y142.193 E.00106
G1 X134.307 Y142.193 E.00232
G1 X134.307 Y140.637 E.05004
; WIPE_START
G1 X134.307 Y142.193 E-.5913
G1 X134.38 Y142.193 E-.02747
G1 X134.371 Y142.161 E-.01252
G1 X134.494 Y141.845 E-.12872
; WIPE_END
G1 E-.04 F1800
G1 X128 Y140.256 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y136.245 E.15488
; WIPE_START
G1 X128 Y138.245 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.307 Y134.986 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X128.307 Y135.693 E.02272
G1 X129.229 Y135.693 E.02964
G1 X129.253 Y135.609 E.00278
G1 X129.568 Y135.173 E.01732
G1 X130.194 Y134.736 E.02456
G1 X130.365 Y134.299 E.01508
G1 X130.242 Y133.862 E.01459
G1 X129.927 Y133.425 E.01732
G1 X129.3 Y132.989 E.02456
G1 X129.129 Y132.552 E.01508
G1 X129.253 Y132.115 E.01459
G1 X129.568 Y131.678 E.01732
G1 X130.194 Y131.242 E.02456
G1 X130.365 Y130.805 E.01508
G1 X130.242 Y130.368 E.01459
G1 X129.927 Y129.931 E.01732
G1 X129.3 Y129.495 E.02456
G1 X129.129 Y129.058 E.01508
G1 X129.253 Y128.621 E.01459
G1 X129.568 Y128.184 E.01732
G1 X130.194 Y127.747 E.02456
G1 X130.365 Y127.311 E.01508
G1 X130.242 Y126.874 E.01459
G1 X129.927 Y126.437 E.01732
G1 X129.3 Y126 E.02456
G1 X129.129 Y125.564 E.01508
G1 X129.253 Y125.127 E.01459
G1 X129.568 Y124.69 E.01732
G1 X130.194 Y124.253 E.02456
G1 X130.365 Y123.816 E.01508
G1 X130.242 Y123.38 E.01459
G1 X129.927 Y122.943 E.01732
G1 X129.3 Y122.506 E.02456
G1 X129.129 Y122.069 E.01508
G1 X129.253 Y121.633 E.01459
G1 X129.568 Y121.196 E.01732
G1 X130.194 Y120.759 E.02456
G1 X130.365 Y120.322 E.01508
G1 X130.242 Y119.885 E.01459
G1 X129.927 Y119.449 E.01732
G1 X129.3 Y119.012 E.02456
G1 X129.129 Y118.575 E.01508
G1 X129.253 Y118.138 E.01459
G1 X129.568 Y117.702 E.01732
G1 X130.194 Y117.265 E.02456
G1 X130.365 Y116.828 E.01508
G1 X130.242 Y116.391 E.01459
G1 X130.181 Y116.307 E.00333
G1 X128.518 Y116.307 E.05347
G1 X128.494 Y116.391 E.00281
G1 X128.307 Y116.651 E.01029
G1 X128.307 Y118.875 E.07153
G1 X128.447 Y119.012 E.00629
G1 X128.618 Y119.449 E.01508
G1 X128.494 Y119.885 E.01459
G1 X128.307 Y120.145 E.01029
G1 X128.307 Y122.369 E.07153
G1 X128.447 Y122.506 E.00629
G1 X128.618 Y122.943 E.01508
G1 X128.494 Y123.38 E.01459
G1 X128.307 Y123.639 E.01029
G1 X128.307 Y125.864 E.07153
G1 X128.447 Y126 E.00629
G1 X128.618 Y126.437 E.01508
G1 X128.494 Y126.874 E.01459
G1 X128.307 Y127.133 E.01029
G1 X128.307 Y129.358 E.07153
G1 X128.447 Y129.495 E.00629
G1 X128.618 Y129.931 E.01508
G1 X128.494 Y130.368 E.01459
G1 X128.307 Y130.628 E.01029
G1 X128.307 Y132.852 E.07153
G1 X128.447 Y132.989 E.00629
G1 X128.618 Y133.425 E.01508
G1 X128.494 Y133.862 E.01459
G1 X128.307 Y134.122 E.01029
G1 X128.307 Y134.986 E.0278
G1 X135.295 Y133.807 F30000
G1 F4200
G1 X133.696 Y133.807 E.05141
G1 X133.736 Y133.862 E.00218
G1 X133.859 Y134.299 E.01459
G1 X133.688 Y134.736 E.01508
G1 X133.062 Y135.173 E.02456
G1 X132.747 Y135.609 E.01732
G1 X132.723 Y135.693 E.00278
G1 X131.06 Y135.693 E.05349
G1 X131 Y135.609 E.0033
G1 X130.876 Y135.173 E.01459
G1 X131.047 Y134.736 E.01508
G1 X131.674 Y134.299 E.02456
G1 X131.989 Y133.862 E.01732
G1 X132.112 Y133.425 E.01459
G1 X131.941 Y132.989 E.01508
G1 X131.315 Y132.552 E.02456
G1 X131 Y132.115 E.01732
G1 X130.876 Y131.678 E.01459
G1 X131.047 Y131.242 E.01508
G1 X131.674 Y130.805 E.02456
G1 X131.989 Y130.368 E.01732
G1 X132.112 Y129.931 E.01459
G1 X131.941 Y129.495 E.01508
G1 X131.315 Y129.058 E.02456
G1 X131 Y128.621 E.01732
G1 X130.876 Y128.184 E.01459
G1 X131.047 Y127.747 E.01508
G1 X131.674 Y127.311 E.02456
G1 X131.989 Y126.874 E.01732
G1 X132.112 Y126.437 E.01459
G1 X131.941 Y126 E.01508
G1 X131.315 Y125.564 E.02456
G1 X131 Y125.127 E.01732
G1 X130.876 Y124.69 E.01459
G1 X131.047 Y124.253 E.01508
G1 X131.674 Y123.816 E.02456
G1 X131.989 Y123.38 E.01732
G1 X132.112 Y122.943 E.01459
G1 X131.941 Y122.506 E.01508
G1 X131.315 Y122.069 E.02456
G1 X131 Y121.633 E.01732
G1 X130.876 Y121.196 E.01459
G1 X131.047 Y120.759 E.01508
G1 X131.674 Y120.322 E.02456
G1 X131.989 Y119.885 E.01732
G1 X132.112 Y119.449 E.01459
G1 X131.941 Y119.012 E.01508
G1 X131.315 Y118.575 E.02456
G1 X131 Y118.138 E.01732
G1 X130.876 Y117.702 E.01459
G1 X131.047 Y117.265 E.01508
G1 X131.674 Y116.828 E.02456
G1 X131.989 Y116.391 E.01732
G1 X132.012 Y116.307 E.00281
G1 X133.675 Y116.307 E.05347
G1 X133.736 Y116.391 E.00333
G1 X133.859 Y116.828 E.01459
G1 X133.688 Y117.265 E.01508
G1 X133.062 Y117.702 E.02456
G1 X132.747 Y118.138 E.01732
G1 X132.732 Y118.193 E.00182
G1 X134.33 Y118.193 E.05139
; WIPE_START
G1 X132.732 Y118.193 E-.60728
G1 X132.747 Y118.138 E-.02146
G1 X132.949 Y117.858 E-.13127
; WIPE_END
G1 E-.04 F1800
G1 X128 Y115.755 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y111.744 E.15488
; WIPE_START
G1 X128 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.929 Y119.449 Z1.8 F30000
G1 X108 Y136.245 Z1.8
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y140.256 E.15487
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F4909.984
G1 X108 Y138.256 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 8/27
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
G17
G3 Z1.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X129.29 Y142.552
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y142.552 E.02708
G1 X128.448 Y136.448 E.19629
G1 X133.552 Y136.448 E.16413
G1 X133.552 Y142.552 E.19629
G1 X129.33 Y142.552 E.13577
G1 X128.855 Y141.71 F30000
G1 F3600
G1 X128.855 Y136.855 E.15612
G1 X133.145 Y136.855 E.13795
G1 X133.145 Y142.145 E.17011
G1 X128.855 Y142.145 E.13795
G1 X128.855 Y141.75 E.0127
M204 S250
G1 X129.29 Y141.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y141.71 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y142.959 E.04017
G1 X132.541 Y142.959 E.1447
G1 X132.541 Y143.541 E.01871
G1 X103.459 Y143.541 E.93516
G1 X103.459 Y142.959 E.01871
G1 X107.959 Y142.959 E.1447
G1 X107.959 Y140.459 E.08039
G1 X128.041 Y140.459 E.64576
G1 X128.041 Y141.67 E.03894
; WIPE_START
G1 X128.041 Y142.959 E-.48987
G1 X128.752 Y142.959 E-.27013
; WIPE_END
G1 E-.04 F1800
G1 X121.47 Y140.673 Z2 F30000
G1 X106.71 Y136.041 Z2
G1 Z1.6
G1 E.8 F1800
G1 F3600
G1 X103.459 Y136.041 E.10454
G1 X103.459 Y115.959 E.64576
G1 X108.041 Y115.959 E.14733
G1 X108.041 Y136.041 E.64576
G1 X106.75 Y136.041 E.04151
; WIPE_START
G1 X104.75 Y136.041 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y140.052 Z2 F30000
G1 Z1.6
G1 E.8 F1800
G1 F3600
G1 X108.448 Y140.052 E.02708
G1 X108.448 Y111.948 E.90373
G1 X127.552 Y111.948 E.61432
G1 X127.552 Y140.052 E.90373
G1 X109.33 Y140.052 E.58595
G1 X109.29 Y139.645 F30000
G1 F3600
G1 X108.855 Y139.645 E.01399
G1 X108.855 Y112.355 E.87755
G1 X127.145 Y112.355 E.58814
G1 X127.145 Y139.645 E.87755
G1 X109.33 Y139.645 E.57287
M204 S250
G1 X109.29 Y139.21 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.747 Y130.987 Z2 F30000
G1 X128.448 Y110.29 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y109.448 E.02708
G1 X133.552 Y109.448 E.16413
G1 X133.552 Y115.552 E.19629
G1 X128.448 Y115.552 E.16413
G1 X128.448 Y110.33 E.16792
G1 X129.29 Y109.855 F30000
G1 F3600
G1 X133.145 Y109.855 E.12396
G1 X133.145 Y115.145 E.17011
G1 X128.855 Y115.145 E.13795
G1 X128.855 Y109.855 E.17011
G1 X129.25 Y109.855 E.0127
M204 S250
G1 X129.29 Y110.29 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y110.29 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y111.541 E.04022
G1 X107.959 Y111.541 E.64576
G1 X107.959 Y109.041 E.08039
G1 X103.459 Y109.041 E.1447
G1 X103.459 Y108.459 E.01871
G1 X132.541 Y108.459 E.93516
G1 X132.541 Y109.041 E.01871
G1 X128.041 Y109.041 E.1447
G1 X128.041 Y110.25 E.03888
; WIPE_START
G1 X128.041 Y111.541 E-.49053
G1 X127.332 Y111.541 E-.26947
; WIPE_END
G1 E-.04 F1800
G1 X134.944 Y110.987 Z2 F30000
G1 X149.21 Y109.948 Z2
G1 Z1.6
G1 E.8 F1800
G1 F3600
G1 X150.052 Y109.948 E.02708
G1 X150.052 Y120.052 E.32491
G1 X145.052 Y120.052 E.16078
G1 X145.052 Y131.948 E.38253
G1 X150.052 Y131.948 E.16078
G1 X150.052 Y142.052 E.32491
G1 X143.948 Y142.052 E.19629
G1 X143.948 Y133.052 E.28941
G1 X132.948 Y133.052 E.35372
G1 X132.948 Y118.948 E.45354
G1 X143.948 Y118.948 E.35372
G1 X143.948 Y109.948 E.28941
G1 X149.17 Y109.948 E.16792
G1 X149.21 Y110.355 F30000
G1 F3600
G1 X149.645 Y110.355 E.01399
G1 X149.645 Y119.645 E.29873
G1 X144.645 Y119.645 E.16078
G1 X144.645 Y132.355 E.40871
G1 X149.645 Y132.355 E.16078
G1 X149.645 Y141.645 E.29873
G1 X144.355 Y141.645 E.17011
G1 X144.355 Y132.645 E.28941
G1 X133.355 Y132.645 E.35372
G1 X133.355 Y119.355 E.42736
G1 X144.355 Y119.355 E.35372
G1 X144.355 Y110.355 E.28941
G1 X149.17 Y110.355 E.15483
; WIPE_START
G1 X149.645 Y110.355 E-.1805
G1 X149.645 Y111.88 E-.5795
; WIPE_END
G1 E-.04 F1800
G1 X147.674 Y119.253 Z2 F30000
G1 X144.21 Y132.21 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X144.584 Y124.924 Z2 F30000
G1 X149.21 Y110.79 Z2
G1 Z1.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
M73 P65 R10
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.191 Y120.422 Z2 F30000
G1 X149.21 Y132.79 Z2
G1 Z1.6
M73 P65 R9
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.541 Y133.459 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X143.541 Y142.541 E.29204
G1 X133.959 Y142.541 E.30811
G1 X133.959 Y136.041 E.20902
G1 X127.959 Y136.041 E.19294
G1 X127.959 Y115.959 E.64576
G1 X133.959 Y115.959 E.19294
G1 X133.959 Y109.459 E.20902
G1 X143.541 Y109.459 E.30811
G1 X143.541 Y118.541 E.29204
G1 X132.541 Y118.541 E.35372
G1 X132.541 Y133.459 E.47972
G1 X143.501 Y133.459 E.35243
; WIPE_START
G1 X143.51 Y135.459 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.238 Y128.025 Z2 F30000
G1 X145.459 Y127.074 Z2
G1 Z1.6
G1 E.8 F1800
G1 F3600
G1 X145.459 Y120.459 E.21272
G1 X150.459 Y120.459 E.16078
G1 X150.459 Y109.459 E.35372
G1 X152.541 Y109.459 E.06694
G1 X152.541 Y142.541 E1.06379
G1 X150.459 Y142.541 E.06694
G1 X150.459 Y131.541 E.35372
G1 X145.459 Y131.541 E.16078
G1 X145.459 Y127.114 E.14234
; WIPE_START
G1 X145.459 Y125.114 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.076 Y131.362 Z2 F30000
G1 X132.948 Y142.948 Z2
G1 Z1.6
G1 E.8 F1800
G1 F3600
G1 X132.948 Y143.948 E.03216
G1 X103.052 Y143.948 E.96134
G1 X103.052 Y142.552 E.04489
G1 X107.552 Y142.552 E.1447
G1 X107.552 Y136.448 E.19629
G1 X103.052 Y136.448 E.1447
G1 X103.052 Y115.552 E.67194
G1 X107.552 Y115.552 E.1447
G1 X107.552 Y109.448 E.19629
G1 X103.052 Y109.448 E.1447
G1 X103.052 Y108.052 E.04489
G1 X132.948 Y108.052 E.96134
G1 X132.948 Y109.052 E.03216
G1 X152.948 Y109.052 E.64313
G1 X152.948 Y142.948 E1.08997
G1 X132.988 Y142.948 E.64184
G1 X133.355 Y143.355 F30000
G1 F3600
G1 X133.355 Y144.355 E.03216
G1 X102.645 Y144.355 E.98752
G1 X102.645 Y142.145 E.07107
G1 X107.145 Y142.145 E.1447
G1 X107.145 Y136.855 E.17011
G1 X102.645 Y136.855 E.1447
G1 X102.645 Y115.145 E.69812
G1 X107.145 Y115.145 E.1447
G1 X107.145 Y109.855 E.17011
G1 X102.645 Y109.855 E.1447
G1 X102.645 Y107.645 E.07107
G1 X133.355 Y107.645 E.98752
G1 X133.355 Y108.645 E.03216
G1 X153.355 Y108.645 E.64313
G1 X153.355 Y143.355 E1.11615
G1 X133.395 Y143.355 E.64184
; WIPE_START
G1 X133.355 Y144.355 E-.3803
G1 X132.356 Y144.355 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X127.765 Y138.257 Z2 F30000
G1 X106.71 Y110.29 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.694 Y119.922 Z2 F30000
G1 X106.71 Y141.71 Z2
G1 Z1.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.323 Y142.242 Z2 F30000
G1 X133.79 Y143.79 Z2
G1 Z1.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
G1 X132.791 Y144.79 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X132.337 Y143.25 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y143.25 E.06208
G1 X127.316 Y142.19 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X127.316 Y141.184 E.03234
G1 X126.693 Y141.184 E.02002
G1 X126.691 Y141.287 E.0033
G1 X126.406 Y141.724 E.01678
G1 X125.988 Y142.16 E.01944
G1 X125.807 Y142.597 E.01521
G1 X125.802 Y142.816 E.00703
G1 X124.14 Y142.816 E.05344
G1 X124.06 Y142.597 E.00749
G1 X124.068 Y142.16 E.01405
G1 X124.354 Y141.724 E.01678
G1 X124.772 Y141.287 E.01944
G1 X124.814 Y141.184 E.00357
G1 X123.199 Y141.184 E.05194
G1 X123.197 Y141.287 E.0033
G1 X122.912 Y141.724 E.01678
G1 X122.494 Y142.16 E.01944
G1 X122.312 Y142.597 E.01521
G1 X122.308 Y142.816 E.00703
G1 X120.646 Y142.816 E.05344
G1 X120.565 Y142.597 E.00749
G1 X120.574 Y142.16 E.01405
G1 X120.859 Y141.724 E.01678
G1 X121.277 Y141.287 E.01944
G1 X121.32 Y141.184 E.00357
G1 X119.705 Y141.184 E.05194
G1 X119.703 Y141.287 E.0033
G1 X119.417 Y141.724 E.01678
G1 X119 Y142.16 E.01944
G1 X118.818 Y142.597 E.01521
M73 P66 R9
G1 X118.813 Y142.816 E.00703
G1 X117.151 Y142.816 E.05344
G1 X117.071 Y142.597 E.00749
G1 X117.08 Y142.16 E.01405
G1 X117.365 Y141.724 E.01678
G1 X117.783 Y141.287 E.01944
G1 X117.826 Y141.184 E.00357
G1 X116.211 Y141.184 E.05194
G1 X116.209 Y141.287 E.0033
G1 X115.923 Y141.724 E.01678
G1 X115.505 Y142.16 E.01944
G1 X115.324 Y142.597 E.01521
G1 X115.319 Y142.816 E.00703
G1 X113.657 Y142.816 E.05344
G1 X113.577 Y142.597 E.00749
G1 X113.586 Y142.16 E.01405
G1 X113.871 Y141.724 E.01678
G1 X114.289 Y141.287 E.01944
G1 X114.331 Y141.184 E.00357
G1 X112.716 Y141.184 E.05194
G1 X112.714 Y141.287 E.0033
G1 X112.429 Y141.724 E.01678
G1 X112.011 Y142.16 E.01944
G1 X111.83 Y142.597 E.01521
G1 X111.825 Y142.816 E.00703
G1 X110.163 Y142.816 E.05344
G1 X110.083 Y142.597 E.00749
G1 X110.091 Y142.16 E.01405
G1 X110.377 Y141.724 E.01678
G1 X110.795 Y141.287 E.01944
G1 X110.837 Y141.184 E.00357
G1 X109.222 Y141.184 E.05194
G1 X109.22 Y141.287 E.0033
G1 X108.935 Y141.724 E.01678
G1 X108.684 Y141.985 E.01165
G1 X108.684 Y142.416 E.01384
G1 X108.888 Y142.416 E.00654
G1 X108.888 Y142.816 E.01285
G1 X109.482 Y142.816 E.01912
G1 X108.163 Y143.25 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y143.25 E.06208
; WIPE_START
G1 X105.663 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y141.927 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y137.073 E.24736
; WIPE_START
G1 X102.75 Y139.073 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X103.981 Y135.678 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.397919
G1 F1500;_EXTRUDE_SET_SPEED
G1 X103.849 Y135.651 E.00377
G1 X103.822 Y135.519 E.00377
G1 X103.822 Y116.481 E.53388
G1 X103.849 Y116.349 E.00377
G1 X103.981 Y116.322 E.00377
G1 X107.519 Y116.322 E.09922
G1 X107.651 Y116.349 E.00377
G1 X107.678 Y116.481 E.00377
G1 X107.678 Y135.519 E.53388
G1 X107.651 Y135.651 E.00377
G1 X107.519 Y135.678 E.00377
G1 X104.041 Y135.678 E.09754
; Slow Down End
; WIPE_START
G1 X106.041 Y135.678 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108 Y136.245 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y140.256 E.15487
; WIPE_START
G1 X108 Y138.256 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X115.567 Y139.25 Z2 F30000
G1 X127.519 Y140.822 Z2
G1 Z1.6
G1 E.8 F1800
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.392205
G1 F1500;_EXTRUDE_SET_SPEED
G1 X127.651 Y140.849 E.00371
G1 X127.678 Y140.981 E.00371
G1 X127.678 Y142.619 E.04521
G1 X127.651 Y142.751 E.00371
G1 X127.502 Y142.806 E.00437
G1 X127.448 Y143.151 E.00964
G1 X127.316 Y143.178 E.00371
G1 X108.684 Y143.178 E.51406
G1 X108.552 Y143.151 E.00371
G1 X108.498 Y142.806 E.00964
G1 X108.349 Y142.751 E.00437
G1 X108.322 Y142.619 E.00371
G1 X108.322 Y140.981 E.04521
G1 X108.349 Y140.849 E.00371
G1 X108.481 Y140.822 E.00371
G1 X127.459 Y140.822 E.52363
; Slow Down End
G1 X128 Y140.256 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y136.245 E.15488
G1 X128.481 Y135.678 F30000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.39829
G1 F1500;_EXTRUDE_SET_SPEED
G1 X128.349 Y135.651 E.00378
G1 X128.322 Y135.519 E.00378
G1 X128.322 Y116.481 E.53444
G1 X128.349 Y116.349 E.00378
G1 X128.481 Y116.322 E.00378
G1 X134.163 Y116.322 E.1595
G1 X134.294 Y116.294 E.00378
G1 X134.322 Y116.163 E.00378
G1 X134.322 Y109.981 E.17353
G1 X134.349 Y109.849 E.00378
G1 X134.481 Y109.822 E.00378
G1 X143.019 Y109.822 E.23969
G1 X143.151 Y109.849 E.00378
G1 X143.178 Y109.981 E.00378
G1 X143.178 Y118.019 E.22565
G1 X143.151 Y118.151 E.00378
G1 X143.019 Y118.178 E.00378
G1 X132.337 Y118.178 E.29986
G1 X132.206 Y118.206 E.00378
G1 X132.178 Y118.337 E.00378
G1 X132.178 Y133.663 E.43021
G1 X132.206 Y133.794 E.00378
G1 X132.337 Y133.822 E.00378
G1 X143.019 Y133.822 E.29986
G1 X143.151 Y133.849 E.00378
G1 X143.178 Y133.981 E.00378
G1 X143.178 Y142.019 E.22565
G1 X143.151 Y142.151 E.00378
G1 X143.019 Y142.178 E.00378
G1 X134.481 Y142.178 E.23969
G1 X134.349 Y142.151 E.00378
G1 X134.322 Y142.019 E.00378
G1 X134.322 Y135.837 E.17353
G1 X134.294 Y135.706 E.00378
G1 X134.163 Y135.678 E.00378
G1 X128.541 Y135.678 E.15781
; Slow Down End
G1 X131.288 Y135.316 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X132.917 Y135.316 E.05236
G1 X132.976 Y135.173 E.00498
G1 X133.394 Y134.736 E.01944
G1 X133.679 Y134.299 E.01678
G1 X133.681 Y134.184 E.00369
G1 X135.301 Y134.184 E.05209
G1 X135.254 Y134.299 E.004
G1 X134.836 Y134.736 E.01944
G1 X134.551 Y135.173 E.01678
G1 X134.548 Y135.316 E.0046
G1 X134.684 Y135.316 E.00439
G1 X134.684 Y135.953 E.02048
G1 X134.723 Y136.046 E.00325
G1 X135.141 Y136.483 E.01944
G1 X135.426 Y136.92 E.01678
G1 X135.435 Y137.356 E.01405
G1 X135.254 Y137.793 E.01521
G1 X134.836 Y138.23 E.01944
G1 X134.684 Y138.462 E.00891
G1 X134.684 Y139.447 E.03167
G1 X134.723 Y139.54 E.00325
G1 X135.141 Y139.977 E.01944
G1 X135.426 Y140.414 E.01678
G1 X135.435 Y140.851 E.01405
G1 X135.254 Y141.287 E.01521
G1 X134.836 Y141.724 E.01944
G1 X134.776 Y141.816 E.00351
G1 X134.684 Y141.816 E.00295
G1 X134.684 Y140.279 E.04941
G1 X135.547 Y134.184 F30000
G1 F4200
G1 X137.176 Y134.184 E.05236
G1 X137.173 Y134.299 E.00369
G1 X136.888 Y134.736 E.01678
G1 X136.47 Y135.173 E.01944
G1 X136.289 Y135.609 E.01521
G1 X136.298 Y136.046 E.01405
G1 X136.583 Y136.483 E.01678
G1 X137.001 Y136.92 E.01944
G1 X137.182 Y137.356 E.01521
G1 X137.173 Y137.793 E.01405
G1 X136.888 Y138.23 E.01678
G1 X136.47 Y138.667 E.01944
G1 X136.289 Y139.104 E.01521
G1 X136.298 Y139.54 E.01405
G1 X136.583 Y139.977 E.01678
G1 X137.001 Y140.414 E.01944
G1 X137.182 Y140.851 E.01521
G1 X137.173 Y141.287 E.01405
G1 X136.888 Y141.724 E.01678
G1 X136.8 Y141.816 E.00407
G1 X138.27 Y141.816 E.04726
G1 X138.33 Y141.724 E.00351
G1 X138.748 Y141.287 E.01944
G1 X138.929 Y140.851 E.01521
G1 X138.92 Y140.414 E.01405
G1 X138.635 Y139.977 E.01678
G1 X138.217 Y139.54 E.01944
G1 X138.036 Y139.104 E.01521
G1 X138.045 Y138.667 E.01405
G1 X138.33 Y138.23 E.01678
G1 X138.748 Y137.793 E.01944
G1 X138.929 Y137.356 E.01521
G1 X138.92 Y136.92 E.01405
G1 X138.635 Y136.483 E.01678
G1 X138.217 Y136.046 E.01944
G1 X138.036 Y135.609 E.01521
G1 X138.045 Y135.173 E.01405
G1 X138.33 Y134.736 E.01678
M73 P67 R9
G1 X138.748 Y134.299 E.01944
G1 X138.796 Y134.184 E.004
G1 X140.67 Y134.184 E.06027
G1 X140.668 Y134.299 E.00369
G1 X140.382 Y134.736 E.01678
G1 X139.964 Y135.173 E.01944
G1 X139.783 Y135.609 E.01521
G1 X139.792 Y136.046 E.01405
G1 X140.077 Y136.483 E.01678
G1 X140.495 Y136.92 E.01944
G1 X140.676 Y137.356 E.01521
G1 X140.668 Y137.793 E.01405
G1 X140.382 Y138.23 E.01678
G1 X139.964 Y138.667 E.01944
G1 X139.783 Y139.104 E.01521
G1 X139.792 Y139.54 E.01405
G1 X140.077 Y139.977 E.01678
G1 X140.495 Y140.414 E.01944
G1 X140.676 Y140.851 E.01521
G1 X140.668 Y141.287 E.01405
G1 X140.382 Y141.724 E.01678
G1 X140.295 Y141.816 E.00407
G1 X141.764 Y141.816 E.04726
G1 X141.824 Y141.724 E.00351
G1 X142.242 Y141.287 E.01944
G1 X142.423 Y140.851 E.01521
G1 X142.415 Y140.414 E.01405
G1 X142.129 Y139.977 E.01678
G1 X141.711 Y139.54 E.01944
G1 X141.53 Y139.104 E.01521
G1 X141.539 Y138.667 E.01405
G1 X141.824 Y138.23 E.01678
G1 X142.242 Y137.793 E.01944
G1 X142.423 Y137.356 E.01521
G1 X142.415 Y136.92 E.01405
G1 X142.129 Y136.483 E.01678
G1 X141.711 Y136.046 E.01944
G1 X141.53 Y135.609 E.01521
G1 X141.539 Y135.173 E.01405
G1 X141.824 Y134.736 E.01678
G1 X142.242 Y134.299 E.01944
G1 X142.29 Y134.184 E.004
G1 X142.816 Y134.184 E.01691
G1 X142.816 Y135.287 E.03545
; WIPE_START
G1 X142.816 Y134.184 E-.4189
G1 X142.29 Y134.184 E-.19986
G1 X142.242 Y134.299 E-.04722
G1 X142.071 Y134.478 E-.09403
; WIPE_END
G1 E-.04 F1800
G1 X146.184 Y130.652 Z2 F30000
G1 Z1.6
G1 E.8 F1800
G1 F4200
G1 X146.184 Y130.816 E.00527
G1 X147.656 Y130.805 E.04732
G1 X147.664 Y130.368 E.01405
G1 X147.483 Y129.931 E.01521
G1 X147.065 Y129.495 E.01944
G1 X146.78 Y129.058 E.01678
G1 X146.771 Y128.621 E.01405
G1 X146.952 Y128.184 E.01521
G1 X147.37 Y127.747 E.01944
G1 X147.656 Y127.311 E.01678
G1 X147.664 Y126.874 E.01405
G1 X147.483 Y126.437 E.01521
G1 X147.065 Y126 E.01944
G1 X146.78 Y125.564 E.01678
G1 X146.771 Y125.127 E.01405
G1 X146.952 Y124.69 E.01521
G1 X147.37 Y124.253 E.01944
G1 X147.656 Y123.816 E.01678
G1 X147.664 Y123.38 E.01405
G1 X147.483 Y122.943 E.01521
G1 X147.065 Y122.506 E.01944
G1 X146.78 Y122.069 E.01678
G1 X146.771 Y121.633 E.01405
G1 X146.963 Y121.184 E.01569
G1 X148.535 Y121.184 E.05052
G1 X148.518 Y121.633 E.01442
G1 X148.7 Y122.069 E.01521
G1 X149.117 Y122.506 E.01944
G1 X149.403 Y122.943 E.01678
G1 X149.412 Y123.38 E.01405
G1 X149.23 Y123.816 E.01521
G1 X148.812 Y124.253 E.01944
G1 X148.527 Y124.69 E.01678
G1 X148.518 Y125.127 E.01405
G1 X148.7 Y125.564 E.01521
G1 X149.117 Y126 E.01944
G1 X149.403 Y126.437 E.01678
G1 X149.412 Y126.874 E.01405
G1 X149.23 Y127.311 E.01521
G1 X148.812 Y127.747 E.01944
G1 X148.527 Y128.184 E.01678
G1 X148.518 Y128.621 E.01405
G1 X148.7 Y129.058 E.01521
G1 X149.117 Y129.495 E.01944
G1 X149.403 Y129.931 E.01678
G1 X149.412 Y130.368 E.01405
G1 X149.22 Y130.816 E.01566
G1 X151.15 Y130.805 E.06206
G1 X151.159 Y130.368 E.01405
G1 X150.977 Y129.931 E.01521
G1 X150.559 Y129.495 E.01944
G1 X150.274 Y129.058 E.01678
G1 X150.265 Y128.621 E.01405
G1 X150.447 Y128.184 E.01521
G1 X150.865 Y127.747 E.01944
G1 X151.15 Y127.311 E.01678
G1 X151.159 Y126.874 E.01405
G1 X150.977 Y126.437 E.01521
G1 X150.559 Y126 E.01944
G1 X150.274 Y125.564 E.01678
G1 X150.265 Y125.127 E.01405
G1 X150.447 Y124.69 E.01521
G1 X150.865 Y124.253 E.01944
G1 X151.15 Y123.816 E.01678
G1 X151.159 Y123.38 E.01405
G1 X150.977 Y122.943 E.01521
G1 X150.559 Y122.506 E.01944
G1 X150.274 Y122.069 E.01678
G1 X150.265 Y121.633 E.01405
G1 X150.458 Y121.184 E.01569
G1 X151.184 Y121.184 E.02337
G1 X151.184 Y118.778 E.07737
G1 X150.807 Y119.118 E.01633
G1 X150.807 Y117.325 E.05768
G1 X150.865 Y117.265 E.00266
G1 X151.15 Y116.828 E.01678
G1 X151.159 Y116.391 E.01405
G1 X150.977 Y115.954 E.01521
G1 X150.807 Y115.777 E.00791
G1 X150.807 Y113.83 E.06259
G1 X150.865 Y113.771 E.00266
G1 X151.15 Y113.334 E.01678
G1 X151.159 Y112.897 E.01405
G1 X150.977 Y112.46 E.01521
G1 X150.807 Y112.283 E.00791
G1 X150.807 Y110.336 E.06259
G1 X150.865 Y110.276 E.00266
G1 X151.15 Y109.84 E.01678
G1 X151.151 Y109.807 E.00104
G1 X152.193 Y109.807 E.03351
G1 X152.193 Y110.451 E.02069
G1 X152.021 Y110.713 E.01008
G1 X152.012 Y111.15 E.01405
G1 X152.193 Y111.584 E.01512
G1 X152.193 Y113.945 E.07591
G1 X152.021 Y114.207 E.01008
G1 X152.012 Y114.644 E.01405
G1 X152.193 Y115.078 E.01512
G1 X152.193 Y117.439 E.07591
G1 X152.021 Y117.702 E.01008
G1 X152.012 Y118.138 E.01405
G1 X152.193 Y118.573 E.01512
G1 X152.193 Y119.36 E.02532
G1 X151.816 Y119.105 E.01464
G1 X151.816 Y133.16 E.45197
G1 X152.193 Y133.301 E.01294
G1 X152.193 Y134.91 E.05174
G1 X152.021 Y135.173 E.01008
G1 X152.012 Y135.609 E.01405
G1 X152.193 Y136.044 E.01512
G1 X152.193 Y138.404 E.07591
G1 X152.021 Y138.667 E.01008
G1 X152.012 Y139.104 E.01405
G1 X152.193 Y139.538 E.01512
G1 X152.193 Y141.899 E.07591
G1 X152.021 Y142.161 E.01008
G1 X152.021 Y142.193 E.00102
G1 X150.807 Y142.193 E.03901
G1 X150.807 Y141.784 E.01314
G1 X150.865 Y141.724 E.00266
G1 X151.15 Y141.287 E.01678
G1 X151.159 Y140.851 E.01405
G1 X150.977 Y140.414 E.01521
G1 X150.807 Y140.236 E.00791
G1 X150.807 Y138.29 E.06259
G1 X150.865 Y138.23 E.00266
G1 X151.15 Y137.793 E.01678
G1 X151.159 Y137.356 E.01405
G1 X150.977 Y136.92 E.01521
G1 X150.807 Y136.742 E.00791
G1 X150.807 Y134.796 E.06259
G1 X150.865 Y134.736 E.00266
G1 X151.15 Y134.299 E.01678
G1 X151.159 Y133.862 E.01405
G1 X150.977 Y133.425 E.01521
G1 X150.807 Y133.248 E.00791
G1 X150.807 Y132.788 E.01477
G1 X151.184 Y132.924 E.01288
G1 X151.184 Y132.156 E.0247
G1 X152.178 Y132.909 F30000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.38292
G1 F1500;_EXTRUDE_SET_SPEED
G1 X152.178 Y119.848 E.35078
; Slow Down End
G1 X150.822 Y119.594 F30000
; Slow Down Start
; LINE_WIDTH: 0.383702
G1 F1500;_EXTRUDE_SET_SPEED
G1 X150.822 Y120.663 E.02877
G1 X150.794 Y120.794 E.00362
G1 X150.663 Y120.822 E.00362
G1 X145.981 Y120.822 E.12603
G1 X145.849 Y120.849 E.00362
G1 X145.822 Y120.981 E.00362
G1 X145.822 Y131.019 E.27022
G1 X145.849 Y131.151 E.00362
G1 X145.981 Y131.178 E.00362
G1 X150.663 Y131.178 E.12603
G1 X150.794 Y131.206 E.00362
G1 X150.822 Y131.337 E.00362
G1 X150.822 Y132.356 E.02743
; Slow Down End
; WIPE_START
G1 X150.822 Y131.337 E-.38725
G1 X150.794 Y131.206 E-.05114
G1 X150.663 Y131.178 E-.05114
G1 X149.951 Y131.178 E-.27047
; WIPE_END
G1 E-.04 F1800
G1 X150.156 Y138.808 Z2 F30000
G1 X150.256 Y142.5 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X143.745 Y142.5 E.2514
; WIPE_START
G1 X145.745 Y142.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X144.858 Y134.919 Z2 F30000
G1 X142.816 Y117.466 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X142.816 Y117.816 E.01123
G1 X141.537 Y117.816 E.04113
G1 X141.539 Y117.702 E.00367
G1 X141.824 Y117.265 E.01678
G1 X142.242 Y116.828 E.01944
G1 X142.423 Y116.391 E.01521
G1 X142.415 Y115.954 E.01405
G1 X142.129 Y115.518 E.01678
G1 X141.711 Y115.081 E.01944
G1 X141.53 Y114.644 E.01521
G1 X141.539 Y114.207 E.01405
G1 X141.824 Y113.771 E.01678
G1 X142.242 Y113.334 E.01944
G1 X142.423 Y112.897 E.01521
G1 X142.415 Y112.46 E.01405
G1 X142.129 Y112.023 E.01678
G1 X141.711 Y111.587 E.01944
G1 X141.53 Y111.15 E.01521
G1 X141.539 Y110.713 E.01405
G1 X141.824 Y110.276 E.01678
G1 X141.912 Y110.184 E.0041
G1 X140.442 Y110.184 E.04727
G1 X140.382 Y110.276 E.00354
G1 X139.964 Y110.713 E.01944
G1 X139.783 Y111.15 E.01521
G1 X139.792 Y111.587 E.01405
G1 X140.077 Y112.023 E.01678
G1 X140.495 Y112.46 E.01944
G1 X140.676 Y112.897 E.01521
G1 X140.668 Y113.334 E.01405
G1 X140.382 Y113.771 E.01678
G1 X139.964 Y114.207 E.01944
G1 X139.783 Y114.644 E.01521
G1 X139.792 Y115.081 E.01405
G1 X140.077 Y115.518 E.01678
G1 X140.495 Y115.954 E.01944
G1 X140.676 Y116.391 E.01521
G1 X140.668 Y116.828 E.01405
G1 X140.382 Y117.265 E.01678
G1 X139.964 Y117.702 E.01944
G1 X139.917 Y117.816 E.00397
G1 X138.042 Y117.816 E.06028
G1 X138.045 Y117.702 E.00367
G1 X138.33 Y117.265 E.01678
G1 X138.748 Y116.828 E.01944
G1 X138.929 Y116.391 E.01521
G1 X138.92 Y115.954 E.01405
G1 X138.635 Y115.518 E.01678
G1 X138.217 Y115.081 E.01944
G1 X138.036 Y114.644 E.01521
G1 X138.045 Y114.207 E.01405
G1 X138.33 Y113.771 E.01678
G1 X138.748 Y113.334 E.01944
G1 X138.929 Y112.897 E.01521
G1 X138.92 Y112.46 E.01405
G1 X138.635 Y112.023 E.01678
G1 X138.217 Y111.587 E.01944
G1 X138.036 Y111.15 E.01521
G1 X138.045 Y110.713 E.01405
G1 X138.33 Y110.276 E.01678
G1 X138.418 Y110.184 E.0041
G1 X136.948 Y110.184 E.04727
G1 X136.888 Y110.276 E.00354
G1 X136.47 Y110.713 E.01944
G1 X136.289 Y111.15 E.01521
G1 X136.298 Y111.587 E.01405
G1 X136.583 Y112.023 E.01678
G1 X137.001 Y112.46 E.01944
G1 X137.182 Y112.897 E.01521
G1 X137.173 Y113.334 E.01405
G1 X136.888 Y113.771 E.01678
G1 X136.47 Y114.207 E.01944
G1 X136.289 Y114.644 E.01521
G1 X136.298 Y115.081 E.01405
G1 X136.583 Y115.518 E.01678
G1 X137.001 Y115.954 E.01944
G1 X137.182 Y116.391 E.01521
G1 X137.173 Y116.828 E.01405
G1 X136.888 Y117.265 E.01678
G1 X136.47 Y117.702 E.01944
G1 X136.423 Y117.816 E.00397
G1 X134.794 Y117.816 E.05236
G1 X128.684 Y116.809 F30000
G1 F4200
G1 X128.684 Y116.684 E.00401
G1 X130.188 Y116.684 E.04835
G1 X130.185 Y116.828 E.00462
G1 X129.9 Y117.265 E.01678
G1 X129.482 Y117.702 E.01944
G1 X129.3 Y118.138 E.01521
G1 X129.309 Y118.575 E.01405
G1 X129.595 Y119.012 E.01678
G1 X130.012 Y119.449 E.01944
G1 X130.194 Y119.885 E.01521
G1 X130.185 Y120.322 E.01405
G1 X129.9 Y120.759 E.01678
G1 X129.482 Y121.196 E.01944
G1 X129.3 Y121.633 E.01521
G1 X129.309 Y122.069 E.01405
G1 X129.595 Y122.506 E.01678
G1 X130.012 Y122.943 E.01944
G1 X130.194 Y123.38 E.01521
G1 X130.185 Y123.816 E.01405
G1 X129.9 Y124.253 E.01678
G1 X129.482 Y124.69 E.01944
G1 X129.3 Y125.127 E.01521
G1 X129.309 Y125.564 E.01405
G1 X129.595 Y126 E.01678
G1 X130.012 Y126.437 E.01944
G1 X130.194 Y126.874 E.01521
G1 X130.185 Y127.311 E.01405
G1 X129.9 Y127.747 E.01678
G1 X129.482 Y128.184 E.01944
G1 X129.3 Y128.621 E.01521
G1 X129.309 Y129.058 E.01405
G1 X129.595 Y129.495 E.01678
G1 X130.012 Y129.931 E.01944
G1 X130.194 Y130.368 E.01521
G1 X130.185 Y130.805 E.01405
G1 X129.9 Y131.242 E.01678
G1 X129.482 Y131.678 E.01944
G1 X129.3 Y132.115 E.01521
G1 X129.309 Y132.552 E.01405
G1 X129.595 Y132.989 E.01678
G1 X130.012 Y133.425 E.01944
G1 X130.194 Y133.862 E.01521
G1 X130.185 Y134.299 E.01405
G1 X129.9 Y134.736 E.01678
G1 X129.482 Y135.173 E.01944
G1 X129.422 Y135.316 E.00498
G1 X131.053 Y135.316 E.05245
G1 X131.056 Y135.173 E.0046
G1 X131.342 Y134.736 E.01678
G1 X131.76 Y134.299 E.01944
G1 X131.816 Y134.164 E.00471
G1 X131.816 Y133.247 E.02946
G1 X131.647 Y132.989 E.00994
G1 X131.229 Y132.552 E.01944
G1 X131.048 Y132.115 E.01521
G1 X131.056 Y131.678 E.01405
G1 X131.342 Y131.242 E.01678
G1 X131.76 Y130.805 E.01944
G1 X131.816 Y130.669 E.00471
G1 X131.816 Y129.753 E.02946
G1 X131.647 Y129.495 E.00994
G1 X131.229 Y129.058 E.01944
G1 X131.048 Y128.621 E.01521
G1 X131.056 Y128.184 E.01405
G1 X131.342 Y127.747 E.01678
G1 X131.76 Y127.311 E.01944
G1 X131.816 Y127.175 E.00471
G1 X131.816 Y126.259 E.02946
G1 X131.647 Y126 E.00994
G1 X131.229 Y125.564 E.01944
G1 X131.048 Y125.127 E.01521
G1 X131.056 Y124.69 E.01405
G1 X131.342 Y124.253 E.01678
G1 X131.76 Y123.816 E.01944
G1 X131.816 Y123.681 E.00471
G1 X131.816 Y122.765 E.02946
G1 X131.647 Y122.506 E.00994
G1 X131.229 Y122.069 E.01944
G1 X131.048 Y121.633 E.01521
G1 X131.056 Y121.196 E.01405
G1 X131.342 Y120.759 E.01678
G1 X131.76 Y120.322 E.01944
G1 X131.816 Y120.187 E.00471
G1 X131.816 Y119.271 E.02946
G1 X131.647 Y119.012 E.00994
G1 X131.229 Y118.575 E.01944
G1 X131.048 Y118.138 E.01521
G1 X131.056 Y117.702 E.01405
G1 X131.342 Y117.265 E.01678
G1 X131.76 Y116.828 E.01944
G1 X131.819 Y116.684 E.00501
G1 X133.682 Y116.684 E.0599
G1 X133.679 Y116.828 E.00462
G1 X133.394 Y117.265 E.01678
G1 X132.976 Y117.702 E.01944
G1 X132.929 Y117.816 E.00397
G1 X134.548 Y117.816 E.05208
G1 X134.551 Y117.702 E.00367
G1 X134.836 Y117.265 E.01678
G1 X135.254 Y116.828 E.01944
G1 X135.435 Y116.391 E.01521
G1 X135.426 Y115.954 E.01405
G1 X135.141 Y115.518 E.01678
G1 X134.723 Y115.081 E.01944
G1 X134.684 Y114.987 E.00325
G1 X134.684 Y114.003 E.03167
G1 X134.836 Y113.771 E.00891
G1 X135.254 Y113.334 E.01944
G1 X135.435 Y112.897 E.01521
G1 X135.426 Y112.46 E.01405
G1 X135.141 Y112.023 E.01678
G1 X134.723 Y111.587 E.01944
G1 X134.684 Y111.493 E.00325
G1 X134.684 Y110.508 E.03167
G1 X134.836 Y110.276 E.00891
G1 X134.924 Y110.184 E.0041
G1 X136.552 Y110.184 E.05236
; WIPE_START
G1 X134.924 Y110.184 E-.61876
G1 X134.836 Y110.276 E-.04845
G1 X134.702 Y110.481 E-.09279
; WIPE_END
G1 E-.04 F1800
G1 X132.337 Y108.75 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y108.75 E.06208
G1 X127.502 Y109.194 F30000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.399363
G1 F1500;_EXTRUDE_SET_SPEED
G1 X127.651 Y109.249 E.00446
G1 X127.678 Y109.381 E.00379
G1 X127.678 Y111.019 E.04614
G1 X127.651 Y111.151 E.00379
G1 X127.519 Y111.178 E.00379
G1 X108.481 Y111.178 E.53605
G1 X108.349 Y111.151 E.00379
G1 X108.322 Y111.019 E.00379
G1 X108.322 Y109.381 E.04614
G1 X108.349 Y109.249 E.00379
G1 X108.498 Y109.194 E.00446
G1 X108.552 Y108.849 E.00984
G1 X108.684 Y108.822 E.00379
G1 X127.316 Y108.822 E.5246
G1 X127.448 Y108.849 E.00379
G1 X127.493 Y109.135 E.00815
; Slow Down End
G1 X127.316 Y110.558 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X127.316 Y110.816 E.00829
G1 X125.945 Y110.816 E.04407
G1 X125.988 Y110.713 E.00357
G1 X126.406 Y110.276 E.01944
G1 X126.691 Y109.84 E.01678
G1 X126.7 Y109.403 E.01405
G1 X126.609 Y109.184 E.00761
G1 X124.948 Y109.184 E.0534
G1 X124.953 Y109.403 E.00703
G1 X124.772 Y109.84 E.01521
G1 X124.354 Y110.276 E.01944
G1 X124.068 Y110.713 E.01678
G1 X124.066 Y110.816 E.0033
G1 X122.451 Y110.816 E.05194
G1 X122.494 Y110.713 E.00357
G1 X122.912 Y110.276 E.01944
G1 X123.197 Y109.84 E.01678
G1 X123.206 Y109.403 E.01405
G1 X123.115 Y109.184 E.00761
G1 X121.454 Y109.184 E.0534
G1 X121.459 Y109.403 E.00703
G1 X121.277 Y109.84 E.01521
G1 X120.859 Y110.276 E.01944
G1 X120.574 Y110.713 E.01678
G1 X120.572 Y110.816 E.0033
G1 X118.957 Y110.816 E.05194
G1 X119 Y110.713 E.00357
G1 X119.417 Y110.276 E.01944
G1 X119.703 Y109.84 E.01678
G1 X119.711 Y109.403 E.01405
G1 X119.621 Y109.184 E.00761
G1 X117.96 Y109.184 E.0534
G1 X117.964 Y109.403 E.00703
G1 X117.783 Y109.84 E.01521
G1 X117.365 Y110.276 E.01944
G1 X117.08 Y110.713 E.01678
G1 X117.078 Y110.816 E.0033
G1 X115.463 Y110.816 E.05193
G1 X115.505 Y110.713 E.00357
G1 X115.923 Y110.276 E.01944
G1 X116.209 Y109.84 E.01678
G1 X116.217 Y109.403 E.01405
G1 X116.127 Y109.184 E.00761
G1 X114.466 Y109.184 E.0534
G1 X114.47 Y109.403 E.00703
G1 X114.289 Y109.84 E.01521
G1 X113.871 Y110.276 E.01944
G1 X113.586 Y110.713 E.01678
G1 X113.584 Y110.816 E.0033
G1 X111.969 Y110.816 E.05194
G1 X112.011 Y110.713 E.00357
G1 X112.429 Y110.276 E.01944
G1 X112.714 Y109.84 E.01678
G1 X112.723 Y109.403 E.01405
G1 X112.632 Y109.184 E.00761
G1 X110.972 Y109.184 E.0534
G1 X110.976 Y109.403 E.00703
G1 X110.795 Y109.84 E.01521
G1 X110.377 Y110.276 E.01944
G1 X110.091 Y110.713 E.01678
G1 X110.089 Y110.816 E.0033
G1 X108.684 Y110.816 E.04518
G1 X108.684 Y110.538 E.00892
G1 X108.935 Y110.276 E.01165
G1 X109.22 Y109.84 E.01678
G1 X109.229 Y109.403 E.01405
G1 X109.138 Y109.184 E.00761
G1 X110.766 Y109.184 E.05236
G1 X108.163 Y108.75 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y108.75 E.06208
; WIPE_START
G1 X105.663 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y110.073 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y114.927 E.24736
; WIPE_START
G1 X102.75 Y112.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X104.184 Y116.768 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X104.184 Y116.684 E.00269
G1 X105.729 Y116.684 E.04967
G1 X105.726 Y116.828 E.00462
G1 X105.441 Y117.265 E.01678
G1 X105.023 Y117.701 E.01944
G1 X104.841 Y118.138 E.01521
G1 X104.85 Y118.575 E.01405
G1 X105.136 Y119.012 E.01678
G1 X105.553 Y119.449 E.01944
G1 X105.735 Y119.885 E.01521
G1 X105.726 Y120.322 E.01405
G1 X105.441 Y120.759 E.01678
G1 X105.023 Y121.196 E.01944
G1 X104.841 Y121.632 E.01521
G1 X104.85 Y122.069 E.01405
G1 X105.136 Y122.506 E.01678
G1 X105.553 Y122.943 E.01944
G1 X105.735 Y123.38 E.01521
G1 X105.726 Y123.816 E.01405
G1 X105.441 Y124.253 E.01678
G1 X105.023 Y124.69 E.01944
G1 X104.841 Y125.127 E.01521
G1 X104.85 Y125.563 E.01405
G1 X105.136 Y126 E.01678
G1 X105.553 Y126.437 E.01944
G1 X105.735 Y126.874 E.01521
G1 X105.726 Y127.311 E.01405
G1 X105.441 Y127.747 E.01678
G1 X105.023 Y128.184 E.01944
G1 X104.841 Y128.621 E.01521
G1 X104.85 Y129.058 E.01405
G1 X105.136 Y129.494 E.01678
G1 X105.553 Y129.931 E.01944
G1 X105.735 Y130.368 E.01521
G1 X105.726 Y130.805 E.01405
G1 X105.441 Y131.241 E.01678
G1 X105.023 Y131.678 E.01944
G1 X104.841 Y132.115 E.01521
G1 X104.85 Y132.552 E.01405
G1 X105.136 Y132.989 E.01678
G1 X105.553 Y133.425 E.01944
G1 X105.735 Y133.862 E.01521
G1 X105.726 Y134.299 E.01405
G1 X105.441 Y134.736 E.01678
G1 X105.023 Y135.172 E.01944
G1 X104.963 Y135.316 E.00499
G1 X106.594 Y135.316 E.05245
G1 X106.597 Y135.172 E.00461
G1 X106.883 Y134.736 E.01678
G1 X107.301 Y134.299 E.01944
G1 X107.316 Y134.249 E.00167
G1 X107.316 Y133.216 E.03323
G1 X107.188 Y132.989 E.00838
G1 X106.77 Y132.552 E.01944
G1 X106.589 Y132.115 E.01521
G1 X106.597 Y131.678 E.01405
G1 X106.883 Y131.241 E.01678
G1 X107.301 Y130.805 E.01944
G1 X107.316 Y130.755 E.00167
G1 X107.316 Y129.722 E.03323
G1 X107.188 Y129.494 E.00838
G1 X106.77 Y129.058 E.01944
G1 X106.589 Y128.621 E.01521
G1 X106.597 Y128.184 E.01405
G1 X106.883 Y127.747 E.01678
G1 X107.301 Y127.311 E.01944
G1 X107.316 Y127.261 E.00167
G1 X107.316 Y126.227 E.03323
G1 X107.188 Y126 E.00838
G1 X106.77 Y125.563 E.01944
G1 X106.589 Y125.127 E.01521
G1 X106.597 Y124.69 E.01405
G1 X106.883 Y124.253 E.01678
G1 X107.301 Y123.816 E.01944
G1 X107.316 Y123.767 E.00167
G1 X107.316 Y122.733 E.03323
G1 X107.188 Y122.506 E.00838
G1 X106.77 Y122.069 E.01944
G1 X106.589 Y121.632 E.01521
G1 X106.597 Y121.196 E.01405
G1 X106.883 Y120.759 E.01678
G1 X107.301 Y120.322 E.01944
G1 X107.316 Y120.272 E.00167
G1 X107.316 Y119.239 E.03323
G1 X107.188 Y119.012 E.00838
G1 X106.77 Y118.575 E.01944
G1 X106.589 Y118.138 E.01521
G1 X106.597 Y117.701 E.01405
G1 X106.883 Y117.265 E.01678
G1 X107.301 Y116.828 E.01944
G1 X107.316 Y116.778 E.00167
G1 X107.316 Y118.407 E.05236
; WIPE_START
G1 X107.316 Y116.778 E-.61876
G1 X107.301 Y116.828 E-.01974
G1 X107.08 Y117.059 E-.1215
; WIPE_END
G1 E-.04 F1800
G1 X108 Y115.755 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y111.744 E.15487
G1 X128 Y111.744 F30000
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y115.755 E.15488
; WIPE_START
G1 X128 Y113.755 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.368 Y111.764 Z2 F30000
G1 X143.745 Y109.5 Z2
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X150.256 Y109.5 E.2514
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F4909.984
G1 X148.256 Y109.5 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 9/27
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
G17
G3 Z2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X129.29 Y142.552
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y142.552 E.02708
G1 X128.448 Y136.448 E.19629
G1 X133.552 Y136.448 E.16413
G1 X133.552 Y142.552 E.19629
G1 X129.33 Y142.552 E.13577
G1 X128.855 Y141.71 F30000
G1 F3600
G1 X128.855 Y136.855 E.15612
G1 X133.145 Y136.855 E.13795
G1 X133.145 Y142.145 E.17011
G1 X128.855 Y142.145 E.13795
G1 X128.855 Y141.75 E.0127
M204 S250
G1 X129.29 Y141.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y141.71 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y142.959 E.04017
G1 X132.541 Y142.959 E.1447
G1 X132.541 Y143.541 E.01871
G1 X103.459 Y143.541 E.93516
G1 X103.459 Y142.959 E.01871
G1 X107.959 Y142.959 E.1447
G1 X107.959 Y140.459 E.08039
G1 X128.041 Y140.459 E.64576
G1 X128.041 Y141.67 E.03894
; WIPE_START
G1 X128.041 Y142.959 E-.48987
G1 X128.752 Y142.959 E-.27013
; WIPE_END
G1 E-.04 F1800
G1 X121.47 Y140.673 Z2.2 F30000
G1 X106.71 Y136.041 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F3600
G1 X103.459 Y136.041 E.10454
G1 X103.459 Y115.959 E.64576
G1 X108.041 Y115.959 E.14733
G1 X108.041 Y136.041 E.64576
G1 X106.75 Y136.041 E.04151
; WIPE_START
G1 X104.75 Y136.041 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y140.052 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
G1 F3600
G1 X108.448 Y140.052 E.02708
G1 X108.448 Y111.948 E.90373
G1 X127.552 Y111.948 E.61432
G1 X127.552 Y140.052 E.90373
G1 X109.33 Y140.052 E.58595
G1 X109.29 Y139.645 F30000
G1 F3600
G1 X108.855 Y139.645 E.01399
G1 X108.855 Y112.355 E.87755
G1 X127.145 Y112.355 E.58814
G1 X127.145 Y139.645 E.87755
G1 X109.33 Y139.645 E.57287
M204 S250
G1 X109.29 Y139.21 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.747 Y130.987 Z2.2 F30000
G1 X128.448 Y110.29 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y109.448 E.02708
G1 X133.552 Y109.448 E.16413
G1 X133.552 Y115.552 E.19629
G1 X128.448 Y115.552 E.16413
G1 X128.448 Y110.33 E.16792
G1 X129.29 Y109.855 F30000
G1 F3600
G1 X133.145 Y109.855 E.12396
G1 X133.145 Y115.145 E.17011
G1 X128.855 Y115.145 E.13795
G1 X128.855 Y109.855 E.17011
G1 X129.25 Y109.855 E.0127
M204 S250
G1 X129.29 Y110.29 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y110.29 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y111.541 E.04022
G1 X107.959 Y111.541 E.64576
G1 X107.959 Y109.041 E.08039
G1 X103.459 Y109.041 E.1447
G1 X103.459 Y108.459 E.01871
G1 X132.541 Y108.459 E.93516
G1 X132.541 Y109.041 E.01871
G1 X128.041 Y109.041 E.1447
G1 X128.041 Y110.25 E.03888
; WIPE_START
G1 X128.041 Y111.541 E-.49053
G1 X127.332 Y111.541 E-.26947
; WIPE_END
G1 E-.04 F1800
G1 X134.944 Y110.987 Z2.2 F30000
G1 X149.21 Y109.948 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F3600
G1 X150.052 Y109.948 E.02708
G1 X150.052 Y120.052 E.32491
G1 X145.052 Y120.052 E.16078
G1 X145.052 Y131.948 E.38253
G1 X150.052 Y131.948 E.16078
G1 X150.052 Y142.052 E.32491
M73 P68 R9
G1 X143.948 Y142.052 E.19629
G1 X143.948 Y133.052 E.28941
G1 X132.948 Y133.052 E.35372
G1 X132.948 Y118.948 E.45354
G1 X143.948 Y118.948 E.35372
G1 X143.948 Y109.948 E.28941
G1 X149.17 Y109.948 E.16792
G1 X149.21 Y110.355 F30000
G1 F3600
G1 X149.645 Y110.355 E.01399
G1 X149.645 Y119.645 E.29873
G1 X144.645 Y119.645 E.16078
G1 X144.645 Y132.355 E.40871
G1 X149.645 Y132.355 E.16078
G1 X149.645 Y141.645 E.29873
G1 X144.355 Y141.645 E.17011
G1 X144.355 Y132.645 E.28941
G1 X133.355 Y132.645 E.35372
G1 X133.355 Y119.355 E.42736
G1 X144.355 Y119.355 E.35372
G1 X144.355 Y110.355 E.28941
G1 X149.17 Y110.355 E.15483
; WIPE_START
G1 X149.645 Y110.355 E-.1805
G1 X149.645 Y111.88 E-.5795
; WIPE_END
G1 E-.04 F1800
G1 X147.674 Y119.253 Z2.2 F30000
G1 X144.21 Y132.21 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X144.584 Y124.924 Z2.2 F30000
G1 X149.21 Y110.79 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.191 Y120.422 Z2.2 F30000
G1 X149.21 Y132.79 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.541 Y133.459 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X143.541 Y142.541 E.29204
G1 X133.959 Y142.541 E.30811
G1 X133.959 Y136.041 E.20902
G1 X127.959 Y136.041 E.19294
G1 X127.959 Y115.959 E.64576
G1 X133.959 Y115.959 E.19294
G1 X133.959 Y109.459 E.20902
G1 X143.541 Y109.459 E.30811
G1 X143.541 Y118.541 E.29204
G1 X132.541 Y118.541 E.35372
G1 X132.541 Y133.459 E.47972
G1 X143.501 Y133.459 E.35243
; WIPE_START
G1 X143.51 Y135.459 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.238 Y128.025 Z2.2 F30000
G1 X145.459 Y127.074 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F3600
M73 P68 R8
G1 X145.459 Y120.459 E.21272
G1 X150.459 Y120.459 E.16078
G1 X150.459 Y109.459 E.35372
G1 X152.541 Y109.459 E.06694
G1 X152.541 Y142.541 E1.06379
G1 X150.459 Y142.541 E.06694
G1 X150.459 Y131.541 E.35372
G1 X145.459 Y131.541 E.16078
G1 X145.459 Y127.114 E.14234
; WIPE_START
G1 X145.459 Y125.114 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.076 Y131.362 Z2.2 F30000
G1 X132.948 Y142.948 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F3600
G1 X132.948 Y143.948 E.03216
G1 X103.052 Y143.948 E.96134
G1 X103.052 Y142.552 E.04489
G1 X107.552 Y142.552 E.1447
G1 X107.552 Y136.448 E.19629
G1 X103.052 Y136.448 E.1447
G1 X103.052 Y115.552 E.67194
G1 X107.552 Y115.552 E.1447
G1 X107.552 Y109.448 E.19629
G1 X103.052 Y109.448 E.1447
G1 X103.052 Y108.052 E.04489
G1 X132.948 Y108.052 E.96134
G1 X132.948 Y109.052 E.03216
G1 X152.948 Y109.052 E.64313
G1 X152.948 Y142.948 E1.08997
G1 X132.988 Y142.948 E.64184
G1 X133.355 Y143.355 F30000
G1 F3600
G1 X133.355 Y144.355 E.03216
G1 X102.645 Y144.355 E.98752
G1 X102.645 Y142.145 E.07107
G1 X107.145 Y142.145 E.1447
G1 X107.145 Y136.855 E.17011
G1 X102.645 Y136.855 E.1447
G1 X102.645 Y115.145 E.69812
G1 X107.145 Y115.145 E.1447
G1 X107.145 Y109.855 E.17011
G1 X102.645 Y109.855 E.1447
G1 X102.645 Y107.645 E.07107
G1 X133.355 Y107.645 E.98752
G1 X133.355 Y108.645 E.03216
G1 X153.355 Y108.645 E.64313
G1 X153.355 Y143.355 E1.11615
G1 X133.395 Y143.355 E.64184
; WIPE_START
G1 X133.355 Y144.355 E-.3803
G1 X132.356 Y144.355 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X127.765 Y138.257 Z2.2 F30000
G1 X106.71 Y110.29 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.694 Y119.922 Z2.2 F30000
G1 X106.71 Y141.71 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
M73 P69 R8
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.323 Y142.242 Z2.2 F30000
G1 X133.79 Y143.79 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
G1 X132.791 Y144.79 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X132.337 Y143.25 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y143.25 E.06208
G1 X127.874 Y141.291 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.40805
; LAYER_HEIGHT: 0.4
M106 S153
G1 F1500
G1 X108.329 Y140.877 E1.00972
G1 X108.329 Y141.335 E.02366
G1 X127.671 Y141.744 E.99926
G1 X127.671 Y142.203 E.02366
G1 X108.329 Y141.793 E.99926
G1 X108.329 Y142.251 E.02366
G1 X127.671 Y142.661 E.99926
G1 X127.671 Y142.771 E.00571
G1 X127.468 Y142.771 E.01051
G1 X127.468 Y143.115 E.01773
G1 X108.126 Y142.705 E.99921
M106 S51
G1 X108.163 Y143.25 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
; LAYER_HEIGHT: 0.2
G1 F13740.983
G1 X103.663 Y143.25 E.06208
; WIPE_START
G1 X105.663 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y141.927 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y137.073 E.24736
; WIPE_START
G1 X102.75 Y139.073 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X103.626 Y135.17 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40285
; LAYER_HEIGHT: 0.4
M106 S153
G1 F1500
G1 X104.834 Y135.671 E.06582
G1 X106.015 Y135.671 E.05947
G1 X103.829 Y134.764 E.11918
G1 X103.829 Y134.273 E.02468
G1 X107.197 Y135.671 E.18357
G1 X107.671 Y135.671 E.02388
G1 X107.671 Y135.378 E.01477
G1 X103.829 Y133.783 E.20943
G1 X103.829 Y133.293 E.02468
G1 X107.671 Y134.887 E.20943
G1 X107.671 Y134.397 E.02468
G1 X103.829 Y132.803 E.20943
G1 X103.829 Y132.312 E.02468
G1 X107.671 Y133.907 E.20943
G1 X107.671 Y133.417 E.02468
G1 X103.829 Y131.822 E.20943
G1 X103.829 Y131.332 E.02468
G1 X107.671 Y132.926 E.20943
G1 X107.671 Y132.436 E.02468
G1 X103.829 Y130.841 E.20943
G1 X103.829 Y130.351 E.02468
G1 X107.671 Y131.946 E.20943
G1 X107.671 Y131.455 E.02468
G1 X103.829 Y129.861 E.20943
G1 X103.829 Y129.37 E.02468
G1 X107.671 Y130.965 E.20943
G1 X107.671 Y130.475 E.02468
G1 X103.829 Y128.88 E.20943
G1 X103.829 Y128.39 E.02468
G1 X107.671 Y129.984 E.20943
G1 X107.671 Y129.494 E.02468
G1 X103.829 Y127.899 E.20943
G1 X103.829 Y127.409 E.02468
G1 X107.671 Y129.004 E.20943
G1 X107.671 Y128.514 E.02468
G1 X103.829 Y126.919 E.20943
G1 X103.829 Y126.429 E.02468
G1 X107.671 Y128.023 E.20943
G1 X107.671 Y127.533 E.02468
G1 X103.829 Y125.938 E.20943
G1 X103.829 Y125.448 E.02468
G1 X107.671 Y127.043 E.20943
G1 X107.671 Y126.552 E.02468
G1 X103.829 Y124.958 E.20943
G1 X103.829 Y124.467 E.02468
G1 X107.671 Y126.062 E.20943
G1 X107.671 Y125.572 E.02468
G1 X103.829 Y123.977 E.20943
G1 X103.829 Y123.487 E.02468
G1 X107.671 Y125.081 E.20943
G1 X107.671 Y124.591 E.02468
G1 X103.829 Y122.996 E.20943
G1 X103.829 Y122.506 E.02468
G1 X107.671 Y124.101 E.20943
G1 X107.671 Y123.611 E.02468
G1 X103.829 Y122.016 E.20943
G1 X103.829 Y121.526 E.02468
G1 X107.671 Y123.12 E.20943
G1 X107.671 Y122.63 E.02468
G1 X103.829 Y121.035 E.20943
G1 X103.829 Y120.545 E.02468
G1 X107.671 Y122.14 E.20943
G1 X107.671 Y121.649 E.02468
G1 X103.829 Y120.055 E.20943
G1 X103.829 Y119.564 E.02468
G1 X107.671 Y121.159 E.20943
G1 X107.671 Y120.669 E.02468
G1 X103.829 Y119.074 E.20943
G1 X103.829 Y118.584 E.02468
G1 X107.671 Y120.178 E.20943
G1 X107.671 Y119.688 E.02468
G1 X103.829 Y118.093 E.20943
M73 P70 R8
G1 X103.829 Y117.603 E.02468
G1 X107.671 Y119.198 E.20943
G1 X107.671 Y118.707 E.02468
G1 X103.829 Y117.113 E.20943
G1 X103.829 Y116.623 E.02468
G1 X107.671 Y118.217 E.20943
G1 X107.671 Y117.727 E.02468
G1 X104.303 Y116.329 E.18361
G1 X105.484 Y116.329 E.05947
G1 X107.671 Y117.237 E.11921
G1 X107.671 Y116.746 E.02468
G1 X106.177 Y116.126 E.08142
M106 S51
; WIPE_START
G1 X107.671 Y116.746 E-.61456
G1 X107.671 Y117.129 E-.14545
; WIPE_END
G1 E-.04 F1800
G1 X108 Y115.755 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
; LAYER_HEIGHT: 0.2
G1 F4909.984
G1 X108 Y111.744 E.15487
G1 X108.126 Y111.16 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.42131
; LAYER_HEIGHT: 0.4
M106 S153
G1 F1500
G1 X127.671 Y111.171 E1.07617
G1 X127.671 Y110.725 E.02458
G1 X108.329 Y110.69 E1.06502
G1 X108.329 Y110.218 E.02595
G1 X127.671 Y110.253 E1.06502
G1 X127.671 Y109.782 E.02595
G1 X108.329 Y109.747 E1.06502
G1 X108.329 Y109.276 E.02595
G1 X127.671 Y109.311 E1.06502
G1 X127.671 Y109.229 E.00453
G1 X127.468 Y109.229 E.0112
G1 X127.468 Y108.839 E.02145
G1 X108.33 Y108.804 E1.05377
M106 S51
G1 X108.163 Y108.75 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
; LAYER_HEIGHT: 0.2
G1 F13740.983
G1 X103.663 Y108.75 E.06208
; WIPE_START
G1 X105.663 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y110.073 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y114.927 E.24736
; WIPE_START
G1 X102.75 Y112.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X104.427 Y120.373 Z2.2 F30000
G1 X108 Y136.245 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y140.256 E.15487
G1 X128 Y140.256 F30000
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y136.245 E.15488
; WIPE_START
G1 X128 Y138.245 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.489 Y135.874 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40362
; LAYER_HEIGHT: 0.4
M106 S153
G1 F1500
G1 X128.329 Y135.217 E.06736
G1 X128.329 Y134.696 E.02634
G1 X130.052 Y135.671 E.10006
G1 X130.973 Y135.671 E.04653
G1 X128.329 Y134.174 E.15353
G1 X128.329 Y133.653 E.02634
G1 X131.893 Y135.671 E.20699
G1 X132.814 Y135.671 E.04653
G1 X128.329 Y133.132 E.26046
G1 X128.329 Y132.611 E.02634
G1 X133.735 Y135.671 E.31393
G1 X134.329 Y135.671 E.03003
G1 X134.329 Y136.008 E.017
G1 X143.171 Y141.014 E.51349
G1 X143.171 Y141.535 E.02634
G1 X134.329 Y136.529 E.51349
G1 X134.329 Y137.05 E.02634
G1 X143.171 Y142.056 E.51349
G1 X143.171 Y142.171 E.00581
G1 X142.453 Y142.171 E.03627
G1 X134.329 Y137.571 E.47181
G1 X134.329 Y138.093 E.02634
G1 X141.533 Y142.171 E.41834
G1 X140.612 Y142.171 E.04653
G1 X134.329 Y138.614 E.36487
G1 X134.329 Y139.135 E.02634
G1 X139.691 Y142.171 E.3114
G1 X138.77 Y142.171 E.04653
G1 X134.329 Y139.656 E.25793
G1 X134.329 Y140.178 E.02634
G1 X137.85 Y142.171 E.20447
G1 X136.929 Y142.171 E.04653
G1 X134.329 Y140.699 E.151
G1 X134.329 Y141.22 E.02634
G1 X136.008 Y142.171 E.09753
G1 X135.088 Y142.171 E.04653
G1 X134.126 Y141.627 E.05582
M106 S51
; WIPE_START
G1 X135.088 Y142.171 E-.41976
G1 X135.983 Y142.171 E-.34024
; WIPE_END
G1 E-.04 F1800
G1 X133.382 Y134.996 Z2.2 F30000
G1 X132.885 Y133.626 Z2.2
G1 Z1.8
G1 E.8 F1800
M106 S153
G1 F1500
G1 X143.171 Y139.45 E.59732
G1 X143.171 Y138.929 E.02634
G1 X134.164 Y133.829 E.52308
G1 X135.084 Y133.829 E.04653
G1 X143.171 Y138.407 E.46962
G1 X143.171 Y137.886 E.02634
G1 X136.005 Y133.829 E.41615
G1 X136.926 Y133.829 E.04653
G1 X143.171 Y137.365 E.36268
G1 X143.171 Y136.843 E.02634
G1 X137.847 Y133.829 E.30921
G1 X138.767 Y133.829 E.04653
G1 X143.171 Y136.322 E.25574
G1 X143.171 Y135.801 E.02634
G1 X139.688 Y133.829 E.20227
G1 X140.609 Y133.829 E.04653
G1 X143.171 Y135.28 E.14881
G1 X143.171 Y134.758 E.02634
G1 X141.529 Y133.829 E.09534
G1 X142.45 Y133.829 E.04653
G1 X143.374 Y134.352 E.05363
M106 S51
; WIPE_START
G1 X142.45 Y133.829 E-.40327
G1 X141.529 Y133.829 E-.34987
G1 X141.545 Y133.838 E-.00685
; WIPE_END
G1 E-.04 F1800
G1 X145.626 Y130.571 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.41402
M106 S153
G1 F1500
G1 X146.513 Y131.171 E.05694
G1 X147.34 Y131.171 E.044
G1 X145.829 Y130.147 E.09707
G1 X145.829 Y129.587 E.0298
G1 X148.168 Y131.171 E.15021
G1 X148.995 Y131.171 E.044
G1 X145.829 Y129.026 E.20335
G1 X145.829 Y128.466 E.0298
M73 P71 R8
G1 X150.122 Y131.374 E.27569
M106 S51
G1 X150.626 Y131.715 F30000
M106 S153
G1 F1500
G1 X152.171 Y132.762 E.09921
G1 X152.171 Y132.201 E.0298
G1 X145.829 Y127.906 E.40731
G1 X145.829 Y127.345 E.0298
G1 X152.171 Y131.641 E.40731
G1 X152.171 Y131.08 E.0298
G1 X145.829 Y126.785 E.40731
G1 X145.829 Y126.224 E.0298
G1 X152.171 Y130.52 E.40731
G1 X152.171 Y129.96 E.0298
G1 X145.829 Y125.664 E.40731
G1 X145.829 Y125.103 E.0298
G1 X152.171 Y129.399 E.40731
G1 X152.171 Y128.839 E.0298
G1 X145.829 Y124.543 E.40731
G1 X145.829 Y123.983 E.0298
G1 X152.171 Y128.278 E.40731
G1 X152.171 Y127.718 E.0298
G1 X145.829 Y123.422 E.40731
G1 X145.829 Y122.862 E.0298
G1 X152.171 Y127.157 E.40731
G1 X152.171 Y126.597 E.0298
G1 X145.829 Y122.301 E.40731
G1 X145.829 Y121.741 E.0298
G1 X152.171 Y126.036 E.40731
G1 X152.171 Y125.476 E.0298
G1 X145.829 Y121.18 E.40731
G1 X145.829 Y120.829 E.01869
G1 X146.137 Y120.829 E.0164
G1 X152.171 Y124.916 E.3875
G1 X152.171 Y124.355 E.0298
G1 X146.965 Y120.829 E.33436
G1 X147.792 Y120.829 E.044
G1 X152.171 Y123.795 E.28122
G1 X152.171 Y123.234 E.0298
G1 X148.62 Y120.829 E.22808
G1 X149.447 Y120.829 E.044
G1 X152.171 Y122.674 E.17494
G1 X152.171 Y122.113 E.0298
G1 X150.275 Y120.829 E.1218
G1 X150.829 Y120.829 E.02948
G1 X150.829 Y120.644 E.00984
G1 X152.171 Y121.553 E.0862
G1 X152.171 Y120.993 E.0298
G1 X150.829 Y120.083 E.0862
G1 X150.829 Y119.676 E.02165
G1 X150.926 Y119.589 E.00695
G1 X152.171 Y120.432 E.07997
G1 X152.171 Y119.872 E.0298
G1 X151.108 Y119.152 E.06829
M106 S51
G1 X150.851 Y119.099 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
; LAYER_HEIGHT: 0.2
G1 F2880
G1 X151.14 Y118.838 E.01158
G1 X151.319 Y118.797 E.00547
G1 X152.149 Y119.348 E.02968
G1 X152.149 Y109.851 E.28288
G1 X150.851 Y109.851 E.03865
G1 X150.851 Y119.039 E.27366
G1 X151.73 Y110.5 F30000
; LINE_WIDTH: 0.50318
G1 F2880
G1 X151.73 Y110.27 E.00837
G1 X151.27 Y110.27 E.01673
G1 X151.27 Y118.433 E.2968
G1 X151.436 Y118.395 E.00619
G1 X151.73 Y118.559 E.01225
G1 X151.73 Y110.56 E.29083
; WIPE_START
G1 X151.73 Y112.56 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X150.256 Y109.5 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X143.745 Y109.5 E.2514
G1 X143.374 Y110.373 F30000
; FEATURE: Bridge
; LINE_WIDTH: 0.40362
; LAYER_HEIGHT: 0.4
M106 S153
G1 F1500
G1 X142.412 Y109.829 E.05581
G1 X141.492 Y109.829 E.04653
G1 X143.171 Y110.78 E.09752
G1 X143.171 Y111.301 E.02634
G1 X140.571 Y109.829 E.15099
G1 X139.65 Y109.829 E.04653
G1 X143.171 Y111.822 E.20446
G1 X143.171 Y112.343 E.02634
G1 X138.73 Y109.829 E.25793
G1 X137.809 Y109.829 E.04653
G1 X143.171 Y112.865 E.3114
G1 X143.171 Y113.386 E.02634
G1 X136.888 Y109.829 E.36486
G1 X135.967 Y109.829 E.04653
G1 X143.171 Y113.907 E.41833
G1 X143.171 Y114.429 E.02634
G1 X135.047 Y109.829 E.4718
G1 X134.329 Y109.829 E.03628
G1 X134.329 Y109.944 E.0058
G1 X143.171 Y114.95 E.51349
G1 X143.171 Y115.471 E.02634
G1 X134.329 Y110.465 E.51349
G1 X134.329 Y110.986 E.02634
G1 X143.171 Y115.992 E.51349
G1 X143.171 Y116.514 E.02634
G1 X134.329 Y111.508 E.51349
G1 X134.329 Y112.029 E.02634
G1 X143.171 Y117.035 E.51349
G1 X143.171 Y117.556 E.02634
G1 X134.329 Y112.55 E.51349
G1 X134.329 Y113.071 E.02634
G1 X143.171 Y118.078 E.51349
G1 X143.171 Y118.171 E.00473
G1 X142.416 Y118.171 E.03817
G1 X134.329 Y113.593 E.46962
G1 X134.329 Y114.114 E.02634
G1 X141.495 Y118.171 E.41615
G1 X140.574 Y118.171 E.04653
G1 X134.329 Y114.635 E.36269
G1 X134.329 Y115.156 E.02634
G1 X139.654 Y118.171 E.30922
G1 X138.733 Y118.171 E.04653
G1 X134.329 Y115.678 E.25575
G1 X134.329 Y116.199 E.02634
G1 X137.812 Y118.171 E.20228
G1 X136.891 Y118.171 E.04653
G1 X133.637 Y116.329 E.18896
G1 X132.717 Y116.329 E.04653
G1 X135.971 Y118.171 E.18896
G1 X135.05 Y118.171 E.04653
G1 X131.796 Y116.329 E.18896
G1 X130.875 Y116.329 E.04653
G1 X134.129 Y118.171 E.18896
G1 X133.209 Y118.171 E.04653
G1 X129.955 Y116.329 E.18896
G1 X129.034 Y116.329 E.04653
G1 X132.288 Y118.171 E.18896
G1 X132.171 Y118.171 E.0059
G1 X132.171 Y118.626 E.023
G1 X128.329 Y116.451 E.22313
G1 X128.329 Y116.972 E.02634
G1 X132.171 Y119.148 E.22313
G1 X132.171 Y119.669 E.02634
G1 X128.329 Y117.494 E.22313
G1 X128.329 Y118.015 E.02634
G1 X132.171 Y120.19 E.22313
G1 X132.171 Y120.711 E.02634
G1 X128.329 Y118.536 E.22313
G1 X128.329 Y119.057 E.02634
G1 X132.171 Y121.233 E.22313
G1 X132.171 Y121.754 E.02634
G1 X128.329 Y119.579 E.22313
G1 X128.329 Y120.1 E.02634
G1 X132.171 Y122.275 E.22313
G1 X132.171 Y122.797 E.02634
G1 X128.329 Y120.621 E.22313
G1 X128.329 Y121.142 E.02634
G1 X132.171 Y123.318 E.22313
G1 X132.171 Y123.839 E.02634
G1 X128.329 Y121.664 E.22313
G1 X128.329 Y122.185 E.02634
G1 X132.171 Y124.36 E.22313
G1 X132.171 Y124.882 E.02634
G1 X128.329 Y122.706 E.22313
G1 X128.329 Y123.228 E.02634
G1 X132.171 Y125.403 E.22313
G1 X132.171 Y125.924 E.02634
G1 X128.329 Y123.749 E.22313
G1 X128.329 Y124.27 E.02634
G1 X132.171 Y126.445 E.22313
G1 X132.171 Y126.967 E.02634
G1 X128.329 Y124.791 E.22313
G1 X128.329 Y125.313 E.02634
G1 X132.171 Y127.488 E.22313
G1 X132.171 Y128.009 E.02634
G1 X128.329 Y125.834 E.22313
G1 X128.329 Y126.355 E.02634
G1 X132.171 Y128.531 E.22313
G1 X132.171 Y129.052 E.02634
G1 X128.329 Y126.877 E.22313
G1 X128.329 Y127.398 E.02634
G1 X132.171 Y129.573 E.22313
G1 X132.171 Y130.094 E.02634
G1 X128.329 Y127.919 E.22313
G1 X128.329 Y128.44 E.02634
G1 X132.171 Y130.616 E.22313
G1 X132.171 Y131.137 E.02634
G1 X128.329 Y128.962 E.22313
G1 X128.329 Y129.483 E.02634
M73 P72 R8
G1 X132.171 Y131.658 E.22313
G1 X132.171 Y132.18 E.02634
G1 X128.329 Y130.004 E.22313
G1 X128.329 Y130.525 E.02634
G1 X132.171 Y132.701 E.22313
G1 X132.171 Y133.222 E.02634
M73 P72 R7
G1 X128.329 Y131.047 E.22313
G1 X128.329 Y131.568 E.02634
G1 X143.171 Y139.971 E.86192
G1 X143.171 Y140.492 E.02634
G1 X128.126 Y131.975 E.87368
M106 S51
; WIPE_START
G1 X129.867 Y132.96 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.043 Y125.372 Z2.2 F30000
G1 X128 Y115.755 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
; LAYER_HEIGHT: 0.2
G1 F4909.783
G1 X128 Y111.744 E.15488
; WIPE_START
G1 X128 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.837 Y108.75 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X132.337 Y108.75 E.06208
; WIPE_START
G1 X130.337 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.155 Y115.843 Z2.2 F30000
G1 X143.745 Y142.5 Z2.2
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X150.256 Y142.5 E.2514
G1 X150.851 Y142.149 F30000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F2880
G1 X152.149 Y142.149 E.03865
G1 X152.149 Y133.269 E.2645
G1 X150.875 Y132.792 E.04052
G1 X150.851 Y133.719 E.02761
G1 X150.851 Y142.089 E.2493
G1 X151.73 Y133.719 F30000
; LINE_WIDTH: 0.503185
G1 F2880
G1 X151.73 Y133.559 E.0058
G1 X151.27 Y133.387 E.01787
G1 X151.27 Y141.73 E.30333
G1 X151.73 Y141.73 E.01673
G1 X151.73 Y133.779 E.28909
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F2880
G1 X151.73 Y135.779 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 10/27
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
G17
G3 Z2.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X129.29 Y142.552
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y142.552 E.02708
G1 X128.448 Y136.448 E.19629
G1 X133.552 Y136.448 E.16413
G1 X133.552 Y142.552 E.19629
G1 X129.33 Y142.552 E.13577
G1 X128.855 Y141.71 F30000
G1 F3600
G1 X128.855 Y136.855 E.15612
G1 X133.145 Y136.855 E.13795
G1 X133.145 Y142.145 E.17011
G1 X128.855 Y142.145 E.13795
G1 X128.855 Y141.75 E.0127
M204 S250
G1 X129.29 Y141.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y141.71 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y142.959 E.04017
G1 X132.541 Y142.959 E.1447
G1 X132.541 Y143.541 E.01871
G1 X103.459 Y143.541 E.93516
G1 X103.459 Y142.959 E.01871
G1 X107.959 Y142.959 E.1447
G1 X107.959 Y140.459 E.08039
G1 X128.041 Y140.459 E.64576
G1 X128.041 Y141.67 E.03894
; WIPE_START
G1 X128.041 Y142.959 E-.48987
G1 X128.752 Y142.959 E-.27013
; WIPE_END
G1 E-.04 F1800
G1 X121.47 Y140.673 Z2.4 F30000
G1 X106.71 Y136.041 Z2.4
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X103.459 Y136.041 E.10454
G1 X103.459 Y115.959 E.64576
G1 X108.041 Y115.959 E.14733
G1 X108.041 Y136.041 E.64576
G1 X106.75 Y136.041 E.04151
; WIPE_START
G1 X104.75 Y136.041 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y140.052 Z2.4 F30000
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X108.448 Y140.052 E.02708
G1 X108.448 Y111.948 E.90373
G1 X127.552 Y111.948 E.61432
G1 X127.552 Y140.052 E.90373
G1 X109.33 Y140.052 E.58595
G1 X109.29 Y139.645 F30000
G1 F3600
G1 X108.855 Y139.645 E.01399
G1 X108.855 Y112.355 E.87755
G1 X127.145 Y112.355 E.58814
G1 X127.145 Y139.645 E.87755
G1 X109.33 Y139.645 E.57287
M204 S250
G1 X109.29 Y139.21 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.747 Y130.987 Z2.4 F30000
G1 X128.448 Y110.29 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y109.448 E.02708
G1 X133.552 Y109.448 E.16413
G1 X133.552 Y115.552 E.19629
G1 X128.448 Y115.552 E.16413
G1 X128.448 Y110.33 E.16792
G1 X129.29 Y109.855 F30000
G1 F3600
G1 X133.145 Y109.855 E.12396
G1 X133.145 Y115.145 E.17011
G1 X128.855 Y115.145 E.13795
G1 X128.855 Y109.855 E.17011
G1 X129.25 Y109.855 E.0127
M204 S250
G1 X129.29 Y110.29 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y110.29 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y111.541 E.04022
G1 X107.959 Y111.541 E.64576
G1 X107.959 Y109.041 E.08039
G1 X103.459 Y109.041 E.1447
G1 X103.459 Y108.459 E.01871
G1 X132.541 Y108.459 E.93516
G1 X132.541 Y109.041 E.01871
G1 X128.041 Y109.041 E.1447
G1 X128.041 Y110.25 E.03888
; WIPE_START
G1 X128.041 Y111.541 E-.49053
G1 X127.332 Y111.541 E-.26947
; WIPE_END
G1 E-.04 F1800
M73 P73 R7
G1 X134.944 Y110.987 Z2.4 F30000
G1 X149.21 Y109.948 Z2.4
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X150.052 Y109.948 E.02708
G1 X150.052 Y120.052 E.32491
G1 X145.052 Y120.052 E.16078
G1 X145.052 Y131.948 E.38253
G1 X150.052 Y131.948 E.16078
G1 X150.052 Y142.052 E.32491
G1 X143.948 Y142.052 E.19629
G1 X143.948 Y133.052 E.28941
G1 X132.948 Y133.052 E.35372
G1 X132.948 Y118.948 E.45354
G1 X143.948 Y118.948 E.35372
G1 X143.948 Y109.948 E.28941
G1 X149.17 Y109.948 E.16792
G1 X149.21 Y110.355 F30000
G1 F3600
G1 X149.645 Y110.355 E.01399
G1 X149.645 Y119.645 E.29873
G1 X144.645 Y119.645 E.16078
G1 X144.645 Y132.355 E.40871
G1 X149.645 Y132.355 E.16078
G1 X149.645 Y141.645 E.29873
G1 X144.355 Y141.645 E.17011
G1 X144.355 Y132.645 E.28941
G1 X133.355 Y132.645 E.35372
G1 X133.355 Y119.355 E.42736
G1 X144.355 Y119.355 E.35372
G1 X144.355 Y110.355 E.28941
G1 X149.17 Y110.355 E.15483
; WIPE_START
G1 X149.645 Y110.355 E-.1805
G1 X149.645 Y111.88 E-.5795
; WIPE_END
G1 E-.04 F1800
G1 X147.674 Y119.253 Z2.4 F30000
G1 X144.21 Y132.21 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X144.584 Y124.924 Z2.4 F30000
G1 X149.21 Y110.79 Z2.4
G1 Z2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.191 Y120.422 Z2.4 F30000
G1 X149.21 Y132.79 Z2.4
G1 Z2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.541 Y133.459 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X143.541 Y142.541 E.29204
G1 X133.959 Y142.541 E.30811
G1 X133.959 Y136.041 E.20902
G1 X127.959 Y136.041 E.19294
G1 X127.959 Y115.959 E.64576
G1 X133.959 Y115.959 E.19294
G1 X133.959 Y109.459 E.20902
G1 X143.541 Y109.459 E.30811
G1 X143.541 Y118.541 E.29204
G1 X132.541 Y118.541 E.35372
G1 X132.541 Y133.459 E.47972
G1 X143.501 Y133.459 E.35243
; WIPE_START
G1 X143.51 Y135.459 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.238 Y128.025 Z2.4 F30000
G1 X145.459 Y127.074 Z2.4
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X145.459 Y120.459 E.21272
G1 X150.459 Y120.459 E.16078
G1 X150.459 Y109.459 E.35372
G1 X152.541 Y109.459 E.06694
G1 X152.541 Y142.541 E1.06379
G1 X150.459 Y142.541 E.06694
G1 X150.459 Y131.541 E.35372
G1 X145.459 Y131.541 E.16078
G1 X145.459 Y127.114 E.14234
; WIPE_START
G1 X145.459 Y125.114 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.076 Y131.362 Z2.4 F30000
G1 X132.948 Y142.948 Z2.4
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X132.948 Y143.948 E.03216
G1 X103.052 Y143.948 E.96134
G1 X103.052 Y142.552 E.04489
G1 X107.552 Y142.552 E.1447
G1 X107.552 Y136.448 E.19629
G1 X103.052 Y136.448 E.1447
G1 X103.052 Y115.552 E.67194
G1 X107.552 Y115.552 E.1447
G1 X107.552 Y109.448 E.19629
G1 X103.052 Y109.448 E.1447
G1 X103.052 Y108.052 E.04489
G1 X132.948 Y108.052 E.96134
G1 X132.948 Y109.052 E.03216
G1 X152.948 Y109.052 E.64313
G1 X152.948 Y142.948 E1.08997
G1 X132.988 Y142.948 E.64184
G1 X133.355 Y143.355 F30000
G1 F3600
G1 X133.355 Y144.355 E.03216
G1 X102.645 Y144.355 E.98752
G1 X102.645 Y142.145 E.07107
G1 X107.145 Y142.145 E.1447
G1 X107.145 Y136.855 E.17011
G1 X102.645 Y136.855 E.1447
G1 X102.645 Y115.145 E.69812
G1 X107.145 Y115.145 E.1447
G1 X107.145 Y109.855 E.17011
G1 X102.645 Y109.855 E.1447
G1 X102.645 Y107.645 E.07107
G1 X133.355 Y107.645 E.98752
G1 X133.355 Y108.645 E.03216
G1 X153.355 Y108.645 E.64313
G1 X153.355 Y143.355 E1.11615
G1 X133.395 Y143.355 E.64184
; WIPE_START
G1 X133.355 Y144.355 E-.3803
G1 X132.356 Y144.355 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X127.765 Y138.257 Z2.4 F30000
G1 X106.71 Y110.29 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
M73 P74 R7
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.694 Y119.922 Z2.4 F30000
G1 X106.71 Y141.71 Z2.4
G1 Z2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.323 Y142.242 Z2.4 F30000
G1 X133.79 Y143.79 Z2.4
G1 Z2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
G1 X132.791 Y144.79 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X132.337 Y143.25 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y143.25 E.06208
; WIPE_START
G1 X129.837 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128 Y140.256 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y136.245 E.15488
; WIPE_START
G1 X128 Y138.245 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.456 Y139.874 Z2.4 F30000
G1 X143.377 Y141.606 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42443
G1 F3600
G1 X142.775 Y142.208 E.02566
G1 X142.236 Y142.208 E.01626
G1 X143.208 Y141.236 E.04142
G1 X143.208 Y140.696 E.01626
G1 X141.696 Y142.208 E.06441
G1 X141.157 Y142.208 E.01626
G1 X143.208 Y140.157 E.08741
G1 X143.208 Y139.617 E.01626
G1 X140.617 Y142.208 E.1104
G1 X140.078 Y142.208 E.01626
G1 X143.208 Y139.078 E.1334
G1 X143.208 Y138.538 E.01626
G1 X139.538 Y142.208 E.15639
G1 X138.999 Y142.208 E.01626
G1 X143.208 Y137.999 E.17939
G1 X143.208 Y137.459 E.01626
G1 X138.459 Y142.208 E.20238
G1 X137.92 Y142.208 E.01626
G1 X143.208 Y136.92 E.22538
G1 X143.208 Y136.38 E.01626
G1 X137.38 Y142.208 E.24837
G1 X136.84 Y142.208 E.01626
G1 X143.208 Y135.84 E.27137
G1 X143.208 Y135.301 E.01626
G1 X136.301 Y142.208 E.29436
G1 X135.761 Y142.208 E.01626
G1 X143.208 Y134.761 E.31736
G1 X143.208 Y134.222 E.01626
G1 X135.222 Y142.208 E.34035
G1 X134.682 Y142.208 E.01626
G1 X143.098 Y133.792 E.35866
G1 X142.558 Y133.792 E.01626
G1 X134.292 Y142.058 E.35229
G1 X134.292 Y141.519 E.01626
G1 X142.019 Y133.792 E.3293
G1 X141.479 Y133.792 E.01626
G1 X134.292 Y140.979 E.3063
G1 X134.292 Y140.44 E.01626
G1 X140.94 Y133.792 E.28331
G1 X140.4 Y133.792 E.01626
G1 X134.292 Y139.9 E.26031
G1 X134.292 Y139.361 E.01626
G1 X139.861 Y133.792 E.23732
G1 X139.321 Y133.792 E.01626
G1 X134.292 Y138.821 E.21432
G1 X134.292 Y138.281 E.01626
G1 X138.781 Y133.792 E.19133
G1 X138.242 Y133.792 E.01626
G1 X134.292 Y137.742 E.16833
G1 X134.292 Y137.202 E.01626
G1 X137.702 Y133.792 E.14534
G1 X137.163 Y133.792 E.01626
G1 X134.292 Y136.663 E.12234
G1 X134.292 Y136.123 E.01626
G1 X136.623 Y133.792 E.09935
G1 X136.084 Y133.792 E.01626
G1 X134.168 Y135.708 E.08163
G1 X133.629 Y135.708 E.01626
G1 X135.544 Y133.792 E.08163
G1 X135.005 Y133.792 E.01626
G1 X133.089 Y135.708 E.08163
G1 X132.55 Y135.708 E.01626
G1 X134.465 Y133.792 E.08163
G1 X133.926 Y133.792 E.01626
G1 X132.01 Y135.708 E.08163
G1 X131.471 Y135.708 E.01626
G1 X133.386 Y133.792 E.08163
G1 X132.847 Y133.792 E.01626
G1 X130.931 Y135.708 E.08163
G1 X130.392 Y135.708 E.01626
G1 X132.307 Y133.792 E.08163
G1 X132.208 Y133.792 E.00299
G1 X132.208 Y133.352 E.01327
G1 X129.852 Y135.708 E.1004
G1 X129.313 Y135.708 E.01626
G1 X132.208 Y132.813 E.12339
M73 P75 R7
G1 X132.208 Y132.273 E.01626
G1 X128.773 Y135.708 E.14639
G1 X128.292 Y135.708 E.01449
G1 X128.292 Y135.649 E.00177
G1 X132.208 Y131.733 E.16687
G1 X132.208 Y131.194 E.01626
G1 X128.292 Y135.109 E.16687
G1 X128.292 Y134.57 E.01626
G1 X132.208 Y130.654 E.16687
G1 X132.208 Y130.115 E.01626
G1 X128.292 Y134.03 E.16687
G1 X128.292 Y133.491 E.01626
G1 X132.208 Y129.575 E.16687
G1 X132.208 Y129.036 E.01626
G1 X128.292 Y132.951 E.16687
G1 X128.292 Y132.412 E.01626
G1 X132.208 Y128.496 E.16687
G1 X132.208 Y127.957 E.01626
G1 X128.292 Y131.872 E.16687
G1 X128.292 Y131.333 E.01626
G1 X132.208 Y127.417 E.16687
G1 X132.208 Y126.878 E.01626
G1 X128.292 Y130.793 E.16687
G1 X128.292 Y130.254 E.01626
G1 X132.208 Y126.338 E.16687
G1 X132.208 Y125.799 E.01626
G1 X128.292 Y129.714 E.16687
G1 X128.292 Y129.174 E.01626
G1 X132.208 Y125.259 E.16687
G1 X132.208 Y124.719 E.01626
G1 X128.292 Y128.635 E.16687
G1 X128.292 Y128.095 E.01626
G1 X132.208 Y124.18 E.16687
G1 X132.208 Y123.64 E.01626
G1 X128.292 Y127.556 E.16687
G1 X128.292 Y127.016 E.01626
G1 X132.208 Y123.101 E.16687
G1 X132.208 Y122.561 E.01626
G1 X128.292 Y126.477 E.16687
G1 X128.292 Y125.937 E.01626
G1 X132.208 Y122.022 E.16687
G1 X132.208 Y121.482 E.01626
G1 X128.292 Y125.398 E.16687
G1 X128.292 Y124.858 E.01626
G1 X132.208 Y120.943 E.16687
G1 X132.208 Y120.403 E.01626
G1 X128.292 Y124.319 E.16687
G1 X128.292 Y123.779 E.01626
G1 X132.208 Y119.864 E.16687
G1 X132.208 Y119.324 E.01626
G1 X128.292 Y123.24 E.16687
G1 X128.292 Y122.7 E.01626
G1 X132.377 Y118.615 E.1741
; WIPE_START
G1 X130.963 Y120.029 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.523 Y118.98 Z2.4 F30000
G1 X142.866 Y118.377 Z2.4
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X143.208 Y118.036 E.01456
G1 X143.208 Y117.496 E.01626
G1 X142.496 Y118.208 E.03032
G1 X141.957 Y118.208 E.01626
G1 X143.208 Y116.957 E.05332
G1 X143.208 Y116.417 E.01626
G1 X141.417 Y118.208 E.07631
G1 X140.878 Y118.208 E.01626
G1 X143.208 Y115.878 E.09931
G1 X143.208 Y115.338 E.01626
G1 X140.338 Y118.208 E.1223
G1 X139.799 Y118.208 E.01626
G1 X143.208 Y114.799 E.1453
G1 X143.208 Y114.259 E.01626
G1 X139.259 Y118.208 E.16829
G1 X138.72 Y118.208 E.01626
G1 X143.208 Y113.719 E.19129
G1 X143.208 Y113.18 E.01626
G1 X138.18 Y118.208 E.21428
G1 X137.64 Y118.208 E.01626
G1 X143.208 Y112.64 E.23727
G1 X143.208 Y112.101 E.01626
G1 X137.101 Y118.208 E.26027
G1 X136.561 Y118.208 E.01626
G1 X143.208 Y111.561 E.28326
G1 X143.208 Y111.022 E.01626
G1 X136.022 Y118.208 E.30626
G1 X135.482 Y118.208 E.01626
G1 X143.208 Y110.482 E.32925
G1 X143.208 Y109.943 E.01626
G1 X134.943 Y118.208 E.35225
G1 X134.403 Y118.208 E.01626
G1 X142.819 Y109.792 E.35866
G1 X142.279 Y109.792 E.01626
G1 X133.864 Y118.208 E.35866
G1 X133.324 Y118.208 E.01626
G1 X141.74 Y109.792 E.35866
G1 X141.2 Y109.792 E.01626
G1 X132.615 Y118.377 E.36589
G1 X128.123 Y122.33 F30000
G1 F3600
G1 X140.66 Y109.792 E.53436
G1 X140.121 Y109.792 E.01626
G1 X134.292 Y115.621 E.24841
G1 X134.292 Y115.081 E.01626
G1 X139.581 Y109.792 E.22542
G1 X139.042 Y109.792 E.01626
G1 X134.292 Y114.542 E.20242
G1 X134.292 Y114.002 E.01626
G1 X138.502 Y109.792 E.17943
G1 X137.963 Y109.792 E.01626
G1 X134.292 Y113.463 E.15643
G1 X134.292 Y112.923 E.01626
G1 X137.423 Y109.792 E.13344
G1 X136.884 Y109.792 E.01626
G1 X134.292 Y112.384 E.11045
G1 X134.292 Y111.844 E.01626
G1 X136.344 Y109.792 E.08745
G1 X135.805 Y109.792 E.01626
G1 X134.292 Y111.305 E.06446
G1 X134.292 Y110.765 E.01626
G1 X135.265 Y109.792 E.04146
G1 X134.726 Y109.792 E.01626
G1 X134.123 Y110.395 E.0257
; WIPE_START
G1 X134.726 Y109.792 E-.32403
G1 X135.265 Y109.792 E-.20502
G1 X134.835 Y110.222 E-.23095
; WIPE_END
G1 E-.04 F1800
G1 X133.791 Y116.123 Z2.4 F30000
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X128.292 Y121.621 E.23434
G1 X128.292 Y121.081 E.01626
G1 X133.081 Y116.292 E.20411
G1 X132.542 Y116.292 E.01626
G1 X128.292 Y120.542 E.18112
G1 X128.292 Y120.002 E.01626
G1 X132.002 Y116.292 E.15812
G1 X131.463 Y116.292 E.01626
G1 X128.292 Y119.463 E.13513
G1 X128.292 Y118.923 E.01626
G1 X130.923 Y116.292 E.11213
G1 X130.384 Y116.292 E.01626
G1 X128.292 Y118.384 E.08914
G1 X128.292 Y117.844 E.01626
G1 X129.844 Y116.292 E.06614
G1 X129.305 Y116.292 E.01626
G1 X128.292 Y117.305 E.04315
G1 X128.292 Y116.765 E.01626
G1 X128.935 Y116.123 E.02738
; WIPE_START
G1 X128.292 Y116.765 E-.34528
G1 X128.292 Y117.305 E-.20503
G1 X128.682 Y116.914 E-.20969
; WIPE_END
G1 E-.04 F1800
G1 X128 Y115.755 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y111.744 E.15488
; WIPE_START
G1 X128 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.837 Y108.75 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X132.337 Y108.75 E.06208
; WIPE_START
G1 X130.337 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.958 Y109.176 Z2.4 F30000
G1 X143.745 Y109.5 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X150.256 Y109.5 E.2514
; WIPE_START
G1 X148.256 Y109.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.227 Y117.07 Z2.4 F30000
G1 X152.377 Y141.604 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42503
G1 F3600
G1 X151.774 Y142.208 E.02575
G1 X151.234 Y142.208 E.01631
G1 X152.208 Y141.234 E.04158
M73 P75 R6
G1 X152.208 Y140.693 E.01631
G1 X150.792 Y142.109 E.06042
G1 X150.792 Y141.568 E.01631
G1 X152.208 Y140.153 E.06042
G1 X152.208 Y139.613 E.01631
G1 X150.792 Y141.028 E.06042
G1 X150.792 Y140.488 E.01631
G1 X152.208 Y139.072 E.06042
G1 X152.208 Y138.532 E.01631
G1 X150.792 Y139.947 E.06042
G1 X150.792 Y139.407 E.01631
G1 X152.208 Y137.991 E.06042
G1 X152.208 Y137.451 E.01631
G1 X150.792 Y138.866 E.06042
G1 X150.792 Y138.326 E.01631
G1 X152.208 Y136.911 E.06042
G1 X152.208 Y136.37 E.01631
G1 X150.792 Y137.786 E.06042
G1 X150.792 Y137.245 E.01631
G1 X152.208 Y135.83 E.06042
G1 X152.208 Y135.29 E.01631
G1 X150.792 Y136.705 E.06042
G1 X150.792 Y136.165 E.01631
G1 X152.208 Y134.749 E.06042
G1 X152.208 Y134.209 E.01631
G1 X150.792 Y135.624 E.06042
G1 X150.792 Y135.084 E.01631
G1 X152.208 Y133.668 E.06042
G1 X152.208 Y133.128 E.01631
G1 X150.792 Y134.543 E.06042
G1 X150.792 Y134.003 E.01631
G1 X152.208 Y132.588 E.06042
G1 X152.208 Y132.047 E.01631
G1 X150.792 Y133.463 E.06042
G1 X150.792 Y132.922 E.01631
G1 X152.208 Y131.507 E.06042
G1 X152.208 Y130.966 E.01631
G1 X150.792 Y132.382 E.06042
G1 X150.792 Y131.841 E.01631
G1 X152.208 Y130.426 E.06042
G1 X152.208 Y129.886 E.01631
G1 X150.792 Y131.301 E.06042
G1 X150.792 Y131.208 E.00282
G1 X150.345 Y131.208 E.01349
G1 X152.208 Y129.345 E.0795
G1 X152.208 Y128.805 E.01631
G1 X149.805 Y131.208 E.10257
G1 X149.264 Y131.208 E.01631
G1 X152.208 Y128.264 E.12564
G1 X152.208 Y127.724 E.01631
G1 X148.724 Y131.208 E.1487
G1 X148.184 Y131.208 E.01631
G1 X152.208 Y127.184 E.17177
G1 X152.208 Y126.643 E.01631
G1 X147.643 Y131.208 E.19484
G1 X147.103 Y131.208 E.01631
G1 X152.208 Y126.103 E.2179
G1 X152.208 Y125.563 E.01631
G1 X146.563 Y131.208 E.24097
G1 X146.022 Y131.208 E.01631
G1 X152.208 Y125.022 E.26404
G1 X152.208 Y124.482 E.01631
G1 X145.792 Y130.897 E.27385
G1 X145.792 Y130.357 E.01631
G1 X152.208 Y123.941 E.27385
G1 X152.208 Y123.401 E.01631
G1 X145.792 Y129.816 E.27385
G1 X145.792 Y129.276 E.01631
G1 X152.208 Y122.861 E.27385
G1 X152.208 Y122.32 E.01631
G1 X145.792 Y128.736 E.27385
G1 X145.792 Y128.195 E.01631
G1 X152.208 Y121.78 E.27385
G1 X152.208 Y121.239 E.01631
G1 X145.792 Y127.655 E.27385
G1 X145.792 Y127.115 E.01631
G1 X152.208 Y120.699 E.27385
G1 X152.208 Y120.159 E.01631
G1 X145.792 Y126.574 E.27385
G1 X145.792 Y126.034 E.01631
G1 X152.208 Y119.618 E.27385
G1 X152.208 Y119.078 E.01631
G1 X145.792 Y125.493 E.27385
G1 X145.792 Y124.953 E.01631
G1 X149.953 Y120.792 E.17761
G1 X149.413 Y120.792 E.01631
G1 X145.792 Y124.413 E.15454
G1 X145.792 Y123.872 E.01631
G1 X148.872 Y120.792 E.13147
G1 X148.332 Y120.792 E.01631
G1 X145.792 Y123.332 E.1084
G1 X145.792 Y122.791 E.01631
G1 X147.791 Y120.792 E.08534
G1 X147.251 Y120.792 E.01631
G1 X145.792 Y122.251 E.06227
G1 X145.792 Y121.711 E.01631
G1 X146.711 Y120.792 E.0392
G1 X146.17 Y120.792 E.01631
G1 X145.623 Y121.34 E.02338
; WIPE_START
G1 X146.17 Y120.792 E-.29433
G1 X146.711 Y120.792 E-.20534
G1 X146.226 Y121.277 E-.26033
; WIPE_END
G1 E-.04 F1800
G1 X150.623 Y120.123 Z2.4 F30000
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X152.208 Y118.538 E.06766
G1 X152.208 Y117.997 E.01631
G1 X150.792 Y119.413 E.06042
G1 X150.792 Y118.872 E.01631
G1 X152.208 Y117.457 E.06042
G1 X152.208 Y116.916 E.01631
G1 X150.792 Y118.332 E.06042
G1 X150.792 Y117.791 E.01631
G1 X152.208 Y116.376 E.06042
G1 X152.208 Y115.836 E.01631
G1 X150.792 Y117.251 E.06042
G1 X150.792 Y116.711 E.01631
G1 X152.208 Y115.295 E.06042
G1 X152.208 Y114.755 E.01631
G1 X150.792 Y116.17 E.06042
G1 X150.792 Y115.63 E.01631
G1 X152.208 Y114.214 E.06042
G1 X152.208 Y113.674 E.01631
G1 X150.792 Y115.09 E.06042
G1 X150.792 Y114.549 E.01631
G1 X152.208 Y113.134 E.06042
G1 X152.208 Y112.593 E.01631
G1 X150.792 Y114.009 E.06042
G1 X150.792 Y113.468 E.01631
G1 X152.208 Y112.053 E.06042
G1 X152.208 Y111.513 E.01631
G1 X150.792 Y112.928 E.06042
G1 X150.792 Y112.388 E.01631
G1 X152.208 Y110.972 E.06042
G1 X152.208 Y110.432 E.01631
G1 X150.792 Y111.847 E.06042
G1 X150.792 Y111.307 E.01631
G1 X152.208 Y109.891 E.06042
G1 X152.208 Y109.792 E.00299
G1 X151.766 Y109.792 E.01332
G1 X150.792 Y110.766 E.04158
G1 X150.792 Y110.226 E.01631
G1 X151.396 Y109.623 E.02576
; WIPE_START
G1 X150.792 Y110.226 E-.32429
G1 X150.792 Y110.766 E-.20534
G1 X151.221 Y110.338 E-.23036
; WIPE_END
G1 E-.04 F1800
G1 X150.992 Y117.967 Z2.4 F30000
G1 X150.256 Y142.5 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X143.745 Y142.5 E.2514
; WIPE_START
G1 X145.745 Y142.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.113 Y142.395 Z2.4 F30000
G1 X109.5 Y142 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y142 E.55165
G1 X126.895 Y141.605 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X109.105 Y141.605 E.52987
G1 X109.105 Y142.363 E.02256
G1 X109.169 Y142.395 E.00212
G1 X126.873 Y142.395 E.52733
M73 P76 R6
G1 X126.895 Y141.665 E.02173
G1 X127.272 Y141.228 F30000
G1 F3600
G1 X108.728 Y141.228 E.55233
G1 X108.728 Y142.552 E.03944
G1 X108.817 Y142.597 E.00296
G1 X108.876 Y142.772 E.0055
G1 X127.124 Y142.772 E.54353
G1 X127.183 Y142.597 E.0055
G1 X127.272 Y142.552 E.00297
G1 X127.272 Y141.288 E.03765
G1 X127.649 Y140.851 F30000
G1 F3600
G1 X108.351 Y140.851 E.5748
G1 X108.351 Y142.749 E.05653
G1 X108.517 Y142.824 E.00541
G1 X108.555 Y143.149 E.00974
G1 X127.445 Y143.149 E.56268
G1 X127.483 Y142.824 E.00974
G1 X127.649 Y142.734 E.0056
G1 X127.649 Y140.911 E.0543
G1 X108.163 Y143.25 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y143.25 E.06208
; WIPE_START
G1 X105.663 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y141.927 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y137.073 E.24736
; WIPE_START
G1 X102.75 Y139.073 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X105.75 Y133.75 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4469
G1 F3600
G1 X105.75 Y118.31 E.49271
G1 X106.141 Y118.25 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X106.141 Y117.859 E.01163
G1 X105.359 Y117.859 E.02326
G1 X105.359 Y134.141 E.48494
G1 X106.141 Y134.141 E.02326
G1 X106.141 Y118.31 E.47153
G1 X106.518 Y118.25 F30000
G1 F3600
G1 X106.518 Y117.482 E.02286
G1 X104.982 Y117.482 E.04573
G1 X104.982 Y134.518 E.50741
G1 X106.518 Y134.518 E.04573
G1 X106.518 Y118.31 E.48276
G1 X106.895 Y118.25 F30000
G1 F3600
G1 X106.895 Y117.105 E.03409
G1 X104.605 Y117.105 E.06819
G1 X104.605 Y134.895 E.52987
G1 X106.895 Y134.895 E.06819
G1 X106.895 Y118.31 E.49399
G1 X107.272 Y118.25 F30000
G1 F3600
G1 X107.272 Y116.728 E.04533
G1 X104.228 Y116.728 E.09065
G1 X104.228 Y135.272 E.55233
G1 X107.272 Y135.272 E.09065
G1 X107.272 Y118.31 E.50522
G1 X107.649 Y118.25 F30000
G1 F3600
G1 X107.649 Y116.351 E.05656
G1 X103.851 Y116.351 E.11311
G1 X103.851 Y135.649 E.5748
G1 X107.649 Y135.649 E.11311
G1 X107.649 Y118.31 E.51645
; WIPE_START
G1 X107.649 Y120.31 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108 Y115.755 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y111.744 E.15487
; WIPE_START
G1 X108 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.5 Y110 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y110 E.55165
G1 X126.895 Y110.395 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X126.895 Y109.637 E.02256
G1 X126.831 Y109.605 E.00212
G1 X109.127 Y109.605 E.52733
G1 X109.105 Y110.395 E.02352
G1 X126.835 Y110.395 E.52808
G1 X127.272 Y110.772 F30000
G1 F3600
G1 X127.272 Y109.448 E.03944
G1 X127.183 Y109.403 E.00297
G1 X127.124 Y109.228 E.0055
G1 X108.876 Y109.228 E.54353
G1 X108.817 Y109.403 E.0055
G1 X108.728 Y109.448 E.00296
G1 X108.728 Y110.772 E.03944
G1 X127.212 Y110.772 E.55055
G1 X127.649 Y111.149 F30000
G1 F3600
G1 X127.649 Y109.266 E.05609
G1 X127.483 Y109.176 E.0056
G1 X127.445 Y108.851 E.00974
G1 X108.555 Y108.851 E.56268
G1 X108.517 Y109.176 E.00974
G1 X108.351 Y109.266 E.0056
G1 X108.351 Y111.149 E.05609
G1 X127.589 Y111.149 E.57301
G1 X108.163 Y108.75 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y108.75 E.06208
; WIPE_START
G1 X105.663 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y110.073 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y114.927 E.24736
; WIPE_START
G1 X102.75 Y112.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X104.427 Y120.373 Z2.4 F30000
G1 X108 Y136.245 Z2.4
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y140.256 E.15487
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F4909.984
G1 X108 Y138.256 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 11/27
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
G17
G3 Z2.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X129.29 Y142.552
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y142.552 E.02708
G1 X128.448 Y136.448 E.19629
G1 X133.552 Y136.448 E.16413
G1 X133.552 Y142.552 E.19629
G1 X129.33 Y142.552 E.13577
G1 X128.855 Y141.71 F30000
G1 F3600
G1 X128.855 Y136.855 E.15612
G1 X133.145 Y136.855 E.13795
G1 X133.145 Y142.145 E.17011
G1 X128.855 Y142.145 E.13795
G1 X128.855 Y141.75 E.0127
M204 S250
G1 X129.29 Y141.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y141.71 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y142.959 E.04017
G1 X132.541 Y142.959 E.1447
G1 X132.541 Y143.541 E.01871
G1 X103.459 Y143.541 E.93516
G1 X103.459 Y142.959 E.01871
G1 X107.959 Y142.959 E.1447
G1 X107.959 Y140.459 E.08039
G1 X128.041 Y140.459 E.64576
G1 X128.041 Y141.67 E.03894
; WIPE_START
G1 X128.041 Y142.959 E-.48987
G1 X128.752 Y142.959 E-.27013
; WIPE_END
G1 E-.04 F1800
G1 X121.47 Y140.673 Z2.6 F30000
G1 X106.71 Y136.041 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X103.459 Y136.041 E.10454
G1 X103.459 Y115.959 E.64576
G1 X108.041 Y115.959 E.14733
G1 X108.041 Y136.041 E.64576
G1 X106.75 Y136.041 E.04151
; WIPE_START
G1 X104.75 Y136.041 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y140.052 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X108.448 Y140.052 E.02708
G1 X108.448 Y111.948 E.90373
G1 X127.552 Y111.948 E.61432
G1 X127.552 Y140.052 E.90373
G1 X109.33 Y140.052 E.58595
G1 X109.29 Y139.645 F30000
G1 F3600
G1 X108.855 Y139.645 E.01399
G1 X108.855 Y112.355 E.87755
G1 X127.145 Y112.355 E.58814
G1 X127.145 Y139.645 E.87755
G1 X109.33 Y139.645 E.57287
M204 S250
G1 X109.29 Y139.21 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.747 Y130.987 Z2.6 F30000
G1 X128.448 Y110.29 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y109.448 E.02708
G1 X133.552 Y109.448 E.16413
G1 X133.552 Y115.552 E.19629
G1 X128.448 Y115.552 E.16413
G1 X128.448 Y110.33 E.16792
G1 X129.29 Y109.855 F30000
G1 F3600
G1 X133.145 Y109.855 E.12396
G1 X133.145 Y115.145 E.17011
G1 X128.855 Y115.145 E.13795
G1 X128.855 Y109.855 E.17011
G1 X129.25 Y109.855 E.0127
M204 S250
G1 X129.29 Y110.29 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y110.29 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y111.541 E.04022
G1 X107.959 Y111.541 E.64576
G1 X107.959 Y109.041 E.08039
G1 X103.459 Y109.041 E.1447
G1 X103.459 Y108.459 E.01871
G1 X132.541 Y108.459 E.93516
G1 X132.541 Y109.041 E.01871
G1 X128.041 Y109.041 E.1447
G1 X128.041 Y110.25 E.03888
; WIPE_START
G1 X128.041 Y111.541 E-.49053
G1 X127.332 Y111.541 E-.26947
; WIPE_END
G1 E-.04 F1800
G1 X134.944 Y110.987 Z2.6 F30000
G1 X149.21 Y109.948 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X150.052 Y109.948 E.02708
G1 X150.052 Y120.052 E.32491
G1 X145.052 Y120.052 E.16078
G1 X145.052 Y131.948 E.38253
G1 X150.052 Y131.948 E.16078
G1 X150.052 Y142.052 E.32491
G1 X143.948 Y142.052 E.19629
G1 X143.948 Y133.052 E.28941
G1 X132.948 Y133.052 E.35372
G1 X132.948 Y118.948 E.45354
G1 X143.948 Y118.948 E.35372
G1 X143.948 Y109.948 E.28941
G1 X149.17 Y109.948 E.16792
G1 X149.21 Y110.355 F30000
G1 F3600
G1 X149.645 Y110.355 E.01399
G1 X149.645 Y119.645 E.29873
G1 X144.645 Y119.645 E.16078
G1 X144.645 Y132.355 E.40871
G1 X149.645 Y132.355 E.16078
G1 X149.645 Y141.645 E.29873
G1 X144.355 Y141.645 E.17011
G1 X144.355 Y132.645 E.28941
G1 X133.355 Y132.645 E.35372
G1 X133.355 Y119.355 E.42736
G1 X144.355 Y119.355 E.35372
G1 X144.355 Y110.355 E.28941
M73 P77 R6
G1 X149.17 Y110.355 E.15483
; WIPE_START
G1 X149.645 Y110.355 E-.1805
G1 X149.645 Y111.88 E-.5795
; WIPE_END
G1 E-.04 F1800
G1 X147.674 Y119.253 Z2.6 F30000
G1 X144.21 Y132.21 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X144.584 Y124.924 Z2.6 F30000
G1 X149.21 Y110.79 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.191 Y120.422 Z2.6 F30000
G1 X149.21 Y132.79 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.541 Y133.459 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X143.541 Y142.541 E.29204
G1 X133.959 Y142.541 E.30811
G1 X133.959 Y136.041 E.20902
G1 X127.959 Y136.041 E.19294
G1 X127.959 Y115.959 E.64576
G1 X133.959 Y115.959 E.19294
G1 X133.959 Y109.459 E.20902
G1 X143.541 Y109.459 E.30811
G1 X143.541 Y118.541 E.29204
G1 X132.541 Y118.541 E.35372
G1 X132.541 Y133.459 E.47972
G1 X143.501 Y133.459 E.35243
; WIPE_START
G1 X143.51 Y135.459 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.238 Y128.025 Z2.6 F30000
G1 X145.459 Y127.074 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X145.459 Y120.459 E.21272
G1 X150.459 Y120.459 E.16078
G1 X150.459 Y109.459 E.35372
G1 X152.541 Y109.459 E.06694
G1 X152.541 Y142.541 E1.06379
G1 X150.459 Y142.541 E.06694
G1 X150.459 Y131.541 E.35372
G1 X145.459 Y131.541 E.16078
G1 X145.459 Y127.114 E.14234
; WIPE_START
G1 X145.459 Y125.114 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.076 Y131.362 Z2.6 F30000
G1 X132.948 Y142.948 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X132.948 Y143.948 E.03216
G1 X103.052 Y143.948 E.96134
G1 X103.052 Y142.552 E.04489
G1 X107.552 Y142.552 E.1447
G1 X107.552 Y136.448 E.19629
G1 X103.052 Y136.448 E.1447
G1 X103.052 Y115.552 E.67194
G1 X107.552 Y115.552 E.1447
G1 X107.552 Y109.448 E.19629
G1 X103.052 Y109.448 E.1447
G1 X103.052 Y108.052 E.04489
G1 X132.948 Y108.052 E.96134
G1 X132.948 Y109.052 E.03216
G1 X152.948 Y109.052 E.64313
G1 X152.948 Y142.948 E1.08997
G1 X132.988 Y142.948 E.64184
G1 X133.355 Y143.355 F30000
G1 F3600
G1 X133.355 Y144.355 E.03216
G1 X102.645 Y144.355 E.98752
G1 X102.645 Y142.145 E.07107
G1 X107.145 Y142.145 E.1447
G1 X107.145 Y136.855 E.17011
G1 X102.645 Y136.855 E.1447
G1 X102.645 Y115.145 E.69812
G1 X107.145 Y115.145 E.1447
G1 X107.145 Y109.855 E.17011
G1 X102.645 Y109.855 E.1447
G1 X102.645 Y107.645 E.07107
G1 X133.355 Y107.645 E.98752
G1 X133.355 Y108.645 E.03216
G1 X153.355 Y108.645 E.64313
G1 X153.355 Y143.355 E1.11615
G1 X133.395 Y143.355 E.64184
; WIPE_START
G1 X133.355 Y144.355 E-.3803
G1 X132.356 Y144.355 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X127.765 Y138.257 Z2.6 F30000
G1 X106.71 Y110.29 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.694 Y119.922 Z2.6 F30000
G1 X106.71 Y141.71 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.323 Y142.242 Z2.6 F30000
G1 X133.79 Y143.79 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
G1 X132.791 Y144.79 E-.3797
; WIPE_END
M73 P78 R6
G1 E-.04 F1800
G1 X132.337 Y143.25 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y143.25 E.06208
; WIPE_START
G1 X129.837 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128 Y140.256 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y136.245 E.15488
; WIPE_START
G1 X128 Y138.245 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.368 Y140.236 Z2.6 F30000
G1 X143.745 Y142.5 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X150.256 Y142.5 E.2514
; WIPE_START
G1 X148.256 Y142.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.227 Y134.93 Z2.6 F30000
G1 X152.377 Y110.396 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42503
G1 F3600
G1 X151.774 Y109.792 E.02575
G1 X151.234 Y109.792 E.01631
G1 X152.208 Y110.766 E.04157
G1 X152.208 Y111.307 E.01631
G1 X150.792 Y109.891 E.06042
G1 X150.792 Y110.432 E.01631
G1 X152.208 Y111.847 E.06042
G1 X152.208 Y112.387 E.01631
G1 X150.792 Y110.972 E.06042
G1 X150.792 Y111.512 E.01631
G1 X152.208 Y112.928 E.06042
G1 X152.208 Y113.468 E.01631
G1 X150.792 Y112.053 E.06042
G1 X150.792 Y112.593 E.01631
G1 X152.208 Y114.009 E.06042
G1 X152.208 Y114.549 E.01631
G1 X150.792 Y113.134 E.06042
G1 X150.792 Y113.674 E.01631
G1 X152.208 Y115.089 E.06042
G1 X152.208 Y115.63 E.01631
G1 X150.792 Y114.214 E.06042
G1 X150.792 Y114.755 E.01631
G1 X152.208 Y116.17 E.06042
G1 X152.208 Y116.71 E.01631
G1 X150.792 Y115.295 E.06042
G1 X150.792 Y115.835 E.01631
G1 X152.208 Y117.251 E.06042
G1 X152.208 Y117.791 E.01631
G1 X150.792 Y116.376 E.06042
G1 X150.792 Y116.916 E.01631
G1 X152.208 Y118.332 E.06042
G1 X152.208 Y118.872 E.01631
G1 X150.792 Y117.457 E.06042
G1 X150.792 Y117.997 E.01631
G1 X152.208 Y119.412 E.06042
G1 X152.208 Y119.953 E.01631
G1 X150.792 Y118.537 E.06042
G1 X150.792 Y119.078 E.01631
G1 X152.208 Y120.493 E.06042
G1 X152.208 Y121.034 E.01631
G1 X150.792 Y119.618 E.06042
G1 X150.792 Y120.159 E.01631
G1 X152.208 Y121.574 E.06042
G1 X152.208 Y122.114 E.01631
G1 X150.792 Y120.699 E.06042
G1 X150.792 Y120.792 E.00282
G1 X150.345 Y120.792 E.01349
G1 X152.208 Y122.655 E.0795
G1 X152.208 Y123.195 E.01631
G1 X149.805 Y120.792 E.10257
G1 X149.264 Y120.792 E.01631
G1 X152.208 Y123.735 E.12564
G1 X152.208 Y124.276 E.01631
G1 X148.724 Y120.792 E.1487
G1 X148.184 Y120.792 E.01631
G1 X152.208 Y124.816 E.17177
G1 X152.208 Y125.357 E.01631
G1 X147.643 Y120.792 E.19484
G1 X147.103 Y120.792 E.01631
G1 X152.208 Y125.897 E.2179
G1 X152.208 Y126.437 E.01631
G1 X146.563 Y120.792 E.24097
G1 X146.022 Y120.792 E.01631
G1 X152.208 Y126.978 E.26404
G1 X152.208 Y127.518 E.01631
G1 X145.792 Y121.103 E.27385
G1 X145.792 Y121.643 E.01631
G1 X152.208 Y128.059 E.27385
G1 X152.208 Y128.599 E.01631
G1 X145.792 Y122.184 E.27385
G1 X145.792 Y122.724 E.01631
G1 X152.208 Y129.139 E.27385
G1 X152.208 Y129.68 E.01631
G1 X145.792 Y123.264 E.27385
G1 X145.792 Y123.805 E.01631
G1 X152.208 Y130.22 E.27385
G1 X152.208 Y130.76 E.01631
G1 X145.792 Y124.345 E.27385
G1 X145.792 Y124.885 E.01631
G1 X152.208 Y131.301 E.27385
G1 X152.208 Y131.841 E.01631
G1 X145.792 Y125.426 E.27385
G1 X145.792 Y125.966 E.01631
G1 X152.208 Y132.382 E.27385
G1 X152.208 Y132.922 E.01631
G1 X145.792 Y126.507 E.27385
G1 X145.792 Y127.047 E.01631
G1 X149.953 Y131.208 E.17761
G1 X149.413 Y131.208 E.01631
G1 X145.792 Y127.587 E.15454
G1 X145.792 Y128.128 E.01631
G1 X148.872 Y131.208 E.13147
G1 X148.332 Y131.208 E.01631
G1 X145.792 Y128.668 E.1084
G1 X145.792 Y129.209 E.01631
G1 X147.791 Y131.208 E.08534
G1 X147.251 Y131.208 E.01631
G1 X145.792 Y129.749 E.06227
G1 X145.792 Y130.289 E.01631
G1 X146.711 Y131.208 E.0392
G1 X146.17 Y131.208 E.01631
G1 X145.623 Y130.66 E.02338
; WIPE_START
G1 X146.17 Y131.208 E-.29432
G1 X146.711 Y131.208 E-.20534
G1 X146.226 Y130.723 E-.26034
; WIPE_END
G1 E-.04 F1800
G1 X150.623 Y131.877 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X152.208 Y133.462 E.06766
G1 X152.208 Y134.003 E.01631
G1 X150.792 Y132.587 E.06042
G1 X150.792 Y133.128 E.01631
G1 X152.208 Y134.543 E.06042
G1 X152.208 Y135.084 E.01631
G1 X150.792 Y133.668 E.06042
G1 X150.792 Y134.209 E.01631
G1 X152.208 Y135.624 E.06042
G1 X152.208 Y136.164 E.01631
G1 X150.792 Y134.749 E.06042
G1 X150.792 Y135.289 E.01631
G1 X152.208 Y136.705 E.06042
G1 X152.208 Y137.245 E.01631
G1 X150.792 Y135.83 E.06042
G1 X150.792 Y136.37 E.01631
G1 X152.208 Y137.786 E.06042
G1 X152.208 Y138.326 E.01631
G1 X150.792 Y136.91 E.06042
G1 X150.792 Y137.451 E.01631
G1 X152.208 Y138.866 E.06042
G1 X152.208 Y139.407 E.01631
G1 X150.792 Y137.991 E.06042
G1 X150.792 Y138.532 E.01631
G1 X152.208 Y139.947 E.06042
G1 X152.208 Y140.487 E.01631
G1 X150.792 Y139.072 E.06042
G1 X150.792 Y139.612 E.01631
G1 X152.208 Y141.028 E.06042
G1 X152.208 Y141.568 E.01631
G1 X150.792 Y140.153 E.06042
G1 X150.792 Y140.693 E.01631
G1 X152.208 Y142.109 E.06042
G1 X152.208 Y142.208 E.00299
G1 X151.766 Y142.208 E.01332
G1 X150.792 Y141.234 E.04158
G1 X150.792 Y141.774 E.01631
G1 X151.396 Y142.377 E.02576
; WIPE_START
G1 X150.792 Y141.774 E-.32429
G1 X150.792 Y141.234 E-.20535
G1 X151.221 Y141.662 E-.23037
; WIPE_END
G1 E-.04 F1800
G1 X150.992 Y134.033 Z2.6 F30000
G1 X150.256 Y109.5 Z2.6
M73 P79 R6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X143.745 Y109.5 E.2514
G1 X143.377 Y110.394 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42443
G1 F3600
G1 X142.775 Y109.792 E.02566
G1 X142.236 Y109.792 E.01626
G1 X143.208 Y110.764 E.04142
G1 X143.208 Y111.304 E.01626
G1 X141.696 Y109.792 E.06441
G1 X141.157 Y109.792 E.01626
G1 X143.208 Y111.843 E.08741
G1 X143.208 Y112.383 E.01626
M73 P79 R5
G1 X140.617 Y109.792 E.1104
G1 X140.078 Y109.792 E.01626
G1 X143.208 Y112.922 E.1334
G1 X143.208 Y113.462 E.01626
G1 X139.538 Y109.792 E.15639
G1 X138.999 Y109.792 E.01626
G1 X143.208 Y114.001 E.17939
G1 X143.208 Y114.541 E.01626
G1 X138.459 Y109.792 E.20238
G1 X137.92 Y109.792 E.01626
G1 X143.208 Y115.08 E.22538
G1 X143.208 Y115.62 E.01626
G1 X137.38 Y109.792 E.24837
G1 X136.84 Y109.792 E.01626
G1 X143.208 Y116.159 E.27137
G1 X143.208 Y116.699 E.01626
G1 X136.301 Y109.792 E.29436
G1 X135.761 Y109.792 E.01626
G1 X143.208 Y117.239 E.31736
G1 X143.208 Y117.778 E.01626
G1 X135.222 Y109.792 E.34035
G1 X134.682 Y109.792 E.01626
G1 X143.098 Y118.208 E.35866
G1 X142.558 Y118.208 E.01626
G1 X134.292 Y109.942 E.35229
G1 X134.292 Y110.481 E.01626
G1 X142.019 Y118.208 E.3293
G1 X141.479 Y118.208 E.01626
G1 X134.292 Y111.021 E.3063
G1 X134.292 Y111.56 E.01626
G1 X140.94 Y118.208 E.28331
G1 X140.4 Y118.208 E.01626
G1 X134.292 Y112.1 E.26031
G1 X134.292 Y112.639 E.01626
G1 X139.861 Y118.208 E.23732
G1 X139.321 Y118.208 E.01626
G1 X134.292 Y113.179 E.21432
G1 X134.292 Y113.719 E.01626
G1 X138.781 Y118.208 E.19133
G1 X138.242 Y118.208 E.01626
G1 X134.292 Y114.258 E.16833
G1 X134.292 Y114.798 E.01626
G1 X137.702 Y118.208 E.14534
G1 X137.163 Y118.208 E.01626
G1 X134.292 Y115.337 E.12234
G1 X134.292 Y115.877 E.01626
G1 X136.623 Y118.208 E.09935
G1 X136.084 Y118.208 E.01626
G1 X134.168 Y116.292 E.08163
G1 X133.629 Y116.292 E.01626
G1 X135.544 Y118.208 E.08163
G1 X135.005 Y118.208 E.01626
G1 X133.089 Y116.292 E.08163
G1 X132.55 Y116.292 E.01626
G1 X134.465 Y118.208 E.08163
G1 X133.926 Y118.208 E.01626
G1 X132.01 Y116.292 E.08163
G1 X131.471 Y116.292 E.01626
G1 X133.386 Y118.208 E.08163
G1 X132.847 Y118.208 E.01626
G1 X130.931 Y116.292 E.08163
G1 X130.392 Y116.292 E.01626
G1 X132.307 Y118.208 E.08163
G1 X132.208 Y118.208 E.00299
G1 X132.208 Y118.648 E.01327
G1 X129.852 Y116.292 E.1004
G1 X129.313 Y116.292 E.01626
G1 X132.208 Y119.187 E.12339
G1 X132.208 Y119.727 E.01626
G1 X128.773 Y116.292 E.14639
G1 X128.292 Y116.292 E.01449
G1 X128.292 Y116.351 E.00177
G1 X132.208 Y120.267 E.16687
G1 X132.208 Y120.806 E.01626
G1 X128.292 Y116.891 E.16687
G1 X128.292 Y117.43 E.01626
G1 X132.208 Y121.346 E.16687
G1 X132.208 Y121.885 E.01626
G1 X128.292 Y117.97 E.16687
G1 X128.292 Y118.509 E.01626
G1 X132.208 Y122.425 E.16687
G1 X132.208 Y122.964 E.01626
G1 X128.292 Y119.049 E.16687
G1 X128.292 Y119.588 E.01626
G1 X132.208 Y123.504 E.16687
G1 X132.208 Y124.043 E.01626
G1 X128.292 Y120.128 E.16687
G1 X128.292 Y120.667 E.01626
G1 X132.208 Y124.583 E.16687
G1 X132.208 Y125.122 E.01626
G1 X128.292 Y121.207 E.16687
G1 X128.292 Y121.746 E.01626
G1 X132.208 Y125.662 E.16687
G1 X132.208 Y126.201 E.01626
G1 X128.292 Y122.286 E.16687
G1 X128.292 Y122.826 E.01626
G1 X132.208 Y126.741 E.16687
G1 X132.208 Y127.28 E.01626
G1 X128.292 Y123.365 E.16687
G1 X128.292 Y123.905 E.01626
G1 X132.208 Y127.82 E.16687
G1 X132.208 Y128.36 E.01626
G1 X128.292 Y124.444 E.16687
G1 X128.292 Y124.984 E.01626
G1 X132.208 Y128.899 E.16687
G1 X132.208 Y129.439 E.01626
G1 X128.292 Y125.523 E.16687
G1 X128.292 Y126.063 E.01626
G1 X132.208 Y129.978 E.16687
G1 X132.208 Y130.518 E.01626
G1 X128.292 Y126.602 E.16687
G1 X128.292 Y127.142 E.01626
G1 X132.208 Y131.057 E.16687
G1 X132.208 Y131.597 E.01626
G1 X128.292 Y127.681 E.16687
G1 X128.292 Y128.221 E.01626
G1 X132.208 Y132.136 E.16687
G1 X132.208 Y132.676 E.01626
G1 X128.292 Y128.76 E.16687
G1 X128.292 Y129.3 E.01626
G1 X132.377 Y133.385 E.1741
; WIPE_START
G1 X130.963 Y131.971 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.523 Y133.02 Z2.6 F30000
G1 X142.866 Y133.623 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X143.208 Y133.964 E.01456
G1 X143.208 Y134.504 E.01626
G1 X142.496 Y133.792 E.03032
G1 X141.957 Y133.792 E.01626
G1 X143.208 Y135.043 E.05332
G1 X143.208 Y135.583 E.01626
G1 X141.417 Y133.792 E.07631
G1 X140.878 Y133.792 E.01626
G1 X143.208 Y136.122 E.09931
G1 X143.208 Y136.662 E.01626
G1 X140.338 Y133.792 E.1223
G1 X139.799 Y133.792 E.01626
G1 X143.208 Y137.201 E.1453
G1 X143.208 Y137.741 E.01626
G1 X139.259 Y133.792 E.16829
G1 X138.72 Y133.792 E.01626
G1 X143.208 Y138.28 E.19128
G1 X143.208 Y138.82 E.01626
G1 X138.18 Y133.792 E.21428
G1 X137.64 Y133.792 E.01626
G1 X143.208 Y139.36 E.23727
G1 X143.208 Y139.899 E.01626
G1 X137.101 Y133.792 E.26027
G1 X136.561 Y133.792 E.01626
G1 X143.208 Y140.439 E.28326
G1 X143.208 Y140.978 E.01626
G1 X136.022 Y133.792 E.30626
G1 X135.482 Y133.792 E.01626
G1 X143.208 Y141.518 E.32925
G1 X143.208 Y142.057 E.01626
G1 X134.943 Y133.792 E.35225
G1 X134.403 Y133.792 E.01626
G1 X142.819 Y142.208 E.35866
G1 X142.279 Y142.208 E.01626
G1 X133.864 Y133.792 E.35866
G1 X133.324 Y133.792 E.01626
G1 X141.74 Y142.208 E.35866
G1 X141.2 Y142.208 E.01626
G1 X132.615 Y133.623 E.36589
G1 X128.123 Y129.67 F30000
G1 F3600
G1 X140.66 Y142.208 E.53436
G1 X140.121 Y142.208 E.01626
G1 X134.292 Y136.379 E.24841
G1 X134.292 Y136.919 E.01626
G1 X139.581 Y142.208 E.22542
G1 X139.042 Y142.208 E.01626
G1 X134.292 Y137.458 E.20242
G1 X134.292 Y137.998 E.01626
G1 X138.502 Y142.208 E.17943
G1 X137.963 Y142.208 E.01626
G1 X134.292 Y138.537 E.15643
G1 X134.292 Y139.077 E.01626
G1 X137.423 Y142.208 E.13344
G1 X136.884 Y142.208 E.01626
G1 X134.292 Y139.616 E.11045
G1 X134.292 Y140.156 E.01626
G1 X136.344 Y142.208 E.08745
G1 X135.805 Y142.208 E.01626
G1 X134.292 Y140.695 E.06446
G1 X134.292 Y141.235 E.01626
G1 X135.265 Y142.208 E.04146
G1 X134.726 Y142.208 E.01626
G1 X134.123 Y141.605 E.0257
; WIPE_START
G1 X134.726 Y142.208 E-.32403
G1 X135.265 Y142.208 E-.20503
G1 X134.835 Y141.778 E-.23095
; WIPE_END
G1 E-.04 F1800
G1 X133.791 Y135.877 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X128.292 Y130.379 E.23434
G1 X128.292 Y130.919 E.01626
G1 X133.081 Y135.708 E.20411
G1 X132.542 Y135.708 E.01626
G1 X128.292 Y131.458 E.18112
G1 X128.292 Y131.998 E.01626
G1 X132.002 Y135.708 E.15812
G1 X131.463 Y135.708 E.01626
G1 X128.292 Y132.537 E.13513
G1 X128.292 Y133.077 E.01626
G1 X130.923 Y135.708 E.11213
G1 X130.384 Y135.708 E.01626
G1 X128.292 Y133.616 E.08914
G1 X128.292 Y134.156 E.01626
G1 X129.844 Y135.708 E.06614
G1 X129.305 Y135.708 E.01626
G1 X128.292 Y134.695 E.04315
G1 X128.292 Y135.235 E.01626
G1 X128.935 Y135.877 E.02738
; WIPE_START
G1 X128.292 Y135.235 E-.34528
G1 X128.292 Y134.695 E-.20503
G1 X128.682 Y135.086 E-.20969
; WIPE_END
G1 E-.04 F1800
G1 X128.413 Y127.458 Z2.6 F30000
G1 X128 Y115.755 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y111.744 E.15488
; WIPE_START
G1 X128 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.837 Y108.75 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X132.337 Y108.75 E.06208
G1 X109.5 Y110 F30000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y110 E.55165
G1 X126.895 Y110.395 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X126.895 Y109.637 E.02256
G1 X126.831 Y109.605 E.00212
G1 X109.127 Y109.605 E.52733
G1 X109.105 Y110.395 E.02352
G1 X126.835 Y110.395 E.52808
G1 X127.272 Y110.772 F30000
G1 F3600
G1 X127.272 Y109.448 E.03944
G1 X127.183 Y109.403 E.00297
G1 X127.124 Y109.228 E.0055
G1 X108.876 Y109.228 E.54353
G1 X108.817 Y109.403 E.0055
G1 X108.728 Y109.448 E.00296
G1 X108.728 Y110.772 E.03944
G1 X127.212 Y110.772 E.55055
G1 X127.649 Y111.149 F30000
G1 F3600
G1 X127.649 Y109.266 E.05609
G1 X127.483 Y109.176 E.0056
G1 X127.445 Y108.851 E.00974
G1 X108.555 Y108.851 E.56268
G1 X108.517 Y109.176 E.00974
G1 X108.351 Y109.266 E.0056
G1 X108.351 Y111.149 E.05609
G1 X127.589 Y111.149 E.57301
G1 X108.163 Y108.75 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y108.75 E.06208
; WIPE_START
G1 X105.663 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y110.073 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y114.927 E.24736
; WIPE_START
G1 X102.75 Y112.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108 Y115.755 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y111.744 E.15487
; WIPE_START
G1 X108 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X107.147 Y121.329 Z2.6 F30000
G1 X105.75 Y133.75 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4469
G1 F3600
G1 X105.75 Y118.31 E.49271
G1 X106.141 Y118.25 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X106.141 Y117.859 E.01163
G1 X105.359 Y117.859 E.02326
G1 X105.359 Y134.141 E.48494
G1 X106.141 Y134.141 E.02326
G1 X106.141 Y118.31 E.47153
G1 X106.518 Y118.25 F30000
G1 F3600
G1 X106.518 Y117.482 E.02286
G1 X104.982 Y117.482 E.04573
G1 X104.982 Y134.518 E.50741
G1 X106.518 Y134.518 E.04573
G1 X106.518 Y118.31 E.48276
G1 X106.895 Y118.25 F30000
G1 F3600
G1 X106.895 Y117.105 E.03409
G1 X104.605 Y117.105 E.06819
G1 X104.605 Y134.895 E.52987
G1 X106.895 Y134.895 E.06819
G1 X106.895 Y118.31 E.49399
G1 X107.272 Y118.25 F30000
G1 F3600
G1 X107.272 Y116.728 E.04533
G1 X104.228 Y116.728 E.09065
G1 X104.228 Y135.272 E.55233
G1 X107.272 Y135.272 E.09065
G1 X107.272 Y118.31 E.50522
G1 X107.649 Y118.25 F30000
G1 F3600
G1 X107.649 Y116.351 E.05656
G1 X103.851 Y116.351 E.11311
G1 X103.851 Y135.649 E.5748
G1 X107.649 Y135.649 E.11311
G1 X107.649 Y118.31 E.51645
; WIPE_START
G1 X107.649 Y120.31 E-.76
; WIPE_END
M73 P80 R5
G1 E-.04 F1800
G1 X107.817 Y127.941 Z2.6 F30000
G1 X108 Y136.245 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y140.256 E.15487
; WIPE_START
G1 X108 Y138.256 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.5 Y142 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y142 E.55165
G1 X126.895 Y141.605 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X109.105 Y141.605 E.52987
G1 X109.105 Y142.363 E.02256
G1 X109.169 Y142.395 E.00212
G1 X126.873 Y142.395 E.52733
G1 X126.895 Y141.665 E.02173
G1 X127.272 Y141.228 F30000
G1 F3600
G1 X108.728 Y141.228 E.55233
G1 X108.728 Y142.552 E.03944
G1 X108.817 Y142.597 E.00296
G1 X108.876 Y142.772 E.0055
G1 X127.124 Y142.772 E.54353
G1 X127.183 Y142.597 E.0055
G1 X127.272 Y142.552 E.00297
G1 X127.272 Y141.288 E.03765
G1 X127.649 Y140.851 F30000
G1 F3600
G1 X108.351 Y140.851 E.5748
G1 X108.351 Y142.749 E.05653
G1 X108.517 Y142.824 E.00541
G1 X108.555 Y143.149 E.00974
G1 X127.445 Y143.149 E.56268
G1 X127.483 Y142.824 E.00974
G1 X127.649 Y142.734 E.0056
G1 X127.649 Y140.911 E.0543
G1 X108.163 Y143.25 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y143.25 E.06208
; WIPE_START
G1 X105.663 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y141.927 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y137.073 E.24736
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3720.872
G1 X102.75 Y139.073 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 12/27
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
G17
G3 Z2.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X129.29 Y142.552
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y142.552 E.02708
G1 X128.448 Y136.448 E.19629
G1 X133.552 Y136.448 E.16413
G1 X133.552 Y142.552 E.19629
G1 X129.33 Y142.552 E.13577
G1 X128.855 Y141.71 F30000
G1 F3600
G1 X128.855 Y136.855 E.15612
G1 X133.145 Y136.855 E.13795
G1 X133.145 Y142.145 E.17011
G1 X128.855 Y142.145 E.13795
G1 X128.855 Y141.75 E.0127
M204 S250
G1 X129.29 Y141.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y141.71 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y142.959 E.04017
G1 X132.541 Y142.959 E.1447
G1 X132.541 Y143.541 E.01871
G1 X103.459 Y143.541 E.93516
G1 X103.459 Y142.959 E.01871
G1 X107.959 Y142.959 E.1447
G1 X107.959 Y140.459 E.08039
G1 X128.041 Y140.459 E.64576
G1 X128.041 Y141.67 E.03894
; WIPE_START
G1 X128.041 Y142.959 E-.48987
G1 X128.752 Y142.959 E-.27013
; WIPE_END
G1 E-.04 F1800
G1 X121.47 Y140.673 Z2.8 F30000
G1 X106.71 Y136.041 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X103.459 Y136.041 E.10454
G1 X103.459 Y115.959 E.64576
G1 X108.041 Y115.959 E.14733
G1 X108.041 Y136.041 E.64576
G1 X106.75 Y136.041 E.04151
; WIPE_START
G1 X104.75 Y136.041 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y140.052 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X108.448 Y140.052 E.02708
G1 X108.448 Y111.948 E.90373
G1 X127.552 Y111.948 E.61432
G1 X127.552 Y140.052 E.90373
G1 X109.33 Y140.052 E.58595
G1 X109.29 Y139.645 F30000
G1 F3600
G1 X108.855 Y139.645 E.01399
G1 X108.855 Y112.355 E.87755
G1 X127.145 Y112.355 E.58814
G1 X127.145 Y139.645 E.87755
G1 X109.33 Y139.645 E.57287
M204 S250
G1 X109.29 Y139.21 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X113.747 Y130.987 Z2.8 F30000
G1 X128.448 Y110.29 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.448 Y109.448 E.02708
G1 X133.552 Y109.448 E.16413
G1 X133.552 Y115.552 E.19629
G1 X128.448 Y115.552 E.16413
G1 X128.448 Y110.33 E.16792
G1 X129.29 Y109.855 F30000
G1 F3600
G1 X133.145 Y109.855 E.12396
G1 X133.145 Y115.145 E.17011
G1 X128.855 Y115.145 E.13795
G1 X128.855 Y109.855 E.17011
G1 X129.25 Y109.855 E.0127
M204 S250
G1 X129.29 Y110.29 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.041 Y110.29 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X128.041 Y111.541 E.04022
G1 X107.959 Y111.541 E.64576
G1 X107.959 Y109.041 E.08039
G1 X103.459 Y109.041 E.1447
G1 X103.459 Y108.459 E.01871
G1 X132.541 Y108.459 E.93516
G1 X132.541 Y109.041 E.01871
G1 X128.041 Y109.041 E.1447
G1 X128.041 Y110.25 E.03888
; WIPE_START
G1 X128.041 Y111.541 E-.49053
G1 X127.332 Y111.541 E-.26947
; WIPE_END
G1 E-.04 F1800
G1 X134.944 Y110.987 Z2.8 F30000
G1 X149.21 Y109.948 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X150.052 Y109.948 E.02708
G1 X150.052 Y120.052 E.32491
G1 X145.052 Y120.052 E.16078
G1 X145.052 Y131.948 E.38253
G1 X150.052 Y131.948 E.16078
G1 X150.052 Y142.052 E.32491
G1 X143.948 Y142.052 E.19629
G1 X143.948 Y133.052 E.28941
G1 X132.948 Y133.052 E.35372
G1 X132.948 Y118.948 E.45354
G1 X143.948 Y118.948 E.35372
G1 X143.948 Y109.948 E.28941
G1 X149.17 Y109.948 E.16792
G1 X149.21 Y110.355 F30000
G1 F3600
G1 X149.645 Y110.355 E.01399
G1 X149.645 Y119.645 E.29873
G1 X144.645 Y119.645 E.16078
G1 X144.645 Y132.355 E.40871
G1 X149.645 Y132.355 E.16078
G1 X149.645 Y141.645 E.29873
G1 X144.355 Y141.645 E.17011
G1 X144.355 Y132.645 E.28941
G1 X133.355 Y132.645 E.35372
G1 X133.355 Y119.355 E.42736
G1 X144.355 Y119.355 E.35372
G1 X144.355 Y110.355 E.28941
G1 X149.17 Y110.355 E.15483
; WIPE_START
G1 X149.645 Y110.355 E-.1805
G1 X149.645 Y111.88 E-.5795
; WIPE_END
G1 E-.04 F1800
G1 X147.674 Y119.253 Z2.8 F30000
G1 X144.21 Y132.21 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X144.584 Y124.924 Z2.8 F30000
M73 P81 R5
G1 X149.21 Y110.79 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.191 Y120.422 Z2.8 F30000
G1 X149.21 Y132.79 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X143.541 Y133.459 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X143.541 Y142.541 E.29204
G1 X133.959 Y142.541 E.30811
G1 X133.959 Y136.041 E.20902
G1 X127.959 Y136.041 E.19294
G1 X127.959 Y115.959 E.64576
G1 X133.959 Y115.959 E.19294
G1 X133.959 Y109.459 E.20902
G1 X143.541 Y109.459 E.30811
G1 X143.541 Y118.541 E.29204
G1 X132.541 Y118.541 E.35372
G1 X132.541 Y133.459 E.47972
G1 X143.501 Y133.459 E.35243
; WIPE_START
G1 X143.51 Y135.459 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X145.238 Y128.025 Z2.8 F30000
G1 X145.459 Y127.074 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X145.459 Y120.459 E.21272
G1 X150.459 Y120.459 E.16078
G1 X150.459 Y109.459 E.35372
G1 X152.541 Y109.459 E.06694
G1 X152.541 Y142.541 E1.06379
G1 X150.459 Y142.541 E.06694
G1 X150.459 Y131.541 E.35372
G1 X145.459 Y131.541 E.16078
G1 X145.459 Y127.114 E.14234
; WIPE_START
G1 X145.459 Y125.114 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.076 Y131.362 Z2.8 F30000
G1 X132.948 Y142.948 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X132.948 Y143.948 E.03216
G1 X103.052 Y143.948 E.96134
G1 X103.052 Y142.552 E.04489
G1 X107.552 Y142.552 E.1447
G1 X107.552 Y136.448 E.19629
G1 X103.052 Y136.448 E.1447
G1 X103.052 Y115.552 E.67194
G1 X107.552 Y115.552 E.1447
G1 X107.552 Y109.448 E.19629
G1 X103.052 Y109.448 E.1447
G1 X103.052 Y108.052 E.04489
G1 X132.948 Y108.052 E.96134
G1 X132.948 Y109.052 E.03216
G1 X152.948 Y109.052 E.64313
G1 X152.948 Y142.948 E1.08997
G1 X132.988 Y142.948 E.64184
G1 X133.355 Y143.355 F30000
G1 F3600
G1 X133.355 Y144.355 E.03216
G1 X102.645 Y144.355 E.98752
G1 X102.645 Y142.145 E.07107
G1 X107.145 Y142.145 E.1447
G1 X107.145 Y136.855 E.17011
G1 X102.645 Y136.855 E.1447
G1 X102.645 Y115.145 E.69812
G1 X107.145 Y115.145 E.1447
G1 X107.145 Y109.855 E.17011
G1 X102.645 Y109.855 E.1447
G1 X102.645 Y107.645 E.07107
G1 X133.355 Y107.645 E.98752
G1 X133.355 Y108.645 E.03216
G1 X153.355 Y108.645 E.64313
G1 X153.355 Y143.355 E1.11615
G1 X133.395 Y143.355 E.64184
; WIPE_START
G1 X133.355 Y144.355 E-.3803
G1 X132.356 Y144.355 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X127.765 Y138.257 Z2.8 F30000
G1 X106.71 Y110.29 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.694 Y119.922 Z2.8 F30000
G1 X106.71 Y141.71 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.323 Y142.242 Z2.8 F30000
G1 X133.79 Y143.79 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
G1 X132.791 Y144.79 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X132.337 Y143.25 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X127.837 Y143.25 E.06208
; WIPE_START
G1 X129.837 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128 Y140.256 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y136.245 E.15488
; WIPE_START
G1 X128 Y138.245 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.456 Y139.874 Z2.8 F30000
G1 X143.377 Y141.606 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42443
G1 F3600
G1 X142.775 Y142.208 E.02566
G1 X142.236 Y142.208 E.01626
G1 X143.208 Y141.236 E.04142
G1 X143.208 Y140.696 E.01626
G1 X141.696 Y142.208 E.06441
G1 X141.157 Y142.208 E.01626
G1 X143.208 Y140.157 E.08741
G1 X143.208 Y139.617 E.01626
G1 X140.617 Y142.208 E.1104
G1 X140.078 Y142.208 E.01626
M73 P82 R5
G1 X143.208 Y139.078 E.1334
G1 X143.208 Y138.538 E.01626
G1 X139.538 Y142.208 E.15639
G1 X138.999 Y142.208 E.01626
G1 X143.208 Y137.999 E.17939
G1 X143.208 Y137.459 E.01626
G1 X138.459 Y142.208 E.20238
G1 X137.92 Y142.208 E.01626
G1 X143.208 Y136.92 E.22538
G1 X143.208 Y136.38 E.01626
G1 X137.38 Y142.208 E.24837
G1 X136.84 Y142.208 E.01626
G1 X143.208 Y135.84 E.27137
G1 X143.208 Y135.301 E.01626
G1 X136.301 Y142.208 E.29436
G1 X135.761 Y142.208 E.01626
G1 X143.208 Y134.761 E.31736
G1 X143.208 Y134.222 E.01626
G1 X135.222 Y142.208 E.34035
G1 X134.682 Y142.208 E.01626
G1 X143.098 Y133.792 E.35866
G1 X142.558 Y133.792 E.01626
G1 X134.292 Y142.058 E.35229
G1 X134.292 Y141.519 E.01626
G1 X142.019 Y133.792 E.3293
G1 X141.479 Y133.792 E.01626
G1 X134.292 Y140.979 E.3063
G1 X134.292 Y140.44 E.01626
G1 X140.94 Y133.792 E.28331
G1 X140.4 Y133.792 E.01626
G1 X134.292 Y139.9 E.26031
G1 X134.292 Y139.361 E.01626
G1 X139.861 Y133.792 E.23732
G1 X139.321 Y133.792 E.01626
G1 X134.292 Y138.821 E.21432
G1 X134.292 Y138.281 E.01626
G1 X138.781 Y133.792 E.19133
G1 X138.242 Y133.792 E.01626
G1 X134.292 Y137.742 E.16833
G1 X134.292 Y137.202 E.01626
G1 X137.702 Y133.792 E.14534
G1 X137.163 Y133.792 E.01626
G1 X134.292 Y136.663 E.12234
G1 X134.292 Y136.123 E.01626
G1 X136.623 Y133.792 E.09935
G1 X136.084 Y133.792 E.01626
G1 X134.168 Y135.708 E.08163
G1 X133.629 Y135.708 E.01626
G1 X135.544 Y133.792 E.08163
G1 X135.005 Y133.792 E.01626
G1 X133.089 Y135.708 E.08163
G1 X132.55 Y135.708 E.01626
G1 X134.465 Y133.792 E.08163
G1 X133.926 Y133.792 E.01626
G1 X132.01 Y135.708 E.08163
G1 X131.471 Y135.708 E.01626
G1 X133.386 Y133.792 E.08163
G1 X132.847 Y133.792 E.01626
G1 X130.931 Y135.708 E.08163
G1 X130.392 Y135.708 E.01626
G1 X132.307 Y133.792 E.08163
G1 X132.208 Y133.792 E.00299
M73 P82 R4
G1 X132.208 Y133.352 E.01327
G1 X129.852 Y135.708 E.1004
G1 X129.313 Y135.708 E.01626
G1 X132.208 Y132.813 E.12339
G1 X132.208 Y132.273 E.01626
G1 X128.773 Y135.708 E.14639
G1 X128.292 Y135.708 E.01449
G1 X128.292 Y135.649 E.00177
G1 X132.208 Y131.733 E.16687
G1 X132.208 Y131.194 E.01626
G1 X128.292 Y135.109 E.16687
G1 X128.292 Y134.57 E.01626
G1 X132.208 Y130.654 E.16687
G1 X132.208 Y130.115 E.01626
G1 X128.292 Y134.03 E.16687
G1 X128.292 Y133.491 E.01626
G1 X132.208 Y129.575 E.16687
G1 X132.208 Y129.036 E.01626
G1 X128.292 Y132.951 E.16687
G1 X128.292 Y132.412 E.01626
G1 X132.208 Y128.496 E.16687
G1 X132.208 Y127.957 E.01626
G1 X128.292 Y131.872 E.16687
G1 X128.292 Y131.333 E.01626
G1 X132.208 Y127.417 E.16687
G1 X132.208 Y126.878 E.01626
G1 X128.292 Y130.793 E.16687
G1 X128.292 Y130.254 E.01626
G1 X132.208 Y126.338 E.16687
G1 X132.208 Y125.799 E.01626
G1 X128.292 Y129.714 E.16687
G1 X128.292 Y129.174 E.01626
G1 X132.208 Y125.259 E.16687
G1 X132.208 Y124.719 E.01626
G1 X128.292 Y128.635 E.16687
G1 X128.292 Y128.095 E.01626
G1 X132.208 Y124.18 E.16687
G1 X132.208 Y123.64 E.01626
G1 X128.292 Y127.556 E.16687
G1 X128.292 Y127.016 E.01626
G1 X132.208 Y123.101 E.16687
G1 X132.208 Y122.561 E.01626
G1 X128.292 Y126.477 E.16687
G1 X128.292 Y125.937 E.01626
G1 X132.208 Y122.022 E.16687
G1 X132.208 Y121.482 E.01626
G1 X128.292 Y125.398 E.16687
G1 X128.292 Y124.858 E.01626
G1 X132.208 Y120.943 E.16687
G1 X132.208 Y120.403 E.01626
G1 X128.292 Y124.319 E.16687
G1 X128.292 Y123.779 E.01626
G1 X132.208 Y119.864 E.16687
G1 X132.208 Y119.324 E.01626
G1 X128.292 Y123.24 E.16687
G1 X128.292 Y122.7 E.01626
G1 X132.377 Y118.615 E.1741
; WIPE_START
G1 X130.963 Y120.029 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.523 Y118.98 Z2.8 F30000
G1 X142.866 Y118.377 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X143.208 Y118.036 E.01456
G1 X143.208 Y117.496 E.01626
G1 X142.496 Y118.208 E.03032
G1 X141.957 Y118.208 E.01626
G1 X143.208 Y116.957 E.05332
G1 X143.208 Y116.417 E.01626
G1 X141.417 Y118.208 E.07631
G1 X140.878 Y118.208 E.01626
G1 X143.208 Y115.878 E.09931
G1 X143.208 Y115.338 E.01626
G1 X140.338 Y118.208 E.1223
G1 X139.799 Y118.208 E.01626
G1 X143.208 Y114.799 E.1453
G1 X143.208 Y114.259 E.01626
G1 X139.259 Y118.208 E.16829
G1 X138.72 Y118.208 E.01626
G1 X143.208 Y113.719 E.19129
G1 X143.208 Y113.18 E.01626
G1 X138.18 Y118.208 E.21428
G1 X137.64 Y118.208 E.01626
G1 X143.208 Y112.64 E.23727
G1 X143.208 Y112.101 E.01626
G1 X137.101 Y118.208 E.26027
G1 X136.561 Y118.208 E.01626
G1 X143.208 Y111.561 E.28326
G1 X143.208 Y111.022 E.01626
G1 X136.022 Y118.208 E.30626
G1 X135.482 Y118.208 E.01626
G1 X143.208 Y110.482 E.32925
G1 X143.208 Y109.943 E.01626
G1 X134.943 Y118.208 E.35225
G1 X134.403 Y118.208 E.01626
G1 X142.819 Y109.792 E.35866
G1 X142.279 Y109.792 E.01626
G1 X133.864 Y118.208 E.35866
G1 X133.324 Y118.208 E.01626
G1 X141.74 Y109.792 E.35866
G1 X141.2 Y109.792 E.01626
G1 X132.615 Y118.377 E.36589
G1 X128.123 Y122.33 F30000
G1 F3600
G1 X140.66 Y109.792 E.53436
G1 X140.121 Y109.792 E.01626
G1 X134.292 Y115.621 E.24841
G1 X134.292 Y115.081 E.01626
G1 X139.581 Y109.792 E.22542
G1 X139.042 Y109.792 E.01626
G1 X134.292 Y114.542 E.20242
G1 X134.292 Y114.002 E.01626
M73 P83 R4
G1 X138.502 Y109.792 E.17943
G1 X137.963 Y109.792 E.01626
G1 X134.292 Y113.463 E.15643
G1 X134.292 Y112.923 E.01626
G1 X137.423 Y109.792 E.13344
G1 X136.884 Y109.792 E.01626
G1 X134.292 Y112.384 E.11045
G1 X134.292 Y111.844 E.01626
G1 X136.344 Y109.792 E.08745
G1 X135.805 Y109.792 E.01626
G1 X134.292 Y111.305 E.06446
G1 X134.292 Y110.765 E.01626
G1 X135.265 Y109.792 E.04146
G1 X134.726 Y109.792 E.01626
G1 X134.123 Y110.395 E.0257
; WIPE_START
G1 X134.726 Y109.792 E-.32403
G1 X135.265 Y109.792 E-.20502
G1 X134.835 Y110.222 E-.23095
; WIPE_END
G1 E-.04 F1800
G1 X133.791 Y116.123 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X128.292 Y121.621 E.23434
G1 X128.292 Y121.081 E.01626
G1 X133.081 Y116.292 E.20411
G1 X132.542 Y116.292 E.01626
G1 X128.292 Y120.542 E.18112
G1 X128.292 Y120.002 E.01626
G1 X132.002 Y116.292 E.15812
G1 X131.463 Y116.292 E.01626
G1 X128.292 Y119.463 E.13513
G1 X128.292 Y118.923 E.01626
G1 X130.923 Y116.292 E.11213
G1 X130.384 Y116.292 E.01626
G1 X128.292 Y118.384 E.08914
G1 X128.292 Y117.844 E.01626
G1 X129.844 Y116.292 E.06614
G1 X129.305 Y116.292 E.01626
G1 X128.292 Y117.305 E.04315
G1 X128.292 Y116.765 E.01626
G1 X128.935 Y116.123 E.02738
; WIPE_START
G1 X128.292 Y116.765 E-.34528
G1 X128.292 Y117.305 E-.20503
G1 X128.682 Y116.914 E-.20969
; WIPE_END
G1 E-.04 F1800
G1 X128 Y115.755 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53174
G1 F4909.783
G1 X128 Y111.744 E.15488
; WIPE_START
G1 X128 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.837 Y108.75 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X132.337 Y108.75 E.06208
; WIPE_START
G1 X130.337 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.958 Y109.176 Z2.8 F30000
G1 X143.745 Y109.5 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X150.256 Y109.5 E.2514
; WIPE_START
G1 X148.256 Y109.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.227 Y117.07 Z2.8 F30000
G1 X152.377 Y141.604 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42503
G1 F3600
G1 X151.774 Y142.208 E.02575
G1 X151.234 Y142.208 E.01631
G1 X152.208 Y141.234 E.04158
G1 X152.208 Y140.693 E.01631
G1 X150.792 Y142.109 E.06042
G1 X150.792 Y141.568 E.01631
G1 X152.208 Y140.153 E.06042
G1 X152.208 Y139.613 E.01631
G1 X150.792 Y141.028 E.06042
G1 X150.792 Y140.488 E.01631
G1 X152.208 Y139.072 E.06042
G1 X152.208 Y138.532 E.01631
G1 X150.792 Y139.947 E.06042
G1 X150.792 Y139.407 E.01631
G1 X152.208 Y137.991 E.06042
G1 X152.208 Y137.451 E.01631
G1 X150.792 Y138.866 E.06042
G1 X150.792 Y138.326 E.01631
G1 X152.208 Y136.911 E.06042
G1 X152.208 Y136.37 E.01631
G1 X150.792 Y137.786 E.06042
G1 X150.792 Y137.245 E.01631
G1 X152.208 Y135.83 E.06042
G1 X152.208 Y135.29 E.01631
G1 X150.792 Y136.705 E.06042
G1 X150.792 Y136.165 E.01631
G1 X152.208 Y134.749 E.06042
G1 X152.208 Y134.209 E.01631
G1 X150.792 Y135.624 E.06042
G1 X150.792 Y135.084 E.01631
G1 X152.208 Y133.668 E.06042
G1 X152.208 Y133.128 E.01631
G1 X150.792 Y134.543 E.06042
G1 X150.792 Y134.003 E.01631
G1 X152.208 Y132.588 E.06042
G1 X152.208 Y132.047 E.01631
G1 X150.792 Y133.463 E.06042
G1 X150.792 Y132.922 E.01631
G1 X152.208 Y131.507 E.06042
G1 X152.208 Y130.966 E.01631
G1 X150.792 Y132.382 E.06042
G1 X150.792 Y131.841 E.01631
G1 X152.208 Y130.426 E.06042
G1 X152.208 Y129.886 E.01631
G1 X150.792 Y131.301 E.06042
G1 X150.792 Y131.208 E.00282
G1 X150.345 Y131.208 E.01349
G1 X152.208 Y129.345 E.0795
G1 X152.208 Y128.805 E.01631
G1 X149.805 Y131.208 E.10257
G1 X149.264 Y131.208 E.01631
G1 X152.208 Y128.264 E.12564
G1 X152.208 Y127.724 E.01631
G1 X148.724 Y131.208 E.1487
G1 X148.184 Y131.208 E.01631
G1 X152.208 Y127.184 E.17177
G1 X152.208 Y126.643 E.01631
G1 X147.643 Y131.208 E.19484
G1 X147.103 Y131.208 E.01631
G1 X152.208 Y126.103 E.2179
G1 X152.208 Y125.563 E.01631
G1 X146.563 Y131.208 E.24097
G1 X146.022 Y131.208 E.01631
G1 X152.208 Y125.022 E.26404
G1 X152.208 Y124.482 E.01631
G1 X145.792 Y130.897 E.27385
G1 X145.792 Y130.357 E.01631
G1 X152.208 Y123.941 E.27385
G1 X152.208 Y123.401 E.01631
G1 X145.792 Y129.816 E.27385
G1 X145.792 Y129.276 E.01631
G1 X152.208 Y122.861 E.27385
G1 X152.208 Y122.32 E.01631
G1 X145.792 Y128.736 E.27385
G1 X145.792 Y128.195 E.01631
G1 X152.208 Y121.78 E.27385
G1 X152.208 Y121.239 E.01631
G1 X145.792 Y127.655 E.27385
G1 X145.792 Y127.115 E.01631
G1 X152.208 Y120.699 E.27385
G1 X152.208 Y120.159 E.01631
G1 X145.792 Y126.574 E.27385
G1 X145.792 Y126.034 E.01631
G1 X152.208 Y119.618 E.27385
G1 X152.208 Y119.078 E.01631
G1 X145.792 Y125.493 E.27385
G1 X145.792 Y124.953 E.01631
G1 X149.953 Y120.792 E.17761
G1 X149.413 Y120.792 E.01631
G1 X145.792 Y124.413 E.15454
G1 X145.792 Y123.872 E.01631
G1 X148.872 Y120.792 E.13147
G1 X148.332 Y120.792 E.01631
G1 X145.792 Y123.332 E.1084
G1 X145.792 Y122.791 E.01631
G1 X147.791 Y120.792 E.08534
G1 X147.251 Y120.792 E.01631
G1 X145.792 Y122.251 E.06227
G1 X145.792 Y121.711 E.01631
G1 X146.711 Y120.792 E.0392
G1 X146.17 Y120.792 E.01631
G1 X145.623 Y121.34 E.02338
; WIPE_START
G1 X146.17 Y120.792 E-.29433
G1 X146.711 Y120.792 E-.20534
G1 X146.226 Y121.277 E-.26033
; WIPE_END
G1 E-.04 F1800
G1 X150.623 Y120.123 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X152.208 Y118.538 E.06766
G1 X152.208 Y117.997 E.01631
G1 X150.792 Y119.413 E.06042
G1 X150.792 Y118.872 E.01631
G1 X152.208 Y117.457 E.06042
G1 X152.208 Y116.916 E.01631
G1 X150.792 Y118.332 E.06042
G1 X150.792 Y117.791 E.01631
G1 X152.208 Y116.376 E.06042
G1 X152.208 Y115.836 E.01631
G1 X150.792 Y117.251 E.06042
G1 X150.792 Y116.711 E.01631
G1 X152.208 Y115.295 E.06042
G1 X152.208 Y114.755 E.01631
G1 X150.792 Y116.17 E.06042
G1 X150.792 Y115.63 E.01631
G1 X152.208 Y114.214 E.06042
G1 X152.208 Y113.674 E.01631
G1 X150.792 Y115.09 E.06042
G1 X150.792 Y114.549 E.01631
G1 X152.208 Y113.134 E.06042
G1 X152.208 Y112.593 E.01631
G1 X150.792 Y114.009 E.06042
G1 X150.792 Y113.468 E.01631
G1 X152.208 Y112.053 E.06042
G1 X152.208 Y111.513 E.01631
G1 X150.792 Y112.928 E.06042
G1 X150.792 Y112.388 E.01631
G1 X152.208 Y110.972 E.06042
G1 X152.208 Y110.432 E.01631
G1 X150.792 Y111.847 E.06042
G1 X150.792 Y111.307 E.01631
G1 X152.208 Y109.891 E.06042
G1 X152.208 Y109.792 E.00299
G1 X151.766 Y109.792 E.01332
G1 X150.792 Y110.766 E.04158
G1 X150.792 Y110.226 E.01631
G1 X151.396 Y109.623 E.02576
; WIPE_START
G1 X150.792 Y110.226 E-.32429
G1 X150.792 Y110.766 E-.20534
G1 X151.221 Y110.338 E-.23036
; WIPE_END
G1 E-.04 F1800
G1 X150.992 Y117.967 Z2.8 F30000
G1 X150.256 Y142.5 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X143.745 Y142.5 E.2514
; WIPE_START
G1 X145.745 Y142.5 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.113 Y142.395 Z2.8 F30000
G1 X109.5 Y142 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y142 E.55165
G1 X126.895 Y141.605 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X109.105 Y141.605 E.52987
G1 X109.105 Y142.363 E.02256
G1 X109.169 Y142.395 E.00212
G1 X126.873 Y142.395 E.52733
G1 X126.895 Y141.665 E.02173
G1 X127.272 Y141.228 F30000
G1 F3600
G1 X108.728 Y141.228 E.55233
G1 X108.728 Y142.552 E.03944
G1 X108.817 Y142.597 E.00296
G1 X108.876 Y142.772 E.0055
G1 X127.124 Y142.772 E.54353
G1 X127.183 Y142.597 E.0055
G1 X127.272 Y142.552 E.00297
G1 X127.272 Y141.288 E.03765
G1 X127.649 Y140.851 F30000
G1 F3600
G1 X108.351 Y140.851 E.5748
G1 X108.351 Y142.749 E.05653
G1 X108.517 Y142.824 E.00541
G1 X108.555 Y143.149 E.00974
G1 X127.445 Y143.149 E.56268
G1 X127.483 Y142.824 E.00974
G1 X127.649 Y142.734 E.0056
G1 X127.649 Y140.911 E.0543
G1 X108.163 Y143.25 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y143.25 E.06208
; WIPE_START
G1 X105.663 Y143.25 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X102.75 Y141.927 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y137.073 E.24736
; WIPE_START
G1 X102.75 Y139.073 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X105.75 Y133.75 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.4469
G1 F3600
G1 X105.75 Y118.31 E.49271
G1 X106.141 Y118.25 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X106.141 Y117.859 E.01163
G1 X105.359 Y117.859 E.02326
G1 X105.359 Y134.141 E.48494
G1 X106.141 Y134.141 E.02326
G1 X106.141 Y118.31 E.47153
G1 X106.518 Y118.25 F30000
G1 F3600
G1 X106.518 Y117.482 E.02286
G1 X104.982 Y117.482 E.04573
G1 X104.982 Y134.518 E.50741
G1 X106.518 Y134.518 E.04573
G1 X106.518 Y118.31 E.48276
G1 X106.895 Y118.25 F30000
G1 F3600
G1 X106.895 Y117.105 E.03409
G1 X104.605 Y117.105 E.06819
G1 X104.605 Y134.895 E.52987
G1 X106.895 Y134.895 E.06819
G1 X106.895 Y118.31 E.49399
G1 X107.272 Y118.25 F30000
G1 F3600
G1 X107.272 Y116.728 E.04533
G1 X104.228 Y116.728 E.09065
G1 X104.228 Y135.272 E.55233
G1 X107.272 Y135.272 E.09065
G1 X107.272 Y118.31 E.50522
G1 X107.649 Y118.25 F30000
G1 F3600
G1 X107.649 Y116.351 E.05656
G1 X103.851 Y116.351 E.11311
G1 X103.851 Y135.649 E.5748
G1 X107.649 Y135.649 E.11311
G1 X107.649 Y118.31 E.51645
; WIPE_START
G1 X107.649 Y120.31 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108 Y115.755 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y111.744 E.15487
; WIPE_START
G1 X108 Y113.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.5 Y110 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.45517
G1 F3600
G1 X126.44 Y110 E.55165
G1 X126.895 Y110.395 F30000
; LINE_WIDTH: 0.41999
G1 F3600
G1 X126.895 Y109.637 E.02256
G1 X126.831 Y109.605 E.00212
G1 X109.127 Y109.605 E.52733
G1 X109.105 Y110.395 E.02352
G1 X126.835 Y110.395 E.52808
G1 X127.272 Y110.772 F30000
G1 F3600
G1 X127.272 Y109.448 E.03944
G1 X127.183 Y109.403 E.00297
G1 X127.124 Y109.228 E.0055
G1 X108.876 Y109.228 E.54353
G1 X108.817 Y109.403 E.0055
G1 X108.728 Y109.448 E.00296
G1 X108.728 Y110.772 E.03944
G1 X127.212 Y110.772 E.55055
G1 X127.649 Y111.149 F30000
G1 F3600
G1 X127.649 Y109.266 E.05609
G1 X127.483 Y109.176 E.0056
G1 X127.445 Y108.851 E.00974
G1 X108.555 Y108.851 E.56268
G1 X108.517 Y109.176 E.00974
G1 X108.351 Y109.266 E.0056
G1 X108.351 Y111.149 E.05609
G1 X127.589 Y111.149 E.57301
G1 X108.163 Y108.75 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21758
G1 F13740.983
G1 X103.663 Y108.75 E.06208
; WIPE_START
G1 X105.663 Y108.75 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P84 R4
G1 X102.75 Y110.073 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.68793
G1 F3720.872
G1 X102.75 Y114.927 E.24736
; WIPE_START
G1 X102.75 Y112.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X104.427 Y120.373 Z2.8 F30000
G1 X108 Y136.245 Z2.8
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.53172
G1 F4909.984
G1 X108 Y140.256 E.15487
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F4909.984
G1 X108 Y138.256 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 13/27
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
G17
G3 Z2.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X144.21 Y132.21
G1 Z2.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.79 Y132.21 E.31038
G1 X133.79 Y119.79 E.36995
G1 X144.21 Y119.79 E.31038
G1 X144.21 Y132.17 E.36876
; WIPE_START
M204 S10000
G1 X142.21 Y132.178 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.33 Y125.605 Z3 F30000
G1 X129.29 Y110.29 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X132.71 Y110.29 E.10187
G1 X132.71 Y114.71 E.13166
G1 X129.29 Y114.71 E.10187
G1 X129.29 Y110.33 E.13046
; WIPE_START
M204 S10000
G1 X131.29 Y110.307 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X138.92 Y110.512 Z3 F30000
G1 X149.21 Y110.79 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y119.21 E.2508
G1 X144.79 Y119.21 E.13166
G1 X144.79 Y110.79 E.2508
G1 X149.17 Y110.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y112.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X149.191 Y120.422 Z3 F30000
G1 X149.21 Y132.79 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X149.21 Y141.21 E.2508
G1 X144.79 Y141.21 E.13166
G1 X144.79 Y132.79 E.2508
G1 X149.17 Y132.79 E.13046
; WIPE_START
M204 S10000
G1 X149.179 Y134.79 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X141.971 Y137.298 Z3 F30000
G1 X129.29 Y141.71 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X129.29 Y137.29 E.13166
G1 X132.71 Y137.29 E.10187
G1 X132.71 Y141.71 E.13166
G1 X129.33 Y141.71 E.10068
; WIPE_START
M204 S10000
G1 X129.312 Y139.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X121.709 Y140.383 Z3 F30000
G1 X106.71 Y141.71 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X103.29 Y141.71 E.10187
G1 X103.29 Y137.29 E.13166
G1 X106.71 Y137.29 E.10187
G1 X106.71 Y141.67 E.13046
; WIPE_START
M204 S10000
G1 X104.71 Y141.693 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X109.29 Y139.21 Z3 F30000
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X109.29 Y112.79 E.78696
G1 X126.71 Y112.79 E.51888
G1 X126.71 Y139.21 E.78696
G1 X109.33 Y139.21 E.51769
; WIPE_START
M204 S10000
G1 X109.327 Y137.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108.588 Y129.613 Z3 F30000
G1 X106.71 Y110.29 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X106.71 Y114.71 E.13166
G1 X103.29 Y114.71 E.10187
G1 X103.29 Y110.29 E.13166
G1 X106.67 Y110.29 E.10068
; WIPE_START
M204 S10000
G1 X106.688 Y112.29 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X111.666 Y118.076 Z3 F30000
G1 X133.79 Y143.79 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.79 Y144.79 E.02979
G1 X102.21 Y144.79 E.94066
G1 X102.21 Y107.21 E1.11938
G1 X133.79 Y107.21 E.94066
G1 X133.79 Y108.21 E.02979
G1 X153.79 Y108.21 E.59573
G1 X153.79 Y143.79 E1.05981
G1 X133.83 Y143.79 E.59454
; WIPE_START
M204 S10000
G1 X133.79 Y144.79 E-.3803
G1 X132.791 Y144.79 E-.3797
; WIPE_END
G1 E-.04 F1800
G1 X129.008 Y144.532 Z3 F30000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.12374
G1 F15000
G1 X106.992 Y144.532 E.14056
; WIPE_START
G1 X108.992 Y144.532 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X108.58 Y136.911 Z3 F30000
G1 X106.992 Y107.468 Z3
G1 Z2.6
G1 E.8 F1800
G1 F15000
G1 X129.008 Y107.468 E.14056
; WIPE_START
G1 X127.008 Y107.468 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.583 Y107.853 Z3 F30000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F2400
M204 S2000
G1 X133.147 Y107.417 E.01834
G1 X132.614 Y107.417
G1 X133.583 Y108.386 E.0408
; WIPE_START
M204 S10000
G1 X132.614 Y107.417 E-.52053
G1 X133.147 Y107.417 E-.20264
G1 X133.216 Y107.486 E-.03684
; WIPE_END
G1 E-.04 F1800
G1 X140.822 Y108.122 Z3 F30000
G1 X153.583 Y109.189 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S2000
G1 X152.811 Y108.417 E.03249
G1 X152.278 Y108.417
G1 X153.583 Y109.722 E.05495
G1 X153.583 Y110.255
G1 X151.745 Y108.417 E.07742
G1 X151.212 Y108.417
G1 X153.583 Y110.788 E.09988
G1 X153.583 Y111.322
G1 X150.678 Y108.417 E.12234
G1 X150.145 Y108.417
G1 X153.583 Y111.855 E.14481
G1 X153.583 Y112.388
G1 X149.612 Y108.417 E.16727
G1 X149.078 Y108.417
G1 X153.583 Y112.922 E.18973
G1 X153.583 Y113.455
G1 X148.545 Y108.417 E.2122
G1 X148.012 Y108.417
G1 X153.583 Y113.988 E.23466
G1 X153.583 Y114.521
G1 X147.479 Y108.417 E.25712
G1 X146.945 Y108.417
G1 X149.111 Y110.583 E.09121
G1 X148.577 Y110.583
G1 X146.412 Y108.417 E.09121
G1 X145.879 Y108.417
G1 X148.044 Y110.583 E.09121
G1 X147.511 Y110.583
G1 X145.346 Y108.417 E.09121
G1 X144.812 Y108.417
G1 X146.978 Y110.583 E.09121
G1 X146.444 Y110.583
G1 X144.279 Y108.417 E.09121
G1 X143.746 Y108.417
G1 X145.911 Y110.583 E.09121
G1 X145.378 Y110.583
G1 X143.213 Y108.417 E.09121
G1 X142.679 Y108.417
G1 X144.845 Y110.583 E.09121
G1 X144.583 Y110.854
G1 X142.146 Y108.417 E.10264
G1 X141.613 Y108.417
G1 X144.583 Y111.387 E.1251
G1 X144.583 Y111.92
G1 X141.08 Y108.417 E.14756
G1 X140.546 Y108.417
G1 X144.583 Y112.454 E.17003
G1 X144.583 Y112.987
G1 X140.013 Y108.417 E.19249
G1 X139.48 Y108.417
G1 X144.583 Y113.52 E.21495
G1 X144.583 Y114.053
G1 X138.947 Y108.417 E.23742
G1 X138.413 Y108.417
G1 X144.583 Y114.587 E.25988
G1 X144.583 Y115.12
G1 X137.88 Y108.417 E.28234
G1 X137.347 Y108.417
G1 X144.583 Y115.653 E.30481
M73 P85 R4
G1 X144.583 Y116.186
G1 X136.814 Y108.417 E.32727
G1 X136.28 Y108.417
G1 X144.583 Y116.72 E.34973
G1 X144.583 Y117.253
G1 X135.747 Y108.417 E.37219
G1 X135.214 Y108.417
G1 X144.583 Y117.786 E.39466
G1 X144.583 Y118.319
G1 X134.681 Y108.417 E.41712
G1 X134.147 Y108.417
G1 X144.583 Y118.853 E.43958
G1 X144.583 Y119.386
G1 X133.614 Y108.417 E.46205
; WIPE_START
M204 S10000
G1 X135.028 Y109.832 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X132.081 Y107.417 Z3 F30000
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S2000
G1 X144.246 Y119.583 E.51246
G1 X143.713 Y119.583
G1 X131.548 Y107.417 E.51246
G1 X131.014 Y107.417
G1 X143.179 Y119.583 E.51246
G1 X142.646 Y119.583
G1 X130.481 Y107.417 E.51246
G1 X129.948 Y107.417
G1 X132.613 Y110.083 E.11227
G1 X132.08 Y110.083
G1 X129.414 Y107.417 E.11227
G1 X129.02 Y107.556
G1 X131.546 Y110.083 E.10642
G1 X131.013 Y110.083
G1 X128.487 Y107.556 E.10642
G1 X127.954 Y107.556
G1 X130.48 Y110.083 E.10642
G1 X129.947 Y110.083
G1 X127.42 Y107.556 E.10642
G1 X126.887 Y107.556
G1 X129.413 Y110.083 E.10642
G1 X129.083 Y110.285
G1 X126.354 Y107.556 E.11495
G1 X125.821 Y107.556
G1 X129.083 Y110.818 E.13741
G1 X129.083 Y111.352
G1 X125.287 Y107.556 E.15988
G1 X124.754 Y107.556
G1 X129.083 Y111.885 E.18234
G1 X129.083 Y112.418
G1 X124.221 Y107.556 E.2048
G1 X123.687 Y107.556
G1 X129.083 Y112.951 E.22727
G1 X129.083 Y113.485
G1 X123.154 Y107.556 E.24973
G1 X122.621 Y107.556
G1 X129.083 Y114.018 E.27219
G1 X129.083 Y114.551
G1 X122.088 Y107.556 E.29466
G1 X121.554 Y107.556
G1 X126.581 Y112.583 E.21173
G1 X126.048 Y112.583
G1 X121.021 Y107.556 E.21173
G1 X120.488 Y107.556
G1 X125.514 Y112.583 E.21173
G1 X124.981 Y112.583
G1 X119.955 Y107.556 E.21173
G1 X119.421 Y107.556
G1 X124.448 Y112.583 E.21173
G1 X123.915 Y112.583
G1 X118.888 Y107.556 E.21173
G1 X118.355 Y107.556
G1 X123.381 Y112.583 E.21173
G1 X122.848 Y112.583
G1 X117.822 Y107.556 E.21173
G1 X117.288 Y107.556
G1 X122.315 Y112.583 E.21173
G1 X121.782 Y112.583
G1 X116.755 Y107.556 E.21173
G1 X116.222 Y107.556
G1 X121.248 Y112.583 E.21173
G1 X120.715 Y112.583
G1 X115.689 Y107.556 E.21173
G1 X115.155 Y107.556
G1 X120.182 Y112.583 E.21173
G1 X119.648 Y112.583
G1 X114.622 Y107.556 E.21173
G1 X114.089 Y107.556
G1 X119.115 Y112.583 E.21173
G1 X118.582 Y112.583
G1 X113.556 Y107.556 E.21173
G1 X113.022 Y107.556
G1 X118.049 Y112.583 E.21173
G1 X117.515 Y112.583
G1 X112.489 Y107.556 E.21173
G1 X111.956 Y107.556
G1 X116.982 Y112.583 E.21173
G1 X116.449 Y112.583
G1 X111.423 Y107.556 E.21173
G1 X110.889 Y107.556
G1 X115.916 Y112.583 E.21173
G1 X115.382 Y112.583
G1 X110.356 Y107.556 E.21173
G1 X109.823 Y107.556
G1 X114.849 Y112.583 E.21173
G1 X114.316 Y112.583
G1 X109.29 Y107.556 E.21173
G1 X108.756 Y107.556
G1 X113.783 Y112.583 E.21173
G1 X113.249 Y112.583
G1 X108.223 Y107.556 E.21173
G1 X107.69 Y107.556
G1 X112.716 Y112.583 E.21173
G1 X112.183 Y112.583
G1 X107.157 Y107.556 E.21173
G1 X106.484 Y107.417
G1 X111.65 Y112.583 E.21758
G1 X111.116 Y112.583
G1 X105.951 Y107.417 E.21758
G1 X105.418 Y107.417
G1 X110.583 Y112.583 E.21758
G1 X110.05 Y112.583
G1 X104.885 Y107.417 E.21758
G1 X104.351 Y107.417
G1 X109.517 Y112.583 E.21758
G1 X109.083 Y112.682
G1 X106.917 Y110.517 E.09121
G1 X106.917 Y111.05
G1 X109.083 Y113.215 E.09121
G1 X109.083 Y113.748
G1 X106.917 Y111.583 E.09121
G1 X106.917 Y112.116
G1 X109.083 Y114.282 E.09121
G1 X109.083 Y114.815
G1 X106.917 Y112.65 E.09121
G1 X106.917 Y113.183
G1 X109.083 Y115.348 E.09121
G1 X109.083 Y115.881
G1 X106.917 Y113.716 E.09121
G1 X106.917 Y114.249
G1 X109.083 Y116.415 E.09121
G1 X109.083 Y116.948
G1 X106.917 Y114.783 E.09121
G1 X106.519 Y114.917
G1 X109.083 Y117.481 E.108
G1 X109.083 Y118.014
G1 X105.986 Y114.917 E.13046
G1 X105.452 Y114.917
G1 X109.083 Y118.548 E.15293
G1 X109.083 Y119.081
G1 X104.919 Y114.917 E.17539
G1 X104.386 Y114.917
G1 X109.083 Y119.614 E.19785
G1 X109.083 Y120.147
G1 X103.853 Y114.917 E.22032
G1 X103.319 Y114.917
G1 X109.083 Y120.681 E.24278
; WIPE_START
M204 S10000
G1 X107.668 Y119.267 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.692 Y111.697 Z3 F30000
G1 X106.483 Y110.083 Z3
G1 Z2.6
G1 E.8 F1800
M73 P86 R4
G1 F2400
M204 S2000
G1 X103.818 Y107.417 E.11227
G1 X103.285 Y107.417
G1 X105.95 Y110.083 E.11227
G1 X105.417 Y110.083
G1 X102.752 Y107.417 E.11227
G1 X102.417 Y107.616
G1 X104.884 Y110.083 E.10389
M73 P86 R3
G1 X104.35 Y110.083
G1 X102.417 Y108.15 E.08142
G1 X102.417 Y108.683
G1 X103.817 Y110.083 E.05896
G1 X103.284 Y110.083
G1 X102.417 Y109.216 E.0365
G1 X102.417 Y109.749
G1 X103.083 Y110.415 E.02802
G1 X103.083 Y110.948
G1 X102.417 Y110.283 E.02802
G1 X102.417 Y110.816
G1 X103.083 Y111.481 E.02802
G1 X103.083 Y112.014
G1 X102.417 Y111.349 E.02802
G1 X102.417 Y111.882
G1 X103.083 Y112.548 E.02802
G1 X103.083 Y113.081
G1 X102.417 Y112.416 E.02802
G1 X102.417 Y112.949
G1 X103.083 Y113.614 E.02802
G1 X103.083 Y114.147
G1 X102.417 Y113.482 E.02802
G1 X102.417 Y114.016
G1 X103.083 Y114.681 E.02802
G1 X102.417 Y114.549
G1 X109.083 Y121.214 E.28077
G1 X109.083 Y121.747
G1 X102.417 Y115.082 E.28077
G1 X102.417 Y115.615
G1 X109.083 Y122.281 E.28077
G1 X109.083 Y122.814
G1 X102.417 Y116.149 E.28077
G1 X102.417 Y116.682
G1 X109.083 Y123.347 E.28077
G1 X109.083 Y123.88
G1 X102.417 Y117.215 E.28077
G1 X102.417 Y117.748
G1 X109.083 Y124.414 E.28077
G1 X109.083 Y124.947
G1 X102.417 Y118.282 E.28077
G1 X102.417 Y118.815
G1 X109.083 Y125.48 E.28077
G1 X109.083 Y126.013
G1 X102.417 Y119.348 E.28077
G1 X102.417 Y119.881
G1 X109.083 Y126.547 E.28077
G1 X109.083 Y127.08
G1 X102.417 Y120.415 E.28077
G1 X102.417 Y120.948
G1 X109.083 Y127.613 E.28077
G1 X109.083 Y128.146
G1 X102.417 Y121.481 E.28077
G1 X102.417 Y122.014
G1 X109.083 Y128.68 E.28077
G1 X109.083 Y129.213
G1 X102.417 Y122.548 E.28077
G1 X102.417 Y123.081
G1 X109.083 Y129.746 E.28077
G1 X109.083 Y130.279
G1 X102.417 Y123.614 E.28077
G1 X102.417 Y124.147
G1 X109.083 Y130.813 E.28077
G1 X109.083 Y131.346
G1 X102.417 Y124.681 E.28077
G1 X102.417 Y125.214
G1 X109.083 Y131.879 E.28077
G1 X109.083 Y132.412
G1 X102.417 Y125.747 E.28077
G1 X102.417 Y126.28
G1 X109.083 Y132.946 E.28077
G1 X109.083 Y133.479
G1 X102.417 Y126.814 E.28077
G1 X102.417 Y127.347
G1 X109.083 Y134.012 E.28077
G1 X109.083 Y134.545
G1 X102.417 Y127.88 E.28077
G1 X102.417 Y128.413
G1 X109.083 Y135.079 E.28077
G1 X109.083 Y135.612
G1 X102.417 Y128.947 E.28077
G1 X102.417 Y129.48
G1 X109.083 Y136.145 E.28077
G1 X109.083 Y136.678
G1 X102.417 Y130.013 E.28077
G1 X102.417 Y130.546
G1 X109.083 Y137.212 E.28077
G1 X109.083 Y137.745
G1 X102.417 Y131.08 E.28077
G1 X102.417 Y131.613
G1 X109.083 Y138.278 E.28077
G1 X109.083 Y138.811
G1 X102.417 Y132.146 E.28077
G1 X102.417 Y132.68
G1 X106.82 Y137.083 E.18548
G1 X106.287 Y137.083
G1 X102.417 Y133.213 E.16302
G1 X102.417 Y133.746
G1 X105.754 Y137.083 E.14055
G1 X105.221 Y137.083
G1 X102.417 Y134.279 E.11809
G1 X102.417 Y134.813
G1 X104.687 Y137.083 E.09563
G1 X104.154 Y137.083
G1 X102.417 Y135.346 E.07316
G1 X102.417 Y135.879
G1 X103.621 Y137.083 E.0507
G1 X103.088 Y137.083
G1 X102.417 Y136.412 E.02824
G1 X102.417 Y136.946
G1 X103.083 Y137.611 E.02802
G1 X103.083 Y138.144
G1 X102.417 Y137.479 E.02802
G1 X102.417 Y138.012
G1 X103.083 Y138.677 E.02802
G1 X103.083 Y139.211
G1 X102.417 Y138.545 E.02802
G1 X102.417 Y139.079
G1 X103.083 Y139.744 E.02802
G1 X103.083 Y140.277
G1 X102.417 Y139.612 E.02802
G1 X102.417 Y140.145
G1 X103.083 Y140.81 E.02802
G1 X103.083 Y141.344
G1 X102.417 Y140.678 E.02802
G1 X102.417 Y141.212
G1 X103.083 Y141.877 E.02802
; WIPE_START
M204 S10000
G1 X102.417 Y141.212 E-.3575
G1 X102.417 Y140.678 E-.20264
G1 X102.789 Y141.05 E-.19987
; WIPE_END
G1 E-.04 F1800
G1 X106.917 Y137.18 Z3 F30000
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S2000
G1 X109.083 Y139.345 E.09121
; WIPE_START
M204 S10000
G1 X107.668 Y137.931 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X112.826 Y132.304 Z3 F30000
G1 X132.917 Y110.387 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S2000
G1 X142.113 Y119.583 E.38736
G1 X141.58 Y119.583
G1 X132.917 Y110.92 E.3649
G1 X132.917 Y111.454
G1 X141.046 Y119.583 E.34243
G1 X140.513 Y119.583
G1 X132.917 Y111.987 E.31997
G1 X132.917 Y112.52
G1 X139.98 Y119.583 E.29751
G1 X139.447 Y119.583
G1 X132.917 Y113.053 E.27504
G1 X132.917 Y113.587
G1 X138.913 Y119.583 E.25258
G1 X138.38 Y119.583
G1 X132.917 Y114.12 E.23012
G1 X132.917 Y114.653
G1 X137.847 Y119.583 E.20765
G1 X137.314 Y119.583
G1 X132.648 Y114.917 E.19652
G1 X132.115 Y114.917
G1 X136.78 Y119.583 E.19652
G1 X136.247 Y119.583
G1 X131.582 Y114.917 E.19652
G1 X131.049 Y114.917
G1 X135.714 Y119.583 E.19652
G1 X135.181 Y119.583
G1 X130.515 Y114.917 E.19652
G1 X129.982 Y114.917
G1 X134.647 Y119.583 E.19652
G1 X134.114 Y119.583
G1 X129.449 Y114.917 E.19652
; WIPE_START
M204 S10000
G1 X130.863 Y116.332 E-.76
; WIPE_END
M73 P87 R3
G1 E-.04 F1800
G1 X126.917 Y112.919 Z3 F30000
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S2000
G1 X133.583 Y119.584 E.28077
G1 X133.583 Y120.118
G1 X126.917 Y113.452 E.28077
G1 X126.917 Y113.986
G1 X133.583 Y120.651 E.28077
G1 X133.583 Y121.184
G1 X126.917 Y114.519 E.28077
G1 X126.917 Y115.052
G1 X133.583 Y121.717 E.28077
G1 X133.583 Y122.251
G1 X126.917 Y115.585 E.28077
G1 X126.917 Y116.119
G1 X133.583 Y122.784 E.28077
G1 X133.583 Y123.317
G1 X126.917 Y116.652 E.28077
G1 X126.917 Y117.185
G1 X133.583 Y123.85 E.28077
G1 X133.583 Y124.384
G1 X126.917 Y117.718 E.28077
G1 X126.917 Y118.252
G1 X133.583 Y124.917 E.28077
G1 X133.583 Y125.45
G1 X126.917 Y118.785 E.28077
G1 X126.917 Y119.318
G1 X133.583 Y125.983 E.28077
G1 X133.583 Y126.517
G1 X126.917 Y119.851 E.28077
G1 X126.917 Y120.385
G1 X133.583 Y127.05 E.28077
G1 X133.583 Y127.583
G1 X126.917 Y120.918 E.28077
G1 X126.917 Y121.451
G1 X133.583 Y128.117 E.28077
G1 X133.583 Y128.65
G1 X126.917 Y121.985 E.28077
G1 X126.917 Y122.518
G1 X133.583 Y129.183 E.28077
G1 X133.583 Y129.716
G1 X126.917 Y123.051 E.28077
G1 X126.917 Y123.584
G1 X133.583 Y130.25 E.28077
G1 X133.583 Y130.783
G1 X126.917 Y124.118 E.28077
G1 X126.917 Y124.651
G1 X133.583 Y131.316 E.28077
G1 X133.583 Y131.849
G1 X126.917 Y125.184 E.28077
G1 X126.917 Y125.717
G1 X133.583 Y132.383 E.28077
; WIPE_START
M204 S10000
G1 X132.168 Y130.968 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X139.742 Y131.916 Z3 F30000
G1 X143.749 Y132.417 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S2000
G1 X144.583 Y133.251 E.0351
G1 X144.583 Y133.784
G1 X143.216 Y132.417 E.05757
G1 X142.683 Y132.417
G1 X144.583 Y134.317 E.08003
G1 X144.583 Y134.85
G1 X142.15 Y132.417 E.10249
G1 X141.616 Y132.417
G1 X144.583 Y135.384 E.12496
G1 X144.583 Y135.917
G1 X141.083 Y132.417 E.14742
G1 X140.55 Y132.417
G1 X144.583 Y136.45 E.16988
G1 X144.583 Y136.983
G1 X140.017 Y132.417 E.19234
G1 X139.483 Y132.417
G1 X144.583 Y137.517 E.21481
G1 X144.583 Y138.05
G1 X138.95 Y132.417 E.23727
G1 X138.417 Y132.417
G1 X144.583 Y138.583 E.25973
G1 X144.583 Y139.117
G1 X137.883 Y132.417 E.2822
G1 X137.35 Y132.417
G1 X144.583 Y139.65 E.30466
G1 X144.583 Y140.183
G1 X136.817 Y132.417 E.32712
G1 X136.284 Y132.417
G1 X144.583 Y140.716 E.34959
G1 X144.583 Y141.25
G1 X135.75 Y132.417 E.37205
; WIPE_START
M204 S10000
G1 X137.165 Y133.832 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X142.189 Y128.086 Z3 F30000
G1 X153.583 Y115.055 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S2000
G1 X149.417 Y110.889 E.17546
G1 X149.417 Y111.423
G1 X153.583 Y115.588 E.17546
G1 X153.583 Y116.121
G1 X149.417 Y111.956 E.17546
G1 X149.417 Y112.489
G1 X153.583 Y116.654 E.17546
G1 X153.583 Y117.188
G1 X149.417 Y113.022 E.17546
G1 X149.417 Y113.556
G1 X153.583 Y117.721 E.17546
G1 X153.583 Y118.254
G1 X149.417 Y114.089 E.17546
G1 X149.417 Y114.622
G1 X153.583 Y118.787 E.17546
G1 X153.583 Y119.321
G1 X149.417 Y115.155 E.17546
G1 X149.417 Y115.689
G1 X153.583 Y119.854 E.17546
G1 X153.583 Y120.387
G1 X149.417 Y116.222 E.17546
G1 X149.417 Y116.755
G1 X153.583 Y120.92 E.17546
G1 X153.583 Y121.454
G1 X149.417 Y117.288 E.17546
G1 X149.417 Y117.822
G1 X153.583 Y121.987 E.17546
G1 X153.583 Y122.52
G1 X149.417 Y118.355 E.17546
G1 X149.417 Y118.888
G1 X153.583 Y123.053 E.17546
G1 X153.583 Y123.587
G1 X149.413 Y119.417 E.17563
G1 X148.88 Y119.417
G1 X153.583 Y124.12 E.19809
G1 X153.583 Y124.653
G1 X148.347 Y119.417 E.22056
G1 X147.814 Y119.417
G1 X153.583 Y125.186 E.24302
G1 X153.583 Y125.72
G1 X147.28 Y119.417 E.26548
G1 X146.747 Y119.417
G1 X153.583 Y126.253 E.28795
G1 X153.583 Y126.786
G1 X146.214 Y119.417 E.31041
G1 X145.681 Y119.417
G1 X153.583 Y127.319 E.33287
G1 X153.583 Y127.853
G1 X145.147 Y119.417 E.35534
G1 X144.614 Y119.417
G1 X153.583 Y128.386 E.3778
G1 X153.583 Y128.919
G1 X144.417 Y119.754 E.38608
G1 X144.417 Y120.287
G1 X153.583 Y129.452 E.38608
G1 X153.583 Y129.986
G1 X144.417 Y120.821 E.38608
G1 X144.417 Y121.354
G1 X153.583 Y130.519 E.38608
G1 X153.583 Y131.052
G1 X144.417 Y121.887 E.38608
G1 X144.417 Y122.42
G1 X153.583 Y131.586 E.38608
G1 X153.583 Y132.119
G1 X144.417 Y122.954 E.38608
G1 X144.417 Y123.487
G1 X153.583 Y132.652 E.38608
G1 X153.583 Y133.185
G1 X144.417 Y124.02 E.38608
G1 X144.417 Y124.553
G1 X153.583 Y133.719 E.38608
G1 X153.583 Y134.252
G1 X144.417 Y125.087 E.38608
G1 X144.417 Y125.62
G1 X153.583 Y134.785 E.38608
G1 X153.583 Y135.318
G1 X144.417 Y126.153 E.38608
G1 X144.417 Y126.686
G1 X153.583 Y135.852 E.38608
G1 X153.583 Y136.385
G1 X144.417 Y127.22 E.38608
G1 X144.417 Y127.753
G1 X149.247 Y132.583 E.20345
M73 P88 R3
G1 X148.714 Y132.583
G1 X144.417 Y128.286 E.18099
G1 X144.417 Y128.819
G1 X148.181 Y132.583 E.15852
G1 X147.647 Y132.583
G1 X144.417 Y129.353 E.13606
G1 X144.417 Y129.886
G1 X147.114 Y132.583 E.1136
G1 X146.581 Y132.583
G1 X144.417 Y130.419 E.09113
G1 X144.417 Y130.952
G1 X146.048 Y132.583 E.06867
G1 X145.514 Y132.583
G1 X144.417 Y131.486 E.04621
G1 X144.417 Y132.019
G1 X144.981 Y132.583 E.02374
; WIPE_START
M204 S10000
G1 X144.417 Y132.019 E-.30293
G1 X144.417 Y131.486 E-.20264
G1 X144.891 Y131.959 E-.25443
; WIPE_END
G1 E-.04 F1800
G1 X149.417 Y132.753 Z3 F30000
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S2000
G1 X153.583 Y136.918 E.17546
G1 X153.583 Y137.451
G1 X149.417 Y133.286 E.17546
G1 X149.417 Y133.819
G1 X153.583 Y137.985 E.17546
G1 X153.583 Y138.518
G1 X149.417 Y134.353 E.17546
G1 X149.417 Y134.886
G1 X153.583 Y139.051 E.17546
G1 X153.583 Y139.584
G1 X149.417 Y135.419 E.17546
G1 X149.417 Y135.952
G1 X153.583 Y140.118 E.17546
G1 X153.583 Y140.651
G1 X149.417 Y136.486 E.17546
G1 X149.417 Y137.019
G1 X153.583 Y141.184 E.17546
G1 X153.583 Y141.717
G1 X149.417 Y137.552 E.17546
G1 X149.417 Y138.085
G1 X153.583 Y142.251 E.17546
G1 X153.583 Y142.784
G1 X149.417 Y138.619 E.17546
G1 X149.417 Y139.152
G1 X153.583 Y143.317 E.17546
G1 X153.315 Y143.583
G1 X149.417 Y139.685 E.16418
G1 X149.417 Y140.218
G1 X152.782 Y143.583 E.14171
G1 X152.248 Y143.583
G1 X149.417 Y140.752 E.11925
G1 X149.417 Y141.285
G1 X151.715 Y143.583 E.09679
G1 X151.182 Y143.583
G1 X149.017 Y141.417 E.09121
G1 X148.483 Y141.417
G1 X150.648 Y143.583 E.09121
G1 X150.115 Y143.583
G1 X147.95 Y141.417 E.09121
G1 X147.417 Y141.417
G1 X149.582 Y143.583 E.09121
G1 X149.049 Y143.583
G1 X146.883 Y141.417 E.09121
G1 X146.35 Y141.417
G1 X148.515 Y143.583 E.09121
G1 X147.982 Y143.583
G1 X145.817 Y141.417 E.09121
G1 X145.284 Y141.417
G1 X147.449 Y143.583 E.09121
G1 X146.916 Y143.583
G1 X144.75 Y141.417 E.09121
; WIPE_START
M204 S10000
G1 X146.165 Y142.832 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X146.382 Y143.583 Z3 F30000
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S2000
G1 X135.217 Y132.417 E.47033
G1 X134.684 Y132.417
G1 X145.849 Y143.583 E.47033
G1 X145.316 Y143.583
G1 X134.151 Y132.417 E.47033
G1 X133.617 Y132.417
G1 X144.783 Y143.583 E.47033
G1 X144.249 Y143.583
G1 X126.917 Y126.251 E.7301
G1 X126.917 Y126.784
G1 X143.716 Y143.583 E.70764
G1 X143.183 Y143.583
G1 X126.917 Y127.317 E.68518
G1 X126.917 Y127.85
G1 X142.65 Y143.583 E.66271
G1 X142.116 Y143.583
G1 X126.917 Y128.384 E.64025
G1 X126.917 Y128.917
G1 X141.583 Y143.583 E.61779
G1 X141.05 Y143.583
G1 X126.917 Y129.45 E.59533
G1 X126.917 Y129.983
G1 X140.517 Y143.583 E.57286
G1 X139.983 Y143.583
G1 X126.917 Y130.517 E.5504
G1 X126.917 Y131.05
G1 X139.45 Y143.583 E.52794
G1 X138.917 Y143.583
G1 X132.917 Y137.583 E.25272
G1 X132.917 Y138.116
G1 X138.384 Y143.583 E.23026
G1 X137.85 Y143.583
G1 X132.917 Y138.65 E.2078
G1 X132.917 Y139.183
G1 X137.317 Y143.583 E.18533
G1 X136.784 Y143.583
G1 X132.917 Y139.716 E.16287
G1 X132.917 Y140.249
G1 X136.251 Y143.583 E.14041
G1 X135.717 Y143.583
G1 X132.917 Y140.783 E.11794
G1 X132.917 Y141.316
G1 X135.184 Y143.583 E.09548
G1 X134.651 Y143.583
G1 X132.917 Y141.849 E.07302
G1 X132.452 Y141.917
G1 X134.118 Y143.583 E.07015
G1 X133.584 Y143.583
G1 X131.919 Y141.917 E.07015
G1 X131.386 Y141.917
G1 X133.583 Y144.114 E.09254
G1 X133.518 Y144.583
G1 X130.853 Y141.917 E.11227
G1 X130.319 Y141.917
G1 X132.984 Y144.583 E.11227
G1 X132.451 Y144.583
G1 X129.786 Y141.917 E.11227
G1 X129.253 Y141.917
G1 X131.918 Y144.583 E.11227
; WIPE_START
M204 S10000
G1 X130.504 Y143.168 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X132.417 Y137.083 Z3 F30000
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S2000
G1 X126.917 Y131.583 E.23166
G1 X126.917 Y132.116
G1 X131.884 Y137.083 E.2092
G1 X131.35 Y137.083
G1 X126.917 Y132.65 E.18674
G1 X126.917 Y133.183
G1 X130.817 Y137.083 E.16427
G1 X130.284 Y137.083
G1 X126.917 Y133.716 E.14181
G1 X126.917 Y134.249
G1 X129.751 Y137.083 E.11935
G1 X129.217 Y137.083
G1 X126.917 Y134.783 E.09688
G1 X126.917 Y135.316
G1 X129.083 Y137.481 E.09121
G1 X129.083 Y138.014
G1 X126.917 Y135.849 E.09121
M73 P89 R3
G1 X126.917 Y136.382
G1 X129.083 Y138.548 E.09121
G1 X129.083 Y139.081
G1 X126.917 Y136.916 E.09121
G1 X126.917 Y137.449
G1 X129.083 Y139.614 E.09121
G1 X129.083 Y140.147
G1 X126.917 Y137.982 E.09121
G1 X126.917 Y138.516
G1 X129.083 Y140.681 E.09121
G1 X129.083 Y141.214
G1 X126.917 Y139.049 E.09121
G1 X126.753 Y139.417
G1 X129.083 Y141.747 E.09814
; WIPE_START
M204 S10000
G1 X127.668 Y140.333 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.219 Y139.417 Z3 F30000
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S2000
G1 X131.385 Y144.583 E.21758
G1 X130.851 Y144.583
G1 X125.686 Y139.417 E.21758
G1 X125.153 Y139.417
G1 X130.318 Y144.583 E.21758
G1 X129.785 Y144.583
G1 X124.62 Y139.417 E.21758
G1 X124.086 Y139.417
G1 X129.252 Y144.583 E.21758
G1 X128.58 Y144.444
G1 X123.553 Y139.417 E.21173
G1 X123.02 Y139.417
G1 X128.046 Y144.444 E.21173
G1 X127.513 Y144.444
G1 X122.487 Y139.417 E.21173
G1 X121.953 Y139.417
G1 X126.98 Y144.444 E.21173
G1 X126.447 Y144.444
G1 X121.42 Y139.417 E.21173
G1 X120.887 Y139.417
G1 X125.913 Y144.444 E.21173
G1 X125.38 Y144.444
G1 X120.354 Y139.417 E.21173
G1 X119.82 Y139.417
G1 X124.847 Y144.444 E.21173
G1 X124.314 Y144.444
G1 X119.287 Y139.417 E.21173
G1 X118.754 Y139.417
G1 X123.78 Y144.444 E.21173
G1 X123.247 Y144.444
G1 X118.221 Y139.417 E.21173
G1 X117.687 Y139.417
G1 X122.714 Y144.444 E.21173
G1 X122.18 Y144.444
G1 X117.154 Y139.417 E.21173
G1 X116.621 Y139.417
G1 X121.647 Y144.444 E.21173
M73 P89 R2
G1 X121.114 Y144.444
G1 X116.088 Y139.417 E.21173
G1 X115.554 Y139.417
G1 X120.581 Y144.444 E.21173
G1 X120.047 Y144.444
G1 X115.021 Y139.417 E.21173
G1 X114.488 Y139.417
G1 X119.514 Y144.444 E.21173
G1 X118.981 Y144.444
G1 X113.955 Y139.417 E.21173
G1 X113.421 Y139.417
G1 X118.448 Y144.444 E.21173
G1 X117.914 Y144.444
G1 X112.888 Y139.417 E.21173
G1 X112.355 Y139.417
G1 X117.381 Y144.444 E.21173
G1 X116.848 Y144.444
G1 X111.822 Y139.417 E.21173
G1 X111.288 Y139.417
G1 X116.315 Y144.444 E.21173
G1 X115.781 Y144.444
G1 X110.755 Y139.417 E.21173
G1 X110.222 Y139.417
G1 X115.248 Y144.444 E.21173
G1 X114.715 Y144.444
G1 X109.688 Y139.417 E.21173
G1 X109.155 Y139.417
G1 X114.182 Y144.444 E.21173
G1 X113.648 Y144.444
G1 X106.917 Y137.713 E.28354
G1 X106.917 Y138.246
G1 X113.115 Y144.444 E.26108
G1 X112.582 Y144.444
G1 X106.917 Y138.779 E.23861
G1 X106.917 Y139.313
G1 X112.049 Y144.444 E.21615
G1 X111.515 Y144.444
G1 X106.917 Y139.846 E.19369
G1 X106.917 Y140.379
G1 X110.982 Y144.444 E.17122
G1 X110.449 Y144.444
G1 X106.917 Y140.912 E.14876
G1 X106.917 Y141.446
G1 X109.916 Y144.444 E.1263
G1 X109.382 Y144.444
G1 X106.856 Y141.917 E.10642
G1 X106.323 Y141.917
G1 X108.849 Y144.444 E.10642
G1 X108.316 Y144.444
G1 X105.789 Y141.917 E.10642
G1 X105.256 Y141.917
G1 X107.783 Y144.444 E.10642
G1 X107.249 Y144.444
G1 X104.723 Y141.917 E.10642
G1 X104.19 Y141.917
G1 X106.855 Y144.583 E.11227
G1 X106.322 Y144.583
G1 X103.656 Y141.917 E.11227
G1 X103.123 Y141.917
G1 X105.788 Y144.583 E.11227
G1 X105.255 Y144.583
G1 X102.417 Y141.745 E.11954
G1 X102.417 Y142.278
G1 X104.722 Y144.583 E.09707
G1 X104.189 Y144.583
G1 X102.417 Y142.811 E.07461
G1 X102.417 Y143.345
G1 X103.655 Y144.583 E.05215
G1 X103.122 Y144.583
G1 X102.417 Y143.878 E.02968
; WIPE_START
M204 S10000
G1 X103.122 Y144.583 E-.3787
G1 X103.655 Y144.583 E-.20264
G1 X103.323 Y144.25 E-.17866
; WIPE_END
G1 E-.04 F1800
G1 X110.926 Y143.585 Z3 F30000
G1 X129.182 Y141.988 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.159137
G1 F15000
G1 X129.101 Y141.954 E.00081
G1 X129.046 Y141.899 E.00072
G1 X129.012 Y141.818 E.00081
; WIPE_START
G1 X129.046 Y141.899 E-.26251
G1 X129.101 Y141.954 E-.23503
G1 X129.182 Y141.988 E-.26246
; WIPE_END
G1 E-.04 F1800
G1 X136.121 Y138.808 Z3 F30000
G1 X149.488 Y132.683 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.159066
G1 F15000
G1 X149.454 Y132.601 E.00081
G1 X149.399 Y132.546 E.00072
G1 X149.317 Y132.512 E.00081
; WIPE_START
G1 X149.399 Y132.546 E-.26273
G1 X149.454 Y132.601 E-.23459
G1 X149.488 Y132.683 E-.26269
; WIPE_END
G1 E-.04 F1800
G1 X141.856 Y132.555 Z3 F30000
G1 X133.584 Y132.416 Z3
M73 P90 R2
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.0921633
G1 F15000
G1 X133.467 Y132.533 E.00065
; WIPE_START
G1 X133.584 Y132.416 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.698 Y124.784 Z3 F30000
G1 X133.775 Y119.601 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.10062
G1 F15000
G1 X133.797 Y119.573 E.00017
G1 X133.684 Y119.483 E.00066
; WIPE_START
G1 X133.797 Y119.573 E-.60743
G1 X133.775 Y119.601 E-.15257
; WIPE_END
G1 E-.04 F1800
G1 X141.407 Y119.66 Z3 F30000
G1 X144.488 Y119.684 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.158487
G1 F15000
G1 X144.454 Y119.601 E.00081
G1 X144.399 Y119.546 E.00071
G1 X144.316 Y119.512 E.00081
; WIPE_START
G1 X144.399 Y119.546 E-.26453
G1 X144.454 Y119.601 E-.23095
G1 X144.488 Y119.684 E-.26453
; WIPE_END
G1 E-.04 F1800
G1 X149.513 Y119.317 Z3 F30000
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.0998311
G1 F15000
G1 X149.427 Y119.204 E.00064
G1 X149.399 Y119.225 E.00016
; WIPE_START
G1 X149.427 Y119.204 E-.15004
G1 X149.513 Y119.317 E-.60996
; WIPE_END
G1 E-.04 F1800
G1 X141.913 Y118.614 Z3 F30000
G1 X103.206 Y115.031 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.0978054
G1 F15000
G1 X103.073 Y114.899 E.00081
G1 X103.081 Y114.793 E.00046
G1 X102.439 Y114.304 F30000
; LINE_WIDTH: 0.0977864
G1 F15000
G1 X102.419 Y114.436 E.00058
; WIPE_START
G1 X102.439 Y114.304 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X107.984 Y119.548 Z3 F30000
G1 X133.601 Y143.775 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.100662
G1 F15000
G1 X133.573 Y143.797 E.00017
G1 X133.483 Y143.684 E.00066
; WIPE_START
G1 X133.573 Y143.797 E-.60731
G1 X133.601 Y143.775 E-.15269
; WIPE_END
G1 E-.04 F1800
G1 X125.983 Y143.312 Z3 F30000
G1 X103.081 Y141.919 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.100224
G1 F15000
G1 X102.97 Y142.03 E.00071
; WIPE_START
G1 X103.081 Y141.919 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X103.101 Y137.275 Z3 F30000
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.0995043
G1 F15000
G1 X103.073 Y137.295 E.00015
G1 X102.988 Y137.182 E.00063
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X103.073 Y137.295 E-.61099
G1 X103.101 Y137.275 E-.14901
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 14/27
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
M106 S153
G17
G3 Z3 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z2.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X129.331 Y140.21 E.00658
G1 X129.7 Y140.21 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X130.19 Y140.21 E.01576
G1 X130.19 Y141.3 E.03505
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X130.19 Y141.669 E.01099
G1 X130.19 Y144.39 E.08105
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y141.669 E.08105
G1 X105.81 Y141.3 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X105.81 Y140.21 E.03505
G1 X106.3 Y140.21 E.01576
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X106.669 Y140.21 E.01099
G1 X106.89 Y140.21 E.00658
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.2 I-.075 J-1.215 P1  F30000
G1 X106.672 Y143.85 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.2 I1.217 J.019 P1  F30000
G1 X106.89 Y108.69 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X106.669 Y111.79 E.00658
G1 X106.3 Y111.79 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X105.81 Y111.79 E.01576
G1 X105.81 Y110.7 E.03505
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X105.81 Y110.331 E.01099
G1 X105.81 Y107.61 E.08105
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y110.331 E.08105
G1 X130.19 Y110.7 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F1500
G1 X130.19 Y111.79 E.03505

G1 X129.7 Y111.79 E.01576
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X129.331 Y111.79 E.01099
G1 X129.11 Y111.79 E.00658
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.2 I.075 J-1.215 P1  F30000
G1 X106.672 Y108.15 Z3.2
G1 Z2.8
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 15/27
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
G17
G3 Z3.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z3
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.4 I-.075 J-1.215 P1  F30000
G1 X106.672 Y143.85 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.4 I1.217 J.019 P1  F30000
G1 X106.89 Y108.69 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.4 I.075 J-1.215 P1  F30000
G1 X106.672 Y108.15 Z3.4
G1 Z3
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
M73 P91 R2
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 16/27
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
G17
G3 Z3.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z3.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.6 I-.075 J-1.215 P1  F30000
G1 X106.672 Y143.85 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.6 I1.217 J.019 P1  F30000
G1 X106.89 Y108.69 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.6 I.075 J-1.215 P1  F30000
G1 X106.672 Y108.15 Z3.6
G1 Z3.2
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 17/27
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
G17
G3 Z3.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z3.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y142.899 Z3.8 F30000
G1 X106.672 Y143.85 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.472 Y134.796 Z3.8 F30000
G1 X106.89 Y108.69 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
M73 P92 R2
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y109.101 Z3.8 F30000
G1 X106.672 Y108.15 Z3.8
G1 Z3.4
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 18/27
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
G17
G3 Z3.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z3.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y142.899 Z4 F30000
G1 X106.672 Y143.85 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.472 Y134.796 Z4 F30000
G1 X106.89 Y108.69 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y109.101 Z4 F30000
G1 X106.672 Y108.15 Z4
G1 Z3.6
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 19/27
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
G17
G3 Z4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z3.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
M73 P93 R2
G1 E-.04 F1800
M73 P93 R1
G1 X122.032 Y142.899 Z4.2 F30000
G1 X106.672 Y143.85 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.472 Y134.796 Z4.2 F30000
G1 X106.89 Y108.69 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y109.101 Z4.2 F30000
G1 X106.672 Y108.15 Z4.2
G1 Z3.8
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 20/27
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
G17
G3 Z4.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y142.899 Z4.4 F30000
G1 X106.672 Y143.85 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.472 Y134.796 Z4.4 F30000
G1 X106.89 Y108.69 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y109.101 Z4.4 F30000
G1 X106.672 Y108.15 Z4.4
G1 Z4
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
M73 P94 R1
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 21/27
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
G17
G3 Z4.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z4.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y142.899 Z4.6 F30000
G1 X106.672 Y143.85 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.472 Y134.796 Z4.6 F30000
G1 X106.89 Y108.69 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y109.101 Z4.6 F30000
G1 X106.672 Y108.15 Z4.6
G1 Z4.2
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 22/27
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
G17
G3 Z4.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z4.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y142.899 Z4.8 F30000
G1 X106.672 Y143.85 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.472 Y134.796 Z4.8 F30000
G1 X106.89 Y108.69 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
M73 P95 R1
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y109.101 Z4.8 F30000
G1 X106.672 Y108.15 Z4.8
G1 Z4.4
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 23/27
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
G17
G3 Z4.8 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z4.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y142.899 Z5 F30000
G1 X106.672 Y143.85 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.472 Y134.796 Z5 F30000
G1 X106.89 Y108.69 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y109.101 Z5 F30000
G1 X106.672 Y108.15 Z5
G1 Z4.6
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 24/27
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
G17
G3 Z5 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z4.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
M73 P96 R1
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y142.899 Z5.2 F30000
G1 X106.672 Y143.85 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.472 Y134.796 Z5.2 F30000
G1 X106.89 Y108.69 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y109.101 Z5.2 F30000
G1 X106.672 Y108.15 Z5.2
G1 Z4.8
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 25/27
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
G17
G3 Z5.2 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z5
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
M73 P96 R0
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y142.899 Z5.4 F30000
G1 X106.672 Y143.85 Z5.4
G1 Z5
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.472 Y134.796 Z5.4 F30000
G1 X106.89 Y108.69 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y109.101 Z5.4 F30000
G1 X106.672 Y108.15 Z5.4
G1 Z5
M73 P97 R0
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 26/27
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
G17
G3 Z5.4 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z5.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y142.899 Z5.6 F30000
G1 X106.672 Y143.85 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.472 Y134.796 Z5.6 F30000
G1 X106.89 Y108.69 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y109.101 Z5.6 F30000
G1 X106.672 Y108.15 Z5.6
G1 Z5.2
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 27/27
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
G17
G3 Z5.6 I1.217 J0 P1  F30000
;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
 ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter

M623
; SKIPPABLE_END
; OBJECT_ID: 14
G1 X106.89 Y143.31
G1 Z5.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X129.11 Y143.31 E.66186
G1 X129.11 Y140.21 E.09234
G1 X130.19 Y140.21 E.03217
G1 X130.19 Y144.39 E.12451
G1 X105.81 Y144.39 E.7262
G1 X105.81 Y140.21 E.12451
G1 X106.89 Y140.21 E.03217
G1 X106.89 Y143.27 E.09115
M204 S10000
G1 X106.672 Y143.85 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y143.85 E1.15443
G1 X129.417 Y143.832 E.00463
; LINE_WIDTH: 0.74326
G1 X129.506 Y143.813 E.00503
; LINE_WIDTH: 0.780154
G1 X129.595 Y143.795 E.0053
; LINE_WIDTH: 0.780149
G1 X129.613 Y143.706 E.0053
; LINE_WIDTH: 0.743266
G1 X129.632 Y143.617 E.00503
; LINE_WIDTH: 0.706382
G1 X129.65 Y143.527 E.00477
; LINE_WIDTH: 0.68792
G1 X129.65 Y140.427 E.15795
; WIPE_START
G1 F3720.93
G1 X129.65 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y142.899 Z5.8 F30000
G1 X106.672 Y143.85 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.706382
G1 F1200
G1 X106.583 Y143.832 E.00477
; LINE_WIDTH: 0.743266
G1 X106.494 Y143.813 E.00503
; LINE_WIDTH: 0.780149
G1 X106.405 Y143.795 E.0053
; LINE_WIDTH: 0.780154
G1 X106.387 Y143.706 E.0053
; LINE_WIDTH: 0.74326
G1 X106.368 Y143.617 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y143.527 E.00464
G1 X106.35 Y140.427 E.15808
; WIPE_START
G1 F3717.844
G1 X106.35 Y142.427 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X106.472 Y134.796 Z5.8 F30000
G1 X106.89 Y108.69 Z5.8
M73 P98 R0
G1 Z5.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X106.89 Y111.79 E.09234
G1 X105.81 Y111.79 E.03217
G1 X105.81 Y107.61 E.12451
G1 X130.19 Y107.61 E.7262
G1 X130.19 Y111.79 E.12451
G1 X129.11 Y111.79 E.03217
G1 X129.11 Y108.69 E.09234
G1 X106.93 Y108.69 E.66067
M204 S10000
G1 X106.672 Y108.15 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.688004
G1 F1200
G1 X129.327 Y108.15 E1.15443
G1 X129.417 Y108.168 E.00463
; LINE_WIDTH: 0.743266
G1 X129.506 Y108.187 E.00503
; LINE_WIDTH: 0.780149
G1 X129.595 Y108.205 E.0053
; LINE_WIDTH: 0.780154
G1 X129.613 Y108.294 E.0053
; LINE_WIDTH: 0.74326
G1 X129.632 Y108.383 E.00503
; LINE_WIDTH: 0.706367
G1 X129.65 Y108.472 E.00477
; LINE_WIDTH: 0.68794
G1 X129.65 Y111.572 E.15795
; WIPE_START
G1 F3720.815
G1 X129.65 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.032 Y109.101 Z5.8 F30000
G1 X106.672 Y108.15 Z5.8
G1 Z5.4
G1 E.8 F1800
; LINE_WIDTH: 0.706367
G1 F1200
G1 X106.583 Y108.168 E.00477
; LINE_WIDTH: 0.74326
G1 X106.494 Y108.187 E.00503
; LINE_WIDTH: 0.780154
G1 X106.405 Y108.205 E.0053
; LINE_WIDTH: 0.780149
G1 X106.387 Y108.294 E.0053
; LINE_WIDTH: 0.743266
G1 X106.368 Y108.383 E.00503
; LINE_WIDTH: 0.688456
G1 X106.35 Y108.472 E.00464
G1 X106.35 Y111.572 E.15808
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F3717.842
G1 X106.35 Y109.572 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z5.8 I1.217 J0 P1  F30000
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 

;===== date: 20240402 =====================
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z5.9 F900 ; lower z a little
G1 X65 Y245 F12000 ; move to safe pos 
G1 Y265 F3000

G1 X65 Y245 F12000
G1 Y265 F3000
M141 S0 ; turn off chamber 
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

G1 X100 F12000 ; wipe
; pull back filament to AMS
M620 S255
G1 X20 Y50 F12000
G1 Y-3
T255
G1 X65 F12000
G1 Y265
G1 X100 F12000 ; wipe
M621 S255
M104 S0 ; turn off hotend

M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S3 ;wait for last picture to be taken
M623; end of "timelapse_record_flag"

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    G1 Z105.4 F600
    G1 Z103.4

M400 P100
M17 R ; restore z current

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M960 S5 P0 ; turn off logo lamp

M73 P100 R0
; EXECUTABLE_BLOCK_END

