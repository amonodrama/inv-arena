function saveCrosshair(player, id)
	local acc = getPlayerAccount(player)
	setAccountData(acc, "crosshair", id)
end
addEvent("saveCrosshair", true)
addEventHandler("saveCrosshair", resourceRoot, saveCrosshair)