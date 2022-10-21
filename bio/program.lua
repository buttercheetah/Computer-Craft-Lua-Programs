local function clear()
    shell.run("clear")
end
local function getuserbal(username,password)
    local request = http.post("http://misc.iefi.xyz/minecraft/api/getbal", tostring(username.."|"..password))
    local body = request.readAll()
    return tonumber(body)
end
local function createuser(ign,username,password)
    local request = http.post("http://misc.iefi.xyz/minecraft/api/createaccount", tostring(ign .. "|"..username.."|"..password))
    local body = request.readAll()
    return body
end
local function logintoaccount(username,password)
    local request = http.post("http://misc.iefi.xyz/minecraft/api/login", tostring(username.."|"..password))
    local body = request.readAll()
    if (body == "True") then
        body = true
    end
    if (body == "False") then
        body = false
    end
    return body
end
local function checkign(name)
    local request = http.post("http://misc.iefi.xyz/minecraft/api/checkandcorrectuser", tostring(name))
    local body = request.readAll()
    if (body == "False") then
        body = false
    end
    return body
end
local function printbanner()
    print("------------------")
    print("    Buttery OS    ")
    print("------------------")
    print("Brought to you by,")
    print("Butter Inc.")
    print("------------------")
end
local function printmostrecenttransactions(username,password)
    local request = http.post("http://misc.iefi.xyz/minecraft/api/gettransactions", tostring(username.."|"..password.."|2"))
    local body = request.readAll()
    print(body)
end
local function pushtransaction(username,password,ammount,desc)
    local request = http.post("http://misc.iefi.xyz/minecraft/api/inputtransaction", tostring(username.."|"..password.."|"..ammount.."|"..desc))
    local body = request.readAll()
    if (body == "True") then
        body = true
    end
    if (body == "False") then
        body = false
    end
    return body
end
local function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
local function createstore(username,password)
    clear()
    print("Enter new store name")
    local storename = read()
    print("Enter store Description")
    local storedescription = read()
    local topush = tostring(username.."|"..password.."|"..storename.."|"..storedescription)
    print(topush)
    local request = http.post("http://misc.iefi.xyz/minecraft/api/createstore", topush)
    local body = request.readAll()
    print(body)
    print("Press enter to go back")
    read()
end
local function getstorelist()
    local request = http.post("http://misc.iefi.xyz/minecraft/api/getshoplist", "e")
    local body = request.readAll()
    local shoplist = split(body,"|")
    return shoplist
end
local function orderfromstore(username,password,storename)
    clear()
    print("You are about to place an order for " .. storename)
    print("Enter [q] to stop/cancel or just enter to continue")
    local sui = read()
    if (sui == "q" or sui == "Q") then
        print("Canceling")
    else
        print("What would you like to order from " .. storename)
        local odesc = read()
        clear()
        print("You are about to place an order at " .. storename)
        print("with the instructions")
        print(odesc)
        print("Is this correct? [y/N]")
        local sui = read()
        if (sui == 'Y' or sui == "y") then
            local request = http.post("http://misc.iefi.xyz/minecraft/api/placeorderatstore", tostring(username.."|"..password.."|"..storename.."|"..odesc))
            local body = request.readAll()
            print(body)
            print("press enter to go back")
            read()
        else
            clear()
            print('Order has been canceled.\nPress enter to go back')
            read()
        end
    end
end
local function displaystoredata(username,password,storename)
    local run = true
    while (run == true) do
        clear()
        local request = http.post("http://misc.iefi.xyz/minecraft/api/getshopdetails", storename)
        local body = request.readAll()
        local shoplist = split(body,"|")
        print("Store Name " .. tostring(shoplist[2]))
        print("Owner " .. tostring(shoplist[1]))
        print("Store Description:")
        print(tostring(shoplist[3]))
        print("0) return")
        print("1) Place order at this store")
        local ui = read()
        if (ui == "0") then
            run = false
        elseif (ui == "1") then
            orderfromstore(username,password,storename)
        end
    end
end
local function storebrowser(username,password)
    shoplist = getstorelist()
    local run = true
    while (run == true) do
        clear()
        printbanner()
        print("0) return")
        for key, value in ipairs(shoplist) do
            print(key .. ") "..value)
        end
        local ui = read()
        if (ui == "0") then
            run = false 
        elseif (shoplist[tonumber(ui)] == nil) then
            clear()
            print(tostring(ui).." not an option\nPress enter to go back")
            read()
        else
            displaystoredata(username,password,shoplist[tonumber(ui)])
        end  
    end
end
local function getstorelist(username,password)
    local request = http.post("http://misc.iefi.xyz/minecraft/api/getshoplist", tostring(username.."|"..password))
    local body = request.readAll()
    local shoplist = split(body,"|")
    return shoplist
end
local function getownedstorelist(username,password)
    local request = http.post("http://misc.iefi.xyz/minecraft/api/getownedshoplist", tostring(username.."|"..password))
    local body = request.readAll()
    local shoplist = split(body,"|")
    return shoplist
