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
while (1==1) do
	local total = 0
	printer.newPage()
	printersetPageTitle(storename .. " Recipt")
	if (printer.getInkLevel() < 10) then
		print("Ink Low")
	elseif (printer.getPaperLevel() < 10) then
		print("Paper Low")
	end
	while (1==1) do
		print("input item price\nEnter [69.420] to stop")
		local price = read()
		if price == "69.420" then
			printer.write("subtotal:" .. total)
			printer.write("Tax:" .. tostring(tonumber(total * 0.01)))
			printer.write("Total:" .. tostring(tonumber(total + (total * 0.01))))
			print("Card?\nY/n")
			local choice = read()
			if (choice == "N") or (choice == "N") then
				printer.write("Paid by cash")
			else
				print("please enter your card")
				local buyername = cardread()
				local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(buyername .. "|Purchase at " .. storename .. "|" .. -tonumber(total + (total * 0.01))))
				os.sleep(1)
				local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring("buttercheetah|Tax from " .. storename .. "|" .. tonumber(total * 0.01)))
				os.sleep(1)
				local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(receivebankaccount .. "|Purchase from " .. storename .. "|" .. tonumber(total)))
				printer.write("Paid by card")
				printer.endPage()
			end
			break
		else
			print("input item name")
			local name = read()
			total = total + tonumber(price)
			printer.write(price .. " - " .. name)
		end
	end
end


