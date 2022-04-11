local modem = peripheral.find("modem") or error("No modem attached", 0)
while (1 == 1) do
	print("please input screen number\nAlternatively, enter [reset] to set all scores to 0")
	local screen = read()
	if screen == "reset" then
		modem.transmit(10, 11, tostring("resetall"))
	else
		print("please input new score")
		local score = read()
		modem.transmit(10, 11, tostring(screen .. "|" .. score))
	end
end