end
local function displaystoredata(username,password,storename)
    local run = true
    while (run == true) do
        clear()
        local request = http.post("http://misc.iefi.xyz/minecraft/api/getshopdetails", storename)
        local body = request.readAll()
        local shoplist = split(body,"|")
        print("Store Name " .. tostring(shoplist[2]))
        print("Owner " .. tostring(shoplist[1]))
        print("Store Description:")
        print(tostring(shoplist[3]))
        print("0) return")
        print("1) Place order at this store")
        local ui = read()
        if (ui == "0") then
            run = false
        elseif (ui == "1") then
            orderfromstore(username,password,storename)
        end
    end
end
local function getorderfromownedstore(username,password)
    local run = true
    while (run == true) do
        clear()
        local request = http.post("http://misc.iefi.xyz/minecraft/api/getordersfromownedstore", username.."|"..password)
        local body = request.readAll()
        if (body == "No Orders") then
            print(body)
            print("Press enter to go back")
            read()
            run = false
            break
        end
        print(body)
        local orderlist = split(body,"|")
        clear()
        print("Order ID: "..orderlist[1])
        print("User: "..orderlist[2])
        print("Store: "..orderlist[4])
        print("Order Request: "..orderlist[3])
        print("0) return")
        print("1) Mark as finished")
        local ui = read()
        if (ui == "0") then
            run = false
            break
        elseif (ui == "1") then
            local request = http.post("http://misc.iefi.xyz/minecraft/api/changeorderstatus", username.."|"..password.."|"..orderlist[1].."|".."1")
            local body = request.readAll()
            print(body)
            os.sleep(2)
        end
    end
end
local function displayownedstoredata(username,password,storename)
    local run = true
    while (run == true) do
        clear()
        local request = http.post("http://misc.iefi.xyz/minecraft/api/getshopdetailsadvanced", storename)
        local body = request.readAll()
        local shoplist = split(body,"|")
        print("Store Name: " .. tostring(shoplist[2]))
        print("Open: " .. tostring(shoplist[1]))
        print("Store Description:")
        print(tostring(shoplist[3]))
        print("0) return")
        print("1) change store status (if it accepts online orders)")
        print("2) change description")
        local ui = read()
        if (ui == "0") then
            run = false
        elseif (ui == "1") then
            print("1) Closed") 
            print("2) Open")
            local ui = read()
            if (ui == "1" or ui == "2") then
                ui = (tonumber(ui)-1)
                local request = http.post("http://misc.iefi.xyz/minecraft/api/toggleopen", tostring(username.."|"..password.."|"..shoplist[2].."|"..ui))
                local body = request.readAll()
                print(body)
                os.sleep(1)
            end
        elseif (ui == "2") then
            print("Enter the new shop description")
            local ui = read()
            local request = http.post("http://misc.iefi.xyz/minecraft/api/changeshopdesc", tostring(username.."|"..password.."|"..shoplist[2].."|"..ui))
            local body = request.readAll()
            print(body)
            os.sleep(1)
        end
    end
end
local function manageownedstores(username,password)
    shoplist = getownedstorelist(username,password)
    local run = true
    while (run == true) do
        clear()
        printbanner()
        print("0) return")
        for key, value in ipairs(shoplist) do
            print(key .. ") "..value)
        end
        local ui = read()
        if (ui == "0") then
            run = false 
        elseif (shoplist[tonumber(ui)] == nil) then
            clear()
            print(tostring(ui).." not an option\nPress enter to go back")
            read()
        else
            displayownedstoredata(username,password,shoplist[tonumber(ui)])
        end  
    end
end
local function managestores(username,password)
    local run = true
    while (run == true) do
        clear()
        printbanner()
        print("0) return")
        print("1) Create store")
        print("2) Manage owned stores")
        print("3) check for new orders")
        local ui = read()
        if (ui == "0") then
            run = false
            break
        elseif (ui == "1") then
            createstore(username,password)
        elseif (ui == "2") then
            manageownedstores(username,password)
        elseif (ui == "3") then
            getorderfromownedstore(username,password)
        end
    end
end
local function storemenu(username,password)
    local run = true
    while (run == true) do
        clear()
        printbanner()
        print("0) return")
        print("1) Browse Stores")
        print("2) Manage Stores")
        local ui = read()
        if (ui == "1") then
            storebrowser(username,password)
        elseif (ui == "2") then
            managestores(username,password)
        elseif (ui == "0") then
            run = false
        end
    end
end
local function onlynum(positive)
    local isnum = false
    while (isnum == false) do
        local ui = read()
        ui = tonumber(ui)
        if (ui == nil) then
            print("That is not a number!")
        else
            if (positive==true) then
                if (ui > 0) then
                    isnum = true
                    return ui
                else
                    print("Number must be positive!")
                end
            else
                isnum = true
                return ui
            end
        end
    end
    return ui
