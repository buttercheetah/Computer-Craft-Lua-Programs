local modem = peripheral.find("modem") or error("No modem attached", 0)
local sleeptimer = 60
function trans(floor)
    print("Transmitting floor " .. floor)
    modem.transmit(20, 21, floor)
end
function getside(z)
    if (z < 4883) then
        return 'Northmost'
    elseif (z > 4913) then
        return 'Southmost'
    else
        return 'Middle'
    end
end
while (1==1) do
    modem.open(21)
    local x, y, z = gps.locate(5)
    if (y >= 69) and (y <= 73) then
        trans('0 ' .. getside(z))
    elseif (y >= 74) and (y <= 79) then
        trans('1 ' .. getside(z))
    elseif (y >= 80) and (y <= 84) then
        trans('2 ' .. getside(z))
    elseif (y >= 85) and (y <= 89) then
        trans('3 ' .. getside(z))
    elseif (y >= 90) and (y <= 94) then
        trans('4 ' .. getside(z))
    elseif (y >= 95) and (y <= 99) then
        trans('5 ' .. getside(z))
    elseif (y >= 100) and (y <= 104) then
        trans('6 ' .. getside(z))
    elseif (y >= 105) and (y <= 109) then
        trans('7 ' .. getside(z))
    elseif (y >= 110) and (y <= 114) then
        trans('8 ' .. getside(z))
    elseif (y >= 115) and (y <= 119) then
        trans('9 ' .. getside(z))
    elseif (y >= 120) and (y <= 124) then
        trans('10 ' .. getside(z))
    elseif (y >= 125) and (y <= 129) then
        trans('11 ' .. getside(z))
    elseif (y >= 130) and (y <= 134) then
        trans('12 ' .. getside(z))
    elseif (y >= 135) and (y <= 139) then
        trans('13 ' .. getside(z))
    elseif (y >= 140) and (y <= 144) then
        trans('14 ' .. getside(z))
    elseif (y >= 145) and (y <= 149) then
        trans('15 ' .. getside(z))
    elseif (y >= 150) then
        trans('16 ' .. getside(z))
    else
        trans('Cheating ' .. getside(z))
    end
    local timeout = os.startTimer(sleeptimer)
    while true do
        osevent = {os.pullEvent()}
        --print(osevent[1] .. osevent[2])
        if osevent[1] == "key" then
            break
        elseif osevent[1] == "timer"  then
            if osevent[2] == timeout then
                break
             end  
        elseif osevent[1] == "modem_message" then
            print(osevent[3])
            if osevent[3] == 21 then
                print('Seeker on floor ' .. osevent[5])
            end
        end
    os.cancelTimer(timeout)
    end
end
