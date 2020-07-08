--[[ ME tweaks

    Skarsnik K8P
    Wulfart - Empire alliance
    Imrik's starting region and Caledor confederation


    From SFO:
    cm:force_make_peace("wh_main_grn_crooked_moon", "wh_main_emp_wissenland");
	cm:force_make_peace("wh_dlc08_nor_norsca", "wh_main_brt_bretonnia");
	cm:force_make_peace("wh_main_emp_marienburg", "wh_main_brt_bretonnia");		

	if not cm:is_multiplayer() then
		cm:force_declare_war("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon", false, false);
		cm:force_declare_war("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor", false, false);
		cm:force_declare_war("wh_dlc08_nor_vanaheimlings", "wh_main_brt_bretonnia", false, false);
    end
    

]]