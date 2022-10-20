function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
local request = http.post("http://misc.iefi.xyz/minecraft/api/gettransactions", tostring("bhghdhfh|2004noah|10"))
local body = request.readAll()
print(body)
