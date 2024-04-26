local ranks = {
	[20] = "Newbie",
	[50] = "Rookie",
	[100] = "Decent"
}

function getPlayerRank(player)
	local kills = tonumber(getElementData(player, "kills"))
	local myrank = "Pathetic"
	if kills then
		for i, v in pairs(ranks) do
			if kills > i and kills < i*2 then
				myrank = ranks[i]
				break
			else
				myrank = "Pathetic"
			end
		end
	end 
	return myrank
end

function getPlayerKD(player)
	local kills = getElementData(player, "kills")
	local deaths = getElementData(player, "deaths")
	if kills and deaths then
		local kd = (kills/deaths)
		kd = tostring(kd)
		if string.len(kd) > 5 then
			kd = kd:sub( 1, #kd - 3 ) 
		end
		return kd
	else
		return "?"
	end
end





