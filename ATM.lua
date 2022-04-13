local modem = peripheral.find("modem") or error("No modem attached", 0)
local atmn = 0003
local tname = ""
local function getuserbal(name)
    print("name "..name)
  local request = http.post("http://misc.iefi.xyz/minecraft/api/getbal/", tostring(name))
  local body = request.readAll()
  return tonumber(body)
end
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
				--speaker.playSound("minecraft:block.note_block.harp")
				os.sleep(0.2)
			end
		end
	 
	end
	return name
end
function adminstuff ()
  tmprun2 = "True"
  while (tmprun2 == "True") do
    shell.run("clear")
    print("select and option")
    print("1) update")
    print("9) back")
    local choice = read()
    if (choice == "1") then
		shell.run("rm atm")
        shell.run("wget https://github.com/buttercheetah/Computer-Craft-Lua-Programs/raw/main/ATM.lua atm")
        shell.run("reboot")
    elseif (choice == "5") then
      tmprun2 = "False"
    end
  end
end
function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
function recenttransacton(name, amount)
	local request = http.post("http://misc.iefi.xyz/minecraft/api/getbalhistory/", name .. "|" .. amount)
	local body = request.readAll()
	if amount == 1 then
		body = string.gsub(body, "%)", "")
	else
		body = string.gsub(body, "%) ", "\n")
    	body = string.gsub(body, "%)", "\n")
	end
	return body
end
while (1 == 1) do
	runcheck = "True"
	while (runcheck == "True") do
		shell.run("clear")
		print("Welcome to ATM #" .. atmn)
		print("Would you like to use your card?\nY/n")
		local option = read()
		if (option == "n") or (option == "N") then
			print("Please enter your username")
			local username = read()
			print("Please enter your password")
			local password = read('*')
			local request = http.post("http://misc.iefi.xyz/minecraft/api/login/", tostring(username .. "|" .. password))
			local body = request.readAll()
			if (body == "True") then
				print("Login Succsesfull")
				os.sleep(1)
				tname = username
				runcheck = "False"
			else
				print("User doesnt exist\nor password incorect")
				os.sleep(2)
			end
		else
			print("If you do not wish to use a card, please power cycle the atm")
			local username = cardread()
   local cbal = nil
			cbal = getuserbal(username)
   print(username)
   print(cbal)
			if cbal == nil then
				print("user does not exist")
			else
				tname = username
    runcheck = 'False'
			end
		end
	end
	runss = "True"
	while (runss == "True") do
		local cbal = getuserbal(tname)
		shell.run("clear")
		print("Welcome ".. tname .." to ATM #" .. atmn)
		print("Account balance: " .. tostring(cbal))
		print("Most recent transaction:\n" .. tostring(recenttransacton(tname, 1)))
		print("1)Deposit\n2)Withdraw\n3)Print recent transactions\n9)close")
		local usersel = read()
		if (usersel == "admin") then
			adminstuff()
		elseif (usersel == "1") then
			print("wip")
			os.sleep(2)
		elseif (usersel == "2") then
			print("how many?")
			local ammount = read()
			modem.transmit(4, 3, tostring(tname .. "|" .. ammount))
			local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(tname .. "|ATM withdraw at ATM #" .. atmn .. "|" .. -tonumber(ammount)))
			print("Withdrawing " .. ammount .. " emeralds")
			os.sleep(2)
		elseif (usersel == "3") then
			shell.run("clear")
			print("Most recent transactions (latest first)")
			print(tostring(recenttransacton(tname, 10)))
			print("press enter to go back")
			read()
		elseif (usersel == "9") then
			break
		end
	end
end
