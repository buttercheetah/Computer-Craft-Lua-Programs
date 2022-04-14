function clearscreen()
    term.clear()                            -- Paint the entire display with the current background colour.
    term.setCursorPos(1,1)                  -- Move the cursor to the top left position.
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
function getuserbal ()
    local request = http.post("http://misc.iefi.xyz/minecraft/api/getbal/", tname)
    local body = request.readAll()
    return tonumber(body)
end
local tmprun2 = "True"
while (tmprun2 == "True") do
    local cbal = getuserbal()
    clearscreen()
    print("Account balance: " .. tostring(cbal))
    print("1) Send money")
    print("2) See recent transactions")
    print("3) return")
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
        local request = http.put("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(tname .. "|Balance Transfer to " .. oac .. "|" .. -tonumber(transfer)))
        local body = request.readAll()
        local request = http.put("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(oac .. "|Balance Transfer from" .. tname .. "|" .. tonumber(transfer)))
        local body = request.readAll()
        end
    else
        print("Your balance is in the negative!")
        os.sleep(5)
    end
    elseif (choice == "2") then
    print(tostring(recenttransacton(tname, 4)) .. "\nPress enter to go back")
    read()
    elseif (choice == "3") then
    tmprun2 = "False"
    end
end