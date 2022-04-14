local modem = peripheral.find("modem") or error("No modem attached", 0)
local osv = "1.0"
network = nil
tname = ""
function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
 end
function checkforupdate ()
  local request = http.get("http://misc.iefi.xyz/minecraft/pc/api/version/")
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
      clearscreen()
      print("select and option")
      print("1) Make new OS Current Version")
      print("2) Make new OS an input version")
      print("3) New Announcement")
      print("9) back")
      local choice = read()
      if (choice == "1") then
        local request = http.post("http://misc.iefi.xyz/minecraft/api/pc/setversion/", tostring(osv))
        local body = request.readAll()
        print(body)
        os.sleep(5)
      elseif (choice == "2") then
        print("current OS version:" .. osv)
        print("enter new OS version")
        local temp = read()
        local request = http.post("http://misc.iefi.xyz/minecraft/api/pc/setversion/", tostring(temp))
        local body = request.readAll()
      elseif (choice == "3") then
        print("enter new Announcement")
        local temp = read()
        local request = http.post("http://misc.iefi.xyz/minecraft/api/setanouncement/", tostring(temp))
        local body = request.readAll()
      elseif (choice == "9") then
        tmprun2 = "False"
      end
    end
end
function getandprintnetwork ()
	network = nil
	clearscreen()
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
function clearscreen()
    term.clear()                            -- Paint the entire display with the current background colour.
    term.setCursorPos(1,1)                  -- Move the cursor to the top left position.
end
runcheck = "True"
while (runcheck == "True") do
  getandprintnetwork()
  clearscreen()
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
    clearscreen()
    print("Welcome " .. tname)
    print("WiFi:" .. network)
    checkforupdate()
    getnewannouncements()
    print("1) App store")
    print("2) settings")
    if (file_exists(Gh2O) == true) then
        print("3) Gh2O game launcher")
    end
    if (file_exists(bbde) == true) then
        print("4) Butter Bank DE")
    end
    if (file_exists(cal) == true) then
        print("5) Calculator")
    end
    local usersel = read()
    if (usersel == "admin") then
        adminstuff()
    elseif (usersel == "1") then
        local tmprun = true
        while tmprun == true do
            clearscreen()
            print("Available Apps:")
            term.write("1) Gh2O game launcher - ")
            if (file_exists(Gh2O) == true) then
                print("Installed")
            else:
                print("Not installed")
            term.write("2) Butter Bank DE - ")
            if (file_exists(bbde) == true) then
                print("Installed")
            else:
                print("Not installed")
            term.write("3) Calculator - ")
            if (file_exists(cal) == true) then
                print("Installed")
            else:
                print("Not installed")
            print("9) close")
            choice = read()
            if (choice == '1') then
                if (file_exists(Gh2O) == true) then
                    print("Updating")
                    shell.run("rm Gh2O")
                end
                shell.run("wget link Gh2O")
            elseif (choice == '1') then
                if (file_exists(bbde) == true) then
                    print("Updating")
                    shell.run("rm bbde")
                end
                shell.run("wget https://github.com/buttercheetah/Computer-Craft-Lua-Programs/raw/main/PC/bbe.lua bbde")
            elseif (choice == '1') then
                if (file_exists(cal) == true) then
                    print("Updating")
                    shell.run("rm cal")
                end
                shell.run("wget link cal")
            elseif (choice == '9') then
                tmprun = false
            end
            os.sleep(2)
        end
    elseif (usersel == "2") then
        clearscreen()
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
            shell.run("rm startup")
            shell.run("wget https://github.com/buttercheetah/Computer-Craft-Lua-Programs/raw/main/PC/startup.lua startup")
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
    elseif (usersel == "3") and (file_exists(Gh2O) == true) then
        shell.run("Gh2O")
    elseif (usersel == "4") and (file_exists(bbde) == true) then
        shell.run("bbde")
    elseif (usersel == "5") and (file_exists(cal) == true) then
        shell.run("cal")
    end
end