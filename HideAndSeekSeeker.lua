local modem = peripheral.find("modem") or error("No modem attached", 0)
while true do
	modem.open(20)  -- Open channel 3 so that we can listen on it
	local event, modemSide, senderChannel, replyChannel, message, senderDistance = os.pullEvent("modem_message")
	if (senderChannel == 20) then
		print("Theres someone of floor " .. message)		
	end
end