out("=========== Skarsnik start in Eight Peaks begin ===========");

-- Check for MCT
local mcm = _G.mcm;

-- And set a default value (MCT 1)
cm:set_saved_value("mcm_tweaker_arsh79_k8p_who_control_value", "skarsnik_value");
-- MCT 2
local settings = {
	mct_skarsnik_option_value = "skarsnik_value",
	mct_k8p_factions_war_value = true,
}

local function disable_feed()
	cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "");
	cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
end

local function enable_feed()
	cm:callback(
		function()
			cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "");
			cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
		end,
		1
	);
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

-- Declare war between the K8P factions if they are not human controlled
local function k8p_race_wardecs(faction)
	local k8p_factions = {
		"wh_main_grn_crooked_moon",
		"wh_main_dwf_karak_izor",
		"wh2_main_skv_clan_mors"
	}
	if not settings.mct_k8p_factions_war_value then
		Arsh79_logger("War declarations disabled by settings");
		return
	end

	Arsh79_logger("Declaring war against "..faction)
	for _, current_faction_str in ipairs(k8p_factions) do

		local current_faction = cm:get_faction(current_faction_str);
		Arsh79_logger("Check if "..current_faction_str.." is a player")

		if current_faction_str ~= faction and not current_faction:is_human() then
			Arsh79_logger(current_faction_str.." declares war on "..faction)
			cm:force_declare_war(current_faction_str, faction, false, false, false);
		end
	end
end

-- Transfer K8P control
local function k8p_to_faction(faction)
	get_rid_of_mutinous_gits();

	cm:transfer_region_to_faction("wh_main_eastern_badlands_karak_eight_peaks", faction:name());
	move_faction_chars_to_region(faction, "wh_main_eastern_badlands_karak_eight_peaks");

	k8p_race_wardecs(faction:name());

	-- CA function for k8p owned events
	eight_peaks_check(faction:name());
end

-- Main functions
local function arsh79_skarsnik_k8p()
	Arsh79_logger("Main function for Skarsnik");
	disable_feed();

	local crooked_moon = cm:get_faction("wh_main_grn_crooked_moon");
	local skarsnik_cqi = cm:char_lookup_str(crooked_moon:faction_leader():command_queue_index());
	Arsh79_logger("Skarsnik is: "..tostring(skarsnik_cqi));

	if crooked_moon and not crooked_moon:is_human() then
		Arsh79_logger("Skarsink is AI controlled, giving him K8P");

		k8p_to_faction(crooked_moon);

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

		-- Peace out Karak Norn, we're too far to care
		cm:force_make_peace(crooked_moon:name(), "wh_main_dwf_karak_norn");

		Arsh79_logger("K8P Skarsnik init done!");
	end
	enable_feed();
end

local function arsh79_belegar_k8p()
	Arsh79_logger("Main function for Belegar");
	disable_feed();

	local clan_angrund = cm:get_faction("wh_main_dwf_karak_izor");
	local belegar_cqi = cm:char_lookup_str(clan_angrund:faction_leader():command_queue_index());
	Arsh79_logger("Belegar is: "..tostring(belegar_cqi));

	if clan_angrund and not clan_angrund:is_human() then
		Arsh79_logger("Belegar is AI controlled, giving him K8P");

		k8p_to_faction(clan_angrund);

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
		Arsh79_logger("K8P Belegar init done!");
	end
	enable_feed();
end

local function arsh79_queek_k8p()
	Arsh79_logger("Main function for Queek");
	disable_feed();

	local clan_mors = cm:get_faction("wh2_main_skv_clan_mors");
	local queek_cqi = cm:char_lookup_str(clan_mors:faction_leader():command_queue_index());
	Arsh79_logger("Queek is: "..tostring(queek_cqi));

	if clan_mors and not clan_mors:is_human() then
		Arsh79_logger("Queek is AI controlled, giving him K8P");

		k8p_to_faction(clan_mors);

		-- Abandon Karag Orrud
		cm:set_region_abandoned("wh2_main_charnel_valley_karag_orrud");

		Arsh79_logger("K8P Queek init done!");
	end
	enable_feed();
end

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

	if mcm then
		settings.mct_skarsnik_option_value = cm:get_saved_value("mcm_tweaker_arsh79_k8p_who_control_value");
		Arsh79_logger("MCT selection: "..tostring(settings.mct_skarsnik_option_value));
	end

	Arsh79_logger("Settings: "..tostring(settings.mct_skarsnik_option_value)..", war: "..tostring(settings.mct_k8p_factions_war_value));

	if settings.mct_skarsnik_option_value == "skarsnik_value" then
		arsh79_skarsnik_k8p();
	elseif settings.mct_skarsnik_option_value == "belegar_value" then
		arsh79_belegar_k8p();
	elseif settings.mct_skarsnik_option_value == "queek_value" then
		arsh79_queek_k8p();
	else
		Arsh79_logger("Dem Muntinous Gits");
		k8p_race_wardecs("wh2_main_skv_clan_mors");
	end
end

-- No MCT 1, just add to first tick with default value
if not mcm then
	Arsh79_logger("no MCT 1.0, adding listener for MCT 2.0 and/or the default action at first tick");

	core:add_listener(
		"arsh79_skarsnik_k8p_init",
		"MctInitialized",
		true,
		function(context)
			Arsh79_logger("MCT initialized listener called");
			local mct = context:mct();

			local k8p_mod = mct:get_mod_by_key("arsh79_skarsnik_k8p");
			Arsh79_logger("Got settings from MCT");

			local mct_skarsnik_option = k8p_mod:get_option_by_key("who_controls_k8p");
			local mct_skarsnik_option_value = mct_skarsnik_option:get_finalized_setting();
			mct_skarsnik_option:set_read_only();
			Arsh79_logger("mct_skarsnik_option_value: "..tostring(mct_skarsnik_option_value));

			local mct_k8p_factions_war = k8p_mod:get_option_by_key("factions_at_war");
			local mct_k8p_factions_war_value = mct_k8p_factions_war:get_finalized_setting();
			mct_k8p_factions_war:set_read_only();
			Arsh79_logger("mct_k8p_factions_war_value: "..tostring(mct_k8p_factions_war_value));

			settings.mct_skarsnik_option_value = mct_skarsnik_option_value;
			settings.mct_k8p_factions_war_value = mct_k8p_factions_war_value;

			Arsh79_logger("MCT 2 faction: "..tostring(settings.mct_skarsnik_option_value)..", war: "..tostring(mct_k8p_factions_war_value));
		end,
		true
	)

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