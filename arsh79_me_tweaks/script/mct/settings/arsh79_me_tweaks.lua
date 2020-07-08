local mct_me_tweaks = mct:register_mod("arsh79_me_tweaks");

mct_me_tweaks:set_title("Mortal Empires tweaks");
mct_me_tweaks:set_author("Arshesney");
mct_me_tweaks:set_description("Various tweaks for Mortal Empires campaign")

-- Karak Eight Peaks
local mct_skarsnik_option = mct_me_tweaks:add_new_option("who_controls_k8p", "dropdown");
mct_skarsnik_option:set_text("Karak Eight Peaks owner");
mct_skarsnik_option:add_dropdown_value("skarsnik_value", "Skarsnik", "Skarsnik Warlord of Karak Eight Peaks");
mct_skarsnik_option:add_dropdown_value("belegar_value", "Belegar", "Belegar Ironhammer and his Dawi ancestors");
mct_skarsnik_option:add_dropdown_value("queek_value", "Queek", "Nothing to see here, just an empty ruin, yes-yes.");
mct_skarsnik_option:add_dropdown_value("mutinous_value", "Munitnous Gits", "Dem Muntinous Gits");
mct_skarsnik_option:set_default_value("skarsnik_value");

local mct_k8p_factions_war = mct_me_tweaks:add_new_option("factions_at_war", "checkbox");
mct_k8p_factions_war:set_text("Factions at war");
mct_k8p_factions_war:set_tooltip_text("Belegar, Queek and Skarsnik start at war");
mct_k8p_factions_war:set_default_value(true);

-- Imrik
local mct_imrik_province_option = mct_me_tweaks:add_new_option("imrik_starting_region", "checkbox");
mct_imrik_province_option:set_text("Control starting province");
mct_imrik_province_option:set_tooltip_text("Imrik controls his whole starting province");
mct_imrik_province_option:set_default_value(true);
local mct_imrik_confederation_option = mct_me_tweaks:add_new_option("imrik_confederation", "checkbox");
mct_imrik_confederation_option:set_text("Confederate with Caledor");
mct_imrik_confederation_option:set_tooltip_text("Imrik confederates with Caledor on turn 6");
mct_imrik_confederation_option:set_default_value(true);

-- Teclis
local mct_teclis_confederation_option = mct_me_tweaks:add_new_option("teclis_confederation", "checkbox");
mct_teclis_confederation_option:set_text("Confederate with Saphery");
mct_teclis_confederation_option:set_tooltip_text("Teclis confederates with Saphery on turn 2");
mct_teclis_confederation_option:set_default_value(true);

-- Couronne starting wars
local mct_bretonnia_starting_wars = mct_me_tweaks:add_new_option("bretonnia_starting_wars", "checkbox");
mct_bretonnia_starting_wars:set_text("Enable alternate starting wars");
mct_bretonnia_starting_wars:set_tooltip_text("Couronne not at war with Marienburg and Norsca, but with Vanaheimlings");
mct_bretonnia_starting_wars:set_default_value(true);

-- AI wars
local mct_ai_wars = mct_me_tweaks:add_new_option("ai_wars", "checkbox");
mct_ai_wars:set_text("AI does not ignore other AI faction for war");
mct_ai_wars:set_tooltip_text("AI will have a chance to declare war on another AI faction when below -200 opinion");
mct_ai_wars:set_default_value(false);

Arsh79_logger("MCT menu initialized");
