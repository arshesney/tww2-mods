-- infodump
local function write_to_file(text)

    local dump_text = tostring(text);
	local dump_file = io.open("arsh79_infodump.txt", "a");
	dump_file:write(dump_text .."\n");
	dump_file:flush()
	dump_file:close()
end

core:add_listener(
    "infodump_listener",
    "FactionTurnStart",
    function(context) return context:faction():is_human() end,
    function(context)
        write_to_file("Faction: "..context:faction():name());
        write_to_file(tostring(context:faction()))
    end,
    true
)