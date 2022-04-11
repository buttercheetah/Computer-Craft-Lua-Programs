local speaker = peripheral.find("speaker")
local printer = peripheral.find("printer")
local receivebankaccount = ""
local storename = ""
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
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
		print("input item price\nEnter [69.420] to stop")
		local price = read()
		if price == "69.420" then
			print("Card?\nY/n")
			local choice = read()
			if (choice == "N") or (choice == "n") then
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
				print("please enter your card")
				local buyername = cardread()
				local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(buyername .. "|Purchase at " .. storename .. "|" .. -tonumber(total + (total * 0.01))))
				os.sleep(1)
				local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring("buttercheetah|Tax from " .. storename .. "|" .. tonumber(total * 0.01)))
				os.sleep(1)
				local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(receivebankaccount .. "|Purchase from " .. storename .. "|" .. tonumber(total)))
				printer.write("Paid by card" .. "\n")
				print("Paid by card")
				os.sleep(2)
			end
			printer.setPageTitle(storename .. " Recipt")
			printer.endPage()
			break
		else
			print("input item name")
			local name = read()
			total = total + tonumber(price)
			printer.write(price .. " - " .. name .. "\n")
		end
	printergodown()
	end
end


