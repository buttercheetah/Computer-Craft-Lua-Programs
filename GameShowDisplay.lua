local modem = peripheral.find("modem") or error("No modem attached", 0)
local cname = "c1"
monitor.setTextScale(5)
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
while true do
	modem.open(10)  -- Open channel 3 so that we can listen on it
	local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
	if (senderChannel == 10) then
		local res = split(message, "|")
		if res[1] == cname then
			monitor.clear()
			monitor.write(res[2])
		end
		
	end
end