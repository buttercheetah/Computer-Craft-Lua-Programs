local speaker = peripheral.find("speaker")
local modem = peripheral.find("modem") or error("No modem attached", 0)
local printer = peripheral.find("printer")
local receivebankaccount = ""
local storename = ""
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
network = nil
function getandprintnetwork () -- Function to require 'wifi' comment out function call below to ignore
	network = nil
	shell.run("clear")
	print("Attempting to connect")
	while network == nil do
		modem.open(2) -- Open 43 so we can receive replies
		modem.transmit(1, 2, "wifissidget")
		local event, side, channel, replyChannel, distance
		local timeout = os.startTimer(5)
		while true do
			osevent = {os.pullEvent()}
			if osevent[1] == "modem_message" then
				local channel = osevent[3]
				local replychannel = osevent[5]
				network = osevent[5]
				local distance = osevent[6]
				print(distance)  
				if channel == 2 then
					print(tostring(network))
					break
				end
			elseif osevent[1] == "timer"  then
				break
			end
		end
		if network == nil then
			print("No network found. retrying in 5 seconds")
			os.sleep(5)
		end
	end
end
function cardread()
	local name = nil
	while (name == nil) do
		os.sleep(1)
		if (file_exists('/disk/name.lua')) then
			local h = fs.open("/disk/name.lua", "r")
			name = h.readLine()
			print("Please take out card")
			while (file_exists('/disk/name.lua')) do
				speaker.playSound("minecraft:block.note_block.harp")
				os.sleep(0.2)
			end
		end
	 
	end
	return name
end
function printergodown()
	local xp, yp = printer.getCursorPos()
	printer.setCursorPos(1, tonumber(yp + 1))
end
while (1==1) do
	if (receivebankaccount == "") or (storename == "") then
		print("ERROR! Variables not set!")
		break
	end
	getandprintnetwork()  -- 'wifi' function call
	local total = 0
	printer.newPage()
	while (1==1) do
		shell.run("clear")
		if (printer.getInkLevel() < 10) then
			print("Ink Low")
		elseif (printer.getPaperLevel() < 10) then
			print("Paper Low")
		end
		print("Running total - " .. total)
		print("input item name\nEnter [END] to stop")
		local name = read()
		if name == "END" then
			print("Card?\nY/n")
			local choice = read()
			if (choice == "N") or (choice == "n") then
				shell.run("clear")
				print("Total " .. total)
				printer.write("Total:" .. tostring(tonumber(total)) .. "\n")
				printergodown()
				printer.write("Paid by cash" .. "\n")
				print("Paid by cash")
				os.sleep(2)
			else
				printer.write("subtotal:" .. total .. "\n")
				printergodown()
				printer.write("Tax:" .. tostring(tonumber(total * 0.01)) .. "\n")
				printergodown()
				printer.write("Total:" .. tostring(tonumber(total + (total * 0.01))) .. "\n")
				printergodown()
				shell.run("clear")
				print("Total " .. tostring(tonumber(total + (total * 0.01))))
				print("please enter your card")
				local buyername = cardread()
				local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(buyername .. "|Purchase at " .. storename .. "|" .. -tonumber(total + (total * 0.01))))
				os.sleep(4)
				print("Communicating")
				local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring("buttercheetah|Tax from " .. storename .. "|" .. tonumber(total * 0.01)))
				os.sleep(4)
				print("Validating")
				local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(receivebankaccount .. "|Purchase from " .. storename .. "|" .. tonumber(total)))
				printer.write("Paid by card" .. "\n")
				print("Paid by card")
				os.sleep(2)
			end
			printer.setPageTitle(storename .. " Recipt")
			printer.endPage()
			break
		else
			print("Please input the item price")
			local price = read()
			total = total + tonumber(price)
			printer.write(price .. " - " .. name .. "\n")
		end
	printergodown()
	end
end


