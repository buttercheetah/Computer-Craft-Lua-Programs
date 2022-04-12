local modem = peripheral.find("modem") or error("No modem attached", 0)
local sleeptimer = 300
function trans(floor)
    print("Transmitting floor " .. floor)
    modem.transmit(20, 21, floor)
end
while (1==1) do
    local x, y, z = gps.locate(5)
    if (y >= 69) and (y <= 73) then
        trans('0')
    elseif (y >= 74) and (y <= 79) then
        trans('1')
    elseif (y >= 80) and (y <= 84) then
        trans('2')
    elseif (y >= 85) and (y <= 89) then
        trans('3')
    elseif (y >= 90) and (y <= 94) then
        trans('4')
    elseif (y >= 95) and (y <= 99) then
        trans('5')
    elseif (y >= 100) and (y <= 104) then
        trans('6')
    elseif (y >= 105) and (y <= 109) then
        trans('7')
    elseif (y >= 110) and (y <= 114) then
        trans('8')
    elseif (y >= 115) and (y <= 119) then
        trans('9')
    elseif (y >= 120) and (y <= 124) then
        trans('10')
    elseif (y >= 125) and (y <= 129) then
        trans('11')
    elseif (y >= 130) and (y <= 134) then
        trans('12')
    elseif (y >= 135) and (y <= 139) then
        trans('13')
    elseif (y >= 140) and (y <= 144) then
        trans('14')
    elseif (y >= 145) and (y <= 149) then
        trans('15')
    elseif (y >= 150) then
        trans('16')
    else
        trans('Cheating')
    end
    local timeout = os.startTimer(sleeptimer)
	while true do
		osevent = {os.pullEvent()}
		if osevent[1] == "key" then
			break
		elseif osevent[1] == "timer"  then
			break
		end
end
    
    