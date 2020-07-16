local cabal_faction_key = "wh2_main_chs_the_cabal"
local cabal_arcane_knowledge = 0

local mixu_arcane_knowledge = {
	["number_of_books"] = 0,
	["egrimm_unlocked"] = false,
	["aekold_unlocked"] = false,
	["reveal_sea_regions"] = false
}

local mixu_cabal_ruins = {}

local aekold_is_leader = false
local locked_lord_subtype = "chs_aekold_helbrass"
local storm_chaser_mission = "mixu_the_cabal_ak_egrimm_relic_4"
local clawhand_mission = "mixu_the_cabal_ak_egrimm_relic_3"
local fiery_ones_mission = "mixu_the_cabal_ak_egrimm_relic_7"
local thrall_mission = "mixu_the_cabal_ak_egrimm_relic_2"
local arcane_knowledge_missions = {}	

local starting_lord_checks = {}

local ak_missions_mortal = {	
	{mission_name = "mixu_the_cabal_ak_egrimm_relic_1", region_key = "wh2_main_isthmus_of_lustria_hexoatl", x_cord = -0.04, y_cord = 0.53, bundle = "ak_reward_hexoatl"},
	{mission_name = "mixu_the_cabal_ak_egrimm_relic_2", region_key = "wh2_main_iron_mountains_naggarond", x_cord = 0, y_cord = 0.1, bundle = "ak_reward_thralls_of_cabal"},
	{mission_name = "mixu_the_cabal_ak_egrimm_relic_3", region_key = "wh2_main_eataine_lothern", x_cord = 0.17, y_cord = 0.58, bundle = "ak_reward_clawhand"},
	{mission_name = "mixu_the_cabal_ak_egrimm_relic_4", region_key = "wh2_main_southern_great_jungle_itza", x_cord = 0.03, y_cord = 0.86, bundle = "ak_reward_lord_of_change"},
	{mission_name = "mixu_the_cabal_ak_egrimm_relic_5", region_key = "wh_main_carcassone_et_brionne_castle_carcassonne", x_cord = 0.32, y_cord = 0.49, bundle = "ak_reward_carcassonne"},
	{mission_name = "mixu_the_cabal_ak_egrimm_relic_6", region_key = "wh2_main_obsidian_peaks_clar_karond", x_cord = 0, y_cord = 0.28, bundle = "ak_reward_clar_karond"},
	{mission_name = "mixu_the_cabal_ak_egrimm_relic_7", region_key = "wh2_main_vampire_coast_the_awakening", x_cord = 0.17, y_cord = 0.72, bundle = "ak_reward_fiery_ones"},
	{mission_name = "mixu_the_cabal_ak_egrimm_relic_8", region_key = "wh2_main_albion_albion", x_cord = 0.2, y_cord = 0.15, bundle = "ak_reward_albion"}
}

local ak_missions_vortex = {	
	{mission_name = "mixu_the_cabal_ak_vor_egrimm_relic_1", region_key = "wh2_main_vor_shadow_wood_clar_karond", x_cord = 0.2, y_cord = 0.18, bundle = "ak_reward_clar_karond"},	
	{mission_name = "mixu_the_cabal_ak_vor_egrimm_relic_2", region_key = "wh2_main_vor_the_broken_land_karond_kar", x_cord = 0.38, y_cord = 0.1, bundle = "ak_reward_karond_kar"},		
	{mission_name = "mixu_the_cabal_ak_vor_egrimm_relic_3", region_key = "wh2_main_vor_naggarond_naggarond", x_cord = 0.17, y_cord = 0.02, bundle = "ak_reward_thralls_of_cabal"},	
	{mission_name = "mixu_the_cabal_ak_vor_egrimm_relic_4", region_key = "wh2_main_vor_isthmus_of_lustria_hexoatl", x_cord = 0.04, y_cord = 0.32, bundle = "ak_reward_hexoatl"},	
	{mission_name = "mixu_the_cabal_ak_vor_egrimm_relic_5", region_key = "wh2_main_vor_the_creeping_jungle_tlaxtlan", x_cord = 0.1, y_cord = 0.49, bundle = "ak_reward_tlaxtlan"},		
	{mission_name = "mixu_the_cabal_ak_vor_egrimm_relic_6", region_key = "wh2_main_vor_northern_great_jungle_itza", x_cord = 0.18, y_cord = 0.72, bundle = "ak_reward_lord_of_change"},		
	{mission_name = "mixu_the_cabal_ak_vor_egrimm_relic_7", region_key = "wh2_main_vor_the_vampire_coast_the_awakening", x_cord = 0.29, y_cord = 0.55, bundle = "ak_reward_fiery_ones"},	
	{mission_name = "mixu_the_cabal_ak_vor_egrimm_relic_8", region_key = "wh2_main_vor_culchan_plains_chupayotl", x_cord = 0.3, y_cord = 0.78, bundle = "ak_reward_clawhand"}
}


