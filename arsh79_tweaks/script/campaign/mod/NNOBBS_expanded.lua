--Vars----------------------------------------------------------
local trigger = 0;
----------------------------------------------------------------


----------------------------------------------------------------
--Which lords get exp?------------------------------------------
----------------------------------------------------------------
local legendary_lords_subtype = {

	--Empire----------------------------------------------------
	["emp_karl_franz"] = true,
	["emp_balthasar_gelt"] = true,
	["dlc04_emp_volkmar"] = true,
	["dlc03_emp_boris_todbringer"] = true,
	["emp_alberich_haupt_anderssen"] = true,
	["emp_alberich_von_korden"] = true,
	["emp_alberich_von_korden_hero"] = true,
	["emp_aldebrand_ludenhof"] = true,
	["emp_edward_van_der_kraal"] = true,
	["emp_helmut_feuerbach"] = true,
	["emp_luthor_huss"] = true,
	["emp_marius_leitdorf"] = true,
	["wh2_dlc13_emp_cha_markus_wulfhart_0"] = true,
	["emp_theoderic_gausser"] = true,
	["emp_theodore_bruckner"] = true,
	["emp_valmir_von_raukov"] = true,
	["emp_vorn_thugenheim"] = true,
	["emp_wolfram_hertwig"] = true,
	["wh2_dlc13_emp_hunter_doctor_hertwig_van_hal"] = true,
	["wh2_dlc13_emp_hunter_jorek_grimm"] = true,
	["wh2_dlc13_emp_hunter_kalara_of_wydrioth"] = true,
	["wh2_dlc13_emp_hunter_rodrik_l_anguille"] = true,
	["mixu_elspeth_von_draken"] = true,

	--Southern Realms----------------------------------------------------
	["teb_borgio_the_besieger"] = true,
	["teb_gashnag"] = true,
	["teb_lucrezzia_belladonna"] = true,
	["teb_tilea"] = true,
	["teb_estalia"] = true,
	["teb_border_princes"] = true,
	["teb_colombo"] = true,
	["teb_new_world_colonies"] = true,

	--Kislev----------------------------------------------------
	["mixu_katarin_the_ice_queen"] = true,

	--Greenskins------------------------------------------------
	["grn_azhag_the_slaughterer"] = true,
	["grn_grimgor_ironhide"] = true,
	["dlc06_grn_skarsnik"] = true,
	["dlc06_grn_wurrzag_da_great_prophet"] = true,
	["grn_gorfang_rotgut"] = true,
	["wh2_dlc15_grn_grom_the_paunch"] = true,
	["spcha_grn_borgut_facebeater"] = true,
	["spcha_grn_grokka_goreaxe"] = true,
	["spcha_grn_tinitt_foureyes"] = true,
	["spcha_grn_grak_beastbasha"] = true,
	["spcha_grn_duffskul"] = true,
	["spcha_grn_snagla_grobspit"] = true,
	["grn_gorbad_ironclaw"] = true,
	["wh_main_grn_grom"] = true,

	--Dwarfs----------------------------------------------------
	["dwf_thorgrim_grudgebearer"] = true,
	["pro01_dwf_grombrindal"] = true,
	["dlc06_dwf_belegar"] = true,
	["dwf_ungrim_ironfist"] = true,
	["dwf_kazador_dragonslayer"] = true,
	["dwf_thorek_ironbrow"] = true,
	["dwf_grimm_burloksson"] = true,
	["dwf_byrrnoth_grundadrakk"] = true,
	["dwf_rorek_granitehand"] = true,
	["dwf_alrik_ranulfsson"] = true,
	["dwf_barundin_stoneheart"] = true,
	["dwf_brokk_ironpick"] = true,
	["dwf_sven_hasselfriesian"] = true,

	--Vampire Counts--------------------------------------------
	["vmp_mannfred_von_carstein"] = true,
	["dlc04_vmp_helman_ghorst"] = true,
	["vmp_heinrich_kemmler"] = true,
	["dlc04_vmp_vlad_con_carstein"] = true,
	["pro02_vmp_isabella_von_carstein"] = true,
	["wh_dlc05_vmp_red_duke"] = true,
	["wh2_dlc11_vmp_bloodline_blood_dragon"] = true,
	["wh2_dlc11_vmp_bloodline_lahmian"] = true,
	["wh2_dlc11_vmp_bloodline_necrarch"] = true,
	["wh2_dlc11_vmp_bloodline_strigoi"] = true,
	["wh2_dlc11_vmp_bloodline_von_carstein"] = true,

	--Bretonnia-------------------------------------------------
	["brt_louen_leoncouer"] = true,
	["dlc07_brt_alberic"] = true,
	["brt_adalhard"] = true,
	["brt_almaric_de_gaudaron"] = true,
	["brt_bohemond"] = true,
	["brt_cassyon"] = true,
	["brt_chilfroy"] = true,
	["brt_donna_don_domingio"] = true,
	["brt_john_tyreweld"] = true,
	["dlc07_brt_green_knight"] = true,
	["dlc07_brt_fay_enchantress"] = true,
	["wh2_dlc14_brt_repanse"] = true,
	
	--Wood Elves------------------------------------------------
	["dlc05_wef_orion"] = true,
	["dlc05_wef_durthu"] = true,
	["wef_daith"] = true,
	["wef_drycha"] = true,
	["wef_naieth_the_prophetess"] = true,

	--Beastmen--------------------------------------------------
	["dlc03_bst_khazrak"] = true,
	["dlc03_bst_graktar"] = true,
	["dlc03_bst_malagor"] = true,
	["dlc05_bst_morghur"] = true,
	["bst_taurox"] = true,

	--Warriors of Chaos-----------------------------------------
	["chs_kholek_suneater"] = true,
	["chs_prince_sigvald"] = true,
	["chs_archaon"] = true,
	["chs_lord_of_change"] = true,
	["chs_egrimm_van_horstmann"] = true,
	["chs_aekold_helbrass"] = true,

	--Norsca----------------------------------------------------
	["wh_dlc08_nor_throgg"] = true,
	["wh_dlc08_nor_wulfrik"] = true,
	["dlc08_nor_kihar"] = true,
	["wh_dlc08_nor_arzik"] = true,
	["nor_egil_styrbjorn"] = true,
	["nor_bloodfather_ritual"] = true,

	--High Elves------------------------------------------------
	["wh2_main_hef_tyrion"] = true,
	["wh2_main_hef_teclis"] = true,
	["wh2_dlc10_hef_alarielle"] = true,
	["wh2_dlc10_hef_alith_anar"] = true,
	["wh2_main_hef_prince_alastar"] = true,
	["wh2_dlc15_hef_eltharion"] = true,
	["hef_belannaer"] = true,
	["hef_caradryan"] = true,
	["hef_korhil"] = true,
	["wh2_dlc15_hef_imrik"] = true,
	["hef_caradryan_hero"] = true,
	["AK_aislinn"] = true,
	["wh2_main_hef_eltharion"] = true,
	["wh2_main_hef_eldyra"] = true,
	["wh2_main_hef_finudel"] = true,

	--Dark Elves------------------------------------------------
	["wh2_main_def_malekith"] = true,
	["wh2_main_def_morathi"] = true,
	["wh2_dlc10_def_crone_hellebron"] = true,
	["wh2_dlc11_def_lokhir"] = true,
	["def_kouran_darkhand"] = true,
	["def_tullaris_dreadbringer"] = true,
	["def_tullaris_hero"] = true,
	["wh2_dlc14_def_malus_darkblade"] = true,
	["def_rakarth"] = true,
	["def_hag_queen_malida"] = true,

	--Lizardmen-------------------------------------------------
	["wh2_main_lzd_kroq_gar"] = true,
	["wh2_main_lzd_lord_mazdamundi"] = true,
	["wh2_dlc12_lzd_tehenhauin"] = true,
	["wh2_dlc12_lzd_tiktaqto"] = true,
	["lzd_chakax"] = true,
	["lzd_tetto_eko"] = true,
	["lzd_lord_huinitenuchli"] = true,
	["lzd_oxyotl"] = true,
	["wh2_dlc12_lzd_lord_kroak"] = true,
	["wh2_dlc13_lzd_nakai"] = true,
	["wh2_dlc13_lzd_gor_rok"] = true,

	--Skaven----------------------------------------------------
	["wh2_main_skv_queek_headtaker"] = true,
	["wh2_main_skv_lord_skrolk"] = true,
	["wh2_dlc09_skv_tretch_craventail"] = true,
	["wh2_dlc12_skv_ikit_claw"] = true,
	["wh2_dlc14_skv_deathmaster_snikch"] = true,
	["skv_feskit"] = true,
	["skv_skweel_gnawtooth"] = true,

	--Tomb Kings------------------------------------------------
	["wh2_dlc09_tmb_arkhan"] = true,
	["wh2_dlc09_tmb_settra"] = true,
	["wh2_dlc09_tmb_khalida"] = true,
	["wh2_dlc09_tmb_khatep"] = true,
	["wh2_dlc09_tmb_tomb_king_alkhazzar_ii"] = true,
	["wh2_dlc09_tmb_tomb_king_lahmizzash"] = true,
	["wh2_dlc09_tmb_tomb_king_rakhash"] = true,
	["wh2_dlc09_tmb_tomb_king_setep"] = true,
	["wh2_dlc09_tmb_tomb_king_thutep"] = true,
	["wh2_dlc09_tmb_tomb_king_wakhaf"] = true,
	["tmb_ramhotep"] = true,
	["tmb_tutankhanut"] = true,

	--Vampire Coast---------------------------------------------
	["wh2_dlc11_cst_aranessa"] = true,
	["wh2_dlc11_cst_noctilus"] = true,
	["wh2_dlc11_cst_cylostra"] = true,
	["wh2_dlc11_cst_harkon"] = true;

	--Whysofurious
	["helsnicht"] = true;
	["konrad"] = true;
	["mallobaude"] = true;
	["zacharias"] = true;
	["sycamo"] = true;

	--Ordo Draconis
	["abhorash"] = true;
	["vmp_walach_harkon_hero"] = true;
	["tib_kael"] = true;

	--Ultimate Chaos
	["Unique_Aberghast"] = true;

	--Karaka Drak
	["dwf_kraka_drak"] = true;

	--Amazons
	["roy_amz_penthesilea"] = true;
	["roy_amz_lwaxana"] = true;

	--OvN
	["albion_morrigan"] = true;
	["Dread_King"] = true;
	["Sultan_Jaffar"] = true;
	["elo_chief_ugma"] = true;
	["morgan_bernhardt"] = true;
	["ovn_stormrider"] = true;

	--Sword of the Emperor
	["emp_cha_helborg"] = true;

	--Vangheist
	["cst_vangheist"] = true;

	--Chorfs
	["drazhoath_the_ashen"] = true;
	["rykarth_the_unbreakable"] = true;
	["zhatan_the_black"] = true;
}


----------------------------------------------------------------
--Give EXP to Lords---------------------------------------------
----------------------------------------------------------------
local function Give_exp_at_turn ()
	if trigger == 0 then

		core:add_listener (
			"CharactersGetEXP",
			"CharacterTurnStart",

			function(context)
				return not (context:character():faction():is_human()) and (cm:model():turn_number() % 4) == 0 
				end,

			function(context)
				local char = context:character()
                local char_cqi = char:command_queue_index()
                local char_str = cm:char_lookup_str(char_cqi)
				if legendary_lords_subtype[char:character_subtype_key()] then
                    if char:rank() <= 10 then
						cm:add_agent_experience(char_str, 1330, false)
                    elseif char:rank() <= 20 and char:rank() > 10 then
                        cm:add_agent_experience(char_str, 1050, false)
                    elseif char:rank() <= 30 and char:rank() > 20 then 
                        cm:add_agent_experience(char_str, 490, false)
                    end
				end
			end,
			true
		)
	end
end;

cm:add_first_tick_callback(function()
	
 	Give_exp_at_turn ()
end);
----------------------------------------------------------------