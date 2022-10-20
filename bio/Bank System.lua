local run = true
while (run == true) do
	print("0) close")
	print("1) deposit")
	print("2) withdraw")
	local ui = read()
	if (ui == "0") then
		run = false
		break
	elseif (ui == "1" or ui == "2") then
		print("enter ign")
		local username = read()
		print("enter ammount")
		local amount = read()
		local tr = "Deposit"
		if (ui == "1") then
			local tr = "Deposit"
			print(username .. tr .. amount)
		else
			local tr = "Withdraw"
			print(username .. tr .. amount)
			amount = ammount*(-1)
		end
		print("is this correct? [Y/n]")
		local ver = read()
		if (ver == "N" or ver == "n") then
			break
		end
		local request = http.post("http://misc.iefi.xyz/minecraft/api/getbal/", playername)
		local body = request.readAll()
		return tonumber(body)
	end
end
