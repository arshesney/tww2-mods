out("=========== Skarsnik start in Eight Peaks begin ===========");

function Arsh79_logger(text)
	if not __write_output_to_logfile then
		return;
	end

	local log_text = tostring(text);
	local log_timestamp = os.date("%Y-%m-%d, %X");
	local pop_log = io.open("arsh79_skarsnik_k8p.txt", "a");
	pop_log :write("skarsnik_K8P: [".. log_timestamp .."]: ".. log_text .."\n");
	pop_log :flush()
	pop_log :close()
end

local function get_rid_of_mutinous_gits()
	Arsh79_logger("Get rid of Mutinous Gits");

	local gits = cm:get_faction("wh_main_grn_necksnappers");
	local gits_leader_cqi = gits:faction_leader():command_queue_index();
	Arsh79_logger("Mutinous Gits leader is: "..tostring(gits_leader_cqi));

	cm:kill_character(gits_leader_cqi, true, false);
end

local function move_faction_chars_to_region(faction, region)
	-- Get Characters from faction:
	Arsh79_logger("Moving faction characters for: ".. tostring(faction:name()));
	local character_list = faction:character_list();
	for i = 0, character_list:num_items() - 1 do (function()
		local current_char_obj = character_list:item_at(i);
		local current_char_cqi = cm:char_lookup_str(current_char_obj:command_queue_index());
		Arsh79_logger("Current character: ".. tostring(current_char_cqi) ..", forename: ".. tostring(current_char_obj:get_forename()));

		-- Only teleport valid characters (politicians are in recruitng pool, garrison residence for heroes in garrisons)
		if current_char_obj:is_politician() or current_char_obj:is_wounded() or current_char_obj:has_garrison_residence() then
			Arsh79_logger("Character: ".. tostring(current_char_cqi) .." not on map, skipping.");
			return
		end
		-- Find a valid spawn point at target region
		local spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_settlement(
			faction:name(),
			region,
			false,
			true,
			i * 2 + 3
		);
		Arsh79_logger("Spawn for ".. tostring(current_char_cqi) ..": ".. tostring(spawn_x) ..", ".. tostring(spawn_y));
		cm:teleport_to(current_char_cqi, spawn_x, spawn_y, true);
	end)()
	end
end

