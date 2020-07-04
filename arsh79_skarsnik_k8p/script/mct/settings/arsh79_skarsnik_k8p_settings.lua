local mct_skarsnik_k8p = mct:register_mod("arsh79_skarsnik_k8p");

mct_skarsnik_k8p:set_title("Skarsnik start in Karak Eight Peaks");
mct_skarsnik_k8p:set_author("Arshesney");
mct_skarsnik_k8p:set_description("Select who starts in Karak Eight Peaks in a new campaign")

local mct_skarsnik_option = mct_skarsnik_k8p:add_new_option("who_controls_k8p", "dropdown");
mct_skarsnik_option:set_text("Karak Eight Peaks owner");
mct_skarsnik_option:add_dropdown_value("skarsnik_value", "Skarsnik", "Skarsnik Warlord of Karak Eight Peaks");
mct_skarsnik_option:add_dropdown_value("belegar_value", "Belegar", "Belegar Ironhammer and his Dawi ancestors");
mct_skarsnik_option:add_dropdown_value("queek_value", "Queek", "Nothing to see here, just an empty ruin, yes-yes.");
mct_skarsnik_option:add_dropdown_value("mutinous_value", "Munitnous Gits", "Dem Muntinous Gits");
mct_skarsnik_option:set_default_value("skarsnik_value");

local mct_k8p_factions_war = mct_skarsnik_k8p:add_new_option("factions_at_war", "checkbox");
mct_k8p_factions_war:set_text("Factions at war");
mct_k8p_factions_war:set_tooltip_text("Belegar, Queek and Skarsnik start at war");
mct_k8p_factions_war:set_default_value(true);

Arsh79_logger("MCT menu initialized");