local function getuserbal (playername)
  local request = http.post("http://misc.iefi.xyz/minecraft/api/getbal/", playername)
  local body = request.readAll()
  return tonumber(body)
end
while (1 == 1) do
	local Login = "False"
	while (Login == "False") do
		shell.run("clear")
		print("Please enter the password")
		local password = read('*')
		local request = http.post("http://misc.iefi.xyz/minecraft/api/login/", tostring("admin|" .. password))
		local body = request.readAll()
		if (body == "True") then
			print("Login Succsesfull")
			os.sleep(1)
			Login = "True"
		else
			print("Password incorect")
			os.sleep(2)
		end
	end
	local username = nil
	while (Login == "True") do
		shell.run("clear")
		while (username == nil) do
			print("please input user's name")
			local attemptuser = read()
			cbal = getuserbal(attemptuser)
			if cbal == nil then
				print("user does not exist")
			else
				username = attemptuser
			end
		end
		cbal = getuserbal(username)
		print("Current balance: " .. cbal)
		print("1)deposit\n2)withdrawl\n3)Change user\n4)Logout")
		local choice = read()
		if choice == "1" then
			print("How much?")
			ammount = read()
			local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(username .. "|Deposit at Bank|" .. tonumber(ammount)))
			print(request.readAll())
		elseif choice == "2" then
			print("How much?")
			ammount = read()
			local request = http.post("http://misc.iefi.xyz/minecraft/api/applypurchase/", tostring(username .. "|Withdrawl at Bank|" .. -tonumber(ammount)))
			print(request.readAll())
		elseif choice == "3" then
			username = nil
		elseif choice == "4" then
			username = nil
			Login = "False"
		end
	end
end