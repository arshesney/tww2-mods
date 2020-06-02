local function alith_anar_to_arnheim()
	out("=========== Alith Anar in Arnehim called ===========");

	if cm:is_new_game() and cm:model():campaign_name("wh2_main_great_vortex") then

		out("arsh79 - We're in a new Vortex game!");
		local nagarythe = cm:get_faction("wh2_main_hef_nagarythe");
		local tiranoc = cm:get_faction("wh2_main_hef_tiranoc");
		local alith_anar_obj = nagarythe:faction_leader();
		local alith_anar_str = cm:char_lookup_str(alith_anar_obj:command_queue_index());

		out("arsh79 - Alith Anar is : "..tostring(alith_anar_obj:get_forename()).." ("..tostring(alith_anar_str)..")");

		if nagarythe then
			out("arsh79 - Nagarythe faction present");
			-- High Vale: wh2_main_vor_tiranoc_the_high_vale
			-- Arnheim: wh2_main_vor_the_black_coast_arnheim
			-- Black Creek Spire: wh2_main_vor_the_broken_land_black_creek_spire

			-- Find a spot near High Vale and Arnheim
			local hvl_x, hvl_y = cm:find_valid_spawn_location_for_character_from_settlement(
				"wh2_main_hef_tiranoc",
				"wh2_main_vor_tiranoc_the_high_vale",
				false,
				true,
				5
			);
			out("arsh79 - coords near High Vale: "..tostring(hvl_x)..", "..tostring(hvl_y));

			local arn_x, arn_y = cm:find_valid_spawn_location_for_character_from_settlement(
				"wh2_main_hef_nagarythe",
				"wh2_main_vor_the_black_coast_arnheim",
				false,
				true,
				5
			);
			out("arsh79 - coords near Arnheim: "..tostring(arn_x)..", "..tostring(arn_y));

			-- Find Valauhir
			local valauhir_obj = cm:get_closest_general_to_position_from_faction(
				tiranoc,
				arn_x,
				arn_y,
				false
			);
			local valauhir_str = cm:char_lookup_str(valauhir_obj:command_queue_index());
			out("arsh79 - Valahuir is:"..tostring(valauhir_obj:get_forename()).." ("..tostring(valauhir_str)..")");

			-- Arnheim to Nagarythe and Black Creek Spire to Karond Kar
			cm:transfer_region_to_faction("wh2_main_vor_the_black_coast_arnheim", "wh2_main_hef_nagarythe");
			cm:transfer_region_to_faction("wh2_main_vor_the_broken_land_black_creek_spire", "wh2_main_def_karond_kar");
			out("arsh79 - swapped regions");

			-- Moving armies
			cm:teleport_to(alith_anar_str, arn_x, arn_y, true);
			cm:teleport_to(valauhir_str, hvl_x, hvl_y, true);
			out("arsh79 - moved armies");

			-- Peace Tiranoc and Bleak Holds
			cm:force_make_peace("wh2_main_hef_tiranoc", "wh2_main_def_bleak_holds");
			-- Peace Nagarythe and Karond Kar
			cm:force_make_peace("wh2_main_hef_nagarythe", "wh2_main_def_karond_kar");
			-- And at war with Clar Karond
			cm:force_declare_war("wh2_main_hef_nagarythe", "wh2_main_def_clar_karond", false, false, false);
			out("arsh79 - Diplomacy set");
		end
	end
	out("=========== Alith Anar in Arnehim end ===========");
end

-- Run it at first tick
cm:add_first_tick_callback(function() alith_anar_to_arnheim() end);