local modem = peripheral.find("modem") or error("No modem attached", 0)

local osv = "1.1"
function checkforupdate ()
  local request = http.get("http://misc.iefi.xyz/minecraft/api/version/")
  local body = request.readAll()
  if (body == osv) then
    print("OS is up to date")
  else
    print("update available")
  end
end
function getnewannouncements ()
  local request = http.get("http://misc.iefi.xyz/minecraft/api/anouncement/")
  local body = request.readAll()
  if (body == "") then
    io.write()
  else
    print(body)
  end
end
function adminstuff ()
  tmprun2 = "True"
  while (tmprun2 == "True") do
    shell.run("clear")
    print("select and option")
    print("1) Make new OS Current Version")
    print("2) Make new OS an input version")
    print("3) New Announcement")
	print("4) New user")
    print("5) back")
    local choice = read()
    if (choice == "1") then
      local request = http.post("http://misc.iefi.xyz/minecraft/api/setversion/", tostring(osv))
      local body = request.readAll()
      print(body)
      os.sleep(5)
    elseif (choice == "2") then
      print("current OS version:" .. osv)
      print("enter new OS version")
      local temp = read()
      local request = http.post("http://misc.iefi.xyz/minecraft/api/setversion/", tostring(temp))
      local body = request.readAll()
    elseif (choice == "3") then
      print("enter new Announcement")
      local temp = read()
      local request = http.post("http://misc.iefi.xyz/minecraft/api/setanouncement/", tostring(temp))
      local body = request.readAll()
    elseif (choice == "4") then
      print("enter new user's IGN")
      local temp = read()
      local request = http.post("http://misc.iefi.xyz/minecraft/api/newuser/", tostring(temp))
      print(request.readAll())
	  os.sleep(2)
	  local request = http.post("http://misc.iefi.xyz/minecraft/api/createuser/", tostring(temp))
      print(request.readAll())
	  os.sleep(2)
	  local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(temp .. "|Opened Account|0"))
      local body = request.readAll()
	  os.sleep(2)
    elseif (choice == "5") then
      tmprun2 = "False"
    end
  end
end
network = nil
function getandprintnetwork ()
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
local tname = ""
runcheck = "True"
while (runcheck == "True") do
  getandprintnetwork()
  shell.run("clear")
  print("WiFi:" .. network)
  print("Welcome!")
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

end
while (1 == 1) do
  getandprintnetwork()
  shell.run("clear")
  print("Welcome " .. tname)
  print("WiFi:" .. network)
  checkforupdate()
  getnewannouncements()
  print("1) Shops (WIP)")
  print("2) Mobile Banking")
  print("3) settings")
  local usersel = read()
  if (usersel == "admin") then
    adminstuff()
  elseif (usersel == "1") then
    local tmprun4 = "True"
    while (tmprun4 == "True") do
      shell.run("clear")
      print("Welcome " .. tname)
      print("9) back")
      local choice = read()
      if (choice == "9") then
        tmprun4 = "False"
      end
    end
  elseif (usersel == "2") then 
    local function getuserbal ()
      local request = http.post("http://misc.iefi.xyz/minecraft/api/getbal/", tname)
      local body = request.readAll()
      return tonumber(body)
    end
    local tmprun2 = "True"
    while (tmprun2 == "True") do
      local cbal = getuserbal()
      shell.run("clear")
      print("Account balance: " .. tostring(cbal))
      print("1) Send money to another account")
      print("2) return")
      local choice = read()
      if (choice == "1") then
        if (cbal > tonumber(0)) then
          print("Please input name of other account!")
          local oac = read()
          print("Please Input amount to transfer!\nNOTE:ONLY ENTER NUMBERS! If letters are written, many things may break.")
          local transfer = read()
          local request = http.put("http://misc.iefi.xyz/minecraft/api/getbal/", oac)
          local body = request.readAll()
          if (body == "False") then
            print("Error: user doesnt exist")
            os.sleep(2)
          else
            local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(tname .. "|Balance Transfer to " .. oac .. "|" .. -tonumber(transfer)))
            local body = request.readAll()
            local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(oac .. "|Balance Transfer from" .. tname .. "|" .. tonumber(transfer)))
            local body = request.readAll()
          end
        else
          print("Your balance is in the negative!")
          os.sleep(5)
        end
      elseif (choice == "2") then
        tmprun2 = "False"
      end
    end
  elseif (usersel == "3") then 
    shell.run("clear")
	local request = http.get("http://misc.iefi.xyz/minecraft/api/version/")
	local body = request.readAll()
	if (body == osv) then
		print("OS is up to date")
	else
		print("Current OS:" .. osv .. "\nAvailable OS:" .. body)
	end
    print("\n1)update OS\n2)Reboot\n3)Shutdown\n4)Change password\n5)Back")
    local usersel2 = read()
    if (usersel2 == "1") then
		shell.run("rm tabletos")
        shell.run("wget https://raw.githubusercontent.com/buttercheetah/Computer-Craft-Lua-Programs/main/Tablet.lua tabletos")
        shell.run("reboot")
    elseif (usersel2 == "2") then
        shell.run("reboot")
    elseif (usersel2 == "3") then
        shell.run("shutdown")
	elseif (usersel2 == "4") then
		print("Please input old password")
        local oldpass = read()
		print("Please input new password")
		local newpass = read()
		local request = http.post("http://misc.iefi.xyz/minecraft/api/clogin/", tostring(tname .. "|" .. oldpass .. "|" .. newpass))
		print(request.readAll())
		os.sleep(3)
    end
  end
end