local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(1) -- Open 15 so we can receive replies


local event, side, channel, replyChannel, message, distance
while true do
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    print("Received a reply: " .. tostring(message))
    if tostring(message) == "wifissidget" then
        modem.transmit(2, 1, "Car Dealership")
    end
end
print("Received a reply: " .. tostring(message))