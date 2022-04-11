local modem = peripheral.find("modem") or error("No modem attached", 0)
while True do
	print("please inpuut screen number")
	local screen = read()
	print("please input new score")
	local score = read()
	modem.transmit(10, 11, tostring(screen .. "|" .. score))
end