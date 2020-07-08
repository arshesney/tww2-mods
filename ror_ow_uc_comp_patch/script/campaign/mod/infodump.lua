-- infodump
local function write_to_file(text)

    local dump_text = tostring(text);
	local dump_file = io.open("arsh79_infodump.txt", "a");
	dump_file:write(dump_text .."\n");
	dump_file:flush()
	dump_file:close()
end

local function dump_faction_info(faction)
    write_to_file("Faction: "..faction:name());
    write_to_file("CQI: "..tostring(faction:command_queue_index()))
    write_to_file("Culture: "..faction:culture());
    write_to_file("Subculture: "..faction:subculture());
    write_to_file("---")
end

core:add_listener(
    "infodump_listener",
    "CharacterSelected",
    true,
    function(context)
        write_to_file("Character: "..context:character():get_forename().." "..context:character():get_surname());
        dump_faction_info(context:character():faction())
    end,
    true
)