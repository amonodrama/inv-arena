local screenX, screenY = guiGetScreenSize()

scoreboard = {}
scoreboard.fontHeight = dxGetFontHeight(1, "default-bold") + 10
scoreboard.sizeX = screenX * 0.6
scoreboard.sizeY = screenY * 0.95
scoreboard.renderTarget = dxCreateRenderTarget(scoreboard.sizeX, scoreboard.sizeY, true)
scoreboard.currentSizeY = 0
scoreboard.alpha = 0
scoreboard.tick = 0
scoreboard.scroll = 0
scoreboard.scrollToGo = 0
scoreboard.maximumScroll = 0
scoreboard.columns = {
{"Name", "name", 0.2},
{"Rank", "rank", 0.120},
{"Arena", "arena", 0.120},
{"Kills", "kills", 0.120},
{"K/D", "kd", 0.120},
{"Country", "country", 0.120},
{"FPS", "fps", 0.120},
{"Ping", "ping", 0.120},
}

function scoreboard.draw()
	local teams = {}
	local players = {}
	local offsetY = 0
	for index, team in pairs(getElementsByType("team")) do
		if not teams[team] then
			teams[team] = {}
			teams[team].name = getTeamName(team)
			teams[team].color = tocolor(getTeamColor(team))
			teams[team].players = {}
		end
	end
	for index, player in pairs(getElementsByType("player")) do
		local team = getPlayerTeam(player) or false
		if team and teams[team] then
			table.insert(teams[team].players, player)
		else
			table.insert(players, player)
		end
 	end
	scoreboard.teams = teams
	scoreboard.players = players
	if scoreboard.renderTarget then
		dxSetRenderTarget(scoreboard.renderTarget, true)
		dxDrawRectangle(0, 0, scoreboard.sizeX, scoreboard.sizeY, tocolor(20, 20, 20, 255))
		offsetY = scoreboard.fontHeight + 2
		offsetY = offsetY - scoreboard.scroll
		scoreboard.maximumScroll = 3
		local columnX = 0
		dxDrawRectangle(0, offsetY, scoreboard.sizeX, scoreboard.fontHeight, tocolor(20, 20, 20, 255))
		dxDrawRectangle(0, 0, scoreboard.sizeX, scoreboard.fontHeight * 2 + 2, tocolor(15, 15, 15, 255))
		for index, column in pairs(scoreboard.columns) do
			dxDrawBoundingText(column[1], columnX + 5, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight)
			columnX = columnX + scoreboard.sizeX * column[3]
		end
		offsetY = offsetY + scoreboard.fontHeight
		scoreboard.maximumScroll = scoreboard.maximumScroll + scoreboard.fontHeight
		for index, player in pairs(scoreboard.players) do
			columnX = 0
			if player == localPlayer then
				dxDrawRectangle(0, offsetY + 2, scoreboard.sizeX, scoreboard.fontHeight - 4, tocolor(45, 45, 45, 255))
			elseif player ~= localPlayer and getElementData(player, "arena") == getElementData(localPlayer, "arena") then
				dxDrawRectangle(0, offsetY + 2, scoreboard.sizeX, scoreboard.fontHeight - 4, tocolor(35, 35, 35, 255))
			end
			for index, column in pairs(scoreboard.columns) do
				if column[2] == "name" then
					dxDrawText(getPlayerName(player), columnX + 5, offsetY, scoreboard.sizeX, offsetY + scoreboard.fontHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", false, false, false, true)
				elseif column[2] == "ping" then
					local ping = getPlayerPing(player)
					dxDrawBoundingText(tostring(ping), columnX + 5, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight, tocolor(255, 255, 255, 255));
				elseif column [2] == "rank" then
					local rank = exports.inv_arena:getPlayerRank(player)
					dxDrawBoundingText(tostring(rank), columnX + 5, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight, tocolor(255, 255, 255, 255));
				elseif column [2] == "kd" then
					local kd = exports.inv_arena:getPlayerKD(player)
					dxDrawBoundingText(tostring(kd), columnX + 5, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight, tocolor(255, 255, 255, 255));	
				elseif column[2] == "country" and getElementData(player, "country") then
					if fileExists(":ip2c/client/images/flags/"..getElementData(player, "country")..".png") then
						dxDrawImage(columnX + 5, offsetY + (scoreboard.fontHeight)/2 - 5, 16, 11, ":ip2c/client/images/flags/"..getElementData(player, "country")..".png", 0, 0, 0, tocolor(255, 255,255,255))
						dxDrawBoundingText(string.upper(getElementData(player, "country")), columnX + 26, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight)
					else
						dxDrawBoundingText(string.upper(getElementData(player, "country")), columnX + 5, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight)
					end
				else
					dxDrawBoundingText(getElementData(player, column[2]) or "N/A", columnX + 5, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight)
				end
				columnX = columnX + scoreboard.sizeX * column[3]
			end
			offsetY = offsetY + scoreboard.fontHeight
			scoreboard.maximumScroll = scoreboard.maximumScroll + scoreboard.fontHeight
		end
		for index, team in pairs(teams) do
			dxDrawRectangle(0, offsetY, scoreboard.sizeX, scoreboard.fontHeight, tocolor(15, 15, 15, 255))
			dxDrawText(team.name, 5, offsetY, scoreboard.sizeX, offsetY + scoreboard.fontHeight, team.color, 1, "default-bold", "left", "center", false, false, false, true)
			offsetY = offsetY + scoreboard.fontHeight
			scoreboard.maximumScroll = scoreboard.maximumScroll + scoreboard.fontHeight
			for index, player in pairs(team.players) do
				columnX = 0
				if player == localPlayer then
					dxDrawRectangle(0, offsetY + 2, scoreboard.sizeX, scoreboard.fontHeight - 4, tocolor(45, 45, 45, 255))
				elseif player ~= localPlayer and getElementData(player, "training.map") == getElementData(localPlayer, "training.map") then
					dxDrawRectangle(0, offsetY + 2, scoreboard.sizeX, scoreboard.fontHeight - 4, tocolor(35, 35, 35, 255))
				end
				for index, column in pairs(scoreboard.columns) do
					if column[2] == "name" then
						dxDrawText(getPlayerName(player), columnX + 5, offsetY, scoreboard.sizeX, offsetY + scoreboard.fontHeight, team.color, 1, "default-bold", "left", "center", false, false, false, true)
					elseif column[2] == "ping" then
						local ping = getPlayerPing(player)
						dxDrawBoundingText(tostring(ping), columnX + 5, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight, tocolor(255, 255, 255, 255))
					elseif column [2] == "rank" then
						local rank = exports.inv_arena:getPlayerRank(player)
						dxDrawBoundingText(tostring(rank), columnX + 5, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight, tocolor(255, 255, 255, 255));
					elseif column [2] == "kd" then
						local kd = exports.inv_arena:getPlayerKD(player)
						dxDrawBoundingText(tostring(kd), columnX + 5, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight, tocolor(255, 255, 255, 255));						
					elseif column[2] == "country" and getElementData(player, "country") then
						if fileExists(":ip2c/client/images/flags/"..getElementData(player, "country")..".png") then
							dxDrawImage(columnX + 5, offsetY + (scoreboard.fontHeight)/2 - 5, 16, 11, ":ip2c/client/images/flags/"..getElementData(player, "country")..".png", 0, 0, 0, tocolor(255, 255,255,255))
							dxDrawBoundingText(string.upper(getElementData(player, "country")), columnX + 26, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight)
						else
							dxDrawBoundingText(string.upper(getElementData(player, "country")), columnX + 5, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight)
						end
					else
						dxDrawBoundingText(getElementData(player, column[2]) or "N/A", columnX + 5, offsetY, scoreboard.sizeX * column[3] - 5, scoreboard.fontHeight)
					end
					columnX = columnX + scoreboard.sizeX * column[3]
				end
				offsetY = offsetY + scoreboard.fontHeight
				scoreboard.maximumScroll = scoreboard.maximumScroll + scoreboard.fontHeight
			end
		end
		dxDrawRectangle(0, 0, scoreboard.sizeX, 1, tocolor(57, 57, 57, 255)) -- TOP
		dxDrawRectangle(0, scoreboard.fontHeight, scoreboard.sizeX, 1, tocolor(57, 57, 57, 255)) -- HEADER
		dxDrawRectangle(0, 0, 1, scoreboard.sizeY, tocolor(57, 57, 57, 255)) -- LEFT
		dxDrawRectangle(0, offsetY - 2, scoreboard.sizeX, 1, tocolor(57, 57, 57, 255)) -- BOTTOM
		dxDrawRectangle(scoreboard.sizeX - 1, 0, 1, scoreboard.sizeY, tocolor(57, 57, 57, 255)) -- LEFT
		dxDrawText("  Invictum PVP Academy 1.0", 6, 3, scoreboard.sizeX/2 + 1, scoreboard.fontHeight + 1, tocolor(0, 0, 0, 127), 1, "default-bold", "left", "center", false, false, false, true);
		dxDrawText(" #abadaaInvictum #ffffffPVP Academy #ff45001.0 - The best experience you will have.", 5, 2, scoreboard.sizeX/2, scoreboard.fontHeight, white, 1, "default-bold", "left", "center", false, false, false, true);
		dxDrawText("Players: "..#getElementsByType("player").." ", 0, 2, scoreboard.sizeX - 5, scoreboard.fontHeight, white, 1, "default-bold", "right", "center", false, false, false, true);
		scoreboard.maximumScroll = scoreboard.maximumScroll - scoreboard.sizeY + (scoreboard.fontHeight)
		dxSetBlendMode("blend")
		dxSetRenderTarget()
		dxDrawImageSection(screenX/2 - scoreboard.sizeX/2, screenY/2 - scoreboard.currentSizeY/2, scoreboard.sizeX, scoreboard.currentSizeY, 0, 0, scoreboard.sizeX, scoreboard.currentSizeY, scoreboard.renderTarget, 0, 0, 0, tocolor(255, 255, 255, scoreboard.alpha), true)
	end
	local startTick = getTickCount() - 500
	local now = getTickCount()
	local endTime = startTick + 5000
	local elapsedTime = now - startTick
	local duration = endTime - startTick
	local progress = elapsedTime/duration
	if getKeyState("tab") and not getElementData(localPlayer, "gui.visible") then
		scoreboard.currentSizeY = interpolateBetween(scoreboard.currentSizeY, 0, 0, math.min(offsetY, scoreboard.sizeY), 0, 0, progress, "OutQuad")
		scoreboard.alpha = interpolateBetween(scoreboard.alpha, 0, 0, 255, 0, 0, progress, "OutQuad")
		scoreboard.scroll = interpolateBetween(scoreboard.scroll, 0, 0, scoreboard.scrollToGo, 0, 0, progress, "Linear")
	else
		scoreboard.currentSizeY = interpolateBetween(scoreboard.currentSizeY, 0, 0, 0, 0, 0, progress, "OutQuad")
		scoreboard.alpha = interpolateBetween(scoreboard.alpha, 0, 0, 0, 0, 0, progress, "OutQuad")
		if scoreboard.alpha < 1 then
			removeEventHandler("onClientRender", root, scoreboard.draw)
		end
	end
end

bindKey("tab", "down", function()
	removeEventHandler("onClientRender", root, scoreboard.draw)
	addEventHandler("onClientRender", root, scoreboard.draw)
end)

function scrollScoreboard(side)
	if not getKeyState("tab") then
		return
	end
	if side == "up" then
		if scoreboard.scroll - scoreboard.fontHeight * 4 > 0 then
			scoreboard.scrollToGo = scoreboard.scroll - scoreboard.fontHeight * 4
		else
			scoreboard.scrollToGo = 0
		end
	elseif side == "down" then
		if scoreboard.maximumScroll > 0 then
			if scoreboard.scroll + scoreboard.fontHeight * 4 < scoreboard.maximumScroll then
				scoreboard.scrollToGo = scoreboard.scroll + scoreboard.fontHeight * 4
			else
				scoreboard.scrollToGo = scoreboard.maximumScroll
			end
		end
	end
end
bindKey("mouse_wheel_up", "both", function() scrollScoreboard("up") end)
bindKey("mouse_wheel_down", "both", function() scrollScoreboard("down") end)
bindKey("arrow_u", "both", function() scrollScoreboard("up") end)
bindKey("arrow_d", "both", function() scrollScoreboard("down") end)

function dxDrawBoundingText(text, x, y, w, h, color, align)
	if not text or not tonumber(x) or not tonumber(y) or not tonumber(w) or not tonumber(h) then
		return
	end
	if not color then
		color = tocolor(255, 255, 255, 255)
	end
	if not align then
		align = "left"
	end
	dxDrawText(text, x, y, x + w, y + h, color, 1, "default-bold", align, "center", true, false)
end

local startTick = false
local counter = 0
local currentTick = 0

addEventHandler("onClientRender",root, function()
	if not startTick then
		startTick = getTickCount()
	end
	counter = counter + 1
	currentTick = getTickCount()
	if currentTick - startTick >= 1000 then
		if getElementData(localPlayer, "fps") ~= counter then
			setElementData(localPlayer, "fps", counter)
		end
		counter = 0
		startTick = false
	end
end
)