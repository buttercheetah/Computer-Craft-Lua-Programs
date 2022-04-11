local modem = peripheral.find("modem") or error("No modem attached", 0)
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
while true do
	modem.open(4)  -- Open channel 3 so that we can listen on it
	local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
	if (senderChannel == 4) then
		local res = split(message, "|")
		print(res[1] .. " withdrew ".. tostring(res[2]))
		exec("/give " .. res[1] .. " emerald " .. tostring(res[2]))
	end
end