local function spawn_clawhand(faction_interface)
	core:add_listener(
		"clawhand_created",
		"UniqueAgentSpawned",
		function(context)
			local unique_agent_subtype = context:unique_agent_details():character():character_subtype_key()
			return unique_agent_subtype == "chs_azubhor_clawhand"
		end,
		function(context)
			local unique_agent = context:unique_agent_details():character()
			local unique_agent_subtype = unique_agent:character_subtype_key()
			
			cm:add_unit_model_overrides(cm:char_lookup_str(unique_agent), "mixu_art_set_chs_azubhor_clawhand")			
			cm:add_agent_experience(cm:char_lookup_str(unique_agent), 20, true)
			cm:replenish_action_points(cm:char_lookup_str(unique_agent))
		end,
		true
	)

	local faction_cqi = faction_interface:command_queue_index()
	cm:spawn_unique_agent(faction_cqi, "chs_azubhor_clawhand", false)
end

local function create_custom_invasion(faction_key, target_faction, x, y, unit_list, apply_bundle, target, target_region, subtype, etunimi, sukunimi)

	local force_name = "mixu_custom_start_army_"..faction_key
	invasion_manager:new_spawn_location(force_name, x, y)
	local custom_force = invasion_manager:new_invasion(force_name, faction_key, unit_list, force_name)

	if target == "NONE" then
		custom_force:set_target("NONE", nil, target_faction)
	elseif target == "CHARACTER" then
		local target_char = cm:get_closest_character_to_position_from_faction(target_faction, x, y, true, false)
		custom_force:set_target("CHARACTER", target_char:command_queue_index(), target_faction);	
	elseif target == "REGION" then
		custom_force:set_target("REGION", target_region, target_faction)
	end	
	
	if apply_bundle == true then
		custom_force:apply_effect("wh_main_reduced_movement_range_90", 3)
	end
	
	custom_force:create_general(false, subtype, etunimi, "", sukunimi, "")		
	
	custom_force:start_invasion(nil, true, false, false)
end

local function mixu_spawn_starting_lord(agent_subtype, etunimi, sukunimi, faction_key, x1, y1)
	local faction = cm:model():world():faction_by_key(faction_key)
	local faction_leader_cqi = faction:faction_leader():command_queue_index()
	local x = x1 or 0
	local y = y1 or 0
	local make_faction_leader = false

	local force_name = "mixu_" .. agent_subtype;
	local region = "wh2_main_vor_the_road_of_skulls_har_ganeth"
	
	if cm:get_campaign_name() == "main_warhammer" then
		region = "wh2_main_the_road_of_skulls_har_ganeth"
	end		
	
	local army_size = random_army_manager:mandatory_unit_count(force_name)
	local force = random_army_manager:generate_force(force_name, army_size)
	
	if agent_subtype == "chs_egrimm_van_horstmann" then
		cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "")
		make_faction_leader = true
		cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false)	
	end
	
	if aekold_is_leader == true and agent_subtype == "chs_egrimm_van_horstmann" then
		force = ""
	elseif aekold_is_leader == false and agent_subtype == "chs_aekold_helbrass" then
		force = ""
	end
	
	cm:create_force_with_general(
		faction_key,
		force,
		region,
		x,
		y,
		"general",
		agent_subtype,
		etunimi,
		"",
		sukunimi,
		"",
		make_faction_leader
	)
	
	if agent_subtype == "chs_egrimm_van_horstmann" then
		cm:kill_character(faction_leader_cqi, true, true)
		cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 0.5)
	end
end

	
local function get_cqi_of_locked_lord()
	local character_list = cabal:character_list()
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)	
		if character:character_subtype(locked_lord_subtype) then
			return character:command_queue_index()
		end
	end
end