end
local function transfermoney(username,password,ouser,ammount,note)
    local request = http.post("http://misc.iefi.xyz/minecraft/api/transferfunds", tostring(username.."|"..password.."|"..ouser.."|"..ammount.."|"..note))
    local body = request.readAll()
    return body
end
local function transfermoneyui(username,password)
    local run = true
    while (run == true) do
        clear()
        print("Please enter the IGN of the player you wish to transfer money to")
        print("Or enter [q] to cancel")
        local igntotransfer = read()
        if (igntotransfer == "q" or igntotransfer == "Q") then
            run = false
            break
        end
        igntotransfer = checkign(igntotransfer)
        if (igntotransfer == false) then
            print("User cannot be found")
            run = false
            break
        end
        print("How much would you like to transfer?")
        local ammount = onlynum(true)
        print("would you like to include a note?")
        local note = read()
        clear()
        print("Ammount: " .. tonumber(ammount))
        print("Recipient: " .. igntotransfer)
        print("Note: " .. note)
        print("Is this correct? [Y/n]")
        local ui = read()
        if (ui == "n" or ui == "N") then
            print("Transaction canceled")
            run = false
            break
        else
            print(transfermoney(username,password,igntotransfer,ammount,note))
            run = false
            break
        end
    end
    print("Press enter to continue")
    read()
end
local function mobilebanking(username,password)
    local run = true
    while (run == true) do
        clear()
        printbanner()
        print("Current Balance: "..getuserbal(username,password))
        print("0) go back")
        print("1) View recent transactions")
        print("2) Transfer money to another account")
        local ui = read()
        if (ui == "0") then
            run = false
        elseif (ui == "1") then
            clear()
            printmostrecenttransactions(username,password)
            print("Press enter to go back")
            read()
        elseif (ui == "2") then
            transfermoneyui(username,password)
        end
    end
end
local function submitticket(username,password)
    local run = true
    while (run == true) do
        clear()
        print("What kind of ticket would you like to open?")
        print("1) Software Bug")
        print("2) Software idea")
        local tkind = read()
        if (tkind == "1") then
            while (run == true) do
                print("What bug catagory?")
                print("1) Mobile banking")
                print("2) Login screen")
                print("3) Shop Browser")
                print("4) Shop Manager")
                print("5) Other")
                local bcat = read()
                if (bcat == "1" or bcat == "2" or bcat == "3" or bcat == "4" or bcat == "5") then
                    if (bcat == "1") then
                        bcat = "Mobile Banking"
                    elseif (bcat == "2") then
                        bcat = "Login Screen"
                    elseif (bcat == "3") then
                        bcat = "Shop Browser"
                    elseif (bcat == "4") then
                        bcat = "Shop Manager"
                    else
                        bcat = "Other"
                    end
                    print("Please describe the issue.")
                    local issuedesc = read()
                    -- Pickup here
                end
            end
        end
    end
end
local function techsupportmenu(username,password)
    local run = true
    while (run == true) do
        clear()
        print("Welcome to tech suppport. Here you can send a bug report, or suggest an idea!")
        print("0) go back")
        print("1) Submit a ticket")
        print("2) Check a ticket WIP")
        local ui = read()
        if (ui == "0") then
            run = false
            break
        elseif (ui == "1") then
            submitticket(username,password)
        elseif (ui == "2") then
            checkticket(username,password)
        end
    end
end
function update() 
    shell.run("rm startup")
    shell.run("wget https://github.com/buttercheetah/Computer-Craft-Lua-Programs/raw/main/bio/program.lua startup")
    shell.run("reboot")
end

local login = false
local run = true
while (login == false) do -- Login
    clear()
    printbanner()
    ign = ""
    print("Enter an option\n[L] to login.\n[c] to create an account\n[q] to quit\n[u] to update")
    local ui = read()
    if (ui == "q" or ui == "Q") then
        run = false
        break
    end
    if (ui == "u") then
        update()
    end 
    if (ui == "c" or ui == "C") then
        print("Please enter your ign as it is in game.")
        ign = read()
    end
    print("Please enter your username.")
    username = read()
    print("Please enter your password.")
    password = read('*')
    if (ui == "c" or ui == "C") then
        print(createuser(ign,username,password))
    end
    login = logintoaccount(username,password)
    if (login == false) then
        print("Inccorect credentials.\nPress enter to try again")
        read()
    end
end
while (run == true) do
    clear()
    printbanner()
    print("0) quit")
    print("1) Mobile Banking")
    print("2) Store Menu")
    print("9) Update")
    --print("3) Tech Support")
    local ui = read()
    if (ui=="1") then
        mobilebanking(username,password)
    elseif (ui == "2") then
        storemenu(username,password)
    --elseif (ui == "3") then
    --    techsupportmenu(username,password)
    elseif (ui == "0") then
        run = false
    elseif (ui == "9") then
        update()
    end 
end
shell.run("exit")
