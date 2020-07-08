local function is_faction_valid(faction_str)

    local exclude_factions_list = {
        [0] = "cst_rogue",
        [1] = "qb",
        [2] = "defenders",
        [3] = "chs",
        [4] = "rebel",
        [5] = "waaagh",
    }

    for _,v in ipairs(exclude_factions_list) do
        if string.find(faction_str, v) then
            return false;
        else
            return true;
        end
    end
end

core:add_listener(
	"ai_vs_ai_war_declare_roll",
	"FactionTurnStart",
	true,
    function(context)
        
	local faction = context:faction()
    local faction_str = faction:name()
    
    if not faction:is_human() and is_faction_valid(faction_str) then

        local factions_list = cm:model():world():faction_list();
        
            for i = 0, factions_list:num_items() - 1 do
                
			local current_faction = factions_list:item_at(i);
            local current_faction_str = current_faction:name();
            
                if not current_faction:is_human() and not faction:at_war_with(current_faction) then
                    
                    local war_roll = -(math.random(199,1000))
                    local opinion = faction:diplomatic_attitude_towards(current_faction_str)
                    if opinion < war_roll then
                        Arsh79_logger("Rolled "..tostring(war_roll).." with "..tostring(opinion).." opinion, war declared")
                        cm:force_declare_war(current_faction_str, faction_str, true, true)
                    end
				end
			end
		end
	end,
	true
);