local function spawn_cabal_lords(cabal)
	-- Aekold's start
	if aekold_is_leader == true then		
		if cm:get_campaign_name() == "main_warhammer" then
			mixu_spawn_starting_lord("chs_egrimm_van_horstmann", "names_name_6450684033", "names_name_6450684034", cabal_faction_key, 180, 699)	
			mixu_spawn_starting_lord("chs_aekold_helbrass", "names_name_6450684052", "names_name_6450684053", cabal_faction_key, 411, 706)
					
			cm:spawn_agent_at_position(cabal, 410, 702, "champion", "chs_exalted_hero")

			local unit_list = "wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_nor_inf_chaos_marauders_1,wh_dlc08_nor_inf_marauder_hunters_0"
			create_custom_invasion("wh2_main_nor_aghol", cabal_faction_key, 398, 702, unit_list, true, "NONE", "", "nor_marauder_chieftain", "names_name_2147356507", "names_name_72280389")
		else
			mixu_spawn_starting_lord("chs_egrimm_van_horstmann", "names_name_6450684033", "names_name_6450684034", cabal_faction_key, 303, 703)
			mixu_spawn_starting_lord("chs_aekold_helbrass", "names_name_6450684052", "names_name_6450684053", cabal_faction_key, 635, 690)
					
			cm:spawn_agent_at_position(cabal, 626, 691, "champion", "chs_exalted_hero")
			
			local unit_list = "wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_1,wh_main_nor_inf_chaos_marauders_1,wh_dlc08_nor_inf_marauder_hunters_0"
			create_custom_invasion("wh2_main_nor_aghol", cabal_faction_key, 621, 687, unit_list, true, "NONE", "", "nor_marauder_chieftain", "names_name_2147356507", "names_name_72280389")					
		end
		
	-- Egrimm's start
	else				
		if cm:get_campaign_name() == "main_warhammer" then
			mixu_spawn_starting_lord("chs_egrimm_van_horstmann", "names_name_6450684033", "names_name_6450684034", cabal_faction_key, 180, 699)	
			mixu_spawn_starting_lord("chs_aekold_helbrass", "names_name_6450684052", "names_name_6450684053", cabal_faction_key, 411, 706)
			
			cm:spawn_agent_at_position(cabal, 175, 699, "wizard", "chs_chaos_sorcerer_fire")	
			
			cm:create_force(
				"wh2_main_def_deadwood_sentinels",
				"wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_dreadspears_0,wh2_main_def_inf_darkshards_0,wh2_main_def_inf_darkshards_0,wh2_main_def_cav_dark_riders_0",
				"wh2_main_the_road_of_skulls_har_ganeth",
				175, 
				691,
				true,
				function(cqi)
					local char = cm:get_character_by_cqi(cqi)
					local mf_cqi = char:military_force()
					local mm = mission_manager:new(cabal_faction_key, "wh2_mixu_mission_the_cabal_early_game_mission_1")
					mm:set_mission_issuer("CLAN_ELDERS")
									
					mm:add_new_objective("ENGAGE_FORCE")
					mm:add_condition("cqi "..mf_cqi:command_queue_index())
					mm:add_condition("requires_victory")
							
					mm:add_payload("money 2000")
					mm:trigger()
					Mixu_Log_2("First turn mission added for wh2_main_chs_the_cabal")							
				end
			)
		else
			mixu_spawn_starting_lord("chs_egrimm_van_horstmann", "names_name_6450684033", "names_name_6450684034", cabal_faction_key, 303, 703)
			mixu_spawn_starting_lord("chs_aekold_helbrass", "names_name_6450684052", "names_name_6450684053", cabal_faction_key, 635, 690)
			
			cm:spawn_agent_at_position(cabal, 300, 699, "wizard", "chs_chaos_sorcerer_fire")					
		end			
	end			
	Mixu_Log_2("Cabal lords spawned")
end

core:add_listener(
	"zz_mixu_cabal_spawns",
	"ScriptEventGlobalCampaignManagerCreated",
	true,
	function(context) 
		if cm:is_new_game() then
			if cm:model():world():faction_exists("wh2_main_chs_chaos_vortex_alternative") then
				cabal_faction_key = "wh2_main_chs_chaos_vortex_alternative";
			end
			if cm:model():world():faction_exists(cabal_faction_key) then		
				local cabal = cm:model():world():faction_by_key(cabal_faction_key)
				if cabal:is_human() then
					if cabal:has_effect_bundle("wh2_main_lord_trait_chs_aekold") then		
						aekold_is_leader = true
					end				
					spawn_cabal_lords(cabal)					
				end
			end
		end	
	end,
	false
)

