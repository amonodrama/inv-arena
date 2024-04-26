local ScreenW, ScreenH = guiGetScreenSize( )

local hudTable = { "ammo", "area_name", "armour", "breath", "clock", "health", "money", "radar", "vehicle_name", "weapon", "radio", "wanted" }

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for id, hudComponents in pairs(hudTable) do
			showPlayerHudComponent(hudComponents, false)
		end
		addEventHandler("onClientRender", root, mainHud)
	end
)


local hudX, hudY = (ScreenW - 37 * 6), (ScreenH - 45 * 3)

function mainHud()
	dxDrawImage(hudX, hudY, 197, 114, "img/main.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)	
	local armor = getPedArmor(localPlayer)	dxDrawImageSection(hudX + 16, hudY + 19, 176/100*armor, 30, 0, 0, 176/100*armor, 30, "img/armor.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	local hp = getElementHealth(localPlayer)
	dxDrawImageSection(hudX + 15, hudY + 18 * 3 + 1, 178/100*hp, 36, 0, 0, 178/100*hp, 36, "img/heart.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawImage(hudX + 27 * 6, hudY + 26, 24, 62, "img/icons.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	--dxDrawImage(hudX, hudY - 40, 197, 39, "img/row.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	local weapon = getWeaponNameFromID(getPlayerWeapon(localPlayer))
	local ammo = getPedAmmoInClip(localPlayer)
	local money = getPlayerMoney(localPlayer)
	dxDrawText(weapon.."/"..ammo, hudX+20+1, hudY-30+1, hudX, hudY, tocolor(0,0,0,255), 2, "unifont", _,_,_,_,_,true)
	dxDrawText(weapon.."/#454554"..ammo, hudX+20, hudY-30, hudX, hudY, tocolor(255,255,255,255), 2, "unifont", _,_,_,_,_,true)
	dxDrawText("$ "..money, hudX+20+1, hudY-65+1, hudX, hudY, tocolor(0,0,0,255), 2, "unifont", _, _, _, _, _, true)
	dxDrawText("#006600$ #ffffff"..money, hudX+20, hudY-65, hudX, hudY, tocolor(255,255,255,255), 2, "unifont", _, _, _, _, _, true)

end

function formatMoney(amount)
	local formatted = tonumber(amount)
	if formatted then
		while true do  
			formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
		if (k==0) then
			break
		end
	end
		return formatted
	else
		return amount
	end
end