local sw,sh = guiGetScreenSize()
local GothaProMed = dxCreateFont("GothaProMed.otf",10)

addEventHandler( "onClientRender", root, function (  )
    for k,player in ipairs(getElementsByType("player")) do
        if player ~= getLocalPlayer() and getElementDimension(getLocalPlayer()) == getElementDimension(player) then
            local x, y, z = getElementPosition(player)
            z = z + 0.95
            local Mx, My, Mz = getCameraMatrix()
            local distance = getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz )
            local size = 1
            if ( distance <= 30 ) then
            local sx,sy = getScreenFromWorldPosition( x, y, z, 0 )
                if ( sx and sy ) then
                    local hp = getElementHealth(player)
                    if hp > 100 then hp = 100 end
                    if hp > 0 then
                        local maxhp = 64
                        local pw,ph = hp*(maxhp/100),5
                        dxDrawImage ( sx-maxhp/2-2, sy-ph/2-2-5, maxhp+4,ph+4, "white.jpg",0,0,0,tocolor(0,0,0,100) )
                        dxDrawImage ( sx-maxhp/2, sy-ph/2-5, pw,ph, "white.jpg",0,0,0,tocolor(255,50,50,150) )
                    end
                    
                    local armor = getPedArmor(player)
                    if armor > 100 then armor = 100 end
                    if armor > 0 then
                        local maxarmor = 64
                        local pw,ph = armor*(maxarmor/100),5
                        dxDrawImage ( sx-maxarmor/2-2, sy-ph/2-2+5, maxarmor+4,ph+4, "white.jpg",0,0,0,tocolor(0,0,0,100) )
                        dxDrawImage ( sx-maxarmor/2, sy-ph/2+5, pw,ph, "white.jpg",0,0,0,tocolor(255,255,0,150) )
                    end
                    
                    local name = string.gsub(getPlayerName(player), "#%x%x%x%x%x%x", "")
                    if hp > 0 and armor then
                        dxDrawText(name, sx, sy, sx+size, sy+size-10, tocolor(0,0,0,255), size, GothaProMed, "center", "bottom", false, false, false)
                        dxDrawText(name, sx, sy, sx-size, sy-size-10, tocolor(0,0,0,255), size, GothaProMed, "center", "bottom", false, false, false)
                        dxDrawText(name, sx, sy, sx-size, sy+size-10, tocolor(0,0,0,255), size, GothaProMed, "center", "bottom", false, false, false)
                        dxDrawText(name, sx, sy, sx+size, sy-size-10, tocolor(0,0,0,255), size, GothaProMed, "center", "bottom", false, false, false)
                        dxDrawText(name, sx, sy, sx, sy-10, tocolor(255,255,255,255), size, GothaProMed, "center", "bottom", false, false, false)
                        
                    end
                end
            end
        end
    end 
end)