function mixu_le_cabal()
	
	if cm:model():world():faction_exists("wh2_main_chs_chaos_vortex_alternative") then
		cabal_faction_key = "wh2_main_chs_chaos_vortex_alternative";
	end

	if cm:model():world():faction_exists(cabal_faction_key) then
	
		local cabal = cm:model():world():faction_by_key(cabal_faction_key)		
		if cabal:is_human() then			
			Mixu_Log_2("Adding playable Cabal listeners")
				
			if cabal:has_effect_bundle("wh2_main_lord_trait_chs_aekold") then		
				aekold_is_leader = true
				locked_lord_subtype = "chs_egrimm_van_horstmann"
				ak_missions_mortal = {	
					{mission_name = "mixu_the_cabal_ak_aekold_relic_1", region_key = "wh2_main_avelorn_gaean_vale", x_cord = 0.12, y_cord = 0.43, bundle = "ak_reward_gaean_vale"},	
					{mission_name = "mixu_the_cabal_ak_aekold_relic_2", region_key = "wh2_main_yvresse_tor_yvresse", x_cord = 0.22, y_cord = 0.48, bundle = "ak_reward_tor_yvresse"},		
					{mission_name = "mixu_the_cabal_ak_aekold_relic_3", region_key = "wh_main_eastern_sylvania_castle_drakenhof", x_cord = 0.58, y_cord = 0.31, bundle = "ak_reward_castle_drakenhof"},	
					{mission_name = "mixu_the_cabal_ak_aekold_relic_4", region_key = "wh_main_couronne_et_languille_couronne", x_cord = 0.3, y_cord = 0.24, bundle = "ak_reward_couronne"},	
					{mission_name = "mixu_the_cabal_ak_aekold_relic_5", region_key = "wh_main_the_silver_road_karaz_a_karak", x_cord = 0.62, y_cord = 0.45, bundle = "ak_reward_fiery_ones"},		
					{mission_name = "mixu_the_cabal_ak_aekold_relic_6", region_key = "wh_main_reikland_altdorf", x_cord = 0.38, y_cord = 0.32, bundle = "ak_reward_lord_of_change"},		
					{mission_name = "mixu_the_cabal_ak_aekold_relic_7", region_key = "wh_main_tilea_miragliano", x_cord = 0.42, y_cord = 0.56, bundle = "ak_reward_clawhand"},	
					{mission_name = "mixu_the_cabal_ak_aekold_relic_8", region_key = "wh_main_southern_oblast_kislev", x_cord = 0.6, y_cord = 0.15, bundle = "ak_reward_thralls_of_cabal"}
				}

				ak_missions_vortex = {	
					{mission_name = "mixu_the_cabal_ak_vor_aekold_relic_1", region_key = "wh2_main_vor_avelorn_gaean_vale", x_cord = 0.62, y_cord = 0.17, bundle = "ak_reward_gaean_vale"},	
					{mission_name = "mixu_the_cabal_ak_vor_aekold_relic_2", region_key = "wh2_main_vor_northern_yvresse_tor_yvresse", x_cord = 0.82, y_cord = 0.25, bundle = "ak_reward_tor_yvresse"},		
					{mission_name = "mixu_the_cabal_ak_vor_aekold_relic_3", region_key = "wh2_main_vor_the_great_desert_black_tower_of_arkhan", x_cord = 0.72, y_cord = 0.56, bundle = "ak_reward_lord_of_change"},	
					{mission_name = "mixu_the_cabal_ak_vor_aekold_relic_4", region_key = "wh2_main_vor_land_of_assassins_palace_of_the_wizard_caliph", x_cord = 0.52, y_cord = 0.56, bundle = "ak_reward_thralls_of_cabal"},	
					{mission_name = "mixu_the_cabal_ak_vor_aekold_relic_5", region_key = "wh2_main_vor_the_red_rivers_zlatan", x_cord = 0.58, y_cord = 0.69, bundle = "ak_reward_clawhand"},		
					{mission_name = "mixu_the_cabal_ak_vor_aekold_relic_6", region_key = "wh2_main_vor_southlands_world_edge_mountains_karak_zorn", x_cord = 0.78, y_cord = 0.74, bundle = "ak_reward_fiery_ones"},		
					{mission_name = "mixu_the_cabal_ak_vor_aekold_relic_7", region_key = "wh2_main_vor_the_galleons_graveyard", x_cord = 0.39, y_cord = 0.38, bundle = "ak_reward_the_galleons_graveyard"},	
					{mission_name = "mixu_the_cabal_ak_vor_aekold_relic_8", region_key = "wh2_main_vor_straits_of_lothern_lothern", x_cord = 0.62, y_cord = 0.33, bundle = "ak_reward_lothern"}				
				}	
			end
			
			if cm:get_campaign_name() == "main_warhammer" then
				arcane_knowledge_missions = ak_missions_mortal
			else
				arcane_knowledge_missions = ak_missions_vortex
			end	
			
			local books_of_nagash_spacer = find_uicomponent(core:get_ui_root(), "layout", "resources_bar", "right_spacer_tomb_kings");	
			local books_of_nagash = find_uicomponent(core:get_ui_root(), "layout", "resources_bar", "right_spacer_tomb_kings", "frame", "button_books_of_nagash");	
			local books_of_nagash_number_of_books = find_uicomponent(core:get_ui_root(), "layout", "resources_bar", "right_spacer_tomb_kings", "frame", "dy_num_books");	
			
			books_of_nagash_spacer:SetVisible(true);			
			books_of_nagash:SetVisible(true);	
			books_of_nagash_number_of_books:SetVisible(false);

			if cm:is_new_game() then		
				if aekold_is_leader == false then
					mixu_arcane_knowledge["egrimm_unlocked"] = true
					mixu_arcane_knowledge["aekold_unlocked"] = false					
				else
					mixu_arcane_knowledge["egrimm_unlocked"] = false
					mixu_arcane_knowledge["aekold_unlocked"] = true					
				end	
				
				core:progress_on_loading_screen_dismissed(
					function() 	
						local character_list = cabal:character_list()						
						for i = 0, character_list:num_items() - 1 do
							local character = character_list:item_at(i)	
							if character:character_subtype(locked_lord_subtype) then
								cm:disable_event_feed_events(true, "", "wh_event_subcategory_character_deaths", "")
								cm:kill_character_and_commanded_unit(cm:char_lookup_str(character), true, false)	
								cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_character_deaths", "") end, 0.5)
							elseif aekold_is_leader == false and character:character_subtype("chs_egrimm_van_horstmann") then
								local buildings = {
									"wh_main_horde_chaos_settlement_2",
									"wh2_mixu_special_the_cabal_1"
								}
								local mf_cqi = character:military_force():command_queue_index()
							
								cm:add_building_to_force(mf_cqi, buildings)						
								cm:force_add_ancillary(character, "wh_main_anc_arcane_item_skull_of_katam", true, true)			
							end
						end
					end
				)	
				
				cm:disable_event_feed_events(true, "wh_event_category_faction", "", "")
				
				for i = 1, #arcane_knowledge_missions do
					local mission = arcane_knowledge_missions[i]
					local mm = mission_manager:new(cabal_faction_key, mission.mission_name)
					mm:set_mission_issuer("CLAN_ELDERS")
					mm:add_new_objective("SCRIPTED");
					mm:add_condition("script_key cabal_arcane_mission_"..mission.region_key);
					mm:add_condition("override_text mission_text_text_mixu_objective_override_raze_" .. mission.region_key);
					
					mm:add_payload("effect_bundle{bundle_key mixu_cabal_" .. mission.bundle .. ";turns 0;}");	
					mm:trigger();	
					
					local region = cm:model():world():region_manager():region_by_key(mission.region_key);
					local garrison_residence = region:garrison_residence();
					local garrison_residence_CQI = garrison_residence:command_queue_index();
					cm:add_garrison_residence_vfx(garrison_residence_CQI, "scripted_effect3", true);					
				end		
								
				cm:disable_event_feed_events(false, "wh_event_category_faction", "", "");				
			end -- end of is_new_game
			
			if aekold_is_leader == true then
				starting_lord_checks[effect.get_localised_string("agent_subtypes_onscreen_name_override_chs_egrimm_van_horstmann")] = true		

				if cm:get_campaign_name() == "main_warhammer" then
					storm_chaser_mission = "mixu_the_cabal_ak_aekold_relic_6"
					clawhand_mission = "mixu_the_cabal_ak_aekold_relic_7"
					fiery_ones_mission = "mixu_the_cabal_ak_aekold_relic_5"
					thrall_mission = "mixu_the_cabal_ak_aekold_relic_8"
				else
					storm_chaser_mission = "mixu_the_cabal_ak_vor_aekold_relic_3"
					clawhand_mission = "mixu_the_cabal_ak_vor_aekold_relic_5"
					fiery_ones_mission = "mixu_the_cabal_ak_aekold_relic_6"
					thrall_mission = "mixu_the_cabal_ak_vor_aekold_relic_4"	
				end						
			else
				starting_lord_checks[effect.get_localised_string("agent_subtypes_onscreen_name_override_chs_aekold_helbrass")] = true		
				
				if cm:get_campaign_name() == "wh2_main_great_vortex" then
					storm_chaser_mission = "mixu_the_cabal_ak_vor_egrimm_relic_6"
					clawhand_mission = "mixu_the_cabal_ak_vor_egrimm_relic_8"
					fiery_ones_mission = "mixu_the_cabal_ak_vor_egrimm_relic_7"
					thrall_mission = "mixu_the_cabal_ak_vor_egrimm_relic_3"
				end					
			end

			core:add_listener(
				"mixu_thecabal_missionsucceeded",
				"MissionSucceeded",
				function(context)
					local faction_name = context:faction():name()
					return faction_name == cabal_faction_key
				end,
				function(context)
				local mission_key = context:mission():mission_record_key();
					for i = 1, #arcane_knowledge_missions do
						local arcane = arcane_knowledge_missions[i]
						if mission_key == arcane.mission_name then						
							local region = cm:model():world():region_manager():region_by_key(arcane.region_key)
							local garrison_residence = region:garrison_residence()
							local garrison_residence_CQI = garrison_residence:command_queue_index()
							cm:remove_garrison_residence_vfx(garrison_residence_CQI, "scripted_effect3")
							
							mixu_arcane_knowledge["egrimm_unlocked"] = true
							mixu_arcane_knowledge["aekold_unlocked"] = true
							
							if mission_key == storm_chaser_mission then
								cm:spawn_character_to_pool(cabal_faction_key, "names_name_2147353733", "names_name_2147350329", "", "", 50, true, "general", "chs_malofex_the_storm_chaser", true, "")
							end
							
							if mission_key == clawhand_mission then
								spawn_clawhand(context:faction())
							end
							
							if mission_key == fiery_ones_mission then
								cm:add_unit_to_faction_mercenary_pool(context:faction(), "mixu_chs_mon_fiery_one", 1, 100, 1, 0.1, 0, "", "", "", true)
							end		

							if mission_key == thrall_mission then
								cm:add_unit_to_faction_mercenary_pool(context:faction(), "mixu_chs_inf_thralls_of_cabal", 1, 100, 1, 0.1, 0, "", "", "", true)
							end
							
							if mission_key == "mixu_the_cabal_ak_vor_aekold_relic_8" then
								mixu_arcane_knowledge["reveal_sea_regions"] = true
							end
							
							local number_of_books = mixu_arcane_knowledge["number_of_books"]
							number_of_books = number_of_books + 1
							
							if number_of_books == 8 then
								cm:complete_scripted_mission_objective("wh_main_short_victory", "collect_books_of_arcane_knowledge", true)
								cm:complete_scripted_mission_objective("wh_main_long_victory", "collect_books_of_arcane_knowledge", true)
							end		
							
							core:trigger_event("ArcaneKnowledgeBookGained", "number_of_books_"..tostring(number_of_books))							
						end
					end	
				end,
				true
			)		
			
		core:add_listener(
			"mixu_cabal_CharacterRazedSettlement",
			"CharacterRazedSettlement",
			function(context)
				local faction = context:character():faction();
				return faction:name() == cabal_faction_key and faction:is_human();
			end,
			function(context)
				local char = context:character()
				local region_name = context:garrison_residence():region():name();
				local region = context:garrison_residence():region();
				local ruin_display = "mixu_special_settlement_tzeentch_ruins"
				local display_chain = region:settlement():display_primary_building_chain()
				local building_chain = region:settlement():primary_building_chain()
				
				-- Change the ruin display if the lord razing it is Aekold
				if char:character_subtype("chs_aekold_helbrass") then
					ruin_display = "wh2_dlc12_dummy_nuclear_ruins_oak"
				end

				-- Check if we should complete a book thingy
				for i = 1, #arcane_knowledge_missions do
					local arcane = arcane_knowledge_missions[i]
					if region_name == arcane.region_key then	
						cm:complete_scripted_mission_objective(arcane.mission_name, "cabal_arcane_mission_"..arcane.region_key, true)
					end
				end	
					
				-- Change the appearance of the ruin + save the old details, so we can restore them if someone colonises it.	
				cm:override_building_chain_display(display_chain, ruin_display, region_name)
				cm:override_building_chain_display(building_chain, ruin_display, region_name)	
				mixu_cabal_ruins[region_name] = {display_chain, building_chain}								
			end,
			true
		);		
			
		core:add_listener(
			"mixu_cabal_details_GarrisonOccupiedEvent",
			"GarrisonOccupiedEvent",
			true,
			function(context)
				local region_key = context:garrison_residence():region():name();
					
				if mixu_cabal_ruins[region_key] ~= nil then
					cm:override_building_chain_display(mixu_cabal_ruins[region_key][1], mixu_cabal_ruins[region_key][1], region_key);
					cm:override_building_chain_display(mixu_cabal_ruins[region_key][2], mixu_cabal_ruins[region_key][2], region_key);
					mixu_cabal_ruins[region_key] = nil;
				end
			end,
			true
		)	
	
	core:add_listener(
		"mixu_cabal_reveal_sea_regions",
		"FactionTurnStart",
		function(context)	
			local faction = context:faction()
			return faction:name() == cabal_faction_key and mixu_arcane_knowledge["reveal_sea_regions"] == true
		end,
		function(context)
			local faction = context:faction()
			reveal_all_sea_regions(faction:name());
		end,
		true
	)
	
	core:add_listener(
		"Mixu_Cabal_Panel",
		"PanelOpenedCampaign",
		function(context)
			return cm:whose_turn_is_it() == cabal_faction_key and context.string == "books_of_nagash"
		end,
		function(context)
			local map = find_uicomponent(core:get_ui_root(), "books_of_nagash", "details", "map")	
			local map_overlay = find_uicomponent(core:get_ui_root(), "books_of_nagash", "details", "map", "map_overlay")	

			for i = 0, map:ChildCount() - 1 do	
				for j = 1, #arcane_knowledge_missions do
					local bleh = arcane_knowledge_missions[j]				
					local map_child = UIComponent(map:Find(i))	
					local child_id = map_child:Id()
					local map_x, map_y = map_overlay:Position()						
					if child_id == bleh.mission_name then				
						map_child:MoveTo(map_x + map_overlay:Width() * bleh.x_cord, map_y + map_overlay:Height() * bleh.y_cord)
					end				
				end
			end										
		end,
		true
	)	
	
			
	local function lock_starting_lord(component)			
		-- Some of this stuff is from Vanvan
		-- grab the listbox (scroll bar) and make sure it exists
		local component = component or find_uicomponent(core:get_ui_root(), "character_panel", "general_selection_panel", "character_list_parent", "character_list", "listview", "list_clip", "list_box")
		if not component then
			Mixu_Log_2("lock_starting_lord() called, but the general candidate list is nonexistent!")
			return
		end

		-- loop through all the UIC's found underneath the listbox
		for i = 0, 20 do
			local lord = find_uicomponent(component, "general_candidate_"..i.."_")

			-- stop loop if there is not UIC with that name
			if not lord then break end
					
			-- check the on-screen text
			local subtype = find_uicomponent(lord, "dy_subtype"):GetStateText()			
			local egrimm_subtype = effect.get_localised_string("agent_subtypes_onscreen_name_override_chs_egrimm_van_horstmann")
			local aekold_subtype = effect.get_localised_string("agent_subtypes_onscreen_name_override_chs_aekold_helbrass")
					
			if subtype == egrimm_subtype and mixu_arcane_knowledge["egrimm_unlocked"] ~= true then
				if lord:CurrentState() ~= "inactive" then
					lord:SetState("inactive")
				end
							
				lord:SetTooltipText(effect.get_localised_string("ui_text_replacements_localised_text_chs_egrimm_van_horstmann_lord_lock"), true)
			elseif subtype == aekold_subtype and mixu_arcane_knowledge["aekold_unlocked"] ~= true then
				if lord:CurrentState() ~= "inactive" then
					lord:SetState("inactive")
				end
						
				lord:SetTooltipText(effect.get_localised_string("ui_text_replacements_localised_text_chs_aekold_helbrass_lord_lock"), true)						
			end
		end
	end

	core:add_listener(
		"mixu_cabal_char_panel_opened",
		"PanelOpenedCampaign",
		function(context)
			return cm:whose_turn_is_it() == chaos_faction_key and context.string == "character_panel"
		end,
		function(context)
			core:add_listener(
				"mixu_chaos_lord_clicked",
				"ComponentLClickUp",
				function(context)
					return context.string:starts_with("general_candidate_") and cm:whose_turn_is_it() == chaos_faction_key	
				end,
				function(context)						
					lock_starting_lord()  
				end,
				true
			)							
		end,
		true
	)

	core:add_listener(
		"Mixu_Cabal_Panel",
		"PanelOpenedCampaign",
		function(context)
			return cm:whose_turn_is_it() == cabal_faction_key and context.string == "appoint_new_general"
		end,
		function(context)
			local component = find_uicomponent(core:get_ui_root(), "appoint_new_general", "event_appoint_new_general", "general_selection_panel", "character_list", "listview")
			lock_starting_lord(component) 								
		end,
		true
	)	
	
	core:add_listener(
		"mixu_cabal_starting_lord_lockup_create_army",
		"ComponentLClickUp",
		function(context)
			return context.string == "button_create_army" and cm:whose_turn_is_it() == cabal_faction_key
		end,
		function(context)
			cm:callback(function()							
				lock_starting_lord()  
			end, 0.1)
		end,
		true
	)
	
	core:add_listener(
		"mixu_cabal_starting_lord_lockup_replace_general",
		"ComponentLClickUp",
		function(context)
			return context.string == "button_replace_general" and cm:whose_turn_is_it() == cabal_faction_key
		end,
		function(context)
			cm:callback(function()		
				local component = find_uicomponent(core:get_ui_root(), "character_details_panel", "general_selection_panel", "character_list", "listview", "list_clip", "list_box")						
				lock_starting_lord(component) 
			end, 0.1)
		end,
		true
	)	

	core:add_listener(
		"mixu_cabal_starting_lord_lockup_army_list",
		"ComponentLClickUp",
		function(context)
			return context.string == "tab_units" and cm:whose_turn_is_it() == cabal_faction_key
		end,
		function(context)		
			if aekold_is_leader == false and mixu_arcane_knowledge["aekold_unlocked"] == true then
				return
			end
			
			if aekold_is_leader == true and mixu_arcane_knowledge["egrimm_unlocked"] == true then
				return
			end	
		
			cm:callback(function()							
				local component = find_uicomponent(core:get_ui_root(), "layout", "radar_things", "dropdown_parent", "units_dropdown", "panel", "panel_clip", "sortable_list_units", "list_clip", "list_box")

				if not component then
					Mixu_Log_2("lock_starting_lord() called, but the general candidate list is nonexistent!")
					return
				end
				
				local cqi = get_cqi_of_locked_lord()

				-- loop through all the UIC's found underneath the listbox
				for i = 0, component:ChildCount() - 1 do	
					local lord = UIComponent(component:Find(i))	
					
					-- stop loop if there is not UIC with that name
					if lord then
						if lord:Id() == "character_row_"..cqi then
							lord:SetVisible(false)
						end
					end
				end				
			end, 0.1)
		end,
		true
	)	
	
