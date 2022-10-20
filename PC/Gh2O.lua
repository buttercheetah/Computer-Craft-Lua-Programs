function clearscreen()
    term.clear()                            -- Paint the entire display with the current background colour.
    term.setCursorPos(1,1)                  -- Move the cursor to the top left position.
end
function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end
function getnewannouncements ()
    local request = http.get("http://misc.iefi.xyz/minecraft/api/pc/gh/advertisement/")
    local body = request.readAll()
    if (body == "") then
      io.write()
    else
      print(body)
    end
end
function checkifgameowned(game, pname)
    io.write()
    --do a http reuest to see if the player ownes the game... retunr true if so
end
function getplayername()
    local h = fs.open("pname", "r")
    name = h.readLine()
	return name
end
function printgamedesc(game)
    if (game == "doom") then
        print("Interface : 3D")
        print("Develooper: Xelostar")
        print("Publisher: c3n")
        print("Game Description:")
        print("Doom is a 1993 first-person shooter (FPS) game developed by id Software for MS-DOS. Players assume the role of a space marine, popularly known as Doomguy, fighting their way through hordes of invading demons from hell.") -- got from wikipedia like the lazy potato i am
    elseif game == 
    
    end 
end
pname = getplayername()
local tmprun = true
while tmprun == true do
    clearscreen()
    print("Available Games:")
    term.write("1) Doom")
    if (file_exists(doom) == true) then
        print("Installed")
    else
        if checkifgameowned("doom", pname) then
            print("Not installed")
        else
            print("Not owned")
    term.write("2) Butter Bank DE - ")
    if (file_exists(bbde) == true) then
        print("Installed")
    else
        print("Not installed")
    term.write("3) Calculator - ")
    if (file_exists(cal) == true) then
        print("Installed")
    else
        print("Not installed")
    print("9) close")
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