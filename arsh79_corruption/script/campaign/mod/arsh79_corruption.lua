--[[
    Events:
    CharacterEntersAttritionalArea
    CharacterFinishedMovingEvent
]]


local corruption_bundles = {
	"wh_main_bundle_region_chaos_corruption_attrition",
	"wh_main_bundle_region_chaos_corruption_attrition_good",
	"wh_main_bundle_region_chaos_corruption_high",
	"wh_main_bundle_region_chaos_corruption_high_good",
	"wh_main_bundle_region_chaos_corruption_low",
	"wh_main_bundle_region_chaos_corruption_low_good",
	"wh_main_bundle_region_chaos_corruption_medium",
	"wh_main_bundle_region_chaos_corruption_medium_good",
	"wh_main_bundle_region_vampiric_corruption_attrition",
	"wh_main_bundle_region_vampiric_corruption_attrition_bad",
	"wh_main_bundle_region_vampiric_corruption_high",
	"wh_main_bundle_region_vampiric_corruption_high_good",
	"wh_main_bundle_region_vampiric_corruption_low",
	"wh_main_bundle_region_vampiric_corruption_low_good",
	"wh_main_bundle_region_vampiric_corruption_medium",
	"wh_main_bundle_region_vampiric_corruption_medium_good",
	"wh_main_bundle_region_untainted_attrition",
}

local turns_in_corrupted_region = 0;

local function clear_effects_from_bundle(effects_bundle)
    return
end

core:add_listener(
    "DumpEffectsTurnStart",
    "FactionTurnStart",
    true,
    function(context)
        for i = 0, context:faction():military_force_list():num_items() -1 do
            local army = context:faction():military_force_list():item_at(i)
            local army_cqi = army:command_queue_index()
            local army_general_cqi = army:general_character():cqi()
            local faction_str = army:faction():name()
            Arsh79_logger("Army "..tostring(army_cqi).." from "..tostring(faction_str).." led by "..tostring(army_general_cqi))
            if not army:effect_bundles():is_empty() then
                for j = 0, army:effect_bundles():num_items() -1 do
                    local current_bundle = army:effect_bundles():item_at(j)
                    Arsh79_logger("Army "..tostring(army_cqi).." has effect_bundle "..tostring(current_bundle:key()))
                    if not current_bundle:effects():is_empty() then
                        local bundle_effects = current_bundle:effects()
                        for y = 0, bundle_effects:num_items() -1 do
                            local effect = bundle_effects:item_at(y)
                            Arsh79_logger("Army "..tostring(army_cqi).." has effect "..tostring(effect:key()).." with scope "..tostring(effect:scope()).." and value "..tostring(effect:value()).." from bundle "..tostring(current_bundle:key()))
                        end
                    end
                end
            end
        end
    end,
    true
)

core:add_listener(
    "DumpEffectsChar",
    "CharacterSelected",
    true,
    function(context)
        if context:character():has_military_force() then
            local army = context:character():military_force()
            local army_cqi = army:command_queue_index()
            local army_general_cqi = context:character():cqi()
            local faction_str = army:faction():name()
            Arsh79_logger("Army "..tostring(army_cqi).." from "..tostring(faction_str).." led by "..tostring(army_general_cqi))
            if not army:effect_bundles():is_empty() then
                for j = 0, army:effect_bundles():num_items() -1 do
                    local current_bundle = army:effect_bundles():item_at(j)
                    Arsh79_logger("Army "..tostring(army_cqi).." has effect_bundle "..tostring(current_bundle:key()))
                    if not current_bundle:effects():is_empty() then
                        local bundle_effects = current_bundle:effects()
                        for y = 0, bundle_effects:num_items() -1 do
                            local effect = bundle_effects:item_at(y)
                            Arsh79_logger("Army "..tostring(army_cqi).." has effect "..tostring(effect:key()).." with scope "..tostring(effect:scope()).." and value "..tostring(effect:value()).." from bundle "..tostring(current_bundle:key()))
                        end
                    end
                end
            end
        end
    end,
    true
)