end	-- End of is_human()
end	-- End of cabal faction exists
end	-- End of main function


-----------------------------
----- Warriors of Chaos	-----
-----------------------------	
local function add_cabal_character_unlock_scripts_for_chaos()
	local chaos_faction_key = "wh_main_chs_chaos"
	if cm:get_campaign_name() == "main_warhammer" and cm:model():world():faction_by_key(chaos_faction_key):is_human() then
		
		Mixu_Log_2("Adding lord unlock listeners for Chaos [Egrimm & Aekold]")
			
		if cm:is_new_game() then
			cm:spawn_character_to_pool(chaos_faction_key, "names_name_6450684033", "names_name_6450684034", "", "", 50, true, "general", "chs_egrimm_van_horstmann", true, "")
			cm:spawn_character_to_pool(chaos_faction_key, "names_name_6450684052", "names_name_6450684053", "", "", 50, true, "general", "chs_aekold_helbrass", true, "")	
		end
			
		core:add_listener(
			"mixu_chaos_recruit_egrimm",
			"CharacterRazedSettlement",
			function(context)
				local faction = context:character():faction()
				local region_name = context:garrison_residence():region():name()
				return faction:name() == chaos_faction_key and faction:is_human() and region_name == "wh_main_reikland_altdorf"
			end,
			function(context)
				if mixu_arcane_knowledge["egrimm_unlocked"] ~= true then
					cm:show_message_event(
						chaos_faction_key,
						"event_feed_strings_text_wh2_mixu_ll_unlocked_title",
						"event_feed_strings_text_wh2_mixu_egrimm_unlocked_primary_detail",
						"event_feed_strings_text_wh2_mixu_egrimm_unlocked_secondary_detail",
						true,
						316
					)
					mixu_arcane_knowledge["egrimm_unlocked"] = true
				end	
			end,
			false
		)
			

		core:add_listener(
			"mixu_chaos_recruit_aekold",
			"MilitaryForceBuildingCompleteEvent",
			function(context)
				return context:character():faction():name() == chaos_faction_key and (context:building() == "wh_main_horde_chaos_magic_2" or context:building() == "_steel_rift_2")
			end,
			function(context)
				if mixu_arcane_knowledge["aekold_unlocked"] ~= true then
					cm:show_message_event(
						chaos_faction_key,
						"event_feed_strings_text_wh2_mixu_ll_unlocked_title",
						"event_feed_strings_text_mixu_aekold_unlocked_primary_detail",
						"event_feed_strings_text_mixu_aekold_unlocked_secondary_detail",
						true,
						319
					)
					mixu_arcane_knowledge["aekold_unlocked"] = true
				end	
			end,
			false
		)		
		local function lock_starting_lord(component)
				
			-- Some of this stuff is still from Vanvan
			-- grab the listbox (scroll bar) and make sure it exists
			local component = component or find_uicomponent(core:get_ui_root(), "character_panel", "general_selection_panel", "character_list_parent", "character_list", "listview", "list_clip", "list_box")
			if not component then
				Mixu_Log_2("lock_starting_lord() called, but the general candidate list is nonexistent!")
				return
			end

			-- loop through all the UIC's found underneath the listbox
			for i = 0, 20 do
				local lord = find_uicomponent(component, "general_candidate_"..i.."_")

				-- stop loop if there is not UIC with that name
				if not lord then break end
					
				-- check the on-screen text
				local subtype = find_uicomponent(lord, "dy_subtype"):GetStateText()			
				local egrimm_subtype = effect.get_localised_string("agent_subtypes_onscreen_name_override_chs_egrimm_van_horstmann")
				local aekold_subtype = effect.get_localised_string("agent_subtypes_onscreen_name_override_chs_aekold_helbrass")
					
				if subtype == egrimm_subtype and mixu_arcane_knowledge["egrimm_unlocked"] ~= true then
					if lord:CurrentState() ~= "inactive" then
						lord:SetState("inactive")
					end
							
					lord:SetTooltipText(effect.get_localised_string("ui_text_replacements_localised_text_chs_egrimm_van_horstmann_lord_lock_chaos"), true)
				elseif subtype == aekold_subtype and mixu_arcane_knowledge["aekold_unlocked"] ~= true then
					if lord:CurrentState() ~= "inactive" then
						lord:SetState("inactive")
					end
						
					lord:SetTooltipText(effect.get_localised_string("ui_text_replacements_localised_text_chs_aekold_helbrass_lord_lock_chaos"), true)						
				end
			end
		end

		core:add_listener(
			"mixu_chaos_char_panel_opened",
			"PanelOpenedCampaign",
			function(context)
				return cm:whose_turn_is_it() == chaos_faction_key and context.string == "character_panel"
			end,
			function(context)
				core:add_listener(
					"mixu_chaos_lord_clicked",
					"ComponentLClickUp",
					function(context)
						Arsh79_logger("mixu_chaos_lord_clicked: "..tostring(context.string))
						return context.string:starts_with("general_candidate_") and cm:whose_turn_is_it() == chaos_faction_key
					end,
					function(context)
						lock_starting_lord()
					end,
					true
				)							
			end,
			true
		)	
		
		core:add_listener(
			"mixu_chaos_appoint_new_general",
			"PanelOpenedCampaign",
			function(context)
				return cm:whose_turn_is_it() == chaos_faction_key and context.string == "appoint_new_general"
			end,
			function(context)
				local component = find_uicomponent(core:get_ui_root(), "appoint_new_general", "event_appoint_new_general", "general_selection_panel", "character_list", "listview")
				lock_starting_lord(component)
			end,
			true
		)	
			
		core:add_listener(
			"mixu_chaos_starting_lord_lockup_create_army",
			"ComponentLClickUp",
			function(context)
				return context.string == "button_create_army" and cm:whose_turn_is_it() == chaos_faction_key
			end,
			function(context)
				cm:callback(function()							
					lock_starting_lord()
				end, 0.1)
			end,
			true
		)
				
		core:add_listener(
			"mixu_chaos_starting_lord_lockup_replace_general",
			"ComponentLClickUp",
			function(context)
				return context.string == "button_replace_general" and cm:whose_turn_is_it() == chaos_faction_key
			end,
			function(context)
				cm:callback(function()
					local component = find_uicomponent(core:get_ui_root(), "character_details_panel", "general_selection_panel", "character_list", "listview", "list_clip", "list_box")						
					lock_starting_lord(component)
				end, 0.1)
			end,
			true
		)		
	end	-- End of Warriors of Chaos script
end


cm:add_first_tick_callback(function() add_cabal_character_unlock_scripts_for_chaos() end)


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("mixu_cabal_ruins", mixu_cabal_ruins, context)
		cm:save_named_value("mixu_arcane_knowledge", mixu_arcane_knowledge, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		mixu_cabal_ruins = cm:load_named_value("mixu_cabal_ruins", {}, context)
		mixu_arcane_knowledge = cm:load_named_value("mixu_arcane_knowledge", {}, context)
	end
)