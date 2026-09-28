; HEADER_BLOCK_START
; BambuStudio 02.08.02.61
; model printing time: 19m 46s; total estimated time: 28m 58s
; total layer number: 152
; total filament length [mm] : 1086.88
; total filament volume [cm^3] : 2614.25
; total filament weight [g] : 3.40
; filament_density: 1.3
; filament_diameter: 1.75
; max_z_height: 20.60
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
; bridge_no_support = 1
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
; different_settings_to_system = enable_prime_tower;;
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
; enable_support = 1
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
M73 P2 R28
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
M73 P20 R23
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
    G29 A X114.058 Y108.549 I27.8848 J36.8933
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
M73 P20 R22
    G1 X70.000 E0.31181 F301.664
    G1 X75.000 E0.31181 F1206.65
    G1 X80.000 E0.31181 F301.664
    G1 X85.000 E0.31181 F1206.65
    G1 X90.000 E0.31181 F301.664
    G1 X95.000 E0.31181 F1206.65
    G1 X100.000 E0.31181 F301.664
    G1 X105.000 E0.31181 F1206.65
    G1 X110.000 E0.31181 F301.664
M73 P21 R22
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
M73 P22 R22
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
M73 P23 R22
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
M73 P24 R22
    G1 X80.000 E0.31181 F301.664
    G1 X85.000 E0.31181 F1206.65
    G1 X90.000 E0.31181 F301.664
    G1 X95.000 E0.31181 F1206.65
    G1 X100.000 E0.31181 F301.664
    G1 X105.000 E0.31181 F1206.65
    G1 X110.000 E0.31181 F301.664
    G1 X115.000 E0.31181 F1206.65
M73 P24 R21
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

M73 P25 R21
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
    G1 X160.000 E0.31181 F301.664
    G1 X165.000 E0.31181 F1206.65
    G1 X170.000 E0.31181 F301.664
    G1 X175.000 E0.31181 F1206.65
    G1 X180.000 E0.31181 F301.664
    G1 X185.000 E0.31181 F1206.65
    G1 X190.000 E0.31181 F301.664
    G1 X195.000 E0.31181 F1206.65
    G1 X200.000 E0.31181 F301.664
M73 P26 R21
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
; layer num/total_layer_count: 1/152
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
G1 X127.061 Y114.05
G1 Z.2
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.5
G1 F1200
M204 S500
G1 X117.43 Y114.05 E.34774
G1 X117.43 Y106.799 E.2618
G1 X127.061 Y106.799 E.34774
G1 X127.061 Y113.981 E.25933
M204 S6000
G1 X126.476 Y113.844 F30000
G1 F1200
M204 S500
G1 X126.476 Y107.21 E.23952
G1 X125.969 Y107.21 E.01834
G1 X125.969 Y113.639 E.2321
G1 X125.461 Y113.639 E.01834
G1 X125.461 Y107.21 E.2321
G1 X124.953 Y107.21 E.01834
G1 X124.953 Y113.639 E.2321
G1 X124.445 Y113.639 E.01834
G1 X124.445 Y107.21 E.2321
G1 X123.937 Y107.21 E.01834
M73 P27 R21
G1 X123.937 Y113.639 E.2321
G1 X123.429 Y113.639 E.01834
G1 X123.429 Y107.21 E.2321
G1 X122.921 Y107.21 E.01834
G1 X122.921 Y113.639 E.2321
G1 X122.414 Y113.639 E.01834
G1 X122.414 Y107.21 E.2321
G1 X121.906 Y107.21 E.01834
G1 X121.906 Y113.639 E.2321
G1 X121.398 Y113.639 E.01834
G1 X121.398 Y107.21 E.2321
G1 X120.89 Y107.21 E.01834
G1 X120.89 Y113.639 E.2321
G1 X120.382 Y113.639 E.01834
G1 X120.382 Y107.21 E.2321
G1 X119.874 Y107.21 E.01834
G1 X119.874 Y113.639 E.2321
M73 P27 R20
G1 X119.366 Y113.639 E.01834
G1 X119.366 Y107.21 E.2321
G1 X118.859 Y107.21 E.01834
M73 P28 R20
G1 X118.859 Y113.639 E.2321
G1 X118.351 Y113.639 E.01834
G1 X118.351 Y107.21 E.2321
G1 X117.843 Y107.21 E.01834
G1 X117.843 Y113.844 E.23952
; WIPE_START
G1 X117.843 Y111.844 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X125.432 Y112.652 Z.6 F30000
G1 X138.57 Y114.05 Z.6
G1 Z.2
M73 P29 R20
G1 E.8 F1800
G1 F1200
M204 S500
G1 X128.939 Y114.05 E.34774
G1 X128.939 Y106.799 E.2618
G1 X138.57 Y106.799 E.34774
G1 X138.57 Y113.981 E.25933
M204 S6000
G1 X138.157 Y113.844 F30000
G1 F1200
M204 S500
G1 X138.157 Y107.21 E.23952
G1 X137.649 Y107.21 E.01834
G1 X137.649 Y113.639 E.2321
G1 X137.141 Y113.639 E.01834
G1 X137.141 Y107.21 E.2321
G1 X136.634 Y107.21 E.01834
M73 P30 R20
G1 X136.634 Y113.639 E.2321
G1 X136.126 Y113.639 E.01834
G1 X136.126 Y107.21 E.2321
G1 X135.618 Y107.21 E.01834
G1 X135.618 Y113.639 E.2321
G1 X135.11 Y113.639 E.01834
G1 X135.11 Y107.21 E.2321
G1 X134.602 Y107.21 E.01834
G1 X134.602 Y113.639 E.2321
G1 X134.094 Y113.639 E.01834
G1 X134.094 Y107.21 E.2321
G1 X133.586 Y107.21 E.01834
G1 X133.586 Y113.639 E.2321
G1 X133.079 Y113.639 E.01834
G1 X133.079 Y107.21 E.2321
G1 X132.571 Y107.21 E.01834
G1 X132.571 Y113.639 E.2321
G1 X132.063 Y113.639 E.01834
G1 X132.063 Y107.21 E.2321
G1 X131.555 Y107.21 E.01834
G1 X131.555 Y113.639 E.2321
G1 X131.047 Y113.639 E.01834
G1 X131.047 Y107.21 E.2321
G1 X130.539 Y107.21 E.01834
G1 X130.539 Y113.639 E.2321
G1 X130.031 Y113.639 E.01834
G1 X130.031 Y107.21 E.2321
G1 X129.524 Y107.21 E.01834
G1 X129.524 Y113.844 E.23952
; WIPE_START
G1 X129.524 Y111.844 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
M73 P31 R19
G1 X136.993 Y113.413 Z.6 F30000
G1 X139.048 Y113.844 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Brim
G1 F1200
M204 S500
G1 X139.048 Y111.792 E.07411
G1 X139.476 Y111.833 E.01553
G1 X140.002 Y111.991 E.01981
G1 X140.436 Y112.202 E.01744
G1 X140.82 Y112.489 E.01731
G1 X141.142 Y112.842 E.01726
G1 X141.416 Y113.304 E.0194
G1 X141.641 Y113.905 E.02316
G1 X141.714 Y114.514 E.02213
G1 X141.714 Y140.489 E.93786
G1 X141.667 Y140.979 E.01776
G1 X141.556 Y141.375 E.01488
G1 X141.297 Y141.938 E.02237
G1 X141.011 Y142.32 E.01722
G1 X140.658 Y142.642 E.01726
G1 X140.196 Y142.916 E.0194
G1 X139.595 Y143.141 E.02316
G1 X138.986 Y143.214 E.02213
G1 X117.011 Y143.214 E.79344
G1 X116.521 Y143.167 E.01776
G1 X116.125 Y143.056 E.01488
M73 P32 R19
G1 X115.562 Y142.797 E.02237
G1 X115.18 Y142.511 E.01722
G1 X114.858 Y142.158 E.01726
G1 X114.584 Y141.696 E.0194
G1 X114.359 Y141.095 E.02316
G1 X114.286 Y140.486 E.02213
G1 X114.286 Y114.511 E.93787
G1 X114.333 Y114.024 E.01767
G1 X114.491 Y113.498 E.01981
G1 X114.702 Y113.064 E.01744
G1 X114.989 Y112.68 E.01731
G1 X115.342 Y112.358 E.01726
G1 X115.942 Y112.02 E.02487
G1 X116.403 Y111.859 E.0176
G1 X116.952 Y111.794 E.01997
G1 X116.952 Y114.071 E.08222
G1 X116.753 Y114.162 E.00789
G1 X116.634 Y114.29 E.00632
G1 X116.571 Y114.5 E.00791
G1 X116.571 Y140.5 E.93876
G1 X116.592 Y140.595 E.00352
G1 X116.662 Y140.747 E.00602
G1 X116.79 Y140.866 E.00632
G1 X117 Y140.929 E.00791
G1 X139 Y140.929 E.79433
G1 X139.095 Y140.908 E.00352
G1 X139.247 Y140.838 E.00602
G1 X139.366 Y140.71 E.00632
G1 X139.429 Y140.5 E.00791
G1 X139.429 Y114.5 E.93876
G1 X139.408 Y114.405 E.00352
G1 X139.338 Y114.253 E.00602
G1 X139.21 Y114.134 E.00631
G1 X139.048 Y114.074 E.00623
G1 X139.048 Y113.884 E.00685
M204 S6000
G1 X139.505 Y113.725 F30000
G1 F1200
M204 S500
G1 X139.505 Y112.503 E.0441
G1 X139.553 Y112.399 E.00413
G1 X139.682 Y112.372 E.00476
G1 X139.825 Y112.415 E.00538
G1 X140.208 Y112.602 E.01541
G1 X140.52 Y112.838 E.01413
G1 X140.78 Y113.127 E.01403
G1 X141.007 Y113.514 E.01619
G1 X141.188 Y113.999 E.01867
G1 X141.257 Y114.549 E.02004
G1 X141.257 Y140.461 E.93556
G1 X141.217 Y140.882 E.01529
G1 X141.121 Y141.227 E.01292
G1 X140.908 Y141.69 E.0184
G1 X140.679 Y142.001 E.01393
G1 X140.373 Y142.28 E.01496
G1 X139.986 Y142.507 E.01619
G1 X139.47 Y142.695 E.01984
G1 X138.951 Y142.757 E.01887
G1 X117.039 Y142.757 E.79113
G1 X116.618 Y142.717 E.01529
G1 X116.273 Y142.621 E.01292
G1 X115.81 Y142.408 E.0184
G1 X115.499 Y142.179 E.01393
G1 X115.22 Y141.873 E.01496
G1 X114.993 Y141.486 E.01619
G1 X114.805 Y140.97 E.01984
G1 X114.743 Y140.451 E.01887
G1 X114.743 Y114.539 E.93556
G1 X114.787 Y114.099 E.01597
G1 X114.915 Y113.675 E.01598
G1 X115.088 Y113.314 E.01447
G1 X115.321 Y112.999 E.01413
G1 X115.625 Y112.723 E.01483
G1 X116.143 Y112.434 E.02141
G1 X116.313 Y112.375 E.0065
G1 X116.426 Y112.386 E.00413
G1 X116.495 Y112.504 E.00494
G1 X116.495 Y113.729 E.04421
G1 X116.454 Y113.826 E.00382
G1 X116.308 Y113.97 E.00739
G1 X116.192 Y114.174 E.00849
G1 X116.114 Y114.51 E.01244
G1 X116.114 Y140.489 E.93801
G1 X116.18 Y140.792 E.0112
G1 X116.241 Y140.925 E.00527
G1 X116.361 Y141.091 E.00739
G1 X116.468 Y141.19 E.00526
G1 X116.674 Y141.308 E.0086
G1 X117.01 Y141.386 E.01244
G1 X138.993 Y141.386 E.7937
G1 X139.295 Y141.319 E.0112
G1 X139.425 Y141.259 E.00515
G1 X139.591 Y141.139 E.00739
G1 X139.69 Y141.032 E.00526
G1 X139.808 Y140.826 E.0086
G1 X139.886 Y140.49 E.01244
G1 X139.886 Y114.511 E.93801
G1 X139.855 Y114.315 E.00716
G1 X139.757 Y114.072 E.00943
G1 X139.639 Y113.909 E.00728
G1 X139.549 Y113.825 E.00444
G1 X139.521 Y113.762 E.00251
M204 S6000
G1 X139.985 Y113.613 F30000
G1 F1200
M204 S500
G1 X139.962 Y113.537 E.00287
G1 X139.962 Y113.265 E.00982
G1 X140.01 Y113.161 E.00413
M73 P33 R19
G1 X140.12 Y113.129 E.00413
G1 X140.182 Y113.156 E.00244
G1 X140.416 Y113.41 E.01247
G1 X140.597 Y113.723 E.01304
G1 X140.743 Y114.124 E.01544
G1 X140.8 Y114.586 E.01681
G1 X140.8 Y140.433 E.9332
G1 X140.767 Y140.787 E.01284
G1 X140.693 Y141.059 E.01018
G1 X140.518 Y141.444 E.01529
G1 X140.346 Y141.682 E.0106
G1 X140.088 Y141.917 E.0126
G1 X139.778 Y142.096 E.01292
G1 X139.347 Y142.25 E.01653
G1 X138.916 Y142.3 E.01568
G1 X117.067 Y142.3 E.78886
G1 X116.713 Y142.267 E.01284
G1 X116.441 Y142.193 E.01018
G1 X116.056 Y142.018 E.01529
G1 X115.818 Y141.846 E.0106
G1 X115.583 Y141.588 E.0126
G1 X115.404 Y141.278 E.01292
G1 X115.25 Y140.847 E.01653
G1 X115.2 Y140.416 E.01568
G1 X115.2 Y114.569 E.93322
G1 X115.236 Y114.202 E.01332
G1 X115.339 Y113.851 E.0132
G1 X115.476 Y113.562 E.01154
G1 X115.653 Y113.318 E.01088
G1 X115.809 Y113.174 E.00766
G1 X115.918 Y113.14 E.00413
G1 X116.015 Y113.2 E.00413
G1 X116.038 Y113.276 E.00286
G1 X116.038 Y113.538 E.00947
G1 X116.008 Y113.623 E.00324
G1 X115.907 Y113.752 E.00595
G1 X115.8 Y113.939 E.00776
G1 X115.745 Y114.079 E.00545
G1 X115.657 Y114.523 E.01634
G1 X115.657 Y140.477 E.93708
G1 X115.767 Y140.987 E.01883
G1 X115.877 Y141.202 E.00871
G1 X115.984 Y141.35 E.00664
G1 X116.15 Y141.518 E.0085
G1 X116.441 Y141.701 E.01244
G1 X116.579 Y141.755 E.00535
G1 X117.023 Y141.843 E.01634
G1 X138.985 Y141.843 E.79295
G1 X139.494 Y141.73 E.01883
G1 X139.699 Y141.625 E.00832
G1 X139.931 Y141.444 E.01058
G1 X140.093 Y141.249 E.00918
G1 X140.2 Y141.061 E.0078
G1 X140.255 Y140.921 E.00545
G1 X140.343 Y140.477 E.01634
G1 X140.343 Y114.52 E.93721
G1 X140.276 Y114.136 E.01405
G1 X140.187 Y113.914 E.00864
G1 X140.008 Y113.646 E.01164
; WIPE_START
G1 X139.962 Y113.537 E-.04497
G1 X139.962 Y113.265 E-.10336
G1 X140.01 Y113.161 E-.04347
G1 X140.12 Y113.129 E-.04347
G1 X140.182 Y113.156 E-.02568
G1 X140.416 Y113.41 E-.13125
G1 X140.597 Y113.723 E-.13719
G1 X140.743 Y114.124 E-.16249
G1 X140.765 Y114.302 E-.06811
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X133.143 Y113.896 Z.6 F30000
G1 X128.46 Y113.646 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X128.46 Y114.071 E.01536
G1 X127.54 Y114.071 E.03322
G1 X127.54 Y111.786 E.08251
G1 X128.46 Y111.786 E.03322
G1 X128.46 Y113.606 E.06572
; WIPE_START
G1 X128.46 Y114.071 E-.17681
G1 X127.54 Y114.071 E-.34965
G1 X127.54 Y113.457 E-.23354
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X135.108 Y114.444 Z.6 F30000
G1 X138.6 Y114.9 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X138.6 Y140.101 E.90991
G1 X135.568 Y140.112 E.10949
G1 X134.104 Y140.226 E.05301
G1 X133.637 Y140.217 E.01687
G1 X132.661 Y140.123 E.03538
G1 X132.16 Y140.104 E.0181
G1 X123.84 Y140.104 E.30042
G1 X123.339 Y140.123 E.0181
G1 X122.363 Y140.217 E.03538
G1 X121.896 Y140.226 E.01687
G1 X120.432 Y140.112 E.05301
G1 X117.4 Y140.101 E.10949
G1 X117.4 Y114.9 E.90991
G1 X138.56 Y114.9 E.764
M204 S6000
G1 X138.1 Y115.4 F30000
; FEATURE: Inner wall
G1 F1200
M204 S500
G1 X138.1 Y139.603 E.87387
G1 X135.995 Y139.611 E.07599
G1 X136.299 Y139.269 E.01651
G1 X136.512 Y138.952 E.01379
G1 X136.681 Y138.611 E.01374
G1 X136.803 Y138.251 E.01372
G1 X136.877 Y137.879 E.0137
G1 X136.9 Y137.529 E.01265
G1 X136.9 Y128.471 E.32707
G1 X136.877 Y128.121 E.01265
G1 X136.803 Y127.749 E.0137
G1 X136.681 Y127.389 E.01371
G1 X136.513 Y127.049 E.0137
G1 X136.302 Y126.733 E.0137
G1 X136.052 Y126.448 E.0137
G1 X135.767 Y126.198 E.01371
G1 X135.451 Y125.987 E.01371
G1 X135.111 Y125.819 E.01371
G1 X134.751 Y125.697 E.01371
G1 X134.377 Y125.622 E.01379
G1 X133.988 Y125.599 E.01406
G1 X133.621 Y125.623 E.01326
G1 X133.249 Y125.697 E.0137
G1 X132.887 Y125.82 E.01379
G1 X132.539 Y125.994 E.01407
G1 X132.233 Y126.198 E.01327
G1 X131.948 Y126.448 E.0137
G1 X131.698 Y126.733 E.0137
G1 X131.494 Y127.039 E.01327
G1 X131.32 Y127.387 E.01407
G1 X131.197 Y127.749 E.01379
G1 X131.123 Y128.121 E.0137
G1 X131.1 Y128.471 E.01265
G1 X131.1 Y137.529 E.32707
M73 P34 R19
G1 X131.123 Y137.879 E.01265
G1 X131.197 Y138.251 E.0137
G1 X131.319 Y138.611 E.01371
G1 X131.488 Y138.952 E.01375
G1 X131.701 Y139.269 E.01379
G1 X131.998 Y139.604 E.01617
G1 X124.002 Y139.604 E.28873
G1 X124.299 Y139.269 E.01617
G1 X124.512 Y138.952 E.0138
G1 X124.681 Y138.611 E.01374
G1 X124.803 Y138.251 E.01372
G1 X124.877 Y137.879 E.0137
G1 X124.9 Y137.529 E.01265
G1 X124.9 Y128.471 E.32707
G1 X124.877 Y128.121 E.01265
G1 X124.803 Y127.749 E.0137
G1 X124.681 Y127.389 E.01371
G1 X124.513 Y127.049 E.0137
G1 X124.302 Y126.733 E.0137
G1 X124.052 Y126.448 E.0137
G1 X123.767 Y126.198 E.01371
G1 X123.451 Y125.987 E.01371
G1 X123.111 Y125.819 E.01371
G1 X122.751 Y125.697 E.01371
G1 X122.377 Y125.622 E.01379
G1 X121.988 Y125.599 E.01406
G1 X121.621 Y125.623 E.01326
G1 X121.249 Y125.697 E.0137
G1 X120.887 Y125.82 E.01379
G1 X120.539 Y125.994 E.01407
G1 X120.233 Y126.198 E.01327
G1 X119.948 Y126.448 E.0137
G1 X119.698 Y126.733 E.0137
G1 X119.494 Y127.039 E.01327
G1 X119.32 Y127.387 E.01407
G1 X119.197 Y127.749 E.01379
G1 X119.123 Y128.121 E.0137
G1 X119.1 Y128.471 E.01265
G1 X119.1 Y137.529 E.32707
G1 X119.123 Y137.879 E.01265
G1 X119.197 Y138.251 E.0137
G1 X119.319 Y138.611 E.01371
G1 X119.488 Y138.952 E.01375
G1 X119.701 Y139.269 E.01379
G1 X120.005 Y139.611 E.01651
G1 X117.9 Y139.603 E.07599
G1 X117.9 Y115.4 E.87387
G1 X138.06 Y115.4 E.7279
M204 S6000
G1 X137.643 Y115.857 F30000
G1 F1200
M204 S500
G1 X137.643 Y139.147 E.84092
G1 X136.924 Y139.15 E.02594
G1 X137.104 Y138.786 E.01466
G1 X137.245 Y138.369 E.01588
G1 X137.331 Y137.939 E.01586
G1 X137.357 Y137.544 E.01428
G1 X137.357 Y128.456 E.32815
G1 X137.331 Y128.061 E.01428
G1 X137.245 Y127.63 E.01586
G1 X137.104 Y127.214 E.01588
G1 X136.91 Y126.82 E.01587
M73 P34 R18
G1 X136.666 Y126.455 E.01587
G1 X136.376 Y126.124 E.01587
G1 X136.045 Y125.834 E.01587
G1 X135.68 Y125.59 E.01587
G1 X135.286 Y125.396 E.01587
G1 X134.87 Y125.254 E.01587
G1 X134.435 Y125.168 E.01599
G1 X133.987 Y125.141 E.01622
G1 X133.561 Y125.169 E.01539
G1 X133.13 Y125.254 E.01587
G1 X132.711 Y125.397 E.01599
G1 X132.309 Y125.598 E.01623
G1 X131.954 Y125.835 E.01539
G1 X131.624 Y126.124 E.01586
G1 X131.334 Y126.455 E.01586
G1 X131.098 Y126.809 E.01539
G1 X130.897 Y127.211 E.01623
G1 X130.754 Y127.63 E.01599
G1 X130.669 Y128.061 E.01586
G1 X130.643 Y128.456 E.01428
G1 X130.643 Y137.544 E.32815
G1 X130.669 Y137.939 E.01427
G1 X130.755 Y138.37 E.01587
G1 X130.896 Y138.786 E.01587
G1 X131.074 Y139.147 E.01452
G1 X124.926 Y139.147 E.22197
G1 X125.104 Y138.786 E.01451
G1 X125.245 Y138.37 E.01588
G1 X125.331 Y137.939 E.01586
G1 X125.357 Y137.544 E.01427
G1 X125.357 Y128.456 E.32815
G1 X125.331 Y128.061 E.01428
G1 X125.245 Y127.63 E.01586
G1 X125.104 Y127.214 E.01588
G1 X124.91 Y126.82 E.01587
G1 X124.666 Y126.455 E.01587
G1 X124.376 Y126.124 E.01587
G1 X124.045 Y125.834 E.01587
G1 X123.68 Y125.59 E.01587
G1 X123.286 Y125.396 E.01587
G1 X122.87 Y125.254 E.01587
G1 X122.435 Y125.168 E.01599
G1 X121.987 Y125.141 E.01622
G1 X121.561 Y125.169 E.01539
G1 X121.13 Y125.254 E.01587
G1 X120.711 Y125.397 E.01599
G1 X120.309 Y125.598 E.01623
G1 X119.954 Y125.835 E.01539
G1 X119.624 Y126.124 E.01586
G1 X119.334 Y126.455 E.01586
G1 X119.098 Y126.809 E.01539
G1 X118.897 Y127.211 E.01623
G1 X118.754 Y127.63 E.01599
G1 X118.669 Y128.061 E.01586
G1 X118.643 Y128.456 E.01428
G1 X118.643 Y137.544 E.32815
G1 X118.669 Y137.939 E.01428
G1 X118.755 Y138.37 E.01587
G1 X118.896 Y138.786 E.01587
G1 X119.076 Y139.15 E.01466
G1 X118.357 Y139.147 E.02594
G1 X118.357 Y115.857 E.84092
G1 X137.603 Y115.857 E.69489
; WIPE_START
G1 X137.606 Y117.857 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X133.142 Y124.048 Z.6 F30000
G1 X132.44 Y125.021 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X132.079 Y125.202 E.01457
G1 X131.675 Y125.471 E.01752
G1 X131.3 Y125.8 E.01802
G1 X130.971 Y126.176 E.01802
G1 X130.702 Y126.579 E.01752
G1 X130.474 Y127.035 E.01839
G1 X130.312 Y127.512 E.01819
G1 X130.215 Y128.001 E.01802
G1 X130.186 Y128.441 E.0159
G1 X130.186 Y137.559 E.32922
G1 X130.215 Y137.999 E.0159
G1 X130.312 Y138.488 E.01803
G1 X130.38 Y138.689 E.00767
G1 X125.62 Y138.689 E.17189
G1 X125.688 Y138.488 E.00768
G1 X125.785 Y137.999 E.01802
G1 X125.814 Y137.559 E.0159
G1 X125.814 Y128.441 E.32923
M73 P35 R18
G1 X125.785 Y128.001 E.0159
G1 X125.688 Y127.512 E.01802
G1 X125.527 Y127.039 E.01804
G1 X125.306 Y126.591 E.01803
G1 X125.029 Y126.176 E.01803
G1 X124.7 Y125.8 E.01803
G1 X124.324 Y125.471 E.01803
G1 X123.909 Y125.193 E.01803
G1 X123.461 Y124.973 E.01803
G1 X122.988 Y124.812 E.01804
G1 X122.494 Y124.714 E.01819
G1 X121.986 Y124.683 E.01838
G1 X121.502 Y124.715 E.01751
G1 X121.012 Y124.812 E.01803
G1 X120.535 Y124.974 E.01819
G1 X120.079 Y125.202 E.0184
G1 X119.675 Y125.471 E.01752
G1 X119.3 Y125.8 E.01802
G1 X118.814 Y126.355 E.02662
G1 X118.814 Y116.314 E.36252
G1 X137.186 Y116.314 E.66333
G1 X137.186 Y126.355 E.36252
G1 X136.7 Y125.8 E.02662
G1 X136.324 Y125.471 E.01803
G1 X135.909 Y125.193 E.01803
G1 X135.461 Y124.973 E.01803
G1 X134.988 Y124.812 E.01804
G1 X134.494 Y124.714 E.01819
G1 X133.986 Y124.683 E.01838
G1 X133.502 Y124.715 E.01751
G1 X133.012 Y124.812 E.01803
G1 X132.535 Y124.974 E.01819
G1 X132.476 Y125.003 E.00238
; WIPE_START
G1 X132.079 Y125.202 E-.16855
G1 X131.675 Y125.471 E-.18439
G1 X131.3 Y125.8 E-.18966
G1 X130.971 Y126.176 E-.1897
G1 X130.931 Y126.236 E-.02769
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X124.116 Y127.375 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Outer wall
G1 F1200
M204 S500
G1 X124.218 Y127.581 E.00832
G1 X124.319 Y127.879 E.01134
G1 X124.38 Y128.187 E.01134
G1 X124.4 Y128.487 E.01087
G1 X124.4 Y137.513 E.3259
G1 X124.38 Y137.813 E.01087
G1 X124.319 Y138.121 E.01133
G1 X124.218 Y138.419 E.01134
G1 X124.079 Y138.701 E.01135
G1 X123.903 Y138.962 E.01137
G1 X123.692 Y139.199 E.01145
G1 X123.456 Y139.395 E.0111
G1 X123.171 Y139.567 E.01201
G1 X122.868 Y139.676 E.01164
G1 X122.564 Y139.734 E.01117
G1 X122 Y139.772 E.0204
G1 X121.436 Y139.734 E.0204
G1 X121.132 Y139.676 E.01116
G1 X120.83 Y139.567 E.01161
G1 X120.563 Y139.408 E.01121
G1 X120.308 Y139.2 E.01189
G1 X120.097 Y138.962 E.01149
G1 X119.921 Y138.701 E.01137
G1 X119.782 Y138.419 E.01135
G1 X119.681 Y138.121 E.01134
G1 X119.62 Y137.813 E.01134
G1 X119.6 Y137.513 E.01087
G1 X119.6 Y128.487 E.3259
G1 X119.62 Y128.187 E.01087
G1 X119.681 Y127.879 E.01133
G1 X119.782 Y127.58 E.01138
G1 X119.927 Y127.29 E.0117
G1 X120.095 Y127.038 E.01094
G1 X120.302 Y126.802 E.01134
G1 X120.538 Y126.595 E.01134
G1 X120.79 Y126.427 E.01094
G1 X121.08 Y126.282 E.0117
G1 X121.379 Y126.181 E.01138
G1 X121.687 Y126.12 E.01134
G1 X121.989 Y126.1 E.01094
G1 X122.312 Y126.119 E.0117
G1 X122.621 Y126.181 E.01137
G1 X122.919 Y126.282 E.01134
G1 X123.2 Y126.421 E.01134
G1 X123.462 Y126.595 E.01134
G1 X123.698 Y126.802 E.01134
G1 X123.905 Y127.038 E.01134
G1 X124.079 Y127.3 E.01134
G1 X124.099 Y127.339 E.00158
; WIPE_START
G1 X124.218 Y127.581 E-.10273
G1 X124.319 Y127.879 E-.11936
G1 X124.38 Y128.187 E-.1193
G1 X124.4 Y128.487 E-.11441
G1 X124.4 Y129.288 E-.30421
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X131.613 Y126.791 Z.6 F30000
G1 X133.072 Y126.287 Z.6
G1 Z.2
G1 E.8 F1800
G1 F1200
M204 S500
G1 X133.08 Y126.282 E.00035
G1 X133.379 Y126.181 E.01138
G1 X133.687 Y126.12 E.01134
G1 X133.989 Y126.1 E.01094
G1 X134.312 Y126.119 E.0117
G1 X134.621 Y126.181 E.01137
G1 X134.919 Y126.282 E.01134
G1 X135.2 Y126.421 E.01134
G1 X135.462 Y126.595 E.01134
G1 X135.698 Y126.802 E.01134
G1 X135.905 Y127.038 E.01134
G1 X136.079 Y127.3 E.01134
G1 X136.218 Y127.581 E.01134
G1 X136.319 Y127.879 E.01134
G1 X136.38 Y128.187 E.01134
G1 X136.4 Y128.487 E.01087
G1 X136.4 Y137.513 E.3259
G1 X136.38 Y137.813 E.01087
G1 X136.319 Y138.121 E.01133
G1 X136.218 Y138.419 E.01134
G1 X136.079 Y138.701 E.01135
G1 X135.903 Y138.962 E.01137
G1 X135.692 Y139.199 E.01145
G1 X135.456 Y139.395 E.0111
G1 X135.171 Y139.567 E.01201
G1 X134.868 Y139.676 E.01164
G1 X134.564 Y139.734 E.01117
G1 X134 Y139.772 E.0204
G1 X133.436 Y139.734 E.0204
G1 X133.132 Y139.676 E.01116
G1 X132.83 Y139.567 E.01161
G1 X132.563 Y139.408 E.01121
G1 X132.308 Y139.2 E.01189
G1 X132.097 Y138.962 E.01149
G1 X131.921 Y138.701 E.01137
G1 X131.782 Y138.419 E.01135
G1 X131.681 Y138.121 E.01134
G1 X131.62 Y137.813 E.01134
G1 X131.6 Y137.513 E.01087
G1 X131.6 Y128.487 E.3259
G1 X131.62 Y128.187 E.01087
G1 X131.681 Y127.879 E.01133
G1 X131.782 Y127.58 E.01138
G1 X131.927 Y127.29 E.0117
G1 X132.095 Y127.038 E.01094
G1 X132.302 Y126.802 E.01134
G1 X132.538 Y126.595 E.01134
G1 X132.79 Y126.427 E.01094
G1 X133.036 Y126.304 E.0099
; WIPE_START
G1 X133.08 Y126.282 E-.01893
G1 X133.379 Y126.181 E-.11972
G1 X133.687 Y126.12 E-.11931
G1 X133.989 Y126.1 E-.11516
G1 X134.312 Y126.119 E-.1231
G1 X134.621 Y126.181 E-.11971
G1 X134.919 Y126.282 E-.11936
G1 X134.977 Y126.311 E-.0247
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X136.805 Y125.551 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.116843
G1 F1200
M204 S500
G1 X136.957 Y125.678 E.00115
M204 S6000
G1 X137.109 Y126.656 F30000
; LINE_WIDTH: 0.129998
G1 F1200
M204 S500
G1 X137.262 Y126.882 E.00187
; LINE_WIDTH: 0.176803
G1 X137.414 Y127.108 E.00288
M204 S6000
G1 X137.389 Y127.265 F30000
; LINE_WIDTH: 0.137628
G1 F1200
M204 S500
G1 X137.31 Y126.843 E.00321
; WIPE_START
G1 X137.389 Y127.265 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X136.462 Y119.689 Z.6 F30000
G1 X136.071 Y116.497 Z.6
G1 Z.2
G1 E.8 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50376
M204 S500
G1 X136.797 Y117.223 E.03739
G1 X136.797 Y117.875 E.02372
G1 X135.625 Y116.703 E.06035
G1 X134.973 Y116.703 E.02372
G1 X136.797 Y118.527 E.0939
G1 X136.797 Y119.178 E.02372
G1 X134.322 Y116.703 E.12746
G1 X133.67 Y116.703 E.02372
G1 X136.797 Y119.83 E.16101
G1 X136.797 Y120.482 E.02372
G1 X133.018 Y116.703 E.19456
G1 X132.366 Y116.703 E.02372
G1 X136.797 Y121.134 E.22811
G1 X136.797 Y121.785 E.02372
G1 X131.715 Y116.703 E.26166
G1 X131.063 Y116.703 E.02372
G1 X136.797 Y122.437 E.29522
G1 X136.797 Y123.089 E.02372
G1 X130.411 Y116.703 E.32877
G1 X129.76 Y116.703 E.02372
G1 X136.797 Y123.74 E.36232
G1 X136.797 Y124.392 E.02372
G1 X129.108 Y116.703 E.39587
G1 X128.456 Y116.703 E.02372
G1 X136.756 Y125.003 E.42731
G1 X136.597 Y125.194 E.00904
G1 X136.104 Y124.856 E.02177
G1 X135.816 Y124.714 E.01168
G1 X127.804 Y116.703 E.41246
G1 X127.153 Y116.703 E.02372
G1 X134.836 Y124.386 E.39553
G1 X134.544 Y124.328 E.01083
G1 X134.099 Y124.301 E.01623
G1 X126.501 Y116.703 E.39115
G1 X125.849 Y116.703 E.02372
G1 X133.474 Y124.327 E.39252
G1 X132.927 Y124.433 E.02025
G1 X125.197 Y116.703 E.39795
G1 X124.546 Y116.703 E.02372
G1 X132.439 Y124.596 E.40637
G1 X131.999 Y124.807 E.01778
G1 X123.894 Y116.703 E.41724
G1 X123.242 Y116.703 E.02372
G1 X131.596 Y125.057 E.43008
G1 X131.438 Y125.162 E.00691
G1 X131.232 Y125.344 E.01002
G1 X122.591 Y116.703 E.44486
G1 X121.939 Y116.703 E.02372
G1 X130.902 Y125.666 E.46142
G1 X130.606 Y126.022 E.01685
G1 X121.287 Y116.703 E.47978
G1 X120.635 Y116.703 E.02372
G1 X130.349 Y126.416 E.50006
G1 X130.132 Y126.851 E.01769
G1 X119.984 Y116.703 E.52244
G1 X119.332 Y116.703 E.02372
G1 X129.962 Y127.333 E.54728
G1 X129.845 Y127.868 E.01992
G1 X119.203 Y117.225 E.54789
G1 X119.203 Y117.877 E.02372
G1 X129.797 Y128.472 E.54543
G1 X129.797 Y129.123 E.02372
G1 X119.203 Y118.529 E.54543
G1 X119.203 Y119.18 E.02372
G1 X129.797 Y129.775 E.54543
G1 X129.797 Y130.427 E.02372
G1 X119.203 Y119.832 E.54543
G1 X119.203 Y120.484 E.02372
G1 X123.189 Y124.47 E.20521
G1 X122.544 Y124.328 E.02404
G1 X122.385 Y124.318 E.00579
G1 X119.203 Y121.135 E.16384
G1 X119.203 Y121.787 E.02372
G1 X121.726 Y124.311 E.12991
G1 X121.451 Y124.329 E.01004
G1 X121.152 Y124.388 E.0111
G1 X119.203 Y122.439 E.10035
G1 X119.203 Y123.091 E.02372
G1 X120.64 Y124.528 E.07399
G1 X120.385 Y124.615 E.0098
G1 X120.178 Y124.718 E.00842
G1 X119.203 Y123.742 E.05022
G1 X119.203 Y124.394 E.02372
G1 X119.906 Y125.097 E.0362
; WIPE_START
G1 X119.203 Y124.394 E-.37788
G1 X119.203 Y123.742 E-.24766
G1 X119.453 Y123.993 E-.13446
; WIPE_END
G1 E-.04
M204 S6000
G1 X125.701 Y126.982 Z.6 F30000
G1 Z.2
G1 E.8 F1800
M204 S500
G1 X129.797 Y131.078 E.21087
G1 X129.797 Y131.73 E.02372
G1 X126.182 Y128.115 E.18612
G1 X126.203 Y128.787 E.02448
G1 X129.797 Y132.382 E.18506
G1 X129.797 Y133.034 E.02372
G1 X126.203 Y129.439 E.18506
G1 X126.203 Y130.091 E.02372
G1 X129.797 Y133.685 E.18506
G1 X129.797 Y134.337 E.02372
G1 X126.203 Y130.742 E.18506
G1 X126.203 Y131.394 E.02372
G1 X129.797 Y134.989 E.18506
G1 X129.797 Y135.641 E.02372
G1 X126.203 Y132.046 E.18506
G1 X126.203 Y132.698 E.02372
G1 X129.797 Y136.292 E.18506
G1 X129.797 Y136.944 E.02372
G1 X126.203 Y133.349 E.18506
G1 X126.203 Y134.001 E.02372
G1 X129.799 Y137.597 E.18515
G1 X129.829 Y138.049 E.01649
G1 X129.879 Y138.301 E.00934
G1 X129.851 Y138.301 E.00101
G1 X126.203 Y134.653 E.18782
G1 X126.203 Y135.304 E.02372
G1 X129.199 Y138.301 E.15426
G1 X128.547 Y138.301 E.02372
M73 P36 R18
G1 X126.203 Y135.956 E.12071
G1 X126.203 Y136.608 E.02372
G1 X127.896 Y138.301 E.08716
G1 X127.244 Y138.301 E.02372
G1 X126.203 Y137.26 E.05361
G1 X126.182 Y137.89 E.02298
G1 X126.798 Y138.507 E.03172
; WIPE_START
G1 X126.182 Y137.89 E-.33111
G1 X126.203 Y137.26 E-.23985
G1 X126.554 Y137.611 E-.18904
; WIPE_END
G1 E-.04
M204 S6000
G1 X123.621 Y139.617 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.122399
G1 F1200
M204 S500
G1 X123.464 Y139.747 E.00128
; LINE_WIDTH: 0.161365
G1 X123.307 Y139.878 E.00191
M204 S6000
G1 X123.167 Y139.862 F30000
; LINE_WIDTH: 0.127022
G1 F1200
M204 S500
G1 X123.513 Y139.777 E.00236
; WIPE_START
G1 X123.167 Y139.862 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X120.489 Y139.779 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.129271
G1 F1200
M204 S500
G1 X120.851 Y139.868 E.00254
M204 S6000
G1 X120.699 Y139.882 F30000
; LINE_WIDTH: 0.162343
G1 F1200
M204 S500
G1 X120.54 Y139.751 E.00194
; LINE_WIDTH: 0.122722
G1 X120.382 Y139.62 E.0013
; WIPE_START
G1 X120.54 Y139.751 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X118.704 Y138.92 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.118208
G1 F1200
M204 S500
G1 X118.633 Y138.872 E.00051
G1 X118.611 Y138.735 E.00083
; WIPE_START
G1 X118.633 Y138.872 E-.47124
G1 X118.704 Y138.92 E-.28876
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X118.695 Y131.288 Z.6 F30000
G1 X118.689 Y126.843 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.138382
G1 F1200
M204 S500
G1 X118.611 Y127.265 E.00323
M204 S6000
G1 X118.586 Y127.108 F30000
; LINE_WIDTH: 0.175181
G1 F1200
M204 S500
G1 X118.738 Y126.881 E.00285
; LINE_WIDTH: 0.127006
G1 X118.89 Y126.654 E.00181
M204 S6000
G1 X119.043 Y125.678 F30000
; LINE_WIDTH: 0.116859
G1 F1200
M204 S500
G1 X119.195 Y125.551 E.00116
; WIPE_START
G1 X119.043 Y125.678 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X124.319 Y131.193 Z.6 F30000
G1 X132.382 Y139.62 Z.6
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.12236
G1 F1200
M204 S500
G1 X132.538 Y139.749 E.00127
; LINE_WIDTH: 0.161259
G1 X132.694 Y139.878 E.00189
M204 S6000
G1 X132.833 Y139.862 F30000
; LINE_WIDTH: 0.126661
G1 F1200
M204 S500
G1 X132.488 Y139.777 E.00235
; WIPE_START
G1 X132.833 Y139.862 E-.76
; WIPE_END
G1 E-.04 F1800
M204 S6000
G1 X135.511 Y139.779 Z.6 F30000
G1 Z.2
G1 E.8 F1800
; LINE_WIDTH: 0.129589
G1 F1200
M204 S500
G1 X135.149 Y139.868 E.00255
M204 S6000
G1 X135.301 Y139.882 F30000
; LINE_WIDTH: 0.162434
G1 F1200
M204 S500
G1 X135.461 Y139.749 E.00196
; LINE_WIDTH: 0.122756
G1 X135.621 Y139.617 E.00131
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F1200
G1 X135.461 Y139.749 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 2/152
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
G1 X133.154 Y126.458
G1 Z.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.428 Y126.365 E.00861
G1 X133.711 Y126.308 E.00861
G1 X133.968 Y126.292 E.00767
G1 X134.287 Y126.308 E.00951
G1 X134.572 Y126.365 E.00865
G1 X134.846 Y126.458 E.00861
G1 X135.105 Y126.586 E.00861
G1 X135.346 Y126.746 E.00861
G1 X135.563 Y126.937 E.00861
G1 X135.754 Y127.154 E.00861
G1 X135.914 Y127.395 E.00861
G1 X136.042 Y127.654 E.00861
G1 X136.135 Y127.928 E.00861
G1 X136.192 Y128.211 E.00861
G1 X136.21 Y128.493 E.00841
G1 X136.21 Y137.507 E.26848
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
G1 X136.042 Y138.346 E.00862
G1 X135.914 Y138.605 E.00861
G1 X135.754 Y138.846 E.00861
G1 X135.563 Y139.063 E.00861
G1 X135.346 Y139.254 E.00861
G1 X135.105 Y139.414 E.00861
G1 X134.846 Y139.542 E.00861
G1 X134.603 Y139.625 E.00763
G1 X134.29 Y139.691 E.00954
G1 X134 Y139.71 E.00866
G1 X133.711 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
G1 X132.895 Y139.414 E.00861
G1 X132.682 Y139.272 E.00763
G1 X132.437 Y139.063 E.00959
G1 X132.228 Y138.818 E.00958
G1 X132.086 Y138.605 E.00763
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.865 Y127.928 E.00861
G1 X131.958 Y127.654 E.00861
G1 X132.086 Y127.395 E.00861
G1 X132.246 Y127.154 E.00861
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.895 Y126.586 E.00861
G1 X133.118 Y126.475 E.00742
; WIPE_START
M204 S10000
G1 X133.428 Y126.365 E-.12496
G1 X133.711 Y126.308 E-.10986
G1 X133.968 Y126.292 E-.09787
G1 X134.287 Y126.308 E-.12126
G1 X134.572 Y126.365 E-.1104
G1 X134.846 Y126.458 E-.10988
G1 X135.048 Y126.558 E-.08578
; WIPE_END
G1 E-.04 F1800
G1 X127.44 Y127.164 Z.8 F30000
G1 X123.938 Y127.443 Z.8
G1 Z.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X124.042 Y127.654 E.00702
G1 X124.135 Y127.928 E.00861
G1 X124.192 Y128.211 E.00861
G1 X124.21 Y128.493 E.00841
G1 X124.21 Y137.507 E.26848
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.914 Y138.605 E.00861
G1 X123.754 Y138.846 E.00861
G1 X123.563 Y139.063 E.00861
G1 X123.346 Y139.254 E.00861
G1 X123.105 Y139.414 E.00861
G1 X122.846 Y139.542 E.00861
G1 X122.603 Y139.625 E.00763
G1 X122.29 Y139.691 E.00954
G1 X122 Y139.71 E.00866
G1 X121.711 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
G1 X120.895 Y139.414 E.00861
G1 X120.682 Y139.272 E.00763
G1 X120.437 Y139.063 E.00959
G1 X120.228 Y138.818 E.00958
G1 X120.086 Y138.605 E.00763
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.865 Y127.928 E.00861
M73 P37 R18
G1 X119.958 Y127.654 E.00861
G1 X120.086 Y127.395 E.00861
G1 X120.246 Y127.154 E.00861
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.895 Y126.586 E.00861
G1 X121.154 Y126.458 E.00861
G1 X121.428 Y126.365 E.00861
G1 X121.711 Y126.308 E.00861
G1 X121.968 Y126.292 E.00767
G1 X122.287 Y126.308 E.00951
G1 X122.572 Y126.365 E.00865
G1 X122.846 Y126.458 E.00861
G1 X123.105 Y126.586 E.00861
G1 X123.346 Y126.746 E.00861
G1 X123.563 Y126.937 E.00861
G1 X123.754 Y127.154 E.00861
G1 X123.914 Y127.395 E.00861
G1 X123.92 Y127.407 E.0004
; WIPE_START
M204 S10000
G1 X124.042 Y127.654 E-.10481
G1 X124.135 Y127.928 E-.10986
G1 X124.192 Y128.211 E-.10984
G1 X124.21 Y128.493 E-.10732
G1 X124.21 Y129.357 E-.32816
; WIPE_END
G1 E-.04 F1800
G1 X129.593 Y123.946 Z.8 F30000
G1 X137.541 Y115.959 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X137.541 Y127.547 E.37262
G1 X137.336 Y127.581 E.00666
G1 X137.199 Y127.175 E.01377
G1 X136.998 Y126.769 E.01457
G1 X136.747 Y126.392 E.01456
G1 X136.448 Y126.052 E.01457
G1 X136.108 Y125.753 E.01456
G1 X135.731 Y125.502 E.01456
G1 X135.325 Y125.301 E.01457
G1 X134.896 Y125.156 E.01456
G1 X134.442 Y125.065 E.01488
G1 X133.96 Y125.04 E.01553
G1 X133.548 Y125.067 E.01327
G1 X133.104 Y125.156 E.01456
G1 X132.675 Y125.301 E.01456
G1 X132.269 Y125.502 E.01457
G1 X131.892 Y125.753 E.01456
G1 X131.552 Y126.052 E.01456
G1 X131.253 Y126.392 E.01456
G1 X131.002 Y126.769 E.01456
G1 X130.801 Y127.175 E.01456
G1 X130.656 Y127.604 E.01457
G1 X130.567 Y128.048 E.01455
G1 X130.541 Y128.452 E.01303
G1 X130.541 Y137.548 E.29247
G1 X130.567 Y137.952 E.01303
G1 X130.656 Y138.396 E.01455
G1 X130.801 Y138.825 E.01457
G1 X130.908 Y139.041 E.00774
G1 X125.092 Y139.041 E.18701
G1 X125.199 Y138.825 E.00774
G1 X125.344 Y138.396 E.01457
G1 X125.433 Y137.952 E.01455
G1 X125.459 Y137.548 E.01303
G1 X125.459 Y128.452 E.29247
G1 X125.433 Y128.048 E.01303
G1 X125.344 Y127.604 E.01456
G1 X125.199 Y127.175 E.01456
G1 X124.998 Y126.769 E.01457
G1 X124.747 Y126.392 E.01456
G1 X124.448 Y126.052 E.01457
G1 X124.108 Y125.753 E.01456
G1 X123.731 Y125.502 E.01456
G1 X123.325 Y125.301 E.01457
G1 X122.896 Y125.156 E.01456
G1 X122.442 Y125.065 E.01488
G1 X121.96 Y125.04 E.01553
G1 X121.548 Y125.067 E.01327
G1 X121.104 Y125.156 E.01456
G1 X120.675 Y125.301 E.01456
G1 X120.269 Y125.502 E.01457
G1 X119.892 Y125.753 E.01456
G1 X119.552 Y126.052 E.01456
G1 X119.253 Y126.392 E.01456
G1 X119.002 Y126.769 E.01456
G1 X118.801 Y127.175 E.01456
G1 X118.664 Y127.581 E.01378
G1 X118.459 Y127.547 E.00666
G1 X118.459 Y115.959 E.37263
G1 X137.501 Y115.959 E.61231
; WIPE_START
G1 X137.508 Y117.959 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.444 Y125.591 Z.8 F30000
G1 X137.336 Y138.419 Z.8
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X137.541 Y138.453 E.00666
G1 X137.541 Y139.041 E.01891
G1 X137.092 Y139.041 E.01443
G1 X137.199 Y138.825 E.00774
G1 X137.324 Y138.457 E.0125
; WIPE_START
G1 X137.541 Y138.453 E-.08772
G1 X137.541 Y139.041 E-.23729
G1 X137.092 Y139.041 E-.18105
G1 X137.199 Y138.825 E-.09712
G1 X137.324 Y138.457 E-.15683
; WIPE_END
G1 E-.04 F1800
G1 X129.691 Y138.442 Z.8 F30000
G1 X118.664 Y138.419 Z.8
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X118.801 Y138.825 E.01378
G1 X118.908 Y139.041 E.00774
G1 X118.459 Y139.041 E.01443
G1 X118.459 Y138.453 E.01891
G1 X118.624 Y138.426 E.00538
; WIPE_START
G1 X118.801 Y138.825 E-.17647
G1 X118.908 Y139.041 E-.09724
G1 X118.459 Y139.041 E-.18122
G1 X118.459 Y138.453 E-.23752
G1 X118.624 Y138.426 E-.06756
; WIPE_END
G1 E-.04 F1800
G1 X123.55 Y132.595 Z.8 F30000
G1 X137.948 Y115.552 Z.8
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X137.948 Y139.448 E.7684
G1 X136.364 Y139.448 E.05094
G1 X136.645 Y139.027 E.01627
G1 X136.822 Y138.669 E.01285
G1 X136.95 Y138.29 E.01285
G1 X137.028 Y137.899 E.01284
G1 X137.052 Y137.534 E.01175
G1 X137.052 Y128.466 E.29161
G1 X137.028 Y128.101 E.01175
G1 X136.95 Y127.709 E.01285
G1 X136.822 Y127.331 E.01284
G1 X136.645 Y126.973 E.01285
G1 X136.423 Y126.641 E.01284
G1 X136.16 Y126.34 E.01285
G1 X135.859 Y126.077 E.01284
G1 X135.527 Y125.855 E.01285
G1 X135.169 Y125.678 E.01285
G1 X134.79 Y125.55 E.01285
G1 X134.392 Y125.47 E.01308
G1 X133.963 Y125.448 E.01381
G1 X133.601 Y125.472 E.01164
G1 X133.21 Y125.55 E.01285
G1 X132.831 Y125.678 E.01285
G1 X132.473 Y125.855 E.01285
G1 X132.141 Y126.077 E.01285
G1 X131.84 Y126.34 E.01284
G1 X131.577 Y126.641 E.01285
G1 X131.355 Y126.973 E.01284
G1 X131.178 Y127.331 E.01285
G1 X131.05 Y127.71 E.01285
G1 X130.972 Y128.101 E.01284
G1 X130.948 Y128.466 E.01175
G1 X130.948 Y137.534 E.29161
G1 X130.972 Y137.899 E.01175
G1 X131.05 Y138.29 E.01284
G1 X131.178 Y138.669 E.01285
G1 X131.355 Y139.027 E.01285
G1 X131.636 Y139.448 E.01627
G1 X124.364 Y139.448 E.23384
G1 X124.645 Y139.027 E.01627
G1 X124.822 Y138.669 E.01285
G1 X124.95 Y138.29 E.01285
G1 X125.028 Y137.899 E.01284
G1 X125.052 Y137.534 E.01175
G1 X125.052 Y128.466 E.29161
G1 X125.028 Y128.101 E.01175
G1 X124.95 Y127.709 E.01285
G1 X124.822 Y127.331 E.01284
G1 X124.645 Y126.973 E.01285
G1 X124.423 Y126.641 E.01284
G1 X124.16 Y126.34 E.01285
G1 X123.859 Y126.077 E.01284
G1 X123.527 Y125.855 E.01285
G1 X123.169 Y125.678 E.01285
G1 X122.79 Y125.55 E.01285
G1 X122.392 Y125.47 E.01308
G1 X121.963 Y125.448 E.01381
G1 X121.601 Y125.472 E.01164
G1 X121.21 Y125.55 E.01285
G1 X120.831 Y125.678 E.01285
G1 X120.473 Y125.855 E.01285
G1 X120.141 Y126.077 E.01285
G1 X119.84 Y126.34 E.01284
G1 X119.577 Y126.641 E.01285
G1 X119.355 Y126.973 E.01284
G1 X119.178 Y127.331 E.01285
G1 X119.05 Y127.71 E.01285
G1 X118.972 Y128.101 E.01284
G1 X118.948 Y128.466 E.01175
G1 X118.948 Y137.534 E.29161
G1 X118.972 Y137.899 E.01175
G1 X119.05 Y138.29 E.01284
G1 X119.178 Y138.669 E.01285
G1 X119.355 Y139.027 E.01285
G1 X119.636 Y139.448 E.01627
G1 X118.052 Y139.448 E.05094
G1 X118.052 Y115.552 E.7684
G1 X137.908 Y115.552 E.63849
G1 X138.355 Y115.145 F30000
G1 F3600
G1 X138.355 Y139.855 E.79458
G1 X135.541 Y139.855 E.0905
G1 X135.488 Y139.682 E.00582
G1 X135.611 Y139.599 E.00476
G1 X135.871 Y139.371 E.01113
G1 X136.1 Y139.111 E.01113
G1 X136.292 Y138.823 E.01113
G1 X136.445 Y138.513 E.01113
G1 X136.556 Y138.185 E.01114
G1 X136.624 Y137.846 E.01113
G1 X136.645 Y137.521 E.01046
G1 X136.645 Y128.479 E.29076
G1 X136.624 Y128.154 E.01046
G1 X136.556 Y127.815 E.01113
G1 X136.445 Y127.487 E.01113
G1 X136.292 Y127.177 E.01114
G1 X136.1 Y126.889 E.01113
G1 X135.871 Y126.629 E.01113
G1 X135.611 Y126.401 E.01113
G1 X135.323 Y126.208 E.01113
G1 X135.013 Y126.055 E.01113
G1 X134.685 Y125.944 E.01113
G1 X134.341 Y125.875 E.01127
G1 X133.965 Y125.856 E.01209
G1 X133.655 Y125.876 E.01002
G1 X133.315 Y125.944 E.01113
G1 X132.987 Y126.055 E.01113
G1 X132.677 Y126.208 E.01114
G1 X132.389 Y126.401 E.01113
G1 X132.129 Y126.629 E.01113
G1 X131.9 Y126.889 E.01113
G1 X131.708 Y127.177 E.01113
G1 X131.555 Y127.487 E.01113
G1 X131.444 Y127.815 E.01114
G1 X131.376 Y128.154 E.01112
G1 X131.355 Y128.479 E.01046
G1 X131.355 Y137.521 E.29076
G1 X131.376 Y137.846 E.01046
G1 X131.444 Y138.185 E.01113
G1 X131.555 Y138.513 E.01113
G1 X131.708 Y138.823 E.01113
G1 X131.881 Y139.081 E.00998
G1 X132.128 Y139.372 E.01228
G1 X132.512 Y139.682 E.01586
G1 X132.459 Y139.855 E.00582
G1 X123.541 Y139.855 E.2868
G1 X123.488 Y139.682 E.00582
G1 X123.611 Y139.599 E.00476
G1 X123.871 Y139.371 E.01113
G1 X124.1 Y139.111 E.01113
G1 X124.292 Y138.823 E.01113
G1 X124.445 Y138.513 E.01113
G1 X124.556 Y138.185 E.01113
G1 X124.624 Y137.846 E.01113
G1 X124.645 Y137.521 E.01046
G1 X124.645 Y128.479 E.29076
G1 X124.624 Y128.154 E.01046
G1 X124.556 Y127.815 E.01113
G1 X124.445 Y127.487 E.01113
G1 X124.292 Y127.177 E.01114
G1 X124.1 Y126.889 E.01113
G1 X123.871 Y126.629 E.01113
G1 X123.611 Y126.401 E.01113
G1 X123.323 Y126.208 E.01113
G1 X123.013 Y126.055 E.01113
G1 X122.685 Y125.944 E.01113
G1 X122.341 Y125.875 E.01127
G1 X121.965 Y125.856 E.01209
G1 X121.655 Y125.876 E.01002
G1 X121.315 Y125.944 E.01113
G1 X120.987 Y126.055 E.01113
G1 X120.677 Y126.208 E.01114
G1 X120.389 Y126.401 E.01113
G1 X120.129 Y126.629 E.01113
G1 X119.9 Y126.889 E.01113
G1 X119.708 Y127.177 E.01113
G1 X119.555 Y127.487 E.01113
G1 X119.444 Y127.815 E.01114
G1 X119.376 Y128.154 E.01112
G1 X119.355 Y128.479 E.01046
G1 X119.355 Y137.521 E.29076
G1 X119.376 Y137.846 E.01046
G1 X119.444 Y138.185 E.01113
G1 X119.555 Y138.513 E.01113
G1 X119.708 Y138.823 E.01113
G1 X119.881 Y139.081 E.00998
G1 X120.128 Y139.372 E.01228
G1 X120.512 Y139.682 E.01586
G1 X120.459 Y139.855 E.00582
G1 X117.645 Y139.855 E.0905
G1 X117.645 Y115.145 E.79458
G1 X138.315 Y115.145 E.66467
M204 S250
G1 X138.79 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
; WIPE_START
M204 S10000
G1 X138.753 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.524 Y124.243 Z.8 F30000
G1 X137.144 Y126.575 Z.8
G1 Z.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.124425
G1 F15000
G1 X137.337 Y126.854 E.00219
G1 X137.179 Y127.813 F30000
; LINE_WIDTH: 0.534809
G1 F4879.151
G1 X137.485 Y128.025 E.01448
G1 X137.487 Y128.058 E.00126
G1 X137.5 Y128.459 E.0156
G1 X137.5 Y137.541 E.35289
G1 X137.485 Y137.974 E.01685
G1 X137.178 Y138.186 E.01449
; WIPE_START
G1 X137.485 Y137.974 E-.14166
G1 X137.5 Y137.541 E-.1648
G1 X137.5 Y136.348 E-.45354
; WIPE_END
G1 E-.04 F1800
G1 X136.038 Y139.527 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.108328
G1 F15000
G1 X135.929 Y139.651 E.00086
G1 X135.308 Y139.839 F30000
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X134.984 Y139.904 E.00895
; LINE_WIDTH: 0.357438
G1 F7630.744
G1 X134.842 Y139.927 E.00357
; LINE_WIDTH: 0.310632
G1 F8964.874
G1 X134.7 Y139.95 E.00304
; LINE_WIDTH: 0.285317
G1 F9901.116
G1 X134.686 Y139.952 E.00027
; LINE_WIDTH: 0.265005
G1 F10806.71
G1 X134.512 Y139.971 E.00308
; LINE_WIDTH: 0.226977
G1 F13039.486
G1 X134.325 Y139.99 E.00272
; LINE_WIDTH: 0.197648
G1 F15000
G1 X133.667 Y139.989 E.00805
; LINE_WIDTH: 0.224994
G1 F13181.497
G1 X133.508 Y139.974 E.00229
; LINE_WIDTH: 0.2578
G1 F11169.049
G1 X133.334 Y139.956 E.00297
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X133.228 Y139.939 E.00212
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X133.122 Y139.921 E.00242
; LINE_WIDTH: 0.379929
G1 F7121.485
G1 X132.692 Y139.839 E.01167
G1 X132.072 Y139.651 F30000
; LINE_WIDTH: 0.108612
G1 F15000
G1 X131.963 Y139.529 E.00085
; WIPE_START
G1 X132.072 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.887 Y138.877 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42215
G1 F3600
G1 X130.325 Y138.44 E.01854
G1 X130.236 Y137.992 E.01367
G1 X129.52 Y138.708 E.03032
G1 X128.984 Y138.708 E.01607
G1 X130.208 Y137.484 E.05184
G1 X130.208 Y136.948 E.01607
G1 X128.448 Y138.708 E.07456
G1 X127.911 Y138.708 E.01607
G1 X130.208 Y136.411 E.09728
G1 X130.208 Y135.875 E.01607
G1 X127.375 Y138.708 E.12
G1 X126.839 Y138.708 E.01607
G1 X130.208 Y135.339 E.14272
G1 X130.208 Y134.802 E.01607
G1 X126.302 Y138.708 E.16544
G1 X125.766 Y138.708 E.01607
G1 X130.208 Y134.266 E.18817
G1 X130.208 Y133.73 E.01607
G1 X125.72 Y138.218 E.19014
G1 X125.764 Y137.996 E.00678
G1 X125.789 Y137.612 E.01151
G1 X130.208 Y133.193 E.1872
G1 X130.208 Y132.657 E.01607
G1 X125.792 Y137.072 E.18705
G1 X125.792 Y136.536 E.01607
G1 X130.208 Y132.121 E.18705
G1 X130.208 Y131.584 E.01607
G1 X125.792 Y136 E.18705
G1 X125.792 Y135.463 E.01607
G1 X130.208 Y131.048 E.18705
G1 X130.208 Y130.512 E.01607
G1 X125.792 Y134.927 E.18705
G1 X125.792 Y134.391 E.01607
G1 X130.208 Y129.976 E.18705
G1 X130.208 Y129.439 E.01607
G1 X125.792 Y133.854 E.18705
G1 X125.792 Y133.318 E.01607
G1 X130.208 Y128.903 E.18705
G1 X130.213 Y128.361 E.01622
G1 X125.792 Y132.782 E.18727
G1 X125.792 Y132.246 E.01607
G1 X130.508 Y127.53 E.19978
; WIPE_START
G1 X129.094 Y128.944 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.256 Y126.306 Z.8 F30000
G1 X136.735 Y126.13 Z.8
G1 Z.4
G1 E.8 F1800
G1 F3600
G1 X137.208 Y125.657 E.02004
G1 X137.208 Y125.121 E.01607
G1 X136.593 Y125.735 E.02604
G1 X136.307 Y125.485 E.01139
G1 X137.208 Y124.584 E.03817
G1 X137.208 Y124.048 E.01607
G1 X135.985 Y125.271 E.05178
G1 X135.636 Y125.083 E.01187
G1 X137.208 Y123.512 E.06657
G1 X137.208 Y122.976 E.01607
G1 X135.257 Y124.926 E.08264
G1 X134.982 Y124.833 E.00868
G1 X134.842 Y124.805 E.0043
G1 X137.208 Y122.439 E.10023
G1 X137.208 Y121.903 E.01607
G1 X134.382 Y124.729 E.11971
G1 X133.861 Y124.713 E.0156
G1 X137.208 Y121.367 E.14176
G1 X137.208 Y120.83 E.01607
G1 X133.03 Y125.008 E.17699
G1 X137.377 Y120.124 F30000
G1 F3600
G1 X132.472 Y125.03 E.20783
G1 X132.102 Y125.212 E.01235
G1 X131.689 Y125.488 E.01487
G1 X131.316 Y125.816 E.01487
G1 X130.988 Y126.189 E.01488
G1 X130.712 Y126.602 E.01487
G1 X130.53 Y126.972 E.01236
G1 X125.792 Y131.709 E.20071
G1 X125.792 Y131.173 E.01607
G1 X137.208 Y119.758 E.4836
G1 X137.208 Y119.221 E.01607
G1 X125.792 Y130.637 E.4836
G1 X125.792 Y130.1 E.01607
G1 X137.208 Y118.685 E.4836
G1 X137.208 Y118.149 E.01607
G1 X125.792 Y129.564 E.4836
G1 X125.792 Y129.028 E.01607
G1 X137.208 Y117.612 E.4836
G1 X137.208 Y117.076 E.01607
G1 X125.792 Y128.491 E.4836
G1 X125.76 Y127.987 E.01514
G1 X137.208 Y116.54 E.48496
G1 X137.208 Y116.292 E.00741
G1 X136.919 Y116.292 E.00865
G1 X125.671 Y127.54 E.47649
G1 X125.538 Y127.137 E.01271
G1 X136.382 Y116.292 E.45943
G1 X135.846 Y116.292 E.01607
G1 X125.37 Y126.769 E.44382
G1 X125.288 Y126.602 E.00557
G1 X125.173 Y126.43 E.0062
G1 X135.31 Y116.292 E.42946
G1 X134.773 Y116.292 E.01607
G1 X124.949 Y126.117 E.41622
G1 X124.698 Y125.831 E.01138
G1 X134.237 Y116.292 E.40412
G1 X133.701 Y116.292 E.01607
G1 X124.414 Y125.579 E.39342
G1 X124.106 Y125.351 E.01149
G1 X133.165 Y116.292 E.38377
G1 X132.628 Y116.292 E.01607
G1 X123.771 Y125.15 E.37524
G1 X123.407 Y124.977 E.01206
G1 X132.092 Y116.292 E.36793
G1 X131.556 Y116.292 E.01607
G1 X123.007 Y124.841 E.36217
G1 X122.562 Y124.749 E.0136
G1 X131.019 Y116.292 E.35828
G1 X130.483 Y116.292 E.01607
G1 X122.063 Y124.712 E.3567
G1 X121.502 Y124.737 E.01682
G1 X129.947 Y116.292 E.35774
G1 X129.41 Y116.292 E.01607
G1 X120.495 Y125.208 E.37769
G1 X118.817 Y126.349 F30000
G1 F3600
G1 X128.874 Y116.292 E.42605
G1 X128.338 Y116.292 E.01607
G1 X118.792 Y125.838 E.40439
G1 X118.792 Y125.301 E.01607
G1 X127.801 Y116.292 E.38167
G1 X127.265 Y116.292 E.01607
G1 X118.792 Y124.765 E.35894
G1 X118.792 Y124.229 E.01607
G1 X126.729 Y116.292 E.33622
G1 X126.192 Y116.292 E.01607
G1 X118.792 Y123.692 E.3135
G1 X118.792 Y123.156 E.01607
G1 X125.656 Y116.292 E.29078
G1 X125.12 Y116.292 E.01607
G1 X118.792 Y122.62 E.26806
G1 X118.792 Y122.084 E.01607
G1 X124.584 Y116.292 E.24534
G1 X124.047 Y116.292 E.01607
G1 X118.792 Y121.547 E.22262
G1 X118.792 Y121.011 E.01607
G1 X123.511 Y116.292 E.1999
G1 X122.975 Y116.292 E.01607
G1 X118.792 Y120.475 E.17718
G1 X118.792 Y119.938 E.01607
G1 X122.438 Y116.292 E.15446
G1 X121.902 Y116.292 E.01607
G1 X118.792 Y119.402 E.13174
G1 X118.792 Y118.866 E.01607
G1 X121.366 Y116.292 E.10902
G1 X120.829 Y116.292 E.01607
G1 X118.792 Y118.329 E.0863
G1 X118.792 Y117.793 E.01607
G1 X120.293 Y116.292 E.06357
G1 X119.757 Y116.292 E.01607
G1 X118.792 Y117.257 E.04085
G1 X118.792 Y116.72 E.01607
G1 X119.39 Y116.123 E.02532
G1 X118.856 Y126.575 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.124444
G1 F15000
G1 X118.663 Y126.854 E.00219
G1 X118.82 Y127.813 F30000
; LINE_WIDTH: 0.534803
G1 F4879.209
G1 X118.515 Y128.026 E.01446
G1 X118.5 Y128.459 E.01685
G1 X118.5 Y137.541 E.35289
G1 X118.513 Y137.942 E.0156
G1 X118.515 Y137.974 E.00125
G1 X118.82 Y138.187 E.01444
; WIPE_START
G1 X118.515 Y137.974 E-.14121
G1 X118.513 Y137.942 E-.01227
M73 P37 R17
G1 X118.5 Y137.541 E-.15254
G1 X118.5 Y136.346 E-.45397
; WIPE_END
G1 E-.04 F1800
G1 X119.963 Y139.529 Z.8 F30000
G1 Z.4
G1 E.8 F1800
; LINE_WIDTH: 0.108612
G1 F15000
G1 X120.072 Y139.651 E.00085
G1 X120.692 Y139.839 F30000
; LINE_WIDTH: 0.379928
G1 F7121.496
G1 X121.122 Y139.921 E.01167
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X121.228 Y139.939 E.00242
; LINE_WIDTH: 0.293374
M73 P38 R17
G1 F9582.623
G1 X121.334 Y139.956 E.00212
; LINE_WIDTH: 0.2578
G1 F11169.054
G1 X121.508 Y139.974 E.00297
; LINE_WIDTH: 0.224994
G1 F13181.497
G1 X121.667 Y139.989 E.00229
; LINE_WIDTH: 0.197648
G1 F15000
G1 X122.325 Y139.99 E.00805
; LINE_WIDTH: 0.226977
G1 F13039.486
G1 X122.512 Y139.971 E.00272
; LINE_WIDTH: 0.265005
G1 F10806.71
G1 X122.686 Y139.952 E.00308
; LINE_WIDTH: 0.285317
G1 F9901.116
G1 X122.7 Y139.95 E.00027
; LINE_WIDTH: 0.310632
G1 F8964.874
G1 X122.842 Y139.927 E.00304
; LINE_WIDTH: 0.357438
G1 F7630.744
G1 X122.984 Y139.904 E.00357
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X123.308 Y139.839 E.00895
G1 X123.929 Y139.651 F30000
; LINE_WIDTH: 0.108326
G1 F15000
G1 X124.038 Y139.527 E.00086
; CHANGE_LAYER
; Z_HEIGHT: 0.475
; LAYER_HEIGHT: 0.075
; WIPE_START
G1 F15000
G1 X123.929 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 3/152
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
G1 X125.123 Y111.803
G1 Z.475
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F3000
G1 X125.123 Y113.911 E.08266
G1 X119.369 Y113.911 E.22562
G1 X119.369 Y111.615 E.09005
G1 X125.123 Y111.615 E.22562
G1 X125.123 Y108.738 E.11281
G1 X119.369 Y108.738 E.22562
; WIPE_START
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z.875 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z.875
G1 Z.475
G1 E.8 F1800
G1 F3000
G1 X136.631 Y108.738 E.22562
G1 X136.631 Y111.615 E.11281
G1 X130.877 Y111.615 E.22562
G1 X130.877 Y113.911 E.09005
G1 X136.631 Y113.911 E.22562
G1 X136.631 Y111.803 E.08266
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.125
; WIPE_START
G1 X136.631 Y113.803 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 4/152
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
G17
G3 Z.875 I1.217 J0 P1  F30000
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
G1 X133.152 Y126.458
G1 Z.6
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F2400
M204 S5000
G1 X133.428 Y126.365 E.00868
G1 X133.711 Y126.308 E.00861
G1 X133.948 Y126.293 E.00705
G1 X134.286 Y126.308 E.0101
G1 X134.572 Y126.365 E.00868
G1 X134.846 Y126.458 E.00861
G1 X135.105 Y126.586 E.00861
G1 X135.346 Y126.746 E.00861
G1 X135.563 Y126.937 E.00861
G1 X135.754 Y127.154 E.00861
G1 X135.914 Y127.395 E.00861
G1 X136.042 Y127.654 E.00861
G1 X136.135 Y127.928 E.0086
G1 X136.192 Y128.211 E.00862
G1 X136.21 Y128.493 E.00841
G1 X136.21 Y137.507 E.26848
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
G1 X136.042 Y138.346 E.00861
G1 X135.914 Y138.605 E.00861
G1 X135.754 Y138.846 E.00861
G1 X135.563 Y139.063 E.00861
G1 X135.387 Y139.218 E.00699
G1 X135.107 Y139.413 E.01016
G1 X134.846 Y139.542 E.00868
G1 X134.572 Y139.635 E.00861
G1 X134.289 Y139.692 E.00861
G1 X134 Y139.71 E.00861
G1 X133.711 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
G1 X132.895 Y139.414 E.00861
G1 X132.654 Y139.254 E.00861
G1 X132.437 Y139.063 E.00861
G1 X132.246 Y138.846 E.00861
G1 X132.086 Y138.605 E.00861
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.865 Y127.928 E.00861
G1 X131.959 Y127.652 E.00868
G1 X132.115 Y127.351 E.0101
G1 X132.246 Y127.154 E.00705
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.851 Y126.615 E.00705
G1 X133.116 Y126.477 E.00891
; WIPE_START
M204 S10000
G1 X133.428 Y126.365 E-.12577
G1 X133.711 Y126.308 E-.10987
G1 X133.948 Y126.293 E-.08992
G1 X134.286 Y126.308 E-.12886
G1 X134.572 Y126.365 E-.11071
G1 X134.846 Y126.458 E-.10988
G1 X135.047 Y126.557 E-.08501
; WIPE_END
G1 E-.04 F1800
G1 X127.437 Y127.15 Z1 F30000
G1 X123.929 Y127.424 Z1
G1 Z.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X124.042 Y127.654 E.00764
G1 X124.135 Y127.928 E.0086
G1 X124.192 Y128.211 E.00862
G1 X124.21 Y128.493 E.00841
G1 X124.21 Y137.507 E.26848
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.914 Y138.605 E.00861
G1 X123.754 Y138.846 E.00861
G1 X123.563 Y139.063 E.00861
G1 X123.387 Y139.218 E.00699
G1 X123.107 Y139.413 E.01016
G1 X122.846 Y139.542 E.00868
G1 X122.572 Y139.635 E.00861
G1 X122.289 Y139.692 E.00861
G1 X122 Y139.71 E.00861
G1 X121.711 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
G1 X120.895 Y139.414 E.00861
G1 X120.654 Y139.254 E.00861
G1 X120.437 Y139.063 E.00861
G1 X120.246 Y138.846 E.00861
G1 X120.086 Y138.605 E.00861
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.865 Y127.928 E.00861
G1 X119.959 Y127.652 E.00868
G1 X120.115 Y127.351 E.0101
G1 X120.246 Y127.154 E.00705
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.851 Y126.615 E.00705
G1 X121.152 Y126.458 E.0101
G1 X121.428 Y126.365 E.00868
G1 X121.711 Y126.308 E.00861
G1 X121.948 Y126.293 E.00705
G1 X122.286 Y126.308 E.0101
G1 X122.572 Y126.365 E.00868
G1 X122.846 Y126.458 E.00861
G1 X123.105 Y126.586 E.00861
G1 X123.346 Y126.746 E.00861
G1 X123.563 Y126.937 E.00861
G1 X123.754 Y127.154 E.00861
G1 X123.91 Y127.389 E.00839
; WIPE_START
M204 S10000
G1 X124.042 Y127.654 E-.11271
G1 X124.135 Y127.928 E-.10977
G1 X124.192 Y128.211 E-.10994
G1 X124.21 Y128.493 E-.10732
G1 X124.21 Y129.336 E-.32026
; WIPE_END
G1 E-.04 F1800
G1 X129.598 Y123.93 Z1 F30000
G1 X137.541 Y115.959 Z1
G1 Z.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X137.541 Y127.547 E.37263
G1 X137.336 Y127.581 E.00666
G1 X137.199 Y127.175 E.01378
G1 X136.998 Y126.769 E.01456
G1 X136.747 Y126.392 E.01457
G1 X136.448 Y126.052 E.01456
G1 X136.108 Y125.753 E.01456
G1 X135.731 Y125.502 E.01457
G1 X135.325 Y125.301 E.01456
G1 X134.896 Y125.156 E.01457
G1 X134.437 Y125.064 E.01506
G1 X133.934 Y125.042 E.01616
G1 X133.548 Y125.067 E.01245
G1 X133.104 Y125.156 E.01457
G1 X132.66 Y125.306 E.01506
G1 X132.214 Y125.538 E.01617
G1 X131.892 Y125.753 E.01246
G1 X131.552 Y126.052 E.01456
G1 X131.253 Y126.392 E.01456
G1 X131.038 Y126.714 E.01246
G1 X130.806 Y127.16 E.01617
G1 X130.656 Y127.604 E.01506
G1 X130.567 Y128.048 E.01455
G1 X130.541 Y128.452 E.01303
G1 X130.541 Y137.548 E.29247
G1 X130.567 Y137.952 E.01303
G1 X130.656 Y138.396 E.01455
G1 X130.801 Y138.825 E.01457
G1 X130.908 Y139.041 E.00774
G1 X125.092 Y139.041 E.18701
G1 X125.199 Y138.825 E.00774
G1 X125.344 Y138.396 E.01457
G1 X125.433 Y137.952 E.01456
G1 X125.459 Y137.548 E.01303
G1 X125.459 Y128.452 E.29247
G1 X125.433 Y128.048 E.01303
G1 X125.344 Y127.604 E.01457
G1 X125.199 Y127.175 E.01455
G1 X124.998 Y126.769 E.01456
G1 X124.747 Y126.392 E.01457
G1 X124.448 Y126.052 E.01456
G1 X124.108 Y125.753 E.01456
G1 X123.731 Y125.502 E.01457
G1 X123.325 Y125.301 E.01456
G1 X122.896 Y125.156 E.01457
G1 X122.437 Y125.064 E.01506
G1 X121.934 Y125.042 E.01616
G1 X121.548 Y125.067 E.01245
G1 X121.104 Y125.156 E.01457
G1 X120.66 Y125.306 E.01506
G1 X120.214 Y125.538 E.01617
G1 X119.892 Y125.753 E.01246
G1 X119.552 Y126.052 E.01456
G1 X119.253 Y126.392 E.01456
G1 X119.038 Y126.714 E.01246
G1 X118.806 Y127.16 E.01617
G1 X118.664 Y127.581 E.01427
G1 X118.459 Y127.547 E.00666
G1 X118.459 Y115.959 E.37262
G1 X137.501 Y115.959 E.61231
; WIPE_START
G1 X137.508 Y117.959 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.444 Y125.591 Z1 F30000
G1 X137.336 Y138.419 Z1
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X137.541 Y138.453 E.00666
G1 X137.541 Y139.041 E.01891
G1 X137.092 Y139.041 E.01443
G1 X137.199 Y138.825 E.00774
G1 X137.324 Y138.457 E.01249
; WIPE_START
G1 X137.541 Y138.453 E-.08772
G1 X137.541 Y139.041 E-.23728
G1 X137.092 Y139.041 E-.18105
G1 X137.199 Y138.825 E-.09713
G1 X137.324 Y138.457 E-.15682
; WIPE_END
G1 E-.04 F1800
G1 X129.691 Y138.442 Z1 F30000
G1 X118.664 Y138.419 Z1
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X118.801 Y138.825 E.01378
G1 X118.908 Y139.041 E.00774
G1 X118.459 Y139.041 E.01443
G1 X118.459 Y138.453 E.01891
G1 X118.624 Y138.426 E.00538
; WIPE_START
G1 X118.801 Y138.825 E-.17648
G1 X118.908 Y139.041 E-.09722
G1 X118.459 Y139.041 E-.18122
G1 X118.459 Y138.453 E-.23752
G1 X118.624 Y138.426 E-.06756
; WIPE_END
G1 E-.04 F1800
G1 X123.55 Y132.595 Z1 F30000
G1 X137.948 Y115.552 Z1
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X137.948 Y139.448 E.7684
G1 X136.364 Y139.448 E.05094
G1 X136.645 Y139.027 E.01627
G1 X136.822 Y138.669 E.01285
G1 X136.95 Y138.29 E.01285
G1 X137.028 Y137.899 E.01284
G1 X137.052 Y137.534 E.01175
G1 X137.052 Y128.466 E.29161
G1 X137.028 Y128.101 E.01175
G1 X136.95 Y127.709 E.01285
G1 X136.822 Y127.331 E.01284
G1 X136.645 Y126.973 E.01285
G1 X136.423 Y126.641 E.01285
G1 X136.16 Y126.34 E.01284
G1 X135.859 Y126.077 E.01284
G1 X135.527 Y125.855 E.01285
G1 X135.169 Y125.678 E.01284
G1 X134.79 Y125.55 E.01285
G1 X134.388 Y125.47 E.01321
G1 X133.939 Y125.45 E.01445
G1 X133.601 Y125.472 E.01087
G1 X133.209 Y125.55 E.01285
G1 X132.821 Y125.682 E.01321
G1 X132.422 Y125.889 E.01446
G1 X132.14 Y126.077 E.01088
G1 X131.84 Y126.34 E.01284
G1 X131.577 Y126.641 E.01284
G1 X131.389 Y126.922 E.01088
G1 X131.182 Y127.321 E.01445
G1 X131.05 Y127.71 E.01321
G1 X130.972 Y128.101 E.01284
G1 X130.948 Y128.466 E.01174
G1 X130.948 Y137.534 E.29161
G1 X130.972 Y137.899 E.01175
G1 X131.05 Y138.29 E.01284
G1 X131.178 Y138.669 E.01285
G1 X131.355 Y139.027 E.01285
G1 X131.636 Y139.448 E.01627
G1 X124.364 Y139.448 E.23384
G1 X124.645 Y139.027 E.01627
G1 X124.822 Y138.669 E.01285
G1 X124.95 Y138.29 E.01285
G1 X125.028 Y137.899 E.01284
G1 X125.052 Y137.534 E.01175
G1 X125.052 Y128.466 E.29161
G1 X125.028 Y128.101 E.01175
G1 X124.95 Y127.709 E.01285
G1 X124.822 Y127.331 E.01284
G1 X124.645 Y126.973 E.01285
G1 X124.423 Y126.641 E.01285
G1 X124.16 Y126.34 E.01284
G1 X123.859 Y126.077 E.01284
G1 X123.527 Y125.855 E.01285
G1 X123.169 Y125.678 E.01284
G1 X122.79 Y125.55 E.01285
G1 X122.388 Y125.47 E.01321
G1 X121.939 Y125.45 E.01445
G1 X121.601 Y125.472 E.01087
G1 X121.209 Y125.55 E.01285
G1 X120.821 Y125.682 E.01321
G1 X120.422 Y125.889 E.01446
G1 X120.14 Y126.077 E.01088
G1 X119.84 Y126.34 E.01284
G1 X119.577 Y126.641 E.01284
G1 X119.389 Y126.922 E.01088
G1 X119.182 Y127.321 E.01445
G1 X119.05 Y127.71 E.01321
G1 X118.972 Y128.101 E.01284
G1 X118.948 Y128.466 E.01174
G1 X118.948 Y137.534 E.29162
G1 X118.972 Y137.899 E.01175
G1 X119.05 Y138.29 E.01284
G1 X119.178 Y138.669 E.01285
G1 X119.355 Y139.027 E.01285
G1 X119.636 Y139.448 E.01627
G1 X118.052 Y139.448 E.05094
G1 X118.052 Y115.552 E.7684
G1 X137.908 Y115.552 E.63849
G1 X138.355 Y115.145 F30000
G1 F3600
G1 X138.355 Y139.855 E.79458
G1 X135.533 Y139.855 E.09076
G1 X135.479 Y139.684 E.00576
G1 X135.656 Y139.56 E.00694
G1 X135.871 Y139.371 E.00922
G1 X136.1 Y139.111 E.01113
G1 X136.292 Y138.823 E.01113
G1 X136.445 Y138.513 E.01113
G1 X136.556 Y138.185 E.01114
G1 X136.624 Y137.846 E.01113
G1 X136.645 Y137.521 E.01046
G1 X136.645 Y128.479 E.29076
G1 X136.624 Y128.154 E.01046
G1 X136.556 Y127.815 E.01114
G1 X136.445 Y127.487 E.01112
G1 X136.292 Y127.177 E.01113
G1 X136.099 Y126.889 E.01113
G1 X135.871 Y126.629 E.01113
G1 X135.611 Y126.401 E.01113
G1 X135.323 Y126.208 E.01113
G1 X135.013 Y126.055 E.01113
G1 X134.685 Y125.944 E.01113
G1 X134.339 Y125.875 E.01135
G1 X133.943 Y125.857 E.01274
G1 X133.655 Y125.876 E.00929
G1 X133.315 Y125.944 E.01113
G1 X132.981 Y126.057 E.01135
G1 X132.629 Y126.24 E.01274
G1 X132.389 Y126.401 E.0093
G1 X132.129 Y126.629 E.01113
G1 X131.901 Y126.889 E.01113
G1 X131.74 Y127.129 E.0093
G1 X131.557 Y127.481 E.01274
G1 X131.444 Y127.815 E.01135
G1 X131.376 Y128.155 E.01113
G1 X131.355 Y128.479 E.01046
G1 X131.355 Y137.521 E.29076
G1 X131.376 Y137.846 E.01046
G1 X131.444 Y138.185 E.01113
G1 X131.555 Y138.513 E.01113
G1 X131.708 Y138.823 E.01113
G1 X131.9 Y139.111 E.01113
G1 X132.129 Y139.371 E.01113
G1 X132.389 Y139.6 E.01113
G1 X132.512 Y139.682 E.00475
G1 X132.459 Y139.855 E.00582
G1 X123.533 Y139.855 E.28706
G1 X123.479 Y139.684 E.00576
G1 X123.656 Y139.56 E.00694
G1 X123.871 Y139.371 E.00922
G1 X124.1 Y139.111 E.01113
G1 X124.292 Y138.823 E.01113
G1 X124.445 Y138.513 E.01113
G1 X124.556 Y138.185 E.01114
G1 X124.624 Y137.846 E.01113
G1 X124.645 Y137.521 E.01046
G1 X124.645 Y128.479 E.29076
G1 X124.624 Y128.154 E.01046
G1 X124.556 Y127.815 E.01114
G1 X124.445 Y127.487 E.01112
G1 X124.292 Y127.177 E.01113
G1 X124.099 Y126.889 E.01113
G1 X123.871 Y126.629 E.01113
G1 X123.611 Y126.401 E.01113
G1 X123.323 Y126.208 E.01113
G1 X123.013 Y126.055 E.01113
G1 X122.685 Y125.944 E.01113
G1 X122.339 Y125.875 E.01135
G1 X121.943 Y125.857 E.01274
G1 X121.655 Y125.876 E.00929
G1 X121.315 Y125.944 E.01113
G1 X120.981 Y126.057 E.01135
G1 X120.629 Y126.24 E.01274
G1 X120.389 Y126.401 E.0093
G1 X120.129 Y126.629 E.01113
G1 X119.901 Y126.889 E.01113
G1 X119.74 Y127.129 E.0093
G1 X119.557 Y127.481 E.01274
G1 X119.444 Y127.815 E.01135
G1 X119.376 Y128.154 E.01113
G1 X119.355 Y128.479 E.01046
G1 X119.355 Y137.521 E.29076
G1 X119.376 Y137.846 E.01046
G1 X119.444 Y138.185 E.01113
G1 X119.555 Y138.513 E.01113
G1 X119.708 Y138.823 E.01113
G1 X119.9 Y139.111 E.01113
G1 X120.129 Y139.371 E.01113
G1 X120.389 Y139.6 E.01113
G1 X120.512 Y139.682 E.00475
G1 X120.459 Y139.855 E.00582
G1 X117.645 Y139.855 E.0905
G1 X117.645 Y115.145 E.79458
G1 X138.315 Y115.145 E.66467
M204 S250
G1 X138.79 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
; WIPE_START
M204 S10000
G1 X138.753 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.61 Y116.123 Z1 F30000
G1 Z.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42215
G1 F3600
G1 X137.208 Y116.72 E.0253
G1 X137.208 Y117.256 E.01607
G1 X136.244 Y116.292 E.04083
G1 X135.708 Y116.292 E.01607
G1 X137.208 Y117.792 E.06355
G1 X137.208 Y118.329 E.01607
G1 X135.171 Y116.292 E.08627
G1 X134.635 Y116.292 E.01607
G1 X137.208 Y118.865 E.10899
G1 X137.208 Y119.401 E.01607
G1 X134.099 Y116.292 E.13171
G1 X133.562 Y116.292 E.01607
G1 X137.208 Y119.938 E.15443
G1 X137.208 Y120.474 E.01607
G1 X133.026 Y116.292 E.17716
G1 X132.49 Y116.292 E.01607
G1 X137.208 Y121.01 E.19988
G1 X137.208 Y121.547 E.01607
G1 X131.953 Y116.292 E.2226
G1 X131.417 Y116.292 E.01607
G1 X137.208 Y122.083 E.24532
G1 X137.208 Y122.619 E.01607
G1 X130.881 Y116.292 E.26804
G1 X130.344 Y116.292 E.01607
G1 X137.208 Y123.156 E.29076
G1 X137.208 Y123.692 E.01607
G1 X129.808 Y116.292 E.31348
G1 X129.272 Y116.292 E.01607
G1 X137.208 Y124.228 E.3362
G1 X137.208 Y124.765 E.01607
G1 X128.735 Y116.292 E.35892
G1 X128.199 Y116.292 E.01607
G1 X137.208 Y125.301 E.38164
G1 X137.208 Y125.837 E.01607
G1 X127.663 Y116.292 E.40436
G1 X127.127 Y116.292 E.01607
G1 X137.183 Y126.349 E.42604
G1 X135.506 Y125.208 F30000
G1 F3600
G1 X126.59 Y116.292 E.37771
G1 X126.054 Y116.292 E.01607
G1 X134.498 Y124.737 E.35775
G1 X133.934 Y124.708 E.01694
G1 X125.518 Y116.292 E.35654
G1 X124.981 Y116.292 E.01607
G1 X133.438 Y124.749 E.35828
G1 X132.994 Y124.841 E.0136
G1 X124.445 Y116.292 E.36217
G1 X123.909 Y116.292 E.01607
G1 X132.593 Y124.977 E.36792
G1 X132.233 Y125.153 E.01202
G1 X123.372 Y116.292 E.37537
G1 X122.836 Y116.292 E.01607
G1 X131.895 Y125.351 E.38376
G1 X131.586 Y125.579 E.01149
G1 X122.3 Y116.292 E.39341
G1 X121.763 Y116.292 E.01607
G1 X131.302 Y125.831 E.40411
G1 X131.052 Y126.117 E.01138
G1 X121.227 Y116.292 E.41621
G1 X120.691 Y116.292 E.01607
G1 X130.828 Y126.429 E.42945
G1 X130.633 Y126.771 E.01178
G1 X120.154 Y116.292 E.44392
G1 X119.618 Y116.292 E.01607
G1 X130.462 Y127.137 E.45941
G1 X130.329 Y127.539 E.01271
G1 X119.082 Y116.292 E.47647
G1 X118.792 Y116.292 E.00867
G1 X118.792 Y116.539 E.0074
G1 X130.24 Y127.987 E.48497
G1 X130.208 Y128.491 E.01513
G1 X118.792 Y117.076 E.4836
G1 X118.792 Y117.612 E.01607
G1 X130.208 Y129.027 E.4836
G1 X130.208 Y129.563 E.01607
G1 X118.792 Y118.148 E.4836
G1 X118.792 Y118.685 E.01607
G1 X130.208 Y130.1 E.4836
G1 X130.208 Y130.636 E.01607
G1 X118.792 Y119.221 E.4836
G1 X118.792 Y119.757 E.01607
G1 X130.208 Y131.172 E.4836
G1 X130.208 Y131.709 E.01607
G1 X125.469 Y126.971 E.20073
M73 P39 R17
G1 X125.288 Y126.602 E.01232
G1 X125.012 Y126.189 E.01488
G1 X124.684 Y125.816 E.01487
G1 X124.311 Y125.488 E.01487
G1 X123.898 Y125.212 E.01488
G1 X123.529 Y125.03 E.01232
G1 X118.792 Y120.293 E.20068
G1 X118.792 Y120.83 E.01607
G1 X122.749 Y124.787 E.16764
G1 X122.477 Y124.733 E.00833
G1 X122.144 Y124.718 E.00997
G1 X118.792 Y121.366 E.14199
G1 X118.792 Y121.902 E.01607
G1 X121.619 Y124.729 E.11974
G1 X121.159 Y124.805 E.01397
G1 X118.792 Y122.439 E.10025
G1 X118.792 Y122.975 E.01607
G1 X120.743 Y124.926 E.08266
G1 X120.529 Y124.999 E.00678
G1 X120.365 Y125.084 E.00554
G1 X118.792 Y123.511 E.06663
G1 X118.792 Y124.048 E.01607
G1 X120.015 Y125.27 E.0518
G1 X119.694 Y125.485 E.01158
G1 X118.792 Y124.584 E.03818
G1 X118.792 Y125.12 E.01607
G1 X119.407 Y125.735 E.02605
G1 X119.146 Y126.01 E.01136
G1 X118.623 Y125.487 E.02215
; WIPE_START
G1 X119.146 Y126.01 E-.28096
G1 X119.407 Y125.735 E-.14414
G1 X118.792 Y125.12 E-.3305
G1 X118.792 Y125.109 E-.0044
; WIPE_END
G1 E-.04 F1800
G1 X125.492 Y127.529 Z1 F30000
G1 Z.6
G1 E.8 F1800
G1 F3600
G1 X130.208 Y132.245 E.1998
G1 X130.208 Y132.781 E.01607
G1 X125.787 Y128.361 E.18727
G1 X125.792 Y128.902 E.01623
G1 X130.208 Y133.318 E.18705
G1 X130.208 Y133.854 E.01607
G1 X125.792 Y129.439 E.18705
G1 X125.792 Y129.975 E.01607
G1 X130.208 Y134.39 E.18705
G1 X130.208 Y134.927 E.01607
G1 X125.792 Y130.511 E.18705
G1 X125.792 Y131.048 E.01607
G1 X130.208 Y135.463 E.18705
G1 X130.208 Y135.999 E.01607
G1 X125.792 Y131.584 E.18705
G1 X125.792 Y132.12 E.01607
G1 X130.208 Y136.535 E.18705
G1 X130.208 Y137.072 E.01607
G1 X125.792 Y132.657 E.18705
G1 X125.792 Y133.193 E.01607
G1 X130.211 Y137.612 E.1872
G1 X130.236 Y137.996 E.01153
G1 X130.28 Y138.217 E.00676
G1 X125.792 Y133.729 E.19013
G1 X125.792 Y134.266 E.01607
G1 X130.234 Y138.708 E.18819
G1 X129.698 Y138.708 E.01607
G1 X125.792 Y134.802 E.16547
G1 X125.792 Y135.338 E.01607
G1 X129.162 Y138.708 E.14275
G1 X128.626 Y138.708 E.01607
G1 X125.792 Y135.874 E.12003
G1 X125.792 Y136.411 E.01607
G1 X128.089 Y138.708 E.09731
G1 X127.553 Y138.708 E.01607
G1 X125.792 Y136.947 E.07458
G1 X125.792 Y137.483 E.01607
G1 X127.017 Y138.708 E.05186
G1 X126.48 Y138.708 E.01607
G1 X125.764 Y137.991 E.03034
G1 X125.675 Y138.439 E.01367
G1 X126.114 Y138.877 E.01856
; WIPE_START
G1 X125.675 Y138.439 E-.23548
G1 X125.764 Y137.991 E-.17344
G1 X126.417 Y138.645 E-.35107
; WIPE_END
G1 E-.04 F1800
G1 X124.038 Y139.527 Z1 F30000
G1 Z.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.108335
G1 F15000
G1 X123.929 Y139.651 E.00086
G1 X123.3 Y139.841 F30000
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X122.984 Y139.904 E.00872
; LINE_WIDTH: 0.363348
G1 F7489.979
G1 X122.878 Y139.921 E.00272
; LINE_WIDTH: 0.328365
G1 F8407.945
G1 X122.772 Y139.939 E.00242
; LINE_WIDTH: 0.290957
G1 F9675.999
G1 X122.651 Y139.958 E.0024
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X122.492 Y139.974 E.00269
; LINE_WIDTH: 0.22395
G1 F13257.525
G1 X122.322 Y139.99 E.00244
; LINE_WIDTH: 0.197595
G1 F15000
G1 X121.667 Y139.989 E.00801
; LINE_WIDTH: 0.224995
G1 F13181.427
G1 X121.508 Y139.974 E.0023
; LINE_WIDTH: 0.257802
G1 F11168.964
G1 X121.334 Y139.956 E.00297
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X121.228 Y139.939 E.00212
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X121.122 Y139.921 E.00242
; LINE_WIDTH: 0.379928
G1 F7121.5
G1 X120.692 Y139.839 E.01167
G1 X120.071 Y139.651 F30000
; LINE_WIDTH: 0.108342
G1 F15000
G1 X119.962 Y139.527 E.00086
; WIPE_START
G1 X120.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X118.821 Y138.187 Z1 F30000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.534812
G1 F4879.124
G1 X118.515 Y137.974 E.01448
G1 X118.5 Y137.541 E.01685
G1 X118.5 Y128.459 E.35289
G1 X118.513 Y128.058 E.0156
G1 X118.515 Y128.025 E.00126
G1 X118.821 Y127.813 E.01447
G1 X118.663 Y126.855 F30000
; LINE_WIDTH: 0.137699
G1 F15000
G1 X118.759 Y126.715 E.00128
; LINE_WIDTH: 0.112345
G1 X118.856 Y126.575 E.00093
; WIPE_START
G1 X118.759 Y126.715 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.392 Y126.657 Z1 F30000
G1 X137.144 Y126.575 Z1
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.124425
G1 F15000
G1 X137.337 Y126.854 E.00219
G1 X137.18 Y127.813 F30000
; LINE_WIDTH: 0.534804
G1 F4879.205
G1 X137.485 Y128.025 E.01445
G1 X137.487 Y128.058 E.00125
G1 X137.5 Y128.459 E.0156
G1 X137.5 Y137.541 E.35288
G1 X137.485 Y137.974 E.01685
G1 X137.18 Y138.187 E.01446
; WIPE_START
G1 X137.485 Y137.974 E-.14137
G1 X137.5 Y137.541 E-.16481
G1 X137.5 Y136.347 E-.45382
; WIPE_END
G1 E-.04 F1800
G1 X136.038 Y139.527 Z1 F30000
G1 Z.6
G1 E.8 F1800
; LINE_WIDTH: 0.108335
G1 F15000
G1 X135.929 Y139.651 E.00086
G1 X135.3 Y139.841 F30000
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X134.984 Y139.904 E.00872
; LINE_WIDTH: 0.363348
G1 F7489.979
G1 X134.878 Y139.921 E.00272
; LINE_WIDTH: 0.328365
G1 F8407.945
G1 X134.772 Y139.939 E.00242
; LINE_WIDTH: 0.290957
G1 F9676.007
G1 X134.651 Y139.958 E.0024
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X134.492 Y139.974 E.00269
; LINE_WIDTH: 0.22395
G1 F13257.53
G1 X134.322 Y139.99 E.00244
; LINE_WIDTH: 0.197595
G1 F15000
G1 X133.667 Y139.989 E.00801
; LINE_WIDTH: 0.224995
G1 F13181.427
G1 X133.508 Y139.974 E.0023
; LINE_WIDTH: 0.257802
G1 F11168.964
G1 X133.334 Y139.956 E.00297
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X133.228 Y139.939 E.00212
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X133.122 Y139.921 E.00242
; LINE_WIDTH: 0.379929
G1 F7121.488
G1 X132.692 Y139.839 E.01167
G1 X132.071 Y139.651 F30000
; LINE_WIDTH: 0.108342
G1 F15000
G1 X131.962 Y139.527 E.00086
; CHANGE_LAYER
; Z_HEIGHT: 0.75
; LAYER_HEIGHT: 0.15
; WIPE_START
G1 F15000
G1 X132.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 5/152
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
M106 S84.15
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
G1 X136.631 Y111.803
G1 Z.75
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F3000
G1 X136.631 Y113.911 E.08266
G1 X130.877 Y113.911 E.22562
G1 X130.877 Y111.615 E.09005
G1 X136.631 Y111.615 E.22562
G1 X136.631 Y108.738 E.11281
G1 X130.877 Y108.738 E.22562
; WIPE_START
G1 X132.877 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.15 I-.447 J-1.132 P1  F30000
G1 X125.123 Y111.803 Z1.15
G1 Z.75
G1 E.8 F1800
G1 F3000
G1 X125.123 Y113.911 E.08266
G1 X119.369 Y113.911 E.22562
G1 X119.369 Y111.615 E.09005
G1 X125.123 Y111.615 E.22562
G1 X125.123 Y108.738 E.11281
G1 X119.369 Y108.738 E.22562
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.05
; WIPE_START
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 6/152
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
G17
G3 Z1.15 I1.217 J0 P1  F30000
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
G1 X133.154 Y126.458
G1 Z.8
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F2400
M204 S5000
G1 X133.428 Y126.365 E.00861
G1 X133.711 Y126.308 E.00861
G1 X133.927 Y126.294 E.00643
G1 X134.286 Y126.308 E.0107
G1 X134.572 Y126.365 E.0087
G1 X134.846 Y126.458 E.00861
G1 X135.105 Y126.586 E.00861
G1 X135.346 Y126.746 E.00861
G1 X135.563 Y126.937 E.00861
G1 X135.754 Y127.154 E.00861
G1 X135.914 Y127.395 E.00861
G1 X136.042 Y127.654 E.00861
G1 X136.135 Y127.928 E.00862
G1 X136.192 Y128.211 E.00861
G1 X136.21 Y128.493 E.00841
G1 X136.21 Y137.507 E.26848
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
G1 X136.042 Y138.346 E.00861
G1 X135.913 Y138.608 E.0087
G1 X135.703 Y138.903 E.01078
G1 X135.563 Y139.063 E.00634
G1 X135.346 Y139.254 E.00861
G1 X135.105 Y139.414 E.00861
G1 X134.846 Y139.542 E.00861
G1 X134.572 Y139.635 E.00861
G1 X134.289 Y139.692 E.00861
G1 X134 Y139.71 E.00861
G1 X133.711 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
G1 X132.895 Y139.414 E.00861
G1 X132.654 Y139.254 E.00861
G1 X132.435 Y139.061 E.0087
G1 X132.204 Y138.782 E.01078
G1 X132.086 Y138.605 E.00634
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.865 Y127.928 E.00861
G1 X131.959 Y127.651 E.0087
G1 X132.126 Y127.334 E.0107
G1 X132.246 Y127.154 E.00643
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.895 Y126.586 E.00861
G1 X133.118 Y126.475 E.00742
; WIPE_START
M204 S10000
G1 X133.428 Y126.365 E-.12496
G1 X133.711 Y126.308 E-.10987
G1 X133.927 Y126.294 E-.082
G1 X134.286 Y126.308 E-.13646
G1 X134.572 Y126.365 E-.11097
G1 X134.846 Y126.458 E-.10987
G1 X135.049 Y126.558 E-.08586
; WIPE_END
G1 E-.04 F1800
G1 X127.438 Y127.136 Z1.2 F30000
G1 X123.918 Y127.403 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X124.042 Y127.654 E.00835
G1 X124.135 Y127.928 E.00862
G1 X124.192 Y128.211 E.00861
G1 X124.21 Y128.493 E.00841
G1 X124.21 Y137.507 E.26848
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.913 Y138.608 E.0087
G1 X123.703 Y138.903 E.01078
G1 X123.563 Y139.063 E.00634
G1 X123.346 Y139.254 E.00861
G1 X123.105 Y139.414 E.00861
G1 X122.846 Y139.542 E.00861
G1 X122.572 Y139.635 E.00861
G1 X122.289 Y139.692 E.00861
G1 X122 Y139.71 E.00861
G1 X121.711 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
G1 X120.895 Y139.414 E.00861
G1 X120.654 Y139.254 E.00861
G1 X120.435 Y139.061 E.0087
G1 X120.204 Y138.782 E.01078
G1 X120.086 Y138.605 E.00634
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.865 Y127.928 E.00861
M73 P40 R17
G1 X119.959 Y127.651 E.0087
G1 X120.126 Y127.334 E.0107
G1 X120.246 Y127.154 E.00643
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.895 Y126.586 E.00861
G1 X121.154 Y126.458 E.00861
G1 X121.428 Y126.365 E.00861
G1 X121.711 Y126.308 E.00861
G1 X121.927 Y126.294 E.00643
G1 X122.286 Y126.308 E.0107
G1 X122.572 Y126.365 E.0087
G1 X122.846 Y126.458 E.00861
G1 X123.105 Y126.586 E.00861
G1 X123.346 Y126.746 E.00861
G1 X123.563 Y126.937 E.00861
G1 X123.754 Y127.154 E.00861
G1 X123.897 Y127.369 E.00769
; WIPE_START
M204 S10000
G1 X124.042 Y127.654 E-.12158
G1 X124.135 Y127.928 E-.10991
G1 X124.192 Y128.211 E-.10981
G1 X124.21 Y128.493 E-.10732
G1 X124.21 Y129.313 E-.31138
; WIPE_END
G1 E-.04 F1800
G1 X129.602 Y123.911 Z1.2 F30000
G1 X137.541 Y115.959 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X137.541 Y127.547 E.37263
G1 X137.336 Y127.581 E.00666
G1 X137.199 Y127.175 E.01378
G1 X136.998 Y126.769 E.01456
G1 X136.747 Y126.392 E.01456
G1 X136.448 Y126.052 E.01456
G1 X136.108 Y125.753 E.01456
G1 X135.731 Y125.502 E.01457
G1 X135.325 Y125.301 E.01457
G1 X134.896 Y125.156 E.01456
G1 X134.432 Y125.063 E.01522
G1 X133.91 Y125.044 E.0168
G1 X133.548 Y125.067 E.01164
G1 X133.104 Y125.156 E.01457
G1 X132.675 Y125.301 E.01456
G1 X132.269 Y125.502 E.01457
G1 X131.892 Y125.753 E.01456
G1 X131.552 Y126.052 E.01456
G1 X131.253 Y126.392 E.01456
G1 X131.052 Y126.693 E.01165
G1 X130.808 Y127.156 E.01681
G1 X130.656 Y127.604 E.01522
G1 X130.567 Y128.048 E.01456
G1 X130.541 Y128.452 E.01303
G1 X130.541 Y137.548 E.29247
G1 X130.567 Y137.952 E.01303
G1 X130.656 Y138.396 E.01455
G1 X130.801 Y138.825 E.01457
G1 X130.908 Y139.041 E.00774
G1 X125.092 Y139.041 E.18701
G1 X125.199 Y138.825 E.00774
G1 X125.344 Y138.396 E.01457
G1 X125.433 Y137.952 E.01455
G1 X125.459 Y137.548 E.01303
G1 X125.459 Y128.452 E.29247
G1 X125.433 Y128.048 E.01303
G1 X125.344 Y127.604 E.01455
G1 X125.199 Y127.175 E.01457
G1 X124.998 Y126.769 E.01456
G1 X124.747 Y126.392 E.01456
G1 X124.448 Y126.052 E.01456
G1 X124.108 Y125.753 E.01456
G1 X123.731 Y125.502 E.01457
G1 X123.325 Y125.301 E.01457
G1 X122.896 Y125.156 E.01456
G1 X122.432 Y125.063 E.01522
G1 X121.91 Y125.044 E.0168
G1 X121.548 Y125.067 E.01164
G1 X121.104 Y125.156 E.01457
G1 X120.675 Y125.301 E.01456
G1 X120.269 Y125.502 E.01457
G1 X119.892 Y125.753 E.01456
G1 X119.552 Y126.052 E.01456
G1 X119.253 Y126.392 E.01456
G1 X119.052 Y126.693 E.01165
G1 X118.808 Y127.156 E.01681
G1 X118.664 Y127.581 E.01443
G1 X118.459 Y127.547 E.00666
G1 X118.459 Y115.959 E.37263
G1 X137.501 Y115.959 E.61231
; WIPE_START
G1 X137.508 Y117.959 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.444 Y125.591 Z1.2 F30000
G1 X137.336 Y138.419 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X137.541 Y138.453 E.00666
G1 X137.541 Y139.041 E.01891
G1 X137.092 Y139.041 E.01443
G1 X137.199 Y138.825 E.00774
G1 X137.324 Y138.457 E.01249
; WIPE_START
G1 X137.541 Y138.453 E-.08772
G1 X137.541 Y139.041 E-.23728
G1 X137.092 Y139.041 E-.18105
G1 X137.199 Y138.825 E-.09715
G1 X137.324 Y138.457 E-.1568
; WIPE_END
G1 E-.04 F1800
G1 X129.691 Y138.442 Z1.2 F30000
G1 X118.664 Y138.419 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X118.801 Y138.825 E.01378
G1 X118.908 Y139.041 E.00774
G1 X118.459 Y139.041 E.01443
G1 X118.459 Y138.453 E.01891
G1 X118.624 Y138.426 E.00538
; WIPE_START
G1 X118.801 Y138.825 E-.17647
G1 X118.908 Y139.041 E-.09724
G1 X118.459 Y139.041 E-.18123
G1 X118.459 Y138.453 E-.23751
G1 X118.624 Y138.426 E-.06756
; WIPE_END
G1 E-.04 F1800
G1 X123.55 Y132.595 Z1.2 F30000
G1 X137.948 Y115.552 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X137.948 Y139.448 E.7684
G1 X136.349 Y139.448 E.05141
G1 X136.638 Y139.041 E.01606
G1 X136.822 Y138.669 E.01333
G1 X136.95 Y138.29 E.01285
G1 X137.028 Y137.899 E.01284
G1 X137.052 Y137.534 E.01175
G1 X137.052 Y128.466 E.29162
G1 X137.028 Y128.101 E.01175
G1 X136.95 Y127.71 E.01284
G1 X136.822 Y127.331 E.01285
G1 X136.645 Y126.973 E.01285
G1 X136.423 Y126.641 E.01284
G1 X136.16 Y126.34 E.01285
G1 X135.859 Y126.077 E.01284
G1 X135.527 Y125.855 E.01285
G1 X135.169 Y125.678 E.01285
G1 X134.791 Y125.55 E.01285
G1 X134.384 Y125.469 E.01332
G1 X133.915 Y125.451 E.01509
G1 X133.601 Y125.472 E.01011
G1 X133.209 Y125.55 E.01285
G1 X132.831 Y125.678 E.01285
G1 X132.473 Y125.855 E.01285
G1 X132.141 Y126.077 E.01285
G1 X131.84 Y126.34 E.01284
G1 X131.577 Y126.641 E.01284
G1 X131.402 Y126.902 E.01012
G1 X131.183 Y127.317 E.01509
G1 X131.05 Y127.709 E.01332
G1 X130.972 Y128.101 E.01284
G1 X130.948 Y128.466 E.01175
G1 X130.948 Y137.534 E.29161
G1 X130.972 Y137.899 E.01175
G1 X131.05 Y138.29 E.01284
G1 X131.178 Y138.669 E.01285
G1 X131.355 Y139.027 E.01285
G1 X131.636 Y139.448 E.01627
G1 X124.349 Y139.448 E.23432
G1 X124.638 Y139.041 E.01606
G1 X124.822 Y138.669 E.01333
G1 X124.95 Y138.29 E.01285
G1 X125.028 Y137.899 E.01284
G1 X125.052 Y137.534 E.01175
G1 X125.052 Y128.466 E.29161
G1 X125.028 Y128.101 E.01175
G1 X124.95 Y127.71 E.01284
G1 X124.822 Y127.331 E.01285
G1 X124.645 Y126.973 E.01285
G1 X124.423 Y126.641 E.01284
G1 X124.16 Y126.34 E.01285
G1 X123.859 Y126.077 E.01284
G1 X123.527 Y125.855 E.01285
G1 X123.169 Y125.678 E.01285
G1 X122.791 Y125.55 E.01285
G1 X122.384 Y125.469 E.01332
G1 X121.915 Y125.451 E.01509
G1 X121.601 Y125.472 E.01011
G1 X121.209 Y125.55 E.01285
G1 X120.831 Y125.678 E.01285
G1 X120.473 Y125.855 E.01285
G1 X120.141 Y126.077 E.01285
G1 X119.84 Y126.34 E.01284
G1 X119.577 Y126.641 E.01284
G1 X119.402 Y126.902 E.01012
G1 X119.183 Y127.317 E.01509
G1 X119.05 Y127.709 E.01332
G1 X118.972 Y128.101 E.01284
G1 X118.948 Y128.466 E.01175
G1 X118.948 Y137.534 E.29162
G1 X118.972 Y137.899 E.01175
G1 X119.05 Y138.29 E.01284
G1 X119.178 Y138.669 E.01285
G1 X119.355 Y139.027 E.01285
G1 X119.636 Y139.448 E.01627
G1 X118.052 Y139.448 E.05093
G1 X118.052 Y115.552 E.7684
G1 X137.908 Y115.552 E.63849
G1 X138.355 Y115.145 F30000
G1 F3600
G1 X138.355 Y139.855 E.79458
G1 X135.541 Y139.855 E.0905
G1 X135.488 Y139.682 E.00582
G1 X135.611 Y139.6 E.00475
G1 X135.871 Y139.371 E.01113
G1 X136.045 Y139.173 E.00848
G1 X136.288 Y138.832 E.01347
G1 X136.445 Y138.513 E.01143
G1 X136.556 Y138.185 E.01113
G1 X136.624 Y137.846 E.01113
G1 X136.645 Y137.521 E.01046
G1 X136.645 Y128.479 E.29076
G1 X136.624 Y128.154 E.01046
G1 X136.556 Y127.815 E.01112
G1 X136.445 Y127.487 E.01114
G1 X136.292 Y127.177 E.01113
G1 X136.1 Y126.889 E.01113
G1 X135.871 Y126.629 E.01113
G1 X135.611 Y126.401 E.01113
G1 X135.323 Y126.208 E.01113
G1 X135.013 Y126.055 E.01113
G1 X134.685 Y125.944 E.01113
G1 X134.337 Y125.874 E.01142
G1 X133.921 Y125.859 E.01338
G1 X133.655 Y125.876 E.00858
G1 X133.315 Y125.944 E.01113
G1 X132.987 Y126.055 E.01113
G1 X132.677 Y126.208 E.01113
G1 X132.389 Y126.401 E.01113
G1 X132.129 Y126.629 E.01113
G1 X131.9 Y126.889 E.01113
G1 X131.752 Y127.111 E.00858
G1 X131.558 Y127.479 E.01338
G1 X131.444 Y127.815 E.01142
G1 X131.376 Y128.154 E.01113
G1 X131.355 Y128.479 E.01046
G1 X131.355 Y137.521 E.29076
G1 X131.376 Y137.846 E.01046
G1 X131.444 Y138.185 E.01113
G1 X131.555 Y138.513 E.01113
G1 X131.708 Y138.823 E.01113
G1 X131.855 Y139.042 E.00848
G1 X132.122 Y139.365 E.01347
G1 X132.389 Y139.6 E.01143
G1 X132.512 Y139.682 E.00475
G1 X132.459 Y139.855 E.00582
G1 X123.541 Y139.855 E.2868
G1 X123.488 Y139.682 E.00582
G1 X123.611 Y139.6 E.00475
G1 X123.871 Y139.371 E.01113
G1 X124.045 Y139.173 E.00848
G1 X124.288 Y138.832 E.01347
G1 X124.445 Y138.513 E.01143
G1 X124.556 Y138.185 E.01113
G1 X124.624 Y137.846 E.01113
G1 X124.645 Y137.521 E.01046
G1 X124.645 Y128.479 E.29076
G1 X124.624 Y128.154 E.01046
G1 X124.556 Y127.815 E.01112
G1 X124.445 Y127.487 E.01114
G1 X124.292 Y127.177 E.01113
G1 X124.1 Y126.889 E.01113
G1 X123.871 Y126.629 E.01113
G1 X123.611 Y126.401 E.01113
G1 X123.323 Y126.208 E.01113
G1 X123.013 Y126.055 E.01113
G1 X122.685 Y125.944 E.01113
G1 X122.337 Y125.874 E.01142
G1 X121.921 Y125.859 E.01338
G1 X121.655 Y125.876 E.00858
G1 X121.315 Y125.944 E.01113
G1 X120.987 Y126.055 E.01113
G1 X120.677 Y126.208 E.01113
G1 X120.389 Y126.401 E.01113
G1 X120.129 Y126.629 E.01113
G1 X119.9 Y126.889 E.01113
G1 X119.752 Y127.111 E.00858
G1 X119.558 Y127.479 E.01338
G1 X119.444 Y127.815 E.01142
G1 X119.376 Y128.154 E.01113
G1 X119.355 Y128.479 E.01046
G1 X119.355 Y137.521 E.29076
G1 X119.376 Y137.846 E.01046
G1 X119.444 Y138.185 E.01113
G1 X119.555 Y138.513 E.01113
G1 X119.708 Y138.823 E.01113
G1 X119.855 Y139.042 E.00848
G1 X120.122 Y139.365 E.01347
G1 X120.389 Y139.6 E.01143
G1 X120.512 Y139.682 E.00475
G1 X120.459 Y139.855 E.00582
G1 X117.645 Y139.855 E.0905
G1 X117.645 Y115.145 E.79458
G1 X138.315 Y115.145 E.66467
M204 S250
G1 X138.79 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
; WIPE_START
M204 S10000
G1 X138.753 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.524 Y124.243 Z1.2 F30000
G1 X137.144 Y126.575 Z1.2
G1 Z.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.124434
G1 F15000
G1 X137.337 Y126.854 E.00219
G1 X137.18 Y127.813 F30000
; LINE_WIDTH: 0.534803
G1 F4879.208
G1 X137.485 Y128.026 E.01444
G1 X137.487 Y128.058 E.00125
G1 X137.5 Y128.459 E.0156
G1 X137.5 Y137.541 E.35289
G1 X137.485 Y137.974 E.01685
G1 X137.179 Y138.187 E.01448
; WIPE_START
G1 X137.485 Y137.974 E-.14157
G1 X137.5 Y137.541 E-.16481
G1 X137.5 Y136.347 E-.45362
; WIPE_END
G1 E-.04 F1800
G1 X135.308 Y139.839 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X134.984 Y139.904 E.00895
; LINE_WIDTH: 0.363348
G1 F7489.979
G1 X134.878 Y139.921 E.00272
; LINE_WIDTH: 0.328365
G1 F8407.945
G1 X134.772 Y139.939 E.00242
; LINE_WIDTH: 0.290957
G1 F9676.007
G1 X134.651 Y139.958 E.0024
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X134.492 Y139.974 E.00269
; LINE_WIDTH: 0.22395
G1 F13257.53
G1 X134.322 Y139.99 E.00244
; LINE_WIDTH: 0.197595
G1 F15000
G1 X133.667 Y139.989 E.00801
; LINE_WIDTH: 0.224995
G1 F13181.427
G1 X133.508 Y139.974 E.0023
; LINE_WIDTH: 0.257802
G1 F11168.964
G1 X133.334 Y139.956 E.00297
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X133.228 Y139.939 E.00212
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X133.122 Y139.921 E.00242
; LINE_WIDTH: 0.379928
G1 F7121.491
G1 X132.692 Y139.839 E.01167
G1 X132.071 Y139.651 F30000
; LINE_WIDTH: 0.108347
G1 F15000
G1 X131.962 Y139.527 E.00086
; WIPE_START
G1 X132.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.887 Y138.877 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42215
G1 F3600
G1 X130.325 Y138.44 E.01854
G1 X130.236 Y137.992 E.01367
G1 X129.52 Y138.708 E.03032
G1 X128.984 Y138.708 E.01607
G1 X130.208 Y137.484 E.05184
G1 X130.208 Y136.948 E.01607
G1 X128.448 Y138.708 E.07456
G1 X127.911 Y138.708 E.01607
G1 X130.208 Y136.411 E.09728
G1 X130.208 Y135.875 E.01607
G1 X127.375 Y138.708 E.12
G1 X126.839 Y138.708 E.01607
G1 X130.208 Y135.339 E.14272
G1 X130.208 Y134.802 E.01607
G1 X126.302 Y138.708 E.16544
G1 X125.766 Y138.708 E.01607
G1 X130.208 Y134.266 E.18816
G1 X130.208 Y133.73 E.01607
G1 X125.72 Y138.218 E.19014
G1 X125.764 Y137.996 E.00678
G1 X125.789 Y137.612 E.01151
G1 X130.208 Y133.193 E.1872
G1 X130.208 Y132.657 E.01607
G1 X125.792 Y137.072 E.18705
G1 X125.792 Y136.536 E.01607
G1 X130.208 Y132.121 E.18705
G1 X130.208 Y131.585 E.01607
G1 X125.792 Y136 E.18705
G1 X125.792 Y135.463 E.01607
G1 X130.208 Y131.048 E.18705
G1 X130.208 Y130.512 E.01607
G1 X125.792 Y134.927 E.18705
G1 X125.792 Y134.391 E.01607
G1 X130.208 Y129.976 E.18705
G1 X130.208 Y129.439 E.01607
G1 X125.792 Y133.854 E.18705
G1 X125.792 Y133.318 E.01607
G1 X130.208 Y128.903 E.18705
G1 X130.213 Y128.361 E.01622
G1 X125.792 Y132.782 E.18727
G1 X125.792 Y132.246 E.01607
G1 X130.508 Y127.53 E.19978
; WIPE_START
G1 X129.094 Y128.944 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.256 Y126.306 Z1.2 F30000
G1 X136.735 Y126.13 Z1.2
G1 Z.8
G1 E.8 F1800
G1 F3600
G1 X137.208 Y125.657 E.02004
G1 X137.208 Y125.121 E.01607
G1 X136.593 Y125.736 E.02604
G1 X136.307 Y125.485 E.01139
G1 X137.208 Y124.585 E.03817
G1 X137.208 Y124.048 E.01607
G1 X135.985 Y125.271 E.05178
G1 X135.636 Y125.083 E.01186
G1 X137.208 Y123.512 E.06657
G1 X137.208 Y122.976 E.01607
G1 X135.257 Y124.926 E.08264
G1 X134.982 Y124.833 E.00868
G1 X134.842 Y124.805 E.0043
G1 X137.208 Y122.439 E.10023
G1 X137.208 Y121.903 E.01607
G1 X134.383 Y124.728 E.11968
G1 X133.861 Y124.713 E.01562
G1 X137.208 Y121.367 E.14176
G1 X137.208 Y120.83 E.01607
G1 X133.03 Y125.008 E.17699
G1 X137.377 Y120.124 F30000
G1 F3600
G1 X132.472 Y125.03 E.20782
G1 X132.102 Y125.212 E.01236
G1 X131.689 Y125.488 E.01487
G1 X131.316 Y125.816 E.01487
G1 X130.988 Y126.189 E.01487
G1 X130.765 Y126.523 E.01202
G1 X130.526 Y126.976 E.01534
G1 X125.792 Y131.709 E.20054
G1 X125.792 Y131.173 E.01607
G1 X137.208 Y119.758 E.4836
G1 X137.208 Y119.221 E.01607
G1 X125.792 Y130.637 E.4836
G1 X125.792 Y130.1 E.01607
G1 X137.208 Y118.685 E.4836
G1 X137.208 Y118.149 E.01607
G1 X125.792 Y129.564 E.4836
G1 X125.792 Y129.028 E.01607
G1 X137.208 Y117.612 E.4836
G1 X137.208 Y117.076 E.01607
G1 X125.792 Y128.491 E.4836
G1 X125.76 Y127.987 E.01514
G1 X137.208 Y116.54 E.48496
G1 X137.208 Y116.292 E.00741
G1 X136.919 Y116.292 E.00865
G1 X125.671 Y127.54 E.4765
G1 X125.538 Y127.137 E.01271
G1 X136.382 Y116.292 E.45943
G1 X135.846 Y116.292 E.01607
G1 X125.37 Y126.769 E.44382
G1 X125.288 Y126.602 E.00557
G1 X125.173 Y126.43 E.0062
G1 X135.31 Y116.292 E.42946
G1 X134.773 Y116.292 E.01607
G1 X124.949 Y126.117 E.41622
G1 X124.698 Y125.831 E.01138
G1 X134.237 Y116.292 E.40412
G1 X133.701 Y116.292 E.01607
G1 X124.414 Y125.579 E.39342
G1 X124.106 Y125.351 E.01149
G1 X133.165 Y116.292 E.38377
G1 X132.628 Y116.292 E.01607
G1 X123.771 Y125.15 E.37524
G1 X123.407 Y124.977 E.01206
G1 X132.092 Y116.292 E.36793
G1 X131.556 Y116.292 E.01607
G1 X123.007 Y124.841 E.36217
G1 X122.562 Y124.749 E.0136
G1 X131.019 Y116.292 E.35828
G1 X130.483 Y116.292 E.01607
G1 X122.06 Y124.716 E.35686
G1 X121.502 Y124.737 E.0167
G1 X129.947 Y116.292 E.35774
G1 X129.41 Y116.292 E.01607
G1 X120.495 Y125.208 E.37769
G1 X118.825 Y126.341 F30000
G1 F3600
G1 X128.874 Y116.292 E.42572
G1 X128.338 Y116.292 E.01607
G1 X118.792 Y125.838 E.40439
G1 X118.792 Y125.301 E.01607
G1 X127.801 Y116.292 E.38167
G1 X127.265 Y116.292 E.01607
G1 X118.792 Y124.765 E.35895
G1 X118.792 Y124.229 E.01607
G1 X126.729 Y116.292 E.33623
G1 X126.192 Y116.292 E.01607
G1 X118.792 Y123.692 E.3135
G1 X118.792 Y123.156 E.01607
G1 X125.656 Y116.292 E.29078
G1 X125.12 Y116.292 E.01607
G1 X118.792 Y122.62 E.26806
G1 X118.792 Y122.084 E.01607
G1 X124.584 Y116.292 E.24534
G1 X124.047 Y116.292 E.01607
G1 X118.792 Y121.547 E.22262
G1 X118.792 Y121.011 E.01607
G1 X123.511 Y116.292 E.1999
G1 X122.975 Y116.292 E.01607
G1 X118.792 Y120.475 E.17718
G1 X118.792 Y119.938 E.01607
G1 X122.438 Y116.292 E.15446
G1 X121.902 Y116.292 E.01607
G1 X118.792 Y119.402 E.13174
G1 X118.792 Y118.866 E.01607
G1 X121.366 Y116.292 E.10902
G1 X120.829 Y116.292 E.01607
G1 X118.792 Y118.329 E.0863
G1 X118.792 Y117.793 E.01607
G1 X120.293 Y116.292 E.06358
G1 X119.757 Y116.292 E.01607
G1 X118.792 Y117.257 E.04086
G1 X118.792 Y116.72 E.01607
G1 X119.39 Y116.123 E.02532
G1 X118.862 Y126.566 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.110353
G1 F15000
G1 X118.762 Y126.711 E.00094
; LINE_WIDTH: 0.13721
G1 X118.663 Y126.856 E.00131
G1 X118.82 Y127.813 F30000
; LINE_WIDTH: 0.534806
G1 F4879.179
G1 X118.515 Y128.025 E.01446
G1 X118.513 Y128.058 E.00126
G1 X118.5 Y128.459 E.0156
G1 X118.5 Y137.541 E.35289
G1 X118.515 Y137.974 E.01685
G1 X118.821 Y138.187 E.01447
; WIPE_START
G1 X118.515 Y137.974 E-.14154
G1 X118.5 Y137.541 E-.16481
G1 X118.5 Y136.347 E-.45366
; WIPE_END
G1 E-.04 F1800
G1 X119.962 Y139.527 Z1.2 F30000
G1 Z.8
G1 E.8 F1800
; LINE_WIDTH: 0.108347
G1 F15000
G1 X120.071 Y139.651 E.00086
G1 X120.692 Y139.839 F30000
; LINE_WIDTH: 0.379928
G1 F7121.5
G1 X121.122 Y139.921 E.01167
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X121.228 Y139.939 E.00242
; LINE_WIDTH: 0.293374
M73 P41 R17
G1 F9582.623
G1 X121.334 Y139.956 E.00212
; LINE_WIDTH: 0.257802
G1 F11168.964
G1 X121.508 Y139.974 E.00297
; LINE_WIDTH: 0.224995
G1 F13181.427
G1 X121.667 Y139.989 E.0023
; LINE_WIDTH: 0.197595
G1 F15000
G1 X122.322 Y139.99 E.00801
; LINE_WIDTH: 0.22395
G1 F13257.525
G1 X122.492 Y139.974 E.00244
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X122.651 Y139.958 E.00269
; LINE_WIDTH: 0.290957
G1 F9675.999
G1 X122.772 Y139.939 E.0024
; LINE_WIDTH: 0.328365
G1 F8407.945
G1 X122.878 Y139.921 E.00242
; LINE_WIDTH: 0.363348
G1 F7489.979
G1 X122.984 Y139.904 E.00272
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X123.308 Y139.839 E.00895
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7009.552
G1 X122.984 Y139.904 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 7/152
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
M106 S91.8
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
G1 X133.152 Y126.459
G1 Z1
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.428 Y126.365 E.00869
G1 X133.711 Y126.308 E.00861
G1 X133.906 Y126.296 E.00581
G1 X134.285 Y126.308 E.01129
G1 X134.572 Y126.365 E.00872
G1 X134.846 Y126.458 E.00861
G1 X135.105 Y126.586 E.00861
G1 X135.346 Y126.746 E.00861
G1 X135.566 Y126.939 E.00872
G1 X135.806 Y127.233 E.01129
G1 X135.914 Y127.395 E.00581
G1 X136.042 Y127.654 E.00861
G1 X136.135 Y127.928 E.00862
G1 X136.192 Y128.211 E.00861
G1 X136.21 Y128.493 E.00841
G1 X136.21 Y137.507 E.26848
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
G1 X136.042 Y138.346 E.00861
G1 X135.914 Y138.605 E.00861
G1 X135.754 Y138.846 E.00861
G1 X135.563 Y139.063 E.00861
G1 X135.346 Y139.254 E.00861
G1 X135.105 Y139.414 E.00861
G1 X134.846 Y139.542 E.00861
G1 X134.572 Y139.635 E.00861
G1 X134.289 Y139.692 E.00861
G1 X134 Y139.71 E.00861
G1 X133.711 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
M73 P41 R16
G1 X132.895 Y139.414 E.00861
G1 X132.654 Y139.254 E.00861
G1 X132.437 Y139.063 E.00861
G1 X132.246 Y138.846 E.00861
G1 X132.086 Y138.605 E.00861
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.866 Y127.924 E.00871
G1 X131.999 Y127.57 E.0113
G1 X132.086 Y127.395 E.00581
G1 X132.246 Y127.154 E.00861
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.817 Y126.638 E.00581
G1 X133.116 Y126.477 E.01013
; WIPE_START
M204 S10000
G1 X133.428 Y126.365 E-.12588
G1 X133.711 Y126.308 E-.10987
G1 X133.906 Y126.296 E-.07412
G1 X134.285 Y126.308 E-.14407
G1 X134.572 Y126.365 E-.11121
G1 X134.846 Y126.458 E-.10988
G1 X135.046 Y126.557 E-.08497
; WIPE_END
G1 E-.04 F1800
G1 X127.434 Y127.112 Z1.4 F30000
G1 X123.898 Y127.37 Z1.4
G1 Z1
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X123.914 Y127.395 E.00087
G1 X124.042 Y127.654 E.00861
G1 X124.135 Y127.928 E.00862
G1 X124.192 Y128.211 E.00861
G1 X124.21 Y128.493 E.00841
G1 X124.21 Y137.507 E.26848
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.914 Y138.605 E.00861
G1 X123.754 Y138.846 E.00861
G1 X123.563 Y139.063 E.00861
G1 X123.346 Y139.254 E.00861
G1 X123.105 Y139.414 E.00861
G1 X122.846 Y139.542 E.00861
G1 X122.572 Y139.635 E.00861
G1 X122.289 Y139.692 E.00861
G1 X122 Y139.71 E.00861
G1 X121.711 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
G1 X120.895 Y139.414 E.00861
G1 X120.654 Y139.254 E.00861
G1 X120.437 Y139.063 E.00861
G1 X120.246 Y138.846 E.00861
G1 X120.086 Y138.605 E.00861
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.866 Y127.924 E.00871
G1 X119.999 Y127.57 E.0113
G1 X120.086 Y127.395 E.00581
G1 X120.246 Y127.154 E.00861
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.817 Y126.638 E.00581
G1 X121.151 Y126.459 E.01129
G1 X121.428 Y126.365 E.00872
G1 X121.711 Y126.308 E.00861
G1 X121.906 Y126.296 E.00581
G1 X122.285 Y126.308 E.01129
G1 X122.572 Y126.365 E.00872
G1 X122.846 Y126.458 E.00861
G1 X123.105 Y126.586 E.00861
G1 X123.346 Y126.746 E.00861
G1 X123.566 Y126.939 E.00872
G1 X123.806 Y127.233 E.01129
G1 X123.876 Y127.337 E.00374
; WIPE_START
M204 S10000
G1 X123.914 Y127.395 E-.02635
G1 X124.042 Y127.654 E-.10989
G1 X124.135 Y127.928 E-.10992
G1 X124.192 Y128.211 E-.10981
G1 X124.21 Y128.493 E-.10731
G1 X124.21 Y129.274 E-.29673
; WIPE_END
G1 E-.04 F1800
G1 X129.61 Y123.88 Z1.4 F30000
G1 X137.541 Y115.959 Z1.4
G1 Z1
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X137.541 Y127.547 E.37262
G1 X137.336 Y127.581 E.00666
G1 X137.199 Y127.175 E.01377
G1 X136.998 Y126.769 E.01457
G1 X136.811 Y126.488 E.01085
G1 X136.467 Y126.068 E.01746
G1 X136.108 Y125.753 E.01535
G1 X135.731 Y125.502 E.01456
G1 X135.325 Y125.301 E.01457
G1 X134.896 Y125.156 E.01457
G1 X134.428 Y125.063 E.01536
G1 X133.885 Y125.045 E.01745
G1 X133.548 Y125.067 E.01085
G1 X133.104 Y125.156 E.01457
G1 X132.652 Y125.309 E.01536
G1 X132.173 Y125.566 E.01747
G1 X131.892 Y125.753 E.01086
G1 X131.552 Y126.052 E.01456
G1 X131.253 Y126.392 E.01456
G1 X131.002 Y126.769 E.01456
G1 X130.852 Y127.072 E.01086
G1 X130.66 Y127.58 E.01747
G1 X130.567 Y128.048 E.01535
G1 X130.541 Y128.452 E.01303
G1 X130.541 Y137.548 E.29247
G1 X130.567 Y137.952 E.01303
G1 X130.656 Y138.396 E.01456
G1 X130.801 Y138.825 E.01457
G1 X130.908 Y139.041 E.00774
G1 X125.092 Y139.041 E.187
G1 X125.199 Y138.825 E.00774
G1 X125.344 Y138.396 E.01457
G1 X125.433 Y137.952 E.01456
G1 X125.459 Y137.548 E.01303
G1 X125.459 Y128.452 E.29247
G1 X125.433 Y128.048 E.01303
G1 X125.344 Y127.604 E.01455
G1 X125.199 Y127.175 E.01457
G1 X124.998 Y126.769 E.01457
G1 X124.811 Y126.488 E.01085
G1 X124.467 Y126.068 E.01746
G1 X124.108 Y125.753 E.01535
G1 X123.731 Y125.502 E.01456
G1 X123.325 Y125.301 E.01457
G1 X122.896 Y125.156 E.01457
G1 X122.428 Y125.063 E.01536
G1 X121.885 Y125.045 E.01745
G1 X121.548 Y125.067 E.01085
G1 X121.104 Y125.156 E.01457
G1 X120.652 Y125.309 E.01536
G1 X120.173 Y125.566 E.01747
G1 X119.892 Y125.753 E.01086
G1 X119.552 Y126.052 E.01456
G1 X119.253 Y126.392 E.01456
G1 X119.002 Y126.769 E.01456
G1 X118.852 Y127.072 E.01086
G1 X118.66 Y127.582 E.01755
G1 X118.459 Y127.546 E.00655
G1 X118.459 Y115.959 E.37259
G1 X137.501 Y115.959 E.61231
; WIPE_START
G1 X137.508 Y117.959 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.444 Y125.591 Z1.4 F30000
G1 X137.336 Y138.419 Z1.4
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X137.541 Y138.453 E.00666
G1 X137.541 Y139.041 E.01891
G1 X137.092 Y139.041 E.01443
G1 X137.199 Y138.825 E.00774
G1 X137.324 Y138.457 E.0125
; WIPE_START
G1 X137.541 Y138.453 E-.08772
G1 X137.541 Y139.041 E-.23728
G1 X137.092 Y139.041 E-.18105
G1 X137.199 Y138.825 E-.09711
G1 X137.324 Y138.457 E-.15684
; WIPE_END
G1 E-.04 F1800
G1 X129.691 Y138.442 Z1.4 F30000
G1 X118.664 Y138.419 Z1.4
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X118.801 Y138.825 E.01378
G1 X118.908 Y139.041 E.00774
G1 X118.459 Y139.041 E.01443
G1 X118.459 Y138.453 E.01891
G1 X118.624 Y138.426 E.00538
; WIPE_START
G1 X118.801 Y138.825 E-.17648
G1 X118.908 Y139.041 E-.09722
G1 X118.459 Y139.041 E-.18122
G1 X118.459 Y138.453 E-.23752
G1 X118.624 Y138.426 E-.06756
; WIPE_END
G1 E-.04 F1800
G1 X123.55 Y132.595 Z1.4 F30000
G1 X137.948 Y115.552 Z1.4
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X137.948 Y139.448 E.7684
G1 X136.364 Y139.448 E.05094
G1 X136.645 Y139.027 E.01627
G1 X136.822 Y138.669 E.01285
G1 X136.95 Y138.29 E.01285
G1 X137.028 Y137.899 E.01284
G1 X137.052 Y137.534 E.01175
G1 X137.052 Y128.466 E.29161
G1 X137.028 Y128.101 E.01175
G1 X136.95 Y127.71 E.01284
G1 X136.822 Y127.331 E.01285
G1 X136.645 Y126.973 E.01286
G1 X136.483 Y126.731 E.00936
G1 X136.173 Y126.352 E.01574
G1 X135.859 Y126.077 E.01342
G1 X135.527 Y125.855 E.01285
G1 X135.169 Y125.678 E.01285
G1 X134.791 Y125.55 E.01285
G1 X134.381 Y125.468 E.01342
G1 X133.892 Y125.453 E.01574
G1 X133.601 Y125.472 E.00936
G1 X133.209 Y125.55 E.01285
G1 X132.814 Y125.684 E.01342
G1 X132.383 Y125.915 E.01575
G1 X132.141 Y126.077 E.00937
G1 X131.84 Y126.34 E.01284
G1 X131.577 Y126.641 E.01285
G1 X131.355 Y126.973 E.01284
G1 X131.226 Y127.234 E.00936
G1 X131.053 Y127.692 E.01575
G1 X130.972 Y128.101 E.01341
G1 X130.948 Y128.466 E.01175
G1 X130.948 Y137.534 E.29161
G1 X130.972 Y137.899 E.01175
G1 X131.05 Y138.29 E.01284
G1 X131.178 Y138.669 E.01285
G1 X131.355 Y139.027 E.01284
G1 X131.636 Y139.448 E.01628
G1 X124.364 Y139.448 E.23384
G1 X124.645 Y139.027 E.01627
G1 X124.822 Y138.669 E.01285
G1 X124.95 Y138.29 E.01285
G1 X125.028 Y137.899 E.01284
G1 X125.052 Y137.534 E.01175
G1 X125.052 Y128.466 E.29161
G1 X125.028 Y128.101 E.01175
G1 X124.95 Y127.71 E.01284
G1 X124.822 Y127.331 E.01285
G1 X124.645 Y126.973 E.01286
G1 X124.483 Y126.731 E.00936
G1 X124.173 Y126.352 E.01574
G1 X123.859 Y126.077 E.01342
G1 X123.527 Y125.855 E.01285
G1 X123.169 Y125.678 E.01285
G1 X122.791 Y125.55 E.01285
G1 X122.381 Y125.468 E.01342
G1 X121.892 Y125.453 E.01574
G1 X121.601 Y125.472 E.00936
G1 X121.209 Y125.55 E.01285
G1 X120.814 Y125.684 E.01342
G1 X120.383 Y125.915 E.01575
G1 X120.141 Y126.077 E.00937
G1 X119.84 Y126.34 E.01284
G1 X119.577 Y126.641 E.01285
G1 X119.355 Y126.973 E.01284
G1 X119.226 Y127.234 E.00936
G1 X119.053 Y127.692 E.01575
G1 X118.972 Y128.101 E.01341
G1 X118.948 Y128.466 E.01175
G1 X118.948 Y137.534 E.29162
G1 X118.972 Y137.899 E.01175
G1 X119.05 Y138.29 E.01284
G1 X119.178 Y138.669 E.01285
G1 X119.355 Y139.027 E.01284
G1 X119.636 Y139.448 E.01628
G1 X118.052 Y139.448 E.05094
G1 X118.052 Y115.552 E.7684
G1 X137.908 Y115.552 E.63849
G1 X138.355 Y115.145 F30000
G1 F3600
G1 X138.355 Y139.855 E.79458
G1 X135.541 Y139.855 E.0905
G1 X135.488 Y139.682 E.00582
G1 X135.611 Y139.6 E.00475
G1 X135.871 Y139.371 E.01113
G1 X136.1 Y139.111 E.01113
G1 X136.292 Y138.823 E.01113
G1 X136.445 Y138.513 E.01113
G1 X136.556 Y138.185 E.01113
G1 X136.624 Y137.846 E.01113
G1 X136.645 Y137.521 E.01046
G1 X136.645 Y128.479 E.29076
G1 X136.624 Y128.154 E.01046
G1 X136.556 Y127.815 E.01112
G1 X136.445 Y127.487 E.01113
G1 X136.292 Y127.177 E.01114
G1 X136.156 Y126.973 E.00786
G1 X135.879 Y126.636 E.01403
G1 X135.611 Y126.401 E.01148
G1 X135.323 Y126.208 E.01113
G1 X135.013 Y126.055 E.01113
G1 X134.685 Y125.944 E.01113
G1 X134.335 Y125.874 E.01148
G1 X133.899 Y125.86 E.01402
G1 X133.655 Y125.876 E.00787
G1 X133.315 Y125.944 E.01113
G1 X132.977 Y126.059 E.01148
G1 X132.592 Y126.265 E.01403
G1 X132.389 Y126.401 E.00787
G1 X132.129 Y126.629 E.01113
G1 X131.9 Y126.889 E.01113
G1 X131.708 Y127.177 E.01113
G1 X131.6 Y127.396 E.00787
G1 X131.446 Y127.804 E.01403
G1 X131.376 Y128.154 E.01148
G1 X131.355 Y128.479 E.01046
G1 X131.355 Y137.521 E.29076
G1 X131.376 Y137.846 E.01046
G1 X131.444 Y138.185 E.01113
G1 X131.555 Y138.513 E.01113
G1 X131.708 Y138.823 E.01113
G1 X131.9 Y139.111 E.01113
G1 X132.129 Y139.371 E.01113
G1 X132.389 Y139.599 E.01113
G1 X132.512 Y139.682 E.00476
G1 X132.459 Y139.855 E.00582
G1 X123.541 Y139.855 E.2868
G1 X123.488 Y139.682 E.00582
G1 X123.611 Y139.6 E.00475
G1 X123.871 Y139.371 E.01113
G1 X124.1 Y139.111 E.01113
G1 X124.292 Y138.823 E.01113
G1 X124.445 Y138.513 E.01113
G1 X124.556 Y138.185 E.01113
G1 X124.624 Y137.846 E.01113
G1 X124.645 Y137.521 E.01046
G1 X124.645 Y128.479 E.29076
G1 X124.624 Y128.154 E.01046
G1 X124.556 Y127.815 E.01112
G1 X124.445 Y127.487 E.01113
G1 X124.292 Y127.177 E.01114
G1 X124.156 Y126.973 E.00786
G1 X123.879 Y126.636 E.01403
G1 X123.611 Y126.401 E.01148
G1 X123.323 Y126.208 E.01113
G1 X123.013 Y126.055 E.01113
G1 X122.685 Y125.944 E.01113
G1 X122.335 Y125.874 E.01148
G1 X121.899 Y125.86 E.01402
G1 X121.655 Y125.876 E.00787
G1 X121.315 Y125.944 E.01113
G1 X120.977 Y126.059 E.01148
G1 X120.592 Y126.265 E.01403
G1 X120.389 Y126.401 E.00787
G1 X120.129 Y126.629 E.01113
G1 X119.9 Y126.889 E.01113
G1 X119.708 Y127.177 E.01113
G1 X119.6 Y127.396 E.00787
G1 X119.446 Y127.804 E.01403
G1 X119.376 Y128.154 E.01148
G1 X119.355 Y128.479 E.01046
G1 X119.355 Y137.521 E.29076
G1 X119.376 Y137.846 E.01046
G1 X119.444 Y138.185 E.01113
G1 X119.555 Y138.513 E.01113
G1 X119.708 Y138.823 E.01113
G1 X119.9 Y139.111 E.01113
G1 X120.129 Y139.371 E.01113
G1 X120.389 Y139.599 E.01113
G1 X120.512 Y139.682 E.00476
G1 X120.459 Y139.855 E.00582
G1 X117.645 Y139.855 E.0905
G1 X117.645 Y115.145 E.79458
G1 X138.315 Y115.145 E.66467
M204 S250
G1 X138.79 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
; WIPE_START
M204 S10000
G1 X138.753 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.61 Y116.123 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42215
G1 F3600
G1 X137.208 Y116.72 E.0253
G1 X137.208 Y117.256 E.01607
G1 X136.244 Y116.292 E.04083
G1 X135.708 Y116.292 E.01607
G1 X137.208 Y117.792 E.06355
G1 X137.208 Y118.329 E.01607
G1 X135.171 Y116.292 E.08627
G1 X134.635 Y116.292 E.01607
G1 X137.208 Y118.865 E.10899
G1 X137.208 Y119.401 E.01607
G1 X134.099 Y116.292 E.13171
G1 X133.562 Y116.292 E.01607
G1 X137.208 Y119.938 E.15443
G1 X137.208 Y120.474 E.01607
G1 X133.026 Y116.292 E.17716
G1 X132.49 Y116.292 E.01607
G1 X137.208 Y121.01 E.19988
G1 X137.208 Y121.547 E.01607
G1 X131.953 Y116.292 E.2226
G1 X131.417 Y116.292 E.01607
G1 X137.208 Y122.083 E.24532
G1 X137.208 Y122.619 E.01607
G1 X130.881 Y116.292 E.26804
G1 X130.344 Y116.292 E.01607
G1 X137.208 Y123.156 E.29076
G1 X137.208 Y123.692 E.01607
G1 X129.808 Y116.292 E.31348
G1 X129.272 Y116.292 E.01607
G1 X137.208 Y124.228 E.3362
G1 X137.208 Y124.765 E.01607
G1 X128.735 Y116.292 E.35892
G1 X128.199 Y116.292 E.01607
G1 X137.208 Y125.301 E.38164
G1 X137.208 Y125.837 E.01607
G1 X127.663 Y116.292 E.40436
G1 X127.127 Y116.292 E.01607
G1 X137.296 Y126.462 E.43082
G1 X135.506 Y125.208 F30000
G1 F3600
G1 X126.59 Y116.292 E.37771
G1 X126.054 Y116.292 E.01607
G1 X134.498 Y124.737 E.35775
G1 X133.939 Y124.714 E.01678
G1 X125.518 Y116.292 E.35676
G1 X124.981 Y116.292 E.01607
G1 X133.438 Y124.749 E.35828
G1 X132.994 Y124.841 E.0136
G1 X124.445 Y116.292 E.36217
G1 X123.909 Y116.292 E.01607
G1 X132.593 Y124.977 E.36792
G1 X132.235 Y125.155 E.01199
G1 X123.372 Y116.292 E.37545
G1 X122.836 Y116.292 E.01607
G1 X131.895 Y125.351 E.38376
G1 X131.586 Y125.579 E.01149
G1 X122.3 Y116.292 E.39341
G1 X121.763 Y116.292 E.01607
G1 X131.302 Y125.831 E.40411
G1 X131.052 Y126.117 E.01138
G1 X121.227 Y116.292 E.41621
G1 X120.691 Y116.292 E.01607
G1 X130.828 Y126.429 E.42945
G1 X130.712 Y126.602 E.00621
G1 X130.63 Y126.768 E.00556
G1 X120.154 Y116.292 E.44381
G1 X119.618 Y116.292 E.01607
G1 X130.469 Y127.143 E.4597
G1 X130.329 Y127.539 E.01259
G1 X119.082 Y116.292 E.47647
G1 X118.792 Y116.292 E.00867
G1 X118.792 Y116.539 E.0074
G1 X130.24 Y127.987 E.48497
G1 X130.208 Y128.491 E.01513
G1 X118.792 Y117.076 E.4836
G1 X118.792 Y117.612 E.01607
G1 X130.208 Y129.027 E.4836
G1 X130.208 Y129.563 E.01607
G1 X118.792 Y118.148 E.4836
G1 X118.792 Y118.685 E.01607
G1 X130.208 Y130.1 E.4836
G1 X130.208 Y130.636 E.01607
G1 X118.792 Y119.221 E.4836
G1 X118.792 Y119.757 E.01607
G1 X130.208 Y131.172 E.4836
G1 X130.208 Y131.709 E.01607
G1 X125.469 Y126.97 E.20073
G1 X125.287 Y126.602 E.01232
G1 X125.079 Y126.289 E.01125
G1 X124.707 Y125.836 E.01757
G1 X124.311 Y125.488 E.01578
M73 P42 R16
G1 X123.898 Y125.212 E.01488
G1 X123.529 Y125.03 E.01232
G1 X118.792 Y120.293 E.20068
G1 X118.792 Y120.83 E.01607
G1 X122.749 Y124.787 E.16763
G1 X122.466 Y124.73 E.00866
G1 X122.146 Y124.72 E.00957
G1 X118.792 Y121.366 E.1421
G1 X118.792 Y121.902 E.01607
G1 X121.619 Y124.729 E.11974
G1 X121.159 Y124.805 E.01397
G1 X118.792 Y122.439 E.10025
G1 X118.792 Y122.975 E.01607
G1 X120.743 Y124.926 E.08266
G1 X120.518 Y125.002 E.00712
G1 X120.365 Y125.084 E.0052
G1 X118.792 Y123.511 E.06664
G1 X118.792 Y124.048 E.01607
G1 X120.016 Y125.271 E.05185
G1 X119.694 Y125.485 E.01159
G1 X118.792 Y124.584 E.03818
G1 X118.792 Y125.12 E.01607
G1 X119.407 Y125.735 E.02605
G1 X119.146 Y126.01 E.01136
G1 X118.623 Y125.487 E.02215
; WIPE_START
G1 X119.146 Y126.01 E-.28096
G1 X119.407 Y125.735 E-.14414
G1 X118.792 Y125.12 E-.3305
G1 X118.792 Y125.109 E-.0044
; WIPE_END
G1 E-.04 F1800
G1 X125.492 Y127.529 Z1.4 F30000
G1 Z1
G1 E.8 F1800
G1 F3600
G1 X130.208 Y132.245 E.19979
G1 X130.208 Y132.781 E.01607
G1 X125.787 Y128.361 E.18727
G1 X125.792 Y128.902 E.01623
G1 X130.208 Y133.318 E.18705
G1 X130.208 Y133.854 E.01607
G1 X125.792 Y129.439 E.18705
G1 X125.792 Y129.975 E.01607
G1 X130.208 Y134.39 E.18705
G1 X130.208 Y134.927 E.01607
G1 X125.792 Y130.511 E.18705
G1 X125.792 Y131.048 E.01607
G1 X130.208 Y135.463 E.18705
G1 X130.208 Y135.999 E.01607
G1 X125.792 Y131.584 E.18705
G1 X125.792 Y132.12 E.01607
G1 X130.208 Y136.535 E.18705
G1 X130.208 Y137.072 E.01607
G1 X125.792 Y132.657 E.18705
G1 X125.792 Y133.193 E.01607
G1 X130.211 Y137.612 E.1872
G1 X130.236 Y137.996 E.01153
G1 X130.28 Y138.217 E.00676
G1 X125.792 Y133.729 E.19013
G1 X125.792 Y134.266 E.01607
G1 X130.234 Y138.708 E.18819
G1 X129.698 Y138.708 E.01607
G1 X125.792 Y134.802 E.16547
G1 X125.792 Y135.338 E.01607
G1 X129.162 Y138.708 E.14275
G1 X128.626 Y138.708 E.01607
G1 X125.792 Y135.874 E.12003
G1 X125.792 Y136.411 E.01607
G1 X128.089 Y138.708 E.09731
G1 X127.553 Y138.708 E.01607
G1 X125.792 Y136.947 E.07458
G1 X125.792 Y137.483 E.01607
G1 X127.017 Y138.708 E.05186
G1 X126.48 Y138.708 E.01607
G1 X125.764 Y137.991 E.03035
G1 X125.675 Y138.439 E.01367
G1 X126.114 Y138.877 E.01856
; WIPE_START
G1 X125.675 Y138.439 E-.23548
G1 X125.764 Y137.991 E-.17345
G1 X126.417 Y138.645 E-.35107
; WIPE_END
G1 E-.04 F1800
G1 X124.038 Y139.527 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.108331
G1 F15000
G1 X123.929 Y139.651 E.00086
G1 X123.308 Y139.839 F30000
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X122.984 Y139.904 E.00895
; LINE_WIDTH: 0.363348
G1 F7489.979
G1 X122.878 Y139.921 E.00272
; LINE_WIDTH: 0.328365
G1 F8407.945
G1 X122.772 Y139.939 E.00242
; LINE_WIDTH: 0.290957
G1 F9675.999
G1 X122.651 Y139.958 E.0024
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X122.492 Y139.974 E.00269
; LINE_WIDTH: 0.22395
G1 F13257.525
G1 X122.322 Y139.99 E.00244
; LINE_WIDTH: 0.197595
G1 F15000
G1 X121.667 Y139.989 E.00801
; LINE_WIDTH: 0.224995
G1 F13181.427
G1 X121.508 Y139.974 E.0023
; LINE_WIDTH: 0.257801
G1 F11168.967
G1 X121.334 Y139.956 E.00297
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X121.228 Y139.939 E.00212
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X121.122 Y139.921 E.00242
; LINE_WIDTH: 0.379928
G1 F7121.498
G1 X120.692 Y139.839 E.01167
G1 X120.071 Y139.651 F30000
; LINE_WIDTH: 0.108329
G1 F15000
G1 X119.962 Y139.527 E.00086
; WIPE_START
G1 X120.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X118.82 Y138.187 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.534753
G1 F4879.711
G1 X118.515 Y137.974 E.01444
G1 X118.5 Y137.541 E.01685
G1 X118.5 Y128.459 E.35285
G1 X118.513 Y128.058 E.0156
G1 X118.515 Y128.027 E.00122
G1 X118.819 Y127.818 E.01432
G1 X118.663 Y126.854 F30000
; LINE_WIDTH: 0.124415
G1 F15000
G1 X118.856 Y126.575 E.00219
; WIPE_START
G1 X118.663 Y126.854 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.295 Y126.793 Z1.4 F30000
G1 X137.22 Y126.705 Z1.4
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.109989
G1 F15000
G1 X137.337 Y126.886 E.00114
G1 X137.179 Y127.813 F30000
; LINE_WIDTH: 0.534812
G1 F4879.128
G1 X137.485 Y128.025 E.01447
G1 X137.487 Y128.058 E.00126
G1 X137.5 Y128.459 E.0156
G1 X137.5 Y137.541 E.35289
G1 X137.485 Y137.974 E.01685
G1 X137.179 Y138.187 E.01448
; WIPE_START
G1 X137.485 Y137.974 E-.14157
G1 X137.5 Y137.541 E-.16481
G1 X137.5 Y136.347 E-.45361
; WIPE_END
G1 E-.04 F1800
G1 X136.038 Y139.527 Z1.4 F30000
G1 Z1
G1 E.8 F1800
; LINE_WIDTH: 0.108331
G1 F15000
G1 X135.929 Y139.651 E.00086
G1 X135.308 Y139.839 F30000
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X134.984 Y139.904 E.00895
; LINE_WIDTH: 0.363348
G1 F7489.979
G1 X134.878 Y139.921 E.00272
; LINE_WIDTH: 0.328365
G1 F8407.945
G1 X134.772 Y139.939 E.00242
; LINE_WIDTH: 0.290957
G1 F9676.007
G1 X134.651 Y139.958 E.0024
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X134.492 Y139.974 E.00269
; LINE_WIDTH: 0.22395
G1 F13257.53
G1 X134.322 Y139.99 E.00244
; LINE_WIDTH: 0.197595
G1 F15000
G1 X133.667 Y139.989 E.00801
; LINE_WIDTH: 0.224995
G1 F13181.427
G1 X133.508 Y139.974 E.0023
; LINE_WIDTH: 0.257802
G1 F11168.964
G1 X133.334 Y139.956 E.00297
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X133.228 Y139.939 E.00212
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X133.122 Y139.921 E.00242
; LINE_WIDTH: 0.379929
G1 F7121.488
G1 X132.692 Y139.839 E.01167
G1 X132.071 Y139.651 F30000
; LINE_WIDTH: 0.108329
G1 F15000
G1 X131.962 Y139.527 E.00086
; CHANGE_LAYER
; Z_HEIGHT: 1.025
; LAYER_HEIGHT: 0.025
; WIPE_START
G1 F15000
G1 X132.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 8/152
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
M106 S130.05
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
G1 X136.631 Y111.803
G1 Z1.025
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F3000
G1 X136.631 Y113.911 E.08266
G1 X130.877 Y113.911 E.22562
G1 X130.877 Y111.615 E.09005
G1 X136.631 Y111.615 E.22562
G1 X136.631 Y108.738 E.11281
G1 X130.877 Y108.738 E.22562
; WIPE_START
G1 X132.877 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.425 I-.447 J-1.132 P1  F30000
G1 X125.123 Y111.803 Z1.425
G1 Z1.025
G1 E.8 F1800
G1 F3000
G1 X125.123 Y113.911 E.08266
G1 X119.369 Y113.911 E.22562
G1 X119.369 Y111.615 E.09005
G1 X125.123 Y111.615 E.22562
G1 X125.123 Y108.738 E.11281
G1 X119.369 Y108.738 E.22562
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.175
; WIPE_START
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 9/152
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
G17
G3 Z1.425 I1.217 J0 P1  F30000
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
G1 X133.154 Y126.458
G1 Z1.2
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F2400
M204 S5000
G1 X133.428 Y126.365 E.00861
G1 X133.711 Y126.308 E.00861
G1 X134.285 Y126.308 E.01707
G1 X134.572 Y126.365 E.00873
G1 X134.846 Y126.458 E.00861
G1 X135.105 Y126.586 E.00861
G1 X135.346 Y126.746 E.00861
G1 X135.563 Y126.937 E.00861
G1 X135.754 Y127.154 E.00861
G1 X135.914 Y127.395 E.00861
G1 X136.042 Y127.654 E.00861
G1 X136.135 Y127.928 E.00861
G1 X136.21 Y128.489 E.01687
G1 X136.21 Y137.507 E.2686
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
G1 X136.042 Y138.346 E.00861
G1 X135.914 Y138.605 E.00861
G1 X135.754 Y138.846 E.00861
G1 X135.563 Y139.063 E.00861
G1 X135.346 Y139.254 E.00861
G1 X135.105 Y139.414 E.00861
G1 X134.846 Y139.542 E.00861
G1 X134.685 Y139.597 E.00506
G1 X134.293 Y139.691 E.01202
G1 X134 Y139.71 E.00874
G1 X133.711 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
G1 X132.895 Y139.414 E.00861
G1 X132.654 Y139.254 E.00861
G1 X132.437 Y139.063 E.00861
G1 X132.246 Y138.846 E.00861
G1 X132.086 Y138.605 E.00861
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.865 Y127.928 E.00861
G1 X131.959 Y127.65 E.00873
G1 X132.246 Y127.154 E.01707
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.895 Y126.586 E.00861
G1 X133.118 Y126.475 E.00742
; WIPE_START
M204 S10000
G1 X133.428 Y126.365 E-.12496
G1 X133.711 Y126.308 E-.10987
G1 X134.285 Y126.308 E-.21776
G1 X134.572 Y126.365 E-.11142
G1 X134.846 Y126.458 E-.10987
G1 X135.049 Y126.558 E-.08612
; WIPE_END
G1 E-.04 F1800
G1 X127.436 Y127.095 Z1.6 F30000
G1 X123.882 Y127.346 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X123.914 Y127.395 E.00175
G1 X124.042 Y127.654 E.00861
G1 X124.135 Y127.928 E.00861
G1 X124.21 Y128.489 E.01687
G1 X124.21 Y137.507 E.2686
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.914 Y138.605 E.00861
G1 X123.754 Y138.846 E.00861
G1 X123.563 Y139.063 E.00861
G1 X123.346 Y139.254 E.00861
G1 X123.105 Y139.414 E.00861
G1 X122.846 Y139.542 E.00861
G1 X122.685 Y139.597 E.00506
G1 X122.293 Y139.691 E.01202
G1 X122 Y139.71 E.00874
G1 X121.711 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
G1 X120.895 Y139.414 E.00861
G1 X120.654 Y139.254 E.00861
G1 X120.437 Y139.063 E.00861
G1 X120.246 Y138.846 E.00861
G1 X120.086 Y138.605 E.00861
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.865 Y127.928 E.00861
G1 X119.959 Y127.65 E.00873
G1 X120.246 Y127.154 E.01707
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.895 Y126.586 E.00861
G1 X121.154 Y126.458 E.00861
G1 X121.428 Y126.365 E.00861
G1 X121.711 Y126.308 E.00861
G1 X122.285 Y126.308 E.01707
G1 X122.572 Y126.365 E.00873
G1 X122.846 Y126.458 E.00861
G1 X123.105 Y126.586 E.00861
G1 X123.346 Y126.746 E.00861
G1 X123.563 Y126.937 E.00861
G1 X123.754 Y127.154 E.00861
G1 X123.86 Y127.313 E.00567
; WIPE_START
M204 S10000
G1 X123.914 Y127.395 E-.03747
G1 X124.042 Y127.654 E-.10989
G1 X124.135 Y127.928 E-.10988
G1 X124.21 Y128.489 E-.21518
G1 X124.21 Y129.246 E-.28759
; WIPE_END
G1 E-.04 F1800
G1 X129.616 Y123.858 Z1.6 F30000
G1 X137.541 Y115.959 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X137.541 Y127.547 E.37263
G1 X137.336 Y127.581 E.00666
G1 X137.199 Y127.175 E.01378
G1 X136.998 Y126.769 E.01456
G1 X136.747 Y126.392 E.01457
G1 X136.448 Y126.052 E.01456
G1 X136.108 Y125.753 E.01456
G1 X135.731 Y125.502 E.01456
G1 X135.325 Y125.301 E.01456
G1 X134.896 Y125.156 E.01457
G1 X134.424 Y125.062 E.01548
G1 X133.861 Y125.047 E.0181
G1 X133.548 Y125.067 E.01008
G1 X133.104 Y125.156 E.01457
G1 X132.675 Y125.301 E.01456
G1 X132.269 Y125.502 E.01457
G1 X131.892 Y125.753 E.01457
G1 X131.552 Y126.052 E.01455
G1 X131.253 Y126.392 E.01456
G1 X131.079 Y126.653 E.01009
G1 X130.81 Y127.148 E.0181
G1 X130.656 Y127.604 E.01548
G1 X130.567 Y128.048 E.01456
G1 X130.541 Y128.452 E.01303
G1 X130.541 Y137.548 E.29247
G1 X130.567 Y137.952 E.01303
G1 X130.656 Y138.396 E.01455
G1 X130.801 Y138.825 E.01457
G1 X130.908 Y139.041 E.00774
G1 X125.092 Y139.041 E.187
G1 X125.199 Y138.825 E.00774
G1 X125.344 Y138.396 E.01457
G1 X125.433 Y137.952 E.01455
G1 X125.459 Y137.548 E.01303
G1 X125.459 Y128.425 E.29336
G1 X125.406 Y127.915 E.01646
G1 X125.344 Y127.604 E.01022
G1 X125.199 Y127.175 E.01457
G1 X124.998 Y126.769 E.01456
G1 X124.747 Y126.392 E.01457
G1 X124.448 Y126.052 E.01456
G1 X124.108 Y125.753 E.01456
G1 X123.731 Y125.502 E.01456
G1 X123.325 Y125.301 E.01456
G1 X122.896 Y125.156 E.01457
G1 X122.424 Y125.062 E.01548
G1 X121.861 Y125.047 E.0181
G1 X121.548 Y125.067 E.01008
G1 X121.104 Y125.156 E.01457
G1 X120.675 Y125.301 E.01456
G1 X120.269 Y125.502 E.01457
G1 X119.892 Y125.753 E.01457
G1 X119.552 Y126.052 E.01455
G1 X119.253 Y126.392 E.01456
G1 X119.079 Y126.653 E.01009
G1 X118.81 Y127.148 E.0181
G1 X118.664 Y127.581 E.01469
G1 X118.459 Y127.547 E.00666
G1 X118.459 Y115.959 E.37262
G1 X137.501 Y115.959 E.61231
; WIPE_START
G1 X137.508 Y117.959 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.444 Y125.591 Z1.6 F30000
G1 X137.336 Y138.419 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F3600
G1 X137.541 Y138.453 E.00666
G1 X137.541 Y139.041 E.01891
M73 P43 R16
G1 X137.092 Y139.041 E.01443
G1 X137.199 Y138.825 E.00774
G1 X137.324 Y138.457 E.01249
; WIPE_START
G1 X137.541 Y138.453 E-.08773
G1 X137.541 Y139.041 E-.23728
G1 X137.092 Y139.041 E-.18105
G1 X137.199 Y138.825 E-.09715
G1 X137.324 Y138.457 E-.15679
; WIPE_END
G1 E-.04 F1800
G1 X129.691 Y138.442 Z1.6 F30000
G1 X118.664 Y138.419 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F3600
G1 X118.801 Y138.825 E.01378
G1 X118.908 Y139.041 E.00774
G1 X118.459 Y139.041 E.01443
G1 X118.459 Y138.453 E.01891
G1 X118.624 Y138.426 E.00538
; WIPE_START
G1 X118.801 Y138.825 E-.17647
G1 X118.908 Y139.041 E-.09724
G1 X118.459 Y139.041 E-.18123
G1 X118.459 Y138.453 E-.23751
G1 X118.624 Y138.426 E-.06756
; WIPE_END
G1 E-.04 F1800
G1 X123.55 Y132.595 Z1.6 F30000
G1 X137.948 Y115.552 Z1.6
G1 Z1.2
G1 E.8 F1800
G1 F3600
G1 X137.948 Y139.448 E.7684
G1 X136.364 Y139.448 E.05094
G1 X136.645 Y139.027 E.01627
G1 X136.822 Y138.669 E.01285
G1 X136.95 Y138.29 E.01285
G1 X137.028 Y137.899 E.01284
G1 X137.052 Y137.534 E.01175
G1 X137.052 Y128.446 E.29226
G1 X137.003 Y127.976 E.01517
G1 X136.95 Y127.709 E.00875
G1 X136.822 Y127.331 E.01285
G1 X136.645 Y126.973 E.01284
G1 X136.423 Y126.641 E.01285
G1 X136.16 Y126.34 E.01285
G1 X135.859 Y126.077 E.01285
G1 X135.527 Y125.855 E.01285
G1 X135.169 Y125.678 E.01285
G1 X134.791 Y125.55 E.01285
G1 X134.378 Y125.468 E.01351
G1 X133.869 Y125.454 E.01639
G1 X133.601 Y125.472 E.00862
G1 X133.209 Y125.55 E.01285
G1 X132.831 Y125.678 E.01285
G1 X132.473 Y125.855 E.01285
G1 X132.141 Y126.077 E.01285
G1 X131.84 Y126.34 E.01284
G1 X131.577 Y126.641 E.01285
G1 X131.428 Y126.864 E.00863
G1 X131.185 Y127.312 E.01639
G1 X131.05 Y127.71 E.01351
G1 X130.972 Y128.101 E.01284
G1 X130.948 Y128.466 E.01175
G1 X130.948 Y137.534 E.29161
G1 X130.972 Y137.899 E.01175
G1 X131.05 Y138.29 E.01284
G1 X131.178 Y138.669 E.01285
G1 X131.355 Y139.027 E.01285
G1 X131.636 Y139.448 E.01627
G1 X124.364 Y139.448 E.23384
G1 X124.645 Y139.027 E.01627
G1 X124.822 Y138.669 E.01285
G1 X124.95 Y138.29 E.01285
G1 X125.028 Y137.899 E.01284
G1 X125.052 Y137.534 E.01175
G1 X125.052 Y128.446 E.29226
G1 X125.003 Y127.976 E.01517
G1 X124.95 Y127.709 E.00875
G1 X124.822 Y127.331 E.01285
G1 X124.645 Y126.973 E.01284
G1 X124.423 Y126.641 E.01285
G1 X124.16 Y126.34 E.01285
G1 X123.859 Y126.077 E.01285
G1 X123.527 Y125.855 E.01285
G1 X123.169 Y125.678 E.01285
G1 X122.791 Y125.55 E.01285
G1 X122.378 Y125.468 E.01351
G1 X121.869 Y125.454 E.01639
G1 X121.601 Y125.472 E.00862
G1 X121.209 Y125.55 E.01285
G1 X120.831 Y125.678 E.01285
G1 X120.473 Y125.855 E.01285
G1 X120.141 Y126.077 E.01285
G1 X119.84 Y126.34 E.01284
G1 X119.577 Y126.641 E.01285
G1 X119.428 Y126.864 E.00863
G1 X119.185 Y127.312 E.01639
G1 X119.05 Y127.71 E.01351
G1 X118.972 Y128.101 E.01284
G1 X118.948 Y128.466 E.01175
G1 X118.948 Y137.534 E.29162
G1 X118.972 Y137.899 E.01175
G1 X119.05 Y138.29 E.01284
G1 X119.178 Y138.669 E.01285
G1 X119.355 Y139.027 E.01285
G1 X119.636 Y139.448 E.01627
G1 X118.052 Y139.448 E.05094
G1 X118.052 Y115.552 E.7684
G1 X137.908 Y115.552 E.63849
G1 X138.355 Y115.145 F30000
G1 F3600
G1 X138.355 Y139.855 E.79458
G1 X135.541 Y139.855 E.0905
G1 X135.488 Y139.682 E.00582
G1 X135.611 Y139.599 E.00476
G1 X135.871 Y139.371 E.01113
G1 X136.1 Y139.111 E.01113
G1 X136.292 Y138.823 E.01113
G1 X136.445 Y138.513 E.01113
G1 X136.556 Y138.185 E.01114
G1 X136.624 Y137.846 E.01112
G1 X136.645 Y137.521 E.01046
G1 X136.645 Y128.467 E.29115
G1 X136.6 Y128.037 E.01388
G1 X136.556 Y127.815 E.00729
G1 X136.445 Y127.487 E.01113
G1 X136.292 Y127.177 E.01113
G1 X136.1 Y126.889 E.01113
G1 X135.871 Y126.629 E.01113
G1 X135.611 Y126.401 E.01113
G1 X135.323 Y126.208 E.01113
G1 X135.013 Y126.055 E.01113
G1 X134.685 Y125.944 E.01113
G1 X134.333 Y125.874 E.01154
G1 X133.877 Y125.862 E.01467
G1 X133.655 Y125.876 E.00717
G1 X133.315 Y125.944 E.01113
G1 X132.987 Y126.055 E.01113
G1 X132.677 Y126.208 E.01113
G1 X132.389 Y126.401 E.01113
G1 X132.129 Y126.629 E.01113
G1 X131.9 Y126.889 E.01113
G1 X131.777 Y127.074 E.00717
G1 X131.559 Y127.475 E.01467
G1 X131.444 Y127.815 E.01154
G1 X131.376 Y128.154 E.01113
G1 X131.355 Y128.479 E.01046
G1 X131.355 Y137.521 E.29076
G1 X131.376 Y137.846 E.01046
G1 X131.444 Y138.185 E.01112
G1 X131.555 Y138.513 E.01114
G1 X131.708 Y138.823 E.01113
G1 X131.9 Y139.111 E.01113
G1 X132.129 Y139.371 E.01113
G1 X132.389 Y139.599 E.01113
G1 X132.512 Y139.682 E.00476
G1 X132.459 Y139.855 E.00582
G1 X123.541 Y139.855 E.2868
G1 X123.488 Y139.682 E.00582
G1 X123.611 Y139.599 E.00476
G1 X123.871 Y139.371 E.01113
G1 X124.1 Y139.111 E.01113
G1 X124.292 Y138.823 E.01113
G1 X124.445 Y138.513 E.01113
G1 X124.556 Y138.185 E.01114
G1 X124.624 Y137.846 E.01112
G1 X124.645 Y137.521 E.01046
G1 X124.645 Y128.467 E.29115
G1 X124.6 Y128.037 E.01388
G1 X124.556 Y127.815 E.00729
G1 X124.445 Y127.487 E.01113
G1 X124.292 Y127.177 E.01113
G1 X124.1 Y126.889 E.01113
G1 X123.871 Y126.629 E.01113
G1 X123.611 Y126.401 E.01113
G1 X123.323 Y126.208 E.01113
G1 X123.013 Y126.055 E.01113
G1 X122.685 Y125.944 E.01113
G1 X122.333 Y125.874 E.01154
G1 X121.877 Y125.862 E.01467
G1 X121.655 Y125.876 E.00717
G1 X121.315 Y125.944 E.01113
G1 X120.987 Y126.055 E.01113
G1 X120.677 Y126.208 E.01113
G1 X120.389 Y126.401 E.01113
G1 X120.129 Y126.629 E.01113
G1 X119.9 Y126.889 E.01113
G1 X119.777 Y127.074 E.00717
G1 X119.559 Y127.475 E.01467
G1 X119.444 Y127.815 E.01154
G1 X119.376 Y128.154 E.01113
G1 X119.355 Y128.479 E.01046
G1 X119.355 Y137.521 E.29076
G1 X119.376 Y137.846 E.01046
G1 X119.444 Y138.185 E.01112
G1 X119.555 Y138.513 E.01114
G1 X119.708 Y138.823 E.01113
G1 X119.9 Y139.111 E.01113
G1 X120.129 Y139.371 E.01113
G1 X120.389 Y139.599 E.01113
G1 X120.512 Y139.682 E.00476
G1 X120.459 Y139.855 E.00582
G1 X117.645 Y139.855 E.0905
G1 X117.645 Y115.145 E.79458
G1 X138.315 Y115.145 E.66467
M204 S250
G1 X138.79 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
; WIPE_START
M204 S10000
G1 X138.753 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.524 Y124.243 Z1.6 F30000
G1 X137.144 Y126.575 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.124418
G1 F15000
G1 X137.337 Y126.854 E.00219
G1 X137.46 Y127.767 F30000
; LINE_WIDTH: 0.534775
G1 F4879.485
G1 X137.5 Y128.435 E.02601
G1 X137.5 Y137.557 E.35441
G1 X137.485 Y137.975 E.01623
G1 X137.179 Y138.187 E.01447
; WIPE_START
G1 X137.485 Y137.975 E-.14154
G1 X137.5 Y137.557 E-.15874
G1 X137.5 Y136.347 E-.45973
; WIPE_END
G1 E-.04 F1800
G1 X136.038 Y139.527 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.10833
G1 F15000
G1 X135.929 Y139.651 E.00086
G1 X135.308 Y139.839 F30000
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X134.984 Y139.904 E.00895
; LINE_WIDTH: 0.364815
G1 F7455.85
G1 X134.887 Y139.92 E.0025
; LINE_WIDTH: 0.330756
G1 F8338.088
G1 X134.777 Y139.937 E.00252
; LINE_WIDTH: 0.29613
G1 F9478.308
G1 X134.633 Y139.954 E.0029
; LINE_WIDTH: 0.26195
G1 F10957.438
G1 X134.489 Y139.972 E.00251
; LINE_WIDTH: 0.226142
G1 F13098.924
G1 X134.331 Y139.99 E.00231
; LINE_WIDTH: 0.197737
G1 F15000
G1 X133.667 Y139.989 E.00812
; LINE_WIDTH: 0.224994
G1 F13181.497
G1 X133.508 Y139.974 E.00229
; LINE_WIDTH: 0.2578
G1 F11169.049
G1 X133.334 Y139.956 E.00297
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X133.228 Y139.939 E.00212
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X133.122 Y139.921 E.00242
; LINE_WIDTH: 0.379929
G1 F7121.488
G1 X132.692 Y139.839 E.01167
G1 X132.071 Y139.651 F30000
; LINE_WIDTH: 0.108329
G1 F15000
G1 X131.962 Y139.527 E.00086
; WIPE_START
G1 X132.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.414 Y132.952 Z1.6 F30000
G1 X125.778 Y128.125 Z1.6
G1 Z1.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X125.751 Y127.863 E.00846
G1 X125.681 Y127.514 E.01147
G1 X125.521 Y127.041 E.01603
G1 X125.294 Y126.585 E.0164
G1 X125.38 Y126.469 E.00462
G1 X125.816 Y126.278 E.01533
G1 X126.253 Y126.386 E.01447
G1 X126.69 Y126.686 E.01704
G1 X127.127 Y127.278 E.02367
G1 X127.563 Y127.469 E.01533
G1 X128 Y127.361 E.01447
G1 X128.437 Y127.061 E.01704
G1 X128.874 Y126.469 E.02367
G1 X129.311 Y126.278 E.01533
G1 X129.747 Y126.386 E.01447
G1 X130.184 Y126.686 E.01704
G1 X130.468 Y127.072 E.01541
G1 X130.319 Y127.514 E.015
G1 X130.219 Y128.041 E.01725
G1 X130.184 Y128.025 E.00122
G1 X129.747 Y128.133 E.01447
G1 X129.311 Y128.433 E.01704
G1 X128.874 Y129.026 E.02367
G1 X128.437 Y129.216 E.01533
G1 X128 Y129.108 E.01447
G1 X127.563 Y128.808 E.01704
G1 X127.127 Y128.216 E.02367
G1 X126.69 Y128.025 E.01533
G1 X126.253 Y128.133 E.01447
G1 X125.807 Y128.445 E.01749
G1 X125.807 Y129.776 E.0428
G1 X126.253 Y129.88 E.01472
G1 X126.69 Y130.18 E.01704
G1 X127.127 Y130.773 E.02367
G1 X127.563 Y130.963 E.01533
G1 X128 Y130.855 E.01447
G1 X128.437 Y130.556 E.01704
G1 X128.874 Y129.963 E.02367
G1 X129.311 Y129.772 E.01533
G1 X129.747 Y129.88 E.01447
G1 X130.193 Y130.192 E.01747
G1 X130.193 Y131.523 E.04281
G1 X129.747 Y131.628 E.01471
G1 X129.311 Y131.927 E.01704
G1 X128.874 Y132.52 E.02367
G1 X128.437 Y132.711 E.01533
G1 X128 Y132.602 E.01447
G1 X127.563 Y132.303 E.01704
G1 X127.127 Y131.71 E.02367
G1 X126.69 Y131.52 E.01533
G1 X126.253 Y131.628 E.01447
G1 X125.807 Y131.939 E.01749
G1 X125.807 Y133.271 E.0428
G1 X126.253 Y133.375 E.01472
G1 X126.69 Y133.675 E.01704
G1 X127.127 Y134.267 E.02367
G1 X127.563 Y134.458 E.01533
G1 X128 Y134.35 E.01447
G1 X128.437 Y134.05 E.01704
G1 X128.874 Y133.457 E.02367
G1 X129.311 Y133.267 E.01533
G1 X129.747 Y133.375 E.01447
G1 X130.193 Y133.686 E.01747
G1 X130.193 Y135.017 E.04281
G1 X129.747 Y135.122 E.01471
G1 X129.311 Y135.422 E.01704
G1 X128.874 Y136.014 E.02367
G1 X128.437 Y136.205 E.01533
G1 X128 Y136.097 E.01447
G1 X127.563 Y135.797 E.01704
G1 X127.127 Y135.204 E.02367
G1 X126.69 Y135.014 E.01533
G1 X126.253 Y135.122 E.01447
G1 X125.807 Y135.434 E.01749
G1 X125.807 Y136.765 E.0428
G1 X126.253 Y136.869 E.01472
G1 X126.69 Y137.169 E.01704
G1 X127.127 Y137.761 E.02367
G1 X127.563 Y137.952 E.01533
G1 X128 Y137.844 E.01447
G1 X128.437 Y137.544 E.01704
G1 X128.874 Y136.952 E.02367
G1 X129.311 Y136.761 E.01533
G1 X129.747 Y136.869 E.01447
G1 X130.193 Y137.18 E.01747
G1 X130.193 Y137.559 E.01218
G1 X130.221 Y137.998 E.01414
G1 X130.351 Y138.581 E.0192
G1 X130.184 Y138.508 E.00584
G1 X129.747 Y138.616 E.01447
G1 X129.618 Y138.693 E.00483
G1 X127.113 Y138.693 E.08056
G1 X126.69 Y138.508 E.01484
G1 X126.253 Y138.616 E.01447
G1 X126.124 Y138.693 E.00483
G1 X125.611 Y138.693 E.01647
G1 X125.681 Y138.486 E.00701
G1 X125.779 Y137.998 E.01602
G1 X125.805 Y137.599 E.01286
; WIPE_START
G1 X125.779 Y137.998 E-.15199
G1 X125.681 Y138.486 E-.1893
G1 X125.611 Y138.693 E-.08281
G1 X126.124 Y138.693 E-.19467
G1 X126.253 Y138.616 E-.05713
G1 X126.468 Y138.563 E-.08411
; WIPE_END
G1 E-.04 F1800
G1 X124.038 Y139.527 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.10833
G1 F15000
G1 X123.929 Y139.651 E.00086
G1 X123.308 Y139.839 F30000
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X122.984 Y139.904 E.00895
; LINE_WIDTH: 0.364815
G1 F7455.85
G1 X122.887 Y139.92 E.0025
; LINE_WIDTH: 0.330756
G1 F8338.083
G1 X122.777 Y139.937 E.00252
; LINE_WIDTH: 0.29613
G1 F9478.308
G1 X122.633 Y139.954 E.0029
; LINE_WIDTH: 0.26195
G1 F10957.438
G1 X122.489 Y139.972 E.00251
; LINE_WIDTH: 0.226142
G1 F13098.916
G1 X122.331 Y139.99 E.00231
; LINE_WIDTH: 0.197737
G1 F15000
G1 X121.667 Y139.989 E.00812
; LINE_WIDTH: 0.224994
G1 F13181.497
G1 X121.508 Y139.974 E.00229
; LINE_WIDTH: 0.2578
G1 F11169.054
G1 X121.334 Y139.956 E.00297
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X121.228 Y139.939 E.00212
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X121.122 Y139.921 E.00242
; LINE_WIDTH: 0.379928
G1 F7121.498
G1 X120.692 Y139.839 E.01167
G1 X120.071 Y139.651 F30000
; LINE_WIDTH: 0.108329
G1 F15000
G1 X119.962 Y139.527 E.00086
; WIPE_START
G1 X120.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X118.819 Y138.187 Z1.6 F30000
G1 Z1.2
G1 E.8 F1800
; LINE_WIDTH: 0.534808
G1 F4879.164
G1 X118.515 Y137.974 E.01442
G1 X118.513 Y137.942 E.00125
G1 X118.5 Y137.541 E.0156
G1 X118.5 Y128.459 E.35289
G1 X118.515 Y128.025 E.01685
G1 X118.82 Y127.813 E.01446
G1 X118.663 Y126.856 F30000
; LINE_WIDTH: 0.138573
G1 F15000
G1 X118.769 Y126.704 E.00141
; LINE_WIDTH: 0.110808
G1 X118.876 Y126.551 E.001
G1 X119.178 Y125.95 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X118.969 Y126.191 E.01028
G1 X118.807 Y126.079 E.00632
G1 X118.807 Y124.967 E.03576
G1 X119.265 Y124.639 E.01809
G1 X119.701 Y124.531 E.01447
G1 X120.138 Y124.722 E.01533
G1 X120.385 Y125.056 E.01335
G1 X120.542 Y124.979 E.00562
G1 X121.014 Y124.818 E.01603
G1 X121.503 Y124.721 E.01603
G1 X121.854 Y124.698 E.01133
G1 X122.463 Y124.714 E.01957
G1 X122.607 Y124.743 E.00474
G1 X122.759 Y124.639 E.00591
G1 X123.196 Y124.531 E.01447
G1 X123.632 Y124.722 E.01533
G1 X124.061 Y125.303 E.02322
G1 X124.506 Y125.614 E.01746
G1 X124.943 Y125.722 E.01447
G1 X125.38 Y125.531 E.01533
G1 X125.816 Y124.939 E.02367
G1 X126.253 Y124.639 E.01704
G1 X126.69 Y124.531 E.01447
G1 X127.127 Y124.722 E.01533
G1 X127.563 Y125.314 E.02367
G1 X128 Y125.614 E.01704
G1 X128.437 Y125.722 E.01447
G1 X128.874 Y125.531 E.01533
G1 X129.311 Y124.939 E.02367
G1 X129.747 Y124.639 E.01704
G1 X130.184 Y124.531 E.01447
G1 X130.621 Y124.722 E.01533
G1 X131.058 Y125.314 E.02367
G1 X131.517 Y125.62 E.01772
G1 X131.68 Y125.476 E.00698
G1 X132.094 Y125.199 E.01603
G1 X132.542 Y124.979 E.01604
G1 X132.948 Y124.841 E.01379
G1 X133.241 Y124.639 E.01146
G1 X133.678 Y124.531 E.01447
G1 X134.074 Y124.704 E.0139
G1 X134.463 Y124.714 E.01249
G1 X134.986 Y124.819 E.01717
G1 X135.459 Y124.979 E.01604
G1 X135.906 Y125.199 E.01603
G1 X136.041 Y125.289 E.00521
G1 X136.299 Y124.939 E.014
G1 X136.736 Y124.639 E.01704
G1 X137.172 Y124.531 E.01447
G1 X137.193 Y124.54 E.00071
G1 X137.193 Y123.219 E.04247
G1 X136.736 Y122.892 E.01807
G1 X136.299 Y122.784 E.01447
G1 X135.862 Y122.975 E.01533
G1 X135.425 Y123.567 E.02367
G1 X134.989 Y123.867 E.01704
G1 X134.552 Y123.975 E.01447
G1 X134.115 Y123.784 E.01533
G1 X133.678 Y123.192 E.02367
G1 X133.241 Y122.892 E.01704
G1 X132.805 Y122.784 E.01447
G1 X132.368 Y122.975 E.01533
G1 X131.931 Y123.567 E.02367
G1 X131.494 Y123.867 E.01704
G1 X131.058 Y123.975 E.01447
G1 X130.621 Y123.784 E.01533
G1 X130.184 Y123.192 E.02367
G1 X129.747 Y122.892 E.01704
G1 X129.311 Y122.784 E.01447
G1 X128.874 Y122.975 E.01533
G1 X128.437 Y123.567 E.02367
G1 X128 Y123.867 E.01704
G1 X127.563 Y123.975 E.01447
G1 X127.127 Y123.784 E.01533
G1 X126.69 Y123.192 E.02367
G1 X126.253 Y122.892 E.01704
G1 X125.816 Y122.784 E.01447
G1 X125.38 Y122.975 E.01533
G1 X124.943 Y123.567 E.02367
G1 X124.506 Y123.867 E.01704
G1 X124.069 Y123.975 E.01447
G1 X123.632 Y123.784 E.01533
G1 X123.196 Y123.192 E.02367
G1 X122.759 Y122.892 E.01704
G1 X122.322 Y122.784 E.01447
G1 X121.885 Y122.975 E.01533
G1 X121.449 Y123.567 E.02367
G1 X121.012 Y123.867 E.01704
G1 X120.575 Y123.975 E.01447
G1 X120.138 Y123.784 E.01533
G1 X119.701 Y123.192 E.02367
G1 X119.265 Y122.892 E.01704
G1 X118.828 Y122.784 E.01447
G1 X118.807 Y122.793 E.00072
G1 X118.807 Y121.473 E.04246
G1 X119.265 Y121.145 E.01809
G1 X119.701 Y121.037 E.01447
G1 X120.138 Y121.228 E.01533
G1 X120.575 Y121.82 E.02367
G1 X121.012 Y122.12 E.01704
G1 X121.449 Y122.228 E.01447
G1 X121.885 Y122.037 E.01533
G1 X122.322 Y121.445 E.02367
G1 X122.759 Y121.145 E.01704
G1 X123.196 Y121.037 E.01447
G1 X123.632 Y121.228 E.01533
G1 X124.069 Y121.82 E.02367
G1 X124.506 Y122.12 E.01704
G1 X124.943 Y122.228 E.01447
G1 X125.38 Y122.037 E.01533
G1 X125.816 Y121.445 E.02367
G1 X126.253 Y121.145 E.01704
G1 X126.69 Y121.037 E.01447
G1 X127.127 Y121.228 E.01533
G1 X127.563 Y121.82 E.02367
G1 X128 Y122.12 E.01704
G1 X128.437 Y122.228 E.01447
G1 X128.874 Y122.037 E.01533
G1 X129.311 Y121.445 E.02367
G1 X129.747 Y121.145 E.01704
G1 X130.184 Y121.037 E.01447
G1 X130.621 Y121.228 E.01533
G1 X131.058 Y121.82 E.02367
G1 X131.494 Y122.12 E.01704
G1 X131.931 Y122.228 E.01447
G1 X132.368 Y122.037 E.01533
G1 X132.805 Y121.445 E.02367
G1 X133.241 Y121.145 E.01704
G1 X133.678 Y121.037 E.01447
G1 X134.115 Y121.228 E.01533
G1 X134.552 Y121.82 E.02367
G1 X134.989 Y122.12 E.01704
G1 X135.425 Y122.228 E.01447
G1 X135.862 Y122.037 E.01533
G1 X136.299 Y121.445 E.02367
G1 X136.736 Y121.145 E.01704
G1 X137.172 Y121.037 E.01447
G1 X137.193 Y121.046 E.00071
G1 X137.193 Y119.725 E.04247
G1 X136.736 Y119.398 E.01807
G1 X136.299 Y119.29 E.01447
G1 X135.862 Y119.481 E.01533
G1 X135.425 Y120.073 E.02367
G1 X134.989 Y120.373 E.01704
G1 X134.552 Y120.481 E.01447
G1 X134.115 Y120.29 E.01533
G1 X133.678 Y119.698 E.02367
G1 X133.241 Y119.398 E.01704
G1 X132.805 Y119.29 E.01447
G1 X132.368 Y119.481 E.01533
G1 X131.931 Y120.073 E.02367
G1 X131.494 Y120.373 E.01704
G1 X131.058 Y120.481 E.01447
G1 X130.621 Y120.29 E.01533
G1 X130.184 Y119.698 E.02367
G1 X129.747 Y119.398 E.01704
G1 X129.311 Y119.29 E.01447
G1 X128.874 Y119.481 E.01533
G1 X128.437 Y120.073 E.02367
G1 X128 Y120.373 E.01704
G1 X127.563 Y120.481 E.01447
G1 X127.127 Y120.29 E.01533
G1 X126.69 Y119.698 E.02367
G1 X126.253 Y119.398 E.01704
G1 X125.816 Y119.29 E.01447
G1 X125.38 Y119.481 E.01533
G1 X124.943 Y120.073 E.02367
G1 X124.506 Y120.373 E.01704
G1 X124.069 Y120.481 E.01447
G1 X123.632 Y120.29 E.01533
G1 X123.196 Y119.698 E.02367
G1 X122.759 Y119.398 E.01704
G1 X122.322 Y119.29 E.01447
G1 X121.885 Y119.481 E.01533
G1 X121.449 Y120.073 E.02367
G1 X121.012 Y120.373 E.01704
G1 X120.575 Y120.481 E.01447
G1 X120.138 Y120.29 E.01533
G1 X119.701 Y119.698 E.02367
G1 X119.265 Y119.398 E.01704
G1 X118.828 Y119.29 E.01447
G1 X118.807 Y119.299 E.00072
G1 X118.807 Y117.978 E.04246
G1 X119.265 Y117.651 E.01809
G1 X119.701 Y117.543 E.01447
G1 X120.138 Y117.733 E.01533
G1 X120.575 Y118.326 E.02367
G1 X121.012 Y118.626 E.01704
G1 X121.449 Y118.734 E.01447
G1 X121.885 Y118.543 E.01533
G1 X122.322 Y117.951 E.02367
G1 X122.759 Y117.651 E.01704
G1 X123.196 Y117.543 E.01447
G1 X123.632 Y117.733 E.01533
G1 X124.069 Y118.326 E.02367
G1 X124.506 Y118.626 E.01704
G1 X124.943 Y118.734 E.01447
G1 X125.38 Y118.543 E.01533
G1 X125.816 Y117.951 E.02367
G1 X126.253 Y117.651 E.01704
G1 X126.69 Y117.543 E.01447
G1 X127.127 Y117.733 E.01533
G1 X127.563 Y118.326 E.02367
G1 X128 Y118.626 E.01704
G1 X128.437 Y118.734 E.01447
G1 X128.874 Y118.543 E.01533
G1 X129.311 Y117.951 E.02367
G1 X129.747 Y117.651 E.01704
G1 X130.184 Y117.543 E.01447
G1 X130.621 Y117.733 E.01533
G1 X131.058 Y118.326 E.02367
G1 X131.494 Y118.626 E.01704
G1 X131.931 Y118.734 E.01447
G1 X132.368 Y118.543 E.01533
G1 X132.805 Y117.951 E.02367
G1 X133.241 Y117.651 E.01704
G1 X133.678 Y117.543 E.01447
G1 X134.115 Y117.733 E.01533
G1 X134.552 Y118.326 E.02367
G1 X134.989 Y118.626 E.01704
G1 X135.425 Y118.734 E.01447
G1 X135.862 Y118.543 E.01533
G1 X136.299 Y117.951 E.02367
G1 X136.736 Y117.651 E.01704
G1 X137.172 Y117.543 E.01447
G1 X137.193 Y117.552 E.00071
G1 X137.193 Y116.307 E.04001
G1 X135.625 Y116.307 E.05039
G1 X135.425 Y116.579 E.01084
G1 X134.989 Y116.879 E.01704
G1 X134.552 Y116.987 E.01447
G1 X134.115 Y116.796 E.01533
G1 X133.755 Y116.307 E.01952
G1 X132.131 Y116.307 E.05221
G1 X131.931 Y116.579 E.01084
G1 X131.494 Y116.879 E.01704
G1 X131.058 Y116.987 E.01447
G1 X130.621 Y116.796 E.01533
G1 X130.261 Y116.307 E.01952
G1 X128.637 Y116.307 E.05221
G1 X128.437 Y116.579 E.01084
G1 X128 Y116.879 E.01704
G1 X127.563 Y116.987 E.01447
G1 X127.127 Y116.796 E.01533
G1 X126.766 Y116.307 E.01952
G1 X125.143 Y116.307 E.05221
G1 X124.943 Y116.579 E.01084
G1 X124.506 Y116.879 E.01704
G1 X124.069 Y116.987 E.01447
G1 X123.632 Y116.796 E.01533
G1 X123.272 Y116.307 E.01952
G1 X121.649 Y116.307 E.05221
G1 X121.449 Y116.579 E.01084
G1 X121.012 Y116.879 E.01704
G1 X120.575 Y116.987 E.01447
G1 X120.138 Y116.796 E.01533
G1 X119.778 Y116.307 E.01952
G1 X118.807 Y116.307 E.03121
G1 X118.807 Y116.965 E.02115
; CHANGE_LAYER
; Z_HEIGHT: 1.3
; LAYER_HEIGHT: 0.0999999
; WIPE_START
G1 F4200
G1 X118.807 Y116.307 E-.24991
G1 X119.778 Y116.307 E-.36885
G1 X119.999 Y116.607 E-.14124
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 10/152
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
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
G1 X125.123 Y111.803
G1 Z1.3
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F3000
G1 X125.123 Y113.911 E.08266
G1 X119.369 Y113.911 E.22562
G1 X119.369 Y111.615 E.09005
G1 X125.123 Y111.615 E.22562
G1 X125.123 Y108.738 E.11281
G1 X119.369 Y108.738 E.22562
; WIPE_START
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.7 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z1.7
G1 Z1.3
G1 E.8 F1800
G1 F3000
G1 X136.631 Y108.738 E.22562
G1 X136.631 Y111.615 E.11281
G1 X130.877 Y111.615 E.22562
G1 X130.877 Y113.911 E.09005
G1 X136.631 Y113.911 E.22562
G1 X136.631 Y111.803 E.08266
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.1
; WIPE_START
G1 X136.631 Y113.803 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 11/152
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
G17
G3 Z1.7 I1.217 J0 P1  F30000
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
G1 X133.154 Y126.458
G1 Z1.4
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F2400
M204 S5000
G1 X133.432 Y126.363 E.00875
G1 X133.856 Y126.298 E.01276
G1 X134.284 Y126.308 E.01276
G1 X134.572 Y126.365 E.00875
G1 X134.846 Y126.458 E.00861
G1 X135.105 Y126.586 E.00861
G1 X135.346 Y126.746 E.00861
G1 X135.563 Y126.937 E.00861
G1 X135.754 Y127.154 E.00861
G1 X135.914 Y127.395 E.00861
G1 X136.042 Y127.654 E.00861
G1 X136.135 Y127.928 E.00861
G1 X136.192 Y128.211 E.00861
G1 X136.21 Y128.493 E.00841
G1 X136.21 Y137.507 E.26848
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
G1 X136.042 Y138.346 E.00861
G1 X135.914 Y138.605 E.00861
G1 X135.754 Y138.846 E.00861
G1 X135.563 Y139.063 E.00861
G1 X135.346 Y139.254 E.00861
G1 X135.101 Y139.417 E.00875
G1 X134.714 Y139.588 E.0126
G1 X134.293 Y139.691 E.01292
G1 X134 Y139.71 E.00875
G1 X133.711 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
G1 X132.895 Y139.414 E.00861
G1 X132.654 Y139.254 E.00861
G1 X132.437 Y139.063 E.00861
G1 X132.246 Y138.846 E.00861
G1 X132.086 Y138.605 E.00861
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.865 Y127.928 E.00861
G1 X131.958 Y127.654 E.00861
G1 X132.086 Y127.395 E.00861
G1 X132.246 Y127.154 E.00861
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.895 Y126.586 E.00861
G1 X133.118 Y126.475 E.00742
; WIPE_START
M204 S10000
G1 X133.432 Y126.363 E-.12672
G1 X133.856 Y126.298 E-.16279
G1 X134.284 Y126.308 E-.1628
G1 X134.572 Y126.365 E-.11161
G1 X134.846 Y126.458 E-.10988
G1 X135.049 Y126.558 E-.0862
; WIPE_END
G1 E-.04 F1800
G1 X127.435 Y127.077 Z1.8 F30000
G1 X123.865 Y127.321 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X123.914 Y127.395 E.00265
G1 X124.042 Y127.654 E.00861
G1 X124.135 Y127.928 E.00861
G1 X124.192 Y128.211 E.00861
G1 X124.21 Y128.493 E.00841
G1 X124.21 Y137.507 E.26848
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.914 Y138.605 E.00861
G1 X123.754 Y138.846 E.00861
G1 X123.563 Y139.063 E.00861
G1 X123.346 Y139.254 E.00861
G1 X123.101 Y139.417 E.00875
G1 X122.714 Y139.588 E.0126
G1 X122.293 Y139.691 E.01292
G1 X122 Y139.71 E.00875
G1 X121.711 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
G1 X120.895 Y139.414 E.00861
G1 X120.654 Y139.254 E.00861
G1 X120.437 Y139.063 E.00861
G1 X120.246 Y138.846 E.00861
G1 X120.086 Y138.605 E.00861
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.865 Y127.928 E.00861
G1 X119.958 Y127.654 E.00861
G1 X120.086 Y127.395 E.00861
G1 X120.246 Y127.154 E.00861
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.895 Y126.586 E.00861
G1 X121.154 Y126.458 E.00861
G1 X121.432 Y126.363 E.00875
G1 X121.856 Y126.298 E.01276
G1 X122.284 Y126.308 E.01276
G1 X122.572 Y126.365 E.00875
G1 X122.846 Y126.458 E.00861
G1 X123.105 Y126.586 E.00861
G1 X123.346 Y126.746 E.00861
G1 X123.563 Y126.937 E.00861
G1 X123.754 Y127.154 E.00861
G1 X123.843 Y127.287 E.00476
; WIPE_START
M204 S10000
G1 X123.914 Y127.395 E-.04906
G1 X124.042 Y127.654 E-.10988
G1 X124.135 Y127.928 E-.10989
G1 X124.192 Y128.211 E-.10984
M73 P44 R16
G1 X124.21 Y128.493 E-.10732
G1 X124.21 Y129.214 E-.27402
; WIPE_END
G1 E-.04 F1800
G1 X129.622 Y123.833 Z1.8 F30000
G1 X137.541 Y115.959 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X137.541 Y127.547 E.37263
G1 X137.336 Y127.581 E.00666
G1 X137.199 Y127.175 E.01378
G1 X136.998 Y126.769 E.01456
G1 X136.747 Y126.392 E.01456
G1 X136.448 Y126.052 E.01456
G1 X136.108 Y125.753 E.01456
G1 X135.731 Y125.502 E.01456
G1 X135.325 Y125.301 E.01456
G1 X134.896 Y125.156 E.01457
G1 X134.42 Y125.061 E.01559
G1 X133.774 Y125.047 E.0208
G1 X133.134 Y125.145 E.02081
G1 X132.675 Y125.301 E.01559
G1 X132.269 Y125.502 E.01457
G1 X131.892 Y125.753 E.01456
G1 X131.552 Y126.052 E.01456
G1 X131.253 Y126.392 E.01456
G1 X131.002 Y126.769 E.01456
G1 X130.801 Y127.175 E.01456
G1 X130.656 Y127.604 E.01457
G1 X130.567 Y128.048 E.01455
G1 X130.541 Y128.452 E.01304
G1 X130.541 Y137.548 E.29247
G1 X130.567 Y137.952 E.01304
G1 X130.656 Y138.396 E.01455
G1 X130.801 Y138.825 E.01457
G1 X130.908 Y139.041 E.00774
G1 X125.092 Y139.041 E.18701
G1 X125.199 Y138.825 E.00774
G1 X125.344 Y138.396 E.01457
G1 X125.433 Y137.952 E.01455
G1 X125.459 Y137.548 E.01304
G1 X125.459 Y128.452 E.29247
G1 X125.433 Y128.048 E.01303
G1 X125.344 Y127.604 E.01455
G1 X125.199 Y127.175 E.01457
G1 X124.998 Y126.769 E.01456
G1 X124.747 Y126.392 E.01456
G1 X124.448 Y126.052 E.01456
G1 X124.108 Y125.753 E.01456
G1 X123.731 Y125.502 E.01456
G1 X123.325 Y125.301 E.01456
G1 X122.896 Y125.156 E.01457
G1 X122.42 Y125.061 E.01559
G1 X121.774 Y125.047 E.0208
G1 X121.134 Y125.145 E.02081
G1 X120.675 Y125.301 E.01559
G1 X120.269 Y125.502 E.01457
G1 X119.892 Y125.753 E.01456
G1 X119.552 Y126.052 E.01456
G1 X119.253 Y126.392 E.01456
G1 X119.002 Y126.769 E.01456
G1 X118.801 Y127.175 E.01456
G1 X118.664 Y127.581 E.01378
G1 X118.459 Y127.547 E.00666
G1 X118.459 Y115.959 E.37263
G1 X137.501 Y115.959 E.61231
; WIPE_START
G1 X137.508 Y117.959 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.444 Y125.591 Z1.8 F30000
G1 X137.336 Y138.419 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F3600
G1 X137.541 Y138.453 E.00666
G1 X137.541 Y139.041 E.01891
G1 X137.092 Y139.041 E.01443
G1 X137.199 Y138.825 E.00774
G1 X137.324 Y138.457 E.01249
; WIPE_START
G1 X137.541 Y138.453 E-.08772
G1 X137.541 Y139.041 E-.23728
G1 X137.092 Y139.041 E-.18106
G1 X137.199 Y138.825 E-.09715
G1 X137.324 Y138.457 E-.1568
; WIPE_END
G1 E-.04 F1800
G1 X129.691 Y138.442 Z1.8 F30000
G1 X118.664 Y138.419 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F3600
G1 X118.801 Y138.825 E.01378
G1 X118.908 Y139.041 E.00774
G1 X118.459 Y139.041 E.01443
G1 X118.459 Y138.453 E.01891
G1 X118.624 Y138.426 E.00538
; WIPE_START
G1 X118.801 Y138.825 E-.17646
G1 X118.908 Y139.041 E-.09724
G1 X118.459 Y139.041 E-.18123
G1 X118.459 Y138.453 E-.23751
G1 X118.624 Y138.426 E-.06756
; WIPE_END
G1 E-.04 F1800
G1 X123.55 Y132.595 Z1.8 F30000
G1 X137.948 Y115.552 Z1.8
G1 Z1.4
G1 E.8 F1800
G1 F3600
G1 X137.948 Y139.448 E.7684
G1 X136.364 Y139.448 E.05094
G1 X136.645 Y139.027 E.01627
G1 X136.822 Y138.669 E.01285
G1 X136.95 Y138.29 E.01285
G1 X137.028 Y137.899 E.01284
G1 X137.052 Y137.534 E.01175
G1 X137.052 Y128.466 E.29161
G1 X137.028 Y128.101 E.01175
G1 X136.95 Y127.71 E.01284
G1 X136.822 Y127.331 E.01285
G1 X136.645 Y126.973 E.01285
G1 X136.423 Y126.641 E.01285
G1 X136.16 Y126.34 E.01285
G1 X135.859 Y126.077 E.01285
G1 X135.527 Y125.855 E.01285
G1 X135.169 Y125.678 E.01285
G1 X134.79 Y125.55 E.01285
G1 X134.376 Y125.467 E.01359
G1 X133.8 Y125.455 E.01851
G1 X133.231 Y125.542 E.01851
G1 X132.831 Y125.678 E.01359
G1 X132.473 Y125.855 E.01285
G1 X132.141 Y126.077 E.01285
G1 X131.84 Y126.34 E.01285
G1 X131.577 Y126.641 E.01285
G1 X131.355 Y126.973 E.01284
G1 X131.178 Y127.331 E.01285
G1 X131.05 Y127.71 E.01285
G1 X130.972 Y128.101 E.01284
G1 X130.948 Y128.466 E.01175
G1 X130.948 Y137.534 E.29162
G1 X130.972 Y137.899 E.01175
G1 X131.05 Y138.29 E.01284
G1 X131.178 Y138.669 E.01285
G1 X131.355 Y139.027 E.01285
G1 X131.636 Y139.448 E.01627
G1 X124.364 Y139.448 E.23384
G1 X124.645 Y139.027 E.01627
G1 X124.822 Y138.669 E.01285
G1 X124.95 Y138.29 E.01285
G1 X125.028 Y137.899 E.01284
G1 X125.052 Y137.534 E.01175
G1 X125.052 Y128.466 E.29161
G1 X125.028 Y128.101 E.01175
G1 X124.95 Y127.71 E.01284
G1 X124.822 Y127.331 E.01285
G1 X124.645 Y126.973 E.01285
G1 X124.423 Y126.641 E.01285
G1 X124.16 Y126.34 E.01285
G1 X123.859 Y126.077 E.01285
G1 X123.527 Y125.855 E.01285
G1 X123.169 Y125.678 E.01285
G1 X122.79 Y125.55 E.01285
G1 X122.376 Y125.467 E.01359
G1 X121.8 Y125.455 E.01851
G1 X121.231 Y125.542 E.01851
G1 X120.831 Y125.678 E.01359
G1 X120.473 Y125.855 E.01285
G1 X120.141 Y126.077 E.01285
G1 X119.84 Y126.34 E.01285
G1 X119.577 Y126.641 E.01285
G1 X119.355 Y126.973 E.01284
G1 X119.178 Y127.331 E.01285
G1 X119.05 Y127.71 E.01285
G1 X118.972 Y128.101 E.01284
G1 X118.948 Y128.466 E.01175
G1 X118.948 Y137.534 E.29162
G1 X118.972 Y137.899 E.01175
G1 X119.05 Y138.29 E.01284
G1 X119.178 Y138.669 E.01285
G1 X119.355 Y139.027 E.01285
G1 X119.636 Y139.448 E.01627
G1 X118.052 Y139.448 E.05094
G1 X118.052 Y115.552 E.7684
G1 X137.908 Y115.552 E.63849
G1 X138.355 Y115.145 F30000
G1 F3600
G1 X138.355 Y139.855 E.79458
G1 X135.541 Y139.855 E.0905
G1 X135.488 Y139.682 E.00582
G1 X135.611 Y139.6 E.00475
G1 X135.871 Y139.371 E.01113
G1 X136.1 Y139.111 E.01113
G1 X136.292 Y138.823 E.01113
G1 X136.445 Y138.513 E.01113
G1 X136.556 Y138.185 E.01113
G1 X136.624 Y137.846 E.01112
G1 X136.645 Y137.521 E.01046
G1 X136.645 Y128.479 E.29076
G1 X136.624 Y128.154 E.01046
G1 X136.556 Y127.815 E.01113
G1 X136.445 Y127.487 E.01114
G1 X136.292 Y127.177 E.01113
G1 X136.1 Y126.889 E.01113
G1 X135.871 Y126.629 E.01113
G1 X135.611 Y126.401 E.01113
G1 X135.323 Y126.208 E.01113
G1 X135.013 Y126.055 E.01113
G1 X134.685 Y125.944 E.01113
G1 X134.332 Y125.873 E.01159
G1 X133.827 Y125.862 E.01622
G1 X133.329 Y125.939 E.01622
G1 X132.987 Y126.055 E.01159
G1 X132.677 Y126.208 E.01113
G1 X132.389 Y126.401 E.01113
G1 X132.129 Y126.629 E.01113
G1 X131.9 Y126.889 E.01113
G1 X131.708 Y127.177 E.01113
G1 X131.555 Y127.487 E.01113
G1 X131.444 Y127.815 E.01113
G1 X131.376 Y128.154 E.01112
G1 X131.355 Y128.479 E.01046
G1 X131.355 Y137.521 E.29076
G1 X131.376 Y137.846 E.01046
G1 X131.444 Y138.185 E.01112
G1 X131.555 Y138.513 E.01113
G1 X131.708 Y138.823 E.01113
G1 X131.901 Y139.111 E.01113
G1 X132.129 Y139.371 E.01113
G1 X132.389 Y139.6 E.01113
G1 X132.512 Y139.682 E.00475
G1 X132.459 Y139.855 E.00582
G1 X123.541 Y139.855 E.2868
G1 X123.488 Y139.682 E.00582
G1 X123.611 Y139.6 E.00475
G1 X123.871 Y139.371 E.01113
G1 X124.1 Y139.111 E.01113
G1 X124.292 Y138.823 E.01113
G1 X124.445 Y138.513 E.01113
G1 X124.556 Y138.185 E.01113
G1 X124.624 Y137.846 E.01112
G1 X124.645 Y137.521 E.01046
G1 X124.645 Y128.479 E.29076
G1 X124.624 Y128.154 E.01046
G1 X124.556 Y127.815 E.01112
G1 X124.445 Y127.487 E.01114
G1 X124.292 Y127.177 E.01113
G1 X124.1 Y126.889 E.01113
G1 X123.871 Y126.629 E.01113
G1 X123.611 Y126.401 E.01113
G1 X123.323 Y126.208 E.01113
G1 X123.013 Y126.055 E.01113
G1 X122.685 Y125.944 E.01113
G1 X122.332 Y125.873 E.01159
G1 X121.827 Y125.862 E.01622
G1 X121.329 Y125.939 E.01622
G1 X120.987 Y126.055 E.01159
G1 X120.677 Y126.208 E.01113
G1 X120.389 Y126.401 E.01113
G1 X120.129 Y126.629 E.01113
G1 X119.9 Y126.889 E.01113
G1 X119.708 Y127.177 E.01113
G1 X119.555 Y127.487 E.01113
G1 X119.444 Y127.815 E.01114
G1 X119.376 Y128.154 E.01112
G1 X119.355 Y128.479 E.01046
G1 X119.355 Y137.521 E.29076
G1 X119.376 Y137.846 E.01046
G1 X119.444 Y138.185 E.01112
G1 X119.555 Y138.513 E.01113
G1 X119.708 Y138.823 E.01113
G1 X119.901 Y139.111 E.01113
G1 X120.129 Y139.371 E.01113
G1 X120.389 Y139.6 E.01113
G1 X120.512 Y139.682 E.00475
G1 X120.459 Y139.855 E.00582
G1 X117.645 Y139.855 E.0905
G1 X117.645 Y115.145 E.79458
G1 X138.315 Y115.145 E.66467
M204 S250
G1 X138.79 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
; WIPE_START
M204 S10000
G1 X138.753 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.474 Y124.234 Z1.8 F30000
G1 X137.193 Y125.886 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X137.193 Y126.118 E.00744
G1 X137.049 Y126.217 E.00563
G1 X136.695 Y125.805 E.01747
G1 X136.32 Y125.476 E.01602
G1 X136.171 Y125.376 E.00579
G1 X136.241 Y125.127 E.00835
G1 X136.556 Y124.69 E.01732
G1 X137.183 Y124.253 E.02456
G1 X137.193 Y124.228 E.00086
G1 X137.193 Y123.327 E.02896
G1 X136.915 Y122.943 E.01525
G1 X136.289 Y122.506 E.02456
G1 X136.118 Y122.069 E.01508
G1 X136.241 Y121.632 E.01459
G1 X136.556 Y121.196 E.01732
G1 X137.183 Y120.759 E.02456
G1 X137.193 Y119.833 E.02977
G1 X136.915 Y119.449 E.01525
G1 X136.289 Y119.012 E.02456
G1 X136.118 Y118.575 E.01508
G1 X136.241 Y118.138 E.01459
G1 X136.556 Y117.701 E.01732
G1 X137.183 Y117.265 E.02456
G1 X137.193 Y116.307 E.03078
G1 X135.507 Y116.307 E.05421
G1 X135.483 Y116.391 E.0028
G1 X135.168 Y116.828 E.01732
G1 X134.541 Y117.265 E.02456
G1 X134.371 Y117.701 E.01508
G1 X134.494 Y118.138 E.01459
G1 X134.809 Y118.575 E.01732
G1 X135.436 Y119.012 E.02456
G1 X135.606 Y119.449 E.01508
G1 X135.483 Y119.885 E.01459
G1 X135.168 Y120.322 E.01732
G1 X134.541 Y120.759 E.02456
G1 X134.371 Y121.196 E.01508
G1 X134.494 Y121.632 E.01459
G1 X134.809 Y122.069 E.01732
G1 X135.436 Y122.506 E.02456
G1 X135.606 Y122.943 E.01508
G1 X135.483 Y123.38 E.01459
G1 X135.168 Y123.816 E.01732
G1 X134.541 Y124.253 E.02456
G1 X134.371 Y124.69 E.01508
G1 X134.377 Y124.712 E.00073
G1 X133.751 Y124.698 E.02014
G1 X133.051 Y124.806 E.02276
G1 X132.955 Y124.838 E.00327
G1 X133.062 Y124.69 E.00589
G1 X133.689 Y124.253 E.02456
G1 X133.859 Y123.816 E.01508
G1 X133.736 Y123.38 E.01459
G1 X133.421 Y122.943 E.01732
G1 X132.794 Y122.506 E.02456
G1 X132.624 Y122.069 E.01508
G1 X132.747 Y121.632 E.01459
G1 X133.062 Y121.196 E.01732
G1 X133.689 Y120.759 E.02456
G1 X133.859 Y120.322 E.01508
G1 X133.736 Y119.885 E.01459
G1 X133.421 Y119.449 E.01732
G1 X132.794 Y119.012 E.02456
G1 X132.624 Y118.575 E.01508
G1 X132.747 Y118.138 E.01459
G1 X133.062 Y117.701 E.01732
G1 X133.689 Y117.265 E.02456
G1 X133.859 Y116.828 E.01508
G1 X133.736 Y116.391 E.01459
G1 X133.676 Y116.307 E.00332
G1 X132.012 Y116.307 E.05348
G1 X131.989 Y116.391 E.0028
G1 X131.674 Y116.828 E.01732
G1 X131.047 Y117.265 E.02456
G1 X130.877 Y117.701 E.01508
G1 X131 Y118.138 E.01459
G1 X131.315 Y118.575 E.01732
G1 X131.942 Y119.012 E.02456
G1 X132.112 Y119.449 E.01508
G1 X131.989 Y119.885 E.01459
G1 X131.674 Y120.322 E.01732
G1 X131.047 Y120.759 E.02456
G1 X130.877 Y121.196 E.01508
G1 X131 Y121.632 E.01459
G1 X131.315 Y122.069 E.01732
G1 X131.942 Y122.506 E.02456
G1 X132.112 Y122.943 E.01508
G1 X131.989 Y123.38 E.01459
G1 X131.674 Y123.816 E.01732
G1 X131.047 Y124.253 E.02456
G1 X130.877 Y124.69 E.01508
G1 X131 Y125.127 E.01459
G1 X131.315 Y125.563 E.01732
G1 X131.463 Y125.667 E.0058
G1 X131.68 Y125.476 E.00927
G1 X132.094 Y125.199 E.01603
G1 X132.542 Y124.979 E.01604
G1 X132.762 Y124.904 E.00749
; WIPE_START
G1 X132.542 Y124.979 E-.08851
G1 X132.094 Y125.199 E-.18953
G1 X131.68 Y125.476 E-.18947
G1 X131.463 Y125.667 E-.10956
G1 X131.315 Y125.563 E-.06855
G1 X131.139 Y125.319 E-.11438
; WIPE_END
G1 E-.04 F1800
G1 X137.144 Y126.575 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.124415
G1 F15000
G1 X137.337 Y126.854 E.00218
G1 X137.179 Y127.814 F30000
; LINE_WIDTH: 0.534808
G1 F4879.158
G1 X137.485 Y128.026 E.01448
G1 X137.487 Y128.058 E.00126
G1 X137.5 Y128.459 E.0156
G1 X137.5 Y137.541 E.35289
G1 X137.485 Y137.974 E.01685
G1 X137.178 Y138.187 E.01449
; WIPE_START
G1 X137.485 Y137.974 E-.14166
G1 X137.5 Y137.541 E-.16481
G1 X137.5 Y136.348 E-.45353
; WIPE_END
G1 E-.04 F1800
G1 X136.038 Y139.527 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.108334
G1 F15000
G1 X135.929 Y139.651 E.00086
G1 X135.312 Y139.85 F30000
; LINE_WIDTH: 0.329311
G1 F8380.169
G1 X134.819 Y139.931 E.0113
; LINE_WIDTH: 0.306106
G1 F9119.04
G1 X134.661 Y139.95 E.00329
; LINE_WIDTH: 0.267997
G1 F10663.028
G1 X134.504 Y139.969 E.00282
; LINE_WIDTH: 0.228177
G1 F12954.975
G1 X134.332 Y139.99 E.00253
; LINE_WIDTH: 0.197752
G1 F15000
G1 X133.667 Y139.989 E.00814
; LINE_WIDTH: 0.224994
G1 F13181.497
G1 X133.508 Y139.974 E.00229
; LINE_WIDTH: 0.2578
G1 F11169.049
G1 X133.334 Y139.956 E.00297
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X133.228 Y139.939 E.00212
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X133.122 Y139.921 E.00242
; LINE_WIDTH: 0.379929
G1 F7121.488
G1 X132.692 Y139.839 E.01167
G1 X132.071 Y139.651 F30000
; LINE_WIDTH: 0.108328
G1 F15000
G1 X131.962 Y139.527 E.00086
; WIPE_START
G1 X132.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X128.497 Y132.908 Z1.8 F30000
G1 X125.707 Y127.643 Z1.8
G1 Z1.4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X125.681 Y127.514 E.00423
G1 X125.521 Y127.041 E.01604
G1 X125.301 Y126.594 E.01603
G1 X125.023 Y126.179 E.01606
G1 X124.953 Y126 E.00618
G1 X124.729 Y125.844 E.00878
G1 X124.32 Y125.476 E.01768
G1 X124.211 Y125.403 E.00422
G1 X124.012 Y125.127 E.01098
G1 X123.888 Y124.69 E.01459
G1 X124.059 Y124.253 E.01508
G1 X124.685 Y123.816 E.02456
G1 X125 Y123.38 E.01732
G1 X125.124 Y122.943 E.01459
G1 X124.953 Y122.506 E.01508
G1 X124.326 Y122.069 E.02456
G1 X124.012 Y121.632 E.01732
G1 X123.888 Y121.196 E.01459
G1 X124.059 Y120.759 E.01508
G1 X124.685 Y120.322 E.02456
G1 X125 Y119.885 E.01732
G1 X125.124 Y119.449 E.01459
G1 X124.953 Y119.012 E.01508
G1 X124.326 Y118.575 E.02456
G1 X124.012 Y118.138 E.01732
G1 X123.888 Y117.701 E.01459
G1 X124.059 Y117.265 E.01508
G1 X124.685 Y116.828 E.02456
G1 X125 Y116.391 E.01732
G1 X125.024 Y116.307 E.0028
G1 X126.687 Y116.307 E.05348
G1 X126.748 Y116.391 E.00332
G1 X126.871 Y116.828 E.01459
G1 X126.7 Y117.265 E.01508
G1 X126.074 Y117.701 E.02456
G1 X125.759 Y118.138 E.01732
G1 X125.635 Y118.575 E.01459
G1 X125.806 Y119.012 E.01508
G1 X126.433 Y119.449 E.02456
G1 X126.748 Y119.885 E.01732
G1 X126.871 Y120.322 E.01459
G1 X126.7 Y120.759 E.01508
G1 X126.074 Y121.196 E.02456
G1 X125.759 Y121.632 E.01732
G1 X125.635 Y122.069 E.01459
G1 X125.806 Y122.506 E.01508
G1 X126.433 Y122.943 E.02456
G1 X126.748 Y123.38 E.01732
G1 X126.871 Y123.816 E.01459
G1 X126.7 Y124.253 E.01508
G1 X126.074 Y124.69 E.02456
G1 X125.759 Y125.127 E.01732
G1 X125.635 Y125.563 E.01459
G1 X125.806 Y126 E.01508
G1 X126.433 Y126.437 E.02456
G1 X126.748 Y126.874 E.01732
G1 X126.871 Y127.311 E.01459
G1 X126.7 Y127.747 E.01508
G1 X126.074 Y128.184 E.02456
G1 X125.807 Y128.553 E.01464
G1 X125.807 Y129.495 E.0303
G1 X126.433 Y129.931 E.0245
G1 X126.748 Y130.368 E.01732
G1 X126.871 Y130.805 E.01459
G1 X126.7 Y131.241 E.01508
G1 X126.074 Y131.678 E.02456
G1 X125.807 Y132.047 E.01464
G1 X125.807 Y132.99 E.0303
G1 X126.433 Y133.425 E.0245
G1 X126.748 Y133.862 E.01732
G1 X126.871 Y134.299 E.01459
G1 X126.7 Y134.736 E.01508
G1 X126.074 Y135.172 E.02456
G1 X125.807 Y135.542 E.01463
G1 X125.807 Y136.484 E.0303
G1 X126.433 Y136.92 E.0245
G1 X126.748 Y137.356 E.01732
G1 X126.871 Y137.793 E.01459
G1 X126.7 Y138.23 E.01508
G1 X126.055 Y138.693 E.02553
G1 X127.39 Y138.693 E.04292
G1 X127.382 Y138.667 E.00087
G1 X127.553 Y138.23 E.01508
G1 X128.18 Y137.793 E.02456
G1 X128.495 Y137.356 E.01732
G1 X128.618 Y136.92 E.01459
G1 X128.447 Y136.483 E.01508
G1 X127.821 Y136.046 E.02456
G1 X127.506 Y135.609 E.01732
G1 X127.382 Y135.172 E.01459
G1 X127.553 Y134.736 E.01508
G1 X128.18 Y134.299 E.02456
G1 X128.495 Y133.862 E.01732
G1 X128.618 Y133.425 E.01459
G1 X128.447 Y132.989 E.01508
G1 X127.821 Y132.552 E.02456
G1 X127.506 Y132.115 E.01732
G1 X127.382 Y131.678 E.01459
G1 X127.553 Y131.241 E.01508
G1 X128.18 Y130.805 E.02456
G1 X128.495 Y130.368 E.01732
G1 X128.618 Y129.931 E.01459
G1 X128.447 Y129.494 E.01508
G1 X127.821 Y129.058 E.02456
G1 X127.506 Y128.621 E.01732
G1 X127.382 Y128.184 E.01459
G1 X127.553 Y127.747 E.01508
G1 X128.18 Y127.311 E.02456
G1 X128.495 Y126.874 E.01732
G1 X128.618 Y126.437 E.01459
G1 X128.447 Y126 E.01508
G1 X127.821 Y125.563 E.02456
G1 X127.506 Y125.127 E.01732
G1 X127.382 Y124.69 E.01459
G1 X127.553 Y124.253 E.01508
G1 X128.18 Y123.816 E.02456
G1 X128.495 Y123.38 E.01732
G1 X128.618 Y122.943 E.01459
G1 X128.447 Y122.506 E.01508
G1 X127.821 Y122.069 E.02456
G1 X127.506 Y121.632 E.01732
G1 X127.382 Y121.196 E.01459
G1 X127.553 Y120.759 E.01508
G1 X128.18 Y120.322 E.02456
G1 X128.495 Y119.885 E.01732
G1 X128.618 Y119.449 E.01459
G1 X128.447 Y119.012 E.01508
G1 X127.821 Y118.575 E.02456
G1 X127.506 Y118.138 E.01732
G1 X127.382 Y117.701 E.01459
G1 X127.553 Y117.265 E.01508
G1 X128.18 Y116.828 E.02456
G1 X128.495 Y116.391 E.01732
G1 X128.518 Y116.307 E.0028
G1 X130.181 Y116.307 E.05348
G1 X130.242 Y116.391 E.00332
G1 X130.365 Y116.828 E.01459
G1 X130.194 Y117.265 E.01508
G1 X129.568 Y117.701 E.02456
G1 X129.253 Y118.138 E.01732
G1 X129.13 Y118.575 E.01459
G1 X129.3 Y119.012 E.01508
G1 X129.927 Y119.449 E.02456
G1 X130.242 Y119.885 E.01732
G1 X130.365 Y120.322 E.01459
G1 X130.194 Y120.759 E.01508
G1 X129.568 Y121.196 E.02456
G1 X129.253 Y121.632 E.01732
G1 X129.13 Y122.069 E.01459
M73 P44 R15
G1 X129.3 Y122.506 E.01508
G1 X129.927 Y122.943 E.02456
G1 X130.242 Y123.38 E.01732
G1 X130.365 Y123.816 E.01459
G1 X130.194 Y124.253 E.01508
G1 X129.568 Y124.69 E.02456
G1 X129.253 Y125.127 E.01732
G1 X129.13 Y125.563 E.01459
G1 X129.3 Y126 E.01508
G1 X129.927 Y126.437 E.02456
G1 X130.242 Y126.874 E.01732
G1 X130.365 Y127.311 E.01459
G1 X130.194 Y127.747 E.01508
G1 X129.568 Y128.184 E.02456
G1 X129.253 Y128.621 E.01732
G1 X129.13 Y129.058 E.01459
G1 X129.3 Y129.494 E.01508
G1 X129.927 Y129.931 E.02456
G1 X130.193 Y130.3 E.01461
G1 X130.193 Y131.243 E.03032
G1 X129.568 Y131.678 E.02449
G1 X129.253 Y132.115 E.01732
G1 X129.13 Y132.552 E.01459
G1 X129.3 Y132.989 E.01508
G1 X129.927 Y133.425 E.02456
G1 X130.193 Y133.794 E.01461
G1 X130.193 Y134.737 E.03032
G1 X129.568 Y135.172 E.02449
G1 X129.253 Y135.609 E.01732
G1 X129.13 Y136.046 E.01459
G1 X129.3 Y136.483 E.01508
G1 X129.927 Y136.92 E.02456
G1 X130.193 Y137.288 E.01461
G1 X130.193 Y137.559 E.00871
G1 X130.243 Y138.106 E.01766
G1 X130.194 Y138.23 E.00428
G1 X129.549 Y138.693 E.02553
G1 X127.921 Y138.693 E.05236
; WIPE_START
G1 X129.549 Y138.693 E-.61876
G1 X129.851 Y138.476 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X124.038 Y139.527 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.108334
G1 F15000
G1 X123.929 Y139.651 E.00086
G1 X123.312 Y139.85 F30000
; LINE_WIDTH: 0.329311
G1 F8380.169
G1 X122.819 Y139.931 E.0113
; LINE_WIDTH: 0.306106
G1 F9119.04
G1 X122.661 Y139.95 E.00329
; LINE_WIDTH: 0.267997
G1 F10663.028
G1 X122.504 Y139.969 E.00282
; LINE_WIDTH: 0.228177
G1 F12954.969
G1 X122.332 Y139.99 E.00253
; LINE_WIDTH: 0.197752
G1 F15000
G1 X121.667 Y139.989 E.00814
; LINE_WIDTH: 0.224994
G1 F13181.497
G1 X121.508 Y139.974 E.00229
; LINE_WIDTH: 0.2578
G1 F11169.054
G1 X121.334 Y139.956 E.00297
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X121.228 Y139.939 E.00212
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X121.122 Y139.921 E.00242
; LINE_WIDTH: 0.379928
G1 F7121.5
G1 X120.692 Y139.839 E.01167
G1 X120.071 Y139.651 F30000
; LINE_WIDTH: 0.108328
G1 F15000
G1 X119.962 Y139.527 E.00086
; WIPE_START
G1 X120.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X118.822 Y138.187 Z1.8 F30000
G1 Z1.4
G1 E.8 F1800
; LINE_WIDTH: 0.534804
G1 F4879.199
G1 X118.515 Y137.974 E.01448
G1 X118.5 Y137.541 E.01685
G1 X118.5 Y128.459 E.35289
G1 X118.513 Y128.058 E.0156
G1 X118.515 Y128.025 E.00125
G1 X118.819 Y127.813 E.01442
G1 X118.663 Y126.854 F30000
; LINE_WIDTH: 0.124417
G1 F15000
G1 X118.856 Y126.575 E.00219
G1 X120.938 Y124.844 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X121.051 Y124.806 E.00386
G1 X121.751 Y124.698 E.02276
G1 X122.458 Y124.714 E.02276
G1 X122.549 Y124.732 E.00298
G1 X122.579 Y124.69 E.00166
G1 X123.206 Y124.253 E.02456
G1 X123.377 Y123.816 E.01508
G1 X123.253 Y123.38 E.01459
G1 X122.938 Y122.943 E.01732
G1 X122.312 Y122.506 E.02456
G1 X122.141 Y122.069 E.01508
G1 X122.264 Y121.632 E.01459
G1 X122.579 Y121.196 E.01732
G1 X123.206 Y120.759 E.02456
G1 X123.377 Y120.322 E.01508
G1 X123.253 Y119.885 E.01459
G1 X122.938 Y119.449 E.01732
G1 X122.312 Y119.012 E.02456
G1 X122.141 Y118.575 E.01508
G1 X122.264 Y118.138 E.01459
G1 X122.579 Y117.701 E.01732
G1 X123.206 Y117.265 E.02456
G1 X123.377 Y116.828 E.01508
G1 X123.253 Y116.391 E.01459
G1 X123.193 Y116.307 E.00332
G1 X121.53 Y116.307 E.05348
G1 X121.506 Y116.391 E.0028
G1 X121.191 Y116.828 E.01732
G1 X120.565 Y117.265 E.02456
G1 X120.394 Y117.701 E.01508
G1 X120.517 Y118.138 E.01459
G1 X120.832 Y118.575 E.01732
G1 X121.459 Y119.012 E.02456
G1 X121.63 Y119.449 E.01508
G1 X121.506 Y119.885 E.01459
G1 X121.191 Y120.322 E.01732
G1 X120.565 Y120.759 E.02456
G1 X120.394 Y121.196 E.01508
G1 X120.517 Y121.632 E.01459
G1 X120.832 Y122.069 E.01732
G1 X121.459 Y122.506 E.02456
G1 X121.63 Y122.943 E.01508
G1 X121.506 Y123.38 E.01459
G1 X121.191 Y123.816 E.01732
G1 X120.565 Y124.253 E.02456
G1 X120.394 Y124.69 E.01508
G1 X120.484 Y125.007 E.01061
G1 X120.094 Y125.199 E.01396
G1 X119.68 Y125.476 E.01603
G1 X119.305 Y125.805 E.01603
G1 X118.951 Y126.217 E.01747
G1 X118.807 Y126.118 E.00563
G1 X118.807 Y125.075 E.03353
G1 X119.085 Y124.69 E.01527
G1 X119.712 Y124.253 E.02456
G1 X119.882 Y123.816 E.01508
G1 X119.759 Y123.38 E.01459
G1 X119.444 Y122.943 E.01732
G1 X118.818 Y122.506 E.02456
G1 X118.807 Y121.581 E.02975
G1 X119.085 Y121.196 E.01527
G1 X119.712 Y120.759 E.02456
G1 X119.882 Y120.322 E.01508
G1 X119.759 Y119.885 E.01459
G1 X119.444 Y119.449 E.01732
G1 X118.818 Y119.012 E.02456
G1 X118.807 Y118.087 E.02975
G1 X119.085 Y117.701 E.01527
G1 X119.712 Y117.265 E.02456
G1 X119.882 Y116.828 E.01508
G1 X119.759 Y116.391 E.01459
G1 X119.699 Y116.307 E.00332
G1 X118.807 Y116.307 E.02866
G1 X118.807 Y117.044 E.0237
; CHANGE_LAYER
; Z_HEIGHT: 1.575
; LAYER_HEIGHT: 0.175
; WIPE_START
G1 F4200
G1 X118.807 Y116.307 E-.28005
G1 X119.699 Y116.307 E-.33871
G1 X119.759 Y116.391 E-.03923
G1 X119.832 Y116.649 E-.10201
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 12/152
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
M106 S112.2
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
G1 X125.123 Y111.803
G1 Z1.575
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F3000
G1 X125.123 Y113.911 E.08266
G1 X119.369 Y113.911 E.22562
G1 X119.369 Y111.615 E.09005
G1 X125.123 Y111.615 E.22562
G1 X125.123 Y108.738 E.11281
G1 X119.369 Y108.738 E.22562
; WIPE_START
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z1.975 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z1.975
G1 Z1.575
G1 E.8 F1800
G1 F3000
G1 X136.631 Y108.738 E.22562
G1 X136.631 Y111.615 E.11281
G1 X130.877 Y111.615 E.22562
G1 X130.877 Y113.911 E.09005
G1 X136.631 Y113.911 E.22562
G1 X136.631 Y111.803 E.08266
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.025
; WIPE_START
G1 X136.631 Y113.803 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 13/152
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
G17
G3 Z1.975 I1.217 J0 P1  F30000
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
G1 X133.154 Y126.458
G1 Z1.6
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F2400
M204 S5000
G1 X133.432 Y126.363 E.00873
G1 X133.826 Y126.301 E.01189
G1 X134 Y126.29 E.00519
G1 X134.289 Y126.308 E.00861
G1 X134.572 Y126.365 E.00861
G1 X134.846 Y126.458 E.00861
G1 X135.105 Y126.586 E.00861
G1 X135.346 Y126.746 E.00861
G1 X135.563 Y126.937 E.00861
G1 X135.754 Y127.154 E.00861
G1 X136.041 Y127.65 E.01707
G1 X136.135 Y127.928 E.00874
G1 X136.192 Y128.211 E.00861
G1 X136.21 Y128.493 E.00841
G1 X136.21 Y137.507 E.26848
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
G1 X136.042 Y138.346 E.00861
G1 X135.914 Y138.605 E.00861
G1 X135.754 Y138.846 E.00861
G1 X135.563 Y139.063 E.00861
G1 X135.346 Y139.254 E.00861
G1 X135.105 Y139.414 E.00861
G1 X134.846 Y139.542 E.00861
G1 X134.572 Y139.635 E.00861
G1 X134.289 Y139.692 E.00861
G1 X134 Y139.71 E.00861
G1 X133.711 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
G1 X132.895 Y139.414 E.00861
G1 X132.654 Y139.254 E.00861
G1 X132.437 Y139.063 E.00861
G1 X132.246 Y138.846 E.00861
G1 X132.086 Y138.605 E.00861
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.865 Y127.928 E.00861
G1 X131.958 Y127.654 E.00861
G1 X132.086 Y127.395 E.00862
G1 X132.246 Y127.154 E.00861
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.895 Y126.586 E.00861
G1 X133.118 Y126.475 E.00742
; WIPE_START
M204 S10000
G1 X133.432 Y126.363 E-.12652
G1 X133.826 Y126.301 E-.15169
G1 X134 Y126.29 E-.06625
G1 X134.289 Y126.308 E-.10988
G1 X134.572 Y126.365 E-.10987
G1 X134.846 Y126.458 E-.10987
G1 X135.049 Y126.558 E-.08593
; WIPE_END
G1 E-.04 F1800
G1 X127.433 Y127.06 Z2 F30000
G1 X123.837 Y127.298 Z2
G1 Z1.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X124.041 Y127.65 E.01213
G1 X124.135 Y127.928 E.00874
G1 X124.192 Y128.211 E.00861
G1 X124.21 Y128.493 E.00841
G1 X124.21 Y137.507 E.26848
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.914 Y138.605 E.00861
G1 X123.754 Y138.846 E.00861
G1 X123.563 Y139.063 E.00861
G1 X123.346 Y139.254 E.00861
G1 X123.105 Y139.414 E.00861
G1 X122.846 Y139.542 E.00861
M73 P45 R15
G1 X122.572 Y139.635 E.00861
G1 X122.289 Y139.692 E.00861
G1 X122 Y139.71 E.00861
G1 X121.711 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
G1 X120.895 Y139.414 E.00861
G1 X120.654 Y139.254 E.00861
G1 X120.437 Y139.063 E.00861
G1 X120.246 Y138.846 E.00861
G1 X120.086 Y138.605 E.00861
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.865 Y127.928 E.00861
G1 X119.958 Y127.654 E.00861
G1 X120.086 Y127.395 E.00862
G1 X120.246 Y127.154 E.00861
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.895 Y126.586 E.00861
G1 X121.154 Y126.458 E.00861
G1 X121.432 Y126.363 E.00873
G1 X121.826 Y126.301 E.01189
G1 X122 Y126.29 E.00519
G1 X122.289 Y126.308 E.00861
G1 X122.572 Y126.365 E.00861
G1 X122.846 Y126.458 E.00861
G1 X123.105 Y126.586 E.00861
G1 X123.346 Y126.746 E.00861
G1 X123.563 Y126.937 E.00861
G1 X123.754 Y127.154 E.00861
G1 X123.817 Y127.263 E.00375
; WIPE_START
M204 S10000
G1 X124.041 Y127.65 E-.16994
G1 X124.135 Y127.928 E-.11145
G1 X124.192 Y128.211 E-.10982
G1 X124.21 Y128.493 E-.10732
G1 X124.21 Y129.181 E-.26148
; WIPE_END
G1 E-.04 F1800
G1 X129.629 Y123.806 Z2 F30000
G1 X137.541 Y115.959 Z2
G1 Z1.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X137.541 Y127.547 E.37263
G1 X137.336 Y127.581 E.00666
G1 X137.19 Y127.148 E.01469
G1 X136.921 Y126.653 E.01811
G1 X136.747 Y126.392 E.01009
G1 X136.448 Y126.052 E.01456
G1 X136.108 Y125.753 E.01456
G1 X135.731 Y125.502 E.01456
G1 X135.325 Y125.301 E.01457
G1 X134.896 Y125.156 E.01456
G1 X134.452 Y125.067 E.01457
G1 X134 Y125.038 E.01456
G1 X133.687 Y125.058 E.01009
G1 X133.131 Y125.146 E.0181
G1 X132.675 Y125.301 E.01549
G1 X132.269 Y125.502 E.01456
G1 X131.892 Y125.753 E.01457
G1 X131.552 Y126.052 E.01456
G1 X131.253 Y126.392 E.01456
G1 X131.002 Y126.769 E.01456
G1 X130.801 Y127.175 E.01457
G1 X130.656 Y127.604 E.01456
G1 X130.567 Y128.048 E.01456
G1 X130.541 Y128.452 E.01303
G1 X130.541 Y137.548 E.29247
G1 X130.567 Y137.952 E.01304
G1 X130.656 Y138.396 E.01455
G1 X130.801 Y138.825 E.01456
G1 X130.908 Y139.041 E.00774
G1 X125.092 Y139.041 E.18701
G1 X125.199 Y138.825 E.00774
G1 X125.344 Y138.396 E.01457
G1 X125.433 Y137.952 E.01455
G1 X125.459 Y137.548 E.01303
G1 X125.459 Y128.452 E.29247
G1 X125.433 Y128.048 E.01303
G1 X125.344 Y127.604 E.01456
G1 X125.19 Y127.148 E.01548
G1 X124.921 Y126.653 E.01811
G1 X124.747 Y126.392 E.01009
G1 X124.448 Y126.052 E.01456
G1 X124.108 Y125.753 E.01456
G1 X123.731 Y125.502 E.01456
G1 X123.325 Y125.301 E.01457
G1 X122.896 Y125.156 E.01456
G1 X122.452 Y125.067 E.01457
G1 X122 Y125.038 E.01456
G1 X121.687 Y125.058 E.01009
G1 X121.131 Y125.146 E.0181
G1 X120.675 Y125.301 E.01549
G1 X120.269 Y125.502 E.01456
G1 X119.892 Y125.753 E.01456
G1 X119.552 Y126.052 E.01456
G1 X119.253 Y126.392 E.01456
G1 X119.002 Y126.769 E.01456
G1 X118.801 Y127.175 E.01457
G1 X118.664 Y127.581 E.01377
G1 X118.459 Y127.547 E.00666
G1 X118.459 Y115.959 E.37262
G1 X137.501 Y115.959 E.61231
; WIPE_START
G1 X137.508 Y117.959 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.444 Y125.591 Z2 F30000
G1 X137.336 Y138.419 Z2
G1 Z1.6
G1 E.8 F1800
G1 F3600
G1 X137.541 Y138.453 E.00666
G1 X137.541 Y139.041 E.0189
G1 X137.092 Y139.041 E.01443
G1 X137.199 Y138.825 E.00774
G1 X137.324 Y138.457 E.01249
; WIPE_START
G1 X137.541 Y138.453 E-.08772
G1 X137.541 Y139.041 E-.23727
G1 X137.092 Y139.041 E-.18107
G1 X137.199 Y138.825 E-.09718
G1 X137.324 Y138.457 E-.15676
; WIPE_END
G1 E-.04 F1800
G1 X129.691 Y138.442 Z2 F30000
G1 X118.664 Y138.419 Z2
G1 Z1.6
G1 E.8 F1800
G1 F3600
G1 X118.801 Y138.825 E.01378
G1 X118.908 Y139.041 E.00774
G1 X118.459 Y139.041 E.01443
G1 X118.459 Y138.453 E.0189
G1 X118.624 Y138.426 E.00538
; WIPE_START
G1 X118.801 Y138.825 E-.17643
G1 X118.908 Y139.041 E-.09727
G1 X118.459 Y139.041 E-.18125
G1 X118.459 Y138.453 E-.2375
G1 X118.624 Y138.426 E-.06756
; WIPE_END
G1 E-.04 F1800
G1 X123.55 Y132.595 Z2 F30000
G1 X137.948 Y115.552 Z2
G1 Z1.6
G1 E.8 F1800
G1 F3600
G1 X137.948 Y139.448 E.7684
G1 X136.364 Y139.448 E.05094
G1 X136.645 Y139.027 E.01627
G1 X136.822 Y138.669 E.01285
G1 X136.95 Y138.29 E.01285
G1 X137.028 Y137.899 E.01284
G1 X137.052 Y137.534 E.01175
G1 X137.052 Y128.466 E.29161
G1 X137.028 Y128.101 E.01175
G1 X136.95 Y127.71 E.01284
G1 X136.815 Y127.312 E.01351
G1 X136.572 Y126.864 E.01639
G1 X136.423 Y126.641 E.00863
G1 X136.16 Y126.34 E.01285
G1 X135.859 Y126.077 E.01284
G1 X135.527 Y125.855 E.01285
G1 X135.169 Y125.678 E.01285
G1 X134.791 Y125.55 E.01285
G1 X134.399 Y125.472 E.01285
G1 X134 Y125.446 E.01284
G1 X133.732 Y125.463 E.00863
G1 X133.229 Y125.543 E.01639
G1 X132.831 Y125.678 E.01351
G1 X132.473 Y125.855 E.01285
G1 X132.141 Y126.077 E.01285
G1 X131.84 Y126.34 E.01285
G1 X131.577 Y126.641 E.01285
G1 X131.355 Y126.973 E.01284
G1 X131.178 Y127.331 E.01285
G1 X131.05 Y127.71 E.01285
G1 X130.972 Y128.101 E.01284
G1 X130.948 Y128.466 E.01175
G1 X130.948 Y137.534 E.29161
G1 X130.972 Y137.899 E.01175
G1 X131.05 Y138.29 E.01284
G1 X131.178 Y138.669 E.01285
G1 X131.355 Y139.027 E.01285
G1 X131.636 Y139.448 E.01628
G1 X124.364 Y139.448 E.23384
G1 X124.645 Y139.027 E.01627
G1 X124.822 Y138.669 E.01285
G1 X124.95 Y138.29 E.01285
G1 X125.028 Y137.899 E.01284
G1 X125.052 Y137.534 E.01175
G1 X125.052 Y128.466 E.29161
G1 X125.028 Y128.101 E.01175
G1 X124.95 Y127.71 E.01284
G1 X124.815 Y127.312 E.01351
G1 X124.572 Y126.864 E.01639
G1 X124.423 Y126.641 E.00863
G1 X124.16 Y126.34 E.01285
G1 X123.859 Y126.077 E.01284
G1 X123.527 Y125.855 E.01285
G1 X123.169 Y125.678 E.01285
G1 X122.791 Y125.55 E.01285
G1 X122.399 Y125.472 E.01285
G1 X122 Y125.446 E.01284
G1 X121.732 Y125.463 E.00863
G1 X121.229 Y125.543 E.01639
G1 X120.831 Y125.678 E.01351
G1 X120.473 Y125.855 E.01285
G1 X120.141 Y126.077 E.01285
G1 X119.84 Y126.34 E.01285
G1 X119.577 Y126.641 E.01285
G1 X119.355 Y126.973 E.01284
G1 X119.178 Y127.331 E.01285
G1 X119.05 Y127.71 E.01285
G1 X118.972 Y128.101 E.01284
G1 X118.948 Y128.466 E.01175
G1 X118.948 Y137.534 E.29161
G1 X118.972 Y137.899 E.01175
G1 X119.05 Y138.29 E.01284
G1 X119.178 Y138.669 E.01285
G1 X119.355 Y139.027 E.01285
G1 X119.636 Y139.448 E.01628
G1 X118.052 Y139.448 E.05094
G1 X118.052 Y115.552 E.7684
G1 X137.908 Y115.552 E.63849
G1 X138.355 Y115.145 F30000
G1 F3600
G1 X138.355 Y139.855 E.79458
G1 X135.541 Y139.855 E.0905
G1 X135.488 Y139.682 E.00582
G1 X135.611 Y139.6 E.00475
G1 X135.871 Y139.371 E.01113
G1 X136.1 Y139.111 E.01113
G1 X136.292 Y138.823 E.01113
G1 X136.445 Y138.513 E.01113
G1 X136.556 Y138.185 E.01113
G1 X136.624 Y137.846 E.01113
G1 X136.645 Y137.521 E.01046
G1 X136.645 Y128.479 E.29076
G1 X136.624 Y128.154 E.01046
G1 X136.556 Y127.815 E.01113
G1 X136.441 Y127.475 E.01154
G1 X136.223 Y127.074 E.01467
G1 X136.099 Y126.889 E.00717
G1 X135.871 Y126.629 E.01113
G1 X135.611 Y126.401 E.01113
G1 X135.323 Y126.208 E.01113
G1 X135.013 Y126.055 E.01113
G1 X134.685 Y125.944 E.01113
G1 X134.345 Y125.876 E.01113
G1 X134 Y125.854 E.01113
G1 X133.778 Y125.868 E.00717
G1 X133.327 Y125.94 E.01467
G1 X132.987 Y126.055 E.01154
G1 X132.677 Y126.208 E.01113
G1 X132.389 Y126.401 E.01113
G1 X132.129 Y126.629 E.01113
G1 X131.9 Y126.889 E.01113
G1 X131.708 Y127.177 E.01113
G1 X131.555 Y127.487 E.01114
G1 X131.444 Y127.815 E.01113
G1 X131.376 Y128.154 E.01113
G1 X131.355 Y128.479 E.01046
G1 X131.355 Y137.521 E.29076
G1 X131.376 Y137.846 E.01046
G1 X131.444 Y138.185 E.01113
G1 X131.555 Y138.513 E.01113
G1 X131.708 Y138.823 E.01113
G1 X131.9 Y139.111 E.01113
G1 X132.129 Y139.371 E.01113
G1 X132.389 Y139.599 E.01113
G1 X132.512 Y139.682 E.00476
G1 X132.459 Y139.855 E.00582
G1 X123.541 Y139.855 E.2868
G1 X123.488 Y139.682 E.00582
G1 X123.611 Y139.6 E.00475
G1 X123.871 Y139.371 E.01113
G1 X124.1 Y139.111 E.01113
G1 X124.292 Y138.823 E.01113
G1 X124.445 Y138.513 E.01113
G1 X124.556 Y138.185 E.01113
G1 X124.624 Y137.846 E.01113
G1 X124.645 Y137.521 E.01046
G1 X124.645 Y128.479 E.29076
G1 X124.624 Y128.154 E.01046
G1 X124.556 Y127.815 E.01113
G1 X124.441 Y127.475 E.01154
G1 X124.223 Y127.074 E.01467
G1 X124.099 Y126.889 E.00717
G1 X123.871 Y126.629 E.01113
G1 X123.611 Y126.401 E.01113
G1 X123.323 Y126.208 E.01113
G1 X123.013 Y126.055 E.01113
G1 X122.685 Y125.944 E.01113
G1 X122.345 Y125.876 E.01113
G1 X122 Y125.854 E.01113
G1 X121.778 Y125.868 E.00717
G1 X121.327 Y125.94 E.01467
G1 X120.987 Y126.055 E.01154
G1 X120.677 Y126.208 E.01113
G1 X120.389 Y126.401 E.01113
G1 X120.129 Y126.629 E.01113
G1 X119.9 Y126.889 E.01113
G1 X119.708 Y127.177 E.01113
G1 X119.555 Y127.487 E.01114
G1 X119.444 Y127.815 E.01113
G1 X119.376 Y128.154 E.01113
G1 X119.355 Y128.479 E.01046
G1 X119.355 Y137.521 E.29076
G1 X119.376 Y137.846 E.01046
G1 X119.444 Y138.185 E.01113
G1 X119.555 Y138.513 E.01113
G1 X119.708 Y138.823 E.01113
G1 X119.9 Y139.111 E.01113
G1 X120.129 Y139.371 E.01113
G1 X120.389 Y139.599 E.01113
G1 X120.512 Y139.682 E.00476
G1 X120.459 Y139.855 E.00582
G1 X117.645 Y139.855 E.0905
G1 X117.645 Y115.145 E.79458
G1 X138.315 Y115.145 E.66467
M204 S250
G1 X138.79 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
; WIPE_START
M204 S10000
G1 X138.753 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X132.054 Y116.684 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X133.682 Y116.684 E.05236
G1 X133.679 Y116.828 E.00462
G1 X133.394 Y117.265 E.01678
G1 X132.976 Y117.701 E.01944
G1 X132.795 Y118.138 E.01521
G1 X132.804 Y118.575 E.01405
G1 X133.089 Y119.012 E.01678
G1 X133.507 Y119.449 E.01944
G1 X133.688 Y119.885 E.01521
G1 X133.679 Y120.322 E.01405
G1 X133.394 Y120.759 E.01678
G1 X132.976 Y121.196 E.01944
G1 X132.795 Y121.632 E.01521
G1 X132.804 Y122.069 E.01405
G1 X133.089 Y122.506 E.01678
G1 X133.507 Y122.943 E.01944
G1 X133.688 Y123.38 E.01521
G1 X133.679 Y123.816 E.01405
G1 X133.394 Y124.253 E.01678
G1 X133.262 Y124.392 E.00616
G1 X133.606 Y124.337 E.01123
G1 X134 Y124.311 E.01269
G1 X134.546 Y124.347 E.01761
G1 X134.749 Y124.387 E.00663
G1 X134.836 Y124.253 E.00514
G1 X135.254 Y123.816 E.01944
G1 X135.435 Y123.38 E.01521
G1 X135.426 Y122.943 E.01405
G1 X135.141 Y122.506 E.01678
G1 X134.723 Y122.069 E.01944
G1 X134.542 Y121.632 E.01521
G1 X134.551 Y121.196 E.01405
G1 X134.836 Y120.759 E.01678
G1 X135.254 Y120.322 E.01944
G1 X135.435 Y119.885 E.01521
G1 X135.426 Y119.449 E.01405
G1 X135.141 Y119.012 E.01678
G1 X134.723 Y118.575 E.01944
G1 X134.542 Y118.138 E.01521
G1 X134.551 Y117.701 E.01405
G1 X134.836 Y117.265 E.01678
G1 X135.254 Y116.828 E.01944
G1 X135.314 Y116.684 E.005
G1 X136.816 Y116.684 E.0483
G1 X136.816 Y117.34 E.0211
G1 X136.47 Y117.701 E.01607
G1 X136.289 Y118.138 E.01521
G1 X136.298 Y118.575 E.01405
G1 X136.583 Y119.012 E.01678
G1 X136.816 Y119.267 E.01109
G1 X136.816 Y120.835 E.05042
G1 X136.47 Y121.196 E.01607
G1 X136.289 Y121.632 E.01521
G1 X136.298 Y122.069 E.01405
G1 X136.583 Y122.506 E.01678
G1 X136.816 Y122.761 E.01109
G1 X136.816 Y124.329 E.05042
G1 X136.47 Y124.69 E.01607
G1 X136.329 Y125.029 E.01182
G1 X136.2 Y124.942 E.00502
G1 X135.603 Y124.63 E.02166
G1 X135.084 Y124.454 E.01762
G1 X134.948 Y124.427 E.00446
G1 X132.549 Y124.578 F30000
G1 F4200
G1 X132.397 Y124.63 E.00516
G1 X131.905 Y124.872 E.01762
G1 X131.45 Y125.177 E.01763
G1 X131.17 Y125.422 E.01195
G1 X131.048 Y125.127 E.01028
G1 X131.057 Y124.69 E.01405
G1 X131.342 Y124.253 E.01678
G1 X131.76 Y123.816 E.01944
G1 X131.941 Y123.38 E.01521
G1 X131.932 Y122.943 E.01405
G1 X131.647 Y122.506 E.01678
G1 X131.229 Y122.069 E.01944
G1 X131.048 Y121.632 E.01521
G1 X131.057 Y121.196 E.01405
G1 X131.342 Y120.759 E.01678
G1 X131.76 Y120.322 E.01944
G1 X131.941 Y119.885 E.01521
G1 X131.932 Y119.449 E.01405
G1 X131.647 Y119.012 E.01678
G1 X131.229 Y118.575 E.01944
G1 X131.048 Y118.138 E.01521
G1 X131.057 Y117.701 E.01405
G1 X131.342 Y117.265 E.01678
G1 X131.76 Y116.828 E.01944
G1 X131.819 Y116.684 E.005
G1 X130.188 Y116.684 E.05246
G1 X130.185 Y116.828 E.00462
G1 X129.9 Y117.265 E.01678
G1 X129.482 Y117.701 E.01944
G1 X129.301 Y118.138 E.01521
G1 X129.309 Y118.575 E.01405
G1 X129.595 Y119.012 E.01678
G1 X130.013 Y119.449 E.01944
G1 X130.194 Y119.885 E.01521
G1 X130.185 Y120.322 E.01405
G1 X129.9 Y120.759 E.01678
G1 X129.482 Y121.196 E.01944
G1 X129.301 Y121.632 E.01521
G1 X129.309 Y122.069 E.01405
G1 X129.595 Y122.506 E.01678
G1 X130.013 Y122.943 E.01944
G1 X130.194 Y123.38 E.01521
G1 X130.185 Y123.816 E.01405
G1 X129.9 Y124.253 E.01678
G1 X129.482 Y124.69 E.01944
G1 X129.301 Y125.127 E.01521
G1 X129.309 Y125.563 E.01405
G1 X129.595 Y126 E.01678
G1 X130.013 Y126.437 E.01944
G1 X130.17 Y126.816 E.01319
G1 X129.954 Y127.416 E.02051
G1 X129.885 Y127.763 E.01138
G1 X129.482 Y128.184 E.01873
G1 X129.301 Y128.621 E.01521
G1 X129.309 Y129.058 E.01405
G1 X129.595 Y129.494 E.01678
G1 X129.816 Y129.725 E.01028
G1 X129.816 Y131.329 E.05158
G1 X129.482 Y131.678 E.01553
G1 X129.301 Y132.115 E.01521
G1 X129.309 Y132.552 E.01405
G1 X129.595 Y132.989 E.01678
G1 X129.816 Y133.22 E.01028
G1 X129.816 Y134.824 E.05158
G1 X129.482 Y135.172 E.01553
G1 X129.301 Y135.609 E.01521
G1 X129.309 Y136.046 E.01405
G1 X129.595 Y136.483 E.01678
G1 X129.816 Y136.714 E.01028
G1 X129.816 Y137.571 E.02758
G1 X129.847 Y138.047 E.01533
G1 X129.9 Y138.316 E.00881
G1 X129.88 Y138.316 E.00065
; WIPE_START
G1 X129.9 Y138.316 E-.00763
G1 X129.847 Y138.047 E-.10413
G1 X129.816 Y137.571 E-.18113
G1 X129.816 Y136.714 E-.32588
G1 X129.595 Y136.483 E-.12147
G1 X129.566 Y136.439 E-.01977
; WIPE_END
G1 E-.04 F1800
G1 X131.962 Y139.527 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.108326
G1 F15000
G1 X132.071 Y139.651 E.00086
G1 X132.692 Y139.839 F30000
; LINE_WIDTH: 0.379929
G1 F7121.488
G1 X133.122 Y139.921 E.01167
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X133.228 Y139.939 E.00242
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X133.334 Y139.956 E.00212
; LINE_WIDTH: 0.257802
G1 F11168.964
G1 X133.508 Y139.974 E.00297
; LINE_WIDTH: 0.224995
G1 F13181.427
G1 X133.667 Y139.989 E.0023
; LINE_WIDTH: 0.197595
G1 F15000
G1 X134.322 Y139.99 E.00801
; LINE_WIDTH: 0.22395
G1 F13257.53
G1 X134.492 Y139.974 E.00244
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X134.651 Y139.958 E.00269
; LINE_WIDTH: 0.290957
G1 F9676.007
G1 X134.772 Y139.939 E.0024
; LINE_WIDTH: 0.328365
G1 F8407.945
G1 X134.878 Y139.921 E.00242
; LINE_WIDTH: 0.363348
G1 F7489.979
G1 X134.984 Y139.904 E.00272
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X135.308 Y139.839 E.00895
G1 X135.929 Y139.651 F30000
; LINE_WIDTH: 0.108331
G1 F15000
G1 X136.038 Y139.527 E.00086
; WIPE_START
G1 X135.929 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.179 Y138.187 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.534813
G1 F4879.117
G1 X137.485 Y137.975 E.01446
G1 X137.487 Y137.942 E.00126
G1 X137.5 Y137.541 E.0156
G1 X137.5 Y128.459 E.35289
G1 X137.485 Y128.025 E.01685
G1 X137.179 Y127.813 E.01448
G1 X137.337 Y126.856 F30000
; LINE_WIDTH: 0.138579
G1 F15000
G1 X137.231 Y126.704 E.00141
; LINE_WIDTH: 0.110811
G1 X137.124 Y126.551 E.001
G1 X129.953 Y116.684 F30000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F4200
G1 X128.325 Y116.684 E.05236
G1 X128.266 Y116.828 E.005
G1 X127.848 Y117.265 E.01944
G1 X127.562 Y117.701 E.01678
G1 X127.554 Y118.138 E.01405
G1 X127.735 Y118.575 E.01521
G1 X128.153 Y119.012 E.01944
G1 X128.438 Y119.449 E.01678
G1 X128.447 Y119.885 E.01405
G1 X128.266 Y120.322 E.01521
G1 X127.848 Y120.759 E.01944
G1 X127.562 Y121.196 E.01678
G1 X127.554 Y121.632 E.01405
G1 X127.735 Y122.069 E.01521
G1 X128.153 Y122.506 E.01944
G1 X128.438 Y122.943 E.01678
G1 X128.447 Y123.38 E.01405
G1 X128.266 Y123.816 E.01521
G1 X127.848 Y124.253 E.01944
G1 X127.562 Y124.69 E.01678
G1 X127.554 Y125.127 E.01405
G1 X127.735 Y125.563 E.01521
G1 X128.153 Y126 E.01944
G1 X128.438 Y126.437 E.01678
G1 X128.447 Y126.874 E.01405
G1 X128.266 Y127.311 E.01521
G1 X127.848 Y127.747 E.01944
G1 X127.562 Y128.184 E.01678
G1 X127.554 Y128.621 E.01405
G1 X127.735 Y129.058 E.01521
G1 X128.153 Y129.494 E.01944
G1 X128.438 Y129.931 E.01678
G1 X128.447 Y130.368 E.01405
G1 X128.266 Y130.805 E.01521
G1 X127.848 Y131.241 E.01944
G1 X127.562 Y131.678 E.01678
G1 X127.554 Y132.115 E.01405
G1 X127.735 Y132.552 E.01521
G1 X128.153 Y132.989 E.01944
G1 X128.438 Y133.425 E.01678
G1 X128.447 Y133.862 E.01405
G1 X128.266 Y134.299 E.01521
G1 X127.848 Y134.736 E.01944
G1 X127.562 Y135.172 E.01678
G1 X127.554 Y135.609 E.01405
G1 X127.735 Y136.046 E.01521
G1 X128.153 Y136.483 E.01944
G1 X128.438 Y136.92 E.01678
G1 X128.447 Y137.356 E.01405
G1 X128.266 Y137.793 E.01521
G1 X127.848 Y138.23 E.01944
G1 X127.792 Y138.316 E.0033
G1 X126.323 Y138.316 E.04721
G1 X126.406 Y138.23 E.00382
G1 X126.691 Y137.793 E.01678
G1 X126.7 Y137.356 E.01405
G1 X126.518 Y136.92 E.01521
G1 X126.184 Y136.57 E.01554
G1 X126.184 Y134.967 E.05155
G1 X126.406 Y134.736 E.0103
G1 X126.691 Y134.299 E.01678
G1 X126.7 Y133.862 E.01405
G1 X126.518 Y133.425 E.01521
G1 X126.184 Y133.076 E.01554
G1 X126.184 Y131.473 E.05155
G1 X126.406 Y131.241 E.0103
G1 X126.691 Y130.805 E.01678
G1 X126.7 Y130.368 E.01405
G1 X126.518 Y129.931 E.01521
G1 X126.184 Y129.582 E.01554
G1 X126.184 Y128.429 E.03708
G1 X126.157 Y128.007 E.01357
G1 X126.406 Y127.747 E.01158
G1 X126.691 Y127.311 E.01678
G1 X126.7 Y126.874 E.01405
G1 X126.518 Y126.437 E.01521
G1 X126.101 Y126 E.01944
G1 X125.815 Y125.563 E.01678
G1 X125.806 Y125.127 E.01405
G1 X125.988 Y124.69 E.01521
G1 X126.406 Y124.253 E.01944
G1 X126.691 Y123.816 E.01678
G1 X126.7 Y123.38 E.01405
G1 X126.518 Y122.943 E.01521
G1 X126.101 Y122.506 E.01944
G1 X125.815 Y122.069 E.01678
G1 X125.806 Y121.632 E.01405
G1 X125.988 Y121.196 E.01521
G1 X126.406 Y120.759 E.01944
G1 X126.691 Y120.322 E.01678
G1 X126.7 Y119.885 E.01405
G1 X126.518 Y119.449 E.01521
G1 X126.101 Y119.012 E.01944
G1 X125.815 Y118.575 E.01678
G1 X125.806 Y118.138 E.01405
G1 X125.988 Y117.701 E.01521
G1 X126.406 Y117.265 E.01944
G1 X126.691 Y116.828 E.01678
G1 X126.694 Y116.684 E.00462
G1 X124.831 Y116.684 E.0599
G1 X124.771 Y116.828 E.005
G1 X124.353 Y117.265 E.01944
G1 X124.068 Y117.701 E.01678
G1 X124.059 Y118.138 E.01405
G1 X124.241 Y118.575 E.01521
G1 X124.659 Y119.012 E.01944
G1 X124.944 Y119.449 E.01678
G1 X124.953 Y119.885 E.01405
G1 X124.771 Y120.322 E.01521
G1 X124.353 Y120.759 E.01944
G1 X124.068 Y121.196 E.01678
G1 X124.059 Y121.632 E.01405
G1 X124.241 Y122.069 E.01521
G1 X124.659 Y122.506 E.01944
G1 X124.944 Y122.943 E.01678
G1 X124.953 Y123.38 E.01405
G1 X124.771 Y123.816 E.01521
G1 X124.353 Y124.253 E.01944
G1 X124.068 Y124.69 E.01678
G1 X124.064 Y124.87 E.0058
G1 X123.603 Y124.63 E.01673
G1 X123.084 Y124.454 E.01762
G1 X122.778 Y124.393 E.01004
G1 X122.911 Y124.253 E.00622
G1 X123.197 Y123.816 E.01678
G1 X123.205 Y123.38 E.01405
G1 X123.024 Y122.943 E.01521
G1 X122.606 Y122.506 E.01944
G1 X122.321 Y122.069 E.01678
G1 X122.312 Y121.632 E.01405
G1 X122.494 Y121.196 E.01521
G1 X122.911 Y120.759 E.01944
G1 X123.197 Y120.322 E.01678
G1 X123.205 Y119.885 E.01405
G1 X123.024 Y119.449 E.01521
G1 X122.606 Y119.012 E.01944
G1 X122.321 Y118.575 E.01678
G1 X122.312 Y118.138 E.01405
G1 X122.494 Y117.701 E.01521
G1 X122.911 Y117.265 E.01944
G1 X123.197 Y116.828 E.01678
G1 X123.2 Y116.684 E.00462
G1 X121.571 Y116.684 E.05236
G1 X119.184 Y122.868 F30000
G1 F4200
G1 X119.184 Y124.497 E.05236
G1 X119.417 Y124.253 E.01084
G1 X119.703 Y123.816 E.01678
G1 X119.711 Y123.38 E.01405
G1 X119.53 Y122.943 E.01521
G1 X119.184 Y122.581 E.01608
G1 X119.184 Y121.002 E.05078
G1 X119.417 Y120.759 E.01084
G1 X119.703 Y120.322 E.01678
G1 X119.711 Y119.885 E.01405
G1 X119.53 Y119.449 E.01521
G1 X119.184 Y119.087 E.01608
G1 X119.184 Y117.508 E.05078
G1 X119.417 Y117.265 E.01084
G1 X119.703 Y116.828 E.01678
G1 X119.705 Y116.684 E.00462
G1 X121.337 Y116.684 E.05246
G1 X121.277 Y116.828 E.005
G1 X120.859 Y117.265 E.01944
G1 X120.574 Y117.701 E.01678
G1 X120.565 Y118.138 E.01405
G1 X120.746 Y118.575 E.01521
G1 X121.164 Y119.012 E.01944
G1 X121.45 Y119.449 E.01678
G1 X121.458 Y119.885 E.01405
G1 X121.277 Y120.322 E.01521
G1 X120.859 Y120.759 E.01944
G1 X120.574 Y121.196 E.01678
G1 X120.565 Y121.632 E.01405
G1 X120.746 Y122.069 E.01521
G1 X121.164 Y122.506 E.01944
G1 X121.45 Y122.943 E.01678
G1 X121.458 Y123.38 E.01405
G1 X121.277 Y123.816 E.01521
G1 X120.859 Y124.253 E.01944
G1 X120.675 Y124.536 E.01085
G1 X120.397 Y124.63 E.00944
G1 X119.905 Y124.872 E.01762
G1 X119.45 Y125.177 E.01762
G1 X119.27 Y125.334 E.00768
G1 X118.856 Y126.575 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.124436
G1 F15000
G1 X118.663 Y126.854 E.00219
G1 X118.821 Y127.813 F30000
; LINE_WIDTH: 0.534815
G1 F4879.09
G1 X118.515 Y128.025 E.01447
G1 X118.5 Y128.459 E.01686
G1 X118.5 Y137.541 E.35289
G1 X118.513 Y137.942 E.0156
G1 X118.515 Y137.975 E.00126
G1 X118.82 Y138.187 E.01444
; WIPE_START
G1 X118.515 Y137.975 E-.14118
G1 X118.513 Y137.942 E-.0123
G1 X118.5 Y137.541 E-.15255
G1 X118.5 Y136.346 E-.45397
; WIPE_END
G1 E-.04 F1800
G1 X119.962 Y139.527 Z2 F30000
G1 Z1.6
G1 E.8 F1800
; LINE_WIDTH: 0.108326
G1 F15000
G1 X120.071 Y139.651 E.00086
G1 X120.692 Y139.839 F30000
; LINE_WIDTH: 0.379928
G1 F7121.498
G1 X121.122 Y139.921 E.01167
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X121.228 Y139.939 E.00242
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X121.334 Y139.956 E.00212
; LINE_WIDTH: 0.257802
G1 F11168.964
G1 X121.508 Y139.974 E.00297
; LINE_WIDTH: 0.224995
G1 F13181.427
G1 X121.667 Y139.989 E.0023
; LINE_WIDTH: 0.197595
G1 F15000
G1 X122.322 Y139.99 E.00801
; LINE_WIDTH: 0.22395
G1 F13257.525
G1 X122.492 Y139.974 E.00244
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X122.651 Y139.958 E.00269
; LINE_WIDTH: 0.290957
G1 F9675.999
G1 X122.772 Y139.939 E.0024
; LINE_WIDTH: 0.328365
G1 F8407.945
G1 X122.878 Y139.921 E.00242
; LINE_WIDTH: 0.363348
G1 F7489.979
G1 X122.984 Y139.904 E.00272
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X123.308 Y139.839 E.00895
G1 X123.929 Y139.651 F30000
; LINE_WIDTH: 0.108331
G1 F15000
G1 X124.038 Y139.527 E.00086
; WIPE_START
G1 X123.929 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.207 Y132.053 Z2 F30000
G1 X122.509 Y124.709 Z2
G1 Z1.6
G1 E.8 F1800
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.38292
G1 F1500;_EXTRUDE_SET_SPEED
G1 X122.01 Y124.675 E.01343
G1 X121.648 Y124.707 E.00977
G1 X121.031 Y124.798 E.01675
G1 X120.546 Y124.962 E.01376
G1 X120.096 Y125.182 E.01344
G1 X119.68 Y125.459 E.01344
G1 X119.303 Y125.788 E.01344
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.399647
;_EXTRUDE_SET_SPEED
G1 X119.231 Y125.871 E.00308
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.4331
;_EXTRUDE_SET_SPEED
G1 X119.16 Y125.954 E.00337
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.466554
;_EXTRUDE_SET_SPEED
G1 X119.089 Y126.037 E.00366
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.409399
;_EXTRUDE_SET_SPEED
G1 X118.906 Y126.119 E.0058
G1 X118.822 Y125.912 E.00648
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.400884
;_EXTRUDE_SET_SPEED
G1 X118.822 Y116.481 E.26667
G1 X118.849 Y116.349 E.00381
G1 X118.981 Y116.322 E.00381
G1 X137.019 Y116.322 E.51006
G1 X137.151 Y116.349 E.00381
G1 X137.178 Y116.481 E.00381
G1 X137.178 Y125.912 E.26667
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.400755
;_EXTRUDE_SET_SPEED
G1 X137.161 Y125.985 E.00213
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.417764
;_EXTRUDE_SET_SPEED
G1 X137.144 Y126.058 E.00223
G1 X137.031 Y126.117 E.00378
G1 X136.912 Y126.037 E.00425
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.38292
;_EXTRUDE_SET_SPEED
G1 X136.712 Y125.803 E.00827
G1 X136.337 Y125.472 E.01343
G1 X136.014 Y125.254 E.01047
G1 X135.473 Y124.97 E.01639
G1 X135 Y124.808 E.01343
G1 X134.509 Y124.709 E.01344
G1 X134.01 Y124.675 E.01343
G1 X133.648 Y124.707 E.00977
G1 X133.031 Y124.798 E.01675
G1 X132.546 Y124.962 E.01376
G1 X132.096 Y125.182 E.01344
G1 X131.68 Y125.459 E.01344
G1 X131.303 Y125.788 E.01344
G1 X130.972 Y126.163 E.01344
G1 X130.693 Y126.578 E.01343
G1 X130.47 Y127.027 E.01344
G1 X130.308 Y127.5 E.01344
G1 X130.209 Y127.99 E.01343
G1 X130.178 Y128.44 E.01212
G1 X130.178 Y137.554 E.24478
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.398185
;_EXTRUDE_SET_SPEED
G1 X130.194 Y137.782 E.00641
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.398021
;_EXTRUDE_SET_SPEED
G1 X130.209 Y138.01 E.0064
G1 X130.311 Y138.637 E.01782
G1 X130.148 Y138.678 E.0047
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.398195
;_EXTRUDE_SET_SPEED
G1 X128 Y138.678 E.06029
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.424762
;_EXTRUDE_SET_SPEED
G1 X125.852 Y138.678 E.0648
G1 X125.689 Y138.637 E.00506
G1 X125.693 Y138.5 E.00412
; Slow Down End
; Slow Down Start
; LINE_WIDTH: 0.38292
;_EXTRUDE_SET_SPEED
G1 X125.791 Y138.01 E.01343
G1 X125.822 Y137.56 E.01212
G1 X125.822 Y128.446 E.24477
G1 X125.791 Y127.99 E.01226
G1 X125.692 Y127.5 E.01343
G1 X125.459 Y126.884 E.01768
G1 X125.04 Y126.18 E.022
G1 X124.712 Y125.803 E.01344
G1 X124.337 Y125.472 E.01343
G1 X124.013 Y125.254 E.01048
G1 X123.473 Y124.97 E.01639
G1 X123 Y124.808 E.01343
G1 X122.568 Y124.721 E.01183
; Slow Down End
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F1500
G1 X123 Y124.808 E-.16742
G1 X123.473 Y124.97 E-.19007
G1 X124.013 Y125.254 E-.23188
G1 X124.337 Y125.472 E-.14823
G1 X124.381 Y125.511 E-.02241
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 14/152
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
M106 S51
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
G1 X133.154 Y126.458
G1 Z1.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X133.431 Y126.364 E.00872
G1 X133.805 Y126.302 E.01129
G1 X134 Y126.29 E.00581
G1 X134.289 Y126.308 E.00861
G1 X134.572 Y126.365 E.00861
G1 X134.849 Y126.459 E.00872
G1 X135.183 Y126.638 E.01129
G1 X135.346 Y126.746 E.00581
G1 X135.563 Y126.937 E.00861
G1 X135.754 Y127.154 E.00861
G1 X135.862 Y127.317 E.00581
G1 X136.041 Y127.651 E.01129
G1 X136.135 Y127.928 E.00872
G1 X136.192 Y128.211 E.00861
G1 X136.21 Y128.493 E.00841
G1 X136.21 Y137.507 E.26848
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
M73 P46 R15
G1 X136.042 Y138.346 E.00861
G1 X135.914 Y138.605 E.00861
G1 X135.754 Y138.846 E.00861
G1 X135.62 Y138.998 E.00602
G1 X135.348 Y139.252 E.01109
G1 X135.105 Y139.414 E.00871
G1 X134.846 Y139.542 E.00861
G1 X134.572 Y139.635 E.00861
G1 X134.289 Y139.692 E.00861
G1 X134 Y139.71 E.00861
G1 X133.711 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
G1 X132.895 Y139.414 E.00861
G1 X132.654 Y139.254 E.00861
G1 X132.437 Y139.063 E.00861
G1 X132.246 Y138.846 E.00861
G1 X132.086 Y138.605 E.00861
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.865 Y127.928 E.00861
G1 X131.958 Y127.654 E.00861
G1 X132.086 Y127.395 E.00861
G1 X132.246 Y127.154 E.00861
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.895 Y126.586 E.00861
G1 X133.118 Y126.475 E.00742
; WIPE_START
M204 S10000
G1 X133.431 Y126.364 E-.12632
G1 X133.805 Y126.302 E-.14406
G1 X134 Y126.29 E-.07411
G1 X134.289 Y126.308 E-.10988
G1 X134.572 Y126.365 E-.10987
G1 X134.849 Y126.459 E-.11122
G1 X135.045 Y126.564 E-.08454
; WIPE_END
G1 E-.04 F1800
G1 X127.428 Y127.038 Z2.2 F30000
G1 X123.826 Y127.262 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X123.862 Y127.317 E.00194
G1 X124.041 Y127.651 E.01129
G1 X124.135 Y127.928 E.00872
G1 X124.192 Y128.211 E.00861
G1 X124.21 Y128.493 E.00841
G1 X124.21 Y137.507 E.26848
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.914 Y138.605 E.00861
G1 X123.754 Y138.846 E.00861
G1 X123.62 Y138.998 E.00602
G1 X123.348 Y139.252 E.01109
G1 X123.105 Y139.414 E.00871
G1 X122.846 Y139.542 E.00861
G1 X122.572 Y139.635 E.00861
G1 X122.289 Y139.692 E.00861
G1 X122 Y139.71 E.00861
G1 X121.711 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
G1 X120.895 Y139.414 E.00861
G1 X120.654 Y139.254 E.00861
G1 X120.437 Y139.063 E.00861
G1 X120.246 Y138.846 E.00861
G1 X120.086 Y138.605 E.00861
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.865 Y127.928 E.00861
G1 X119.958 Y127.654 E.00862
G1 X120.086 Y127.395 E.00861
G1 X120.246 Y127.154 E.00861
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.895 Y126.586 E.00861
G1 X121.154 Y126.458 E.00861
G1 X121.431 Y126.364 E.00872
G1 X121.805 Y126.302 E.01129
G1 X122 Y126.29 E.00581
G1 X122.289 Y126.308 E.00861
G1 X122.572 Y126.365 E.00861
G1 X122.849 Y126.459 E.00872
G1 X123.183 Y126.638 E.01129
G1 X123.346 Y126.746 E.00581
G1 X123.563 Y126.937 E.00861
G1 X123.754 Y127.154 E.00861
G1 X123.804 Y127.229 E.00268
; WIPE_START
M204 S10000
G1 X123.862 Y127.317 E-.03994
G1 X124.041 Y127.651 E-.14406
G1 X124.135 Y127.928 E-.11127
G1 X124.192 Y128.211 E-.10982
G1 X124.21 Y128.493 E-.10731
G1 X124.21 Y129.145 E-.2476
; WIPE_END
G1 E-.04 F1800
G1 X129.636 Y123.777 Z2.2 F30000
G1 X137.541 Y115.959 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X137.541 Y127.547 E.37262
G1 X137.336 Y127.581 E.00666
G1 X137.191 Y127.152 E.01457
G1 X136.934 Y126.673 E.01747
G1 X136.747 Y126.392 E.01085
G1 X136.448 Y126.052 E.01456
G1 X136.108 Y125.753 E.01456
G1 X135.827 Y125.566 E.01086
G1 X135.348 Y125.309 E.01747
G1 X134.896 Y125.156 E.01536
G1 X134.452 Y125.067 E.01457
G1 X134 Y125.038 E.01456
G1 X133.663 Y125.06 E.01086
G1 X133.127 Y125.148 E.01746
G1 X132.675 Y125.301 E.01536
G1 X132.269 Y125.502 E.01457
G1 X131.892 Y125.753 E.01456
G1 X131.552 Y126.052 E.01456
G1 X131.253 Y126.392 E.01456
G1 X131.002 Y126.769 E.01456
G1 X130.801 Y127.175 E.01456
G1 X130.656 Y127.604 E.01457
G1 X130.567 Y128.048 E.01455
G1 X130.541 Y128.452 E.01303
G1 X130.541 Y137.548 E.29247
G1 X130.567 Y137.952 E.01303
G1 X130.656 Y138.396 E.01455
G1 X130.801 Y138.825 E.01457
G1 X130.908 Y139.041 E.00774
G1 X125.092 Y139.041 E.18701
G1 X125.199 Y138.825 E.00774
G1 X125.344 Y138.396 E.01457
G1 X125.433 Y137.952 E.01455
G1 X125.459 Y137.548 E.01303
G1 X125.459 Y128.452 E.29247
G1 X125.433 Y128.048 E.01304
G1 X125.344 Y127.604 E.01455
G1 X125.191 Y127.152 E.01536
G1 X124.934 Y126.673 E.01746
G1 X124.747 Y126.392 E.01086
G1 X124.448 Y126.052 E.01456
G1 X124.108 Y125.753 E.01456
G1 X123.827 Y125.566 E.01086
G1 X123.348 Y125.309 E.01746
G1 X122.896 Y125.156 E.01536
G1 X122.452 Y125.067 E.01457
G1 X122 Y125.038 E.01456
G1 X121.663 Y125.06 E.01086
G1 X121.127 Y125.148 E.01746
G1 X120.675 Y125.301 E.01536
G1 X120.269 Y125.502 E.01456
G1 X119.892 Y125.753 E.01456
G1 X119.552 Y126.052 E.01456
G1 X119.253 Y126.392 E.01456
G1 X119.002 Y126.769 E.01456
G1 X118.801 Y127.175 E.01457
G1 X118.664 Y127.581 E.01378
G1 X118.459 Y127.547 E.00666
G1 X118.459 Y115.959 E.37262
G1 X137.501 Y115.959 E.61231
; WIPE_START
G1 X137.508 Y117.959 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.444 Y125.591 Z2.2 F30000
G1 X137.336 Y138.419 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F3600
G1 X137.541 Y138.453 E.00666
G1 X137.541 Y139.041 E.01891
G1 X137.092 Y139.041 E.01443
G1 X137.199 Y138.825 E.00774
G1 X137.324 Y138.457 E.01249
; WIPE_START
G1 X137.541 Y138.453 E-.08772
G1 X137.541 Y139.041 E-.23729
G1 X137.092 Y139.041 E-.18104
G1 X137.199 Y138.825 E-.09715
G1 X137.324 Y138.457 E-.1568
; WIPE_END
G1 E-.04 F1800
G1 X129.691 Y138.442 Z2.2 F30000
G1 X118.664 Y138.419 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F3600
G1 X118.801 Y138.825 E.01378
G1 X118.908 Y139.041 E.00774
G1 X118.459 Y139.041 E.01443
G1 X118.459 Y138.453 E.01891
G1 X118.624 Y138.426 E.00538
; WIPE_START
G1 X118.801 Y138.825 E-.17648
G1 X118.908 Y139.041 E-.09722
G1 X118.459 Y139.041 E-.18122
G1 X118.459 Y138.453 E-.23752
G1 X118.624 Y138.426 E-.06755
; WIPE_END
G1 E-.04 F1800
G1 X123.55 Y132.595 Z2.2 F30000
G1 X137.948 Y115.552 Z2.2
G1 Z1.8
G1 E.8 F1800
G1 F3600
G1 X137.948 Y139.448 E.7684
G1 X136.364 Y139.448 E.05094
G1 X136.645 Y139.027 E.01627
G1 X136.822 Y138.669 E.01285
G1 X136.95 Y138.29 E.01285
G1 X137.028 Y137.899 E.01284
G1 X137.052 Y137.534 E.01175
G1 X137.052 Y128.466 E.29162
G1 X137.028 Y128.101 E.01175
G1 X136.95 Y127.71 E.01284
G1 X136.816 Y127.314 E.01342
G1 X136.585 Y126.883 E.01575
G1 X136.423 Y126.641 E.00936
G1 X136.16 Y126.34 E.01285
G1 X135.859 Y126.077 E.01284
G1 X135.617 Y125.915 E.00937
G1 X135.186 Y125.684 E.01575
G1 X134.791 Y125.55 E.01342
G1 X134.399 Y125.472 E.01285
G1 X134 Y125.446 E.01284
G1 X133.709 Y125.465 E.00936
G1 X133.226 Y125.544 E.01574
G1 X132.831 Y125.678 E.01342
G1 X132.473 Y125.855 E.01285
G1 X132.141 Y126.077 E.01284
G1 X131.84 Y126.34 E.01285
G1 X131.577 Y126.641 E.01285
G1 X131.355 Y126.973 E.01284
G1 X131.178 Y127.331 E.01285
G1 X131.05 Y127.71 E.01285
G1 X130.972 Y128.101 E.01284
G1 X130.948 Y128.466 E.01175
G1 X130.948 Y137.534 E.29161
G1 X130.972 Y137.899 E.01175
G1 X131.05 Y138.29 E.01284
G1 X131.178 Y138.669 E.01285
G1 X131.355 Y139.027 E.01285
G1 X131.636 Y139.448 E.01627
G1 X124.364 Y139.448 E.23384
G1 X124.645 Y139.027 E.01627
G1 X124.822 Y138.669 E.01285
G1 X124.95 Y138.29 E.01285
G1 X125.028 Y137.899 E.01284
G1 X125.052 Y137.534 E.01175
G1 X125.052 Y128.466 E.29161
G1 X125.028 Y128.101 E.01175
G1 X124.95 Y127.71 E.01284
G1 X124.816 Y127.314 E.01342
G1 X124.585 Y126.883 E.01574
G1 X124.423 Y126.641 E.00936
G1 X124.16 Y126.34 E.01285
G1 X123.859 Y126.077 E.01284
G1 X123.617 Y125.915 E.00937
G1 X123.186 Y125.684 E.01574
G1 X122.791 Y125.55 E.01342
G1 X122.399 Y125.472 E.01285
G1 X122 Y125.446 E.01284
G1 X121.709 Y125.465 E.00936
G1 X121.226 Y125.544 E.01574
G1 X120.831 Y125.678 E.01342
G1 X120.473 Y125.855 E.01285
G1 X120.141 Y126.077 E.01285
G1 X119.84 Y126.34 E.01285
G1 X119.577 Y126.641 E.01285
G1 X119.355 Y126.973 E.01284
G1 X119.178 Y127.331 E.01285
G1 X119.05 Y127.71 E.01285
G1 X118.972 Y128.101 E.01284
G1 X118.948 Y128.466 E.01175
G1 X118.948 Y137.534 E.29161
G1 X118.972 Y137.899 E.01175
G1 X119.05 Y138.29 E.01284
G1 X119.178 Y138.669 E.01285
G1 X119.355 Y139.027 E.01285
G1 X119.636 Y139.448 E.01627
G1 X118.052 Y139.448 E.05094
G1 X118.052 Y115.552 E.7684
G1 X137.908 Y115.552 E.63849
G1 X138.355 Y115.145 F30000
G1 F3600
G1 X138.355 Y139.855 E.79458
G1 X135.541 Y139.855 E.0905
G1 X135.488 Y139.682 E.00582
G1 X135.62 Y139.594 E.00509
G1 X135.933 Y139.301 E.01381
G1 X136.1 Y139.111 E.00811
G1 X136.292 Y138.823 E.01113
G1 X136.445 Y138.513 E.01113
G1 X136.556 Y138.185 E.01113
G1 X136.624 Y137.846 E.01113
G1 X136.645 Y137.521 E.01046
G1 X136.645 Y128.479 E.29076
G1 X136.624 Y128.154 E.01046
G1 X136.556 Y127.815 E.01112
G1 X136.441 Y127.477 E.01149
G1 X136.235 Y127.092 E.01403
G1 X136.1 Y126.889 E.00786
G1 X135.871 Y126.629 E.01113
G1 X135.611 Y126.401 E.01113
G1 X135.408 Y126.265 E.00787
G1 X135.023 Y126.059 E.01403
G1 X134.685 Y125.944 E.01148
G1 X134.345 Y125.876 E.01113
G1 X134 Y125.854 E.01113
G1 X133.756 Y125.87 E.00787
G1 X133.325 Y125.94 E.01403
G1 X132.987 Y126.055 E.01148
G1 X132.677 Y126.208 E.01113
G1 X132.389 Y126.401 E.01113
G1 X132.129 Y126.629 E.01113
G1 X131.9 Y126.889 E.01113
G1 X131.708 Y127.177 E.01113
G1 X131.555 Y127.487 E.01113
G1 X131.444 Y127.815 E.01113
G1 X131.376 Y128.154 E.01113
G1 X131.355 Y128.479 E.01046
G1 X131.355 Y137.521 E.29076
G1 X131.376 Y137.846 E.01046
G1 X131.444 Y138.185 E.01113
G1 X131.555 Y138.513 E.01114
G1 X131.708 Y138.823 E.01113
G1 X131.9 Y139.111 E.01113
G1 X132.129 Y139.371 E.01113
G1 X132.389 Y139.6 E.01113
G1 X132.512 Y139.682 E.00475
G1 X132.459 Y139.855 E.00582
G1 X123.541 Y139.855 E.2868
G1 X123.488 Y139.682 E.00582
G1 X123.62 Y139.594 E.00509
G1 X123.933 Y139.301 E.01381
G1 X124.1 Y139.111 E.00811
G1 X124.292 Y138.823 E.01113
G1 X124.445 Y138.513 E.01113
G1 X124.556 Y138.185 E.01113
G1 X124.624 Y137.846 E.01113
G1 X124.645 Y137.521 E.01046
G1 X124.645 Y128.479 E.29076
G1 X124.624 Y128.154 E.01046
G1 X124.556 Y127.815 E.01112
G1 X124.441 Y127.477 E.01148
G1 X124.235 Y127.092 E.01403
G1 X124.099 Y126.889 E.00787
G1 X123.871 Y126.629 E.01113
G1 X123.611 Y126.401 E.01113
G1 X123.408 Y126.265 E.00787
G1 X123.023 Y126.059 E.01403
G1 X122.685 Y125.944 E.01148
G1 X122.345 Y125.876 E.01113
G1 X122 Y125.854 E.01113
G1 X121.756 Y125.87 E.00787
G1 X121.325 Y125.94 E.01403
G1 X120.987 Y126.055 E.01148
G1 X120.677 Y126.208 E.01113
G1 X120.389 Y126.401 E.01113
G1 X120.129 Y126.629 E.01113
G1 X119.9 Y126.889 E.01113
G1 X119.708 Y127.177 E.01113
G1 X119.555 Y127.487 E.01113
G1 X119.444 Y127.815 E.01113
G1 X119.376 Y128.154 E.01113
G1 X119.355 Y128.479 E.01046
G1 X119.355 Y137.521 E.29076
G1 X119.376 Y137.846 E.01046
G1 X119.444 Y138.185 E.01113
G1 X119.555 Y138.513 E.01114
G1 X119.708 Y138.823 E.01113
G1 X119.9 Y139.111 E.01113
G1 X120.129 Y139.371 E.01113
G1 X120.389 Y139.6 E.01113
G1 X120.512 Y139.682 E.00475
G1 X120.459 Y139.855 E.00582
G1 X117.645 Y139.855 E.0905
G1 X117.645 Y115.145 E.79458
G1 X138.315 Y115.145 E.66467
M204 S250
G1 X138.79 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
; WIPE_START
M204 S10000
G1 X138.753 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.27 Y116.126 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40507
; LAYER_HEIGHT: 0.4
M106 S153
G1 F1500
G1 X137.171 Y116.785 E.05681
G1 X137.171 Y117.349 E.02869
G1 X135.776 Y116.329 E.08796
G1 X135.005 Y116.329 E.03925
G1 X137.171 Y117.912 E.13658
G1 X137.171 Y118.476 E.02869
G1 X134.234 Y116.329 E.18519
G1 X133.463 Y116.329 E.03925
G1 X137.171 Y119.04 E.23381
G1 X137.171 Y119.604 E.02869
G1 X132.692 Y116.329 E.28242
G1 X131.921 Y116.329 E.03925
G1 X137.171 Y120.167 E.33104
G1 X137.171 Y120.731 E.02869
G1 X131.15 Y116.329 E.37966
G1 X130.378 Y116.329 E.03925
G1 X137.171 Y121.295 E.42828
G1 X137.171 Y121.858 E.02869
G1 X129.607 Y116.329 E.47689
G1 X128.836 Y116.329 E.03925
G1 X137.171 Y122.422 E.52551
G1 X137.171 Y122.986 E.02869
G1 X128.065 Y116.329 E.57413
G1 X127.294 Y116.329 E.03925
G1 X137.171 Y123.549 E.62274
G1 X137.171 Y124.113 E.02869
G1 X126.523 Y116.329 E.67136
G1 X125.752 Y116.329 E.03925
G1 X137.171 Y124.677 E.71998
G1 X137.171 Y125.241 E.02869
G1 X124.981 Y116.329 E.76859
G1 X124.21 Y116.329 E.03925
G1 X137.171 Y125.804 E.81721
G1 X137.171 Y126.08 E.01403
G1 X137.043 Y126.169 E.00795
G1 X136.71 Y125.79 E.02567
G1 X136.333 Y125.459 E.02551
G1 X136.018 Y125.248 E.01933
G1 X135.496 Y124.969 E.03012
G1 X135.05 Y124.818 E.02396
G1 X123.439 Y116.329 E.7321
G1 X122.668 Y116.329 E.03925
G1 X134.081 Y124.673 E.7196
G1 X133.621 Y124.692 E.02342
G1 X133.389 Y124.73 E.01199
G1 X121.897 Y116.329 E.72457
G1 X121.125 Y116.329 E.03925
G1 X132.804 Y124.867 E.73636
G1 X132.533 Y124.959 E.01458
G1 X132.31 Y125.069 E.01267
G1 X120.354 Y116.329 E.7538
G1 X119.583 Y116.329 E.03925
G1 X131.879 Y125.318 E.77523
G1 X131.667 Y125.459 E.01298
G1 X131.501 Y125.605 E.01124
G1 X118.829 Y116.341 E.79896
G1 X118.829 Y116.905 E.02869
G1 X131.17 Y125.927 E.77809
G1 X130.959 Y126.167 E.01626
G1 X130.883 Y126.281 E.00698
G1 X118.829 Y117.468 E.76001
G1 X118.829 Y118.032 E.02869
G1 X130.64 Y126.667 E.74467
G1 X130.441 Y127.085 E.02358
G1 X118.829 Y118.596 E.73216
G1 X118.829 Y119.16 E.02869
G1 X130.292 Y127.539 E.72272
G1 X130.198 Y128.035 E.02565
G1 X118.829 Y119.723 E.7168
G1 X118.829 Y120.287 E.02869
G1 X130.171 Y128.579 E.71513
G1 X130.171 Y129.143 E.02869
G1 X118.626 Y120.703 E.72789
M106 S51
; WIPE_START
G1 X120.241 Y121.883 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.597 Y123.919 Z2.2 F30000
G1 X137.131 Y126.558 Z2.2
G1 Z1.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.110598
; LAYER_HEIGHT: 0.2
G1 F15000
G1 X137.234 Y126.707 E.00097
; LINE_WIDTH: 0.137951
G1 X137.337 Y126.856 E.00136
G1 X137.18 Y127.813 F30000
; LINE_WIDTH: 0.534809
G1 F4879.151
G1 X137.485 Y128.025 E.01446
G1 X137.487 Y128.058 E.00126
G1 X137.5 Y128.459 E.0156
G1 X137.5 Y137.541 E.35289
G1 X137.485 Y137.974 E.01685
G1 X137.178 Y138.186 E.01449
; WIPE_START
G1 X137.485 Y137.974 E-.14166
G1 X137.5 Y137.541 E-.1648
G1 X137.5 Y136.348 E-.45354
; WIPE_END
G1 E-.04 F1800
G1 X136.06 Y139.494 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.11134
G1 F15000
G1 X135.926 Y139.651 E.00112
G1 X135.308 Y139.839 F30000
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X134.984 Y139.904 E.00895
; LINE_WIDTH: 0.363348
G1 F7489.979
G1 X134.878 Y139.921 E.00272
; LINE_WIDTH: 0.328365
G1 F8407.945
G1 X134.772 Y139.939 E.00242
; LINE_WIDTH: 0.290957
G1 F9676.007
G1 X134.651 Y139.958 E.0024
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X134.492 Y139.974 E.00269
; LINE_WIDTH: 0.22395
G1 F13257.53
G1 X134.322 Y139.99 E.00244
; LINE_WIDTH: 0.197595
G1 F15000
G1 X133.667 Y139.989 E.00801
; LINE_WIDTH: 0.224995
G1 F13181.427
M73 P47 R15
G1 X133.508 Y139.974 E.0023
; LINE_WIDTH: 0.257802
G1 F11168.964
G1 X133.334 Y139.956 E.00297
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X133.228 Y139.939 E.00212
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X133.122 Y139.921 E.00242
; LINE_WIDTH: 0.379929
G1 F7121.488
G1 X132.692 Y139.839 E.01167
G1 X132.071 Y139.651 F30000
; LINE_WIDTH: 0.108327
G1 F15000
G1 X131.962 Y139.527 E.00086
; WIPE_START
G1 X132.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X125.559 Y138.173 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40507
; LAYER_HEIGHT: 0.4
M106 S153
G1 F1500
G1 X126.241 Y138.671 E.043
G1 X127.012 Y138.671 E.03925
G1 X125.813 Y137.795 E.07559
G1 X125.829 Y137.242 E.02813
G1 X127.783 Y138.671 E.12324
G1 X128.555 Y138.671 E.03925
G1 X125.829 Y136.679 E.17185
G1 X125.829 Y136.115 E.02869
G1 X129.326 Y138.671 E.22047
G1 X130.097 Y138.671 E.03925
G1 X125.829 Y135.551 E.26909
G1 X125.829 Y134.987 E.02869
G1 X130.243 Y138.214 E.27828
G1 X130.2 Y138.001 E.01108
G1 X130.174 Y137.6 E.02043
G1 X125.829 Y134.424 E.27395
G1 X125.829 Y133.86 E.02869
G1 X130.171 Y137.034 E.27378
G1 X130.171 Y136.471 E.02869
G1 X125.829 Y133.296 E.27378
G1 X125.829 Y132.733 E.02869
G1 X130.171 Y135.907 E.27378
G1 X130.171 Y135.343 E.02869
G1 X125.829 Y132.169 E.27378
G1 X125.829 Y131.605 E.02869
G1 X130.171 Y134.78 E.27378
G1 X130.171 Y134.216 E.02869
G1 X125.829 Y131.041 E.27378
G1 X125.829 Y130.478 E.02869
G1 X130.171 Y133.652 E.27378
G1 X130.171 Y133.088 E.02869
G1 X125.829 Y129.914 E.27378
G1 X125.829 Y129.35 E.02869
G1 X130.171 Y132.525 E.27378
G1 X130.171 Y131.961 E.02869
G1 X125.829 Y128.787 E.27378
G1 X125.814 Y128.212 E.02926
G1 X130.171 Y131.397 E.27472
G1 X130.171 Y130.834 E.02869
G1 X125.716 Y127.577 E.28091
G1 X125.531 Y127.004 E.03062
G1 X125.42 Y126.797 E.01197
G1 X130.171 Y130.27 E.29955
G1 X130.171 Y129.706 E.02869
G1 X118.829 Y121.414 E.71513
G1 X118.829 Y121.978 E.02869
G1 X122.571 Y124.714 E.23597
G1 X122 Y124.667 E.02918
G1 X121.758 Y124.683 E.01235
G1 X118.829 Y122.542 E.18467
G1 X118.829 Y123.106 E.02869
G1 X121.113 Y124.775 E.14402
G1 X120.574 Y124.945 E.02876
G1 X118.829 Y123.669 E.11003
G1 X118.829 Y124.233 E.02869
G1 X120.108 Y125.168 E.08068
G1 X119.703 Y125.435 E.02473
G1 X118.829 Y124.797 E.05508
G1 X118.829 Y125.36 E.02869
G1 X119.347 Y125.739 E.03269
G1 X119.038 Y126.077 E.0233
G1 X118.626 Y125.776 E.02595
M106 S51
G1 X118.856 Y126.575 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.124422
; LAYER_HEIGHT: 0.2
G1 F15000
G1 X118.663 Y126.854 E.00219
G1 X118.821 Y127.813 F30000
; LINE_WIDTH: 0.534808
G1 F4879.165
G1 X118.515 Y128.025 E.01446
G1 X118.513 Y128.058 E.00126
G1 X118.5 Y128.459 E.0156
G1 X118.5 Y137.541 E.35289
G1 X118.515 Y137.974 E.01685
G1 X118.821 Y138.187 E.01448
; WIPE_START
G1 X118.515 Y137.974 E-.14157
G1 X118.5 Y137.541 E-.16481
G1 X118.5 Y136.347 E-.45362
; WIPE_END
G1 E-.04 F1800
G1 X119.962 Y139.527 Z2.2 F30000
G1 Z1.8
G1 E.8 F1800
; LINE_WIDTH: 0.108327
G1 F15000
G1 X120.071 Y139.651 E.00086
G1 X120.692 Y139.839 F30000
; LINE_WIDTH: 0.379928
G1 F7121.5
G1 X121.122 Y139.921 E.01167
; LINE_WIDTH: 0.32836
G1 F8408.073
G1 X121.228 Y139.939 E.00242
; LINE_WIDTH: 0.293374
G1 F9582.623
G1 X121.334 Y139.956 E.00212
; LINE_WIDTH: 0.257801
G1 F11168.967
G1 X121.508 Y139.974 E.00297
; LINE_WIDTH: 0.224995
G1 F13181.427
G1 X121.667 Y139.989 E.0023
; LINE_WIDTH: 0.197595
G1 F15000
G1 X122.322 Y139.99 E.00801
; LINE_WIDTH: 0.22395
G1 F13257.525
G1 X122.492 Y139.974 E.00244
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X122.651 Y139.958 E.00269
; LINE_WIDTH: 0.290957
G1 F9675.999
G1 X122.772 Y139.939 E.0024
; LINE_WIDTH: 0.328365
G1 F8407.945
G1 X122.878 Y139.921 E.00242
; LINE_WIDTH: 0.363348
G1 F7489.979
G1 X122.984 Y139.904 E.00272
; LINE_WIDTH: 0.38531
G1 F7009.552
G1 X123.308 Y139.839 E.00895
G1 X123.926 Y139.651 F30000
; LINE_WIDTH: 0.11134
G1 F15000
G1 X124.06 Y139.494 E.00112
; CHANGE_LAYER
; Z_HEIGHT: 1.85
; LAYER_HEIGHT: 0.0500001
; WIPE_START
G1 F15000
G1 X123.926 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 15/152
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
M106 S84.15
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
G1 X125.123 Y111.803
G1 Z1.85
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F3000
G1 X125.123 Y113.911 E.08266
G1 X119.369 Y113.911 E.22562
G1 X119.369 Y111.615 E.09005
G1 X125.123 Y111.615 E.22562
G1 X125.123 Y108.738 E.11281
G1 X119.369 Y108.738 E.22562
; WIPE_START
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z2.25 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z2.25
G1 Z1.85
M73 P48 R15
G1 E.8 F1800
G1 F3000
G1 X136.631 Y108.738 E.22562
G1 X136.631 Y111.615 E.11281
G1 X130.877 Y111.615 E.22562
G1 X130.877 Y113.911 E.09005
G1 X136.631 Y113.911 E.22562
G1 X136.631 Y111.803 E.08266
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.15
; WIPE_START
G1 X136.631 Y113.803 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 16/152
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
G17
G3 Z2.25 I1.217 J0 P1  F30000
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
G1 X133.154 Y126.458
G1 Z2
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F2400
M204 S5000
G1 X133.154 Y126.458 E.00002
G1 X133.431 Y126.364 E.0087
G1 X133.785 Y126.304 E.0107
G1 X134 Y126.29 E.00643
G1 X134.289 Y126.308 E.00861
G1 X134.572 Y126.365 E.00861
G1 X134.846 Y126.458 E.00861
G1 X135.105 Y126.586 E.00861
G1 X135.346 Y126.746 E.00861
G1 X135.563 Y126.937 E.00861
G1 X135.754 Y127.154 E.00861
G1 X135.874 Y127.334 E.00643
G1 X136.041 Y127.651 E.0107
G1 X136.135 Y127.928 E.0087
G1 X136.192 Y128.211 E.00861
G1 X136.21 Y128.493 E.00841
G1 X136.21 Y137.507 E.26848
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
G1 X136.042 Y138.346 E.00861
G1 X135.914 Y138.605 E.00861
G1 X135.754 Y138.846 E.00861
G1 X135.563 Y139.063 E.00861
G1 X135.346 Y139.254 E.00861
G1 X135.105 Y139.414 E.00861
G1 X134.846 Y139.542 E.00861
G1 X134.572 Y139.635 E.00861
G1 X134.289 Y139.692 E.00861
G1 X134 Y139.71 E.00861
G1 X133.711 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
G1 X132.895 Y139.414 E.00861
G1 X132.654 Y139.254 E.00861
G1 X132.437 Y139.063 E.00861
G1 X132.246 Y138.846 E.00861
G1 X132.086 Y138.605 E.00861
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.865 Y127.928 E.00861
G1 X131.958 Y127.654 E.00861
G1 X132.086 Y127.395 E.00862
G1 X132.246 Y127.154 E.00861
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.895 Y126.586 E.00861
G1 X133.118 Y126.476 E.0074
; WIPE_START
M204 S10000
G1 X133.154 Y126.458 E-.01543
G1 X133.431 Y126.364 E-.11099
G1 X133.785 Y126.304 E-.13646
G1 X134 Y126.29 E-.08199
G1 X134.289 Y126.308 E-.10988
G1 X134.572 Y126.365 E-.10987
G1 X134.846 Y126.458 E-.10987
G1 X135.048 Y126.557 E-.08552
; WIPE_END
G1 E-.04 F1800
G1 X127.429 Y127.01 Z2.4 F30000
G1 X123.801 Y127.226 Z2.4
G1 Z2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X123.874 Y127.334 E.00387
G1 X124.041 Y127.651 E.0107
G1 X124.135 Y127.928 E.0087
G1 X124.192 Y128.211 E.00861
G1 X124.21 Y128.493 E.00841
G1 X124.21 Y137.507 E.26848
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.914 Y138.605 E.00861
G1 X123.754 Y138.846 E.00861
G1 X123.563 Y139.063 E.00861
G1 X123.346 Y139.254 E.00861
G1 X123.105 Y139.414 E.00861
G1 X122.846 Y139.542 E.00861
G1 X122.572 Y139.635 E.00861
G1 X122.289 Y139.692 E.00861
G1 X122 Y139.71 E.00861
G1 X121.711 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
M73 P48 R14
G1 X120.895 Y139.414 E.00861
G1 X120.654 Y139.254 E.00861
G1 X120.437 Y139.063 E.00861
G1 X120.246 Y138.846 E.00861
G1 X120.086 Y138.605 E.00861
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.865 Y127.928 E.00861
G1 X119.958 Y127.654 E.00861
G1 X120.086 Y127.395 E.00862
G1 X120.246 Y127.154 E.00861
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.895 Y126.586 E.00861
G1 X121.154 Y126.458 E.00861
G1 X121.431 Y126.364 E.0087
G1 X121.785 Y126.304 E.0107
G1 X122 Y126.29 E.00643
G1 X122.289 Y126.308 E.00861
G1 X122.572 Y126.365 E.00861
G1 X122.846 Y126.458 E.00861
G1 X123.105 Y126.586 E.00861
G1 X123.346 Y126.746 E.00861
G1 X123.563 Y126.937 E.00861
G1 X123.754 Y127.154 E.00861
G1 X123.779 Y127.193 E.00137
; WIPE_START
M204 S10000
G1 X123.874 Y127.334 E-.06452
G1 X124.041 Y127.651 E-.13648
G1 X124.135 Y127.928 E-.11101
G1 X124.192 Y128.211 E-.10982
G1 X124.21 Y128.493 E-.10731
G1 X124.21 Y129.101 E-.23087
; WIPE_END
G1 E-.04 F1800
G1 X129.645 Y123.743 Z2.4 F30000
G1 X137.541 Y115.959 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X137.541 Y127.547 E.37263
G1 X137.336 Y127.581 E.00666
G1 X137.192 Y127.156 E.01443
G1 X136.948 Y126.693 E.01681
G1 X136.747 Y126.392 E.01165
G1 X136.448 Y126.052 E.01456
G1 X136.108 Y125.753 E.01456
G1 X135.731 Y125.502 E.01456
G1 X135.325 Y125.301 E.01457
G1 X134.896 Y125.156 E.01456
G1 X134.452 Y125.067 E.01457
G1 X134 Y125.038 E.01456
G1 X133.639 Y125.061 E.01164
G1 X133.123 Y125.149 E.01681
G1 X132.675 Y125.301 E.01523
G1 X132.269 Y125.502 E.01456
G1 X131.892 Y125.753 E.01456
G1 X131.552 Y126.052 E.01456
G1 X131.253 Y126.392 E.01456
G1 X131.002 Y126.769 E.01456
G1 X130.801 Y127.175 E.01457
G1 X130.656 Y127.604 E.01456
G1 X130.567 Y128.048 E.01456
G1 X130.541 Y128.452 E.01303
G1 X130.541 Y137.548 E.29247
G1 X130.567 Y137.952 E.01303
G1 X130.656 Y138.396 E.01455
G1 X130.801 Y138.825 E.01457
G1 X130.908 Y139.041 E.00774
G1 X125.092 Y139.041 E.18701
G1 X125.199 Y138.825 E.00774
G1 X125.344 Y138.396 E.01457
G1 X125.433 Y137.952 E.01455
G1 X125.459 Y137.548 E.01303
G1 X125.459 Y128.452 E.29247
G1 X125.433 Y128.048 E.01303
G1 X125.344 Y127.604 E.01455
G1 X125.192 Y127.156 E.01522
G1 X124.948 Y126.693 E.01681
G1 X124.747 Y126.392 E.01165
G1 X124.448 Y126.052 E.01456
G1 X124.108 Y125.753 E.01456
G1 X123.731 Y125.502 E.01456
G1 X123.325 Y125.301 E.01457
G1 X122.896 Y125.156 E.01456
G1 X122.452 Y125.067 E.01457
G1 X122 Y125.038 E.01456
G1 X121.639 Y125.061 E.01164
G1 X121.123 Y125.149 E.01681
G1 X120.675 Y125.301 E.01523
G1 X120.269 Y125.502 E.01456
G1 X119.892 Y125.753 E.01457
G1 X119.552 Y126.052 E.01456
G1 X119.253 Y126.392 E.01456
G1 X119.002 Y126.769 E.01456
G1 X118.801 Y127.175 E.01457
G1 X118.664 Y127.581 E.01377
G1 X118.459 Y127.547 E.00666
G1 X118.459 Y115.959 E.37262
G1 X137.501 Y115.959 E.61231
; WIPE_START
G1 X137.508 Y117.959 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.444 Y125.591 Z2.4 F30000
G1 X137.336 Y138.419 Z2.4
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X137.541 Y138.453 E.00666
G1 X137.541 Y139.041 E.01891
G1 X137.092 Y139.041 E.01443
G1 X137.199 Y138.825 E.00774
G1 X137.324 Y138.457 E.01249
; WIPE_START
G1 X137.541 Y138.453 E-.08772
G1 X137.541 Y139.041 E-.23729
G1 X137.092 Y139.041 E-.18104
G1 X137.199 Y138.825 E-.09715
G1 X137.324 Y138.457 E-.1568
; WIPE_END
G1 E-.04 F1800
G1 X129.691 Y138.442 Z2.4 F30000
G1 X118.664 Y138.419 Z2.4
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X118.801 Y138.825 E.01378
G1 X118.908 Y139.041 E.00774
G1 X118.459 Y139.041 E.01443
G1 X118.459 Y138.453 E.01891
G1 X118.624 Y138.426 E.00538
; WIPE_START
G1 X118.801 Y138.825 E-.17648
G1 X118.908 Y139.041 E-.09722
G1 X118.459 Y139.041 E-.18122
G1 X118.459 Y138.453 E-.23752
G1 X118.624 Y138.426 E-.06755
; WIPE_END
G1 E-.04 F1800
G1 X123.55 Y132.595 Z2.4 F30000
G1 X137.948 Y115.552 Z2.4
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X137.948 Y139.448 E.7684
G1 X136.364 Y139.448 E.05094
G1 X136.645 Y139.027 E.01627
G1 X136.822 Y138.669 E.01285
G1 X136.95 Y138.29 E.01285
G1 X137.028 Y137.899 E.01284
G1 X137.052 Y137.534 E.01175
G1 X137.052 Y128.466 E.29161
G1 X137.028 Y128.101 E.01175
G1 X136.95 Y127.71 E.01284
G1 X136.817 Y127.317 E.01332
G1 X136.598 Y126.902 E.0151
G1 X136.423 Y126.641 E.01012
G1 X136.16 Y126.34 E.01284
G1 X135.859 Y126.077 E.01284
G1 X135.527 Y125.855 E.01285
G1 X135.169 Y125.678 E.01285
G1 X134.791 Y125.55 E.01285
G1 X134.399 Y125.472 E.01285
G1 X134 Y125.446 E.01284
G1 X133.686 Y125.466 E.01011
G1 X133.223 Y125.545 E.0151
G1 X132.831 Y125.678 E.01332
G1 X132.473 Y125.855 E.01285
G1 X132.141 Y126.077 E.01285
G1 X131.84 Y126.34 E.01285
G1 X131.577 Y126.641 E.01285
G1 X131.355 Y126.973 E.01284
G1 X131.178 Y127.331 E.01285
G1 X131.05 Y127.71 E.01285
G1 X130.972 Y128.101 E.01284
G1 X130.948 Y128.466 E.01175
G1 X130.948 Y137.534 E.29161
G1 X130.972 Y137.899 E.01175
G1 X131.05 Y138.29 E.01284
G1 X131.178 Y138.669 E.01285
G1 X131.355 Y139.027 E.01284
G1 X131.636 Y139.448 E.01627
G1 X124.364 Y139.448 E.23384
G1 X124.645 Y139.027 E.01627
G1 X124.822 Y138.669 E.01285
G1 X124.95 Y138.29 E.01285
G1 X125.028 Y137.899 E.01284
G1 X125.052 Y137.534 E.01175
G1 X125.052 Y128.466 E.29161
G1 X125.028 Y128.101 E.01175
G1 X124.95 Y127.71 E.01284
G1 X124.817 Y127.317 E.01332
G1 X124.598 Y126.902 E.0151
G1 X124.423 Y126.641 E.01012
G1 X124.16 Y126.34 E.01284
G1 X123.859 Y126.077 E.01284
G1 X123.527 Y125.855 E.01285
G1 X123.169 Y125.678 E.01285
G1 X122.791 Y125.55 E.01285
G1 X122.399 Y125.472 E.01285
G1 X122 Y125.446 E.01284
G1 X121.686 Y125.466 E.01011
G1 X121.223 Y125.545 E.0151
G1 X120.831 Y125.678 E.01332
G1 X120.473 Y125.855 E.01284
G1 X120.141 Y126.077 E.01285
G1 X119.84 Y126.34 E.01284
G1 X119.577 Y126.641 E.01285
G1 X119.355 Y126.973 E.01284
G1 X119.178 Y127.331 E.01285
G1 X119.05 Y127.71 E.01285
G1 X118.972 Y128.101 E.01284
G1 X118.948 Y128.466 E.01175
G1 X118.948 Y137.534 E.29161
G1 X118.972 Y137.899 E.01175
G1 X119.05 Y138.29 E.01284
G1 X119.178 Y138.669 E.01285
G1 X119.355 Y139.027 E.01284
G1 X119.636 Y139.448 E.01627
G1 X118.052 Y139.448 E.05094
G1 X118.052 Y115.552 E.7684
G1 X137.908 Y115.552 E.63849
G1 X138.355 Y115.145 F30000
G1 F3600
G1 X138.355 Y139.855 E.79458
G1 X135.541 Y139.855 E.0905
G1 X135.488 Y139.682 E.00582
G1 X135.611 Y139.599 E.00476
G1 X135.871 Y139.371 E.01113
G1 X136.1 Y139.111 E.01113
G1 X136.292 Y138.823 E.01113
G1 X136.445 Y138.513 E.01113
G1 X136.556 Y138.185 E.01113
G1 X136.624 Y137.846 E.01113
G1 X136.645 Y137.521 E.01046
G1 X136.645 Y128.479 E.29076
G1 X136.624 Y128.154 E.01046
G1 X136.556 Y127.815 E.01113
G1 X136.442 Y127.479 E.01142
G1 X136.248 Y127.111 E.01338
G1 X136.099 Y126.889 E.00858
G1 X135.871 Y126.629 E.01113
G1 X135.611 Y126.401 E.01113
G1 X135.323 Y126.208 E.01113
G1 X135.013 Y126.055 E.01113
G1 X134.685 Y125.944 E.01113
G1 X134.345 Y125.876 E.01113
G1 X134 Y125.854 E.01113
G1 X133.734 Y125.871 E.00858
G1 X133.324 Y125.941 E.01338
G1 X132.987 Y126.055 E.01142
G1 X132.677 Y126.208 E.01113
G1 X132.389 Y126.401 E.01113
G1 X132.129 Y126.629 E.01113
G1 X131.9 Y126.889 E.01113
G1 X131.708 Y127.177 E.01113
G1 X131.555 Y127.487 E.01114
G1 X131.444 Y127.815 E.01113
G1 X131.376 Y128.154 E.01113
G1 X131.355 Y128.479 E.01046
G1 X131.355 Y137.521 E.29076
G1 X131.376 Y137.846 E.01046
G1 X131.444 Y138.185 E.01113
G1 X131.555 Y138.513 E.01113
G1 X131.708 Y138.823 E.01113
G1 X131.9 Y139.111 E.01113
G1 X132.129 Y139.371 E.01113
G1 X132.389 Y139.599 E.01113
G1 X132.512 Y139.682 E.00476
G1 X132.459 Y139.855 E.00582
G1 X123.541 Y139.855 E.2868
G1 X123.488 Y139.682 E.00582
G1 X123.611 Y139.599 E.00476
G1 X123.871 Y139.371 E.01113
G1 X124.1 Y139.111 E.01113
G1 X124.292 Y138.823 E.01113
G1 X124.445 Y138.513 E.01113
G1 X124.556 Y138.185 E.01113
G1 X124.624 Y137.846 E.01113
G1 X124.645 Y137.521 E.01046
G1 X124.645 Y128.479 E.29076
G1 X124.624 Y128.154 E.01046
G1 X124.556 Y127.815 E.01113
G1 X124.442 Y127.479 E.01142
G1 X124.248 Y127.111 E.01338
G1 X124.099 Y126.889 E.00858
G1 X123.871 Y126.629 E.01113
G1 X123.611 Y126.401 E.01113
G1 X123.323 Y126.208 E.01113
G1 X123.013 Y126.055 E.01113
G1 X122.685 Y125.944 E.01113
G1 X122.345 Y125.876 E.01113
G1 X122 Y125.854 E.01113
G1 X121.734 Y125.871 E.00858
G1 X121.324 Y125.941 E.01338
G1 X120.987 Y126.055 E.01142
G1 X120.677 Y126.208 E.01113
G1 X120.389 Y126.401 E.01113
G1 X120.129 Y126.629 E.01113
G1 X119.9 Y126.889 E.01113
G1 X119.708 Y127.177 E.01113
G1 X119.555 Y127.487 E.01114
G1 X119.444 Y127.815 E.01113
G1 X119.376 Y128.154 E.01113
G1 X119.355 Y128.479 E.01046
G1 X119.355 Y137.521 E.29076
G1 X119.376 Y137.846 E.01046
G1 X119.444 Y138.185 E.01113
G1 X119.555 Y138.513 E.01113
G1 X119.708 Y138.823 E.01113
G1 X119.9 Y139.111 E.01113
G1 X120.129 Y139.371 E.01113
G1 X120.389 Y139.599 E.01113
G1 X120.512 Y139.682 E.00476
G1 X120.459 Y139.855 E.00582
G1 X117.645 Y139.855 E.0905
G1 X117.645 Y115.145 E.79458
G1 X138.315 Y115.145 E.66467
M204 S250
G1 X138.79 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
; WIPE_START
M204 S10000
G1 X138.753 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.519 Y124.242 Z2.4 F30000
G1 X137.138 Y126.566 Z2.4
G1 Z2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.110352
G1 F15000
G1 X137.237 Y126.711 E.00094
; LINE_WIDTH: 0.137222
G1 X137.337 Y126.856 E.00131
G1 X137.179 Y127.813 F30000
; LINE_WIDTH: 0.534809
G1 F4879.156
G1 X137.485 Y128.025 E.01448
G1 X137.487 Y128.058 E.00126
G1 X137.5 Y128.459 E.0156
G1 X137.5 Y137.541 E.35289
G1 X137.485 Y137.974 E.01685
G1 X137.178 Y138.186 E.01449
; WIPE_START
G1 X137.485 Y137.974 E-.14166
G1 X137.5 Y137.541 E-.1648
G1 X137.5 Y136.348 E-.45354
; WIPE_END
G1 E-.04 F1800
G1 X136.038 Y139.527 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.10833
G1 F15000
G1 X135.929 Y139.651 E.00086
G1 X135.308 Y139.839 F30000
; LINE_WIDTH: 0.385284
G1 F7010.082
G1 X134.984 Y139.904 E.00895
; LINE_WIDTH: 0.363331
G1 F7490.395
G1 X134.878 Y139.921 E.00272
; LINE_WIDTH: 0.328351
G1 F8408.335
G1 X134.772 Y139.939 E.00242
; LINE_WIDTH: 0.290951
G1 F9676.242
G1 X134.651 Y139.958 E.0024
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X134.492 Y139.974 E.00269
; LINE_WIDTH: 0.22395
G1 F13257.53
G1 X134.322 Y139.99 E.00244
; LINE_WIDTH: 0.197595
G1 F15000
G1 X133.667 Y139.989 E.00801
; LINE_WIDTH: 0.224995
G1 F13181.427
G1 X133.508 Y139.974 E.0023
; LINE_WIDTH: 0.2578
G1 F11169.026
G1 X133.334 Y139.956 E.00297
; LINE_WIDTH: 0.293373
G1 F9582.664
G1 X133.228 Y139.939 E.00212
; LINE_WIDTH: 0.328357
G1 F8408.168
G1 X133.122 Y139.921 E.00242
; LINE_WIDTH: 0.37992
G1 F7121.68
G1 X132.692 Y139.839 E.01167
G1 X132.071 Y139.651 F30000
; LINE_WIDTH: 0.108329
G1 F15000
G1 X131.962 Y139.527 E.00086
; WIPE_START
G1 X132.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.887 Y138.877 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42215
G1 F3600
G1 X130.325 Y138.44 E.01854
G1 X130.236 Y137.992 E.01367
G1 X129.52 Y138.708 E.03032
G1 X128.984 Y138.708 E.01607
G1 X130.208 Y137.484 E.05184
G1 X130.208 Y136.948 E.01607
G1 X128.448 Y138.708 E.07456
G1 X127.911 Y138.708 E.01607
G1 X130.208 Y136.411 E.09728
G1 X130.208 Y135.875 E.01607
G1 X127.375 Y138.708 E.12
G1 X126.839 Y138.708 E.01607
G1 X130.208 Y135.339 E.14272
G1 X130.208 Y134.802 E.01607
G1 X126.302 Y138.708 E.16544
G1 X125.766 Y138.708 E.01607
G1 X130.208 Y134.266 E.18816
G1 X130.208 Y133.73 E.01607
G1 X125.72 Y138.218 E.19014
G1 X125.764 Y137.996 E.00678
G1 X125.789 Y137.612 E.01151
G1 X130.208 Y133.193 E.1872
G1 X130.208 Y132.657 E.01607
G1 X125.792 Y137.072 E.18705
G1 X125.792 Y136.536 E.01607
G1 X130.208 Y132.121 E.18705
G1 X130.208 Y131.585 E.01607
G1 X125.792 Y136 E.18705
G1 X125.792 Y135.463 E.01607
G1 X130.208 Y131.048 E.18705
G1 X130.208 Y130.512 E.01607
G1 X125.792 Y134.927 E.18705
G1 X125.792 Y134.391 E.01607
G1 X130.208 Y129.976 E.18705
G1 X130.208 Y129.439 E.01607
G1 X125.792 Y133.854 E.18705
G1 X125.792 Y133.318 E.01607
G1 X130.208 Y128.903 E.18705
G1 X130.213 Y128.361 E.01622
G1 X125.792 Y132.782 E.18727
G1 X125.792 Y132.246 E.01607
G1 X130.508 Y127.53 E.19978
; WIPE_START
G1 X129.094 Y128.944 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.256 Y126.306 Z2.4 F30000
G1 X136.735 Y126.13 Z2.4
G1 Z2
G1 E.8 F1800
G1 F3600
G1 X137.208 Y125.657 E.02004
G1 X137.208 Y125.121 E.01607
G1 X136.593 Y125.736 E.02604
G1 X136.307 Y125.485 E.01139
G1 X137.208 Y124.585 E.03817
G1 X137.208 Y124.048 E.01607
G1 X135.985 Y125.271 E.05178
G1 X135.636 Y125.083 E.01187
G1 X137.208 Y123.512 E.06657
G1 X137.208 Y122.976 E.01607
G1 X135.257 Y124.926 E.08264
G1 X134.982 Y124.833 E.00868
G1 X134.842 Y124.805 E.0043
G1 X137.208 Y122.439 E.10023
G1 X137.208 Y121.903 E.01607
G1 X134.382 Y124.729 E.11972
G1 X134 Y124.704 E.01146
G1 X133.861 Y124.713 E.00416
G1 X137.208 Y121.367 E.14176
G1 X137.208 Y120.83 E.01607
G1 X133.03 Y125.008 E.17699
G1 X137.377 Y120.124 F30000
G1 F3600
G1 X132.472 Y125.03 E.20782
G1 X132.102 Y125.212 E.01236
G1 X131.689 Y125.488 E.01488
G1 X131.316 Y125.816 E.01487
G1 X130.988 Y126.189 E.01487
G1 X130.712 Y126.602 E.01487
G1 X130.53 Y126.972 E.01236
G1 X125.792 Y131.709 E.20071
G1 X125.792 Y131.173 E.01607
G1 X137.208 Y119.758 E.4836
G1 X137.208 Y119.221 E.01607
G1 X125.792 Y130.637 E.4836
G1 X125.792 Y130.1 E.01607
G1 X137.208 Y118.685 E.4836
G1 X137.208 Y118.149 E.01607
G1 X125.792 Y129.564 E.4836
G1 X125.792 Y129.028 E.01607
G1 X137.208 Y117.612 E.4836
G1 X137.208 Y117.076 E.01607
G1 X125.792 Y128.491 E.4836
G1 X125.76 Y127.987 E.01514
G1 X137.208 Y116.54 E.48496
G1 X137.208 Y116.292 E.00741
M73 P49 R14
G1 X136.919 Y116.292 E.00865
G1 X125.671 Y127.54 E.47649
G1 X125.538 Y127.137 E.01271
G1 X136.382 Y116.292 E.45943
G1 X135.846 Y116.292 E.01607
G1 X125.366 Y126.772 E.44397
G1 X125.173 Y126.43 E.01179
G1 X135.31 Y116.292 E.42946
G1 X134.773 Y116.292 E.01607
G1 X124.949 Y126.117 E.41622
G1 X124.698 Y125.831 E.01138
G1 X134.237 Y116.292 E.40412
G1 X133.701 Y116.292 E.01607
G1 X124.414 Y125.579 E.39342
G1 X124.106 Y125.351 E.01149
G1 X133.165 Y116.292 E.38377
G1 X132.628 Y116.292 E.01607
G1 X123.771 Y125.15 E.37524
G1 X123.407 Y124.977 E.01206
G1 X132.092 Y116.292 E.36793
G1 X131.556 Y116.292 E.01607
G1 X123.007 Y124.841 E.36217
G1 X122.562 Y124.749 E.0136
G1 X131.019 Y116.292 E.35828
G1 X130.483 Y116.292 E.01607
G1 X122.067 Y124.708 E.35653
G1 X121.491 Y124.749 E.01732
G1 X129.947 Y116.292 E.35824
G1 X129.41 Y116.292 E.01607
G1 X120.495 Y125.207 E.37769
G1 X118.817 Y126.349 F30000
G1 F3600
G1 X128.874 Y116.292 E.42605
G1 X128.338 Y116.292 E.01607
G1 X118.792 Y125.838 E.40439
G1 X118.792 Y125.301 E.01607
G1 X127.801 Y116.292 E.38167
G1 X127.265 Y116.292 E.01607
G1 X118.792 Y124.765 E.35895
G1 X118.792 Y124.229 E.01607
G1 X126.729 Y116.292 E.33623
G1 X126.192 Y116.292 E.01607
G1 X118.792 Y123.692 E.3135
G1 X118.792 Y123.156 E.01607
G1 X125.656 Y116.292 E.29078
G1 X125.12 Y116.292 E.01607
G1 X118.792 Y122.62 E.26806
G1 X118.792 Y122.084 E.01607
G1 X124.584 Y116.292 E.24534
G1 X124.047 Y116.292 E.01607
G1 X118.792 Y121.547 E.22262
G1 X118.792 Y121.011 E.01607
G1 X123.511 Y116.292 E.1999
G1 X122.975 Y116.292 E.01607
G1 X118.792 Y120.475 E.17718
G1 X118.792 Y119.938 E.01607
G1 X122.438 Y116.292 E.15446
G1 X121.902 Y116.292 E.01607
G1 X118.792 Y119.402 E.13174
G1 X118.792 Y118.866 E.01607
G1 X121.366 Y116.292 E.10902
G1 X120.829 Y116.292 E.01607
G1 X118.792 Y118.329 E.0863
G1 X118.792 Y117.793 E.01607
G1 X120.293 Y116.292 E.06358
G1 X119.757 Y116.292 E.01607
G1 X118.792 Y117.257 E.04086
G1 X118.792 Y116.72 E.01607
G1 X119.39 Y116.123 E.02532
G1 X118.856 Y126.575 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.124426
G1 F15000
G1 X118.663 Y126.854 E.00219
G1 X118.821 Y127.813 F30000
; LINE_WIDTH: 0.534809
G1 F4879.151
G1 X118.515 Y128.025 E.01448
G1 X118.5 Y128.459 E.01685
G1 X118.5 Y137.541 E.35289
G1 X118.513 Y137.942 E.0156
G1 X118.515 Y137.974 E.00125
G1 X118.821 Y138.187 E.01448
; WIPE_START
G1 X118.515 Y137.974 E-.14157
G1 X118.513 Y137.942 E-.01227
G1 X118.5 Y137.541 E-.15255
G1 X118.5 Y136.347 E-.45361
; WIPE_END
G1 E-.04 F1800
G1 X119.962 Y139.527 Z2.4 F30000
G1 Z2
G1 E.8 F1800
; LINE_WIDTH: 0.108329
G1 F15000
G1 X120.071 Y139.651 E.00086
G1 X120.692 Y139.839 F30000
; LINE_WIDTH: 0.379919
G1 F7121.682
G1 X121.122 Y139.921 E.01167
; LINE_WIDTH: 0.328357
G1 F8408.168
G1 X121.228 Y139.939 E.00242
; LINE_WIDTH: 0.293373
G1 F9582.664
G1 X121.334 Y139.956 E.00212
; LINE_WIDTH: 0.2578
G1 F11169.026
G1 X121.508 Y139.974 E.00297
; LINE_WIDTH: 0.224995
G1 F13181.427
G1 X121.667 Y139.989 E.0023
; LINE_WIDTH: 0.197595
G1 F15000
G1 X122.322 Y139.99 E.00801
; LINE_WIDTH: 0.22395
G1 F13257.53
G1 X122.492 Y139.974 E.00244
; LINE_WIDTH: 0.256264
G1 F11249.438
G1 X122.651 Y139.958 E.00269
; LINE_WIDTH: 0.290951
G1 F9676.242
G1 X122.772 Y139.939 E.0024
; LINE_WIDTH: 0.328351
G1 F8408.335
G1 X122.878 Y139.921 E.00242
; LINE_WIDTH: 0.363331
G1 F7490.395
G1 X122.984 Y139.904 E.00272
; LINE_WIDTH: 0.385284
G1 F7010.082
G1 X123.308 Y139.839 E.00895
G1 X123.929 Y139.651 F30000
; LINE_WIDTH: 0.10833
G1 F15000
G1 X124.038 Y139.527 E.00086
; CHANGE_LAYER
; Z_HEIGHT: 2.125
; LAYER_HEIGHT: 0.125
; WIPE_START
G1 F15000
G1 X123.929 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 17/152
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
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
G1 X125.123 Y111.803
G1 Z2.125
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F3000
G1 X125.123 Y113.911 E.08266
G1 X119.369 Y113.911 E.22562
G1 X119.369 Y111.615 E.09005
G1 X125.123 Y111.615 E.22562
G1 X125.123 Y108.738 E.11281
G1 X119.369 Y108.738 E.22562
; WIPE_START
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z2.525 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z2.525
G1 Z2.125
G1 E.8 F1800
G1 F3000
G1 X136.631 Y108.738 E.22562
G1 X136.631 Y111.615 E.11281
G1 X130.877 Y111.615 E.22562
G1 X130.877 Y113.911 E.09005
G1 X136.631 Y113.911 E.22562
G1 X136.631 Y111.803 E.08266
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.075
; WIPE_START
G1 X136.631 Y113.803 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 18/152
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
G17
G3 Z2.525 I1.217 J0 P1  F30000
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
G1 X133.153 Y126.458
G1 Z2.2
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F2400
M204 S5000
G1 X133.154 Y126.458 E.00003
G1 X133.43 Y126.364 E.00868
G1 X133.764 Y126.305 E.0101
G1 X134 Y126.29 E.00705
G1 X134.289 Y126.308 E.00861
G1 X134.572 Y126.365 E.00861
G1 X134.848 Y126.458 E.00868
G1 X135.149 Y126.615 E.0101
G1 X135.346 Y126.746 E.00705
G1 X135.563 Y126.937 E.00861
G1 X135.754 Y127.154 E.00862
G1 X135.885 Y127.351 E.00705
G1 X136.041 Y127.652 E.0101
G1 X136.135 Y127.928 E.00868
G1 X136.192 Y128.211 E.00861
G1 X136.21 Y128.493 E.00841
G1 X136.21 Y137.507 E.26848
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
G1 X136.042 Y138.346 E.00861
G1 X135.914 Y138.605 E.00861
G1 X135.754 Y138.846 E.00861
G1 X135.592 Y139.03 E.00731
G1 X135.347 Y139.253 E.00985
G1 X135.105 Y139.414 E.00866
G1 X134.844 Y139.543 E.00867
G1 X134.529 Y139.644 E.00985
G1 X134.288 Y139.692 E.00731
G1 X134 Y139.71 E.00861
G1 X133.712 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
G1 X132.895 Y139.414 E.00861
G1 X132.654 Y139.254 E.00861
G1 X132.437 Y139.063 E.00861
G1 X132.246 Y138.846 E.00861
G1 X132.086 Y138.605 E.00861
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.865 Y127.928 E.00861
G1 X131.958 Y127.654 E.00861
G1 X132.086 Y127.395 E.00862
G1 X132.246 Y127.154 E.00861
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.895 Y126.586 E.00862
G1 X133.117 Y126.476 E.0074
; WIPE_START
M204 S10000
G1 X133.154 Y126.458 E-.01554
G1 X133.43 Y126.364 E-.11071
G1 X133.764 Y126.305 E-.12886
G1 X134 Y126.29 E-.08991
G1 X134.289 Y126.308 E-.10988
G1 X134.572 Y126.365 E-.10987
G1 X134.848 Y126.458 E-.11071
G1 X135.045 Y126.561 E-.08452
; WIPE_END
G1 E-.04 F1800
G1 X127.425 Y126.983 Z2.6 F30000
G1 X123.774 Y127.185 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X123.885 Y127.351 E.00595
G1 X124.041 Y127.652 E.0101
G1 X124.135 Y127.928 E.00868
G1 X124.192 Y128.211 E.00861
G1 X124.21 Y128.493 E.00841
G1 X124.21 Y137.507 E.26848
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.914 Y138.605 E.00861
G1 X123.754 Y138.846 E.00861
G1 X123.592 Y139.03 E.00731
G1 X123.347 Y139.253 E.00985
G1 X123.105 Y139.414 E.00866
G1 X122.844 Y139.543 E.00867
G1 X122.529 Y139.644 E.00985
G1 X122.288 Y139.692 E.00731
G1 X122 Y139.71 E.00861
G1 X121.712 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
G1 X120.895 Y139.414 E.00861
G1 X120.654 Y139.254 E.00861
G1 X120.437 Y139.063 E.00861
G1 X120.246 Y138.846 E.00861
G1 X120.086 Y138.605 E.00861
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.865 Y127.928 E.00861
G1 X119.958 Y127.654 E.00861
G1 X120.086 Y127.395 E.00862
G1 X120.246 Y127.154 E.00861
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.895 Y126.586 E.00862
G1 X121.154 Y126.458 E.00861
G1 X121.43 Y126.364 E.00868
G1 X121.764 Y126.305 E.0101
G1 X122 Y126.29 E.00705
G1 X122.289 Y126.308 E.00861
G1 X122.572 Y126.365 E.00861
G1 X122.848 Y126.458 E.00868
G1 X123.149 Y126.615 E.0101
G1 X123.346 Y126.746 E.00705
G1 X123.563 Y126.937 E.00861
G1 X123.751 Y127.152 E.00852
; WIPE_START
M204 S10000
G1 X123.885 Y127.351 E-.09115
G1 X124.041 Y127.652 E-.12887
G1 X124.135 Y127.928 E-.11074
G1 X124.192 Y128.211 E-.10982
G1 X124.21 Y128.493 E-.10731
G1 X124.21 Y129.051 E-.21211
; WIPE_END
G1 E-.04 F1800
G1 X129.655 Y123.703 Z2.6 F30000
G1 X137.541 Y115.959 Z2.6
G1 Z2.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X137.541 Y127.547 E.37262
G1 X137.336 Y127.581 E.00666
G1 X137.194 Y127.16 E.01427
G1 X136.962 Y126.714 E.01618
G1 X136.747 Y126.392 E.01244
G1 X136.448 Y126.052 E.01457
G1 X136.108 Y125.753 E.01456
G1 X135.786 Y125.538 E.01245
G1 X135.34 Y125.306 E.01617
G1 X134.896 Y125.156 E.01506
G1 X134.452 Y125.067 E.01457
G1 X134 Y125.038 E.01456
G1 X133.614 Y125.063 E.01245
G1 X133.119 Y125.151 E.01617
G1 X132.675 Y125.301 E.01506
G1 X132.269 Y125.502 E.01456
G1 X131.892 Y125.753 E.01457
G1 X131.552 Y126.052 E.01455
G1 X131.253 Y126.392 E.01456
G1 X131.002 Y126.769 E.01456
G1 X130.801 Y127.175 E.01457
G1 X130.656 Y127.604 E.01457
G1 X130.567 Y128.048 E.01456
G1 X130.541 Y128.452 E.01303
G1 X130.541 Y137.548 E.29247
G1 X130.567 Y137.952 E.01303
G1 X130.656 Y138.396 E.01456
G1 X130.801 Y138.825 E.01456
G1 X130.908 Y139.041 E.00774
G1 X125.092 Y139.041 E.187
G1 X125.199 Y138.825 E.00774
G1 X125.344 Y138.396 E.01456
G1 X125.433 Y137.952 E.01456
G1 X125.459 Y137.548 E.01303
G1 X125.459 Y128.452 E.29247
G1 X125.433 Y128.048 E.01303
G1 X125.344 Y127.604 E.01455
G1 X125.194 Y127.16 E.01507
G1 X124.962 Y126.714 E.01618
G1 X124.747 Y126.392 E.01244
G1 X124.448 Y126.052 E.01457
G1 X124.108 Y125.753 E.01456
G1 X123.786 Y125.538 E.01245
G1 X123.34 Y125.306 E.01617
G1 X122.896 Y125.156 E.01506
G1 X122.452 Y125.067 E.01457
G1 X122 Y125.038 E.01456
G1 X121.614 Y125.063 E.01245
G1 X121.119 Y125.151 E.01617
G1 X120.675 Y125.301 E.01506
G1 X120.269 Y125.502 E.01456
G1 X119.892 Y125.753 E.01457
G1 X119.552 Y126.052 E.01455
G1 X119.253 Y126.392 E.01456
G1 X119.002 Y126.769 E.01456
G1 X118.801 Y127.175 E.01457
G1 X118.664 Y127.581 E.01378
G1 X118.459 Y127.547 E.00666
G1 X118.459 Y115.959 E.37263
G1 X137.501 Y115.959 E.61231
; WIPE_START
G1 X137.508 Y117.959 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.444 Y125.591 Z2.6 F30000
G1 X137.336 Y138.419 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X137.541 Y138.453 E.00666
G1 X137.541 Y139.041 E.0189
G1 X137.092 Y139.041 E.01443
G1 X137.199 Y138.825 E.00774
G1 X137.324 Y138.457 E.01249
; WIPE_START
G1 X137.541 Y138.453 E-.08772
G1 X137.541 Y139.041 E-.23727
G1 X137.092 Y139.041 E-.18106
G1 X137.199 Y138.825 E-.09715
G1 X137.324 Y138.457 E-.15679
; WIPE_END
G1 E-.04 F1800
G1 X129.691 Y138.442 Z2.6 F30000
G1 X118.664 Y138.419 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X118.801 Y138.825 E.01378
G1 X118.908 Y139.041 E.00774
G1 X118.459 Y139.041 E.01443
G1 X118.459 Y138.453 E.01891
G1 X118.624 Y138.426 E.00538
; WIPE_START
G1 X118.801 Y138.825 E-.17645
G1 X118.908 Y139.041 E-.09725
G1 X118.459 Y139.041 E-.18123
G1 X118.459 Y138.453 E-.23751
G1 X118.624 Y138.426 E-.06756
; WIPE_END
G1 E-.04 F1800
G1 X123.55 Y132.595 Z2.6 F30000
G1 X137.948 Y115.552 Z2.6
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X137.948 Y139.448 E.7684
G1 X136.364 Y139.448 E.05094
G1 X136.645 Y139.027 E.01628
G1 X136.822 Y138.669 E.01284
G1 X136.95 Y138.291 E.01285
G1 X137.028 Y137.899 E.01284
G1 X137.052 Y137.534 E.01175
G1 X137.052 Y128.466 E.29161
G1 X137.028 Y128.101 E.01175
G1 X136.95 Y127.71 E.01284
G1 X136.818 Y127.321 E.01321
G1 X136.611 Y126.922 E.01446
G1 X136.423 Y126.641 E.01087
G1 X136.16 Y126.34 E.01285
G1 X135.859 Y126.077 E.01284
G1 X135.578 Y125.889 E.01087
G1 X135.179 Y125.682 E.01446
G1 X134.791 Y125.55 E.01321
G1 X134.399 Y125.472 E.01285
G1 X134 Y125.446 E.01284
G1 X133.663 Y125.468 E.01087
G1 X133.22 Y125.546 E.01445
G1 X132.831 Y125.678 E.01321
G1 X132.473 Y125.855 E.01285
G1 X132.14 Y126.077 E.01285
G1 X131.84 Y126.34 E.01284
G1 X131.577 Y126.641 E.01285
G1 X131.355 Y126.973 E.01284
G1 X131.178 Y127.331 E.01285
G1 X131.05 Y127.71 E.01285
G1 X130.972 Y128.101 E.01284
G1 X130.948 Y128.466 E.01174
G1 X130.948 Y137.534 E.29161
G1 X130.972 Y137.899 E.01175
G1 X131.05 Y138.29 E.01284
G1 X131.178 Y138.669 E.01285
G1 X131.355 Y139.027 E.01284
G1 X131.636 Y139.448 E.01628
G1 X124.364 Y139.448 E.23384
G1 X124.645 Y139.027 E.01628
G1 X124.822 Y138.669 E.01284
G1 X124.95 Y138.291 E.01285
G1 X125.028 Y137.899 E.01284
G1 X125.052 Y137.534 E.01175
G1 X125.052 Y128.466 E.29161
G1 X125.028 Y128.101 E.01175
G1 X124.95 Y127.71 E.01284
G1 X124.818 Y127.321 E.01321
G1 X124.611 Y126.922 E.01446
G1 X124.423 Y126.641 E.01087
G1 X124.16 Y126.34 E.01285
G1 X123.859 Y126.077 E.01284
G1 X123.578 Y125.889 E.01087
G1 X123.179 Y125.682 E.01446
G1 X122.791 Y125.55 E.01321
G1 X122.399 Y125.472 E.01285
G1 X122 Y125.446 E.01284
G1 X121.663 Y125.468 E.01087
G1 X121.22 Y125.546 E.01445
G1 X120.831 Y125.678 E.01321
G1 X120.473 Y125.855 E.01285
G1 X120.14 Y126.077 E.01285
G1 X119.84 Y126.34 E.01284
M73 P50 R14
G1 X119.577 Y126.641 E.01285
G1 X119.355 Y126.973 E.01284
G1 X119.178 Y127.331 E.01285
G1 X119.05 Y127.71 E.01285
G1 X118.972 Y128.101 E.01284
G1 X118.948 Y128.466 E.01174
G1 X118.948 Y137.534 E.29161
G1 X118.972 Y137.899 E.01175
G1 X119.05 Y138.29 E.01284
G1 X119.178 Y138.669 E.01285
G1 X119.355 Y139.027 E.01284
G1 X119.636 Y139.448 E.01628
G1 X118.052 Y139.448 E.05094
G1 X118.052 Y115.552 E.7684
G1 X137.908 Y115.552 E.63849
G1 X138.355 Y115.145 F30000
G1 F3600
G1 X138.355 Y139.855 E.79458
G1 X135.541 Y139.855 E.0905
G1 X135.488 Y139.682 E.00582
G1 X135.616 Y139.596 E.00494
G1 X135.903 Y139.335 E.01247
G1 X136.1 Y139.111 E.0096
G1 X136.292 Y138.823 E.01113
G1 X136.445 Y138.513 E.01113
G1 X136.556 Y138.185 E.01113
G1 X136.624 Y137.846 E.01113
G1 X136.645 Y137.521 E.01046
G1 X136.645 Y128.479 E.29076
G1 X136.624 Y128.154 E.01046
G1 X136.556 Y127.815 E.01112
G1 X136.443 Y127.481 E.01135
G1 X136.26 Y127.129 E.01274
G1 X136.1 Y126.889 E.00929
G1 X135.871 Y126.629 E.01113
G1 X135.611 Y126.401 E.01113
G1 X135.371 Y126.24 E.0093
G1 X135.019 Y126.057 E.01274
G1 X134.685 Y125.944 E.01135
G1 X134.345 Y125.876 E.01113
G1 X134 Y125.854 E.01113
G1 X133.712 Y125.873 E.00929
G1 X133.322 Y125.942 E.01274
G1 X132.987 Y126.055 E.01135
G1 X132.677 Y126.208 E.01113
G1 X132.389 Y126.401 E.01114
G1 X132.129 Y126.629 E.01113
G1 X131.9 Y126.889 E.01113
G1 X131.708 Y127.177 E.01113
G1 X131.555 Y127.487 E.01114
G1 X131.444 Y127.815 E.01113
G1 X131.376 Y128.154 E.01113
G1 X131.355 Y128.479 E.01046
G1 X131.355 Y137.521 E.29076
G1 X131.376 Y137.846 E.01046
G1 X131.444 Y138.185 E.01113
G1 X131.555 Y138.513 E.01113
G1 X131.708 Y138.823 E.01113
G1 X131.9 Y139.111 E.01113
G1 X132.129 Y139.371 E.01113
G1 X132.389 Y139.6 E.01113
G1 X132.512 Y139.682 E.00475
G1 X132.459 Y139.855 E.00582
G1 X123.541 Y139.855 E.2868
G1 X123.488 Y139.682 E.00582
G1 X123.616 Y139.596 E.00494
G1 X123.903 Y139.335 E.01247
G1 X124.1 Y139.111 E.0096
G1 X124.292 Y138.823 E.01113
G1 X124.445 Y138.513 E.01113
G1 X124.556 Y138.185 E.01113
G1 X124.624 Y137.846 E.01113
G1 X124.645 Y137.521 E.01046
G1 X124.645 Y128.479 E.29076
G1 X124.624 Y128.154 E.01046
G1 X124.556 Y127.815 E.01112
G1 X124.443 Y127.481 E.01135
G1 X124.26 Y127.129 E.01274
G1 X124.1 Y126.889 E.00929
G1 X123.871 Y126.629 E.01113
G1 X123.611 Y126.401 E.01113
G1 X123.371 Y126.24 E.0093
G1 X123.019 Y126.057 E.01274
G1 X122.685 Y125.944 E.01135
G1 X122.345 Y125.876 E.01113
G1 X122 Y125.854 E.01113
G1 X121.712 Y125.873 E.00929
G1 X121.322 Y125.942 E.01274
G1 X120.987 Y126.055 E.01135
G1 X120.677 Y126.208 E.01113
G1 X120.389 Y126.401 E.01114
G1 X120.129 Y126.629 E.01113
G1 X119.9 Y126.889 E.01113
G1 X119.708 Y127.177 E.01113
G1 X119.555 Y127.487 E.01114
G1 X119.444 Y127.815 E.01113
G1 X119.376 Y128.154 E.01113
G1 X119.355 Y128.479 E.01046
G1 X119.355 Y137.521 E.29076
G1 X119.376 Y137.846 E.01046
G1 X119.444 Y138.185 E.01113
G1 X119.555 Y138.513 E.01113
G1 X119.708 Y138.823 E.01113
G1 X119.9 Y139.111 E.01113
G1 X120.129 Y139.371 E.01113
G1 X120.389 Y139.6 E.01113
G1 X120.512 Y139.682 E.00475
G1 X120.459 Y139.855 E.00582
G1 X117.645 Y139.855 E.0905
G1 X117.645 Y115.145 E.79458
G1 X138.315 Y115.145 E.66467
M204 S250
G1 X138.79 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
; WIPE_START
M204 S10000
G1 X138.753 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.61 Y116.123 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42215
G1 F3600
G1 X137.208 Y116.72 E.0253
G1 X137.208 Y117.256 E.01607
G1 X136.244 Y116.292 E.04083
G1 X135.708 Y116.292 E.01607
G1 X137.208 Y117.792 E.06355
G1 X137.208 Y118.329 E.01607
G1 X135.171 Y116.292 E.08627
G1 X134.635 Y116.292 E.01607
G1 X137.208 Y118.865 E.10899
G1 X137.208 Y119.401 E.01607
G1 X134.099 Y116.292 E.13171
G1 X133.562 Y116.292 E.01607
G1 X137.208 Y119.938 E.15443
G1 X137.208 Y120.474 E.01607
G1 X133.026 Y116.292 E.17716
G1 X132.49 Y116.292 E.01607
G1 X137.208 Y121.01 E.19988
G1 X137.208 Y121.547 E.01607
G1 X131.953 Y116.292 E.2226
G1 X131.417 Y116.292 E.01607
G1 X137.208 Y122.083 E.24532
G1 X137.208 Y122.619 E.01607
G1 X130.881 Y116.292 E.26804
G1 X130.344 Y116.292 E.01607
G1 X137.208 Y123.156 E.29076
G1 X137.208 Y123.692 E.01607
G1 X129.808 Y116.292 E.31348
G1 X129.272 Y116.292 E.01607
G1 X137.208 Y124.228 E.3362
G1 X137.208 Y124.765 E.01607
G1 X128.735 Y116.292 E.35892
G1 X128.199 Y116.292 E.01607
G1 X137.208 Y125.301 E.38164
G1 X137.208 Y125.837 E.01607
G1 X127.663 Y116.292 E.40436
G1 X127.127 Y116.292 E.01607
G1 X137.184 Y126.35 E.42608
G1 X135.506 Y125.208 F30000
G1 F3600
G1 X126.59 Y116.292 E.37773
G1 X126.054 Y116.292 E.01607
G1 X134.498 Y124.737 E.35775
G1 X133.933 Y124.708 E.01695
G1 X125.518 Y116.292 E.35653
G1 X124.981 Y116.292 E.01607
G1 X133.444 Y124.755 E.35851
G1 X132.994 Y124.841 E.01372
G1 X124.445 Y116.292 E.36217
G1 X123.909 Y116.292 E.01607
G1 X132.593 Y124.977 E.36792
G1 X132.229 Y125.149 E.01206
G1 X123.372 Y116.292 E.37523
G1 X122.836 Y116.292 E.01607
G1 X131.895 Y125.351 E.38376
G1 X131.586 Y125.579 E.01149
G1 X122.3 Y116.292 E.39341
G1 X121.763 Y116.292 E.01607
G1 X131.302 Y125.831 E.40411
G1 X131.052 Y126.117 E.01138
G1 X121.227 Y116.292 E.41621
G1 X120.691 Y116.292 E.01607
G1 X130.828 Y126.429 E.42945
G1 X130.712 Y126.602 E.00622
G1 X130.63 Y126.768 E.00556
G1 X120.154 Y116.292 E.44381
G1 X119.618 Y116.292 E.01607
G1 X130.462 Y127.137 E.45941
G1 X130.329 Y127.539 E.01271
G1 X119.082 Y116.292 E.47648
G1 X118.792 Y116.292 E.00867
G1 X118.792 Y116.539 E.0074
G1 X130.24 Y127.987 E.48497
G1 X130.208 Y128.491 E.01513
G1 X118.792 Y117.076 E.4836
G1 X118.792 Y117.612 E.01607
G1 X130.208 Y129.027 E.4836
G1 X130.208 Y129.563 E.01607
G1 X118.792 Y118.148 E.4836
G1 X118.792 Y118.685 E.01607
G1 X130.208 Y130.1 E.4836
G1 X130.208 Y130.636 E.01607
G1 X118.792 Y119.221 E.4836
G1 X118.792 Y119.757 E.01607
G1 X130.208 Y131.172 E.4836
G1 X130.208 Y131.709 E.01607
G1 X125.472 Y126.973 E.20062
G1 X125.249 Y126.544 E.01448
G1 X125.012 Y126.189 E.01279
G1 X124.684 Y125.816 E.01488
G1 X124.311 Y125.488 E.01487
G1 X123.956 Y125.251 E.0128
G1 X123.527 Y125.028 E.01448
G1 X118.792 Y120.293 E.20058
G1 X118.792 Y120.83 E.01607
G1 X122.749 Y124.787 E.16764
G1 X122.495 Y124.736 E.00776
G1 X122.139 Y124.713 E.01069
G1 X118.792 Y121.366 E.14179
G1 X118.792 Y121.902 E.01607
G1 X121.619 Y124.729 E.11974
G1 X121.159 Y124.805 E.01397
G1 X118.792 Y122.439 E.10025
G1 X118.792 Y122.975 E.01607
G1 X120.743 Y124.926 E.08266
G1 X120.547 Y124.993 E.00621
G1 X120.364 Y125.083 E.00612
G1 X118.792 Y123.511 E.06658
G1 X118.792 Y124.048 E.01607
G1 X120.015 Y125.27 E.0518
G1 X119.694 Y125.485 E.01158
G1 X118.792 Y124.584 E.03818
G1 X118.792 Y125.12 E.01607
G1 X119.407 Y125.735 E.02605
G1 X119.146 Y126.01 E.01136
G1 X118.623 Y125.487 E.02215
; WIPE_START
G1 X119.146 Y126.01 E-.28095
G1 X119.407 Y125.735 E-.14415
G1 X118.792 Y125.12 E-.33049
G1 X118.792 Y125.109 E-.0044
; WIPE_END
G1 E-.04 F1800
G1 X125.492 Y127.529 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
G1 F3600
G1 X130.208 Y132.245 E.19979
G1 X130.208 Y132.781 E.01607
G1 X125.787 Y128.361 E.18727
G1 X125.792 Y128.902 E.01623
G1 X130.208 Y133.318 E.18705
G1 X130.208 Y133.854 E.01607
G1 X125.792 Y129.439 E.18705
G1 X125.792 Y129.975 E.01607
G1 X130.208 Y134.39 E.18705
G1 X130.208 Y134.927 E.01607
G1 X125.792 Y130.511 E.18705
G1 X125.792 Y131.048 E.01607
G1 X130.208 Y135.463 E.18705
G1 X130.208 Y135.999 E.01607
G1 X125.792 Y131.584 E.18705
G1 X125.792 Y132.12 E.01607
G1 X130.208 Y136.535 E.18705
G1 X130.208 Y137.072 E.01607
G1 X125.792 Y132.657 E.18705
G1 X125.792 Y133.193 E.01607
G1 X130.211 Y137.612 E.1872
G1 X130.236 Y137.996 E.01153
G1 X130.28 Y138.217 E.00676
G1 X125.792 Y133.729 E.19013
G1 X125.792 Y134.266 E.01607
G1 X130.234 Y138.708 E.18819
G1 X129.698 Y138.708 E.01607
G1 X125.792 Y134.802 E.16547
G1 X125.792 Y135.338 E.01607
G1 X129.162 Y138.708 E.14275
G1 X128.626 Y138.708 E.01607
G1 X125.792 Y135.874 E.12003
G1 X125.792 Y136.411 E.01607
G1 X128.089 Y138.708 E.09731
G1 X127.553 Y138.708 E.01607
G1 X125.792 Y136.947 E.07459
G1 X125.792 Y137.483 E.01607
G1 X127.017 Y138.708 E.05186
G1 X126.48 Y138.708 E.01607
G1 X125.764 Y137.991 E.03034
G1 X125.676 Y138.439 E.01367
G1 X126.114 Y138.877 E.01856
; WIPE_START
G1 X125.676 Y138.439 E-.23547
G1 X125.764 Y137.991 E-.17345
G1 X126.417 Y138.645 E-.35108
; WIPE_END
G1 E-.04 F1800
G1 X124.05 Y139.509 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.110091
G1 F15000
G1 X123.927 Y139.651 E.001
G1 X123.309 Y139.84 F30000
; LINE_WIDTH: 0.383006
G1 F7057.038
G1 X122.977 Y139.905 E.00908
; LINE_WIDTH: 0.359394
G1 F7583.571
G1 X122.857 Y139.924 E.00303
; LINE_WIDTH: 0.322061
G1 F8597.813
G1 X122.737 Y139.942 E.00267
; LINE_WIDTH: 0.28282
G1 F10004.169
G1 X122.605 Y139.963 E.00254
; LINE_WIDTH: 0.249518
G1 F11616.767
G1 X122.469 Y139.976 E.00223
; LINE_WIDTH: 0.202016
G1 F15000
G1 X122.005 Y140 E.00584
G1 X121.667 Y139.989 E.00425
; LINE_WIDTH: 0.224994
G1 F13181.497
G1 X121.508 Y139.974 E.0023
; LINE_WIDTH: 0.257798
G1 F11169.125
G1 X121.334 Y139.956 E.00297
; LINE_WIDTH: 0.293373
G1 F9582.664
G1 X121.228 Y139.939 E.00212
; LINE_WIDTH: 0.328357
G1 F8408.168
G1 X121.122 Y139.921 E.00242
; LINE_WIDTH: 0.379927
G1 F7121.527
G1 X120.692 Y139.839 E.01167
G1 X120.071 Y139.651 F30000
; LINE_WIDTH: 0.108328
G1 F15000
G1 X119.962 Y139.527 E.00086
; WIPE_START
G1 X120.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X118.82 Y138.187 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.534805
G1 F4879.194
G1 X118.515 Y137.974 E.01444
G1 X118.513 Y137.942 E.00125
G1 X118.5 Y137.541 E.0156
G1 X118.5 Y128.459 E.35289
G1 X118.515 Y128.026 E.01685
G1 X118.821 Y127.814 E.01446
G1 X118.663 Y126.854 F30000
; LINE_WIDTH: 0.124431
G1 F15000
M73 P51 R14
G1 X118.856 Y126.575 E.00219
; WIPE_START
G1 X118.663 Y126.854 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.294 Y126.739 Z2.6 F30000
G1 X137.145 Y126.574 Z2.6
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.11004
G1 F15000
G1 X137.241 Y126.715 E.0009
; LINE_WIDTH: 0.136299
G1 X137.337 Y126.855 E.00125
G1 X137.179 Y127.813 F30000
; LINE_WIDTH: 0.534812
G1 F4879.121
G1 X137.485 Y128.025 E.01446
G1 X137.487 Y128.058 E.00126
G1 X137.5 Y128.459 E.0156
G1 X137.5 Y137.541 E.35289
G1 X137.485 Y137.975 E.01685
G1 X137.178 Y138.187 E.01448
; WIPE_START
G1 X137.485 Y137.975 E-.14165
G1 X137.5 Y137.541 E-.16484
G1 X137.5 Y136.348 E-.45351
; WIPE_END
G1 E-.04 F1800
G1 X136.05 Y139.509 Z2.6 F30000
G1 Z2.2
G1 E.8 F1800
; LINE_WIDTH: 0.110091
G1 F15000
G1 X135.927 Y139.651 E.001
G1 X135.309 Y139.84 F30000
; LINE_WIDTH: 0.383006
G1 F7057.038
G1 X134.977 Y139.905 E.00908
; LINE_WIDTH: 0.359394
G1 F7583.571
G1 X134.857 Y139.924 E.00303
; LINE_WIDTH: 0.322061
G1 F8597.813
G1 X134.737 Y139.942 E.00267
; LINE_WIDTH: 0.28282
G1 F10004.169
G1 X134.605 Y139.963 E.00254
; LINE_WIDTH: 0.249518
G1 F11616.767
G1 X134.469 Y139.976 E.00223
; LINE_WIDTH: 0.202015
G1 F15000
G1 X134.005 Y140 E.00584
G1 X133.667 Y139.989 E.00425
; LINE_WIDTH: 0.224994
G1 F13181.497
G1 X133.508 Y139.974 E.0023
; LINE_WIDTH: 0.257799
G1 F11169.121
G1 X133.334 Y139.956 E.00297
; LINE_WIDTH: 0.293373
G1 F9582.664
G1 X133.228 Y139.939 E.00212
; LINE_WIDTH: 0.328357
G1 F8408.168
G1 X133.122 Y139.921 E.00242
; LINE_WIDTH: 0.379927
G1 F7121.517
G1 X132.692 Y139.839 E.01167
G1 X132.071 Y139.651 F30000
; LINE_WIDTH: 0.108328
G1 F15000
G1 X131.962 Y139.527 E.00086
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X132.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 19/152
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
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
G1 X136.631 Y111.803
G1 Z2.4
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.275
G1 F3000
G1 X136.631 Y113.911 E.08266
G1 X130.877 Y113.911 E.22562
G1 X130.877 Y111.615 E.09005
G1 X136.631 Y111.615 E.22562
G1 X136.631 Y108.738 E.11281
G1 X130.877 Y108.738 E.22562
; WIPE_START
G1 X132.877 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z2.8 I-.447 J-1.132 P1  F30000
G1 X125.123 Y111.803 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F3000
G1 X125.123 Y113.911 E.08266
G1 X119.369 Y113.911 E.22562
G1 X119.369 Y111.615 E.09005
G1 X125.123 Y111.615 E.22562
G1 X125.123 Y108.738 E.11281
G1 X119.369 Y108.738 E.22562
; WIPE_START
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z2.8 I-1.013 J.674 P1  F30000
G1 X133.154 Y126.458 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Outer wall
; LAYER_HEIGHT: 0.2
G1 F2400
M204 S5000
G1 X133.429 Y126.364 E.00866
G1 X133.743 Y126.306 E.0095
G1 X134 Y126.29 E.00767
G1 X134.289 Y126.308 E.00861
G1 X134.572 Y126.365 E.00861
G1 X134.846 Y126.458 E.00861
G1 X135.105 Y126.586 E.00861
G1 X135.346 Y126.746 E.00861
G1 X135.563 Y126.937 E.00861
G1 X135.754 Y127.154 E.00861
G1 X135.897 Y127.368 E.00767
G1 X136.042 Y127.653 E.00951
G1 X136.135 Y127.928 E.00866
G1 X136.192 Y128.211 E.00861
G1 X136.21 Y128.493 E.00841
G1 X136.21 Y137.507 E.26848
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
G1 X136.042 Y138.346 E.00861
G1 X135.914 Y138.605 E.00861
G1 X135.754 Y138.846 E.00861
G1 X135.563 Y139.063 E.00862
G1 X135.346 Y139.254 E.00861
G1 X135.104 Y139.415 E.00864
G1 X134.825 Y139.549 E.00923
G1 X134.572 Y139.635 E.00796
G1 X134.288 Y139.692 E.00861
G1 X134 Y139.71 E.00861
G1 X133.712 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
G1 X132.895 Y139.414 E.00861
G1 X132.654 Y139.254 E.00861
G1 X132.437 Y139.063 E.00861
G1 X132.246 Y138.846 E.00862
G1 X132.086 Y138.605 E.00861
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.865 Y127.928 E.00861
G1 X131.958 Y127.654 E.00861
G1 X132.086 Y127.395 E.00862
G1 X132.246 Y127.154 E.00861
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.895 Y126.586 E.00861
G1 X133.118 Y126.475 E.00742
; WIPE_START
M204 S10000
G1 X133.429 Y126.364 E-.12551
G1 X133.743 Y126.306 E-.12125
G1 X134 Y126.29 E-.09785
G1 X134.289 Y126.308 E-.10988
G1 X134.572 Y126.365 E-.10985
G1 X134.846 Y126.458 E-.10988
G1 X135.048 Y126.558 E-.08578
; WIPE_END
G1 E-.04 F1800
G1 X127.427 Y126.96 Z2.8 F30000
G1 X123.754 Y127.154 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X123.897 Y127.368 E.00767
G1 X124.042 Y127.653 E.00951
G1 X124.135 Y127.928 E.00866
G1 X124.192 Y128.211 E.00861
G1 X124.21 Y128.493 E.00841
G1 X124.21 Y137.507 E.26848
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.914 Y138.605 E.00861
G1 X123.754 Y138.846 E.00861
G1 X123.563 Y139.063 E.00862
G1 X123.346 Y139.254 E.00861
G1 X123.104 Y139.415 E.00864
G1 X122.825 Y139.549 E.00923
G1 X122.572 Y139.635 E.00796
G1 X122.288 Y139.692 E.00861
G1 X122 Y139.71 E.00861
G1 X121.712 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
G1 X120.895 Y139.414 E.00861
G1 X120.654 Y139.254 E.00861
G1 X120.437 Y139.063 E.00861
G1 X120.246 Y138.846 E.00862
G1 X120.086 Y138.605 E.00861
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.865 Y127.928 E.00861
G1 X119.958 Y127.654 E.00861
G1 X120.086 Y127.395 E.00862
G1 X120.246 Y127.154 E.00861
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.895 Y126.586 E.00861
G1 X121.154 Y126.458 E.00861
G1 X121.429 Y126.364 E.00866
G1 X121.743 Y126.306 E.0095
G1 X122 Y126.29 E.00767
G1 X122.289 Y126.308 E.00861
G1 X122.572 Y126.365 E.00861
G1 X122.846 Y126.458 E.00861
G1 X123.105 Y126.586 E.00861
G1 X123.346 Y126.746 E.00861
G1 X123.563 Y126.937 E.00861
G1 X123.727 Y127.124 E.00742
; WIPE_START
M204 S10000
G1 X123.897 Y127.368 E-.11292
G1 X124.042 Y127.653 E-.12129
G1 X124.135 Y127.928 E-.11043
G1 X124.192 Y128.211 E-.10981
G1 X124.21 Y128.493 E-.10731
G1 X124.21 Y129.015 E-.19824
; WIPE_END
G1 E-.04 F1800
G1 X129.663 Y123.674 Z2.8 F30000
G1 X137.541 Y115.959 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X137.541 Y127.547 E.37263
G1 X137.336 Y127.581 E.00666
G1 X137.196 Y127.166 E.01409
G1 X136.976 Y126.735 E.01554
G1 X136.747 Y126.392 E.01326
G1 X136.448 Y126.052 E.01456
G1 X136.108 Y125.753 E.01456
G1 X135.731 Y125.502 E.01456
G1 X135.325 Y125.301 E.01457
G1 X134.896 Y125.156 E.01456
G1 X134.452 Y125.067 E.01457
G1 X134 Y125.038 E.01456
G1 X133.588 Y125.065 E.01327
G1 X133.113 Y125.152 E.01553
G1 X132.675 Y125.301 E.01488
G1 X132.269 Y125.502 E.01457
G1 X131.892 Y125.753 E.01457
G1 X131.552 Y126.052 E.01456
G1 X131.253 Y126.392 E.01456
G1 X131.002 Y126.769 E.01456
G1 X130.801 Y127.175 E.01456
G1 X130.656 Y127.604 E.01457
G1 X130.567 Y128.048 E.01455
G1 X130.541 Y128.452 E.01303
G1 X130.541 Y137.548 E.29247
G1 X130.567 Y137.952 E.01303
G1 X130.656 Y138.396 E.01456
G1 X130.801 Y138.825 E.01456
G1 X130.908 Y139.041 E.00774
G1 X125.092 Y139.041 E.187
G1 X125.199 Y138.825 E.00774
G1 X125.344 Y138.396 E.01457
G1 X125.433 Y137.952 E.01455
G1 X125.459 Y137.548 E.01304
G1 X125.459 Y128.452 E.29247
G1 X125.433 Y128.048 E.01303
G1 X125.344 Y127.604 E.01455
G1 X125.196 Y127.166 E.01488
G1 X124.976 Y126.736 E.01553
G1 X124.747 Y126.392 E.01328
G1 X124.448 Y126.052 E.01456
G1 X124.108 Y125.753 E.01456
G1 X123.731 Y125.502 E.01457
G1 X123.325 Y125.301 E.01457
G1 X122.896 Y125.156 E.01456
G1 X122.452 Y125.067 E.01457
G1 X122 Y125.038 E.01456
G1 X121.588 Y125.065 E.01327
G1 X121.113 Y125.152 E.01553
G1 X120.675 Y125.301 E.01488
G1 X120.269 Y125.502 E.01457
G1 X119.892 Y125.753 E.01457
G1 X119.552 Y126.052 E.01456
G1 X119.253 Y126.392 E.01456
G1 X119.002 Y126.769 E.01456
G1 X118.801 Y127.175 E.01456
G1 X118.664 Y127.581 E.01378
G1 X118.459 Y127.547 E.00666
G1 X118.459 Y115.959 E.37263
G1 X137.501 Y115.959 E.61231
; WIPE_START
G1 X137.508 Y117.959 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.444 Y125.591 Z2.8 F30000
G1 X137.336 Y138.419 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X137.541 Y138.453 E.00666
G1 X137.541 Y139.041 E.01891
G1 X137.092 Y139.041 E.01443
G1 X137.199 Y138.825 E.00774
G1 X137.324 Y138.457 E.01249
; WIPE_START
G1 X137.541 Y138.453 E-.08772
G1 X137.541 Y139.041 E-.23728
G1 X137.092 Y139.041 E-.18106
G1 X137.199 Y138.825 E-.09714
G1 X137.324 Y138.457 E-.15681
; WIPE_END
G1 E-.04 F1800
G1 X129.691 Y138.442 Z2.8 F30000
G1 X118.664 Y138.419 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X118.801 Y138.825 E.01377
G1 X118.908 Y139.041 E.00774
G1 X118.459 Y139.041 E.01443
G1 X118.459 Y138.453 E.0189
G1 X118.624 Y138.426 E.00538
; WIPE_START
G1 X118.801 Y138.825 E-.17641
G1 X118.908 Y139.041 E-.09729
G1 X118.459 Y139.041 E-.18124
G1 X118.459 Y138.453 E-.2375
G1 X118.624 Y138.426 E-.06756
; WIPE_END
G1 E-.04 F1800
G1 X123.55 Y132.595 Z2.8 F30000
G1 X137.948 Y115.552 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X137.948 Y139.448 E.7684
G1 X136.364 Y139.448 E.05094
G1 X136.645 Y139.027 E.01627
G1 X136.822 Y138.669 E.01284
G1 X136.95 Y138.29 E.01285
G1 X137.028 Y137.899 E.01284
G1 X137.052 Y137.534 E.01175
G1 X137.052 Y128.466 E.29162
G1 X137.028 Y128.101 E.01175
G1 X136.95 Y127.71 E.01284
G1 X136.82 Y127.324 E.01308
G1 X136.624 Y126.942 E.01382
G1 X136.423 Y126.641 E.01164
G1 X136.16 Y126.34 E.01285
G1 X135.859 Y126.077 E.01284
G1 X135.527 Y125.855 E.01285
G1 X135.169 Y125.678 E.01285
G1 X134.79 Y125.55 E.01285
G1 X134.399 Y125.472 E.01285
G1 X134 Y125.446 E.01284
G1 X133.639 Y125.469 E.01164
G1 X133.216 Y125.547 E.01381
G1 X132.831 Y125.678 E.01308
G1 X132.473 Y125.855 E.01285
G1 X132.141 Y126.077 E.01285
G1 X131.84 Y126.34 E.01284
G1 X131.577 Y126.641 E.01285
G1 X131.355 Y126.973 E.01284
G1 X131.178 Y127.331 E.01285
G1 X131.05 Y127.71 E.01285
G1 X130.972 Y128.101 E.01284
G1 X130.948 Y128.466 E.01174
G1 X130.948 Y137.534 E.29161
G1 X130.972 Y137.899 E.01175
G1 X131.05 Y138.291 E.01284
G1 X131.178 Y138.669 E.01285
G1 X131.355 Y139.027 E.01285
G1 X131.636 Y139.448 E.01627
G1 X124.364 Y139.448 E.23384
G1 X124.645 Y139.027 E.01627
G1 X124.822 Y138.669 E.01284
G1 X124.95 Y138.29 E.01285
G1 X125.028 Y137.899 E.01284
G1 X125.052 Y137.534 E.01175
G1 X125.052 Y128.466 E.29161
G1 X125.028 Y128.101 E.01175
G1 X124.95 Y127.71 E.01284
G1 X124.82 Y127.324 E.01308
G1 X124.624 Y126.942 E.01381
G1 X124.423 Y126.641 E.01165
G1 X124.16 Y126.34 E.01285
G1 X123.859 Y126.077 E.01284
G1 X123.527 Y125.855 E.01285
G1 X123.169 Y125.678 E.01285
G1 X122.79 Y125.55 E.01285
G1 X122.399 Y125.472 E.01285
G1 X122 Y125.446 E.01284
G1 X121.639 Y125.469 E.01164
G1 X121.216 Y125.547 E.01381
G1 X120.831 Y125.678 E.01308
G1 X120.473 Y125.855 E.01285
G1 X120.141 Y126.077 E.01285
G1 X119.84 Y126.34 E.01284
G1 X119.577 Y126.641 E.01285
G1 X119.355 Y126.973 E.01284
G1 X119.178 Y127.331 E.01285
G1 X119.05 Y127.71 E.01285
G1 X118.972 Y128.101 E.01284
G1 X118.948 Y128.466 E.01174
G1 X118.948 Y137.534 E.29161
G1 X118.972 Y137.899 E.01175
G1 X119.05 Y138.291 E.01284
G1 X119.178 Y138.669 E.01285
G1 X119.355 Y139.027 E.01285
G1 X119.636 Y139.448 E.01627
G1 X118.052 Y139.448 E.05094
G1 X118.052 Y115.552 E.7684
G1 X137.908 Y115.552 E.63849
G1 X138.355 Y115.145 F30000
G1 F3600
G1 X138.355 Y139.855 E.79458
G1 X135.541 Y139.855 E.0905
G1 X135.488 Y139.682 E.00582
G1 X135.611 Y139.599 E.00476
G1 X135.871 Y139.371 E.01113
G1 X136.1 Y139.111 E.01113
G1 X136.292 Y138.823 E.01113
G1 X136.445 Y138.513 E.01113
G1 X136.556 Y138.185 E.01114
G1 X136.624 Y137.846 E.01112
G1 X136.645 Y137.521 E.01046
G1 X136.645 Y128.479 E.29076
G1 X136.624 Y128.154 E.01046
G1 X136.556 Y127.815 E.01112
G1 X136.444 Y127.483 E.01127
G1 X136.273 Y127.148 E.0121
G1 X136.1 Y126.889 E.01002
G1 X135.871 Y126.629 E.01113
G1 X135.611 Y126.401 E.01113
G1 X135.323 Y126.208 E.01113
G1 X135.013 Y126.055 E.01114
G1 X134.685 Y125.944 E.01113
G1 X134.345 Y125.876 E.01113
G1 X134 Y125.854 E.01113
G1 X133.689 Y125.874 E.01002
G1 X133.319 Y125.942 E.01209
G1 X132.987 Y126.055 E.01127
G1 X132.677 Y126.208 E.01113
G1 X132.389 Y126.401 E.01113
G1 X132.129 Y126.629 E.01113
G1 X131.9 Y126.889 E.01113
G1 X131.708 Y127.177 E.01113
G1 X131.555 Y127.487 E.01114
G1 X131.444 Y127.815 E.01113
G1 X131.376 Y128.154 E.01112
G1 X131.355 Y128.479 E.01046
G1 X131.355 Y137.521 E.29076
G1 X131.376 Y137.846 E.01046
G1 X131.444 Y138.185 E.01113
G1 X131.555 Y138.513 E.01113
G1 X131.708 Y138.823 E.01113
G1 X131.9 Y139.111 E.01113
G1 X132.129 Y139.371 E.01114
G1 X132.389 Y139.6 E.01113
G1 X132.512 Y139.682 E.00475
G1 X132.459 Y139.855 E.00582
G1 X123.541 Y139.855 E.2868
G1 X123.488 Y139.682 E.00582
G1 X123.611 Y139.599 E.00476
G1 X123.871 Y139.371 E.01113
G1 X124.1 Y139.111 E.01113
G1 X124.292 Y138.823 E.01113
G1 X124.445 Y138.513 E.01113
G1 X124.556 Y138.185 E.01114
G1 X124.624 Y137.846 E.01112
G1 X124.645 Y137.521 E.01046
G1 X124.645 Y128.479 E.29076
G1 X124.624 Y128.154 E.01046
G1 X124.556 Y127.815 E.01112
G1 X124.444 Y127.483 E.01127
G1 X124.273 Y127.148 E.0121
G1 X124.1 Y126.889 E.01002
G1 X123.871 Y126.629 E.01113
G1 X123.611 Y126.401 E.01113
G1 X123.323 Y126.208 E.01113
G1 X123.013 Y126.055 E.01114
G1 X122.685 Y125.944 E.01113
G1 X122.345 Y125.876 E.01113
G1 X122 Y125.854 E.01113
G1 X121.689 Y125.874 E.01002
G1 X121.319 Y125.942 E.01209
G1 X120.987 Y126.055 E.01127
G1 X120.677 Y126.208 E.01113
G1 X120.389 Y126.401 E.01114
G1 X120.129 Y126.629 E.01113
G1 X119.9 Y126.889 E.01113
G1 X119.708 Y127.177 E.01113
G1 X119.555 Y127.487 E.01114
G1 X119.444 Y127.815 E.01113
G1 X119.376 Y128.154 E.01112
G1 X119.355 Y128.479 E.01046
G1 X119.355 Y137.521 E.29076
G1 X119.376 Y137.846 E.01046
G1 X119.444 Y138.185 E.01113
G1 X119.555 Y138.513 E.01113
G1 X119.708 Y138.823 E.01113
G1 X119.9 Y139.111 E.01113
G1 X120.129 Y139.371 E.01114
G1 X120.389 Y139.6 E.01113
G1 X120.512 Y139.682 E.00475
G1 X120.459 Y139.855 E.00582
G1 X117.645 Y139.855 E.0905
G1 X117.645 Y115.145 E.79458
G1 X138.315 Y115.145 E.66467
M204 S250
G1 X138.79 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
; WIPE_START
M204 S10000
M73 P51 R13
G1 X138.753 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.525 Y124.243 Z2.8 F30000
G1 X137.144 Y126.575 Z2.8
G1 Z2.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.112258
G1 F15000
G1 X137.241 Y126.715 E.00093
; LINE_WIDTH: 0.137438
G1 X137.337 Y126.855 E.00127
G1 X137.18 Y127.813 F30000
; LINE_WIDTH: 0.534804
G1 F4879.202
G1 X137.485 Y128.026 E.01444
G1 X137.487 Y128.058 E.00125
G1 X137.5 Y128.459 E.0156
G1 X137.5 Y137.541 E.35289
G1 X137.485 Y137.975 E.01685
G1 X137.18 Y138.187 E.01446
; WIPE_START
G1 X137.485 Y137.975 E-.14137
G1 X137.5 Y137.541 E-.16482
G1 X137.5 Y136.347 E-.45382
; WIPE_END
G1 E-.04 F1800
G1 X136.038 Y139.527 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.108328
G1 F15000
G1 X135.929 Y139.651 E.00086
G1 X135.308 Y139.839 F30000
; LINE_WIDTH: 0.377226
G1 F7179.06
G1 X134.961 Y139.907 E.00936
; LINE_WIDTH: 0.348901
G1 F7843.636
G1 X134.813 Y139.932 E.00361
; LINE_WIDTH: 0.300222
G1 F9327.575
G1 X134.666 Y139.956 E.00304
; LINE_WIDTH: 0.273887
G1 F10391.104
G1 X134.651 Y139.958 E.00028
; LINE_WIDTH: 0.256269
G1 F11249.179
G1 X134.492 Y139.974 E.00269
; LINE_WIDTH: 0.223966
G1 F13256.336
G1 X134.322 Y139.99 E.00244
; LINE_WIDTH: 0.197585
G1 F15000
G1 X133.667 Y139.989 E.00801
; LINE_WIDTH: 0.224994
G1 F13181.497
G1 X133.508 Y139.974 E.0023
; LINE_WIDTH: 0.257799
G1 F11169.121
G1 X133.334 Y139.956 E.00297
; LINE_WIDTH: 0.293377
G1 F9582.504
G1 X133.228 Y139.939 E.00212
; LINE_WIDTH: 0.32837
G1 F8407.794
G1 X133.122 Y139.921 E.00242
; LINE_WIDTH: 0.379942
G1 F7121.214
G1 X132.692 Y139.839 E.01167
G1 X132.071 Y139.651 F30000
; LINE_WIDTH: 0.108322
G1 F15000
G1 X131.962 Y139.527 E.00085
; WIPE_START
G1 X132.071 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.887 Y138.877 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42215
G1 F3600
G1 X130.325 Y138.44 E.01854
G1 X130.236 Y137.992 E.01367
G1 X129.52 Y138.708 E.03032
G1 X128.984 Y138.708 E.01607
G1 X130.208 Y137.484 E.05184
G1 X130.208 Y136.948 E.01607
G1 X128.448 Y138.708 E.07456
G1 X127.911 Y138.708 E.01607
G1 X130.208 Y136.411 E.09728
G1 X130.208 Y135.875 E.01607
G1 X127.375 Y138.708 E.12
G1 X126.839 Y138.708 E.01607
G1 X130.208 Y135.339 E.14272
G1 X130.208 Y134.802 E.01607
G1 X126.302 Y138.708 E.16544
G1 X125.766 Y138.708 E.01607
G1 X130.208 Y134.266 E.18817
G1 X130.208 Y133.73 E.01607
G1 X125.72 Y138.218 E.19014
G1 X125.764 Y137.996 E.00678
G1 X125.789 Y137.612 E.01151
G1 X130.208 Y133.193 E.1872
G1 X130.208 Y132.657 E.01607
G1 X125.792 Y137.072 E.18705
G1 X125.792 Y136.536 E.01607
G1 X130.208 Y132.121 E.18705
G1 X130.208 Y131.585 E.01607
G1 X125.792 Y136 E.18705
G1 X125.792 Y135.463 E.01607
G1 X130.208 Y131.048 E.18705
G1 X130.208 Y130.512 E.01607
G1 X125.792 Y134.927 E.18705
G1 X125.792 Y134.391 E.01607
G1 X130.208 Y129.976 E.18705
G1 X130.208 Y129.439 E.01607
G1 X125.792 Y133.854 E.18705
G1 X125.792 Y133.318 E.01607
G1 X130.208 Y128.903 E.18705
G1 X130.213 Y128.361 E.01622
G1 X125.792 Y132.782 E.18727
G1 X125.792 Y132.246 E.01607
G1 X130.508 Y127.53 E.19978
; WIPE_START
G1 X129.094 Y128.944 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.256 Y126.306 Z2.8 F30000
G1 X136.735 Y126.13 Z2.8
G1 Z2.4
G1 E.8 F1800
G1 F3600
G1 X137.208 Y125.657 E.02004
G1 X137.208 Y125.121 E.01607
G1 X136.593 Y125.736 E.02604
G1 X136.307 Y125.485 E.01139
G1 X137.208 Y124.585 E.03817
G1 X137.208 Y124.048 E.01607
G1 X135.985 Y125.271 E.05179
G1 X135.636 Y125.083 E.01186
G1 X137.208 Y123.512 E.06657
G1 X137.208 Y122.976 E.01607
G1 X135.257 Y124.926 E.08264
G1 X134.982 Y124.833 E.00868
G1 X134.842 Y124.805 E.0043
G1 X137.208 Y122.439 E.10023
G1 X137.208 Y121.903 E.01607
G1 X134.382 Y124.729 E.11972
G1 X134 Y124.704 E.01146
G1 X133.861 Y124.713 E.00416
G1 X137.208 Y121.367 E.14176
G1 X137.208 Y120.83 E.01607
G1 X133.03 Y125.008 E.17699
G1 X137.377 Y120.124 F30000
G1 F3600
G1 X132.472 Y125.03 E.20782
G1 X132.102 Y125.212 E.01235
G1 X131.689 Y125.488 E.01488
G1 X131.316 Y125.816 E.01486
G1 X130.988 Y126.189 E.01488
G1 X130.712 Y126.602 E.01487
G1 X130.53 Y126.972 E.01235
G1 X125.792 Y131.709 E.20071
G1 X125.792 Y131.173 E.01607
G1 X137.208 Y119.758 E.4836
G1 X137.208 Y119.221 E.01607
G1 X125.792 Y130.637 E.4836
G1 X125.792 Y130.1 E.01607
G1 X137.208 Y118.685 E.4836
G1 X137.208 Y118.149 E.01607
G1 X125.792 Y129.564 E.4836
G1 X125.792 Y129.028 E.01607
G1 X137.208 Y117.612 E.4836
G1 X137.208 Y117.076 E.01607
G1 X125.792 Y128.491 E.4836
G1 X125.76 Y127.987 E.01514
G1 X137.208 Y116.54 E.48496
G1 X137.208 Y116.292 E.00741
G1 X136.919 Y116.292 E.00865
M73 P52 R13
G1 X125.671 Y127.54 E.4765
G1 X125.538 Y127.137 E.01271
G1 X136.382 Y116.292 E.45943
G1 X135.846 Y116.292 E.01607
G1 X125.368 Y126.77 E.4439
G1 X125.173 Y126.43 E.01177
G1 X135.31 Y116.292 E.42946
G1 X134.773 Y116.292 E.01607
G1 X124.949 Y126.117 E.41622
G1 X124.698 Y125.831 E.01138
G1 X134.237 Y116.292 E.40412
G1 X133.701 Y116.292 E.01607
G1 X124.414 Y125.579 E.39342
G1 X124.106 Y125.351 E.01149
G1 X133.165 Y116.292 E.38377
G1 X132.628 Y116.292 E.01607
G1 X123.771 Y125.15 E.37524
G1 X123.407 Y124.977 E.01206
G1 X132.092 Y116.292 E.36793
G1 X131.556 Y116.292 E.01607
G1 X123.007 Y124.841 E.36217
G1 X122.562 Y124.749 E.0136
G1 X131.019 Y116.292 E.35828
G1 X130.483 Y116.292 E.01607
G1 X122.067 Y124.708 E.35653
G1 X121.496 Y124.743 E.01714
G1 X129.947 Y116.292 E.358
G1 X129.41 Y116.292 E.01607
G1 X120.495 Y125.207 E.37769
G1 X118.817 Y126.349 F30000
G1 F3600
G1 X128.874 Y116.292 E.42606
G1 X128.338 Y116.292 E.01607
G1 X118.792 Y125.838 E.40439
G1 X118.792 Y125.301 E.01607
G1 X127.801 Y116.292 E.38167
G1 X127.265 Y116.292 E.01607
G1 X118.792 Y124.765 E.35895
G1 X118.792 Y124.229 E.01607
G1 X126.729 Y116.292 E.33622
G1 X126.192 Y116.292 E.01607
G1 X118.792 Y123.692 E.3135
G1 X118.792 Y123.156 E.01607
G1 X125.656 Y116.292 E.29078
G1 X125.12 Y116.292 E.01607
G1 X118.792 Y122.62 E.26806
G1 X118.792 Y122.084 E.01607
G1 X124.584 Y116.292 E.24534
G1 X124.047 Y116.292 E.01607
G1 X118.792 Y121.547 E.22262
G1 X118.792 Y121.011 E.01607
G1 X123.511 Y116.292 E.1999
G1 X122.975 Y116.292 E.01607
G1 X118.792 Y120.475 E.17718
G1 X118.792 Y119.938 E.01607
G1 X122.438 Y116.292 E.15446
G1 X121.902 Y116.292 E.01607
G1 X118.792 Y119.402 E.13174
G1 X118.792 Y118.866 E.01607
G1 X121.366 Y116.292 E.10902
G1 X120.829 Y116.292 E.01607
G1 X118.792 Y118.329 E.0863
G1 X118.792 Y117.793 E.01607
G1 X120.293 Y116.292 E.06358
G1 X119.757 Y116.292 E.01607
G1 X118.792 Y117.257 E.04085
G1 X118.792 Y116.72 E.01607
G1 X119.39 Y116.123 E.02532
G1 X118.856 Y126.575 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.124419
G1 F15000
G1 X118.663 Y126.854 E.00218
G1 X118.82 Y127.813 F30000
; LINE_WIDTH: 0.534808
G1 F4879.168
G1 X118.515 Y128.026 E.01446
G1 X118.5 Y128.459 E.01685
G1 X118.5 Y137.541 E.35289
G1 X118.513 Y137.942 E.0156
G1 X118.515 Y137.975 E.00126
G1 X118.82 Y138.187 E.01444
; WIPE_START
G1 X118.515 Y137.975 E-.14117
G1 X118.513 Y137.942 E-.01231
G1 X118.5 Y137.541 E-.15255
G1 X118.5 Y136.346 E-.45397
; WIPE_END
G1 E-.04 F1800
G1 X119.962 Y139.527 Z2.8 F30000
G1 Z2.4
G1 E.8 F1800
; LINE_WIDTH: 0.108322
G1 F15000
G1 X120.071 Y139.651 E.00085
G1 X120.692 Y139.839 F30000
; LINE_WIDTH: 0.379941
G1 F7121.225
G1 X121.122 Y139.921 E.01167
; LINE_WIDTH: 0.32837
G1 F8407.794
G1 X121.228 Y139.939 E.00242
; LINE_WIDTH: 0.293377
G1 F9582.504
G1 X121.334 Y139.956 E.00212
; LINE_WIDTH: 0.257798
G1 F11169.125
G1 X121.508 Y139.974 E.00297
; LINE_WIDTH: 0.224994
G1 F13181.497
G1 X121.667 Y139.989 E.0023
; LINE_WIDTH: 0.197585
G1 F15000
G1 X122.322 Y139.99 E.00801
; LINE_WIDTH: 0.223966
G1 F13256.332
G1 X122.492 Y139.974 E.00244
; LINE_WIDTH: 0.256269
G1 F11249.179
G1 X122.651 Y139.958 E.00269
; LINE_WIDTH: 0.273887
G1 F10391.104
G1 X122.666 Y139.956 E.00028
; LINE_WIDTH: 0.300222
G1 F9327.575
G1 X122.813 Y139.932 E.00304
; LINE_WIDTH: 0.348901
G1 F7843.636
G1 X122.961 Y139.907 E.00361
; LINE_WIDTH: 0.377226
G1 F7179.06
G1 X123.308 Y139.839 E.00936
G1 X123.929 Y139.651 F30000
; LINE_WIDTH: 0.108328
G1 F15000
G1 X124.038 Y139.527 E.00086
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X123.929 Y139.651 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 20/152
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
M106 S51
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
G1 X125.123 Y111.803
G1 Z2.6
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
G1 F3000
G1 X125.123 Y113.911 E.0628
G1 X119.369 Y113.911 E.1714
G1 X119.369 Y111.615 E.06841
G1 X125.123 Y111.615 E.1714
G1 X125.123 Y108.738 E.0857
G1 X119.369 Y108.738 E.1714
; WIPE_START
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z3
G1 Z2.6
G1 E.8 F1800
G1 F3000
G1 X136.631 Y108.738 E.1714
G1 X136.631 Y111.615 E.0857
G1 X130.877 Y111.615 E.1714
G1 X130.877 Y113.911 E.06841
G1 X136.631 Y113.911 E.1714
G1 X136.631 Y111.803 E.0628
; WIPE_START
G1 X136.631 Y113.803 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3 I-.762 J-.949 P1  F30000
G1 X122.134 Y125.454 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X122 Y125.446 E.00431
G1 X121.614 Y125.471 E.01244
G1 X121.166 Y125.558 E.01467
G1 X121.166 Y115.552 E.32175
G1 X122.134 Y115.552 E.03111
G1 X122.134 Y125.414 E.31714
G1 X122.541 Y125.915 F30000
G1 F3600
G1 X122.345 Y125.876 E.00641
G1 X122 Y125.854 E.01113
G1 X121.666 Y125.875 E.01076
G1 X121.317 Y125.943 E.01145
G1 X120.987 Y126.055 E.01118
G1 X120.759 Y126.167 E.00818
G1 X120.759 Y115.145 E.35444
G1 X122.541 Y115.145 E.05729
G1 X122.541 Y125.875 E.34504
; WIPE_START
G1 X122.345 Y125.876 E-.07425
G1 X122 Y125.854 E-.13151
G1 X121.666 Y125.875 E-.12712
G1 X121.317 Y125.943 E-.13534
G1 X120.987 Y126.055 E-.13217
G1 X120.759 Y126.167 E-.09662
G1 X120.759 Y126.002 E-.06299
; WIPE_END
G1 E-.04 F1800
G1 X123.72 Y127.116 Z3 F30000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X123.754 Y127.154 E.00151
G1 X123.914 Y127.395 E.00861
G1 X124.042 Y127.654 E.00861
G1 X124.135 Y127.928 E.00862
G1 X124.192 Y128.211 E.00861
G1 X124.21 Y128.493 E.00841
G1 X124.21 Y137.507 E.26848
G1 X124.192 Y137.789 E.00841
G1 X124.135 Y138.072 E.00861
G1 X124.042 Y138.346 E.00861
G1 X123.914 Y138.605 E.00861
G1 X123.754 Y138.846 E.00861
G1 X123.563 Y139.063 E.00861
G1 X123.346 Y139.254 E.00861
G1 X123.105 Y139.414 E.00861
G1 X122.846 Y139.542 E.00861
G1 X122.572 Y139.635 E.00861
G1 X122.289 Y139.692 E.00861
G1 X122 Y139.71 E.00861
G1 X121.711 Y139.692 E.00861
G1 X121.428 Y139.635 E.00861
G1 X121.154 Y139.542 E.00861
G1 X120.895 Y139.414 E.00861
G1 X120.654 Y139.254 E.00861
G1 X120.437 Y139.063 E.00861
G1 X120.246 Y138.846 E.00861
G1 X120.086 Y138.605 E.00861
G1 X119.958 Y138.346 E.00861
G1 X119.865 Y138.072 E.00861
G1 X119.808 Y137.789 E.00861
G1 X119.79 Y137.507 E.00841
G1 X119.79 Y128.493 E.26848
G1 X119.808 Y128.211 E.00841
G1 X119.865 Y127.928 E.00861
G1 X119.958 Y127.654 E.00862
G1 X120.086 Y127.395 E.00861
G1 X120.246 Y127.154 E.00861
G1 X120.437 Y126.937 E.00861
G1 X120.654 Y126.746 E.00861
G1 X120.895 Y126.586 E.00861
G1 X121.154 Y126.458 E.00861
G1 X121.428 Y126.365 E.00863
G1 X121.722 Y126.308 E.00891
G1 X122 Y126.29 E.0083
G1 X122.289 Y126.308 E.00861
G1 X122.572 Y126.365 E.00861
G1 X122.846 Y126.458 E.00863
G1 X123.114 Y126.592 E.00891
G1 X123.346 Y126.746 E.0083
G1 X123.563 Y126.937 E.00861
G1 X123.694 Y127.086 E.00591
; WIPE_START
M204 S10000
G1 X123.754 Y127.154 E-.03449
G1 X123.914 Y127.395 E-.10986
G1 X124.042 Y127.654 E-.10988
G1 X124.135 Y127.928 E-.10992
G1 X124.192 Y128.211 E-.1098
G1 X124.21 Y128.493 E-.10731
G1 X124.21 Y128.964 E-.17873
; WIPE_END
G1 E-.04 F1800
G1 X131.559 Y126.904 Z3 F30000
G1 X133.156 Y126.457 Z3
G1 Z2.6
G1 E.8 F1800
G1 F2400
M204 S5000
G1 X133.428 Y126.365 E.00857
G1 X133.722 Y126.308 E.00891
G1 X134 Y126.29 E.0083
G1 X134.289 Y126.308 E.00861
G1 X134.572 Y126.365 E.00861
G1 X134.846 Y126.458 E.00863
G1 X135.114 Y126.592 E.00891
G1 X135.346 Y126.746 E.0083
G1 X135.563 Y126.937 E.00861
G1 X135.754 Y127.154 E.00861
G1 X135.914 Y127.395 E.00861
G1 X136.042 Y127.654 E.00861
G1 X136.135 Y127.928 E.00862
G1 X136.192 Y128.211 E.00861
G1 X136.21 Y128.493 E.00841
G1 X136.21 Y137.507 E.26848
G1 X136.192 Y137.789 E.00841
G1 X136.135 Y138.072 E.00861
G1 X136.042 Y138.346 E.00861
G1 X135.914 Y138.605 E.00861
G1 X135.754 Y138.846 E.00861
G1 X135.563 Y139.063 E.00861
G1 X135.346 Y139.254 E.00861
G1 X135.105 Y139.414 E.00861
G1 X134.846 Y139.542 E.00861
G1 X134.572 Y139.635 E.00861
G1 X134.289 Y139.692 E.00861
G1 X134 Y139.71 E.00861
G1 X133.711 Y139.692 E.00861
G1 X133.428 Y139.635 E.00861
G1 X133.154 Y139.542 E.00861
G1 X132.895 Y139.414 E.00861
G1 X132.654 Y139.254 E.00861
G1 X132.437 Y139.063 E.00861
G1 X132.246 Y138.846 E.00861
G1 X132.086 Y138.605 E.00861
G1 X131.958 Y138.346 E.00861
G1 X131.865 Y138.072 E.00861
G1 X131.808 Y137.789 E.00861
G1 X131.79 Y137.507 E.00841
G1 X131.79 Y128.493 E.26848
G1 X131.808 Y128.211 E.00841
G1 X131.865 Y127.928 E.00861
G1 X131.958 Y127.654 E.00862
G1 X132.086 Y127.395 E.00861
G1 X132.246 Y127.154 E.00861
G1 X132.437 Y126.937 E.00861
G1 X132.654 Y126.746 E.00861
G1 X132.895 Y126.586 E.00861
G1 X133.12 Y126.475 E.00747
; WIPE_START
M204 S10000
G1 X133.428 Y126.365 E-.12448
G1 X133.722 Y126.308 E-.11366
G1 X134 Y126.29 E-.10587
G1 X134.289 Y126.308 E-.10986
G1 X134.572 Y126.365 E-.10984
G1 X134.846 Y126.458 E-.1101
G1 X135.049 Y126.559 E-.08618
; WIPE_END
G1 E-.04 F1800
G1 X133.866 Y125.454 Z3 F30000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3600
G1 X133.866 Y115.552 E.31843
G1 X134.834 Y115.552 E.03111
G1 X134.834 Y125.558 E.32176
G1 X134.399 Y125.472 E.01427
G1 X134 Y125.446 E.01284
G1 X133.906 Y125.452 E.00303
G1 X133.459 Y125.916 F30000
G1 F3600
G1 X133.459 Y115.145 E.34634
G1 X135.241 Y115.145 E.05729
G1 X135.241 Y126.169 E.35448
G1 X135.014 Y126.056 E.00814
G1 X134.685 Y125.944 E.01118
G1 X134.345 Y125.876 E.01113
G1 X134 Y125.854 E.01113
G1 X133.666 Y125.875 E.01076
G1 X133.498 Y125.908 E.0055
; WIPE_START
G1 X133.491 Y123.908 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X137.301 Y117.294 Z3 F30000
G1 X138.79 Y114.71 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2400
M204 S5000
G1 X138.79 Y140.29 E.76194
G1 X117.21 Y140.29 E.6428
G1 X117.21 Y114.71 E.76194
G1 X138.75 Y114.71 E.6416
M204 S10000
G1 X137.981 Y114.917 F30000
; FEATURE: Top surface
G1 F2400
M204 S2000
G1 X138.583 Y115.519 E.02534
G1 X138.583 Y116.052
G1 X137.448 Y114.917 E.04781
G1 X136.914 Y114.917
G1 X138.583 Y116.586 E.07027
G1 X138.583 Y117.119
G1 X136.381 Y114.917 E.09273
G1 X135.848 Y114.917
G1 X138.583 Y117.652 E.1152
G1 X138.583 Y118.185
G1 X135.506 Y115.109 E.12959
G1 X135.506 Y115.642
G1 X138.583 Y118.719 E.12959
G1 X138.583 Y119.252
G1 X135.506 Y116.175 E.12959
G1 X135.506 Y116.709
G1 X138.583 Y119.785 E.12959
G1 X138.583 Y120.318
G1 X135.506 Y117.242 E.12959
G1 X135.506 Y117.775
G1 X138.583 Y120.852 E.12959
G1 X138.583 Y121.385
G1 X135.506 Y118.308 E.12959
G1 X135.506 Y118.842
G1 X138.583 Y121.918 E.12959
G1 X138.583 Y122.451
G1 X135.506 Y119.375 E.12959
G1 X135.506 Y119.908
G1 X138.583 Y122.985 E.12959
G1 X138.583 Y123.518
G1 X135.506 Y120.441 E.12959
G1 X135.506 Y120.975
G1 X138.583 Y124.051 E.12959
G1 X138.583 Y124.584
G1 X135.506 Y121.508 E.12959
G1 X135.506 Y122.041
G1 X138.583 Y125.118 E.12959
G1 X138.583 Y125.651
G1 X135.506 Y122.575 E.12959
G1 X135.506 Y123.108
G1 X138.583 Y126.184 E.12959
G1 X138.583 Y126.717
G1 X135.506 Y123.641 E.12959
G1 X135.506 Y124.174
G1 X138.583 Y127.251 E.12959
G1 X138.583 Y127.784
G1 X135.506 Y124.708 E.12959
G1 X135.506 Y125.241
G1 X138.583 Y128.317 E.12959
G1 X138.583 Y128.85
G1 X135.506 Y125.774 E.12959
G1 X135.506 Y126.307
G1 X138.583 Y129.384 E.12959
G1 X138.583 Y129.917
G1 X136.228 Y127.563 E.09917
G1 X136.403 Y128.271
G1 X138.583 Y130.45 E.0918
G1 X138.583 Y130.983
G1 X136.417 Y128.818 E.09121
G1 X136.417 Y129.351
G1 X138.583 Y131.517 E.09121
G1 X138.583 Y132.05
G1 X136.417 Y129.885 E.09121
G1 X136.417 Y130.418
G1 X138.583 Y132.583 E.09121
G1 X138.583 Y133.117
G1 X136.417 Y130.951 E.09121
G1 X136.417 Y131.485
G1 X138.583 Y133.65 E.09121
G1 X138.583 Y134.183
G1 X136.417 Y132.018 E.09121
G1 X136.417 Y132.551
G1 X138.583 Y134.716 E.09121
G1 X138.583 Y135.25
G1 X136.417 Y133.084 E.09121
G1 X136.417 Y133.618
G1 X138.583 Y135.783 E.09121
G1 X138.583 Y136.316
G1 X136.417 Y134.151 E.09121
M73 P53 R13
G1 X136.417 Y134.684
G1 X138.583 Y136.849 E.09121
G1 X138.583 Y137.383
G1 X136.417 Y135.217 E.09121
G1 X136.417 Y135.751
G1 X138.583 Y137.916 E.09121
G1 X138.583 Y138.449
G1 X136.417 Y136.284 E.09121
G1 X136.417 Y136.817
G1 X138.583 Y138.982 E.09121
G1 X138.583 Y139.516
G1 X136.417 Y137.35 E.09121
G1 X136.39 Y137.856
G1 X138.583 Y140.049 E.09238
G1 X138.083 Y140.083
G1 X136.283 Y138.282 E.07584
G1 X136.121 Y138.654
G1 X137.55 Y140.083 E.06017
G1 X137.017 Y140.083
G1 X135.913 Y138.979 E.0465
G1 X135.657 Y139.256
G1 X136.483 Y140.083 E.03481
G1 X135.95 Y140.083
G1 X135.361 Y139.493 E.02483
G1 X135.021 Y139.687
G1 X135.417 Y140.083 E.01667
; WIPE_START
M204 S10000
G1 X135.021 Y139.687 E-.21262
G1 X135.361 Y139.493 E-.14852
G1 X135.95 Y140.083 E-.31682
G1 X136.166 Y140.083 E-.08204
; WIPE_END
G1 E-.04 F1800
G1 X136.241 Y132.451 Z3 F30000
G1 X136.29 Y127.501 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.201445
G1 F15000
G1 X136.209 Y127.388 E.00174
; LINE_WIDTH: 0.169747
G1 X136.124 Y127.27 E.00146
; LINE_WIDTH: 0.137766
G1 X136.024 Y127.148 E.00118
; LINE_WIDTH: 0.101617
G1 X135.876 Y126.975 E.00105
; WIPE_START
G1 X136.024 Y127.148 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.353 Y134.751 Z3 F30000
G1 X134.915 Y139.718 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.154136
G1 F15000
G1 X134.862 Y139.78 E.00072
; LINE_WIDTH: 0.190314
G1 X134.808 Y139.842 E.00096
; LINE_WIDTH: 0.216735
G1 F13807.788
G1 X134.902 Y140.101 E.00379
; WIPE_START
G1 X134.808 Y139.842 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.118 Y132.215 Z3 F30000
G1 X135.822 Y114.944 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.13312
G1 F15000
G1 X135.487 Y114.944 E.00238
; WIPE_START
G1 X135.822 Y114.944 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.744 Y122.5 Z3 F30000
G1 X134.35 Y125.265 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.60333
G1 F4282.579
G1 X134.35 Y115.756 E.42095
; WIPE_START
G1 X134.35 Y117.756 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.194 Y115.463 Z3 F30000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F2400
M204 S2000
G1 X132.648 Y114.917 E.02297
G1 X132.115 Y114.917
G1 X133.194 Y115.996 E.04544
G1 X133.194 Y116.529
G1 X131.582 Y114.917 E.0679
G1 X131.049 Y114.917
G1 X133.194 Y117.062 E.09036
G1 X133.194 Y117.596
G1 X130.515 Y114.917 E.11283
G1 X129.982 Y114.917
G1 X133.194 Y118.129 E.13529
G1 X133.194 Y118.662
G1 X129.449 Y114.917 E.15775
G1 X128.916 Y114.917
G1 X133.194 Y119.196 E.18022
G1 X133.194 Y119.729
G1 X128.382 Y114.917 E.20268
G1 X127.849 Y114.917
G1 X133.194 Y120.262 E.22514
G1 X133.194 Y120.795
G1 X127.316 Y114.917 E.24761
G1 X126.783 Y114.917
G1 X133.194 Y121.329 E.27007
G1 X133.194 Y121.862
G1 X126.249 Y114.917 E.29253
G1 X125.716 Y114.917
G1 X133.194 Y122.395 E.315
G1 X133.194 Y122.928
G1 X125.183 Y114.917 E.33746
G1 X124.65 Y114.917
G1 X133.194 Y123.462 E.35992
G1 X133.194 Y123.995
G1 X124.116 Y114.917 E.38239
G1 X123.583 Y114.917
G1 X133.194 Y124.528 E.40485
G1 X133.194 Y125.061
G1 X123.05 Y114.917 E.42731
G1 X122.806 Y115.207
G1 X133.194 Y125.595 E.43757
G1 X133.194 Y126.128
G1 X122.806 Y115.74 E.43757
G1 X122.806 Y116.274
G1 X132.89 Y126.357 E.42476
G1 X132.56 Y126.56
G1 X122.806 Y116.807 E.41086
G1 X122.806 Y117.34
G1 X132.274 Y126.808 E.39883
G1 X132.033 Y127.1
G1 X122.806 Y117.873 E.38868
G1 X122.806 Y118.407
G1 X131.835 Y127.435 E.38032
G1 X131.683 Y127.817
G1 X122.806 Y118.94 E.37395
G1 X122.806 Y119.473
G1 X131.597 Y128.264 E.37031
G1 X131.583 Y128.783
G1 X122.806 Y120.006 E.3697
G1 X122.806 Y120.54
G1 X131.583 Y129.316 E.3697
G1 X131.583 Y129.849
G1 X122.806 Y121.073 E.3697
G1 X122.806 Y121.606
G1 X131.583 Y130.383 E.3697
G1 X131.583 Y130.916
G1 X122.806 Y122.139 E.3697
G1 X122.806 Y122.673
G1 X131.583 Y131.449 E.3697
G1 X131.583 Y131.982
G1 X122.806 Y123.206 E.3697
G1 X122.806 Y123.739
G1 X131.583 Y132.516 E.3697
G1 X131.583 Y133.049
G1 X122.806 Y124.272 E.3697
G1 X122.806 Y124.806
G1 X131.583 Y133.582 E.3697
G1 X131.583 Y134.115
G1 X122.806 Y125.339 E.3697
G1 X122.806 Y125.872
G1 X131.583 Y134.649 E.3697
G1 X131.583 Y135.182
G1 X124.351 Y127.95 E.30463
G1 X124.417 Y128.55
G1 X131.583 Y135.715 E.30183
G1 X131.583 Y136.248
G1 X124.417 Y129.083 E.30183
G1 X124.417 Y129.616
G1 X131.583 Y136.782 E.30183
G1 X131.583 Y137.315
G1 X124.417 Y130.15 E.30183
G1 X124.417 Y130.683
G1 X131.615 Y137.881 E.30321
G1 X131.901 Y138.7
G1 X124.417 Y131.216 E.31525
G1 X124.417 Y131.749
G1 X132.751 Y140.083 E.35103
G1 X132.217 Y140.083
G1 X124.417 Y132.283 E.32857
G1 X124.417 Y132.816
G1 X131.684 Y140.083 E.3061
G1 X131.151 Y140.083
G1 X124.417 Y133.349 E.28364
G1 X124.417 Y133.882
G1 X130.618 Y140.083 E.26118
G1 X130.084 Y140.083
G1 X124.417 Y134.416 E.23871
G1 X124.417 Y134.949
G1 X129.551 Y140.083 E.21625
G1 X129.018 Y140.083
G1 X124.417 Y135.482 E.19379
G1 X124.417 Y136.016
G1 X128.484 Y140.083 E.17133
G1 X127.951 Y140.083
G1 X124.417 Y136.549 E.14886
G1 X124.417 Y137.082
G1 X127.418 Y140.083 E.1264
G1 X126.885 Y140.083
G1 X124.411 Y137.609 E.1042
G1 X124.346 Y138.077
G1 X126.351 Y140.083 E.08449
G1 X125.818 Y140.083
G1 X124.21 Y138.474 E.06774
G1 X124.021 Y138.819
G1 X125.285 Y140.083 E.05324
G1 X124.752 Y140.083
G1 X123.789 Y139.12 E.04055
G1 X123.516 Y139.38
G1 X124.218 Y140.083 E.02959
G1 X123.685 Y140.083
G1 X123.201 Y139.598 E.0204
G1 X122.834 Y139.765
G1 X123.152 Y140.083 E.01337
; WIPE_START
M204 S10000
G1 X122.834 Y139.765 E-.17062
G1 X123.201 Y139.598 E-.153
G1 X123.685 Y140.083 E-.26027
G1 X124.149 Y140.083 E-.17611
; WIPE_END
G1 E-.04 F1800
G1 X128.148 Y133.582 Z3 F30000
G1 X131.673 Y127.852 Z3
G1 Z2.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0889717
G1 F15000
G1 X131.591 Y127.992 E.00059
; WIPE_START
G1 X131.673 Y127.852 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.619 Y135.485 Z3 F30000
G1 X131.605 Y137.603 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.114473
G1 F15000
G1 X131.511 Y137.387 E.00133
; WIPE_START
G1 X131.605 Y137.603 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.069 Y139.912 Z3 F30000
M73 P54 R13
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.39623
G1 F6792.904
G1 X133.029 Y139.872 E.00159
; LINE_WIDTH: 0.357877
G1 F7620.09
G1 X132.991 Y139.842 E.0012
; LINE_WIDTH: 0.323213
G1 F8562.473
G1 X132.873 Y139.757 E.00323
; LINE_WIDTH: 0.275687
G1 F10310.754
G1 X132.754 Y139.672 E.00268
; LINE_WIDTH: 0.250158
G1 F11580.881
G1 X132.743 Y139.663 E.00022
; LINE_WIDTH: 0.232904
G1 F12632.695
G1 X132.621 Y139.563 E.00237
; LINE_WIDTH: 0.201052
G1 F15000
G1 X132.492 Y139.457 E.00209
; LINE_WIDTH: 0.175018
G1 X132.037 Y139 E.00673
; LINE_WIDTH: 0.207691
G1 F14565.732
G1 X131.84 Y138.761 E.00403
; WIPE_START
G1 X132.037 Y139 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.755 Y132.682 Z3 F30000
G1 X124.401 Y127.733 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.141773
G1 F15000
G1 X124.34 Y127.962 E.00184
; WIPE_START
G1 X124.401 Y127.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X121.65 Y125.265 Z3 F30000
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.60333
G1 F4282.579
G1 X121.65 Y115.756 E.42095
; WIPE_START
G1 X121.65 Y117.756 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X120.494 Y115.561 Z3 F30000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F2400
M204 S2000
G1 X119.85 Y114.917 E.02711
G1 X119.317 Y114.917
G1 X120.494 Y116.094 E.04957
G1 X120.494 Y116.627
G1 X118.784 Y114.917 E.07204
G1 X118.25 Y114.917
G1 X120.494 Y117.161 E.0945
G1 X120.494 Y117.694
G1 X117.717 Y114.917 E.11696
G1 X117.417 Y115.151
G1 X120.494 Y118.227 E.12959
G1 X120.494 Y118.76
G1 X117.417 Y115.684 E.12959
G1 X117.417 Y116.217
G1 X120.494 Y119.294 E.12959
G1 X120.494 Y119.827
G1 X117.417 Y116.751 E.12959
G1 X117.417 Y117.284
G1 X120.494 Y120.36 E.12959
G1 X120.494 Y120.893
G1 X117.417 Y117.817 E.12959
G1 X117.417 Y118.35
G1 X120.494 Y121.427 E.12959
G1 X120.494 Y121.96
G1 X117.417 Y118.884 E.12959
G1 X117.417 Y119.417
G1 X120.494 Y122.493 E.12959
G1 X120.494 Y123.027
G1 X117.417 Y119.95 E.12959
G1 X117.417 Y120.483
G1 X120.494 Y123.56 E.12959
G1 X120.494 Y124.093
G1 X117.417 Y121.017 E.12959
G1 X117.417 Y121.55
G1 X120.494 Y124.626 E.12959
G1 X120.494 Y125.16
G1 X117.417 Y122.083 E.12959
G1 X117.417 Y122.616
G1 X120.494 Y125.693 E.12959
G1 X120.494 Y126.226
G1 X117.417 Y123.15 E.12959
G1 X117.417 Y123.683
G1 X120.415 Y126.68 E.12627
G1 X120.15 Y126.949
G1 X117.417 Y124.216 E.11513
G1 X117.417 Y124.749
G1 X119.927 Y127.259 E.10572
G1 X119.751 Y127.617
G1 X117.417 Y125.283 E.09832
G1 X117.417 Y125.816
G1 X119.633 Y128.031 E.09332
G1 X119.583 Y128.514
G1 X117.417 Y126.349 E.09121
G1 X117.417 Y126.882
G1 X119.583 Y129.048 E.09121
G1 X119.583 Y129.581
G1 X117.417 Y127.416 E.09121
G1 X117.417 Y127.949
G1 X119.583 Y130.114 E.09121
G1 X119.583 Y130.647
G1 X117.417 Y128.482 E.09121
G1 X117.417 Y129.016
G1 X119.583 Y131.181 E.09121
G1 X119.583 Y131.714
G1 X117.417 Y129.549 E.09121
G1 X117.417 Y130.082
G1 X119.583 Y132.247 E.09121
G1 X119.583 Y132.781
G1 X117.417 Y130.615 E.09121
G1 X117.417 Y131.149
G1 X119.583 Y133.314 E.09121
G1 X119.583 Y133.847
G1 X117.417 Y131.682 E.09121
G1 X117.417 Y132.215
G1 X119.583 Y134.38 E.09121
G1 X119.583 Y134.914
G1 X117.417 Y132.748 E.09121
G1 X117.417 Y133.282
G1 X119.583 Y135.447 E.09121
G1 X119.583 Y135.98
G1 X117.417 Y133.815 E.09121
G1 X117.417 Y134.348
G1 X119.583 Y136.513 E.09121
G1 X119.583 Y137.047
G1 X117.417 Y134.881 E.09121
G1 X117.417 Y135.415
G1 X119.587 Y137.584 E.09141
G1 X119.699 Y138.23
G1 X117.417 Y135.948 E.09613
G1 X117.417 Y136.481
G1 X121.019 Y140.083 E.15171
G1 X120.486 Y140.083
G1 X117.417 Y137.014 E.12925
G1 X117.417 Y137.548
G1 X119.952 Y140.083 E.10679
G1 X119.419 Y140.083
G1 X117.417 Y138.081 E.08432
G1 X117.417 Y138.614
G1 X118.886 Y140.083 E.06186
G1 X118.353 Y140.083
G1 X117.417 Y139.147 E.0394
G1 X117.417 Y139.681
G1 X117.819 Y140.083 E.01693
; WIPE_START
M204 S10000
G1 X117.417 Y139.681 E-.21601
G1 X117.417 Y139.147 E-.20264
G1 X118.053 Y139.783 E-.34135
; WIPE_END
G1 E-.04 F1800
G1 X119.873 Y138.643 Z3 F30000
G1 Z2.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.106272
G1 F15000
G1 X119.802 Y138.544 E.00061
; LINE_WIDTH: 0.154104
G1 X119.632 Y138.297 E.00263
; WIPE_START
G1 X119.802 Y138.544 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X121.265 Y139.909 Z3 F30000
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.162076
G1 F15000
G1 X121.056 Y139.769 E.00237
; LINE_WIDTH: 0.142431
G1 X120.956 Y139.698 E.00096
; LINE_WIDTH: 0.106253
G1 X120.857 Y139.627 E.00061
G1 X121.209 Y139.76 F30000
; LINE_WIDTH: 0.168549
G1 F15000
G1 X121.193 Y139.99 E.00229
G1 X121.136 Y140.101 E.00124
G1 X121.288 Y139.948 F30000
; LINE_WIDTH: 0.253462
G1 F11399.191
G1 X121.476 Y139.968 E.00315
; LINE_WIDTH: 0.224327
G1 F13229.914
G1 X121.665 Y139.989 E.00272
; LINE_WIDTH: 0.197631
G1 F15000
G1 X122.322 Y139.99 E.00803
; LINE_WIDTH: 0.223337
G1 F13302.513
G1 X122.524 Y139.968 E.00288
; LINE_WIDTH: 0.253451
G1 F11399.747
G1 X122.712 Y139.948 E.00315
; WIPE_START
G1 X122.524 Y139.968 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X130.156 Y139.954 Z3 F30000
G1 X133.288 Y139.948 Z3
G1 Z2.6
G1 E.8 F1800
; LINE_WIDTH: 0.253462
G1 F11399.191
G1 X133.476 Y139.968 E.00315
; LINE_WIDTH: 0.224327
G1 F13229.914
G1 X133.665 Y139.989 E.00272
; LINE_WIDTH: 0.197631
G1 F15000
G1 X134.322 Y139.99 E.00803
; LINE_WIDTH: 0.223337
G1 F13302.518
G1 X134.524 Y139.968 E.00288
; LINE_WIDTH: 0.253451
G1 F11399.747
G1 X134.712 Y139.948 E.00315
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F11399.747
G1 X134.524 Y139.968 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 21/152
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
M106 S150.45
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
G1 X136.631 Y111.803
G1 Z2.8
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
G1 F2041
G1 X136.631 Y113.911 E.0628
G1 X131.606 Y113.911 E.14968
G1 X131.406 Y114.111 E.00842
G1 X130.877 Y114.111 E.01576
G1 X130.877 Y111.615 E.07437
G1 X136.631 Y111.615 E.1714
G1 X136.631 Y108.738 E.0857
G1 X130.877 Y108.738 E.1714
; WIPE_START
G1 F3000
G1 X132.877 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.2 I-.447 J-1.132 P1  F30000
G1 X125.123 Y111.803 Z3.2
G1 Z2.8
G1 E.8 F1800
G1 F2041
G1 X125.123 Y114.111 E.06876
G1 X124.594 Y114.111 E.01576
G1 X124.394 Y113.911 E.00842
G1 X119.369 Y113.911 E.14968
G1 X119.369 Y111.615 E.06841
G1 X125.123 Y111.615 E.1714
G1 X125.123 Y108.738 E.0857
G1 X119.369 Y108.738 E.1714
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.2 I-.63 J1.041 P1  F30000
G1 X133.309 Y115.959 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2041
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y126.309 E.33282
G1 X133.309 Y126.309 E.06694
G1 X133.309 Y115.999 E.33154
G1 X132.902 Y115.552 F30000
G1 F2041
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y126.716 E.359
G1 X135.251 Y126.716 E.01758
M106 S153
G1 F1080
G1 X134.238 Y126.716 E.03259
M106 S150.45
; FEATURE: Overhang wall
M106 S153
G1 F1500
M204 S5000
G1 X133.769 Y126.716 E.01508
M106 S150.45
; FEATURE: Inner wall
M106 S153
G1 F840
M204 S10000
G1 X132.902 Y126.716 E.02786
M106 S150.45
M106 S153
G1 F1302.167
G1 X132.902 Y126.614 E.0033
M106 S150.45
G1 F2041
G1 X132.902 Y126.214 E.01286
G1 X132.902 Y115.592 E.34156
G1 X132.495 Y115.145 F30000
G1 F2041
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y127.123 E.38518
G1 X135.69 Y127.123 E.01656
M106 S153
G1 F1680
G1 X135.154 Y127.123 E.01724
M106 S150.45
; FEATURE: Overhang wall
M106 S153
G1 F1500
M204 S5000
G1 X132.846 Y127.123 E.0742
M106 S150.45
; FEATURE: Inner wall
M106 S153
G1 F960
M204 S10000
G1 X132.495 Y127.123 E.01129
M106 S150.45
M106 S153
G1 F2015.437
G1 X132.495 Y126.923 E.00646
M106 S150.45
G1 F2041
G1 X132.495 Y126.523 E.01286
G1 X132.495 Y115.185 E.36458
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2041
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y127.558 E.38271
G1 X135.949 Y127.558 E.02057
M106 S153
G1 F1800
G1 X135.531 Y127.558 E.01247
M106 S150.45
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
M106 S153
G1 F1500
G1 X132.469 Y127.558 E.09843
M106 S150.45
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S153
G1 F1800
G1 X132.06 Y127.558 E.0122
M106 S150.45
G1 F2041
G1 X132.06 Y127.54 E.00056
G1 X132.06 Y114.75 E.38096
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.815 Y122.361 Z3.2 F30000
M73 P55 R13
G1 X133.701 Y125.917 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2041
G1 X134.999 Y125.917 E.03865
G1 X134.999 Y116.351 E.28493
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y125.857 E.28314
G1 X134.12 Y125.499 F30000
; LINE_WIDTH: 0.50318
G1 F2041
G1 X134.58 Y125.499 E.01673
G1 X134.58 Y116.77 E.31735
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y125.439 E.31517
; WIPE_START
G1 F3600
G1 X134.12 Y123.439 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y125.298 Z3.2 F30000
G1 X122.691 Y126.309 Z3.2
G1 Z2.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2041
G1 X120.609 Y126.309 E.06694
G1 X120.609 Y115.959 E.33282
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y126.269 E.33154
G1 X123.098 Y126.716 F30000
M106 S153
G1 F840
G1 X122.238 Y126.716 E.02766
M106 S150.45
; FEATURE: Overhang wall
M106 S153
G1 F1500
M204 S5000
G1 X121.769 Y126.716 E.01508
M106 S150.45
; FEATURE: Inner wall
M106 S153
G1 F1080
M204 S10000
G1 X120.749 Y126.716 E.0328
M106 S150.45
G1 F2041
G1 X120.202 Y126.716 E.01758
G1 X120.202 Y115.552 E.359
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y126.614 E.35572
M106 S153
G1 X123.098 Y126.676 E.002
M106 S150.45
G1 X123.505 Y127.123 F30000
M106 S153
G1 F960
G1 X123.154 Y127.123 E.01129
M106 S150.45
; FEATURE: Overhang wall
M106 S153
G1 F1500
M204 S5000
G1 X120.846 Y127.123 E.0742
M106 S150.45
; FEATURE: Inner wall
M106 S153
G1 F1680
M204 S10000
G1 X120.31 Y127.123 E.01724
M106 S150.45
G1 F2041
G1 X119.795 Y127.123 E.01656
M73 P55 R12
G1 X119.795 Y115.145 E.38518
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y126.923 E.37873
M106 S153
G1 X123.505 Y127.083 E.00517
M106 S150.45
M204 S250
G1 X123.94 Y127.54 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2041
M204 S5000
G1 X123.94 Y127.558 E.00056
M106 S153
G1 F1800
G1 X123.531 Y127.558 E.0122
M106 S150.45
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
M106 S153
G1 F1500
G1 X120.469 Y127.558 E.09843
M106 S150.45
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M106 S153
G1 F1800
G1 X120.051 Y127.558 E.01247
M106 S150.45
G1 F2041
G1 X119.36 Y127.558 E.02057
G1 X119.36 Y114.71 E.38271
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y127.5 E.38096
; WIPE_START
G1 F2400
M204 S10000
G1 X123.94 Y127.558 E-.02237
G1 X123.531 Y127.558 E-.15559
G1 X121.999 Y127.558 E-.58203
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y125.917 Z3.2 F30000
G1 Z2.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2041
G1 X122.299 Y116.351 E.28493
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y125.917 E.28493
G1 X122.239 Y125.917 E.03686
G1 X121.88 Y125.499 F30000
; LINE_WIDTH: 0.50319
G1 F2041
G1 X121.88 Y116.77 E.31736
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y125.499 E.31736
G1 X121.82 Y125.499 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3600
G1 X121.42 Y125.499 E-.1521
G1 X121.42 Y123.899 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 22/152
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
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
G1 X125.354 Y114.404
G1 Z3
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
G1 X125.354 Y117.465 E.09117
G1 X125.219 Y117.6 E.00571
G1 X124.738 Y117.6 E.01431
G1 X124.738 Y114.268 E.09925
G1 X125.221 Y114.271 E.01438
; WIPE_START
G1 X124.738 Y114.268 E-.18344
G1 X124.738 Y115.786 E-.57656
; WIPE_END
G1 E-.04
G17
G3 Z3.4 I1.211 J.117 P1  F30000
G1 X125.123 Y111.803 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Support
G1 F2085
G1 X125.123 Y113.891 E.0622
G1 X123.898 Y113.891 E.03649
G1 X123.878 Y113.911 E.00085
G1 X119.369 Y113.911 E.13431
G1 X119.369 Y111.615 E.06841
G1 X125.123 Y111.615 E.1714
G1 X125.123 Y108.738 E.0857
G1 X119.369 Y108.738 E.1714
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.4 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z3.4
G1 Z3
G1 E.8 F1800
G1 F2085
G1 X136.631 Y108.738 E.1714
G1 X136.631 Y111.615 E.0857
G1 X130.877 Y111.615 E.1714
G1 X130.877 Y113.891 E.06782
G1 X132.102 Y113.891 E.03649
G1 X132.122 Y113.911 E.00085
G1 X136.631 Y113.911 E.13431
G1 X136.631 Y111.803 E.0628
; WIPE_START
G1 F3000
G1 X136.631 Y113.803 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.4 I-.703 J-.994 P1  F30000
G1 X131.262 Y117.6 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Support interface
G1 X130.781 Y117.6 E.01431
G1 X130.646 Y117.465 E.00571
G1 X130.646 Y114.404 E.09117
G1 X130.781 Y114.268 E.00571
G1 X131.262 Y114.268 E.01431
G1 X131.262 Y117.412 E.09363
; WIPE_START
G1 X131.262 Y115.412 E-.76
; WIPE_END
G1 E-.04
G17
G3 Z3.4 I-.314 J1.176 P1  F30000
G1 X133.309 Y115.959 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2085
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y126.078 E.32538
G1 X133.309 Y126.078 E.06694
G1 X133.309 Y115.999 E.32409
G1 X132.902 Y115.552 F30000
G1 F2085
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y126.485 E.35156
G1 X132.902 Y126.485 E.09312
G1 X132.902 Y115.592 E.35027
G1 X132.495 Y115.145 F30000
G1 F2085
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y126.892 E.37774
G1 X132.495 Y126.892 E.1193
G1 X132.495 Y115.185 E.37645
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2085
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y127.327 E.37581
G1 X132.06 Y127.327 E.13642
G1 X132.06 Y114.75 E.37462
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.81 Y122.361 Z3.4 F30000
G1 X133.701 Y125.686 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2085
G1 X134.999 Y125.686 E.03865
G1 X134.999 Y116.351 E.27803
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y125.626 E.27625
G1 X134.12 Y125.267 F30000
; LINE_WIDTH: 0.50318
G1 F2085
G1 X134.58 Y125.267 E.01673
G1 X134.58 Y116.77 E.30893
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y125.207 E.30675
; WIPE_START
G1 F3600
G1 X134.12 Y123.207 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y125.066 Z3.4 F30000
G1 X122.691 Y126.078 Z3.4
G1 Z3
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F2085
G1 X120.609 Y126.078 E.06694
G1 X120.609 Y115.959 E.32538
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y126.038 E.32409
G1 X123.098 Y126.485 F30000
G1 F2085
G1 X120.202 Y126.485 E.09312
G1 X120.202 Y115.552 E.35156
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y126.445 E.35027
G1 X123.505 Y126.892 F30000
G1 F2085
G1 X119.795 Y126.892 E.1193
G1 X119.795 Y115.145 E.37774
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y126.852 E.37645
M204 S250
G1 X123.94 Y127.327 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2085
M204 S5000
G1 X119.36 Y127.327 E.13642
G1 X119.36 Y114.71 E.37581
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y127.287 E.37462
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y127.304 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y125.686 Z3.4 F30000
G1 Z3
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F2085
G1 X122.299 Y116.351 E.27803
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y125.686 E.27803
G1 X122.239 Y125.686 E.03686
G1 X121.88 Y125.267 F30000
; LINE_WIDTH: 0.50319
G1 F2085
G1 X121.88 Y116.77 E.30894
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y125.267 E.30894
G1 X121.82 Y125.267 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3600
G1 X121.42 Y125.267 E-.1521
G1 X121.42 Y123.667 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 23/152
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
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
G1 X133.309 Y115.959
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1616
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y125.846 E.31793
G1 X133.309 Y125.846 E.06694
G1 X133.309 Y115.999 E.31664
G1 X132.902 Y115.552 F30000
G1 F1616
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y126.253 E.34411
G1 X132.902 Y126.253 E.09312
G1 X132.902 Y115.592 E.34282
G1 X132.495 Y115.145 F30000
G1 F1616
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y126.66 E.37029
G1 X132.495 Y126.66 E.1193
M73 P56 R12
G1 X132.495 Y115.185 E.369
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1616
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y127.095 E.36892
G1 X132.06 Y127.095 E.13642
G1 X132.06 Y114.75 E.36772
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.805 Y122.361 Z3.6 F30000
G1 X133.701 Y125.454 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1616
G1 X134.999 Y125.454 E.03865
G1 X134.999 Y116.351 E.27114
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y125.394 E.26935
G1 X134.12 Y125.035 F30000
; LINE_WIDTH: 0.50318
G1 F1616
G1 X134.58 Y125.035 E.01673
G1 X134.58 Y116.77 E.30051
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y124.975 E.29833
; WIPE_START
G1 F3600
G1 X134.12 Y122.975 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y124.835 Z3.6 F30000
G1 X122.691 Y125.846 Z3.6
G1 Z3.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1616
G1 X120.609 Y125.846 E.06694
G1 X120.609 Y115.959 E.31793
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y125.806 E.31664
G1 X123.098 Y126.253 F30000
G1 F1616
G1 X120.202 Y126.253 E.09312
G1 X120.202 Y115.552 E.34411
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y126.213 E.34282
G1 X123.505 Y126.66 F30000
G1 F1616
G1 X119.795 Y126.66 E.1193
G1 X119.795 Y115.145 E.37029
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y126.62 E.369
M204 S250
G1 X123.94 Y127.095 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1616
M204 S5000
G1 X119.36 Y127.095 E.13642
G1 X119.36 Y114.71 E.36892
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y127.055 E.36772
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y127.073 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y125.454 Z3.6 F30000
G1 Z3.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1616
G1 X122.299 Y116.351 E.27114
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y125.454 E.27114
G1 X122.239 Y125.454 E.03686
G1 X121.88 Y125.035 F30000
; LINE_WIDTH: 0.50319
G1 F1616
G1 X121.88 Y116.77 E.30052
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y125.035 E.30052
G1 X121.82 Y125.035 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 3.27273
; LAYER_HEIGHT: 0.0727272
; WIPE_START
G1 F3600
G1 X121.42 Y125.035 E-.1521
G1 X121.42 Y123.436 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 24/152
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
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
G1 X125.131 Y117.377
G1 Z3.273
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 X124.731 Y117.377 E.01559
G1 X124.731 Y114.261 E.12134
G1 X125.131 Y114.261 E.01559
G1 X125.131 Y117.196 E.1143
G1 X125.123 Y111.803 F30000
; FEATURE: Support
G1 F1988
G1 X125.123 Y113.891 E.08131
G1 X123.898 Y113.891 E.0477
G1 X123.878 Y113.911 E.00111
G1 X119.369 Y113.911 E.17557
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.673 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z3.673
G1 Z3.273
G1 E.8 F1800
G1 F1988
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y113.891 E.08865
G1 X132.102 Y113.891 E.0477
G1 X132.122 Y113.911 E.00111
G1 X136.631 Y113.911 E.17558
G1 X136.631 Y111.803 E.08209
; WIPE_START
G1 F3000
G1 X136.631 Y113.803 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.673 I-.675 J-1.013 P1  F30000
G1 X131.269 Y117.377 Z3.673
G1 Z3.273
G1 E.8 F1800
; FEATURE: Support interface
G1 X130.869 Y117.377 E.01558
G1 X130.869 Y114.261 E.12134
G1 X131.269 Y114.261 E.01558
G1 X131.269 Y117.196 E.1143
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.127273
; WIPE_START
G1 X131.269 Y115.196 E-.76
; WIPE_END
G1 E-.04
; layer num/total_layer_count: 25/152
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
G17
G3 Z3.673 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1988
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y125.615 E.31048
G1 X133.309 Y125.615 E.06694
G1 X133.309 Y115.999 E.3092
G1 X132.902 Y115.552 F30000
G1 F1988
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y126.022 E.33666
G1 X132.902 Y126.022 E.09312
G1 X132.902 Y115.592 E.33538
G1 X132.495 Y115.145 F30000
G1 F1988
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y126.429 E.36284
G1 X132.495 Y126.429 E.1193
G1 X132.495 Y115.185 E.36156
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1988
M204 S5000
G1 X136.64 Y114.71 E.13642
M73 P57 R12
G1 X136.64 Y126.864 E.36202
G1 X132.06 Y126.864 E.13642
G1 X132.06 Y114.75 E.36083
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.799 Y122.361 Z3.8 F30000
G1 X133.701 Y125.222 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1988
G1 X134.999 Y125.222 E.03865
G1 X134.999 Y116.351 E.26424
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y125.162 E.26245
G1 X134.12 Y124.804 F30000
; LINE_WIDTH: 0.50319
G1 F1988
G1 X134.58 Y124.804 E.01673
G1 X134.58 Y116.77 E.2921
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y124.744 E.28992
; WIPE_START
G1 F3600
G1 X134.12 Y122.744 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y124.603 Z3.8 F30000
G1 X122.691 Y125.615 Z3.8
G1 Z3.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1988
G1 X120.609 Y125.615 E.06694
G1 X120.609 Y115.959 E.31048
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y125.575 E.3092
G1 X123.098 Y126.022 F30000
G1 F1988
G1 X120.202 Y126.022 E.09312
G1 X120.202 Y115.552 E.33666
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y125.982 E.33538
G1 X123.505 Y126.429 F30000
G1 F1988
G1 X119.795 Y126.429 E.1193
G1 X119.795 Y115.145 E.36284
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y126.389 E.36156
M204 S250
G1 X123.94 Y126.864 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1988
M204 S5000
G1 X119.36 Y126.864 E.13642
G1 X119.36 Y114.71 E.36202
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y126.824 E.36083
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y126.841 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y125.222 Z3.8 F30000
G1 Z3.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1988
G1 X122.299 Y116.351 E.26424
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y125.222 E.26424
G1 X122.239 Y125.222 E.03686
G1 X121.88 Y124.804 F30000
; LINE_WIDTH: 0.50318
G1 F1988
G1 X121.88 Y116.77 E.29209
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y124.804 E.29209
G1 X121.82 Y124.804 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 3.54545
; LAYER_HEIGHT: 0.145454
; WIPE_START
G1 F3600
G1 X121.42 Y124.804 E-.1521
G1 X121.42 Y123.204 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 26/152
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
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
G1 X125.131 Y117.377
G1 Z3.545
G1 E.8 F1800
; FEATURE: Support interface
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1768
G1 X124.731 Y117.377 E.01559
G1 X124.731 Y114.261 E.12134
G1 X125.131 Y114.261 E.01559
G1 X125.131 Y117.196 E.1143
G1 X125.123 Y111.803 F30000
; FEATURE: Support
G1 F1768
G1 X125.123 Y113.891 E.08131
G1 X123.898 Y113.891 E.0477
G1 X123.878 Y113.911 E.00111
G1 X119.369 Y113.911 E.17557
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.945 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z3.945
G1 Z3.545
G1 E.8 F1800
G1 F1768
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y113.891 E.08865
G1 X132.102 Y113.891 E.0477
G1 X132.122 Y113.911 E.00111
G1 X136.631 Y113.911 E.17558
G1 X136.631 Y111.803 E.08209
; WIPE_START
G1 F3000
G1 X136.631 Y113.803 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z3.945 I-.675 J-1.013 P1  F30000
G1 X131.269 Y117.377 Z3.945
G1 Z3.545
G1 E.8 F1800
; FEATURE: Support interface
G1 F1768
G1 X130.869 Y117.377 E.01558
G1 X130.869 Y114.261 E.12134
G1 X131.269 Y114.261 E.01558
G1 X131.269 Y117.196 E.1143
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.0545454
; WIPE_START
G1 F1800
G1 X131.269 Y115.196 E-.76
; WIPE_END
G1 E-.04
; layer num/total_layer_count: 27/152
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
G17
G3 Z3.945 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1768
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y125.383 E.30304
G1 X133.309 Y125.383 E.06694
G1 X133.309 Y115.999 E.30175
G1 X132.902 Y115.552 F30000
G1 F1768
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y125.79 E.32922
G1 X132.902 Y125.79 E.09312
G1 X132.902 Y115.592 E.32793
G1 X132.495 Y115.145 F30000
G1 F1768
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y126.197 E.3554
G1 X132.495 Y126.197 E.1193
G1 X132.495 Y115.185 E.35411
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1768
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y126.632 E.35512
G1 X132.06 Y126.632 E.13642
G1 X132.06 Y114.75 E.35393
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.714 Y122.357 Z4 F30000
G1 X133.657 Y123.6 Z4
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1768
G1 X133.657 Y121.971 E.05236
G1 X133.683 Y121.632 E.01093
G1 X133.657 Y121.56 E.00246
G1 X133.657 Y118.477 E.09915
G1 X133.683 Y118.138 E.01093
G1 X133.657 Y118.066 E.00246
G1 X133.657 Y116.307 E.05656
G1 X134.553 Y116.307 E.0288
G1 X134.546 Y116.391 E.0027
G1 X134.703 Y116.828 E.01492
G1 X135.043 Y117.205 E.01633
G1 X135.043 Y118.832 E.0523
G1 X134.881 Y119.012 E.00779
G1 X134.58 Y119.449 E.01705
G1 X134.546 Y119.885 E.01409
G1 X134.703 Y120.322 E.01492
G1 X135.043 Y120.7 E.01633
G1 X135.043 Y122.326 E.0523
G1 X134.881 Y122.506 E.00779
G1 X134.58 Y122.943 E.01706
G1 X134.546 Y123.38 E.01409
G1 X134.703 Y123.816 E.01492
G1 X135.043 Y124.194 E.01633
G1 X135.043 Y125.035 E.02704
G1 X134.255 Y125.035 E.02532
; WIPE_START
G1 F4200
G1 X135.043 Y125.035 E-.29917
G1 X135.043 Y124.194 E-.3196
G1 X134.794 Y123.918 E-.14124
; WIPE_END
G1 E-.04 F1800
G1 X127.217 Y124.835 Z4 F30000
G1 X122.691 Y125.383 Z4
M73 P58 R12
G1 Z3.6
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1768
G1 X120.609 Y125.383 E.06694
G1 X120.609 Y115.959 E.30304
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y125.343 E.30175
G1 X123.098 Y125.79 F30000
G1 F1768
G1 X120.202 Y125.79 E.09312
G1 X120.202 Y115.552 E.32922
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y125.75 E.32793
G1 X123.505 Y126.197 F30000
G1 F1768
G1 X119.795 Y126.197 E.1193
G1 X119.795 Y115.145 E.3554
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y126.157 E.35411
M204 S250
G1 X123.94 Y126.632 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1768
M204 S5000
G1 X119.36 Y126.632 E.13642
G1 X119.36 Y114.71 E.35512
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y126.592 E.35393
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y126.61 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.343 Y121.68 Z4 F30000
G1 Z3.6
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1768
G1 X122.343 Y123.308 E.05236
G1 X122.317 Y123.38 E.00245
G1 X122.343 Y123.717 E.01088
G1 X122.343 Y125.035 E.04238
G1 X121.447 Y125.035 E.02881
G1 X121.42 Y124.69 E.01112
G1 X121.12 Y124.253 E.01706
G1 X120.957 Y124.073 E.0078
G1 X120.957 Y122.447 E.05229
G1 X121.297 Y122.069 E.01634
G1 X121.454 Y121.632 E.01492
G1 X121.42 Y121.196 E.01409
G1 X121.12 Y120.759 E.01706
G1 X120.957 Y120.579 E.0078
G1 X120.957 Y118.953 E.05229
G1 X121.297 Y118.575 E.01634
G1 X121.454 Y118.138 E.01492
G1 X121.42 Y117.701 E.01409
G1 X121.12 Y117.265 E.01705
G1 X120.957 Y117.084 E.0078
G1 X120.957 Y116.307 E.02499
G1 X122.343 Y116.307 E.04455
G1 X122.317 Y116.391 E.00282
G1 X122.343 Y116.729 E.01088
G1 X122.343 Y119.814 E.09921
G1 X122.317 Y119.885 E.00245
G1 X122.343 Y120.223 E.01088
G1 X122.343 Y121.68 E.04685
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F4200
G1 X122.343 Y120.223 E-.55359
G1 X122.317 Y119.885 E-.1286
G1 X122.343 Y119.814 E-.02892
G1 X122.343 Y119.685 E-.04889
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 28/152
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
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
G1 X133.309 Y115.959
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1366
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y125.151 E.29559
G1 X133.309 Y125.151 E.06694
G1 X133.309 Y115.999 E.2943
G1 X132.902 Y115.552 F30000
G1 F1366
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y125.558 E.32177
G1 X132.902 Y125.558 E.09312
G1 X132.902 Y115.592 E.32048
G1 X132.495 Y115.145 F30000
G1 F1366
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y125.966 E.34795
G1 X132.495 Y125.966 E.1193
G1 X132.495 Y115.185 E.34666
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1366
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y126.401 E.34822
G1 X132.06 Y126.401 E.13642
G1 X132.06 Y114.75 E.34703
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.73 Y122.358 Z4.2 F30000
G1 X133.657 Y124.031 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1366
G1 X133.657 Y122.402 E.05236
G1 X133.815 Y122.069 E.01186
G1 X133.722 Y121.632 E.01436
G1 X133.657 Y121.533 E.00382
G1 X133.657 Y118.908 E.08441
G1 X133.815 Y118.575 E.01186
G1 X133.722 Y118.138 E.01436
G1 X133.657 Y118.039 E.00382
G1 X133.657 Y116.307 E.05568
G1 X134.49 Y116.307 E.02676
G1 X134.507 Y116.391 E.00276
G1 X134.792 Y116.828 E.01677
G1 X135.043 Y117.022 E.01019
G1 X135.043 Y118.685 E.05347
G1 X134.621 Y119.012 E.01715
G1 X134.414 Y119.449 E.01555
G1 X134.507 Y119.885 E.01436
G1 X134.792 Y120.322 E.01677
G1 X135.043 Y120.516 E.01019
G1 X135.043 Y122.179 E.05347
G1 X134.621 Y122.506 E.01715
G1 X134.414 Y122.943 E.01555
M73 P58 R11
G1 X134.507 Y123.38 E.01436
G1 X134.792 Y123.816 E.01677
G1 X135.043 Y124.011 E.01019
G1 X135.043 Y124.803 E.02549
G1 X134.207 Y124.803 E.02687
; WIPE_START
G1 F4200
G1 X135.043 Y124.803 E-.31753
G1 X135.043 Y124.011 E-.30123
G1 X134.792 Y123.816 E-.12038
G1 X134.762 Y123.77 E-.02086
; WIPE_END
G1 E-.04 F1800
G1 X127.179 Y124.638 Z4.2 F30000
G1 X122.691 Y125.151 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1366
G1 X120.609 Y125.151 E.06694
G1 X120.609 Y115.959 E.29559
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y125.111 E.2943
G1 X123.098 Y125.558 F30000
G1 F1366
G1 X120.202 Y125.558 E.09312
G1 X120.202 Y115.552 E.32177
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y125.518 E.32048
G1 X123.505 Y125.966 F30000
G1 F1366
G1 X119.795 Y125.966 E.1193
G1 X119.795 Y115.145 E.34795
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y125.926 E.34666
M204 S250
G1 X123.94 Y126.401 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1366
M204 S5000
G1 X119.36 Y126.401 E.13642
G1 X119.36 Y114.71 E.34822
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y126.361 E.34703
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y126.378 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.313 Y118.755 Z4.2 F30000
G1 X122.343 Y118.141 Z4.2
G1 Z3.8
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1366
G1 X122.343 Y119.77 E.05236
G1 X122.278 Y119.885 E.00426
G1 X122.185 Y120.322 E.01436
G1 X122.343 Y120.655 E.01185
G1 X122.343 Y123.264 E.08389
G1 X122.278 Y123.38 E.00426
G1 X122.185 Y123.816 E.01436
G1 X122.343 Y124.149 E.01185
G1 X122.343 Y124.803 E.02103
G1 X121.562 Y124.803 E.02511
G1 X121.586 Y124.69 E.00373
G1 X121.379 Y124.253 E.01555
G1 X120.957 Y123.926 E.01715
G1 X120.957 Y122.264 E.05346
G1 X121.208 Y122.069 E.01019
G1 X121.493 Y121.632 E.01677
G1 X121.586 Y121.196 E.01436
G1 X121.379 Y120.759 E.01555
G1 X120.957 Y120.432 E.01715
G1 X120.957 Y118.769 E.05346
G1 X121.208 Y118.575 E.01019
G1 X121.493 Y118.138 E.01677
G1 X121.586 Y117.701 E.01436
G1 X121.379 Y117.265 E.01555
G1 X120.957 Y116.938 E.01715
G1 X120.957 Y116.307 E.02027
G1 X122.325 Y116.307 E.04398
G1 X122.278 Y116.391 E.00309
G1 X122.185 Y116.828 E.01436
G1 X122.343 Y117.161 E.01185
G1 X122.343 Y118.141 E.03153
; CHANGE_LAYER
; Z_HEIGHT: 3.81818
; LAYER_HEIGHT: 0.0181818
; WIPE_START
G1 F4200
G1 X122.343 Y117.161 E-.37264
G1 X122.185 Y116.828 E-.14004
G1 X122.278 Y116.391 E-.16971
G1 X122.325 Y116.307 E-.03651
G1 X122.217 Y116.307 E-.04109
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 29/152
; update layer progress
M73 L29
M991 S0 P28 ;notify layer change
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
G1 X124.739 Y117.369
G1 Z3.818
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1660
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
M73 P59 R11
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z4.218 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z4.218
G1 Z3.818
G1 E.8 F1800
G1 F1660
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z4.218 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z4.218
G1 Z3.818
G1 E.8 F1800
G1 F1660
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.181818
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 30/152
; update layer progress
M73 L30
M991 S0 P29 ;notify layer change
G17
G3 Z4.218 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1660
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y124.92 E.28814
G1 X133.309 Y124.92 E.06694
G1 X133.309 Y115.999 E.28686
G1 X132.902 Y115.552 F30000
G1 F1660
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y125.327 E.31432
G1 X132.902 Y125.327 E.09312
G1 X132.902 Y115.592 E.31304
G1 X132.495 Y115.145 F30000
G1 F1660
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y125.734 E.3405
G1 X132.495 Y125.734 E.1193
G1 X132.495 Y115.185 E.33922
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1660
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y126.169 E.34132
G1 X132.06 Y126.169 E.13642
G1 X132.06 Y114.75 E.34013
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.657 Y117.208 Z4.4 F30000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1660
G1 X133.657 Y116.307 E.02898
G1 X134.384 Y116.307 E.02338
G1 X134.552 Y116.563 E.00981
G1 X134.988 Y116.893 E.01761
G1 X135.043 Y116.91 E.00183
G1 X135.043 Y118.599 E.0543
G1 X134.988 Y118.64 E.00219
G1 X134.552 Y118.779 E.01474
G1 X134.115 Y118.634 E.0148
G1 X133.657 Y117.951 E.02644
G1 X133.657 Y119.251 E.04179
G1 X133.678 Y119.244 E.0007
G1 X134.115 Y119.389 E.0148
G1 X134.552 Y120.057 E.02565
G1 X134.988 Y120.387 E.01761
G1 X135.043 Y120.405 E.00183
G1 X135.043 Y122.093 E.0543
G1 X134.988 Y122.134 E.00219
G1 X134.552 Y122.274 E.01474
G1 X134.115 Y122.128 E.0148
G1 X133.657 Y121.445 E.02644
G1 X133.657 Y122.745 E.04179
G1 X133.678 Y122.738 E.0007
G1 X134.115 Y122.884 E.0148
G1 X134.552 Y123.551 E.02565
G1 X134.988 Y123.882 E.01761
G1 X135.043 Y123.899 E.00183
G1 X135.043 Y124.572 E.02164
G1 X134.087 Y124.572 E.03073
; WIPE_START
G1 F4200
G1 X135.043 Y124.572 E-.36309
G1 X135.043 Y123.899 E-.25567
G1 X134.988 Y123.882 E-.02168
G1 X134.737 Y123.692 E-.11956
; WIPE_END
G1 E-.04 F1800
G1 X127.144 Y124.466 Z4.4 F30000
G1 X122.691 Y124.92 Z4.4
G1 Z4
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1660
G1 X120.609 Y124.92 E.06694
G1 X120.609 Y115.959 E.28814
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y124.88 E.28686
G1 X123.098 Y125.327 F30000
G1 F1660
G1 X120.202 Y125.327 E.09312
G1 X120.202 Y115.552 E.31432
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y125.287 E.31304
G1 X123.505 Y125.734 F30000
G1 F1660
G1 X119.795 Y125.734 E.1193
G1 X119.795 Y115.145 E.3405
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y125.694 E.33922
M204 S250
G1 X123.94 Y126.169 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1660
M204 S5000
G1 X119.36 Y126.169 E.13642
G1 X119.36 Y114.71 E.34132
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y126.129 E.34013
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y126.146 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.094 Y124.572 Z4.4 F30000
G1 Z4
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1660
G1 X122.343 Y124.572 E.00801
G1 X122.343 Y123.192 E.04435
G1 X121.885 Y123.875 E.02643
G1 X121.449 Y124.021 E.0148
G1 X121.012 Y123.882 E.01474
G1 X120.957 Y123.84 E.0022
G1 X120.957 Y122.152 E.0543
G1 X121.012 Y122.134 E.00184
G1 X121.449 Y121.804 E.01761
G1 X121.885 Y121.137 E.02565
G1 X122.322 Y120.991 E.0148
G1 X122.343 Y120.998 E.00069
G1 X122.343 Y119.698 E.04179
G1 X121.885 Y120.381 E.02643
G1 X121.449 Y120.526 E.0148
G1 X121.012 Y120.387 E.01474
G1 X120.957 Y120.346 E.0022
G1 X120.957 Y118.658 E.0543
G1 X121.012 Y118.64 E.00184
G1 X121.449 Y118.31 E.01761
G1 X121.885 Y117.642 E.02565
G1 X122.322 Y117.497 E.0148
G1 X122.343 Y117.504 E.00069
G1 X122.343 Y116.307 E.03847
G1 X122.265 Y116.307 E.00251
G1 X121.885 Y116.887 E.02228
G1 X121.449 Y117.032 E.0148
G1 X121.012 Y116.893 E.01474
G1 X120.957 Y116.852 E.0022
G1 X120.957 Y116.307 E.01751
G1 X122.041 Y116.307 E.03485
; CHANGE_LAYER
; Z_HEIGHT: 4.09091
; LAYER_HEIGHT: 0.090909
; WIPE_START
G1 F4200
G1 X120.957 Y116.307 E-.41182
G1 X120.957 Y116.852 E-.20694
G1 X121.012 Y116.893 E-.02596
G1 X121.301 Y116.985 E-.11528
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 31/152
; update layer progress
M73 L31
M991 S0 P30 ;notify layer change
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
G1 X124.739 Y117.369
G1 Z4.091
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1637
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z4.491 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z4.491
G1 Z4.091
G1 E.8 F1800
G1 F1637
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z4.491 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z4.491
G1 Z4.091
G1 E.8 F1800
G1 F1637
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.109091
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 32/152
; update layer progress
M73 L32
M991 S0 P31 ;notify layer change
G17
G3 Z4.491 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1637
G1 X135.391 Y115.959 E.06694
M73 P60 R11
G1 X135.391 Y124.688 E.2807
G1 X133.309 Y124.688 E.06694
G1 X133.309 Y115.999 E.27941
G1 X132.902 Y115.552 F30000
G1 F1637
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y125.095 E.30688
G1 X132.902 Y125.095 E.09312
G1 X132.902 Y115.592 E.30559
G1 X132.495 Y115.145 F30000
G1 F1637
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y125.502 E.33306
G1 X132.495 Y125.502 E.1193
G1 X132.495 Y115.185 E.33177
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1637
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y125.937 E.33443
G1 X132.06 Y125.937 E.13642
G1 X132.06 Y114.75 E.33323
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.657 Y117.385 Z4.6 F30000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1637
G1 X133.657 Y116.307 E.03465
G1 X134.208 Y116.307 E.01771
G1 X134.552 Y116.647 E.01553
G1 X134.988 Y116.841 E.01537
G1 X135.043 Y116.841 E.00175
G1 X135.043 Y118.564 E.05539
G1 X134.988 Y118.588 E.00191
G1 X134.552 Y118.592 E.01405
G1 X134.115 Y118.314 E.01664
G1 X133.657 Y117.873 E.02043
G1 X133.657 Y119.432 E.05012
G1 X134.115 Y119.709 E.0172
G1 X134.552 Y120.141 E.01975
G1 X134.988 Y120.335 E.01537
G1 X135.043 Y120.335 E.00175
G1 X135.043 Y122.058 E.05539
G1 X134.988 Y122.082 E.00191
G1 X134.552 Y122.086 E.01405
G1 X134.115 Y121.808 E.01664
G1 X133.657 Y121.368 E.02043
G1 X133.657 Y122.926 E.05012
G1 X134.115 Y123.204 E.0172
G1 X134.552 Y123.635 E.01975
G1 X134.988 Y123.829 E.01537
G1 X135.043 Y123.83 E.00175
G1 X135.043 Y124.34 E.01641
G1 X133.925 Y124.34 E.03595
; WIPE_START
G1 F4200
G1 X135.043 Y124.34 E-.42479
G1 X135.043 Y123.83 E-.19397
G1 X134.988 Y123.829 E-.02066
G1 X134.698 Y123.7 E-.12058
; WIPE_END
G1 E-.04 F1800
G1 X127.092 Y124.326 Z4.6 F30000
G1 X122.691 Y124.688 Z4.6
G1 Z4.2
G1 E.8 F1800
; FEATURE: Inner wall
G1 F1637
G1 X120.609 Y124.688 E.06694
G1 X120.609 Y115.959 E.2807
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y124.648 E.27941
G1 X123.098 Y125.095 F30000
G1 F1637
G1 X120.202 Y125.095 E.09312
G1 X120.202 Y115.552 E.30688
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y125.055 E.30559
G1 X123.505 Y125.502 F30000
G1 F1637
G1 X119.795 Y125.502 E.1193
G1 X119.795 Y115.145 E.33306
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y125.462 E.33177
M204 S250
G1 X123.94 Y125.937 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1637
M204 S5000
G1 X119.36 Y125.937 E.13642
G1 X119.36 Y114.71 E.33443
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y125.897 E.33323
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y125.915 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X121.94 Y124.34 Z4.6 F30000
G1 Z4.2
G1 E.8 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F1637
G1 X122.343 Y124.34 E.01296
G1 X122.343 Y123.115 E.0394
G1 X121.885 Y123.555 E.02042
G1 X121.449 Y123.833 E.01664
G1 X121.012 Y123.829 E.01405
G1 X120.957 Y123.805 E.00192
G1 X120.957 Y122.083 E.05539
G1 X121.012 Y122.082 E.00175
G1 X121.449 Y121.888 E.01537
G1 X121.885 Y121.456 E.01975
G1 X122.343 Y121.179 E.0172
G1 X122.343 Y119.621 E.05012
G1 X121.885 Y120.061 E.02042
G1 X121.449 Y120.339 E.01664
G1 X121.012 Y120.335 E.01405
G1 X120.957 Y120.311 E.00192
G1 X120.957 Y118.588 E.05539
G1 X121.012 Y118.588 E.00175
G1 X121.449 Y118.394 E.01537
G1 X121.885 Y117.962 E.01975
G1 X122.343 Y117.685 E.0172
G1 X122.343 Y116.307 E.0443
G1 X122.148 Y116.307 E.00625
G1 X121.885 Y116.567 E.01188
G1 X121.449 Y116.844 E.01664
G1 X121.012 Y116.841 E.01405
G1 X120.957 Y116.817 E.00192
G1 X120.957 Y118.385 E.05043
; CHANGE_LAYER
; Z_HEIGHT: 4.36364
; LAYER_HEIGHT: 0.163637
; WIPE_START
G1 F4200
G1 X120.957 Y116.817 E-.59593
G1 X121.012 Y116.841 E-.02265
G1 X121.384 Y116.844 E-.14142
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 33/152
; update layer progress
M73 L33
M991 S0 P32 ;notify layer change
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
G1 X124.739 Y117.369
G1 Z4.364
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1785
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z4.764 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z4.764
G1 Z4.364
G1 E.8 F1800
G1 F1785
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z4.764 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z4.764
G1 Z4.364
G1 E.8 F1800
G1 F1785
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.0363636
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 34/152
; update layer progress
M73 L34
M991 S0 P33 ;notify layer change
G17
G3 Z4.764 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1785
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y124.457 E.27325
G1 X133.309 Y124.457 E.06694
G1 X133.309 Y115.999 E.27196
G1 X132.902 Y115.552 F30000
G1 F1785
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y124.864 E.29943
G1 X132.902 Y124.864 E.09312
G1 X132.902 Y115.592 E.29814
G1 X132.495 Y115.145 F30000
G1 F1785
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y125.271 E.32561
G1 X132.495 Y125.271 E.1193
G1 X132.495 Y115.185 E.32432
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1785
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y125.706 E.32753
G1 X132.06 Y125.706 E.13642
G1 X132.06 Y114.75 E.32634
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X134.824 Y122.327 Z4.8 F30000
G1 X134.999 Y124.065 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F1785
G1 X134.999 Y116.351 E.22975
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y124.065 E.22975
G1 X134.939 Y124.065 E.03686
G1 X134.58 Y117 F30000
; LINE_WIDTH: 0.50318
G1 F1785
G1 X134.58 Y116.77 E.00837
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y123.646 E.24999
G1 X134.58 Y123.646 E.01673
G1 X134.58 Y117.06 E.23945
; WIPE_START
G1 F2880
G1 X134.58 Y119.06 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X127.63 Y122.215 Z4.8 F30000
G1 X122.691 Y124.457 Z4.8
G1 Z4.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1785
G1 X120.609 Y124.457 E.06694
G1 X120.609 Y115.959 E.27325
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y124.417 E.27196
G1 X123.098 Y124.864 F30000
G1 F1785
G1 X120.202 Y124.864 E.09312
G1 X120.202 Y115.552 E.29943
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y124.824 E.29814
G1 X123.505 Y125.271 F30000
G1 F1785
G1 X119.795 Y125.271 E.1193
G1 X119.795 Y115.145 E.32561
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y125.231 E.32432
M204 S250
G1 X123.94 Y125.706 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1785
M204 S5000
G1 X119.36 Y125.706 E.13642
G1 X119.36 Y114.71 E.32753
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y125.666 E.32634
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y125.683 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y124.065 Z4.8 F30000
G1 Z4.4
G1 E.8 F1800
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.41999
G1 F1785
G1 X122.299 Y116.351 E.22975
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y124.065 E.22975
G1 X122.239 Y124.065 E.03686
G1 X121.88 Y117 F30000
; LINE_WIDTH: 0.50319
G1 F1785
G1 X121.88 Y116.77 E.00837
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y123.646 E.25
G1 X121.88 Y123.646 E.01673
G1 X121.88 Y117.06 E.23945
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F2880
G1 X121.88 Y119.06 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 35/152
; update layer progress
M73 L35
M991 S0 P34 ;notify layer change
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
G1 X133.309 Y115.959
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1413
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y124.225 E.2658
M73 P61 R11
G1 X133.309 Y124.225 E.06694
G1 X133.309 Y115.999 E.26452
G1 X132.902 Y115.552 F30000
G1 F1413
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y124.632 E.29198
G1 X132.902 Y124.632 E.09312
G1 X132.902 Y115.592 E.2907
G1 X132.495 Y115.145 F30000
G1 F1413
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y125.039 E.31816
G1 X132.495 Y125.039 E.1193
G1 X132.495 Y115.185 E.31688
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1413
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y125.474 E.32063
G1 X132.06 Y125.474 E.13642
G1 X132.06 Y114.75 E.31944
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.759 Y122.359 Z5 F30000
G1 X133.701 Y123.833 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1413
G1 X134.999 Y123.833 E.03865
G1 X134.999 Y116.351 E.22285
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y123.773 E.22106
G1 X134.12 Y123.414 F30000
; LINE_WIDTH: 0.50318
G1 F1413
G1 X134.58 Y123.414 E.01673
G1 X134.58 Y116.77 E.24157
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y123.354 E.23939
; WIPE_START
G1 F3600
G1 X134.12 Y121.354 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y123.214 Z5 F30000
G1 X122.691 Y124.225 Z5
G1 Z4.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1413
G1 X120.609 Y124.225 E.06694
G1 X120.609 Y115.959 E.2658
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y124.185 E.26452
G1 X123.098 Y124.632 F30000
G1 F1413
G1 X120.202 Y124.632 E.09312
G1 X120.202 Y115.552 E.29198
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y124.592 E.2907
G1 X123.505 Y125.039 F30000
G1 F1413
G1 X119.795 Y125.039 E.1193
G1 X119.795 Y115.145 E.31816
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y124.999 E.31688
M204 S250
G1 X123.94 Y125.474 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1413
M204 S5000
G1 X119.36 Y125.474 E.13642
G1 X119.36 Y114.71 E.32063
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y125.434 E.31944
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y125.452 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y123.833 Z5 F30000
G1 Z4.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1413
G1 X122.299 Y116.351 E.22285
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y123.833 E.22285
G1 X122.239 Y123.833 E.03686
G1 X121.88 Y123.414 F30000
; LINE_WIDTH: 0.50319
G1 F1413
G1 X121.88 Y116.77 E.24158
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y123.414 E.24158
G1 X121.82 Y123.414 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 4.63636
; LAYER_HEIGHT: 0.0363636
; WIPE_START
G1 F3600
G1 X121.42 Y123.414 E-.1521
G1 X121.42 Y121.815 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 36/152
; update layer progress
M73 L36
M991 S0 P35 ;notify layer change
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
G1 X124.739 Y117.369
G1 Z4.636
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1722
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z5.036 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z5.036
G1 Z4.636
G1 E.8 F1800
G1 F1722
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z5.036 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z5.036
G1 Z4.636
G1 E.8 F1800
G1 F1722
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.163637
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 37/152
; update layer progress
M73 L37
M991 S0 P36 ;notify layer change
G17
G3 Z5.036 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1722
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y123.993 E.25836
G1 X133.309 Y123.993 E.06694
G1 X133.309 Y115.999 E.25707
G1 X132.902 Y115.552 F30000
G1 F1722
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y124.401 E.28454
G1 X132.902 Y124.401 E.09312
G1 X132.902 Y115.592 E.28325
G1 X132.495 Y115.145 F30000
G1 F1722
M73 P62 R11
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y124.808 E.31072
G1 X132.495 Y124.808 E.1193
G1 X132.495 Y115.185 E.30943
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1722
M204 S5000
M73 P62 R10
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y125.243 E.31373
G1 X132.06 Y125.243 E.13642
G1 X132.06 Y114.75 E.31254
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.751 Y122.359 Z5.2 F30000
G1 X133.701 Y123.601 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1722
G1 X134.999 Y123.601 E.03865
G1 X134.999 Y116.351 E.21595
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y123.541 E.21417
G1 X134.12 Y123.183 F30000
; LINE_WIDTH: 0.50318
G1 F1722
G1 X134.58 Y123.183 E.01673
G1 X134.58 Y116.77 E.23315
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y123.123 E.23097
; WIPE_START
G1 F3600
G1 X134.12 Y121.123 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y122.982 Z5.2 F30000
G1 X122.691 Y123.993 Z5.2
G1 Z4.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1722
G1 X120.609 Y123.993 E.06694
G1 X120.609 Y115.959 E.25836
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y123.953 E.25707
G1 X123.098 Y124.401 F30000
G1 F1722
G1 X120.202 Y124.401 E.09312
G1 X120.202 Y115.552 E.28454
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y124.361 E.28325
G1 X123.505 Y124.808 F30000
G1 F1722
G1 X119.795 Y124.808 E.1193
G1 X119.795 Y115.145 E.31072
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y124.768 E.30943
M204 S250
G1 X123.94 Y125.243 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1722
M204 S5000
G1 X119.36 Y125.243 E.13642
G1 X119.36 Y114.71 E.31373
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y125.203 E.31254
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y125.22 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y123.601 Z5.2 F30000
G1 Z4.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1722
G1 X122.299 Y116.351 E.21595
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y123.601 E.21595
G1 X122.239 Y123.601 E.03686
G1 X121.88 Y123.183 F30000
; LINE_WIDTH: 0.50319
G1 F1722
G1 X121.88 Y116.77 E.23316
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y123.183 E.23316
G1 X121.82 Y123.183 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 4.90909
; LAYER_HEIGHT: 0.109091
; WIPE_START
G1 F3600
G1 X121.42 Y123.183 E-.1521
G1 X121.42 Y121.583 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 38/152
; update layer progress
M73 L38
M991 S0 P37 ;notify layer change
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
G1 X124.739 Y117.369
G1 Z4.909
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1692
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z5.309 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z5.309
G1 Z4.909
G1 E.8 F1800
G1 F1692
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z5.309 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z5.309
G1 Z4.909
G1 E.8 F1800
G1 F1692
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.090909
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 39/152
; update layer progress
M73 L39
M991 S0 P38 ;notify layer change
G17
G3 Z5.309 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1692
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y123.762 E.25091
G1 X133.309 Y123.762 E.06694
G1 X133.309 Y115.999 E.24962
G1 X132.902 Y115.552 F30000
G1 F1692
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y124.169 E.27709
G1 X132.902 Y124.169 E.09312
G1 X132.902 Y115.592 E.2758
G1 X132.495 Y115.145 F30000
G1 F1692
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y124.576 E.30327
G1 X132.495 Y124.576 E.1193
G1 X132.495 Y115.185 E.30198
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1692
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y125.011 E.30683
G1 X132.06 Y125.011 E.13642
G1 X132.06 Y114.75 E.30564
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.743 Y122.358 Z5.4 F30000
G1 X133.701 Y123.37 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1692
G1 X134.999 Y123.37 E.03865
G1 X134.999 Y116.351 E.20906
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y123.31 E.20727
G1 X134.12 Y122.951 F30000
; LINE_WIDTH: 0.50319
G1 F1692
G1 X134.58 Y122.951 E.01673
G1 X134.58 Y116.77 E.22474
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y122.891 E.22256
; WIPE_START
G1 F3600
M73 P63 R10
G1 X134.12 Y120.891 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y122.751 Z5.4 F30000
G1 X122.691 Y123.762 Z5.4
G1 Z5
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1692
G1 X120.609 Y123.762 E.06694
G1 X120.609 Y115.959 E.25091
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y123.722 E.24962
G1 X123.098 Y124.169 F30000
G1 F1692
G1 X120.202 Y124.169 E.09312
G1 X120.202 Y115.552 E.27709
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y124.129 E.2758
G1 X123.505 Y124.576 F30000
G1 F1692
G1 X119.795 Y124.576 E.1193
G1 X119.795 Y115.145 E.30327
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y124.536 E.30198
M204 S250
G1 X123.94 Y125.011 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1692
M204 S5000
G1 X119.36 Y125.011 E.13642
G1 X119.36 Y114.71 E.30683
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y124.971 E.30564
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y124.989 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y123.37 Z5.4 F30000
G1 Z5
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1692
G1 X122.299 Y116.351 E.20906
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y123.37 E.20906
G1 X122.239 Y123.37 E.03686
G1 X121.88 Y122.951 F30000
; LINE_WIDTH: 0.50318
G1 F1692
G1 X121.88 Y116.77 E.22473
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y122.951 E.22473
G1 X121.82 Y122.951 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 5.18182
; LAYER_HEIGHT: 0.181818
; WIPE_START
G1 F3600
G1 X121.42 Y122.951 E-.1521
G1 X121.42 Y121.351 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 40/152
; update layer progress
M73 L40
M991 S0 P39 ;notify layer change
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
G1 X124.739 Y117.369
G1 Z5.182
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1662
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z5.582 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z5.582
G1 Z5.182
G1 E.8 F1800
G1 F1662
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z5.582 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z5.582
G1 Z5.182
G1 E.8 F1800
G1 F1662
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.0181818
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 41/152
; update layer progress
M73 L41
M991 S0 P40 ;notify layer change
G17
G3 Z5.582 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1662
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y123.53 E.24346
G1 X133.309 Y123.53 E.06694
G1 X133.309 Y115.999 E.24218
G1 X132.902 Y115.552 F30000
G1 F1662
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y123.937 E.26964
G1 X132.902 Y123.937 E.09312
G1 X132.902 Y115.592 E.26836
G1 X132.495 Y115.145 F30000
G1 F1662
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y124.344 E.29582
G1 X132.495 Y124.344 E.1193
G1 X132.495 Y115.185 E.29454
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1662
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y124.779 E.29994
G1 X132.06 Y124.779 E.13642
G1 X132.06 Y114.75 E.29874
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.734 Y122.358 Z5.6 F30000
G1 X133.701 Y123.138 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1662
G1 X134.999 Y123.138 E.03865
G1 X134.999 Y116.351 E.20216
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y123.078 E.20037
G1 X134.12 Y122.72 F30000
; LINE_WIDTH: 0.50318
G1 F1662
G1 X134.58 Y122.72 E.01673
G1 X134.58 Y116.77 E.21632
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y122.66 E.21413
; WIPE_START
G1 F3600
G1 X134.12 Y120.66 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y122.519 Z5.6 F30000
G1 X122.691 Y123.53 Z5.6
G1 Z5.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1662
G1 X120.609 Y123.53 E.06694
G1 X120.609 Y115.959 E.24346
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y123.49 E.24218
G1 X123.098 Y123.937 F30000
G1 F1662
G1 X120.202 Y123.937 E.09312
G1 X120.202 Y115.552 E.26964
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y123.897 E.26836
G1 X123.505 Y124.344 F30000
G1 F1662
G1 X119.795 Y124.344 E.1193
G1 X119.795 Y115.145 E.29582
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y124.304 E.29454
M204 S250
G1 X123.94 Y124.779 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1662
M204 S5000
G1 X119.36 Y124.779 E.13642
G1 X119.36 Y114.71 E.29994
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y124.739 E.29874
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y124.757 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y123.138 Z5.6 F30000
G1 Z5.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1662
G1 X122.299 Y116.351 E.20216
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y123.138 E.20216
G1 X122.239 Y123.138 E.03686
G1 X121.88 Y122.72 F30000
; LINE_WIDTH: 0.50319
G1 F1662
G1 X121.88 Y116.77 E.21632
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y122.72 E.21632
G1 X121.82 Y122.72 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3600
G1 X121.42 Y122.72 E-.1521
G1 X121.42 Y121.12 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 42/152
; update layer progress
M73 L42
M991 S0 P41 ;notify layer change
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
G1 X133.309 Y115.959
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1295
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y123.299 E.23602
G1 X133.309 Y123.299 E.06694
G1 X133.309 Y115.999 E.23473
G1 X132.902 Y115.552 F30000
G1 F1295
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y123.706 E.2622
G1 X132.902 Y123.706 E.09312
G1 X132.902 Y115.592 E.26091
G1 X132.495 Y115.145 F30000
G1 F1295
M73 P64 R10
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y124.113 E.28838
G1 X132.495 Y124.113 E.1193
G1 X132.495 Y115.185 E.28709
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1295
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y124.548 E.29304
G1 X132.06 Y124.548 E.13642
G1 X132.06 Y114.75 E.29185
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.725 Y122.358 Z5.8 F30000
G1 X133.701 Y122.907 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1295
G1 X134.999 Y122.907 E.03865
G1 X134.999 Y116.351 E.19526
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y122.847 E.19347
G1 X134.12 Y122.488 F30000
; LINE_WIDTH: 0.50318
G1 F1295
G1 X134.58 Y122.488 E.01673
G1 X134.58 Y116.77 E.2079
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y122.428 E.20572
; WIPE_START
G1 F3600
G1 X134.12 Y120.428 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y122.287 Z5.8 F30000
G1 X122.691 Y123.299 Z5.8
G1 Z5.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1295
G1 X120.609 Y123.299 E.06694
G1 X120.609 Y115.959 E.23602
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y123.259 E.23473
G1 X123.098 Y123.706 F30000
G1 F1295
G1 X120.202 Y123.706 E.09312
G1 X120.202 Y115.552 E.2622
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y123.666 E.26091
G1 X123.505 Y124.113 F30000
G1 F1295
G1 X119.795 Y124.113 E.1193
G1 X119.795 Y115.145 E.28838
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y124.073 E.28709
M204 S250
G1 X123.94 Y124.548 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1295
M204 S5000
G1 X119.36 Y124.548 E.13642
G1 X119.36 Y114.71 E.29304
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y124.508 E.29185
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y124.525 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y122.907 Z5.8 F30000
G1 Z5.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1295
G1 X122.299 Y116.351 E.19526
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y122.907 E.19526
G1 X122.239 Y122.907 E.03686
G1 X121.88 Y122.488 F30000
; LINE_WIDTH: 0.50319
G1 F1295
G1 X121.88 Y116.77 E.2079
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y122.488 E.2079
G1 X121.82 Y122.488 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 5.45455
; LAYER_HEIGHT: 0.0545454
; WIPE_START
G1 F3600
G1 X121.42 Y122.488 E-.1521
G1 X121.42 Y120.888 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 43/152
; update layer progress
M73 L43
M991 S0 P42 ;notify layer change
G17
G3 Z5.8 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z5.455
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1602
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z5.855 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z5.855
G1 Z5.455
G1 E.8 F1800
G1 F1602
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z5.855 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z5.855
G1 Z5.455
G1 E.8 F1800
G1 F1602
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.145454
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 44/152
; update layer progress
M73 L44
M991 S0 P43 ;notify layer change
G17
G3 Z5.855 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1602
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y123.067 E.22857
G1 X133.309 Y123.067 E.06694
G1 X133.309 Y115.999 E.22728
G1 X132.902 Y115.552 F30000
G1 F1602
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y123.474 E.25475
G1 X132.902 Y123.474 E.09312
G1 X132.902 Y115.592 E.25346
G1 X132.495 Y115.145 F30000
G1 F1602
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y123.881 E.28093
G1 X132.495 Y123.881 E.1193
G1 X132.495 Y115.185 E.27964
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1602
M204 S5000
G1 X136.64 Y114.71 E.13642
M73 P65 R10
G1 X136.64 Y124.316 E.28614
G1 X132.06 Y124.316 E.13642
G1 X132.06 Y114.75 E.28495
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.716 Y122.357 Z6 F30000
G1 X133.701 Y122.675 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1602
G1 X134.999 Y122.675 E.03865
G1 X134.999 Y116.351 E.18836
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y122.615 E.18658
G1 X134.12 Y122.256 F30000
; LINE_WIDTH: 0.50318
G1 F1602
G1 X134.58 Y122.256 E.01673
G1 X134.58 Y116.77 E.19948
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y122.196 E.1973
; WIPE_START
G1 F3600
G1 X134.12 Y120.196 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y122.056 Z6 F30000
G1 X122.691 Y123.067 Z6
G1 Z5.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1602
G1 X120.609 Y123.067 E.06694
G1 X120.609 Y115.959 E.22857
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y123.027 E.22728
G1 X123.098 Y123.474 F30000
G1 F1602
G1 X120.202 Y123.474 E.09312
G1 X120.202 Y115.552 E.25475
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y123.434 E.25346
G1 X123.505 Y123.881 F30000
G1 F1602
G1 X119.795 Y123.881 E.1193
G1 X119.795 Y115.145 E.28093
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y123.841 E.27964
M204 S250
G1 X123.94 Y124.316 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1602
M204 S5000
G1 X119.36 Y124.316 E.13642
G1 X119.36 Y114.71 E.28614
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y124.276 E.28495
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y124.294 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y122.675 Z6 F30000
G1 Z5.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1602
G1 X122.299 Y116.351 E.18836
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y122.675 E.18836
G1 X122.239 Y122.675 E.03686
G1 X121.88 Y122.256 F30000
; LINE_WIDTH: 0.50319
G1 F1602
G1 X121.88 Y116.77 E.19948
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y122.256 E.19948
G1 X121.82 Y122.256 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 5.72727
; LAYER_HEIGHT: 0.127273
; WIPE_START
G1 F3600
G1 X121.42 Y122.256 E-.1521
G1 X121.42 Y120.657 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 45/152
; update layer progress
M73 L45
M991 S0 P44 ;notify layer change
G17
G3 Z6 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z5.727
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1572
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z6.127 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z6.127
G1 Z5.727
G1 E.8 F1800
G1 F1572
M73 P65 R9
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z6.127 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z6.127
G1 Z5.727
G1 E.8 F1800
G1 F1572
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 5.8
; LAYER_HEIGHT: 0.0727277
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 46/152
; update layer progress
M73 L46
M991 S0 P45 ;notify layer change
G17
G3 Z6.127 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1572
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y122.836 E.22112
G1 X133.309 Y122.836 E.06694
G1 X133.309 Y115.999 E.21984
G1 X132.902 Y115.552 F30000
G1 F1572
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y123.243 E.2473
G1 X132.902 Y123.243 E.09312
G1 X132.902 Y115.592 E.24602
G1 X132.495 Y115.145 F30000
G1 F1572
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y123.65 E.27348
G1 X132.495 Y123.65 E.1193
G1 X132.495 Y115.185 E.2722
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1572
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y124.085 E.27924
G1 X132.06 Y124.085 E.13642
G1 X132.06 Y114.75 E.27805
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.705 Y122.357 Z6.2 F30000
G1 X133.701 Y122.444 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1572
G1 X134.999 Y122.444 E.03865
G1 X134.999 Y116.351 E.18147
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y122.384 E.17968
G1 X134.12 Y122.025 F30000
; LINE_WIDTH: 0.50318
G1 F1572
G1 X134.58 Y122.025 E.01673
G1 X134.58 Y116.77 E.19106
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y121.965 E.18888
; WIPE_START
G1 F3600
G1 X134.12 Y119.965 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y121.824 Z6.2 F30000
G1 X122.691 Y122.836 Z6.2
G1 Z5.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1572
G1 X120.609 Y122.836 E.06694
G1 X120.609 Y115.959 E.22112
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y122.796 E.21984
G1 X123.098 Y123.243 F30000
G1 F1572
G1 X120.202 Y123.243 E.09312
G1 X120.202 Y115.552 E.2473
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y123.203 E.24602
G1 X123.505 Y123.65 F30000
G1 F1572
G1 X119.795 Y123.65 E.1193
G1 X119.795 Y115.145 E.27348
G1 X123.505 Y115.145 E.1193
M73 P66 R9
G1 X123.505 Y123.61 E.2722
M204 S250
G1 X123.94 Y124.085 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1572
M204 S5000
G1 X119.36 Y124.085 E.13642
G1 X119.36 Y114.71 E.27924
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y124.045 E.27805
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y124.062 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y122.444 Z6.2 F30000
G1 Z5.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1572
G1 X122.299 Y116.351 E.18147
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y122.444 E.18147
G1 X122.239 Y122.444 E.03686
G1 X121.88 Y122.025 F30000
; LINE_WIDTH: 0.50319
G1 F1572
G1 X121.88 Y116.77 E.19106
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y122.025 E.19106
G1 X121.82 Y122.025 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3600
G1 X121.42 Y122.025 E-.1521
G1 X121.42 Y120.425 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 47/152
; update layer progress
M73 L47
M991 S0 P46 ;notify layer change
G17
G3 Z6.2 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z6
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1542
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z6.4 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z6.4
G1 Z6
G1 E.8 F1800
G1 F1542
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z6.4 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z6.4
G1 Z6
G1 E.8 F1800
G1 F1542
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z6.4 I.346 J1.167 P1  F30000
G1 X133.309 Y115.959 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1542
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y122.604 E.21368
G1 X133.309 Y122.604 E.06694
G1 X133.309 Y115.999 E.21239
G1 X132.902 Y115.552 F30000
G1 F1542
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y123.011 E.23986
G1 X132.902 Y123.011 E.09312
G1 X132.902 Y115.592 E.23857
G1 X132.495 Y115.145 F30000
G1 F1542
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y123.418 E.26604
G1 X132.495 Y123.418 E.1193
G1 X132.495 Y115.185 E.26475
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1542
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y123.853 E.27234
G1 X132.06 Y123.853 E.13642
G1 X132.06 Y114.75 E.27115
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y122.212 Z6.4 F30000
G1 Z6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1542
G1 X134.999 Y122.212 E.03865
G1 X134.999 Y116.351 E.17457
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y122.152 E.17278
G1 X134.12 Y121.793 F30000
; LINE_WIDTH: 0.50318
G1 F1542
G1 X134.58 Y121.793 E.01673
G1 X134.58 Y116.77 E.18264
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y121.733 E.18046
; WIPE_START
G1 F3600
G1 X134.12 Y119.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y121.593 Z6.4 F30000
G1 X122.691 Y122.604 Z6.4
G1 Z6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1542
G1 X120.609 Y122.604 E.06694
G1 X120.609 Y115.959 E.21368
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y122.564 E.21239
G1 X123.098 Y123.011 F30000
G1 F1542
G1 X120.202 Y123.011 E.09312
G1 X120.202 Y115.552 E.23986
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y122.971 E.23857
G1 X123.505 Y123.418 F30000
G1 F1542
G1 X119.795 Y123.418 E.1193
G1 X119.795 Y115.145 E.26604
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y123.378 E.26475
M204 S250
G1 X123.94 Y123.853 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1542
M204 S5000
G1 X119.36 Y123.853 E.13642
G1 X119.36 Y114.71 E.27234
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y123.813 E.27115
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y123.831 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y122.212 Z6.4 F30000
G1 Z6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1542
G1 X122.299 Y116.351 E.17457
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y122.212 E.17457
G1 X122.239 Y122.212 E.03686
G1 X121.88 Y121.793 F30000
; LINE_WIDTH: 0.50319
G1 F1542
G1 X121.88 Y116.77 E.18264
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y121.793 E.18264
G1 X121.82 Y121.793 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 6.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3600
G1 X121.42 Y121.793 E-.1521
G1 X121.42 Y120.194 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 48/152
; update layer progress
M73 L48
M991 S0 P47 ;notify layer change
M106 S153
G17
G3 Z6.4 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y122.372 E.20623
G1 X133.309 Y122.372 E.06694
G1 X133.309 Y115.999 E.20494
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y122.78 E.23241
G1 X132.902 Y122.78 E.09312
G1 X132.902 Y115.592 E.23112
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y123.187 E.25859
G1 X132.495 Y123.187 E.1193
G1 X132.495 Y115.185 E.2573
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y123.622 E.26545
G1 X132.06 Y123.622 E.13642
G1 X132.06 Y114.75 E.26425
; WIPE_START
G1 F2400
M204 S10000
M73 P67 R9
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y121.98 Z6.6 F30000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y121.98 E.03865
G1 X134.999 Y116.351 E.16767
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y121.92 E.16588
G1 X134.12 Y121.562 F30000
; LINE_WIDTH: 0.50318
G1 F1200
G1 X134.58 Y121.562 E.01673
G1 X134.58 Y116.77 E.17422
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y121.502 E.17204
; WIPE_START
G1 F3600
G1 X134.12 Y119.502 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y121.361 Z6.6 F30000
G1 X122.691 Y122.372 Z6.6
G1 Z6.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y122.372 E.06694
G1 X120.609 Y115.959 E.20623
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y122.332 E.20494
G1 X123.098 Y122.78 F30000
G1 F1200
G1 X120.202 Y122.78 E.09312
G1 X120.202 Y115.552 E.23241
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y122.74 E.23112
G1 X123.505 Y123.187 F30000
G1 F1200
G1 X119.795 Y123.187 E.1193
G1 X119.795 Y115.145 E.25859
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y123.147 E.2573
M204 S250
G1 X123.94 Y123.622 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y123.622 E.13642
G1 X119.36 Y114.71 E.26545
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y123.582 E.26425
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y123.599 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y121.98 Z6.6 F30000
G1 Z6.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.16767
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y121.98 E.16767
G1 X122.239 Y121.98 E.03686
G1 X121.88 Y121.562 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X121.88 Y116.77 E.17422
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y121.562 E.17422
G1 X121.82 Y121.562 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 6.27273
; LAYER_HEIGHT: 0.0727277
; WIPE_START
G1 F3600
G1 X121.42 Y121.562 E-.1521
G1 X121.42 Y119.962 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 49/152
; update layer progress
M73 L49
M991 S0 P48 ;notify layer change
M106 S150.45
G17
G3 Z6.6 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z6.273
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1483
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z6.673 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z6.673
G1 Z6.273
G1 E.8 F1800
G1 F1483
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z6.673 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z6.673
G1 Z6.273
G1 E.8 F1800
G1 F1483
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 6.4
; LAYER_HEIGHT: 0.127273
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 50/152
; update layer progress
M73 L50
M991 S0 P49 ;notify layer change
G17
G3 Z6.673 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1483
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y122.141 E.19878
G1 X133.309 Y122.141 E.06694
G1 X133.309 Y115.999 E.1975
G1 X132.902 Y115.552 F30000
G1 F1483
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y122.548 E.22496
G1 X132.902 Y122.548 E.09312
G1 X132.902 Y115.592 E.22368
G1 X132.495 Y115.145 F30000
G1 F1483
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y122.955 E.25114
G1 X132.495 Y122.955 E.1193
G1 X132.495 Y115.185 E.24986
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1483
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y123.39 E.25855
G1 X132.06 Y123.39 E.13642
G1 X132.06 Y114.75 E.25736
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y121.749 Z6.8 F30000
G1 Z6.4
M73 P68 R9
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1483
G1 X134.999 Y121.749 E.03865
G1 X134.999 Y116.351 E.16077
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y121.689 E.15899
G1 X134.12 Y121.33 F30000
; LINE_WIDTH: 0.50318
G1 F1483
G1 X134.58 Y121.33 E.01673
G1 X134.58 Y116.77 E.1658
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y121.27 E.16362
; WIPE_START
G1 F3600
G1 X134.12 Y119.27 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y121.129 Z6.8 F30000
G1 X122.691 Y122.141 Z6.8
G1 Z6.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1483
G1 X120.609 Y122.141 E.06694
G1 X120.609 Y115.959 E.19878
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y122.101 E.1975
G1 X123.098 Y122.548 F30000
G1 F1483
G1 X120.202 Y122.548 E.09312
G1 X120.202 Y115.552 E.22496
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y122.508 E.22368
G1 X123.505 Y122.955 F30000
G1 F1483
G1 X119.795 Y122.955 E.1193
G1 X119.795 Y115.145 E.25114
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y122.915 E.24986
M204 S250
G1 X123.94 Y123.39 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1483
M204 S5000
G1 X119.36 Y123.39 E.13642
G1 X119.36 Y114.71 E.25855
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y123.35 E.25736
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y123.367 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y121.749 Z6.8 F30000
G1 Z6.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1483
G1 X122.299 Y116.351 E.16077
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y121.749 E.16077
G1 X122.239 Y121.749 E.03686
G1 X121.88 Y121.33 F30000
; LINE_WIDTH: 0.50319
G1 F1483
G1 X121.88 Y116.77 E.1658
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y121.33 E.1658
G1 X121.82 Y121.33 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 6.54545
; LAYER_HEIGHT: 0.145454
; WIPE_START
G1 F3600
G1 X121.42 Y121.33 E-.1521
G1 X121.42 Y119.73 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 51/152
; update layer progress
M73 L51
M991 S0 P50 ;notify layer change
G17
G3 Z6.8 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z6.545
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1453
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z6.945 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z6.945
G1 Z6.545
G1 E.8 F1800
G1 F1453
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z6.945 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z6.945
G1 Z6.545
G1 E.8 F1800
G1 F1453
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 6.6
; LAYER_HEIGHT: 0.0545454
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 52/152
; update layer progress
M73 L52
M991 S0 P51 ;notify layer change
G17
G3 Z6.945 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1453
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y121.909 E.19134
G1 X133.309 Y121.909 E.06694
G1 X133.309 Y115.999 E.19005
G1 X132.902 Y115.552 F30000
G1 F1453
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y122.316 E.21752
G1 X132.902 Y122.316 E.09312
G1 X132.902 Y115.592 E.21623
G1 X132.495 Y115.145 F30000
G1 F1453
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y122.723 E.24369
G1 X132.495 Y122.723 E.1193
G1 X132.495 Y115.185 E.24241
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1453
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y123.158 E.25165
G1 X132.06 Y123.158 E.13642
G1 X132.06 Y114.75 E.25046
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y121.517 Z7 F30000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1453
G1 X134.999 Y121.517 E.03865
G1 X134.999 Y116.351 E.15387
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y121.457 E.15209
G1 X134.12 Y121.099 F30000
; LINE_WIDTH: 0.50318
G1 F1453
G1 X134.58 Y121.099 E.01673
G1 X134.58 Y116.77 E.15738
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y121.039 E.1552
; WIPE_START
G1 F3600
G1 X134.12 Y119.039 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y120.898 Z7 F30000
G1 X122.691 Y121.909 Z7
G1 Z6.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1453
G1 X120.609 Y121.909 E.06694
G1 X120.609 Y115.959 E.19134
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y121.869 E.19005
G1 X123.098 Y122.316 F30000
G1 F1453
G1 X120.202 Y122.316 E.09312
G1 X120.202 Y115.552 E.21752
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y122.276 E.21623
G1 X123.505 Y122.723 F30000
G1 F1453
G1 X119.795 Y122.723 E.1193
G1 X119.795 Y115.145 E.24369
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y122.683 E.24241
M204 S250
G1 X123.94 Y123.158 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1453
M204 S5000
G1 X119.36 Y123.158 E.13642
G1 X119.36 Y114.71 E.25165
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y123.118 E.25046
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y123.136 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y121.517 Z7 F30000
G1 Z6.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1453
G1 X122.299 Y116.351 E.15387
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y121.517 E.15387
M73 P68 R8
G1 X122.239 Y121.517 E.03686
G1 X121.88 Y121.099 F30000
; LINE_WIDTH: 0.50319
G1 F1453
G1 X121.88 Y116.77 E.15738
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y121.099 E.15738
G1 X121.82 Y121.099 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 6.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3600
G1 X121.42 Y121.099 E-.1521
G1 X121.42 Y119.499 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 53/152
; update layer progress
M73 L53
M991 S0 P52 ;notify layer change
M106 S153
G17
G3 Z7 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
M73 P69 R8
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y121.678 E.18389
G1 X133.309 Y121.678 E.06694
G1 X133.309 Y115.999 E.1826
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y122.085 E.21007
G1 X132.902 Y122.085 E.09312
G1 X132.902 Y115.592 E.20878
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y122.492 E.23625
G1 X132.495 Y122.492 E.1193
G1 X132.495 Y115.185 E.23496
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y122.927 E.24475
G1 X132.06 Y122.927 E.13642
G1 X132.06 Y114.75 E.24356
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y121.286 Z7.2 F30000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y121.286 E.03865
G1 X134.999 Y116.351 E.14698
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y121.226 E.14519
G1 X134.12 Y120.867 F30000
; LINE_WIDTH: 0.50318
G1 F1200
G1 X134.58 Y120.867 E.01673
G1 X134.58 Y116.77 E.14896
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y120.807 E.14678
; WIPE_START
G1 F3600
G1 X134.12 Y118.807 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y120.666 Z7.2 F30000
G1 X122.691 Y121.678 Z7.2
G1 Z6.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y121.678 E.06694
G1 X120.609 Y115.959 E.18389
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y121.638 E.1826
G1 X123.098 Y122.085 F30000
G1 F1200
G1 X120.202 Y122.085 E.09312
G1 X120.202 Y115.552 E.21007
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y122.045 E.20878
G1 X123.505 Y122.492 F30000
G1 F1200
G1 X119.795 Y122.492 E.1193
G1 X119.795 Y115.145 E.23625
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y122.452 E.23496
M204 S250
G1 X123.94 Y122.927 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y122.927 E.13642
G1 X119.36 Y114.71 E.24475
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y122.887 E.24356
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y122.904 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y121.286 Z7.2 F30000
G1 Z6.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.14698
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y121.286 E.14698
G1 X122.239 Y121.286 E.03686
G1 X121.88 Y120.867 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X121.88 Y116.77 E.14896
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y120.867 E.14896
G1 X121.82 Y120.867 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 6.81818
; LAYER_HEIGHT: 0.0181818
; WIPE_START
G1 F3600
G1 X121.42 Y120.867 E-.1521
G1 X121.42 Y119.267 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 54/152
; update layer progress
M73 L54
M991 S0 P53 ;notify layer change
M106 S150.45
G17
G3 Z7.2 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z6.818
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1393
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z7.218 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z7.218
G1 Z6.818
G1 E.8 F1800
G1 F1393
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z7.218 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z7.218
G1 Z6.818
G1 E.8 F1800
G1 F1393
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 7
; LAYER_HEIGHT: 0.181818
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 55/152
; update layer progress
M73 L55
M991 S0 P54 ;notify layer change
G17
G3 Z7.218 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1393
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y121.446 E.17644
G1 X133.309 Y121.446 E.06694
G1 X133.309 Y115.999 E.17516
G1 X132.902 Y115.552 F30000
G1 F1393
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y121.853 E.20262
G1 X132.902 Y121.853 E.09312
G1 X132.902 Y115.592 E.20134
G1 X132.495 Y115.145 F30000
G1 F1393
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y122.26 E.2288
G1 X132.495 Y122.26 E.1193
G1 X132.495 Y115.185 E.22751
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1393
M204 S5000
M73 P70 R8
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y122.695 E.23785
G1 X132.06 Y122.695 E.13642
G1 X132.06 Y114.75 E.23666
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y121.054 Z7.4 F30000
G1 Z7
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1393
G1 X134.999 Y121.054 E.03865
G1 X134.999 Y116.351 E.14008
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y120.994 E.13829
G1 X134.12 Y120.635 F30000
; LINE_WIDTH: 0.50318
G1 F1393
G1 X134.58 Y120.635 E.01673
G1 X134.58 Y116.77 E.14054
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y120.575 E.13836
; WIPE_START
G1 F3600
G1 X134.12 Y118.575 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y120.435 Z7.4 F30000
G1 X122.691 Y121.446 Z7.4
G1 Z7
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1393
G1 X120.609 Y121.446 E.06694
G1 X120.609 Y115.959 E.17644
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y121.406 E.17516
G1 X123.098 Y121.853 F30000
G1 F1393
G1 X120.202 Y121.853 E.09312
G1 X120.202 Y115.552 E.20262
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y121.813 E.20134
G1 X123.505 Y122.26 F30000
G1 F1393
G1 X119.795 Y122.26 E.1193
G1 X119.795 Y115.145 E.2288
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y122.22 E.22751
M204 S250
G1 X123.94 Y122.695 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1393
M204 S5000
G1 X119.36 Y122.695 E.13642
G1 X119.36 Y114.71 E.23785
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y122.655 E.23666
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y122.673 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y121.054 Z7.4 F30000
G1 Z7
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1393
G1 X122.299 Y116.351 E.14008
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y121.054 E.14008
G1 X122.239 Y121.054 E.03686
G1 X121.88 Y120.635 F30000
; LINE_WIDTH: 0.50319
G1 F1393
G1 X121.88 Y116.77 E.14054
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y120.635 E.14054
G1 X121.82 Y120.635 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 7.09091
; LAYER_HEIGHT: 0.090909
; WIPE_START
G1 F3600
G1 X121.42 Y120.635 E-.1521
G1 X121.42 Y119.036 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 56/152
; update layer progress
M73 L56
M991 S0 P55 ;notify layer change
G17
G3 Z7.4 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z7.091
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1364
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z7.491 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z7.491
G1 Z7.091
G1 E.8 F1800
G1 F1364
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z7.491 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z7.491
G1 Z7.091
G1 E.8 F1800
G1 F1364
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 7.2
; LAYER_HEIGHT: 0.109091
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 57/152
; update layer progress
M73 L57
M991 S0 P56 ;notify layer change
G17
G3 Z7.491 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1364
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y121.215 E.16899
G1 X133.309 Y121.215 E.06694
G1 X133.309 Y115.999 E.16771
G1 X132.902 Y115.552 F30000
G1 F1364
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y121.622 E.19517
G1 X132.902 Y121.622 E.09312
G1 X132.902 Y115.592 E.19389
G1 X132.495 Y115.145 F30000
G1 F1364
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y122.029 E.22135
G1 X132.495 Y122.029 E.1193
G1 X132.495 Y115.185 E.22007
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1364
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y122.464 E.23096
G1 X132.06 Y122.464 E.13642
G1 X132.06 Y114.75 E.22976
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y120.822 Z7.6 F30000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1364
G1 X134.999 Y120.822 E.03865
G1 X134.999 Y116.351 E.13318
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y120.762 E.13139
G1 X134.12 Y120.404 F30000
; LINE_WIDTH: 0.50318
G1 F1364
G1 X134.58 Y120.404 E.01673
G1 X134.58 Y116.77 E.13212
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y120.344 E.12994
; WIPE_START
G1 F3600
G1 X134.12 Y118.344 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y120.203 Z7.6 F30000
G1 X122.691 Y121.215 Z7.6
G1 Z7.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1364
G1 X120.609 Y121.215 E.06694
G1 X120.609 Y115.959 E.16899
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y121.175 E.16771
G1 X123.098 Y121.622 F30000
G1 F1364
G1 X120.202 Y121.622 E.09312
G1 X120.202 Y115.552 E.19517
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y121.582 E.19389
G1 X123.505 Y122.029 F30000
G1 F1364
G1 X119.795 Y122.029 E.1193
G1 X119.795 Y115.145 E.22135
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y121.989 E.22007
M204 S250
M73 P71 R8
G1 X123.94 Y122.464 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1364
M204 S5000
G1 X119.36 Y122.464 E.13642
G1 X119.36 Y114.71 E.23096
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y122.424 E.22976
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y122.441 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y120.822 Z7.6 F30000
G1 Z7.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1364
G1 X122.299 Y116.351 E.13318
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y120.822 E.13318
G1 X122.239 Y120.822 E.03686
G1 X121.88 Y120.404 F30000
; LINE_WIDTH: 0.50319
G1 F1364
G1 X121.88 Y116.77 E.13212
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y120.404 E.13212
G1 X121.82 Y120.404 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 7.36364
; LAYER_HEIGHT: 0.163637
; WIPE_START
G1 F3600
G1 X121.42 Y120.404 E-.1521
G1 X121.42 Y118.804 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 58/152
; update layer progress
M73 L58
M991 S0 P57 ;notify layer change
G17
G3 Z7.6 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z7.364
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1334
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z7.764 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z7.764
G1 Z7.364
G1 E.8 F1800
G1 F1334
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z7.764 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z7.764
G1 Z7.364
G1 E.8 F1800
G1 F1334
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 7.4
; LAYER_HEIGHT: 0.0363636
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 59/152
; update layer progress
M73 L59
M991 S0 P58 ;notify layer change
G17
G3 Z7.764 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1334
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y120.983 E.16155
G1 X133.309 Y120.983 E.06694
G1 X133.309 Y115.999 E.16026
G1 X132.902 Y115.552 F30000
G1 F1334
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y121.39 E.18773
G1 X132.902 Y121.39 E.09312
G1 X132.902 Y115.592 E.18644
G1 X132.495 Y115.145 F30000
G1 F1334
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y121.797 E.21391
G1 X132.495 Y121.797 E.1193
G1 X132.495 Y115.185 E.21262
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1334
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y122.232 E.22406
G1 X132.06 Y122.232 E.13642
G1 X132.06 Y114.75 E.22287
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y120.591 Z7.8 F30000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1334
G1 X134.999 Y120.591 E.03865
G1 X134.999 Y116.351 E.12628
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y120.531 E.1245
G1 X134.12 Y120.172 F30000
; LINE_WIDTH: 0.50318
G1 F1334
G1 X134.58 Y120.172 E.01673
G1 X134.58 Y116.77 E.1237
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y120.112 E.12152
; WIPE_START
G1 F3600
G1 X134.12 Y118.112 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y119.972 Z7.8 F30000
G1 X122.691 Y120.983 Z7.8
G1 Z7.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1334
G1 X120.609 Y120.983 E.06694
G1 X120.609 Y115.959 E.16155
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y120.943 E.16026
G1 X123.098 Y121.39 F30000
G1 F1334
G1 X120.202 Y121.39 E.09312
G1 X120.202 Y115.552 E.18773
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y121.35 E.18644
G1 X123.505 Y121.797 F30000
G1 F1334
G1 X119.795 Y121.797 E.1193
G1 X119.795 Y115.145 E.21391
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y121.757 E.21262
M204 S250
G1 X123.94 Y122.232 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1334
M204 S5000
G1 X119.36 Y122.232 E.13642
G1 X119.36 Y114.71 E.22406
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y122.192 E.22287
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y122.21 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y120.591 Z7.8 F30000
G1 Z7.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1334
G1 X122.299 Y116.351 E.12628
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y120.591 E.12628
G1 X122.239 Y120.591 E.03686
G1 X121.88 Y120.172 F30000
; LINE_WIDTH: 0.50319
G1 F1334
G1 X121.88 Y116.77 E.1237
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y120.172 E.1237
G1 X121.82 Y120.172 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 7.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3600
G1 X121.42 Y120.172 E-.1521
G1 X121.42 Y118.573 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 60/152
; update layer progress
M73 L60
M991 S0 P59 ;notify layer change
M106 S153
G17
G3 Z7.8 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y120.751 E.1541
G1 X133.309 Y120.751 E.06694
G1 X133.309 Y115.999 E.15282
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y121.158 E.18028
G1 X132.902 Y121.158 E.09312
G1 X132.902 Y115.592 E.179
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y121.566 E.20646
G1 X132.495 Y121.566 E.1193
G1 X132.495 Y115.185 E.20518
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y122.001 E.21716
G1 X132.06 Y122.001 E.13642
G1 X132.06 Y114.75 E.21597
; WIPE_START
M73 P72 R8
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y120.359 Z8 F30000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y120.359 E.03865
G1 X134.999 Y116.351 E.11939
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y120.299 E.1176
G1 X134.12 Y119.941 F30000
; LINE_WIDTH: 0.50318
G1 F1200
G1 X134.58 Y119.941 E.01673
G1 X134.58 Y116.77 E.11528
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y119.881 E.1131
; WIPE_START
G1 F3600
G1 X134.12 Y117.881 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y119.74 Z8 F30000
G1 X122.691 Y120.751 Z8
G1 Z7.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y120.751 E.06694
G1 X120.609 Y115.959 E.1541
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y120.711 E.15282
G1 X123.098 Y121.158 F30000
G1 F1200
G1 X120.202 Y121.158 E.09312
G1 X120.202 Y115.552 E.18028
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y121.118 E.179
G1 X123.505 Y121.566 F30000
G1 F1200
G1 X119.795 Y121.566 E.1193
G1 X119.795 Y115.145 E.20646
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y121.526 E.20518
M204 S250
G1 X123.94 Y122.001 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y122.001 E.13642
G1 X119.36 Y114.71 E.21716
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y121.961 E.21597
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y121.978 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y120.359 Z8 F30000
G1 Z7.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.11939
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y120.359 E.11939
G1 X122.239 Y120.359 E.03686
G1 X121.88 Y119.941 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X121.88 Y116.77 E.11528
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y119.941 E.11528
G1 X121.82 Y119.941 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 7.63636
; LAYER_HEIGHT: 0.0363636
; WIPE_START
G1 F3600
G1 X121.42 Y119.941 E-.1521
G1 X121.42 Y118.341 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 61/152
; update layer progress
M73 L61
M991 S0 P60 ;notify layer change
M106 S150.45
G17
G3 Z8 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z7.636
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1274
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
M73 P72 R7
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z8.036 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z8.036
G1 Z7.636
G1 E.8 F1800
G1 F1274
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z8.036 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z8.036
G1 Z7.636
G1 E.8 F1800
G1 F1274
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 7.8
; LAYER_HEIGHT: 0.163637
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 62/152
; update layer progress
M73 L62
M991 S0 P61 ;notify layer change
G17
G3 Z8.036 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1274
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y120.52 E.14665
G1 X133.309 Y120.52 E.06694
G1 X133.309 Y115.999 E.14537
G1 X132.902 Y115.552 F30000
G1 F1274
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y120.927 E.17283
G1 X132.902 Y120.927 E.09312
G1 X132.902 Y115.592 E.17155
G1 X132.495 Y115.145 F30000
G1 F1274
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y121.334 E.19901
G1 X132.495 Y121.334 E.1193
G1 X132.495 Y115.185 E.19773
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1274
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y121.769 E.21026
G1 X132.06 Y121.769 E.13642
G1 X132.06 Y114.75 E.20907
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y120.128 Z8.2 F30000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1274
G1 X134.999 Y120.128 E.03865
G1 X134.999 Y116.351 E.11249
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y120.068 E.1107
G1 X134.12 Y119.709 F30000
; LINE_WIDTH: 0.50319
G1 F1274
G1 X134.58 Y119.709 E.01673
G1 X134.58 Y116.77 E.10686
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y119.649 E.10468
; WIPE_START
G1 F3600
G1 X134.12 Y117.649 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y119.508 Z8.2 F30000
G1 X122.691 Y120.52 Z8.2
G1 Z7.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1274
G1 X120.609 Y120.52 E.06694
G1 X120.609 Y115.959 E.14665
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y120.48 E.14537
G1 X123.098 Y120.927 F30000
G1 F1274
G1 X120.202 Y120.927 E.09312
G1 X120.202 Y115.552 E.17283
G1 X123.098 Y115.552 E.09312
M73 P73 R7
G1 X123.098 Y120.887 E.17155
G1 X123.505 Y121.334 F30000
G1 F1274
G1 X119.795 Y121.334 E.1193
G1 X119.795 Y115.145 E.19901
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y121.294 E.19773
M204 S250
G1 X123.94 Y121.769 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1274
M204 S5000
G1 X119.36 Y121.769 E.13642
G1 X119.36 Y114.71 E.21026
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y121.729 E.20907
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y121.746 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y120.128 Z8.2 F30000
G1 Z7.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1274
G1 X122.299 Y116.351 E.11249
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y120.128 E.11249
G1 X122.239 Y120.128 E.03686
G1 X121.88 Y119.709 F30000
; LINE_WIDTH: 0.50318
G1 F1274
G1 X121.88 Y116.77 E.10686
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y119.709 E.10686
G1 X121.82 Y119.709 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 7.90909
; LAYER_HEIGHT: 0.109091
; WIPE_START
G1 F3600
G1 X121.42 Y119.709 E-.1521
G1 X121.42 Y118.109 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 63/152
; update layer progress
M73 L63
M991 S0 P62 ;notify layer change
G17
G3 Z8.2 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z7.909
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1244
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z8.309 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z8.309
G1 Z7.909
G1 E.8 F1800
G1 F1244
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z8.309 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z8.309
G1 Z7.909
G1 E.8 F1800
G1 F1244
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 8
; LAYER_HEIGHT: 0.090909
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 64/152
; update layer progress
M73 L64
M991 S0 P63 ;notify layer change
G17
G3 Z8.309 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1244
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y120.288 E.13921
G1 X133.309 Y120.288 E.06694
G1 X133.309 Y115.999 E.13792
G1 X132.902 Y115.552 F30000
G1 F1244
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y120.695 E.16539
G1 X132.902 Y120.695 E.09312
G1 X132.902 Y115.592 E.1641
G1 X132.495 Y115.145 F30000
G1 F1244
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y121.102 E.19157
G1 X132.495 Y121.102 E.1193
G1 X132.495 Y115.185 E.19028
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1244
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y121.537 E.20336
G1 X132.06 Y121.537 E.13642
G1 X132.06 Y114.75 E.20217
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y119.896 Z8.4 F30000
G1 Z8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1244
G1 X134.999 Y119.896 E.03865
G1 X134.999 Y116.351 E.10559
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y119.836 E.1038
G1 X134.12 Y119.477 F30000
; LINE_WIDTH: 0.50318
G1 F1244
G1 X134.58 Y119.477 E.01673
G1 X134.58 Y116.77 E.09844
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y119.417 E.09626
; WIPE_START
G1 F3600
G1 X134.12 Y117.417 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y119.277 Z8.4 F30000
G1 X122.691 Y120.288 Z8.4
G1 Z8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1244
G1 X120.609 Y120.288 E.06694
G1 X120.609 Y115.959 E.13921
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y120.248 E.13792
G1 X123.098 Y120.695 F30000
G1 F1244
G1 X120.202 Y120.695 E.09312
G1 X120.202 Y115.552 E.16539
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y120.655 E.1641
G1 X123.505 Y121.102 F30000
G1 F1244
G1 X119.795 Y121.102 E.1193
G1 X119.795 Y115.145 E.19157
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y121.062 E.19028
M204 S250
G1 X123.94 Y121.537 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1244
M204 S5000
G1 X119.36 Y121.537 E.13642
G1 X119.36 Y114.71 E.20336
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y121.497 E.20217
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y121.515 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y119.896 Z8.4 F30000
G1 Z8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1244
G1 X122.299 Y116.351 E.10559
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y119.896 E.10559
G1 X122.239 Y119.896 E.03686
G1 X121.88 Y119.477 F30000
; LINE_WIDTH: 0.50319
G1 F1244
G1 X121.88 Y116.77 E.09844
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y119.477 E.09844
G1 X121.82 Y119.477 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 8.18182
; LAYER_HEIGHT: 0.181818
; WIPE_START
G1 F3600
G1 X121.42 Y119.477 E-.1521
G1 X121.42 Y117.878 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 65/152
; update layer progress
M73 L65
M991 S0 P64 ;notify layer change
G17
G3 Z8.4 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z8.182
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1215
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z8.582 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z8.582
G1 Z8.182
M73 P74 R7
G1 E.8 F1800
G1 F1215
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z8.582 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z8.582
G1 Z8.182
G1 E.8 F1800
G1 F1215
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 8.2
; LAYER_HEIGHT: 0.0181818
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 66/152
; update layer progress
M73 L66
M991 S0 P65 ;notify layer change
G17
G3 Z8.582 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1215
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y120.057 E.13176
G1 X133.309 Y120.057 E.06694
G1 X133.309 Y115.999 E.13048
G1 X132.902 Y115.552 F30000
G1 F1215
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y120.464 E.15794
G1 X132.902 Y120.464 E.09312
G1 X132.902 Y115.592 E.15665
G1 X132.495 Y115.145 F30000
G1 F1215
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y120.871 E.18412
G1 X132.495 Y120.871 E.1193
G1 X132.495 Y115.185 E.18283
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1215
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y121.306 E.19647
G1 X132.06 Y121.306 E.13642
G1 X132.06 Y114.75 E.19527
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y119.665 Z8.6 F30000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1215
G1 X134.999 Y119.665 E.03865
G1 X134.999 Y116.351 E.09869
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y119.605 E.0969
G1 X134.12 Y119.246 F30000
; LINE_WIDTH: 0.50318
G1 F1215
G1 X134.58 Y119.246 E.01673
G1 X134.58 Y116.77 E.09002
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y119.186 E.08784
; WIPE_START
G1 F3600
G1 X134.12 Y117.186 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y119.045 Z8.6 F30000
G1 X122.691 Y120.057 Z8.6
G1 Z8.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1215
G1 X120.609 Y120.057 E.06694
G1 X120.609 Y115.959 E.13176
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y120.017 E.13048
G1 X123.098 Y120.464 F30000
G1 F1215
G1 X120.202 Y120.464 E.09312
G1 X120.202 Y115.552 E.15794
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y120.424 E.15665
G1 X123.505 Y120.871 F30000
G1 F1215
G1 X119.795 Y120.871 E.1193
G1 X119.795 Y115.145 E.18412
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y120.831 E.18283
M204 S250
G1 X123.94 Y121.306 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1215
M204 S5000
G1 X119.36 Y121.306 E.13642
G1 X119.36 Y114.71 E.19647
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y121.266 E.19527
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y121.283 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y119.665 Z8.6 F30000
G1 Z8.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1215
G1 X122.299 Y116.351 E.09869
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y119.665 E.09869
G1 X122.239 Y119.665 E.03686
G1 X121.88 Y119.246 F30000
; LINE_WIDTH: 0.50319
G1 F1215
G1 X121.88 Y116.77 E.09002
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y119.246 E.09002
G1 X121.82 Y119.246 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 8.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3600
G1 X121.42 Y119.246 E-.1521
G1 X121.42 Y117.646 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 67/152
; update layer progress
M73 L67
M991 S0 P66 ;notify layer change
M106 S153
G17
G3 Z8.6 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y119.825 E.12431
G1 X133.309 Y119.825 E.06694
G1 X133.309 Y115.999 E.12303
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y120.232 E.15049
G1 X132.902 Y120.232 E.09312
G1 X132.902 Y115.592 E.14921
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y120.639 E.17667
G1 X132.495 Y120.639 E.1193
G1 X132.495 Y115.185 E.17539
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y121.074 E.18957
G1 X132.06 Y121.074 E.13642
G1 X132.06 Y114.75 E.18838
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y119.433 Z8.8 F30000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y119.433 E.03865
G1 X134.999 Y116.351 E.09179
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y119.373 E.09001
G1 X134.12 Y119.014 F30000
; LINE_WIDTH: 0.50318
G1 F1200
G1 X134.58 Y119.014 E.01673
G1 X134.58 Y116.77 E.0816
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y118.954 E.07942
; WIPE_START
G1 F3600
G1 X134.12 Y116.954 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.717 Y118.814 Z8.8 F30000
G1 X122.691 Y119.825 Z8.8
G1 Z8.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y119.825 E.06694
G1 X120.609 Y115.959 E.12431
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y119.785 E.12303
G1 X123.098 Y120.232 F30000
G1 F1200
G1 X120.202 Y120.232 E.09312
G1 X120.202 Y115.552 E.15049
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y120.192 E.14921
G1 X123.505 Y120.639 F30000
G1 F1200
G1 X119.795 Y120.639 E.1193
G1 X119.795 Y115.145 E.17667
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y120.599 E.17539
M204 S250
G1 X123.94 Y121.074 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P75 R7
G1 F1200
M204 S5000
G1 X119.36 Y121.074 E.13642
G1 X119.36 Y114.71 E.18957
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y121.034 E.18838
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y121.052 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y119.433 Z8.8 F30000
G1 Z8.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.09179
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y119.433 E.09179
G1 X122.239 Y119.433 E.03686
G1 X121.88 Y119.014 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X121.88 Y116.77 E.0816
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y119.014 E.0816
G1 X121.82 Y119.014 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 8.45455
; LAYER_HEIGHT: 0.0545454
; WIPE_START
G1 F3600
G1 X121.42 Y119.014 E-.1521
G1 X121.42 Y117.415 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 68/152
; update layer progress
M73 L68
M991 S0 P67 ;notify layer change
G17
G3 Z8.8 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z8.455
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z8.855 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z8.855
G1 Z8.455
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z8.855 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z8.855
G1 Z8.455
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 8.6
; LAYER_HEIGHT: 0.145455
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 69/152
; update layer progress
M73 L69
M991 S0 P68 ;notify layer change
G17
G3 Z8.855 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y119.593 E.11687
G1 X133.309 Y119.593 E.06694
G1 X133.309 Y115.999 E.11558
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y120.001 E.14305
G1 X132.902 Y120.001 E.09312
G1 X132.902 Y115.592 E.14176
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y120.408 E.16923
G1 X132.495 Y120.408 E.1193
G1 X132.495 Y115.185 E.16794
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y120.843 E.18267
G1 X132.06 Y120.843 E.13642
G1 X132.06 Y114.75 E.18148
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y119.201 Z9 F30000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y119.201 E.03865
G1 X134.999 Y116.351 E.0849
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y119.141 E.08311
G1 X134.12 Y118.783 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X134.58 Y118.783 E.01673
G1 X134.58 Y116.77 E.07319
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y118.723 E.071
; WIPE_START
G1 F3600
G1 X134.12 Y116.77 E-.7421
G1 X134.167 Y116.77 E-.0179
; WIPE_END
G1 E-.04 F1800
G1 X126.756 Y118.593 Z9 F30000
G1 X122.691 Y119.593 Z9
G1 Z8.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y119.593 E.06694
G1 X120.609 Y115.959 E.11687
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y119.553 E.11558
G1 X123.098 Y120.001 F30000
G1 F1200
G1 X120.202 Y120.001 E.09312
G1 X120.202 Y115.552 E.14305
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y119.961 E.14176
G1 X123.505 Y120.408 F30000
G1 F1200
G1 X119.795 Y120.408 E.1193
G1 X119.795 Y115.145 E.16923
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y120.368 E.16794
M204 S250
G1 X123.94 Y120.843 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y120.843 E.13642
G1 X119.36 Y114.71 E.18267
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y120.803 E.18148
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y120.82 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y119.201 Z9 F30000
G1 Z8.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.0849
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y119.201 E.0849
G1 X122.239 Y119.201 E.03686
G1 X121.88 Y118.783 F30000
; LINE_WIDTH: 0.50318
G1 F1200
G1 X121.88 Y116.77 E.07318
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y118.783 E.07318
G1 X121.82 Y118.783 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 8.72727
; LAYER_HEIGHT: 0.127273
; WIPE_START
G1 F3600
M73 P75 R6
G1 X121.42 Y118.783 E-.1521
G1 X121.42 Y117.183 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 70/152
; update layer progress
M73 L70
M991 S0 P69 ;notify layer change
G17
G3 Z9 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z8.727
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z9.127 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z9.127
G1 Z8.727
G1 E.8 F1800
M73 P76 R6
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z9.127 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z9.127
G1 Z8.727
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 8.8
; LAYER_HEIGHT: 0.0727272
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 71/152
; update layer progress
M73 L71
M991 S0 P70 ;notify layer change
G17
G3 Z9.127 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y119.362 E.10942
G1 X133.309 Y119.362 E.06694
G1 X133.309 Y115.999 E.10813
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y119.769 E.1356
G1 X132.902 Y119.769 E.09312
G1 X132.902 Y115.592 E.13431
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y120.176 E.16178
G1 X132.495 Y120.176 E.1193
G1 X132.495 Y115.185 E.16049
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y120.611 E.17577
G1 X132.06 Y120.611 E.13642
G1 X132.06 Y114.75 E.17458
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y118.97 Z9.2 F30000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y118.97 E.03865
G1 X134.999 Y116.351 E.078
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y118.91 E.07621
G1 X134.12 Y118.551 F30000
; LINE_WIDTH: 0.50318
G1 F1200
G1 X134.58 Y118.551 E.01673
G1 X134.58 Y116.77 E.06476
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y118.491 E.06258
; WIPE_START
G1 F3600
G1 X134.12 Y116.77 E-.6541
G1 X134.399 Y116.77 E-.1059
; WIPE_END
G1 E-.04 F1800
G1 X126.947 Y118.42 Z9.2 F30000
G1 X122.691 Y119.362 Z9.2
G1 Z8.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y119.362 E.06694
G1 X120.609 Y115.959 E.10942
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y119.322 E.10813
G1 X123.098 Y119.769 F30000
G1 F1200
G1 X120.202 Y119.769 E.09312
G1 X120.202 Y115.552 E.1356
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y119.729 E.13431
G1 X123.505 Y120.176 F30000
G1 F1200
G1 X119.795 Y120.176 E.1193
G1 X119.795 Y115.145 E.16178
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y120.136 E.16049
M204 S250
G1 X123.94 Y120.611 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y120.611 E.13642
G1 X119.36 Y114.71 E.17577
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y120.571 E.17458
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y120.589 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y118.97 Z9.2 F30000
G1 Z8.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.078
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y118.97 E.078
G1 X122.239 Y118.97 E.03686
G1 X121.88 Y118.551 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X121.88 Y116.77 E.06477
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y118.551 E.06477
G1 X121.82 Y118.551 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 9
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3600
G1 X121.42 Y118.551 E-.1521
G1 X121.42 Y116.951 E-.6079
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 72/152
; update layer progress
M73 L72
M991 S0 P71 ;notify layer change
G17
G3 Z9.2 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z9
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z9.4 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z9.4
G1 Z9
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z9.4 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z9.4
G1 Z9
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z9.4 I.346 J1.167 P1  F30000
G1 X133.309 Y115.959 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y119.13 E.10197
G1 X133.309 Y119.13 E.06694
G1 X133.309 Y115.999 E.10069
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y119.537 E.12815
G1 X132.902 Y119.537 E.09312
G1 X132.902 Y115.592 E.12687
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y119.944 E.15433
G1 X132.495 Y119.944 E.1193
G1 X132.495 Y115.185 E.15305
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y120.379 E.16887
G1 X132.06 Y120.379 E.13642
G1 X132.06 Y114.75 E.16768
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y118.738 Z9.4 F30000
M73 P77 R6
G1 Z9
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y118.738 E.03865
G1 X134.999 Y116.351 E.0711
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y118.678 E.06931
G1 X134.12 Y118.32 F30000
; LINE_WIDTH: 0.50318
G1 F1200
G1 X134.58 Y118.32 E.01673
G1 X134.58 Y116.77 E.05634
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y118.26 E.05416
; WIPE_START
G1 F3600
G1 X134.12 Y116.77 E-.5661
G1 X134.58 Y116.77 E-.1749
G1 X134.58 Y116.82 E-.019
; WIPE_END
G1 E-.04 F1800
G1 X127.088 Y118.276 Z9.4 F30000
G1 X122.691 Y119.13 Z9.4
G1 Z9
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y119.13 E.06694
G1 X120.609 Y115.959 E.10197
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y119.09 E.10069
G1 X123.098 Y119.537 F30000
G1 F1200
G1 X120.202 Y119.537 E.09312
G1 X120.202 Y115.552 E.12815
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y119.497 E.12687
G1 X123.505 Y119.944 F30000
G1 F1200
G1 X119.795 Y119.944 E.1193
G1 X119.795 Y115.145 E.15433
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y119.904 E.15305
M204 S250
G1 X123.94 Y120.379 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y120.379 E.13642
G1 X119.36 Y114.71 E.16887
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y120.339 E.16768
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y120.357 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y118.738 Z9.4 F30000
G1 Z9
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.0711
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y118.738 E.0711
G1 X122.239 Y118.738 E.03686
G1 X121.88 Y118.32 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X121.88 Y116.77 E.05635
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y118.32 E.05635
G1 X121.82 Y118.32 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 9.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3600
G1 X121.42 Y118.32 E-.1521
G1 X121.42 Y116.77 E-.5889
G1 X121.47 Y116.77 E-.019
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 73/152
; update layer progress
M73 L73
M991 S0 P72 ;notify layer change
G17
G3 Z9.4 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y118.899 E.09453
G1 X133.309 Y118.899 E.06694
G1 X133.309 Y115.999 E.09324
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y119.306 E.12071
G1 X132.902 Y119.306 E.09312
G1 X132.902 Y115.592 E.11942
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y119.713 E.14689
G1 X132.495 Y119.713 E.1193
G1 X132.495 Y115.185 E.1456
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y120.148 E.16198
G1 X132.06 Y120.148 E.13642
G1 X132.06 Y114.75 E.16078
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z9.6 I-1.212 J-.115 P1  F30000
G1 X133.701 Y118.507 Z9.6
G1 Z9.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y118.507 E.03865
G1 X134.999 Y116.351 E.0642
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y118.447 E.06242
G1 X134.12 Y118.088 F30000
; LINE_WIDTH: 0.50318
G1 F1200
G1 X134.58 Y118.088 E.01673
G1 X134.58 Y116.77 E.04792
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y118.028 E.04574
; WIPE_START
G1 F3600
G1 X134.12 Y116.77 E-.47809
G1 X134.58 Y116.77 E-.1749
G1 X134.58 Y117.051 E-.10701
; WIPE_END
G1 E-.04 F1800
G1 X127.038 Y118.223 Z9.6 F30000
G1 X122.691 Y118.899 Z9.6
G1 Z9.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y118.899 E.06694
G1 X120.609 Y115.959 E.09453
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y118.859 E.09324
G1 X123.098 Y119.306 F30000
G1 F1200
G1 X120.202 Y119.306 E.09312
G1 X120.202 Y115.552 E.12071
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y119.266 E.11942
G1 X123.505 Y119.713 F30000
G1 F1200
G1 X119.795 Y119.713 E.1193
G1 X119.795 Y115.145 E.14689
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y119.673 E.1456
M204 S250
G1 X123.94 Y120.148 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y120.148 E.13642
G1 X119.36 Y114.71 E.16198
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y120.108 E.16078
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y120.125 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y118.507 Z9.6 F30000
G1 Z9.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.0642
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y118.507 E.0642
G1 X122.239 Y118.507 E.03686
G1 X121.88 Y118.088 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X121.88 Y116.77 E.04793
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y118.088 E.04793
G1 X121.82 Y118.088 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 9.27273
; LAYER_HEIGHT: 0.0727272
; WIPE_START
G1 F3600
G1 X121.42 Y118.088 E-.1521
G1 X121.42 Y116.77 E-.5009
G1 X121.701 Y116.77 E-.107
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 74/152
; update layer progress
M73 L74
M991 S0 P73 ;notify layer change
G17
G3 Z9.6 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z9.273
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z9.673 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z9.673
G1 Z9.273
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z9.673 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z9.673
G1 Z9.273
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 9.4
; LAYER_HEIGHT: 0.127273
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 75/152
; update layer progress
M73 L75
M991 S0 P74 ;notify layer change
G17
G3 Z9.673 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y118.667 E.08708
G1 X133.309 Y118.667 E.06694
G1 X133.309 Y115.999 E.08579
G1 X132.902 Y115.552 F30000
G1 F1200
M73 P78 R6
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y119.074 E.11326
G1 X132.902 Y119.074 E.09312
G1 X132.902 Y115.592 E.11197
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y119.481 E.13944
G1 X132.495 Y119.481 E.1193
G1 X132.495 Y115.185 E.13815
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y119.916 E.15508
G1 X132.06 Y119.916 E.13642
G1 X132.06 Y114.75 E.15389
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z9.8 I-1.211 J-.123 P1  F30000
G1 X133.701 Y118.275 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y118.275 E.03865
G1 X134.999 Y116.351 E.05731
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y118.215 E.05552
G1 X134.12 Y117.856 F30000
; LINE_WIDTH: 0.50318
G1 F1200
G1 X134.58 Y117.856 E.01673
G1 X134.58 Y116.77 E.0395
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y117.796 E.03732
; WIPE_START
G1 F3600
G1 X134.12 Y116.77 E-.3901
G1 X134.58 Y116.77 E-.1749
G1 X134.58 Y117.283 E-.195
; WIPE_END
G1 E-.04 F1800
G1 X126.999 Y118.166 Z9.8 F30000
G1 X122.691 Y118.667 Z9.8
G1 Z9.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y118.667 E.06694
G1 X120.609 Y115.959 E.08708
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y118.627 E.0858
G1 X123.098 Y119.074 F30000
G1 F1200
G1 X120.202 Y119.074 E.09312
G1 X120.202 Y115.552 E.11326
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y119.034 E.11197
G1 X123.505 Y119.481 F30000
G1 F1200
G1 X119.795 Y119.481 E.1193
G1 X119.795 Y115.145 E.13944
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y119.441 E.13815
M204 S250
G1 X123.94 Y119.916 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y119.916 E.13642
G1 X119.36 Y114.71 E.15508
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y119.876 E.15389
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y119.894 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y118.275 Z9.8 F30000
G1 Z9.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.05731
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y118.275 E.05731
G1 X122.239 Y118.275 E.03686
G1 X121.88 Y117.856 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X121.88 Y116.77 E.03951
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y117.856 E.03951
G1 X121.82 Y117.856 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 9.54545
; LAYER_HEIGHT: 0.145455
; WIPE_START
G1 F3600
G1 X121.42 Y117.856 E-.15211
G1 X121.42 Y116.77 E-.4129
G1 X121.88 Y116.77 E-.1749
G1 X121.88 Y116.823 E-.02009
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 76/152
; update layer progress
M73 L76
M991 S0 P75 ;notify layer change
G17
G3 Z9.8 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z9.545
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z9.945 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z9.945
G1 Z9.545
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z9.945 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z9.945
G1 Z9.545
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 9.6
; LAYER_HEIGHT: 0.0545454
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 77/152
; update layer progress
M73 L77
M991 S0 P76 ;notify layer change
G17
G3 Z9.945 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y118.436 E.07963
G1 X133.309 Y118.436 E.06694
G1 X133.309 Y115.999 E.07835
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y118.843 E.10581
G1 X132.902 Y118.843 E.09312
G1 X132.902 Y115.592 E.10453
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y119.25 E.13199
G1 X132.495 Y119.25 E.1193
G1 X132.495 Y115.185 E.13071
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y119.685 E.14818
G1 X132.06 Y119.685 E.13642
G1 X132.06 Y114.75 E.14699
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10 I-1.21 J-.131 P1  F30000
G1 X133.701 Y118.044 Z10
G1 Z9.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y118.044 E.03865
G1 X134.999 Y116.351 E.05041
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y117.984 E.04862
G1 X134.12 Y117.625 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X134.58 Y117.625 E.01673
G1 X134.58 Y116.77 E.03109
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y117.565 E.0289
; WIPE_START
G1 F3600
G1 X134.12 Y116.77 E-.3021
G1 X134.58 Y116.77 E-.1749
G1 X134.58 Y117.515 E-.28299
; WIPE_END
G1 E-.04 F1800
G1 X126.97 Y118.104 Z10 F30000
G1 X122.691 Y118.436 Z10
G1 Z9.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y118.436 E.06694
G1 X120.609 Y115.959 E.07963
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y118.396 E.07835
G1 X123.098 Y118.843 F30000
G1 F1200
G1 X120.202 Y118.843 E.09312
G1 X120.202 Y115.552 E.10581
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y118.803 E.10453
G1 X123.505 Y119.25 F30000
G1 F1200
G1 X119.795 Y119.25 E.1193
G1 X119.795 Y115.145 E.13199
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y119.21 E.13071
M204 S250
G1 X123.94 Y119.685 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y119.685 E.13642
G1 X119.36 Y114.71 E.14818
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y119.645 E.14699
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y119.662 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y118.044 Z10 F30000
G1 Z9.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
M73 P79 R6
G1 F1200
G1 X122.299 Y116.351 E.05041
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y118.044 E.05041
G1 X122.239 Y118.044 E.03686
G1 X121.88 Y117.625 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X121.88 Y116.77 E.03109
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y117.625 E.03109
G1 X121.82 Y117.625 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 9.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3600
G1 X121.42 Y117.625 E-.15211
G1 X121.42 Y116.77 E-.3249
G1 X121.88 Y116.77 E-.1749
G1 X121.88 Y117.054 E-.10809
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 78/152
; update layer progress
M73 L78
M991 S0 P77 ;notify layer change
G17
G3 Z10 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y118.204 E.07219
G1 X133.309 Y118.204 E.06694
G1 X133.309 Y115.999 E.0709
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y118.611 E.09837
G1 X132.902 Y118.611 E.09312
G1 X132.902 Y115.592 E.09708
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y119.018 E.12455
G1 X132.495 Y119.018 E.1193
G1 X132.495 Y115.185 E.12326
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y119.453 E.14128
G1 X132.06 Y119.453 E.13642
G1 X132.06 Y114.75 E.14009
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.2 I-1.209 J-.141 P1  F30000
G1 X133.701 Y117.812 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y117.812 E.03865
G1 X134.999 Y116.351 E.04351
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y117.752 E.04172
G1 X134.12 Y117.393 F30000
; LINE_WIDTH: 0.50318
G1 F1200
G1 X134.58 Y117.393 E.01673
G1 X134.58 Y116.77 E.02267
G1 X134.12 Y116.77 E.01673
G1 X134.12 Y117.333 E.02048
; WIPE_START
G1 F3600
G1 X134.12 Y116.77 E-.2141
G1 X134.58 Y116.77 E-.1749
G1 X134.58 Y117.393 E-.2369
G1 X134.227 Y117.393 E-.13409
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.2 I-.085 J-1.214 P1  F30000
G1 X122.691 Y118.204 Z10.2
G1 Z9.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y118.204 E.06694
G1 X120.609 Y115.959 E.07219
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y118.164 E.0709
G1 X123.098 Y118.611 F30000
G1 F1200
M73 P79 R5
G1 X120.202 Y118.611 E.09312
G1 X120.202 Y115.552 E.09837
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y118.571 E.09708
G1 X123.505 Y119.018 F30000
G1 F1200
G1 X119.795 Y119.018 E.1193
G1 X119.795 Y115.145 E.12455
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y118.978 E.12326
M204 S250
G1 X123.94 Y119.453 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y119.453 E.13642
G1 X119.36 Y114.71 E.14128
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y119.413 E.14009
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y119.431 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y117.812 Z10.2 F30000
G1 Z9.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.04351
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y117.812 E.04351
G1 X122.239 Y117.812 E.03686
G1 X121.88 Y117.393 F30000
; LINE_WIDTH: 0.50319
G1 F1200
G1 X121.88 Y116.77 E.02267
G1 X121.42 Y116.77 E.01673
G1 X121.42 Y117.393 E.02267
G1 X121.82 Y117.393 E.01455
; CHANGE_LAYER
; Z_HEIGHT: 9.81818
; LAYER_HEIGHT: 0.0181818
; WIPE_START
G1 F3600
G1 X121.42 Y117.393 E-.1521
G1 X121.42 Y116.77 E-.2369
G1 X121.88 Y116.77 E-.1749
G1 X121.88 Y117.286 E-.19609
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 79/152
; update layer progress
M73 L79
M991 S0 P78 ;notify layer change
G17
G3 Z10.2 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z9.818
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.218 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z10.218
G1 Z9.818
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.218 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z10.218
G1 Z9.818
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 10
; LAYER_HEIGHT: 0.181818
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 80/152
; update layer progress
M73 L80
M991 S0 P79 ;notify layer change
G17
G3 Z10.218 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y117.972 E.06474
G1 X133.309 Y117.972 E.06694
G1 X133.309 Y115.999 E.06345
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y118.38 E.09092
G1 X132.902 Y118.38 E.09312
G1 X132.902 Y115.592 E.08963
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y118.787 E.1171
G1 X132.495 Y118.787 E.1193
G1 X132.495 Y115.185 E.11581
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y119.222 E.13438
G1 X132.06 Y119.222 E.13642
G1 X132.06 Y114.75 E.13319
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.4 I-1.207 J-.152 P1  F30000
G1 X133.701 Y117.58 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y117.58 E.03865
G1 X134.999 Y116.351 E.03661
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y117.52 E.03483
G1 X134.103 Y117.179 F30000
; LINE_WIDTH: 0.468975
G1 F1200
G1 X134.597 Y117.179 E.01664
G1 X134.597 Y116.753 E.01434
G1 X134.103 Y116.753 E.01664
G1 X134.103 Y117.119 E.01232
; WIPE_START
G1 F3600
G1 X134.103 Y116.753 E-.1562
G1 X134.597 Y116.753 E-.211
G1 X134.597 Y117.179 E-.1818
G1 X134.103 Y117.179 E-.211
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.4 I-.084 J-1.214 P1  F30000
G1 X122.691 Y117.972 Z10.4
G1 Z10
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y117.972 E.06694
G1 X120.609 Y115.959 E.06474
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y117.932 E.06345
G1 X123.098 Y118.38 F30000
G1 F1200
G1 X120.202 Y118.38 E.09312
G1 X120.202 Y115.552 E.09092
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y118.34 E.08963
G1 X123.505 Y118.787 F30000
G1 F1200
G1 X119.795 Y118.787 E.1193
G1 X119.795 Y115.145 E.1171
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y118.747 E.11581
M204 S250
G1 X123.94 Y119.222 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y119.222 E.13642
G1 X119.36 Y114.71 E.13438
G1 X123.94 Y114.71 E.13642
M73 P80 R5
G1 X123.94 Y119.182 E.13319
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y119.199 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.299 Y117.58 Z10.4 F30000
G1 Z10
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.03661
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y117.58 E.03661
G1 X122.239 Y117.58 E.03686
G1 X121.897 Y117.179 F30000
; LINE_WIDTH: 0.46898
G1 F1200
G1 X121.897 Y116.753 E.01434
G1 X121.403 Y116.753 E.01664
G1 X121.403 Y117.179 E.01434
G1 X121.837 Y117.179 E.01462
; CHANGE_LAYER
; Z_HEIGHT: 10.0909
; LAYER_HEIGHT: 0.090909
; WIPE_START
G1 F3600
G1 X121.403 Y117.179 E-.1854
G1 X121.403 Y116.753 E-.1818
G1 X121.897 Y116.753 E-.211
G1 X121.897 Y117.179 E-.1818
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 81/152
; update layer progress
M73 L81
M991 S0 P80 ;notify layer change
G17
G3 Z10.4 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z10.091
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.491 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z10.491
G1 Z10.091
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.491 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z10.491
G1 Z10.091
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 10.2
; LAYER_HEIGHT: 0.109091
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 82/152
; update layer progress
M73 L82
M991 S0 P81 ;notify layer change
G17
G3 Z10.491 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y117.741 E.05729
G1 X133.309 Y117.741 E.06694
G1 X133.309 Y115.999 E.05601
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y118.148 E.08347
G1 X132.902 Y118.148 E.09312
G1 X132.902 Y115.592 E.08219
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y118.555 E.10965
G1 X132.495 Y118.555 E.1193
G1 X132.495 Y115.185 E.10837
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y118.99 E.12749
G1 X132.06 Y118.99 E.13642
G1 X132.06 Y114.75 E.1263
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y117.349 Z10.6 F30000
G1 Z10.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y117.349 E.03865
G1 X134.999 Y116.351 E.02971
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y117.289 E.02793
G1 X134.045 Y117.005 F30000
; LINE_WIDTH: 0.353185
G1 F1200
G1 X134.655 Y117.005 E.01496
G1 X134.655 Y116.695 E.0076
G1 X134.045 Y116.695 E.01496
G1 X134.045 Y116.945 E.00613
; WIPE_START
G1 F3600
G1 X134.045 Y116.695 E-.10679
G1 X134.655 Y116.695 E-.26041
G1 X134.655 Y117.005 E-.13239
G1 X134.045 Y117.005 E-.26041
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.6 I-.079 J-1.214 P1  F30000
G1 X122.691 Y117.741 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y117.741 E.06694
G1 X120.609 Y115.959 E.05729
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y117.701 E.05601
G1 X123.098 Y118.148 F30000
G1 F1200
G1 X120.202 Y118.148 E.09312
G1 X120.202 Y115.552 E.08347
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y118.108 E.08219
G1 X123.505 Y118.555 F30000
G1 F1200
G1 X119.795 Y118.555 E.1193
G1 X119.795 Y115.145 E.10965
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y118.515 E.10837
M204 S250
G1 X123.94 Y118.99 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y118.99 E.13642
G1 X119.36 Y114.71 E.12749
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y118.95 E.1263
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y118.967 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.6 I1.188 J.263 P1  F30000
G1 X122.299 Y117.349 Z10.6
G1 Z10.2
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.02971
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y117.349 E.02971
G1 X122.239 Y117.349 E.03686
G1 X121.955 Y117.005 F30000
; LINE_WIDTH: 0.35319
G1 F1200
G1 X121.955 Y116.695 E.0076
G1 X121.345 Y116.695 E.01496
G1 X121.345 Y117.005 E.0076
G1 X121.895 Y117.005 E.01349
; CHANGE_LAYER
; Z_HEIGHT: 10.3636
; LAYER_HEIGHT: 0.163636
; WIPE_START
G1 F3600
G1 X121.345 Y117.005 E-.2348
G1 X121.345 Y116.695 E-.13239
G1 X121.955 Y116.695 E-.26041
G1 X121.955 Y117.005 E-.13239
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 83/152
; update layer progress
M73 L83
M991 S0 P82 ;notify layer change
G17
G3 Z10.6 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z10.364
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.764 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z10.764
G1 Z10.364
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.764 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z10.764
G1 Z10.364
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 10.4
; LAYER_HEIGHT: 0.0363636
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 84/152
; update layer progress
M73 L84
M991 S0 P83 ;notify layer change
G17
G3 Z10.764 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y117.509 E.04985
G1 X133.309 Y117.509 E.06694
G1 X133.309 Y115.999 E.04856
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y117.916 E.07603
G1 X132.902 Y117.916 E.09312
G1 X132.902 Y115.592 E.07474
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y118.323 E.10221
G1 X132.495 Y118.323 E.1193
G1 X132.495 Y115.185 E.10092
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y118.758 E.12059
G1 X132.06 Y118.758 E.13642
G1 X132.06 Y114.75 E.1194
; WIPE_START
M73 P81 R5
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.701 Y117.117 Z10.8 F30000
G1 Z10.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X134.999 Y117.117 E.03865
G1 X134.999 Y116.351 E.02282
G1 X133.701 Y116.351 E.03865
G1 X133.701 Y117.057 E.02103
G1 X134.084 Y116.734 F30000
; LINE_WIDTH: 0.43187
G1 F1200
G1 X134.556 Y116.734 E.01449
; WIPE_START
G1 F3600
G1 X134.084 Y116.734 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.8 I-.083 J-1.214 P1  F30000
G1 X122.691 Y117.509 Z10.8
G1 Z10.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y117.509 E.06694
G1 X120.609 Y115.959 E.04985
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y117.469 E.04856
G1 X123.098 Y117.916 F30000
G1 F1200
G1 X120.202 Y117.916 E.09312
G1 X120.202 Y115.552 E.07603
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y117.876 E.07474
G1 X123.505 Y118.323 F30000
G1 F1200
G1 X119.795 Y118.323 E.1193
G1 X119.795 Y115.145 E.10221
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y118.283 E.10092
M204 S250
G1 X123.94 Y118.758 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y118.758 E.13642
G1 X119.36 Y114.71 E.12059
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y118.718 E.1194
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y118.736 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z10.8 I1.188 J.263 P1  F30000
G1 X122.299 Y117.117 Z10.8
G1 Z10.4
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41999
G1 F1200
G1 X122.299 Y116.351 E.02282
G1 X121.001 Y116.351 E.03865
G1 X121.001 Y117.117 E.02282
G1 X122.239 Y117.117 E.03686
G1 X121.384 Y116.734 F30000
; LINE_WIDTH: 0.43187
G1 F1200
G1 X121.856 Y116.734 E.01449
; CHANGE_LAYER
; Z_HEIGHT: 10.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F3600
G1 X121.384 Y116.734 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 85/152
; update layer progress
M73 L85
M991 S0 P84 ;notify layer change
G17
G3 Z10.8 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y117.278 E.0424
G1 X133.309 Y117.278 E.06694
G1 X133.309 Y115.999 E.04111
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y117.685 E.06858
G1 X132.902 Y117.685 E.09312
G1 X132.902 Y115.592 E.06729
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y118.092 E.09476
G1 X132.495 Y118.092 E.1193
G1 X132.495 Y115.185 E.09347
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y118.527 E.11369
G1 X132.06 Y118.527 E.13642
G1 X132.06 Y114.75 E.1125
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.741 Y116.846 Z11 F30000
G1 Z10.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.49868
G1 F1200
G1 X134.959 Y116.846 E.04388
G1 X134.959 Y116.391 E.01641
G1 X133.741 Y116.391 E.04388
G1 X133.741 Y116.786 E.01425
; WIPE_START
G1 F3600
G1 X133.741 Y116.391 E-.15039
G1 X134.959 Y116.391 E-.46319
G1 X134.959 Y116.776 E-.14643
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11 I-.05 J-1.216 P1  F30000
G1 X122.691 Y117.278 Z11
G1 Z10.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y117.278 E.06694
G1 X120.609 Y115.959 E.0424
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y117.238 E.04111
G1 X123.098 Y117.685 F30000
G1 F1200
G1 X120.202 Y117.685 E.09312
G1 X120.202 Y115.552 E.06858
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y117.645 E.06729
G1 X123.505 Y118.092 F30000
G1 F1200
G1 X119.795 Y118.092 E.1193
G1 X119.795 Y115.145 E.09476
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y118.052 E.09347
M204 S250
G1 X123.94 Y118.527 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y118.527 E.13642
G1 X119.36 Y114.71 E.11369
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y118.487 E.1125
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y118.504 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11 I1.195 J.23 P1  F30000
G1 X122.259 Y116.846 Z11
G1 Z10.6
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.49868
G1 F1200
G1 X122.259 Y116.391 E.01641
G1 X121.041 Y116.391 E.04388
G1 X121.041 Y116.846 E.01641
G1 X122.199 Y116.846 E.04172
; CHANGE_LAYER
; Z_HEIGHT: 10.6364
; LAYER_HEIGHT: 0.0363636
; WIPE_START
G1 F3600
G1 X121.041 Y116.846 E-.44039
G1 X121.041 Y116.391 E-.17319
G1 X121.426 Y116.391 E-.14643
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 86/152
; update layer progress
M73 L86
M991 S0 P85 ;notify layer change
G17
G3 Z11 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z10.636
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.036 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z11.036
G1 Z10.636
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.036 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z11.036
G1 Z10.636
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 10.8
; LAYER_HEIGHT: 0.163636
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 87/152
; update layer progress
M73 L87
M991 S0 P86 ;notify layer change
G17
G3 Z11.036 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y117.046 E.03495
G1 X133.309 Y117.046 E.06694
G1 X133.309 Y115.999 E.03367
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y117.453 E.06113
G1 X132.902 Y117.453 E.09312
G1 X132.902 Y115.592 E.05985
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y117.86 E.08731
G1 X132.495 Y117.86 E.1193
G1 X132.495 Y115.185 E.08603
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y118.295 E.10679
G1 X132.06 Y118.295 E.13642
G1 X132.06 Y114.75 E.1056
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.683 Y116.673 Z11.2 F30000
G1 Z10.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.382885
G1 F1200
G1 X135.017 Y116.673 E.03584
G1 X135.017 Y116.333 E.00913
G1 X133.683 Y116.333 E.03584
G1 X133.683 Y116.613 E.00752
; WIPE_START
G1 F3600
G1 X133.683 Y116.333 E-.10639
G1 X135.017 Y116.333 E-.50719
G1 X135.017 Y116.673 E-.12918
G1 X134.972 Y116.673 E-.01724
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.2 I-.037 J-1.216 P1  F30000
G1 X122.691 Y117.046 Z11.2
G1 Z10.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y117.046 E.06694
G1 X120.609 Y115.959 E.03495
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y117.006 E.03367
G1 X123.098 Y117.453 F30000
G1 F1200
G1 X120.202 Y117.453 E.09312
G1 X120.202 Y115.552 E.06113
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y117.413 E.05985
G1 X123.505 Y117.86 F30000
G1 F1200
G1 X119.795 Y117.86 E.1193
G1 X119.795 Y115.145 E.08731
M73 P82 R5
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y117.82 E.08603
M204 S250
G1 X123.94 Y118.295 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y118.295 E.13642
G1 X119.36 Y114.71 E.10679
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y118.255 E.1056
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y118.273 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.2 I1.184 J.279 P1  F30000
G1 X122.317 Y116.673 Z11.2
G1 Z10.8
G1 E.8 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38289
G1 F1200
G1 X122.317 Y116.333 E.00913
G1 X120.983 Y116.333 E.03584
G1 X120.983 Y116.673 E.00913
G1 X122.257 Y116.673 E.03423
; CHANGE_LAYER
; Z_HEIGHT: 10.9091
; LAYER_HEIGHT: 0.109091
; WIPE_START
G1 F3600
G1 X120.983 Y116.673 E-.48439
G1 X120.983 Y116.333 E-.12919
G1 X121.368 Y116.333 E-.14642
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 88/152
; update layer progress
M73 L88
M991 S0 P87 ;notify layer change
G17
G3 Z11.2 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z10.909
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.309 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z11.309
G1 Z10.909
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.309 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z11.309
G1 Z10.909
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 11
; LAYER_HEIGHT: 0.090909
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 89/152
; update layer progress
M73 L89
M991 S0 P88 ;notify layer change
G17
G3 Z11.309 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y116.815 E.02751
G1 X133.309 Y116.815 E.06694
G1 X133.309 Y115.999 E.02622
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y117.222 E.05369
G1 X132.902 Y117.222 E.09312
G1 X132.902 Y115.592 E.0524
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y117.629 E.07987
G1 X132.495 Y117.629 E.1193
G1 X132.495 Y115.185 E.07858
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y118.064 E.09989
G1 X132.06 Y118.064 E.13642
G1 X132.06 Y114.75 E.0987
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.513 Y116.387 Z11.4 F30000
G1 Z11
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.49126
G1 F1200
G1 X135.187 Y116.387 E.05931
; WIPE_START
G1 F5353.08
G1 X133.513 Y116.387 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.4 I-.048 J-1.216 P1  F30000
G1 X122.691 Y116.815 Z11.4
G1 Z11
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y116.815 E.06694
G1 X120.609 Y115.959 E.02751
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y116.775 E.02622
G1 X123.098 Y117.222 F30000
G1 F1200
G1 X120.202 Y117.222 E.09312
G1 X120.202 Y115.552 E.05369
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y117.182 E.0524
G1 X123.505 Y117.629 F30000
G1 F1200
G1 X119.795 Y117.629 E.1193
G1 X119.795 Y115.145 E.07987
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y117.589 E.07858
M204 S250
G1 X123.94 Y118.064 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y118.064 E.13642
G1 X119.36 Y114.71 E.09989
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y118.024 E.0987
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y118.041 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.4 I1.155 J.382 P1  F30000
G1 X122.487 Y116.387 Z11.4
G1 Z11
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.49126
G1 F1200
G1 X120.813 Y116.387 E.05931
; CHANGE_LAYER
; Z_HEIGHT: 11.1818
; LAYER_HEIGHT: 0.181818
; WIPE_START
G1 F5353.08
G1 X122.487 Y116.387 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 90/152
; update layer progress
M73 L90
M991 S0 P89 ;notify layer change
G17
G3 Z11.4 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z11.182
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.582 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z11.582
G1 Z11.182
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.582 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z11.582
G1 Z11.182
G1 E.8 F1800
G1 F1200
M73 P82 R4
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 11.2
; LAYER_HEIGHT: 0.0181818
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 91/152
; update layer progress
M73 L91
M991 S0 P90 ;notify layer change
G17
G3 Z11.582 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z11.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y116.583 E.02006
G1 X133.309 Y116.583 E.06694
G1 X133.309 Y115.999 E.01877
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y116.99 E.04624
G1 X132.902 Y116.99 E.09312
G1 X132.902 Y115.592 E.04495
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y117.397 E.07242
G1 X132.495 Y117.397 E.1193
G1 X132.495 Y115.185 E.07113
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y117.832 E.093
G1 X132.06 Y117.832 E.13642
G1 X132.06 Y114.75 E.09181
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.513 Y116.271 Z11.6 F30000
G1 Z11.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.25968
G1 F1200
G1 X135.187 Y116.271 E.02867
; WIPE_START
G1 F11072.153
G1 X133.513 Y116.271 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.6 I-.035 J-1.216 P1  F30000
G1 X122.691 Y116.583 Z11.6
G1 Z11.2
M73 P83 R4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y116.583 E.06694
G1 X120.609 Y115.959 E.02006
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y116.543 E.01877
G1 X123.098 Y116.99 F30000
G1 F1200
G1 X120.202 Y116.99 E.09312
G1 X120.202 Y115.552 E.04624
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y116.95 E.04495
G1 X123.505 Y117.397 F30000
G1 F1200
G1 X119.795 Y117.397 E.1193
G1 X119.795 Y115.145 E.07242
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y117.357 E.07113
M204 S250
G1 X123.94 Y117.832 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y117.832 E.13642
G1 X119.36 Y114.71 E.093
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y117.792 E.09181
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y117.81 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.6 I1.147 J.408 P1  F30000
G1 X122.487 Y116.271 Z11.6
G1 Z11.2
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.25968
G1 F1200
G1 X120.813 Y116.271 E.02867
; CHANGE_LAYER
; Z_HEIGHT: 11.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F11072.153
G1 X122.487 Y116.271 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 92/152
; update layer progress
M73 L92
M991 S0 P91 ;notify layer change
G17
G3 Z11.6 I1.217 J0 P1  F30000
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
G1 X133.309 Y115.959
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.391 Y115.959 E.06694
G1 X135.391 Y116.351 E.01261
G1 X133.309 Y116.351 E.06694
G1 X133.309 Y115.999 E.01133
G1 X132.902 Y115.552 F30000
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y116.758 E.03879
G1 X132.902 Y116.758 E.09312
G1 X132.902 Y115.592 E.03751
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y117.166 E.06497
G1 X132.495 Y117.166 E.1193
G1 X132.495 Y115.185 E.06369
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y117.601 E.0861
G1 X132.06 Y117.601 E.13642
G1 X132.06 Y114.75 E.08491
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.8 I-.172 J-1.205 P1  F30000
G1 X122.691 Y116.351 Z11.8
G1 Z11.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.609 Y116.351 E.06694
G1 X120.609 Y115.959 E.01261
G1 X122.691 Y115.959 E.06694
G1 X122.691 Y116.311 E.01133
G1 X123.098 Y116.758 F30000
G1 F1200
G1 X120.202 Y116.758 E.09312
G1 X120.202 Y115.552 E.03879
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y116.718 E.03751
G1 X123.505 Y117.166 F30000
G1 F1200
G1 X119.795 Y117.166 E.1193
G1 X119.795 Y115.145 E.06497
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y117.126 E.06369
M204 S250
G1 X123.94 Y117.601 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y117.601 E.13642
G1 X119.36 Y114.71 E.0861
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y117.561 E.08491
; CHANGE_LAYER
; Z_HEIGHT: 11.4545
; LAYER_HEIGHT: 0.0545454
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y117.578 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 93/152
; update layer progress
M73 L93
M991 S0 P92 ;notify layer change
G17
G3 Z11.8 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z11.455
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.855 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z11.855
G1 Z11.455
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z11.855 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z11.855
G1 Z11.455
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 11.6
; LAYER_HEIGHT: 0.145455
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 94/152
; update layer progress
M73 L94
M991 S0 P93 ;notify layer change
G17
G3 Z11.855 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y116.527 E.03135
G1 X132.902 Y116.527 E.09312
G1 X132.902 Y115.592 E.03006
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.934 E.05753
G1 X132.495 Y116.934 E.1193
G1 X132.495 Y115.185 E.05624
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y117.369 E.0792
G1 X132.06 Y117.369 E.13642
G1 X132.06 Y114.75 E.07801
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.106 Y116.039 Z12 F30000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.61067
G1 F1200
G1 X135.594 Y116.039 E.11162
; WIPE_START
G1 F4227.213
G1 X133.594 Y116.039 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12 I-.056 J-1.216 P1  F30000
G1 X123.098 Y116.527 Z12
G1 Z11.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y116.527 E.09312
G1 X120.202 Y115.552 E.03135
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y116.487 E.03006
G1 X123.505 Y116.934 F30000
G1 F1200
G1 X119.795 Y116.934 E.1193
G1 X119.795 Y115.145 E.05753
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.894 E.05624
M204 S250
G1 X123.94 Y117.369 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y117.369 E.13642
G1 X119.36 Y114.71 E.0792
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y117.329 E.07801
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y117.346 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.894 Y116.039 Z12 F30000
G1 Z11.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.61067
G1 F1200
G1 X120.406 Y116.039 E.11162
; CHANGE_LAYER
; Z_HEIGHT: 11.7273
; LAYER_HEIGHT: 0.127273
; WIPE_START
G1 F4227.213
G1 X122.406 Y116.039 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 95/152
; update layer progress
M73 L95
M991 S0 P94 ;notify layer change
G17
G3 Z12 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z11.727
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.127 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z12.127
G1 Z11.727
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.127 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z12.127
G1 Z11.727
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; CHANGE_LAYER
; Z_HEIGHT: 11.8
; LAYER_HEIGHT: 0.0727272
; WIPE_START
M73 P84 R4
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 96/152
; update layer progress
M73 L96
M991 S0 P95 ;notify layer change
G17
G3 Z12.127 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y116.295 E.0239
G1 X132.902 Y116.295 E.09312
G1 X132.902 Y115.592 E.02261
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.702 E.05008
G1 X132.495 Y116.702 E.1193
G1 X132.495 Y115.185 E.04879
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y117.137 E.0723
G1 X132.06 Y117.137 E.13642
G1 X132.06 Y114.75 E.07111
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.106 Y115.924 Z12.2 F30000
G1 Z11.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.37909
G1 F1200
G1 X135.594 Y115.924 E.06609
; WIPE_START
G1 F7139.245
G1 X133.594 Y115.924 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.2 I-.043 J-1.216 P1  F30000
G1 X123.098 Y116.295 Z12.2
G1 Z11.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y116.295 E.09312
G1 X120.202 Y115.552 E.0239
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y116.255 E.02261
G1 X123.505 Y116.702 F30000
G1 F1200
G1 X119.795 Y116.702 E.1193
G1 X119.795 Y115.145 E.05008
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.662 E.04879
M204 S250
G1 X123.94 Y117.137 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y117.137 E.13642
G1 X119.36 Y114.71 E.0723
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y117.097 E.07111
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y117.115 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.894 Y115.924 Z12.2 F30000
G1 Z11.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.37909
G1 F1200
G1 X120.406 Y115.924 E.06609
; CHANGE_LAYER
; Z_HEIGHT: 12
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F7139.245
G1 X122.406 Y115.924 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 97/152
; update layer progress
M73 L97
M991 S0 P96 ;notify layer change
G17
G3 Z12.2 I1.217 J0 P1  F30000
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
G1 X124.739 Y117.369
G1 Z12
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
; LAYER_HEIGHT: 0.272727
G1 F1200
G1 X125.123 Y117.369 E.01497
G1 X125.123 Y114.492 E.11202
G1 X124.739 Y114.492 E.01497
G1 X124.739 Y114.256 E.00917
G1 X124.394 Y113.911 E.01898
G1 X119.369 Y113.911 E.19566
G1 X119.369 Y111.615 E.08943
G1 X125.123 Y111.615 E.22405
G1 X125.123 Y108.738 E.11202
G1 X119.369 Y108.738 E.22405
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.4 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z12.4
G1 Z12
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.22405
G1 X136.631 Y111.615 E.11202
G1 X130.877 Y111.615 E.22405
G1 X130.877 Y114.492 E.11202
G1 X131.261 Y114.492 E.01497
G1 X131.261 Y114.256 E.00917
G1 X131.606 Y113.911 E.01898
G1 X136.631 Y113.911 E.19566
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.4 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z12.4
G1 Z12
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.369 E.10468
G1 X130.877 Y117.369 E.01497
G1 X130.877 Y114.68 E.10468
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.4 I.592 J1.063 P1  F30000
G1 X132.902 Y115.552 Z12.4
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y116.064 E.01645
G1 X132.902 Y116.064 E.09312
G1 X132.902 Y115.592 E.01517
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.471 E.04263
G1 X132.495 Y116.471 E.1193
G1 X132.495 Y115.185 E.04135
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.906 E.06541
G1 X132.06 Y116.906 E.13642
G1 X132.06 Y114.75 E.06421
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.106 Y115.808 Z12.4 F30000
G1 Z12
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.14751
G1 F1200
G1 X135.594 Y115.808 E.02056
; WIPE_START
G1 F15000
G1 X133.594 Y115.808 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.4 I-.03 J-1.217 P1  F30000
G1 X123.098 Y116.064 Z12.4
G1 Z12
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y116.064 E.09312
G1 X120.202 Y115.552 E.01645
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y116.024 E.01517
G1 X123.505 Y116.471 F30000
G1 F1200
G1 X119.795 Y116.471 E.1193
G1 X119.795 Y115.145 E.04263
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.431 E.04135
M204 S250
G1 X123.94 Y116.906 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.906 E.13642
G1 X119.36 Y114.71 E.06541
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.866 E.06421
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.883 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X122.894 Y115.808 Z12.4 F30000
G1 Z12
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.14751
G1 F1200
G1 X120.406 Y115.808 E.02056
; CHANGE_LAYER
; Z_HEIGHT: 12.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X122.406 Y115.808 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 98/152
; update layer progress
M73 L98
M991 S0 P97 ;notify layer change
G17
G3 Z12.4 I1.217 J0 P1  F30000
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
G1 X124.759 Y117.369
G1 Z12.2
G1 E.8 F1800
; FEATURE: Support
; LINE_WIDTH: 0.42
G1 F1200
G1 X125.123 Y117.369 E.01085
G1 X125.123 Y114.492 E.0857
G1 X124.739 Y114.492 E.01145
G1 X124.739 Y114.256 E.00701
G1 X124.394 Y113.911 E.01452
G1 X119.369 Y113.911 E.14968
G1 X119.369 Y111.615 E.06841
G1 X125.123 Y111.615 E.1714
G1 X125.123 Y108.738 E.0857
G1 X119.369 Y108.738 E.1714
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.6 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z12.6
G1 Z12.2
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.1714
G1 X136.631 Y111.615 E.0857
G1 X130.877 Y111.615 E.1714
G1 X130.877 Y114.492 E.0857
G1 X131.261 Y114.492 E.01145
G1 X131.261 Y114.256 E.00701
G1 X131.606 Y113.911 E.01452
G1 X136.631 Y113.911 E.14968
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.6 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z12.6
G1 Z12.2
G1 E.8 F1800
G1 F1200
G1 X131.261 Y116.844 E.06444
G1 X131.241 Y116.864 E.00085
G1 X131.241 Y117.369 E.01504
G1 X130.877 Y117.369 E.01085
G1 X130.877 Y114.68 E.08008
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.6 I.592 J1.063 P1  F30000
G1 X132.902 Y115.552 Z12.6
G1 Z12.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
M73 P85 R4
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.6 I-.134 J-1.21 P1  F30000
G1 X123.098 Y115.948 Z12.6
G1 Z12.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 12.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 99/152
; update layer progress
M73 L99
M991 S0 P98 ;notify layer change
G17
G3 Z12.6 I1.217 J0 P1  F30000
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
G1 X124.759 Y117.369
G1 Z12.4
G1 E.8 F1800
; FEATURE: Support
G1 F1200
G1 X125.123 Y117.369 E.01085
G1 X125.123 Y114.492 E.0857
G1 X124.739 Y114.492 E.01145
G1 X124.739 Y114.256 E.00701
G1 X124.394 Y113.911 E.01452
G1 X119.369 Y113.911 E.14968
G1 X119.369 Y111.615 E.06841
G1 X125.123 Y111.615 E.1714
G1 X125.123 Y108.738 E.0857
G1 X119.369 Y108.738 E.1714
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.8 I0 J1.217 P1  F30000
G1 X130.877 Y108.738 Z12.8
G1 Z12.4
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.1714
G1 X136.631 Y111.615 E.0857
G1 X130.877 Y111.615 E.1714
G1 X130.877 Y114.492 E.0857
G1 X131.261 Y114.492 E.01145
G1 X131.261 Y114.256 E.00701
G1 X131.606 Y113.911 E.01452
G1 X136.631 Y113.911 E.14968
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.8 I-.271 J-1.186 P1  F30000
G1 X131.261 Y114.68 Z12.8
G1 Z12.4
G1 E.8 F1800
G1 F1200
G1 X131.261 Y116.728 E.06099
G1 X131.241 Y116.748 E.00085
G1 X131.241 Y117.369 E.01849
G1 X130.877 Y117.369 E.01085
G1 X130.877 Y114.68 E.08008
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z12.8 I.592 J1.063 P1  F30000
G1 X132.902 Y115.552 Z12.8
G1 Z12.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z12.8 F30000
G1 X123.098 Y115.948 Z12.8
G1 Z12.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 12.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 100/152
; update layer progress
M73 L100
M991 S0 P99 ;notify layer change
G17
G3 Z12.8 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z12.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z13 F30000
G1 X123.098 Y115.948 Z13
G1 Z12.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 12.6615
; LAYER_HEIGHT: 0.0615377
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 101/152
; update layer progress
M73 L101
M991 S0 P100 ;notify layer change
G17
G3 Z13 I1.217 J0 P1  F30000
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
G1 X124.759 Y117.369
G1 Z12.662
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.0137
G1 X125.123 Y114.492 E.10814
G1 X124.739 Y114.492 E.01445
G1 X124.739 Y114.256 E.00885
G1 X124.394 Y113.911 E.01833
G1 X119.369 Y113.911 E.18888
G1 X119.369 Y111.615 E.08633
G1 X125.123 Y111.615 E.21629
G1 X125.123 Y108.738 E.10814
G1 X119.369 Y108.738 E.21629
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.001 Y108.738 Z13.062 F30000
G1 X130.877 Y108.738 Z13.062
G1 Z12.662
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.21629
G1 X136.631 Y111.615 E.10814
G1 X130.877 Y111.615 E.21629
G1 X130.877 Y114.492 E.10814
G1 X131.261 Y114.492 E.01445
G1 X131.261 Y114.256 E.00885
G1 X131.606 Y113.911 E.01833
G1 X136.631 Y113.911 E.18888
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.261 Y114.68 Z13.062 F30000
G1 Z12.662
G1 E.8 F1800
G1 F1200
G1 X131.261 Y116.728 E.07697
G1 X131.241 Y116.748 E.00107
G1 X131.241 Y117.369 E.02333
G1 X130.877 Y117.369 E.01369
G1 X130.877 Y114.68 E.10106
; CHANGE_LAYER
; Z_HEIGHT: 12.8
; LAYER_HEIGHT: 0.138462
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 102/152
; update layer progress
M73 L102
M991 S0 P101 ;notify layer change
G17
G3 Z13.062 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P86 R4
G1 X126.474 Y115.574 Z13.2 F30000
G1 X123.098 Y115.948 Z13.2
G1 Z12.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 12.9231
; LAYER_HEIGHT: 0.123076
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 103/152
; update layer progress
M73 L103
M991 S0 P102 ;notify layer change
G17
G3 Z13.2 I1.217 J0 P1  F30000
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
G1 X124.758 Y117.369
G1 Z12.923
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01373
G1 X125.123 Y114.492 E.10814
G1 X124.739 Y114.492 E.01445
G1 X124.739 Y114.256 E.00885
G1 X124.394 Y113.911 E.01833
G1 X119.369 Y113.911 E.18888
G1 X119.369 Y111.615 E.08633
G1 X125.123 Y111.615 E.21629
G1 X125.123 Y108.738 E.10814
G1 X119.369 Y108.738 E.21629
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.001 Y108.738 Z13.323 F30000
G1 X130.877 Y108.738 Z13.323
G1 Z12.923
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.21629
G1 X136.631 Y111.615 E.10814
G1 X130.877 Y111.615 E.21629
G1 X130.877 Y114.492 E.10814
G1 X131.261 Y114.492 E.01445
M73 P86 R3
G1 X131.261 Y114.256 E.00885
G1 X131.606 Y113.911 E.01833
G1 X136.631 Y113.911 E.18888
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.261 Y114.68 Z13.323 F30000
G1 Z12.923
G1 E.8 F1800
G1 F1200
G1 X131.261 Y116.728 E.07697
G1 X131.241 Y116.748 E.00107
G1 X131.242 Y117.369 E.02333
G1 X130.877 Y117.369 E.01373
G1 X130.877 Y114.68 E.10106
; CHANGE_LAYER
; Z_HEIGHT: 13
; LAYER_HEIGHT: 0.0769234
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 104/152
; update layer progress
M73 L104
M991 S0 P103 ;notify layer change
G17
G3 Z13.323 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z13
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z13.4 F30000
G1 X123.098 Y115.948 Z13.4
G1 Z13
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 13.1846
; LAYER_HEIGHT: 0.184615
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 105/152
; update layer progress
M73 L105
M991 S0 P104 ;notify layer change
G17
G3 Z13.4 I1.217 J0 P1  F30000
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
G1 X124.614 Y117.369
G1 Z13.185
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01915
G1 X125.123 Y114.492 E.10814
G1 X124.739 Y114.492 E.01445
G1 X124.739 Y114.256 E.00885
G1 X124.394 Y113.911 E.01833
G1 X119.369 Y113.911 E.18888
G1 X119.369 Y111.615 E.08633
G1 X125.123 Y111.615 E.21629
G1 X125.123 Y108.738 E.10814
G1 X119.369 Y108.738 E.21629
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.001 Y108.738 Z13.585 F30000
G1 X130.877 Y108.738 Z13.585
G1 Z13.185
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.21629
G1 X136.631 Y111.615 E.10814
G1 X130.877 Y111.615 E.21629
G1 X130.877 Y114.492 E.10814
G1 X131.261 Y114.492 E.01445
G1 X131.261 Y114.256 E.00885
G1 X131.606 Y113.911 E.01833
G1 X136.631 Y113.911 E.18888
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.261 Y114.68 Z13.585 F30000
G1 Z13.185
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.244 E.09636
G1 X131.386 Y117.369 E.00665
G1 X130.877 Y117.369 E.01915
G1 X130.877 Y114.68 E.10106
; CHANGE_LAYER
; Z_HEIGHT: 13.2
; LAYER_HEIGHT: 0.0153847
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 106/152
; update layer progress
M73 L106
M991 S0 P105 ;notify layer change
G17
G3 Z13.585 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z13.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z13.6 F30000
G1 X123.098 Y115.948 Z13.6
G1 Z13.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 13.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 107/152
; update layer progress
M73 L107
M991 S0 P106 ;notify layer change
G17
G3 Z13.6 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z13.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z13.8 F30000
G1 X123.098 Y115.948 Z13.8
G1 Z13.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
M73 P87 R3
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 13.4462
; LAYER_HEIGHT: 0.046154
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 108/152
; update layer progress
M73 L108
M991 S0 P107 ;notify layer change
G17
G3 Z13.8 I1.217 J0 P1  F30000
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
G1 X124.614 Y117.369
G1 Z13.446
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01915
G1 X125.123 Y114.492 E.10814
G1 X124.739 Y114.492 E.01445
G1 X124.739 Y114.256 E.00885
G1 X124.394 Y113.911 E.01833
G1 X119.369 Y113.911 E.18888
G1 X119.369 Y111.615 E.08633
G1 X125.123 Y111.615 E.21629
G1 X125.123 Y108.738 E.10814
G1 X119.369 Y108.738 E.21629
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.001 Y108.738 Z13.846 F30000
G1 X130.877 Y108.738 Z13.846
G1 Z13.446
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.21629
G1 X136.631 Y111.615 E.10814
G1 X130.877 Y111.615 E.21629
G1 X130.877 Y114.492 E.10814
G1 X131.261 Y114.492 E.01445
G1 X131.261 Y114.256 E.00885
G1 X131.606 Y113.911 E.01833
G1 X136.631 Y113.911 E.18888
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.261 Y114.68 Z13.846 F30000
G1 Z13.446
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.244 E.09636
G1 X131.386 Y117.369 E.00665
G1 X130.877 Y117.369 E.01915
G1 X130.877 Y114.68 E.10106
; CHANGE_LAYER
; Z_HEIGHT: 13.6
; LAYER_HEIGHT: 0.153847
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 109/152
; update layer progress
M73 L109
M991 S0 P108 ;notify layer change
G17
G3 Z13.846 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z14 F30000
G1 X123.098 Y115.948 Z14
G1 Z13.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 13.7077
; LAYER_HEIGHT: 0.107692
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 110/152
; update layer progress
M73 L110
M991 S0 P109 ;notify layer change
G17
G3 Z14 I1.217 J0 P1  F30000
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
G1 X124.614 Y117.369
G1 Z13.708
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01915
G1 X125.123 Y114.492 E.10814
G1 X124.739 Y114.492 E.01445
G1 X124.739 Y114.256 E.00885
G1 X124.394 Y113.911 E.01833
G1 X119.369 Y113.911 E.18888
G1 X119.369 Y111.615 E.08633
G1 X125.123 Y111.615 E.21629
G1 X125.123 Y108.738 E.10814
G1 X119.369 Y108.738 E.21629
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.001 Y108.738 Z14.108 F30000
G1 X130.877 Y108.738 Z14.108
G1 Z13.708
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.21629
G1 X136.631 Y111.615 E.10814
G1 X130.877 Y111.615 E.21629
G1 X130.877 Y114.492 E.10814
G1 X131.261 Y114.492 E.01445
G1 X131.261 Y114.256 E.00885
G1 X131.606 Y113.911 E.01833
G1 X136.631 Y113.911 E.18888
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.261 Y114.68 Z14.108 F30000
G1 Z13.708
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.244 E.09636
G1 X131.386 Y117.369 E.00665
G1 X130.877 Y117.369 E.01915
G1 X130.877 Y114.68 E.10106
; CHANGE_LAYER
; Z_HEIGHT: 13.8
; LAYER_HEIGHT: 0.092308
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 111/152
; update layer progress
M73 L111
M991 S0 P110 ;notify layer change
G17
G3 Z14.108 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z13.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z14.2 F30000
G1 X123.098 Y115.948 Z14.2
G1 Z13.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 13.9692
; LAYER_HEIGHT: 0.16923
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 112/152
; update layer progress
M73 L112
M991 S0 P111 ;notify layer change
G17
G3 Z14.2 I1.217 J0 P1  F30000
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
G1 X124.614 Y117.369
G1 Z13.969
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01915
G1 X125.123 Y114.492 E.10814
G1 X124.739 Y114.492 E.01445
G1 X124.739 Y114.256 E.00885
G1 X124.394 Y113.911 E.01833
G1 X119.369 Y113.911 E.18888
G1 X119.369 Y111.615 E.08633
G1 X125.123 Y111.615 E.21629
G1 X125.123 Y108.738 E.10814
G1 X119.369 Y108.738 E.21629
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.001 Y108.738 Z14.369 F30000
G1 X130.877 Y108.738 Z14.369
G1 Z13.969
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.21629
G1 X136.631 Y111.615 E.10814
G1 X130.877 Y111.615 E.21629
G1 X130.877 Y114.492 E.10814
G1 X131.261 Y114.492 E.01445
G1 X131.261 Y114.256 E.00885
M73 P88 R3
G1 X131.606 Y113.911 E.01833
G1 X136.631 Y113.911 E.18888
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.261 Y114.68 Z14.369 F30000
G1 Z13.969
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.244 E.09636
G1 X131.386 Y117.369 E.00665
G1 X130.877 Y117.369 E.01915
G1 X130.877 Y114.68 E.10106
; CHANGE_LAYER
; Z_HEIGHT: 14
; LAYER_HEIGHT: 0.0307693
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 113/152
; update layer progress
M73 L113
M991 S0 P112 ;notify layer change
G17
G3 Z14.369 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z14
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z14.4 F30000
G1 X123.098 Y115.948 Z14.4
G1 Z14
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 14.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 114/152
; update layer progress
M73 L114
M991 S0 P113 ;notify layer change
G17
G3 Z14.4 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z14.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z14.6 F30000
G1 X123.098 Y115.948 Z14.6
G1 Z14.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 14.2308
; LAYER_HEIGHT: 0.0307693
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 115/152
; update layer progress
M73 L115
M991 S0 P114 ;notify layer change
G17
G3 Z14.6 I1.217 J0 P1  F30000
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
G1 X124.614 Y117.369
G1 Z14.231
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01915
G1 X125.123 Y114.492 E.10814
G1 X124.739 Y114.492 E.01445
G1 X124.739 Y114.256 E.00885
G1 X124.394 Y113.911 E.01833
G1 X119.369 Y113.911 E.18888
G1 X119.369 Y111.615 E.08633
G1 X125.123 Y111.615 E.21629
G1 X125.123 Y108.738 E.10814
G1 X119.369 Y108.738 E.21629
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.001 Y108.738 Z14.631 F30000
G1 X130.877 Y108.738 Z14.631
G1 Z14.231
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.21629
G1 X136.631 Y111.615 E.10814
G1 X130.877 Y111.615 E.21629
G1 X130.877 Y114.492 E.10814
G1 X131.261 Y114.492 E.01445
G1 X131.261 Y114.256 E.00885
G1 X131.606 Y113.911 E.01833
G1 X136.631 Y113.911 E.18888
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.261 Y114.68 Z14.631 F30000
G1 Z14.231
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.244 E.09636
G1 X131.386 Y117.369 E.00665
G1 X130.877 Y117.369 E.01915
G1 X130.877 Y114.68 E.10106
; CHANGE_LAYER
; Z_HEIGHT: 14.4
; LAYER_HEIGHT: 0.16923
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 116/152
; update layer progress
M73 L116
M991 S0 P115 ;notify layer change
G17
G3 Z14.631 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z14.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z14.8 F30000
G1 X123.098 Y115.948 Z14.8
G1 Z14.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 14.4923
; LAYER_HEIGHT: 0.092308
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 117/152
; update layer progress
M73 L117
M991 S0 P116 ;notify layer change
G17
G3 Z14.8 I1.217 J0 P1  F30000
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
G1 X124.614 Y117.369
G1 Z14.492
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01915
G1 X125.123 Y114.492 E.10814
G1 X124.739 Y114.492 E.01445
G1 X124.739 Y114.256 E.00885
G1 X124.394 Y113.911 E.01833
G1 X119.369 Y113.911 E.18888
G1 X119.369 Y111.615 E.08633
G1 X125.123 Y111.615 E.21629
G1 X125.123 Y108.738 E.10814
G1 X119.369 Y108.738 E.21629
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.001 Y108.738 Z14.892 F30000
G1 X130.877 Y108.738 Z14.892
G1 Z14.492
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.21629
G1 X136.631 Y111.615 E.10814
G1 X130.877 Y111.615 E.21629
G1 X130.877 Y114.492 E.10814
G1 X131.261 Y114.492 E.01445
G1 X131.261 Y114.256 E.00885
M73 P89 R3
G1 X131.606 Y113.911 E.01833
G1 X136.631 Y113.911 E.18888
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.261 Y114.68 Z14.892 F30000
G1 Z14.492
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.244 E.09636
G1 X131.386 Y117.369 E.00665
G1 X130.877 Y117.369 E.01915
G1 X130.877 Y114.68 E.10106
; CHANGE_LAYER
; Z_HEIGHT: 14.6
; LAYER_HEIGHT: 0.107693
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 118/152
; update layer progress
M73 L118
M991 S0 P117 ;notify layer change
G17
G3 Z14.892 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z14.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z15 F30000
G1 X123.098 Y115.948 Z15
G1 Z14.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 14.7538
; LAYER_HEIGHT: 0.153846
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 119/152
; update layer progress
M73 L119
M991 S0 P118 ;notify layer change
G17
G3 Z15 I1.217 J0 P1  F30000
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
G1 X124.614 Y117.369
G1 Z14.754
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01915
G1 X125.123 Y114.492 E.10814
G1 X124.739 Y114.492 E.01445
G1 X124.739 Y114.256 E.00885
G1 X124.394 Y113.911 E.01833
G1 X119.369 Y113.911 E.18888
G1 X119.369 Y111.615 E.08633
G1 X125.123 Y111.615 E.21629
G1 X125.123 Y108.738 E.10814
G1 X119.369 Y108.738 E.21629
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.001 Y108.738 Z15.154 F30000
G1 X130.877 Y108.738 Z15.154
G1 Z14.754
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.21629
G1 X136.631 Y111.615 E.10814
G1 X130.877 Y111.615 E.21629
G1 X130.877 Y114.492 E.10814
G1 X131.261 Y114.492 E.01445
G1 X131.261 Y114.256 E.00885
G1 X131.606 Y113.911 E.01833
G1 X136.631 Y113.911 E.18888
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.261 Y114.68 Z15.154 F30000
G1 Z14.754
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.244 E.09636
G1 X131.386 Y117.369 E.00665
G1 X130.877 Y117.369 E.01915
G1 X130.877 Y114.68 E.10106
; CHANGE_LAYER
; Z_HEIGHT: 14.8
; LAYER_HEIGHT: 0.046154
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 120/152
; update layer progress
M73 L120
M991 S0 P119 ;notify layer change
G17
G3 Z15.154 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z15.2 F30000
G1 X123.098 Y115.948 Z15.2
G1 Z14.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 15
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 121/152
; update layer progress
M73 L121
M991 S0 P120 ;notify layer change
G17
G3 Z15.2 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
M73 P89 R2
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z15.4 F30000
G1 X123.098 Y115.948 Z15.4
G1 Z15
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 15.0154
; LAYER_HEIGHT: 0.0153847
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 122/152
; update layer progress
M73 L122
M991 S0 P121 ;notify layer change
G17
G3 Z15.4 I1.217 J0 P1  F30000
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
G1 X124.614 Y117.369
G1 Z15.015
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01915
G1 X125.123 Y114.492 E.10814
G1 X124.739 Y114.492 E.01445
G1 X124.739 Y114.256 E.00885
G1 X124.394 Y113.911 E.01833
G1 X119.369 Y113.911 E.18888
G1 X119.369 Y111.615 E.08633
G1 X125.123 Y111.615 E.21629
G1 X125.123 Y108.738 E.10814
G1 X119.369 Y108.738 E.21629
; WIPE_START
G1 F3000
G1 X121.369 Y108.738 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.001 Y108.738 Z15.415 F30000
G1 X130.877 Y108.738 Z15.415
G1 Z15.015
G1 E.8 F1800
G1 F1200
G1 X136.631 Y108.738 E.21629
G1 X136.631 Y111.615 E.10814
G1 X130.877 Y111.615 E.21629
G1 X130.877 Y114.492 E.10814
G1 X131.261 Y114.492 E.01445
G1 X131.261 Y114.256 E.00885
G1 X131.606 Y113.911 E.01833
G1 X136.631 Y113.911 E.18888
; WIPE_START
G1 F3000
G1 X134.631 Y113.911 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.261 Y114.68 Z15.415 F30000
G1 Z15.015
M73 P90 R2
G1 E.8 F1800
G1 F1200
G1 X131.261 Y117.244 E.09636
G1 X131.386 Y117.369 E.00665
G1 X130.877 Y117.369 E.01915
G1 X130.877 Y114.68 E.10106
; CHANGE_LAYER
; Z_HEIGHT: 15.2
; LAYER_HEIGHT: 0.184615
; WIPE_START
G1 F3000
G1 X130.877 Y116.68 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 123/152
; update layer progress
M73 L123
M991 S0 P122 ;notify layer change
G17
G3 Z15.415 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z15.6 F30000
G1 X123.098 Y115.948 Z15.6
G1 Z15.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 15.2769
; LAYER_HEIGHT: 0.0769234
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 124/152
; update layer progress
M73 L124
M991 S0 P123 ;notify layer change
G17
G3 Z15.6 I1.217 J0 P1  F30000
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
G1 X124.614 Y117.369
G1 Z15.277
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01915
G1 X125.123 Y114.869 E.09396
G1 X124.739 Y114.869 E.01445
G1 X124.739 Y117.232 E.08882
G1 X124.625 Y114.143 F30000
; FEATURE: Support transition
G1 F1200
G1 X124.738 Y114.256 E.00603
G1 X124.738 Y114.492 E.00886
G1 X125.123 Y114.492 E.01446
G1 X125.123 Y108.737 E.2163
G1 X124.492 Y108.737 E.02373
G1 X124.492 Y114.01 E.19817
G1 X124.394 Y113.912 E.00521
G1 X123.615 Y113.912 E.02928
G1 X123.615 Y108.737 E.19448
G1 X122.738 Y108.737 E.03297
G1 X122.738 Y113.912 E.19448
G1 X121.861 Y113.912 E.03297
G1 X121.861 Y108.737 E.19448
G1 X120.983 Y108.737 E.03297
G1 X120.983 Y113.912 E.19448
G1 X120.106 Y113.912 E.03297
G1 X120.106 Y108.737 E.19448
G1 X119.369 Y108.737 E.02773
G1 X119.369 Y113.912 E.19448
G1 X119.918 Y113.912 E.02064
; WIPE_START
G1 F1500
G1 X119.369 Y113.912 E-.20869
G1 X119.369 Y112.461 E-.55131
; WIPE_END
G1 E-.04 F1800
G1 X126.389 Y115.455 Z15.677 F30000
G1 X130.877 Y117.369 Z15.677
G1 Z15.277
G1 E.8 F1800
; FEATURE: Support
G1 F1200
G1 X131.386 Y117.369 E.01915
G1 X131.261 Y117.244 E.00665
G1 X131.261 Y114.869 E.08926
G1 X130.877 Y114.869 E.01445
G1 X130.877 Y117.18 E.08688
G1 X131.375 Y114.143 F30000
; FEATURE: Support transition
G1 F1200
G1 X131.262 Y114.256 E.00603
G1 X131.262 Y114.492 E.00886
G1 X130.877 Y114.492 E.01446
G1 X130.877 Y108.737 E.2163
G1 X131.508 Y108.737 E.02373
G1 X131.508 Y114.01 E.19817
G1 X131.606 Y113.912 E.00521
G1 X132.385 Y113.912 E.02928
G1 X132.385 Y108.737 E.19448
G1 X133.262 Y108.737 E.03297
G1 X133.262 Y113.912 E.19448
G1 X134.139 Y113.912 E.03297
G1 X134.139 Y108.737 E.19448
G1 X135.017 Y108.737 E.03297
G1 X135.017 Y113.912 E.19448
G1 X135.894 Y113.912 E.03297
G1 X135.894 Y108.737 E.19448
G1 X136.631 Y108.737 E.02773
G1 X136.631 Y113.912 E.19448
G1 X136.082 Y113.912 E.02065
; CHANGE_LAYER
; Z_HEIGHT: 15.4
; LAYER_HEIGHT: 0.123076
; WIPE_START
G1 F1500
G1 X136.631 Y113.912 E-.20872
G1 X136.631 Y112.461 E-.55128
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 125/152
; update layer progress
M73 L125
M991 S0 P124 ;notify layer change
G17
G3 Z15.677 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z15.8 F30000
G1 X123.098 Y115.948 Z15.8
G1 Z15.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 15.5385
; LAYER_HEIGHT: 0.138462
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 126/152
; update layer progress
M73 L126
M991 S0 P125 ;notify layer change
G17
G3 Z15.8 I1.217 J0 P1  F30000
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
G1 X124.614 Y117.369
G1 Z15.538
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01915
G1 X125.123 Y114.869 E.09396
G1 X124.739 Y114.869 E.01445
G1 X124.739 Y117.232 E.08882
; WIPE_START
G1 F3000
G1 X124.739 Y115.232 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.492 Y114.25 Z15.938 F30000
G1 Z15.538
G1 E.8 F1800
; FEATURE: Support interface
G1 F1200
G1 X124.492 Y108.737 E.20718
G1 X123.615 Y108.737 E.03297
G1 X123.615 Y113.912 E.19448
G1 X122.738 Y113.912 E.03297
G1 X122.738 Y108.737 E.19448
G1 X121.861 Y108.737 E.03297
G1 X121.861 Y113.912 E.19448
G1 X120.983 Y113.912 E.03297
G1 X120.983 Y108.737 E.19448
G1 X120.106 Y108.737 E.03297
G1 X120.106 Y114.081 E.20086
; WIPE_START
G1 F1800
G1 X120.106 Y112.081 E-.76
; WIPE_END
G1 E-.04
G1 X126.958 Y115.445 Z15.938 F30000
G1 X130.877 Y117.369 Z15.938
G1 Z15.538
G1 E.8 F1800
; FEATURE: Support
G1 F1200
G1 X131.386 Y117.369 E.01915
G1 X131.261 Y117.244 E.00665
G1 X131.261 Y114.869 E.08926
G1 X130.877 Y114.869 E.01445
G1 X130.877 Y117.18 E.08688
; WIPE_START
G1 F3000
G1 X130.877 Y115.18 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.508 Y114.25 Z15.938 F30000
G1 Z15.538
M73 P91 R2
G1 E.8 F1800
; FEATURE: Support interface
G1 F1200
G1 X131.508 Y108.737 E.20718
G1 X132.385 Y108.737 E.03297
G1 X132.385 Y113.912 E.19448
G1 X133.262 Y113.912 E.03297
G1 X133.262 Y108.737 E.19448
G1 X134.139 Y108.737 E.03297
G1 X134.139 Y113.912 E.19448
G1 X135.017 Y113.912 E.03297
G1 X135.017 Y108.737 E.19448
G1 X135.894 Y108.737 E.03297
G1 X135.894 Y114.081 E.20086
; CHANGE_LAYER
; Z_HEIGHT: 15.6
; LAYER_HEIGHT: 0.0615387
; WIPE_START
G1 F1800
G1 X135.894 Y112.081 E-.76
; WIPE_END
G1 E-.04
; layer num/total_layer_count: 127/152
; update layer progress
M73 L127
M991 S0 P126 ;notify layer change
G17
G3 Z15.938 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z16 F30000
G1 X123.098 Y115.948 Z16
G1 Z15.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 15.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 128/152
; update layer progress
M73 L128
M991 S0 P127 ;notify layer change
G17
G3 Z16 I1.217 J0 P1  F30000
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
G1 X124.614 Y117.369
G1 Z15.8
G1 E.8 F1800
; FEATURE: Support
; LAYER_HEIGHT: 0.261538
G1 F1200
G1 X125.123 Y117.369 E.01915
G1 X125.123 Y114.869 E.09396
G1 X124.739 Y114.869 E.01445
G1 X124.739 Y117.232 E.08882
; WIPE_START
G1 F3000
G1 X124.739 Y115.232 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.492 Y114.25 Z16.2 F30000
G1 Z15.8
G1 E.8 F1800
; FEATURE: Support interface
G1 F1200
G1 X124.492 Y108.737 E.20719
G1 X123.615 Y108.737 E.03297
G1 X123.615 Y113.912 E.19448
G1 X122.738 Y113.912 E.03297
G1 X122.738 Y108.737 E.19448
G1 X121.861 Y108.737 E.03297
G1 X121.861 Y113.912 E.19448
G1 X120.983 Y113.912 E.03297
G1 X120.983 Y108.737 E.19448
G1 X120.106 Y108.737 E.03297
G1 X120.106 Y114.081 E.20086
; WIPE_START
G1 F1800
G1 X120.106 Y112.081 E-.76
; WIPE_END
G1 E-.04
G1 X126.958 Y115.445 Z16.2 F30000
G1 X130.877 Y117.369 Z16.2
G1 Z15.8
G1 E.8 F1800
; FEATURE: Support
G1 F1200
G1 X131.386 Y117.369 E.01915
G1 X131.261 Y117.244 E.00665
G1 X131.261 Y114.869 E.08926
G1 X130.877 Y114.869 E.01445
G1 X130.877 Y117.18 E.08688
; WIPE_START
G1 F3000
G1 X130.877 Y115.18 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.508 Y114.25 Z16.2 F30000
G1 Z15.8
G1 E.8 F1800
; FEATURE: Support interface
G1 F1200
G1 X131.508 Y108.737 E.20719
G1 X132.385 Y108.737 E.03297
G1 X132.385 Y113.912 E.19448
G1 X133.262 Y113.912 E.03297
G1 X133.262 Y108.737 E.19448
G1 X134.139 Y108.737 E.03297
G1 X134.139 Y113.912 E.19448
G1 X135.017 Y113.912 E.03297
G1 X135.017 Y108.737 E.19448
G1 X135.894 Y108.737 E.03297
G1 X135.894 Y114.081 E.20086
; WIPE_START
G1 F1800
G1 X135.894 Y112.081 E-.76
; WIPE_END
G1 E-.04
G1 X132.902 Y115.552 Z16.2 F30000
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
; LAYER_HEIGHT: 0.2
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z16.2 F30000
G1 X123.098 Y115.948 Z16.2
G1 Z15.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 16
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 129/152
; update layer progress
M73 L129
M991 S0 P128 ;notify layer change
G17
G3 Z16.2 I1.217 J0 P1  F30000
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
G1 X120.106 Y114.081
G1 Z16
G1 E.8 F1800
; FEATURE: Support interface
G1 F1200
G1 X120.106 Y108.737 E.15917
G1 X120.983 Y108.737 E.02612
G1 X120.983 Y111.112 E.07072
G1 X121.861 Y111.112 E.02612
G1 X121.861 Y108.737 E.07072
G1 X122.738 Y108.737 E.02612
G1 X122.738 Y113.912 E.15412
G1 X123.615 Y113.912 E.02612
G1 X123.615 Y108.737 E.15412
G1 X124.492 Y108.737 E.02612
G1 X124.492 Y114.25 E.16419
; WIPE_START
G1 F1800
G1 X124.492 Y112.25 E-.76
; WIPE_END
G1 E-.04
G1 X131.508 Y114.25 Z16.4 F30000
G1 Z16
G1 E.8 F1800
G1 F1200
G1 X131.508 Y108.737 E.16419
G1 X132.385 Y108.737 E.02612
G1 X132.385 Y113.912 E.15412
G1 X133.262 Y113.912 E.02612
G1 X133.262 Y108.737 E.15412
G1 X134.139 Y108.737 E.02612
G1 X134.139 Y111.112 E.07072
G1 X135.017 Y111.112 E.02612
G1 X135.017 Y108.737 E.07072
G1 X135.894 Y108.737 E.02612
G1 X135.894 Y114.081 E.15917
; WIPE_START
G1 F1800
G1 X135.894 Y112.081 E-.76
; WIPE_END
G1 E-.04
G1 X132.902 Y115.552 Z16.4 F30000
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
M73 P92 R2
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.474 Y115.574 Z16.4 F30000
G1 X123.098 Y115.948 Z16.4
G1 Z16
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.098 Y115.552 E.09312
G1 X123.098 Y115.908 E.01144
G1 X123.505 Y116.355 F30000
G1 F1200
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.505 Y115.145 E.1193
G1 X123.505 Y116.315 E.03762
M204 S250
G1 X123.94 Y116.79 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.94 Y114.71 E.13642
G1 X123.94 Y116.75 E.06076
; CHANGE_LAYER
; Z_HEIGHT: 16.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F2400
M204 S10000
G1 X121.94 Y116.767 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 130/152
; update layer progress
M73 L130
M991 S0 P129 ;notify layer change
G17
G3 Z16.4 I1.217 J0 P1  F30000
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
G1 X134.79 Y115.552
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.552 E.0324
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.552 E.01273
G1 X134.75 Y115.552 E.05944
G1 X134.383 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.05858
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.145 E.03891
G1 X134.343 Y115.145 E.05944
M204 S250
G1 X133.948 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X133.948 Y114.669 E.00122
G1 X133.948 Y114.3 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X133.948 Y111.71 E.08329
G1 X134.752 Y111.71 E.02583
G1 X134.752 Y114.3 E.08329
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X134.752 Y114.669 E.01099
G1 X134.752 Y114.71 E.00122
G1 X136.64 Y114.71 E.05625
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.71 E.06196
G1 X133.908 Y114.71 E.05506
M204 S10000
G1 X134.35 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.41115
G1 F1200
G1 X134.35 Y111.927 E.08726
; WIPE_START
G1 F6517.666
G1 X134.35 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z16.6 I-.16 J-1.206 P1  F30000
G1 X122.09 Y115.552 Z16.6
G1 Z16.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.098 Y115.552 E.0324
G1 X123.098 Y115.948 E.01273
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X122.05 Y115.552 E.05944
G1 X121.683 Y115.145 F30000
G1 F1200
G1 X123.505 Y115.145 E.05858
G1 X123.505 Y116.355 E.03891
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X121.643 Y115.145 E.05944
M204 S250
G1 X121.248 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X121.248 Y114.669 E.00122
G1 X121.248 Y114.3 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X121.248 Y111.71 E.08329
G1 X122.052 Y111.71 E.02583
G1 X122.052 Y114.3 E.08329
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X122.052 Y114.669 E.01099
G1 X122.052 Y114.71 E.00122
G1 X123.94 Y114.71 E.05625
G1 X123.94 Y116.79 E.06196
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X121.208 Y114.71 E.05506
M204 S10000
G1 X121.65 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.41115
G1 F1200
G1 X121.65 Y111.927 E.08726
; CHANGE_LAYER
; Z_HEIGHT: 16.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F6517.666
G1 X121.65 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 131/152
; update layer progress
M73 L131
M991 S0 P130 ;notify layer change
G17
G3 Z16.6 I1.217 J0 P1  F30000
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
G1 X134.354 Y115.552
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.552 E.04643
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.552 E.01273
G1 X134.314 Y115.552 E.0454
G1 X133.947 Y115.145 F30000
G1 F1200
G1 X133.947 Y112.145 E.09647
G1 X134.753 Y112.145 E.02592
G1 X134.753 Y115.145 E.09647
G1 X136.205 Y115.145 E.04669
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.145 E.03891
G1 X133.907 Y115.145 E.0454
M204 S250
G1 X133.512 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X133.512 Y114.669 E.00122
G1 X133.512 Y114.3 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X133.512 Y111.71 E.08329
G1 X133.538 Y111.71 E.00085
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X133.907 Y111.71 E.01099
G1 X134.793 Y111.71 E.02637
G1 X135.162 Y111.71 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X135.188 Y111.71 E.00085
G1 X135.188 Y114.3 E.08329
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X135.188 Y114.669 E.01099
G1 X135.188 Y114.71 E.00122
G1 X136.64 Y114.71 E.04325
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.71 E.06196
G1 X133.472 Y114.71 E.04206
; WIPE_START
G1 F2400
M204 S10000
G1 X133.512 Y114.669 E-.02176
G1 X133.512 Y114.3 E-.14022
G1 X133.512 Y112.726 E-.59802
; WIPE_END
G1 E-.04 F1800
G1 X134.35 Y115.348 Z16.8 F30000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4419
G1 F1200
G1 X134.35 Y112.349 E.09455
; WIPE_START
G1 F6015.339
G1 X134.35 Y114.349 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z16.8 I-.115 J-1.212 P1  F30000
G1 X121.654 Y115.552 Z16.8
G1 Z16.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.098 Y115.552 E.04643
G1 X123.098 Y115.948 E.01273
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X121.614 Y115.552 E.0454
G1 X121.247 Y115.145 F30000
G1 F1200
G1 X121.247 Y112.145 E.09647
G1 X122.053 Y112.145 E.02592
G1 X122.053 Y115.145 E.09647
G1 X123.505 Y115.145 E.04669
G1 X123.505 Y116.355 E.03891
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X121.207 Y115.145 E.0454
M204 S250
G1 X120.812 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X120.812 Y114.669 E.00122
G1 X120.812 Y114.3 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X120.812 Y111.71 E.08329
G1 X120.838 Y111.71 E.00085
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X121.207 Y111.71 E.01099
G1 X122.093 Y111.71 E.02637
G1 X122.462 Y111.71 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F600
G1 X122.488 Y111.71 E.00085
G1 X122.488 Y114.3 E.08329
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X122.488 Y114.669 E.01099
G1 X122.488 Y114.71 E.00122
G1 X123.94 Y114.71 E.04325
G1 X123.94 Y116.79 E.06196
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X120.772 Y114.71 E.04206
; WIPE_START
G1 F2400
M204 S10000
G1 X120.812 Y114.669 E-.02176
G1 X120.812 Y114.3 E-.14022
G1 X120.812 Y112.726 E-.59802
; WIPE_END
G1 E-.04 F1800
G1 X121.65 Y115.348 Z16.8 F30000
G1 Z16.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.4419
G1 F1200
G1 X121.65 Y112.349 E.09455
; CHANGE_LAYER
; Z_HEIGHT: 16.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F6015.339
G1 X121.65 Y114.349 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 132/152
; update layer progress
M73 L132
M991 S0 P131 ;notify layer change
G17
G3 Z16.8 I1.217 J0 P1  F30000
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
G1 X134.086 Y115.552
G1 Z16.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X134.086 Y112.552 E.09647
G1 X134.614 Y112.552 E.017
G1 X134.614 Y115.552 E.09647
G1 X135.798 Y115.552 E.03806
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.552 E.01273
G1 X134.046 Y115.552 E.03677
G1 X133.679 Y115.145 F30000
G1 F1200
G1 X133.679 Y112.145 E.09647
G1 X135.021 Y112.145 E.04318
G1 X135.021 Y115.145 E.09647
G1 X136.205 Y115.145 E.03806
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.145 E.03891
M73 P93 R2
G1 X133.639 Y115.145 E.03677
M204 S250
G1 X133.244 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X133.244 Y114.669 E.00122
G1 X133.244 Y111.71 E.08814
G1 X133.471 Y111.71 E.00677
G1 X135.229 Y111.71 E.05237
G1 X135.456 Y111.71 E.00677
G1 X135.456 Y114.669 E.08814
G1 X135.456 Y114.71 E.00122
G1 X135.856 Y114.71 E.01191
G1 X136.64 Y114.71 E.02334
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.71 E.06196
G1 X133.204 Y114.71 E.03406
; WIPE_START
G1 F2400
M204 S10000
G1 X133.244 Y114.669 E-.02176
G1 X133.244 Y112.726 E-.73824
; WIPE_END
G1 E-.04 F1800
G1 X134.35 Y115.744 Z17 F30000
G1 Z16.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.16448
G1 F1200
G1 X134.35 Y112.756 E.0287
; WIPE_START
G1 F15000
G1 X134.35 Y114.756 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z17 I-.075 J-1.215 P1  F30000
G1 X121.386 Y115.552 Z17
G1 Z16.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X121.386 Y112.552 E.09647
G1 X121.914 Y112.552 E.017
G1 X121.914 Y115.552 E.09647
G1 X123.098 Y115.552 E.03806
G1 X123.098 Y115.948 E.01273
G1 X120.202 Y115.948 E.09312
M73 P93 R1
G1 X120.202 Y115.552 E.01273
G1 X121.346 Y115.552 E.03677
G1 X120.979 Y115.145 F30000
G1 F1200
G1 X120.979 Y112.145 E.09647
G1 X122.321 Y112.145 E.04318
G1 X122.321 Y115.145 E.09647
G1 X123.505 Y115.145 E.03806
G1 X123.505 Y116.355 E.03891
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X120.939 Y115.145 E.03677
M204 S250
G1 X120.544 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X120.544 Y114.669 E.00122
G1 X120.544 Y111.71 E.08814
G1 X120.771 Y111.71 E.00677
G1 X122.529 Y111.71 E.05237
G1 X122.756 Y111.71 E.00677
G1 X122.756 Y114.669 E.08814
G1 X122.756 Y114.71 E.00122
G1 X123.156 Y114.71 E.01191
G1 X123.94 Y114.71 E.02334
G1 X123.94 Y116.79 E.06196
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X120.504 Y114.71 E.03406
; WIPE_START
G1 F2400
M204 S10000
G1 X120.544 Y114.669 E-.02176
G1 X120.544 Y112.726 E-.73824
; WIPE_END
G1 E-.04 F1800
G1 X121.65 Y115.744 Z17 F30000
G1 Z16.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.16448
G1 F1200
G1 X121.65 Y112.756 E.0287
; CHANGE_LAYER
; Z_HEIGHT: 16.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X121.65 Y114.756 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 133/152
; update layer progress
M73 L133
M991 S0 P132 ;notify layer change
G17
G3 Z17 I1.217 J0 P1  F30000
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
G1 X133.888 Y115.552
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X133.888 Y112.552 E.09647
G1 X134.812 Y112.552 E.02973
G1 X134.812 Y115.552 E.09647
G1 X135.798 Y115.552 E.03169
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.552 E.01273
G1 X133.848 Y115.552 E.03041
G1 X133.481 Y115.145 F30000
G1 F1200
G1 X133.481 Y112.145 E.09647
G1 X135.219 Y112.145 E.05591
G1 X135.219 Y115.145 E.09647
G1 X136.205 Y115.145 E.03169
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.145 E.03891
G1 X133.441 Y115.145 E.03041
M204 S250
G1 X133.046 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X133.046 Y114.669 E.00122
G1 X133.046 Y111.71 E.08814
G1 X133.203 Y111.71 E.00468
G1 X135.497 Y111.71 E.06835
G1 X135.654 Y111.71 E.00468
G1 X135.654 Y114.669 E.08814
G1 X135.654 Y114.71 E.00122
G1 X136.64 Y114.71 E.02936
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.71 E.06196
G1 X133.006 Y114.71 E.02817
; WIPE_START
G1 F2400
M204 S10000
G1 X133.046 Y114.669 E-.02176
G1 X133.046 Y112.726 E-.73824
; WIPE_END
G1 E-.04 F1800
G1 X134.35 Y115.744 Z17.2 F30000
G1 Z16.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.56044
G1 F1200
G1 X134.35 Y112.756 E.12218
; WIPE_START
G1 F4637.502
G1 X134.35 Y114.756 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z17.2 I-.074 J-1.215 P1  F30000
G1 X121.188 Y115.552 Z17.2
G1 Z16.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X121.188 Y112.552 E.09647
G1 X122.112 Y112.552 E.02973
G1 X122.112 Y115.552 E.09647
G1 X123.098 Y115.552 E.03169
G1 X123.098 Y115.948 E.01273
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X121.148 Y115.552 E.03041
G1 X120.781 Y115.145 F30000
G1 F1200
G1 X120.781 Y112.145 E.09647
G1 X122.519 Y112.145 E.05591
G1 X122.519 Y115.145 E.09647
G1 X123.505 Y115.145 E.03169
G1 X123.505 Y116.355 E.03891
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X120.741 Y115.145 E.03041
M204 S250
G1 X120.346 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X120.346 Y114.669 E.00122
G1 X120.346 Y111.71 E.08814
G1 X120.503 Y111.71 E.00468
G1 X122.797 Y111.71 E.06835
G1 X122.954 Y111.71 E.00468
G1 X122.954 Y114.669 E.08814
G1 X122.954 Y114.71 E.00122
G1 X123.94 Y114.71 E.02936
G1 X123.94 Y116.79 E.06196
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X120.306 Y114.71 E.02817
; WIPE_START
G1 F2400
M204 S10000
G1 X120.346 Y114.669 E-.02176
G1 X120.346 Y112.726 E-.73824
; WIPE_END
G1 E-.04 F1800
G1 X121.65 Y115.744 Z17.2 F30000
G1 Z16.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.56044
G1 F1200
G1 X121.65 Y112.756 E.12218
; CHANGE_LAYER
; Z_HEIGHT: 17
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F4637.502
G1 X121.65 Y114.756 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 134/152
; update layer progress
M73 L134
M991 S0 P133 ;notify layer change
G17
G3 Z17.2 I1.217 J0 P1  F30000
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
G1 X135.37 Y115.145
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X136.205 Y115.145 E.02684
G1 X136.205 Y116.355 E.03891
G1 X135.324 Y116.355 E.02831
G1 X135.324 Y115.145 E.03891
G1 X135.33 Y115.145 E.00018
M204 S250
G1 X135.805 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.02486
G1 X136.64 Y116.79 E.06196
G1 X134.889 Y116.79 E.05214
G1 X134.889 Y111.71 E.15132
G1 X135.695 Y111.71 E.024
G1 X135.805 Y111.71 E.00327
G1 X135.805 Y114.669 E.08814
G1 X135.805 Y114.67 E.00003
M204 S10000
G1 X135.347 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52367
G1 F1200
G1 X135.347 Y111.927 E.11392
; WIPE_START
G1 F4992.2
G1 X135.347 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X133.33 Y115.145 Z17.4 F30000
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X133.376 Y115.145 E.00147
G1 X133.376 Y116.355 E.03891
G1 X132.495 Y116.355 E.02831
G1 X132.495 Y115.145 E.03891
G1 X133.29 Y115.145 E.02556
M204 S250
G1 X132.895 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X132.895 Y114.669 E.00122
G1 X132.895 Y111.71 E.08814
G1 X133.005 Y111.71 E.00327
G1 X133.811 Y111.71 E.024
G1 X133.811 Y116.79 E.15132
G1 X132.06 Y116.79 E.05214
G1 X132.06 Y114.71 E.06196
G1 X132.855 Y114.71 E.02367
M204 S10000
G1 X133.353 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52367
G1 F1200
G1 X133.353 Y111.927 E.11392
; WIPE_START
G1 F4992.2
G1 X133.353 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X125.769 Y114.792 Z17.4 F30000
G1 X122.67 Y115.145 Z17.4
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.505 Y115.145 E.02684
G1 X123.505 Y116.355 E.03891
G1 X122.624 Y116.355 E.02831
G1 X122.624 Y115.145 E.03891
G1 X122.63 Y115.145 E.00019
M204 S250
G1 X123.105 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.02486
G1 X123.94 Y116.79 E.06196
G1 X122.189 Y116.79 E.05214
G1 X122.189 Y111.71 E.15132
G1 X122.995 Y111.71 E.024
G1 X123.105 Y111.71 E.00327
G1 X123.105 Y114.669 E.08814
G1 X123.105 Y114.67 E.00003
M204 S10000
G1 X122.647 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52367
G1 F1200
G1 X122.647 Y111.927 E.11392
; WIPE_START
G1 F4992.2
G1 X122.647 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X120.63 Y115.145 Z17.4 F30000
G1 Z17
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.676 Y115.145 E.00147
G1 X120.676 Y116.355 E.03891
G1 X119.795 Y116.355 E.02831
G1 X119.795 Y115.145 E.03891
G1 X120.59 Y115.145 E.02556
M204 S250
G1 X120.195 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X120.195 Y114.669 E.00122
G1 X120.195 Y111.71 E.08814
G1 X120.305 Y111.71 E.00327
G1 X121.111 Y111.71 E.024
G1 X121.111 Y116.79 E.15132
G1 X119.36 Y116.79 E.05214
G1 X119.36 Y114.71 E.06196
G1 X120.155 Y114.71 E.02367
M204 S10000
G1 X120.653 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52367
G1 F1200
G1 X120.653 Y111.927 E.11392
; CHANGE_LAYER
; Z_HEIGHT: 17.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F4992.2
G1 X120.653 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 135/152
; update layer progress
M73 L135
M991 S0 P134 ;notify layer change
G17
G3 Z17.4 I1.217 J0 P1  F30000
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
G1 X120.291 Y115.145
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.291 Y116.355 E.03891
G1 X119.795 Y116.355 E.01594
G1 X119.795 Y115.145 E.03891
G1 X120.251 Y115.145 E.01466
M204 S250
G1 X120.079 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X120.079 Y114.669 E.00122
G1 X120.079 Y111.71 E.08814
G1 X120.154 Y111.71 E.00224
G1 X120.726 Y111.71 E.01704
G1 X120.726 Y116.79 E.15132
G1 X119.36 Y116.79 E.04068
G1 X119.36 Y114.71 E.06196
G1 X120.039 Y114.71 E.02021
M204 S10000
G1 X120.402 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.25508
G1 F1200
G1 X120.402 Y111.927 E.05028
; WIPE_START
G1 F11312.218
G1 X120.402 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
M73 P94 R1
G1 X120.043 Y115.349 Z17.6 F30000
G1 Z17.2
G1 E.8 F1800
; LINE_WIDTH: 0.13164
G1 F1200
G1 X120.043 Y116.151 E.00563
; WIPE_START
G1 F15000
G1 X120.043 Y115.349 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.009 Y115.145 Z17.6 F30000
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.505 Y115.145 E.01594
G1 X123.505 Y116.355 E.03891
G1 X123.009 Y116.355 E.01594
G1 X123.009 Y115.185 E.03762
M204 S250
G1 X123.221 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.02141
G1 X123.94 Y116.79 E.06196
G1 X122.574 Y116.79 E.04068
G1 X122.574 Y111.71 E.15132
G1 X123.146 Y111.71 E.01704
G1 X123.221 Y111.71 E.00224
G1 X123.221 Y114.669 E.08814
G1 X123.221 Y114.67 E.00003
M204 S10000
G1 X122.898 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.25508
G1 F1200
G1 X122.898 Y111.927 E.05028
; WIPE_START
G1 F11312.218
G1 X122.898 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.257 Y115.349 Z17.6 F30000
G1 Z17.2
G1 E.8 F1800
; LINE_WIDTH: 0.13164
G1 F1200
G1 X123.257 Y116.151 E.00563
; WIPE_START
G1 F15000
G1 X123.257 Y115.349 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X130.888 Y115.189 Z17.6 F30000
G1 X132.991 Y115.145 Z17.6
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X132.991 Y116.355 E.03891
G1 X132.495 Y116.355 E.01594
G1 X132.495 Y115.145 E.03891
G1 X132.951 Y115.145 E.01466
M204 S250
G1 X132.779 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X132.779 Y114.669 E.00122
G1 X132.779 Y111.71 E.08814
G1 X132.854 Y111.71 E.00224
G1 X133.426 Y111.71 E.01704
G1 X133.426 Y116.79 E.15132
G1 X132.06 Y116.79 E.04068
G1 X132.06 Y114.71 E.06196
G1 X132.739 Y114.71 E.02021
M204 S10000
G1 X133.102 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.25508
G1 F1200
G1 X133.102 Y111.927 E.05028
; WIPE_START
G1 F11312.218
G1 X133.102 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X132.743 Y115.349 Z17.6 F30000
G1 Z17.2
G1 E.8 F1800
; LINE_WIDTH: 0.13164
G1 F1200
G1 X132.743 Y116.151 E.00563
; WIPE_START
G1 F15000
G1 X132.743 Y115.349 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.921 Y115.145 Z17.6 F30000
G1 Z17.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X136.205 Y115.145 E.00912
G1 X136.205 Y116.355 E.03891
G1 X135.709 Y116.355 E.01594
G1 X135.709 Y115.145 E.03891
G1 X135.881 Y115.145 E.00554
M204 S250
G1 X135.921 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.02141
G1 X136.64 Y116.79 E.06196
G1 X135.274 Y116.79 E.04068
G1 X135.274 Y111.71 E.15132
G1 X135.846 Y111.71 E.01704
G1 X135.921 Y111.71 E.00224
G1 X135.921 Y114.669 E.08814
G1 X135.921 Y114.67 E.00003
M204 S10000
G1 X135.598 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.25508
G1 F1200
G1 X135.598 Y111.927 E.05028
; WIPE_START
G1 F11312.218
G1 X135.598 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.957 Y115.349 Z17.6 F30000
G1 Z17.2
G1 E.8 F1800
; LINE_WIDTH: 0.13164
G1 F1200
G1 X135.957 Y116.151 E.00563
; CHANGE_LAYER
; Z_HEIGHT: 17.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X135.957 Y115.349 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 136/152
; update layer progress
M73 L136
M991 S0 P135 ;notify layer change
G17
G3 Z17.6 I1.217 J0 P1  F30000
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
G1 X135.907 Y115.145
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X136.205 Y115.145 E.00957
G1 X136.205 Y116.355 E.03891
G1 X135.907 Y116.355 E.00957
G1 X135.907 Y115.185 E.03762
M204 S250
G1 X136.01 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.01877
G1 X136.64 Y116.79 E.06196
G1 X135.472 Y116.79 E.03478
G1 X135.472 Y111.71 E.15132
G1 X135.962 Y111.71 E.01459
G1 X136.01 Y111.71 E.00142
G1 X136.01 Y114.669 E.08814
G1 X136.01 Y114.67 E.00003
M204 S10000
G1 X135.741 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.14545
G1 F1200
G1 X135.741 Y111.927 E.0243
; WIPE_START
G1 F15000
G1 X135.741 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X132.793 Y115.145 Z17.8 F30000
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X132.793 Y116.355 E.03891
G1 X132.495 Y116.355 E.00957
G1 X132.495 Y115.145 E.03891
G1 X132.753 Y115.145 E.00828
M204 S250
G1 X132.69 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X132.69 Y114.669 E.00122
G1 X132.69 Y111.71 E.08814
G1 X132.738 Y111.71 E.00142
G1 X133.228 Y111.71 E.01459
G1 X133.228 Y116.79 E.15132
G1 X132.06 Y116.79 E.03478
G1 X132.06 Y114.71 E.06196
G1 X132.65 Y114.71 E.01758
M204 S10000
G1 X132.959 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.14545
G1 F1200
G1 X132.959 Y111.927 E.0243
; WIPE_START
G1 F15000
G1 X132.959 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X125.386 Y114.883 Z17.8 F30000
G1 X123.31 Y115.145 Z17.8
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.505 Y115.145 E.00627
G1 X123.505 Y116.355 E.03891
G1 X123.207 Y116.355 E.00957
G1 X123.207 Y115.145 E.03891
G1 X123.27 Y115.145 E.00201
M204 S250
G1 X123.31 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.01877
G1 X123.94 Y116.79 E.06196
G1 X122.772 Y116.79 E.03478
G1 X122.772 Y111.71 E.15132
G1 X123.262 Y111.71 E.01459
G1 X123.31 Y111.71 E.00142
G1 X123.31 Y114.669 E.08814
G1 X123.31 Y114.67 E.00003
M204 S10000
G1 X123.041 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.14545
G1 F1200
G1 X123.041 Y111.927 E.0243
; WIPE_START
G1 F15000
G1 X123.041 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X120.093 Y115.145 Z17.8 F30000
G1 Z17.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.093 Y116.355 E.03891
G1 X119.795 Y116.355 E.00957
G1 X119.795 Y115.145 E.03891
G1 X120.053 Y115.145 E.00828
M204 S250
G1 X119.99 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.99 Y114.669 E.00122
G1 X119.99 Y111.71 E.08814
G1 X120.038 Y111.71 E.00142
G1 X120.528 Y111.71 E.01459
G1 X120.528 Y116.79 E.15132
G1 X119.36 Y116.79 E.03478
G1 X119.36 Y114.71 E.06196
G1 X119.95 Y114.71 E.01758
M204 S10000
G1 X120.259 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.14545
G1 F1200
G1 X120.259 Y111.927 E.0243
; CHANGE_LAYER
; Z_HEIGHT: 17.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X120.259 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 137/152
; update layer progress
M73 L137
M991 S0 P136 ;notify layer change
G17
G3 Z17.8 I1.217 J0 P1  F30000
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
M204 S250
G1 X119.925 Y114.71
M204 S10000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.925 Y114.669 E.00122
G1 X119.925 Y111.71 E.08814
G1 X119.949 Y111.71 E.00073
G1 X120.407 Y111.71 E.01364
G1 X120.407 Y116.79 E.15132
G1 X119.36 Y116.79 E.03119
G1 X119.36 Y114.71 E.06196
G1 X119.885 Y114.71 E.01563
M204 S10000
G1 X119.884 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.65501
G1 F1200
G1 X119.884 Y116.572 E.07954
; WIPE_START
G1 F3920.992
G1 X119.884 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.375 Y114.71 Z18 F30000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.01682
G1 X123.94 Y116.79 E.06196
G1 X122.893 Y116.79 E.03119
G1 X122.893 Y111.71 E.15132
G1 X123.351 Y111.71 E.01364
G1 X123.375 Y111.71 E.00073
G1 X123.375 Y114.669 E.08814
G1 X123.375 Y114.67 E.00003
M204 S10000
G1 X123.416 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.65501
G1 F1200
G1 X123.416 Y116.572 E.07954
; WIPE_START
G1 F3920.992
G1 X123.416 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.047 Y114.747 Z18 F30000
G1 X132.625 Y114.71 Z18
G1 Z17.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X132.625 Y114.669 E.00122
G1 X132.625 Y111.71 E.08814
G1 X132.649 Y111.71 E.00073
G1 X133.107 Y111.71 E.01364
G1 X133.107 Y116.79 E.15132
G1 X132.06 Y116.79 E.03119
G1 X132.06 Y114.71 E.06196
G1 X132.585 Y114.71 E.01563
M204 S10000
G1 X132.584 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.65501
G1 F1200
G1 X132.584 Y116.572 E.07954
; WIPE_START
G1 F3920.992
G1 X132.584 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.075 Y114.71 Z18 F30000
G1 Z17.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.01682
G1 X136.64 Y116.79 E.06196
G1 X135.593 Y116.79 E.03119
G1 X135.593 Y111.71 E.15132
G1 X136.051 Y111.71 E.01364
G1 X136.075 Y111.71 E.00073
G1 X136.075 Y114.669 E.08814
G1 X136.075 Y114.67 E.00003
M204 S10000
G1 X136.116 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.65501
G1 F1200
G1 X136.116 Y116.572 E.07954
; CHANGE_LAYER
; Z_HEIGHT: 17.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F3920.992
G1 X136.116 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 138/152
; update layer progress
M73 L138
M991 S0 P137 ;notify layer change
G17
G3 Z18 I1.217 J0 P1  F30000
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
G1 X119.885 Y114.71
G1 Z17.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.885 Y111.71 E.08936
G1 X120.33 Y111.71 E.01326
G1 X120.33 Y116.79 E.15132
G1 X119.36 Y116.79 E.02889
G1 X119.36 Y114.71 E.06196
G1 X119.845 Y114.71 E.01444
M204 S10000
G1 X119.845 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.57793
G1 F1200
G1 X119.845 Y116.572 E.06952
; WIPE_START
G1 F4485.898
G1 X119.845 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.415 Y114.71 Z18.2 F30000
G1 Z17.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.01563
G1 X123.94 Y116.79 E.06196
G1 X122.97 Y116.79 E.02889
G1 X122.97 Y111.71 E.15132
G1 X123.415 Y111.71 E.01326
G1 X123.415 Y114.67 E.08817
M204 S10000
G1 X123.455 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.57792
G1 F1200
G1 X123.455 Y116.572 E.06952
; WIPE_START
G1 F4485.982
G1 X123.455 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.085 Y114.746 Z18.2 F30000
G1 X132.585 Y114.71 Z18.2
G1 Z17.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X132.585 Y111.71 E.08936
G1 X133.03 Y111.71 E.01326
G1 X133.03 Y116.79 E.15132
G1 X132.06 Y116.79 E.02889
G1 X132.06 Y114.71 E.06196
G1 X132.545 Y114.71 E.01444
M204 S10000
G1 X132.545 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.57792
G1 F1200
G1 X132.545 Y116.572 E.06952
; WIPE_START
G1 F4485.982
G1 X132.545 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.115 Y114.71 Z18.2 F30000
G1 Z17.8
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.01563
G1 X136.64 Y116.79 E.06196
G1 X135.67 Y116.79 E.02889
G1 X135.67 Y111.71 E.15132
G1 X136.115 Y111.71 E.01326
G1 X136.115 Y114.67 E.08817
M204 S10000
G1 X136.155 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.57793
G1 F1200
G1 X136.155 Y116.572 E.06952
; CHANGE_LAYER
; Z_HEIGHT: 18
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F4485.898
G1 X136.155 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 139/152
; update layer progress
M73 L139
M991 S0 P138 ;notify layer change
G17
G3 Z18.2 I1.217 J0 P1  F30000
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
G1 X119.867 Y114.71
G1 Z18
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.867 Y111.71 E.08936
G1 X120.297 Y111.71 E.01281
G1 X120.297 Y116.79 E.15132
G1 X119.36 Y116.79 E.0279
G1 X119.36 Y114.71 E.06196
G1 X119.827 Y114.71 E.0139
M204 S10000
G1 X119.828 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.54449
G1 F1200
G1 X119.828 Y116.572 E.06518
; WIPE_START
G1 F4784.975
G1 X119.828 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.433 Y114.71 Z18.4 F30000
G1 Z18
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.01509
G1 X123.94 Y116.79 E.06196
G1 X123.003 Y116.79 E.0279
G1 X123.003 Y111.71 E.15132
G1 X123.433 Y111.71 E.01281
G1 X123.433 Y114.67 E.08817
M204 S10000
G1 X123.472 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.54449
G1 F1200
G1 X123.472 Y116.572 E.06518
; WIPE_START
G1 F4784.975
G1 X123.472 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.102 Y114.745 Z18.4 F30000
G1 X132.567 Y114.71 Z18.4
G1 Z18
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P95 R1
G1 X132.567 Y111.71 E.08936
G1 X132.997 Y111.71 E.01281
G1 X132.997 Y116.79 E.15132
G1 X132.06 Y116.79 E.0279
G1 X132.06 Y114.71 E.06196
G1 X132.527 Y114.71 E.0139
M204 S10000
G1 X132.528 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.54449
G1 F1200
G1 X132.528 Y116.572 E.06518
; WIPE_START
G1 F4784.975
G1 X132.528 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.133 Y114.71 Z18.4 F30000
G1 Z18
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.01509
G1 X136.64 Y116.79 E.06196
G1 X135.703 Y116.79 E.0279
G1 X135.703 Y111.71 E.15132
G1 X136.133 Y111.71 E.01281
G1 X136.133 Y114.67 E.08817
M204 S10000
G1 X136.172 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.54449
G1 F1200
G1 X136.172 Y116.572 E.06518
; CHANGE_LAYER
; Z_HEIGHT: 18.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F4784.975
G1 X136.172 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 140/152
; update layer progress
M73 L140
M991 S0 P139 ;notify layer change
G17
G3 Z18.4 I1.217 J0 P1  F30000
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
G1 X119.867 Y114.71
G1 Z18.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.867 Y111.71 E.08936
G1 X120.297 Y111.71 E.01281
G1 X120.297 Y116.79 E.15132
G1 X119.36 Y116.79 E.0279
G1 X119.36 Y114.71 E.06196
G1 X119.827 Y114.71 E.0139
M204 S10000
G1 X119.828 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.54449
G1 F1200
G1 X119.828 Y116.572 E.06518
; WIPE_START
G1 F4784.975
G1 X119.828 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.433 Y114.71 Z18.6 F30000
G1 Z18.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.01509
G1 X123.94 Y116.79 E.06196
G1 X123.003 Y116.79 E.0279
G1 X123.003 Y111.71 E.15132
G1 X123.433 Y111.71 E.01281
G1 X123.433 Y114.67 E.08817
M204 S10000
G1 X123.472 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.54449
G1 F1200
G1 X123.472 Y116.572 E.06518
; WIPE_START
G1 F4784.975
G1 X123.472 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.102 Y114.745 Z18.6 F30000
G1 X132.567 Y114.71 Z18.6
G1 Z18.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X132.567 Y111.71 E.08936
G1 X132.997 Y111.71 E.01281
G1 X132.997 Y116.79 E.15132
G1 X132.06 Y116.79 E.0279
G1 X132.06 Y114.71 E.06196
G1 X132.527 Y114.71 E.0139
M204 S10000
G1 X132.528 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.54449
G1 F1200
G1 X132.528 Y116.572 E.06518
; WIPE_START
G1 F4784.975
G1 X132.528 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.133 Y114.71 Z18.6 F30000
G1 Z18.2
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.01509
G1 X136.64 Y116.79 E.06196
G1 X135.703 Y116.79 E.0279
G1 X135.703 Y111.71 E.15132
G1 X136.133 Y111.71 E.01281
G1 X136.133 Y114.67 E.08817
M204 S10000
G1 X136.172 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.54449
G1 F1200
G1 X136.172 Y116.572 E.06518
; CHANGE_LAYER
; Z_HEIGHT: 18.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F4784.975
G1 X136.172 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 141/152
; update layer progress
M73 L141
M991 S0 P140 ;notify layer change
G17
G3 Z18.6 I1.217 J0 P1  F30000
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
G1 X119.885 Y114.71
G1 Z18.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.885 Y111.71 E.08936
G1 X120.33 Y111.71 E.01326
G1 X120.33 Y116.79 E.15132
G1 X119.36 Y116.79 E.02889
G1 X119.36 Y114.71 E.06196
G1 X119.845 Y114.71 E.01444
M204 S10000
G1 X119.845 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.57793
G1 F1200
G1 X119.845 Y116.572 E.06952
; WIPE_START
G1 F4485.898
G1 X119.845 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.415 Y114.71 Z18.8 F30000
G1 Z18.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.01563
G1 X123.94 Y116.79 E.06196
G1 X122.97 Y116.79 E.02889
G1 X122.97 Y111.71 E.15132
G1 X123.415 Y111.71 E.01326
G1 X123.415 Y114.67 E.08817
M204 S10000
G1 X123.455 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.57792
G1 F1200
G1 X123.455 Y116.572 E.06952
; WIPE_START
G1 F4485.982
G1 X123.455 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X131.085 Y114.746 Z18.8 F30000
G1 X132.585 Y114.71 Z18.8
G1 Z18.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X132.585 Y111.71 E.08936
G1 X133.03 Y111.71 E.01326
G1 X133.03 Y116.79 E.15132
G1 X132.06 Y116.79 E.02889
G1 X132.06 Y114.71 E.06196
G1 X132.545 Y114.71 E.01444
M204 S10000
G1 X132.545 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.57792
G1 F1200
G1 X132.545 Y116.572 E.06952
; WIPE_START
G1 F4485.982
G1 X132.545 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.115 Y114.71 Z18.8 F30000
G1 Z18.4
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.01563
G1 X136.64 Y116.79 E.06196
G1 X135.67 Y116.79 E.02889
G1 X135.67 Y111.71 E.15132
G1 X136.115 Y111.71 E.01326
G1 X136.115 Y114.67 E.08817
M204 S10000
G1 X136.155 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.57793
G1 F1200
G1 X136.155 Y116.572 E.06952
; CHANGE_LAYER
; Z_HEIGHT: 18.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F4485.898
G1 X136.155 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 142/152
; update layer progress
M73 L142
M991 S0 P141 ;notify layer change
G17
G3 Z18.8 I1.217 J0 P1  F30000
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
M204 S250
G1 X136.075 Y114.71
M204 S10000
G1 Z18.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.01682
G1 X136.64 Y116.79 E.06196
G1 X135.629 Y116.79 E.03011
G1 X135.593 Y116.79 E.00107
G1 X135.593 Y111.71 E.15132
G1 X135.629 Y111.71 E.00107
G1 X136.075 Y111.71 E.0133
G1 X136.075 Y114.67 E.08817
M204 S10000
G1 X136.116 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.65501
G1 F1200
G1 X136.116 Y116.572 E.07954
; WIPE_START
G1 F3920.992
G1 X136.116 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X132.625 Y114.71 Z19 F30000
G1 Z18.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X132.625 Y111.71 E.08936
G1 X133.071 Y111.71 E.01329
G1 X133.107 Y111.71 E.00108
G1 X133.107 Y116.79 E.15132
G1 X133.071 Y116.79 E.00108
G1 X132.06 Y116.79 E.03011
G1 X132.06 Y114.71 E.06196
G1 X132.585 Y114.71 E.01563
M204 S10000
G1 X132.584 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.65501
G1 F1200
G1 X132.584 Y116.572 E.07954
; WIPE_START
G1 F3920.992
G1 X132.584 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X124.953 Y114.747 Z19 F30000
G1 X123.375 Y114.71 Z19
G1 Z18.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.01682
G1 X123.94 Y116.79 E.06196
G1 X122.929 Y116.79 E.03011
G1 X122.893 Y116.79 E.00108
G1 X122.893 Y111.71 E.15132
G1 X122.929 Y111.71 E.00108
G1 X123.375 Y111.71 E.01329
G1 X123.375 Y114.67 E.08817
M204 S10000
G1 X123.416 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.65501
G1 F1200
G1 X123.416 Y116.572 E.07954
; WIPE_START
G1 F3920.992
G1 X123.416 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X119.925 Y114.71 Z19 F30000
G1 Z18.6
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.925 Y111.71 E.08936
G1 X120.371 Y111.71 E.0133
G1 X120.407 Y111.71 E.00107
G1 X120.407 Y116.79 E.15132
G1 X120.371 Y116.79 E.00107
G1 X119.36 Y116.79 E.03011
G1 X119.36 Y114.71 E.06196
G1 X119.885 Y114.71 E.01563
M204 S10000
G1 X119.884 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.65501
G1 F1200
G1 X119.884 Y116.572 E.07954
; CHANGE_LAYER
; Z_HEIGHT: 18.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F3920.992
G1 X119.884 Y114.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 143/152
; update layer progress
M73 L143
M991 S0 P142 ;notify layer change
G17
G3 Z19 I1.217 J0 P1  F30000
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
G1 X120.093 Y115.145
G1 Z18.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.093 Y116.355 E.03891
G1 X119.795 Y116.355 E.00957
G1 X119.795 Y115.145 E.03891
G1 X120.053 Y115.145 E.00828
M204 S250
G1 X119.99 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X119.99 Y111.71 E.08936
G1 X120.448 Y111.71 E.01364
G1 X120.528 Y111.71 E.00237
G1 X120.528 Y116.79 E.15132
G1 X120.448 Y116.79 E.00237
G1 X119.36 Y116.79 E.03241
G1 X119.36 Y114.71 E.06196
G1 X119.95 Y114.71 E.01758
M204 S10000
G1 X120.259 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.14545
G1 F1200
G1 X120.259 Y111.927 E.0243
; WIPE_START
G1 F15000
G1 X120.259 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.31 Y115.145 Z19.2 F30000
G1 Z18.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.505 Y115.145 E.00627
G1 X123.505 Y116.355 E.03891
G1 X123.207 Y116.355 E.00957
G1 X123.207 Y115.145 E.03891
G1 X123.27 Y115.145 E.00201
M204 S250
G1 X123.31 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.01877
G1 X123.94 Y116.79 E.06196
G1 X122.852 Y116.79 E.03241
G1 X122.772 Y116.79 E.00237
G1 X122.772 Y111.71 E.15132
G1 X122.852 Y111.71 E.00237
G1 X123.31 Y111.71 E.01364
G1 X123.31 Y114.67 E.08817
M204 S10000
G1 X123.041 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.14545
G1 F1200
G1 X123.041 Y111.927 E.0243
; WIPE_START
G1 F15000
G1 X123.041 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X130.615 Y114.873 Z19.2 F30000
G1 X132.793 Y115.145 Z19.2
G1 Z18.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X132.793 Y116.355 E.03891
G1 X132.495 Y116.355 E.00957
G1 X132.495 Y115.145 E.03891
G1 X132.753 Y115.145 E.00828
M204 S250
G1 X132.69 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X132.69 Y111.71 E.08936
G1 X133.148 Y111.71 E.01364
G1 X133.228 Y111.71 E.00237
G1 X133.228 Y116.79 E.15132
G1 X133.148 Y116.79 E.00237
G1 X132.06 Y116.79 E.03241
G1 X132.06 Y114.71 E.06196
G1 X132.65 Y114.71 E.01758
M204 S10000
G1 X132.959 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.14545
G1 F1200
G1 X132.959 Y111.927 E.0243
; WIPE_START
G1 F15000
G1 X132.959 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.907 Y115.145 Z19.2 F30000
G1 Z18.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X136.205 Y115.145 E.00957
G1 X136.205 Y116.355 E.03891
G1 X135.907 Y116.355 E.00957
G1 X135.907 Y115.185 E.03762
M204 S250
G1 X136.01 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.01877
G1 X136.64 Y116.79 E.06196
G1 X135.552 Y116.79 E.03241
G1 X135.472 Y116.79 E.00237
G1 X135.472 Y111.71 E.15132
G1 X135.552 Y111.71 E.00237
G1 X136.01 Y111.71 E.01364
G1 X136.01 Y114.67 E.08817
M204 S10000
G1 X135.741 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.14545
G1 F1200
G1 X135.741 Y111.927 E.0243
; CHANGE_LAYER
; Z_HEIGHT: 19
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X135.741 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 144/152
; update layer progress
M73 L144
M991 S0 P143 ;notify layer change
G17
G3 Z19.2 I1.217 J0 P1  F30000
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
G1 X120.291 Y115.145
G1 Z19
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.291 Y116.355 E.03891
G1 X119.795 Y116.355 E.01594
G1 X119.795 Y115.145 E.03891
G1 X120.251 Y115.145 E.01466
M204 S250
G1 X120.079 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
M73 P96 R1
G1 X120.079 Y111.71 E.08936
G1 X120.569 Y111.71 E.01459
G1 X120.726 Y111.71 E.00468
G1 X120.726 Y116.79 E.15132
G1 X120.569 Y116.79 E.00468
G1 X119.36 Y116.79 E.036
G1 X119.36 Y114.71 E.06196
G1 X120.039 Y114.71 E.02021
M204 S10000
G1 X120.402 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.25508
G1 F1200
G1 X120.402 Y111.927 E.05028
; WIPE_START
G1 F11312.218
G1 X120.402 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X120.043 Y115.349 Z19.4 F30000
G1 Z19
G1 E.8 F1800
; LINE_WIDTH: 0.13164
G1 F1200
G1 X120.043 Y116.151 E.00563
; WIPE_START
G1 F15000
G1 X120.043 Y115.349 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.221 Y115.145 Z19.4 F30000
G1 Z19
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.505 Y115.145 E.00912
G1 X123.505 Y116.355 E.03891
G1 X123.009 Y116.355 E.01594
G1 X123.009 Y115.145 E.03891
G1 X123.181 Y115.145 E.00554
M204 S250
G1 X123.221 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.02141
G1 X123.94 Y116.79 E.06196
G1 X122.731 Y116.79 E.036
G1 X122.574 Y116.79 E.00468
G1 X122.574 Y111.71 E.15132
G1 X122.731 Y111.71 E.00468
G1 X123.221 Y111.71 E.01459
G1 X123.221 Y114.67 E.08817
M204 S10000
G1 X122.898 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.25508
G1 F1200
G1 X122.898 Y111.927 E.05028
; WIPE_START
G1 F11312.218
G1 X122.898 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.257 Y115.349 Z19.4 F30000
G1 Z19
G1 E.8 F1800
; LINE_WIDTH: 0.13164
G1 F1200
G1 X123.257 Y116.151 E.00563
; WIPE_START
G1 F15000
G1 X123.257 Y115.349 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X130.888 Y115.189 Z19.4 F30000
G1 X132.991 Y115.145 Z19.4
G1 Z19
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X132.991 Y116.355 E.03891
G1 X132.495 Y116.355 E.01594
G1 X132.495 Y115.145 E.03891
G1 X132.951 Y115.145 E.01466
M204 S250
G1 X132.779 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X132.779 Y111.71 E.08936
G1 X133.269 Y111.71 E.01459
G1 X133.426 Y111.71 E.00468
G1 X133.426 Y116.79 E.15132
G1 X133.269 Y116.79 E.00468
G1 X132.06 Y116.79 E.036
G1 X132.06 Y114.71 E.06196
G1 X132.739 Y114.71 E.02021
M204 S10000
G1 X133.102 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.25508
G1 F1200
G1 X133.102 Y111.927 E.05028
; WIPE_START
G1 F11312.218
G1 X133.102 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X132.743 Y115.349 Z19.4 F30000
G1 Z19
G1 E.8 F1800
; LINE_WIDTH: 0.13164
G1 F1200
G1 X132.743 Y116.151 E.00563
; WIPE_START
G1 F15000
G1 X132.743 Y115.349 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.709 Y115.145 Z19.4 F30000
G1 Z19
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X136.205 Y115.145 E.01594
G1 X136.205 Y116.355 E.03891
G1 X135.709 Y116.355 E.01594
G1 X135.709 Y115.185 E.03762
M204 S250
G1 X135.921 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.02141
G1 X136.64 Y116.79 E.06196
G1 X135.431 Y116.79 E.036
G1 X135.274 Y116.79 E.00468
G1 X135.274 Y111.71 E.15132
G1 X135.431 Y111.71 E.00468
G1 X135.921 Y111.71 E.01459
G1 X135.921 Y114.67 E.08817
M204 S10000
G1 X135.598 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.25508
G1 F1200
G1 X135.598 Y111.927 E.05028
; WIPE_START
G1 F11312.218
G1 X135.598 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X135.957 Y115.349 Z19.4 F30000
G1 Z19
G1 E.8 F1800
; LINE_WIDTH: 0.13164
G1 F1200
G1 X135.957 Y116.151 E.00563
; CHANGE_LAYER
; Z_HEIGHT: 19.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X135.957 Y115.349 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 145/152
; update layer progress
M73 L145
M991 S0 P144 ;notify layer change
G17
G3 Z19.4 I1.217 J0 P1  F30000
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
G1 X120.63 Y115.145
G1 Z19.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X120.676 Y115.145 E.00147
G1 X120.676 Y116.355 E.03891
G1 X119.795 Y116.355 E.02831
G1 X119.795 Y115.145 E.03891
G1 X120.59 Y115.145 E.02556
M204 S250
G1 X120.195 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X120.195 Y111.71 E.08936
G1 X120.767 Y111.71 E.01704
G1 X121.111 Y111.71 E.01024
G1 F600
G1 X121.111 Y116.79 E.15132
G1 F1200
G1 X120.767 Y116.79 E.01024
G1 X119.36 Y116.79 E.0419
G1 X119.36 Y114.71 E.06196
G1 X120.155 Y114.71 E.02367
M204 S10000
G1 X120.653 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52367
G1 F1200
G1 X120.653 Y111.927 E.11392
; WIPE_START
G1 F4992.2
G1 X120.653 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z19.6 I-.629 J1.042 P1  F30000
G1 X122.67 Y115.145 Z19.6
G1 Z19.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.505 Y115.145 E.02684
G1 X123.505 Y116.355 E.03891
G1 X122.624 Y116.355 E.02831
G1 X122.624 Y115.145 E.03891
G1 X122.63 Y115.145 E.00019
M204 S250
G1 X123.105 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y114.71 E.02486
G1 X123.94 Y116.79 E.06196
G1 X122.533 Y116.79 E.0419
G1 X122.189 Y116.79 E.01024
G1 F600
G1 X122.189 Y111.71 E.15132
G1 F1200
G1 X122.533 Y111.71 E.01024
G1 X123.105 Y111.71 E.01704
G1 X123.105 Y114.67 E.08817
M204 S10000
G1 X122.647 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52367
G1 F1200
G1 X122.647 Y111.927 E.11392
; WIPE_START
G1 F4992.2
G1 X122.647 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X130.231 Y114.792 Z19.6 F30000
G1 X133.33 Y115.145 Z19.6
G1 Z19.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X133.376 Y115.145 E.00147
G1 X133.376 Y116.355 E.03891
G1 X132.495 Y116.355 E.02831
G1 X132.495 Y115.145 E.03891
G1 X133.29 Y115.145 E.02556
M204 S250
G1 X132.895 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X132.895 Y111.71 E.08936
G1 X133.467 Y111.71 E.01704
G1 X133.811 Y111.71 E.01024
G1 F600
G1 X133.811 Y116.79 E.15132
G1 F1200
G1 X133.467 Y116.79 E.01024
G1 X132.06 Y116.79 E.0419
G1 X132.06 Y114.71 E.06196
G1 X132.855 Y114.71 E.02367
M204 S10000
G1 X133.353 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52367
G1 F1200
G1 X133.353 Y111.927 E.11392
; WIPE_START
G1 F4992.2
G1 X133.353 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z19.6 I-.629 J1.042 P1  F30000
G1 X135.37 Y115.145 Z19.6
G1 Z19.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X136.205 Y115.145 E.02684
G1 X136.205 Y116.355 E.03891
G1 X135.324 Y116.355 E.02831
G1 X135.324 Y115.145 E.03891
G1 X135.33 Y115.145 E.00018
M204 S250
G1 X135.805 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.02486
G1 X136.64 Y116.79 E.06196
G1 X135.233 Y116.79 E.0419
G1 X134.889 Y116.79 E.01024
G1 F600
G1 X134.889 Y111.71 E.15132
G1 F1200
G1 X135.233 Y111.71 E.01024
G1 X135.805 Y111.71 E.01704
G1 X135.805 Y114.67 E.08817
M204 S10000
G1 X135.347 Y114.927 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.52367
G1 F1200
M73 P96 R0
G1 X135.347 Y111.927 E.11392
; CHANGE_LAYER
; Z_HEIGHT: 19.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F4992.2
G1 X135.347 Y113.927 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 146/152
; update layer progress
M73 L146
M991 S0 P145 ;notify layer change
G17
G3 Z19.6 I1.217 J0 P1  F30000
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
G1 X133.888 Y115.552
G1 Z19.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X133.888 Y112.952 E.08361
G1 X133.888 Y112.552 E.01286
G1 X134.221 Y112.552 E.0107
; FEATURE: Overhang wall
G1 F1500
M204 S5000
G1 X134.479 Y112.552 E.00833
; FEATURE: Inner wall
G1 F1200
M204 S10000
G1 X134.812 Y112.552 E.0107
G1 X134.812 Y112.952 E.01286
G1 X134.812 Y115.552 E.08361
G1 X134.862 Y115.552 E.0016
G1 X135.798 Y115.552 E.0301
G1 X135.798 Y115.948 E.01273
G1 X135.262 Y115.948 E.01723
G1 X134.862 Y115.948 E.01286
G1 X134.479 Y115.948 E.0123
; FEATURE: Overhang wall
G1 F1500
M204 S5000
G1 X134.221 Y115.948 E.00833
; FEATURE: Inner wall
G1 F1200
M204 S10000
G1 X133.838 Y115.948 E.0123
G1 X133.438 Y115.948 E.01286
G1 X132.902 Y115.948 E.01723
G1 X132.902 Y115.552 E.01273
G1 X133.838 Y115.552 E.0301
G1 X133.848 Y115.552 E.00031
G1 X133.481 Y115.145 F30000
G1 F1200
G1 X133.481 Y112.145 E.09647
G1 X133.838 Y112.145 E.01149
G1 X134.221 Y112.145 E.0123
; FEATURE: Overhang wall
G1 F1500
M204 S5000
G1 X134.479 Y112.145 E.00833
; FEATURE: Inner wall
G1 F1200
M204 S10000
G1 X134.862 Y112.145 E.0123
G1 X135.219 Y112.145 E.01149
G1 X135.219 Y115.145 E.09647
G1 X136.205 Y115.145 E.03169
G1 X136.205 Y116.355 E.03891
G1 X135.262 Y116.355 E.03032
G1 X134.862 Y116.355 E.01286
G1 X134.479 Y116.355 E.0123
; FEATURE: Overhang wall
G1 F1500
M204 S5000
G1 X134.221 Y116.355 E.00833
; FEATURE: Inner wall
G1 F1200
M204 S10000
G1 X133.838 Y116.355 E.0123
G1 X133.438 Y116.355 E.01286
G1 X132.495 Y116.355 E.03032
G1 X132.495 Y115.145 E.03891
G1 X133.441 Y115.145 E.03041
M204 S250
G1 X133.046 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X133.046 Y111.71 E.08936
G1 X133.852 Y111.71 E.024
G1 X134.221 Y111.71 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F1500
G1 X134.479 Y111.71 E.00833
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X134.848 Y111.71 E.01099
G1 X135.654 Y111.71 E.024
G1 X135.654 Y114.71 E.08936
G1 X136.64 Y114.71 E.02936
G1 X136.64 Y116.79 E.06196
G1 X134.848 Y116.79 E.05336
G1 X134.479 Y116.79 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F1500
G1 X134.221 Y116.79 E.00833
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X133.852 Y116.79 E.01099
G1 X132.06 Y116.79 E.05336
G1 X132.06 Y114.71 E.06196
G1 X133.006 Y114.71 E.02817
; WIPE_START
G1 F2400
M204 S10000
G1 X133.032 Y112.71 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z19.8 I-1.116 J.485 P1  F30000
G1 X134.35 Y115.744 Z19.8
G1 Z19.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.56044
G1 F1200
G1 X134.35 Y112.756 E.12218
; WIPE_START
G1 F4637.502
G1 X134.35 Y114.756 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z19.8 I-.074 J-1.215 P1  F30000
G1 X121.188 Y115.552 Z19.8
G1 Z19.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X121.188 Y112.952 E.08361
G1 X121.188 Y112.552 E.01286
G1 X121.521 Y112.552 E.0107
; FEATURE: Overhang wall
G1 F1500
M204 S5000
G1 X121.779 Y112.552 E.00833
; FEATURE: Inner wall
G1 F1200
M204 S10000
G1 X122.112 Y112.552 E.0107
G1 X122.112 Y112.952 E.01286
G1 X122.112 Y115.552 E.08361
G1 X122.162 Y115.552 E.0016
G1 X123.098 Y115.552 E.0301
G1 X123.098 Y115.948 E.01273
G1 X122.562 Y115.948 E.01723
G1 X122.162 Y115.948 E.01286
G1 X121.779 Y115.948 E.0123
; FEATURE: Overhang wall
G1 F1500
M204 S5000
G1 X121.521 Y115.948 E.00833
; FEATURE: Inner wall
G1 F1200
M204 S10000
G1 X121.138 Y115.948 E.0123
G1 X120.738 Y115.948 E.01286
G1 X120.202 Y115.948 E.01723
G1 X120.202 Y115.552 E.01273
G1 X121.138 Y115.552 E.0301
G1 X121.148 Y115.552 E.00031
G1 X120.781 Y115.145 F30000
G1 F1200
G1 X120.781 Y112.145 E.09647
G1 X121.138 Y112.145 E.01149
G1 X121.521 Y112.145 E.0123
; FEATURE: Overhang wall
G1 F1500
M204 S5000
G1 X121.779 Y112.145 E.00833
; FEATURE: Inner wall
G1 F1200
M204 S10000
G1 X122.162 Y112.145 E.0123
G1 X122.519 Y112.145 E.01149
G1 X122.519 Y115.145 E.09647
G1 X123.505 Y115.145 E.03169
G1 X123.505 Y116.355 E.03891
G1 X122.562 Y116.355 E.03032
G1 X122.162 Y116.355 E.01286
G1 X121.779 Y116.355 E.0123
; FEATURE: Overhang wall
G1 F1500
M204 S5000
G1 X121.521 Y116.355 E.00833
; FEATURE: Inner wall
G1 F1200
M204 S10000
G1 X121.138 Y116.355 E.0123
G1 X120.738 Y116.355 E.01286
G1 X119.795 Y116.355 E.03032
G1 X119.795 Y115.145 E.03891
G1 X120.741 Y115.145 E.03041
M204 S250
G1 X120.346 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X120.346 Y111.71 E.08936
G1 X121.152 Y111.71 E.024
G1 X121.521 Y111.71 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F1500
G1 X121.779 Y111.71 E.00833
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X122.148 Y111.71 E.01099
G1 X122.954 Y111.71 E.024
M73 P97 R0
G1 X122.954 Y114.71 E.08936
G1 X123.94 Y114.71 E.02936
G1 X123.94 Y116.79 E.06196
G1 X122.148 Y116.79 E.05336
G1 X121.779 Y116.79 E.01099
; FEATURE: Overhang wall
; LINE_WIDTH: 0.45
G1 F1500
G1 X121.521 Y116.79 E.00833
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
G1 X121.152 Y116.79 E.01099
G1 X119.36 Y116.79 E.05336
G1 X119.36 Y114.71 E.06196
G1 X120.306 Y114.71 E.02817
; WIPE_START
G1 F2400
M204 S10000
G1 X120.332 Y112.71 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z19.8 I-1.116 J.485 P1  F30000
G1 X121.65 Y115.744 Z19.8
G1 Z19.4
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.56044
G1 F1200
G1 X121.65 Y112.756 E.12218
; CHANGE_LAYER
; Z_HEIGHT: 19.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F4637.502
G1 X121.65 Y114.756 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 147/152
; update layer progress
M73 L147
M991 S0 P146 ;notify layer change
G17
G3 Z19.8 I1.217 J0 P1  F30000
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
G1 X134.086 Y115.552
G1 Z19.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X134.086 Y112.552 E.09647
G1 X134.614 Y112.552 E.017
G1 X134.614 Y115.552 E.09647
G1 X135.798 Y115.552 E.03806
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.552 E.01273
G1 X134.046 Y115.552 E.03677
G1 X133.679 Y115.145 F30000
G1 F1200
G1 X133.679 Y112.145 E.09647
G1 X135.021 Y112.145 E.04318
G1 X135.021 Y115.145 E.09647
G1 X136.205 Y115.145 E.03806
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.145 E.03891
G1 X133.639 Y115.145 E.03677
M204 S250
G1 X133.244 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X133.244 Y111.71 E.08936
G1 X135.456 Y111.71 E.06591
G1 X135.456 Y114.71 E.08936
G1 X136.64 Y114.71 E.03526
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.71 E.06196
G1 X133.204 Y114.71 E.03406
; WIPE_START
G1 F2400
M204 S10000
G1 X133.23 Y112.71 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z20 I-1.142 J.421 P1  F30000
G1 X134.35 Y115.744 Z20
G1 Z19.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.16448
G1 F1200
G1 X134.35 Y112.756 E.0287
; WIPE_START
G1 F15000
G1 X134.35 Y114.756 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z20 I-.075 J-1.215 P1  F30000
G1 X121.386 Y115.552 Z20
G1 Z19.6
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X121.386 Y112.552 E.09647
G1 X121.914 Y112.552 E.017
G1 X121.914 Y115.552 E.09647
G1 X123.098 Y115.552 E.03806
G1 X123.098 Y115.948 E.01273
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X121.346 Y115.552 E.03677
G1 X120.979 Y115.145 F30000
G1 F1200
G1 X120.979 Y112.145 E.09647
G1 X122.321 Y112.145 E.04318
G1 X122.321 Y115.145 E.09647
G1 X123.505 Y115.145 E.03806
G1 X123.505 Y116.355 E.03891
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X120.939 Y115.145 E.03677
M204 S250
G1 X120.544 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X120.544 Y111.71 E.08936
G1 X122.756 Y111.71 E.06591
G1 X122.756 Y114.71 E.08936
G1 X123.94 Y114.71 E.03526
G1 X123.94 Y116.79 E.06196
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X120.504 Y114.71 E.03406
; WIPE_START
G1 F2400
M204 S10000
G1 X120.53 Y112.71 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z20 I-1.142 J.421 P1  F30000
G1 X121.65 Y115.744 Z20
G1 Z19.6
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.16448
G1 F1200
G1 X121.65 Y112.756 E.0287
; CHANGE_LAYER
; Z_HEIGHT: 19.8
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F15000
G1 X121.65 Y114.756 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 148/152
; update layer progress
M73 L148
M991 S0 P147 ;notify layer change
G17
G3 Z20 I1.217 J0 P1  F30000
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
G1 X134.354 Y115.552
G1 Z19.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.552 E.04643
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.552 E.01273
G1 X134.314 Y115.552 E.04541
G1 X133.947 Y115.145 F30000
G1 F1200
G1 X133.947 Y112.145 E.09647
G1 X134.753 Y112.145 E.02591
G1 X134.753 Y115.145 E.09647
G1 X136.205 Y115.145 E.04669
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.145 E.03891
G1 X133.907 Y115.145 E.04541
M204 S250
G1 X133.512 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X133.512 Y111.71 E.08936
G1 X135.188 Y111.71 E.04992
G1 X135.188 Y114.71 E.08936
G1 X136.64 Y114.71 E.04325
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.71 E.06196
G1 X133.472 Y114.71 E.04206
; WIPE_START
G1 F2400
M204 S10000
G1 X133.499 Y112.71 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z20.2 I-1.158 J.374 P1  F30000
G1 X134.35 Y115.348 Z20.2
G1 Z19.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.44166
G1 F1200
G1 X134.35 Y112.349 E.09449
; WIPE_START
G1 F6018.96
G1 X134.35 Y114.349 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z20.2 I-.115 J-1.212 P1  F30000
G1 X121.654 Y115.552 Z20.2
G1 Z19.8
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.098 Y115.552 E.04643
G1 X123.098 Y115.948 E.01273
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X121.614 Y115.552 E.04541
G1 X121.247 Y115.145 F30000
G1 F1200
G1 X121.247 Y112.145 E.09647
G1 X122.053 Y112.145 E.02591
G1 X122.053 Y115.145 E.09647
G1 X123.505 Y115.145 E.04669
G1 X123.505 Y116.355 E.03891
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X121.207 Y115.145 E.04541
M204 S250
G1 X120.812 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X120.812 Y111.71 E.08936
G1 X122.488 Y111.71 E.04992
G1 X122.488 Y114.71 E.08936
G1 X123.94 Y114.71 E.04325
G1 X123.94 Y116.79 E.06196
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X120.772 Y114.71 E.04206
; WIPE_START
G1 F2400
M204 S10000
G1 X120.799 Y112.71 E-.76
; WIPE_END
G1 E-.04 F1800
G17
G3 Z20.2 I-1.158 J.374 P1  F30000
G1 X121.65 Y115.348 Z20.2
G1 Z19.8
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.44166
G1 F1200
G1 X121.65 Y112.349 E.09449
; CHANGE_LAYER
; Z_HEIGHT: 20
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F6018.96
G1 X121.65 Y114.349 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 149/152
; update layer progress
M73 L149
M991 S0 P148 ;notify layer change
G17
G3 Z20.2 I1.217 J0 P1  F30000
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
G1 X135.348 Y116.109
G1 Z20
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X136.205 Y116.109 E.02757
G1 X136.205 Y116.355 E.0079
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y116.109 E.0079
G1 X135.308 Y116.109 E.09044
; WIPE_START
G1 F3600
G1 X136.205 Y116.109 E-.34103
G1 X136.205 Y116.355 E-.09341
G1 X135.348 Y116.355 E-.32557
; WIPE_END
G1 E-.04 F1800
G1 X133.948 Y114.71 Z20.4 F30000
G1 Z20
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X133.948 Y111.71 E.08936
G1 X134.752 Y111.71 E.02393
G1 X134.752 Y114.71 E.08936
G1 X136.64 Y114.71 E.05625
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.71 E.06196
G1 X133.908 Y114.71 E.05506
; WIPE_START
G1 F2400
M204 S10000
G1 X133.935 Y112.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.433 Y115.168 Z20.4 F30000
G1 Z20
G1 E.8 F1800
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X135.757 Y115.844 E.02848
G1 X135.223 Y115.844
G1 X136.15 Y114.917 E.03902
G1 X135.616 Y114.917
G1 X134.69 Y115.844 E.03902
G1 X134.157 Y115.844
G1 X135.083 Y114.917 E.03902
G1 X134.55 Y114.917
G1 X133.623 Y115.844 E.03902
G1 X133.09 Y115.844
G1 X134.017 Y114.917 E.03902
G1 X133.483 Y114.917
G1 X132.557 Y115.844 E.03902
G1 X132.267 Y115.6
G1 X132.95 Y114.917 E.02876
G1 X134.156 Y114.778
G1 X134.544 Y114.39 E.01636
G1 X134.544 Y113.857
G1 X134.156 Y114.245 E.01636
G1 X134.156 Y113.712
G1 X134.544 Y113.323 E.01636
G1 X134.544 Y112.79
G1 X134.156 Y113.178 E.01636
G1 X134.156 Y112.645
G1 X134.544 Y112.257 E.01636
; WIPE_START
G1 F2400
M204 S10000
G1 X134.156 Y112.645 E-.20875
G1 X134.156 Y113.178 E-.20264
G1 X134.544 Y112.79 E-.20875
G1 X134.544 Y113.158 E-.13986
; WIPE_END
G1 E-.04 F1800
G1 X134.563 Y114.725 Z20.4 F30000
G1 Z20
G1 E.8 F1800
; FEATURE: Gap infill
; LINE_WIDTH: 0.0993352
G1 F1200
G1 X134.535 Y114.705 E.00015
G1 X134.451 Y114.819 E.00063
G1 X134.267 Y114.889 F30000
; LINE_WIDTH: 0.0937845
G1 F1200
G1 X134.18 Y114.988 E.00053
G1 X134.118 Y115.018 E.00028
; WIPE_START
G1 F15000
G1 X134.18 Y114.988 E-.26207
G1 X134.267 Y114.889 E-.49793
; WIPE_END
G1 E-.04 F1800
G1 X126.676 Y115.686 Z20.4 F30000
G1 X122.648 Y116.109 Z20.4
G1 Z20
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.505 Y116.109 E.02757
G1 X123.505 Y116.355 E.0079
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y116.109 E.0079
G1 X122.608 Y116.109 E.09044
; WIPE_START
G1 F3600
G1 X123.505 Y116.109 E-.34102
G1 X123.505 Y116.355 E-.09341
G1 X122.648 Y116.355 E-.32557
; WIPE_END
G1 E-.04 F1800
G1 X121.248 Y114.71 Z20.4 F30000
G1 Z20
G1 E.8 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X121.248 Y111.71 E.08936
G1 X122.052 Y111.71 E.02393
G1 X122.052 Y114.71 E.08936
G1 X123.94 Y114.71 E.05625
G1 X123.94 Y116.79 E.06196
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X121.208 Y114.71 E.05506
; WIPE_START
G1 F2400
M204 S10000
G1 X121.235 Y112.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X123.733 Y115.069 Z20.4 F30000
G1 Z20
G1 E.8 F1800
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X122.958 Y115.844 E.03262
G1 X122.425 Y115.844
G1 X123.351 Y114.917 E.03902
G1 X122.818 Y114.917
G1 X121.892 Y115.844 E.03902
G1 X121.359 Y115.844
G1 X122.285 Y114.917 E.03902
G1 X121.844 Y114.825
G1 X120.825 Y115.844 E.04292
G1 X120.292 Y115.844
M73 P98 R0
G1 X121.218 Y114.917 E.03902
G1 X120.685 Y114.917
G1 X119.759 Y115.844 E.03902
G1 X119.567 Y115.502
G1 X120.152 Y114.917 E.02462
M204 S10000
G1 X121.456 Y114.68 F30000
G1 F1200
M204 S2000
G1 X121.844 Y114.292 E.01636
G1 X121.844 Y113.758
G1 X121.456 Y114.147 E.01636
G1 X121.456 Y113.614
G1 X121.844 Y113.225 E.01636
G1 X121.844 Y112.692
G1 X121.456 Y113.08 E.01636
G1 X121.456 Y112.547
G1 X121.844 Y112.159 E.01636
M204 S10000
G1 X121.863 Y112.014 F30000
; FEATURE: Gap infill
; LINE_WIDTH: 0.193154
G1 F1200
G1 X121.763 Y111.973 E.00128
G1 X121.437 Y111.973 E.00387
; WIPE_START
G1 F15000
G1 X121.763 Y111.973 E-.57103
G1 X121.863 Y112.014 E-.18897
; WIPE_END
G1 E-.04 F1800
G1 X121.569 Y114.794 Z20.4 F30000
G1 Z20
G1 E.8 F1800
; LINE_WIDTH: 0.0982936
G1 F1200
G1 X121.332 Y115.031 E.00147
; CHANGE_LAYER
; Z_HEIGHT: 20.2
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F15000
G1 X121.569 Y114.794 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 150/152
; update layer progress
M73 L150
M991 S0 P149 ;notify layer change
G17
G3 Z20.4 I1.217 J0 P1  F30000
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
G1 X135.798 Y115.552
G1 Z20.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.552 E.01273
G1 X135.758 Y115.552 E.09183
G1 X136.205 Y115.145 F30000
G1 F1200
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.145 E.03891
G1 X136.165 Y115.145 E.11801
M204 S250
G1 X136.64 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.71 E.06196
G1 X136.6 Y114.71 E.13523
; WIPE_START
G1 F2400
M204 S10000
G1 X136.638 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X129.034 Y116.059 Z20.6 F30000
G1 X123.098 Y115.552 Z20.6
G1 Z20.2
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.098 Y115.948 E.01273
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.058 Y115.552 E.09183
G1 X123.505 Y115.145 F30000
G1 F1200
G1 X123.505 Y116.355 E.03891
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.465 Y115.145 E.11801
M204 S250
G1 X123.94 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y116.79 E.06196
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.9 Y114.71 E.13523
; CHANGE_LAYER
; Z_HEIGHT: 20.4
; LAYER_HEIGHT: 0.199999
; WIPE_START
G1 F2400
M204 S10000
G1 X123.938 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 151/152
; update layer progress
M73 L151
M991 S0 P150 ;notify layer change
G17
G3 Z20.6 I1.217 J0 P1  F30000
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
G1 X132.902 Y115.552
G1 Z20.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X135.798 Y115.552 E.09312
G1 X135.798 Y115.948 E.01273
G1 X132.902 Y115.948 E.09312
G1 X132.902 Y115.592 E.01144
G1 X132.495 Y115.145 F30000
G1 F1200
G1 X136.205 Y115.145 E.1193
G1 X136.205 Y116.355 E.03891
G1 X132.495 Y116.355 E.1193
G1 X132.495 Y115.185 E.03762
M204 S250
G1 X132.06 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X126.449 Y115.302 Z20.8 F30000
G1 X123.098 Y115.552 Z20.8
G1 Z20.4
G1 E.8 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F1200
G1 X123.098 Y115.948 E.01273
G1 X120.202 Y115.948 E.09312
G1 X120.202 Y115.552 E.01273
G1 X123.058 Y115.552 E.09183
G1 X123.505 Y115.145 F30000
G1 F1200
G1 X123.505 Y116.355 E.03891
G1 X119.795 Y116.355 E.1193
G1 X119.795 Y115.145 E.03891
G1 X123.465 Y115.145 E.11801
M204 S250
G1 X123.94 Y114.71 F30000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1200
M204 S5000
G1 X123.94 Y116.79 E.06196
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.9 Y114.71 E.13523
; CHANGE_LAYER
; Z_HEIGHT: 20.6
; LAYER_HEIGHT: 0.200001
; WIPE_START
G1 F2400
M204 S10000
G1 X123.938 Y116.71 E-.76
; WIPE_END
G1 E-.04 F1800
; layer num/total_layer_count: 152/152
; update layer progress
M73 L152
M991 S0 P151 ;notify layer change
G17
G3 Z20.8 I1.217 J0 P1  F30000
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
G1 X132.06 Y114.71
G1 Z20.6
G1 E.8 F1800
G1 F1200
M204 S5000
G1 X136.64 Y114.71 E.13642
G1 X136.64 Y116.79 E.06196
G1 X132.06 Y116.79 E.13642
G1 X132.06 Y114.75 E.06076
; WIPE_START
G1 F2400
M204 S10000
G1 X134.06 Y114.733 E-.76
; WIPE_END
G1 E-.04 F1800
G1 X136.433 Y115.502 Z21 F30000
G1 Z20.6
G1 E.8 F1800
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X135.848 Y114.917 E.02463
G1 X135.315 Y114.917
G1 X136.433 Y116.035 E.04709
G1 X136.433 Y116.569
G1 X134.781 Y114.917 E.06956
G1 X134.248 Y114.917
G1 X135.913 Y116.583 E.07015
G1 X135.38 Y116.583
G1 X133.715 Y114.917 E.07015
G1 X133.182 Y114.917
G1 X134.847 Y116.583 E.07015
G1 X134.314 Y116.583
G1 X132.648 Y114.917 E.07015
G1 X132.267 Y115.07
G1 X133.78 Y116.583 E.06373
G1 X133.247 Y116.583
G1 X132.267 Y115.603 E.04127
G1 X132.267 Y116.136
G1 X132.714 Y116.583 E.01881
; WIPE_START
G1 F2400
M204 S10000
G1 X132.267 Y116.136 E-.23995
G1 X132.267 Y115.603 E-.20264
G1 X132.858 Y116.194 E-.31741
; WIPE_END
G1 E-.04 F1800
G1 X125.329 Y114.941 Z21 F30000
G1 X123.94 Y114.71 Z21
G1 Z20.6
G1 E.8 F1800
; FEATURE: Outer wall
G1 F1200
M204 S5000
G1 X123.94 Y116.79 E.06196
G1 X119.36 Y116.79 E.13642
G1 X119.36 Y114.71 E.06196
G1 X123.9 Y114.71 E.13523
M204 S10000
G1 X123.733 Y115.6 F30000
; FEATURE: Top surface
G1 F1200
M204 S2000
G1 X123.05 Y114.917 E.02876
G1 X122.517 Y114.917
G1 X123.733 Y116.133 E.05123
G1 X123.648 Y116.583
G1 X121.983 Y114.917 E.07015
G1 X121.45 Y114.917
G1 X123.115 Y116.583 E.07015
G1 X122.582 Y116.583
G1 X120.917 Y114.917 E.07015
G1 X120.383 Y114.917
G1 X122.049 Y116.583 E.07015
G1 X121.515 Y116.583
G1 X119.85 Y114.917 E.07015
G1 X119.567 Y115.168
G1 X120.982 Y116.583 E.0596
G1 X120.449 Y116.583
G1 X119.567 Y115.701 E.03714
G1 X119.567 Y116.234
G1 X119.916 Y116.583 E.01467
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F2400
M204 S10000
G1 X119.567 Y116.234 E-.18719
G1 X119.567 Y115.701 E-.20264
G1 X120.256 Y116.39 E-.37017
; WIPE_END
G1 E-.04 F1800
G17
G3 Z21 I1.217 J0 P1  F30000
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
G1 Z21.1 F900 ; lower z a little
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

    G1 Z120.6 F600
    G1 Z118.6

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

