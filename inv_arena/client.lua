
local leavepos = "-2423.22144, -608.90436, 132.56250"

local arenas = { 
[1] = { ["arenaname"] = "DEAGLE",
	["entermarker"] = "3409.95410, -2088.34106, 78.26875",
	["weapons"] = "0,24"
},
[2] = { ["arenaname"] = "M4",
	["entermarker"] = "3410.16016, -2111.29590, 78.26875",
	["weapons"] = "0,31"

}
}

local markers = {}
local insideArena = false

function createArenas()
	for i, v in pairs(arenas) do
		local x, y, z = gettok(v.entermarker, 1, ","), gettok(v.entermarker, 2, ","), gettok(v.entermarker, 3, ",")
		local enterMarker = createMarker(x, y, z-1, "cylinder", 1.5, 255, 255, 0, 170)
		setElementData(enterMarker, "dimension", i)
		markers[v.arenaname] = enterMarker
	end
	print(getResourceName(resource).." started. All arenas created.")
	addEventHandler("onClientRender", root, renderTexts)
end
addEventHandler("onClientResourceStart", resourceRoot, createArenas)

function renderTexts()
	for i, v in pairs(markers) do
		dxDrawTextOnElement(v, i, 3, 100, 255, 255, 255, 255, 4, "default-bold")
	end
end

function handleEntry(player)
	local dimension = getElementData(source, "dimension")
	if dimension then
		if not insideInterior then
			triggerServerEvent("handleArena", resourceRoot, player, dimension, arenas[dimension].weapons)
			insideArena = true
			setElementData(player, "arena", arenas[dimension].arenaname)
		end
	end
end
addEventHandler("onClientMarkerHit", root, handleEntry)

function handleLeave()
	if insideArena then
		triggerServerEvent("handleArena", root, localPlayer, 0)
		insideArena = false
		setElementData(localPlayer, "arena", "LOBBY")
	end
end
addCommandHandler("leave", handleLeave)


local screenW, screenH = guiGetScreenSize()
local positions = {}
positions.headshotX, positions.headshotY = (screenW-100)/2, (screenH-1000)/2
positions.attackX, positions.attackY = (screenW-400)/2, (screenH-400)/2
positions.attackedX, positions.attackedY = (screenW+400)/2, (screenH-400)/2
local alpha = 0

local showHeadshot = false
function gotHeadshot()
	if showHeadshot then
		showHeadshot = false
		removeEventHandler("onClientRender", root, renderHeadshot)
	else
			showHeadshot = true
			addEventHandler("onClientRender", root, renderHeadshot)
			setTimer ( function()
				showHeadshot = false
				removeEventHandler("onClientRender", root, renderHeadshot)
		end, 6000, 1 )
	end
end
addEvent("gotHeadshot", true)
addEventHandler("gotHeadshot", root, gotHeadshot)

function renderHeadshot()
	if showHeadshot then
		alpha = math.max(alpha + 2, 255)
	end
	if alpha > 0 then
		dxDrawText("Headshot", positions.headshotX-1, positions.headshotY-1, positions.headshotX, positions.headshotY, tocolor(0,0,0,alpha), 2, "unifont")
		dxDrawText("Headshot", positions.headshotX, positions.headshotY, positions.headshotX, positions.headshotY, tocolor(255,255,255,alpha), 2, "unifont")
	end
end


local damageTable = {
["attacked"] = {},
["attack"] = {}
}

local showDamage = false
function gotDamaged(damage, state)
	showDamage = true
	table.insert(damageTable[state], damage)
	addEventHandler("onClientRender", root, renderDamage)
 	setTimer(function()
 		showDamage = false
 		removeEventHandler("onClientRender", root, renderDamage)
 		 damageTable = {
		["attacked"] = {},
		["attack"] = {}
		}
 	end, 6000, 1 )
end
addEvent("gotDamage", true)
addEventHandler("gotDamage", root, gotDamaged)

function renderDamage()
	if showDamage then
		for i, v in pairs(damageTable) do
			for a,damage in pairs(v) do
				if i == "attacked" then
					local move = a*22
					dxDrawText("-"..tonumber(damage), positions.attackedX, positions.attackedY+move, positions.attackedX, positions.attackedY, tocolor(255,0,0,255), 2, "default-bold")
				elseif i == "attack" then
					local move = a*22
					dxDrawText("+"..tonumber(damage), positions.attackX, positions.attackY+move, positions.attackX, positions.attackY, tocolor(0,255,0,255), 2, "default-bold")
				end
			end
		end
	end
end
