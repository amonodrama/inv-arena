function updatePlayerCountry(player)
	if player then
		if exports.ip2c:getPlayerCountry(player) then
			setElementData(player, "country", string.lower(exports.ip2c:getPlayerCountry(player)))
		end
	end
end

for index, player in pairs(getElementsByType("player")) do
	updatePlayerCountry(player)
end

addEventHandler("onPlayerJoin", root,
function()
	updatePlayerCountry(source)
end)