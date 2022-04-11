local h = fs.open("/disk/name.lua", "w") 
print("Input players name")
h.write(read()) -- completely insecure and easily ahcked... in all honesty, i dont care