-- Main function
local function arsh79_skarsnik_k8p()
	Arsh79_logger("Main function for Skarsnik");

	local crooked_moon = cm:get_faction("wh_main_grn_crooked_moon");
	local skarsnik_cqi = cm:char_lookup_str(crooked_moon:faction_leader():command_queue_index());
	Arsh79_logger("Skarsnik is: "..tostring(skarsnik_cqi));

	if crooked_moon and not crooked_moon:is_human() then
		Arsh79_logger("Skarsink is AI controlled, giving him K8P");

		get_rid_of_mutinous_gits();

		-- Transfer region to Crooked Moon and move Skarsnik there (don't leave Sly da Miser behind!)
		cm:transfer_region_to_faction("wh_main_eastern_badlands_karak_eight_peaks", crooked_moon:name());

		move_faction_chars_to_region(crooked_moon, "wh_main_eastern_badlands_karak_eight_peaks");

		-- Give Skarsnik some XP
		cm:add_agent_experience(skarsnik_cqi, 2000);

		-- some units
		cm:grant_unit_to_character(skarsnik_cqi, "wh_main_grn_inf_night_goblins");
		cm:grant_unit_to_character(skarsnik_cqi, "wh_main_grn_inf_night_goblin_archers");
		cm:grant_unit_to_character(skarsnik_cqi, "wh_main_grn_mon_trolls");

		-- And a shaman
		local smn_x, smn_y = cm:find_valid_spawn_location_for_character_from_settlement(
			crooked_moon:name(),
			"wh_main_eastern_badlands_karak_eight_peaks",
			false,
			true,
			6
		);
		Arsh79_logger("Shaman spawn: ".. tostring(smn_x) ..", ".. tostring(smn_y));
		cm:create_agent(
			crooked_moon:name(),
			"wizard",
			"grn_night_goblin_shaman",
			smn_x,
			smn_y,
			false,
			function(cqi)
				Arsh79_logger("spawned shaman with cqi. "..cqi);
			end);

		-- Now, for Karak Azgaraz, give it back to Karak Norn
		cm:transfer_region_to_faction("wh_main_southern_grey_mountains_karak_azgaraz", "wh_main_dwf_karak_norn");

		-- Peace out Karak Norn
		cm:force_make_peace(crooked_moon:name(), "wh_main_dwf_karak_norn");

		-- And war with Clan Volkn
		cm:force_declare_war("wh2_dlc15_skv_clan_volkn", crooked_moon:name(), false, false, false);

		eight_peaks_check(crooked_moon:name());
		Arsh79_logger("K8P Skarsnik init done!");
	end
end

local function arsh79_belegar_k8p()
	Arsh79_logger("Main function for Belegar");

	local clan_angrund = cm:get_faction("wh_main_dwf_karak_izor");
	local belegar_cqi = cm:char_lookup_str(clan_angrund:faction_leader():command_queue_index());
	Arsh79_logger("Belegar is: "..tostring(belegar_cqi));

	if clan_angrund and not clan_angrund:is_human() then
		Arsh79_logger("Belegar is AI controlled, giving him K8P");

		get_rid_of_mutinous_gits();

		-- Transfer region control
		cm:transfer_region_to_faction("wh_main_eastern_badlands_karak_eight_peaks", clan_angrund:name());

		move_faction_chars_to_region(clan_angrund, "wh_main_eastern_badlands_karak_eight_peaks");

		-- Move Skarsnik to Karak Izor if AI controlled
		local crooked_moon = cm:get_faction("wh_main_grn_crooked_moon");
		if crooked_moon and not crooked_moon:is_human() then
			Arsh79_logger("Skarsnik is also AI controlled, moving him to Karak Izor");

			cm:transfer_region_to_faction("wh_main_the_vaults_karak_izor", crooked_moon:name());
			move_faction_chars_to_region(crooked_moon, "wh_main_the_vaults_karak_izor");

			-- And abandon Karak Azgaraz
			cm:set_region_abandoned("wh_main_southern_grey_mountains_karak_azgaraz");

			-- Peace out Karak Norn
			cm:force_make_peace(crooked_moon:name(), "wh_main_dwf_karak_norn");
		else
			-- Otherwise Karak Izor goes to Clan Spittel
			cm:transfer_region_to_faction("wh_main_the_vaults_karak_izor", "wh2_main_skv_clan_spittel");
		end

		-- War with Clan Volkn
		cm:force_declare_war("wh2_dlc15_skv_clan_volkn", clan_angrund:name(), false, false, false);

		eight_peaks_check(clan_angrund:name());
		Arsh79_logger("K8P Belegar init done!");
	end
end

local function arsh79_queek_k8p()
	Arsh79_logger("Main function for Queek");

	local clan_mors = cm:get_faction("wh2_main_skv_clan_mors");
	local queek_cqi = cm:char_lookup_str(clan_mors:faction_leader():command_queue_index());
	Arsh79_logger("Queek is: "..tostring(queek_cqi));

	if clan_mors and not clan_mors:is_human() then
		Arsh79_logger("Queek is AI controlled, giving him K8P");

		get_rid_of_mutinous_gits();

		-- Transfer region control
		cm:transfer_region_to_faction("wh_main_eastern_badlands_karak_eight_peaks", clan_mors:name());

		move_faction_chars_to_region(clan_mors, "wh_main_eastern_badlands_karak_eight_peaks");

		-- Abandon Karag Orrud
		cm:set_region_abandoned("wh2_main_charnel_valley_karag_orrud");

		eight_peaks_check(clan_mors:name());
		Arsh79_logger("K8P Queek init done!");
	end
end

-- Check for MCT
local mcm = _G.mcm;

-- And set a default value
cm:set_saved_value("mcm_tweaker_arsh79_k8p_who_control_value", "skarsnik_value");

-- Build MCT menu if present
if not not mcm then
	Arsh79_logger("found MCT, setting up menu for Skarsnik K8P");
	local skarsnik_k8p_mcm = mcm:register_mod("arsh79_k8p", "Skarsnik K8P", "Skarsnik start in Karak Eight Peaks");
	local skarsnik_k8p_set = skarsnik_k8p_mcm:add_tweaker("who_control", "Choose who starts in Karak Eight Peaks");

	skarsnik_k8p_set:add_option("skarsnik_value", "Skarsnik", "Skarsnik Warlord of Karak Eight Peaks");
	skarsnik_k8p_set:add_option("belegar_value", "Belegar", "Belegar Ironhammer");
	skarsnik_k8p_set:add_option("queek_value", "Queek", "Queek Headtaker");
	skarsnik_k8p_set:add_option("mutinous_value", "Munitnous Gits", "Dem Muntinous Gits");
end

-- And listen for its callback
local skarsnik_k8p_callback = function()
	local value = cm:get_saved_value("mcm_tweaker_arsh79_k8p_who_control_value");

	Arsh79_logger("MCT selection: "..tostring(value));

	if value == "skarsnik_value" then
		Arsh79_logger("Skarsnik Warlord of Karak Eight Peaks");
		arsh79_skarsnik_k8p();
	elseif value == "belegar_value" then
		Arsh79_logger("Belegar Ironhammer");
		arsh79_belegar_k8p();
	elseif value == "queek_value" then
		Arsh79_logger("Queek Headtaker");
		arsh79_queek_k8p();
	else
		Arsh79_logger("Dem Muntinous Gits");
	end
end

-- No MCM, just add to first tick with default value
if not mcm then
	Arsh79_logger("no MCT, running at first tick");
	cm.first_tick_callbacks[#cm.first_tick_callbacks+1] = function()
		if cm:is_new_game() then
			Arsh79_logger("new game first tick");
			skarsnik_k8p_callback();
		end
	end
else
	Arsh79_logger("from MCT menu");
	mcm:add_new_game_only_callback(skarsnik_k8p_callback);
end