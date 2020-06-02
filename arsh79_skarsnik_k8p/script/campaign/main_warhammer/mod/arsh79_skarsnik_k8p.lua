cm:add_first_tick_callback(
function()
	out("=========== Skarsnik Warlord of Eight Peaks called ===========");
	if cm:is_new_game() then
		
		local skarsnik = cm:get_faction("wh_main_grn_crooked_moon");
		local skarsnik_str = cm:char_lookup_str(skarsnik:faction_leader():command_queue_index());
		local gits = cm:get_faction("wh_main_grn_necksnappers");
		local gits_leader = gits:faction_leader():command_queue_index();
		
		out("arsh79 - skarsnik: "..tostring(skarsnik_str));
		
		if skarsnik and not skarsnik:is_human() then
			out("arsh79 - skarsink is AI controlled, giving him K8P");
			-- Remove mutinous gits
			cm:kill_character(gits_leader, true, false);
			
			-- Transfer region to Crooked Moon and move Skarsnik there (don't leave Sly da Miser behind!)
			cm:transfer_region_to_faction("wh_main_eastern_badlands_karak_eight_peaks", "wh_main_grn_crooked_moon");
			
			cm:teleport_to("faction:wh_main_grn_crooked_moon,forename:2147358016", 725, 267, true);
			cm:teleport_to("faction:wh_main_grn_crooked_moon,forename:2147344448", 719, 266, true);
			
			-- Give him some XP
			cm:add_agent_experience(skarsnik_str, 2000);
			
			-- And some units
			cm:grant_unit_to_character(skarsnik_str, "wh_main_grn_inf_night_goblins");
			cm:grant_unit_to_character(skarsnik_str, "wh_main_grn_inf_night_goblin_archers");
			cm:grant_unit_to_character(skarsnik_str, "wh_main_grn_mon_trolls");
			
			-- And a shaman
			cm:create_agent(
				"wh_main_grn_crooked_moon",
				"wizard",
				"grn_night_goblin_shaman",
				730, 
				267, 
				false,
				function(cqi)
					out("arsh79 - created shaman with cqi. "..cqi);
				end);
			
			-- Now, for Karak Azgaraz, give it back to Karak Norn
			cm:transfer_region_to_faction("wh_main_southern_grey_mountains_karak_azgaraz", "wh_main_dwf_karak_norn");
			
			-- Peace out Karak Norn
			cm:force_make_peace("wh_main_grn_crooked_moon", "wh_main_dwf_karak_norn");
			-- And war with Clan Volkn
			cm:force_declare_war("wh2_dlc15_skv_clan_volkn", "wh_main_grn_crooked_moon", false, false, false);
			
			eight_peaks_check(skarsnik:name());
			out("arsh79 - K8P init done!");
		end
	end
end
);