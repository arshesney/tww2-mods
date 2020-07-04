function Arsh79_logger(text)
	if not __write_output_to_logfile then
		return;
	end

	local log_text = tostring(text);
	local log_timestamp = os.date("%Y-%m-%d, %X");
	local log_file = io.open("arsh79_logs.txt", "a");
	log_file:write("[".. log_timestamp .."]: ".. log_text .."\n");
	log_file:flush()
	log_file:close()
end
