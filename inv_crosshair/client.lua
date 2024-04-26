local config = {

    serverColor = {5, 134, 249},

    crosshairs = { 
        {'mira/1.png'},
        {'mira/2.png'},
        {'mira/3.png'},
        {'mira/4.png'},
    },
    
}

local screenW, screenH = guiGetScreenSize()
local resW, resH = 1920, 1080
local x, y = (screenW/resW), (screenH/resH)

local crosshairs = {}
local shader = false
local currentCrosshair = nil

local proximaPagina = 0
local maxLinhas = 3
local font = "default-bold"

local tableDx = {

    selects = {
        {x*785, y*412, x*349, y*83},
        {x*785, y*503, x*349, y*83},
        {x*785, y*594, x*349, y*83},
    },

    verification = {
        {x*764, y*701, x*392, y*82},
    },

    crosshairListTxt = {
        {x*888, y*443, x*(888 + 62), y*(443 + 21)},
        {x*888, y*534, x*(888 + 62), y*(534 + 21)},
        {x*888, y*625, x*(888 + 62), y*(625 + 21)},
    },

    crosshairListTwo = {
        {x*1056, y*417, x*73, y*73},
        {x*1056, y*508, x*73, y*73},
        {x*1056, y*599, x*73, y*73},
    },

    crosshairPos = {
        {x*1056, y*417, x*73, y*73},
        {x*1056, y*500, x*73, y*73},
        {x*1056, y*599, x*73, y*73},
    },

}

function menuRender()

    local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, ((getTickCount() - tick) / 500), 'Linear')
    linha = 0

    dxDrawImage(x*715, y*253, x*490, y*574, "files/background.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)

    for i,v in ipairs(config.crosshairs) do 
        if (i > proximaPagina and linha < maxLinhas) then
            linha = linha + 1

            if mousePosition(tableDx.selects[linha][1], tableDx.selects[linha][2], tableDx.selects[linha][3], tableDx.selects[linha][4]) then
                color = tocolor(25 + 25, 25 + 25, 25 + 25, alpha)
            else
                color = tocolor(25, 25, 25, alpha)
            end
            
            if selectedCrosshair == i then 
                color = tocolor(config.serverColor[1], config.serverColor[2], config.serverColor[3], alpha)
            end

            dxDrawRoundedRectangle(tableDx.selects[linha][1], tableDx.selects[linha][2], tableDx.selects[linha][3], tableDx.selects[linha][4], color, 5)
            dxDrawRoundedRectangle(tableDx.crosshairListTwo[linha][1], tableDx.crosshairListTwo[linha][2], tableDx.crosshairListTwo[linha][3], tableDx.crosshairListTwo[linha][4], tocolor(45, 45, 45, 255), 5)
            dxDrawImage(tableDx.crosshairPos[linha][1], tableDx.crosshairPos[linha][2], tableDx.crosshairPos[linha][3], tableDx.crosshairPos[linha][4], v[1], 0, 0, 0, tocolor(255, 255, 255, 255), false)
            dxDrawText('Crosshair ['..i..']', tableDx.crosshairListTxt[linha][1], tableDx.crosshairListTxt[linha][2], tableDx.crosshairListTxt[linha][3], tableDx.crosshairListTxt[linha][4], tocolor(255, 255, 255, alpha), x*1, font, "center", "center", false, false, false, true, false)
        end
    end

    for i,v in ipairs(tableDx.verification) do

        if mousePosition(tableDx.verification[i][1], tableDx.verification[i][2], tableDx.verification[i][3], tableDx.verification[i][4]) then
            colorVerifi = tocolor(config.serverColor[1], config.serverColor[2], config.serverColor[3], alpha)
        else
            colorVerifi = tocolor(config.serverColor[1], config.serverColor[2], config.serverColor[3], 0)
        end

        dxDrawRoundedRectangle(tableDx.verification[i][1], tableDx.verification[i][2], tableDx.verification[i][3], tableDx.verification[i][4], colorVerifi, 5)
    end

    dxDrawRoundedRectangle(x*766, y*702, x*389, y*79, tocolor(25, 25, 25, 255), 5)
	dxDrawText("Choose", x*892, y*728, x*(892 + 135), y*(728 + 28), tocolor(255, 255, 255, 255), x*1.0, font, "center", "center", false, false, false, true, false)

end

addEventHandler("onClientClick", getRootElement(), function(button,state)
    if button == "left" and state == "down" then
        if isEventHandlerAdded("onClientRender", getRootElement(), menuRender) then

            linha = 0
            for i,v in ipairs(config.crosshairs) do
                if (i > proximaPagina and linha < maxLinhas) then
                    linha = linha + 1
                    if isMouseInPosition(tableDx.selects[linha][1], tableDx.selects[linha][2], tableDx.selects[linha][3], tableDx.selects[linha][4]) then
                        if selectedCrosshair ~= i then 
                            selectedCrosshair = i
                        else
                            selectedCrosshair = nil
                        end
                    end
                end
            end

            for i,v in ipairs(tableDx.verification) do
                if isMouseInPosition(v[1], v[2], v[3], v[4]) then
                    if selectedCrosshair == nil then return end
                    changeCrosshair(selectedCrosshair)
                end
            end

        end
    end
end)

function open_close()
    if not isEventHandlerAdded("onClientRender", getRootElement(), menuRender) then
        tick = getTickCount()
        proximaPagina = 0 
        selectedCrosshair = nil
		showCursor(true)
		showChat(false)
		addEventHandler("onClientRender", getRootElement(), menuRender)
	else
		showCursor(false)
		showChat(true)
		removeEventHandler("onClientRender", getRootElement(), menuRender)
	end
end
bindKey('f2', 'down', open_close)

function UpDown (b)
    if isEventHandlerAdded('onClientRender', root, menuRender) then
        if isMouseInPosition(x*783, y*407, x*354, y*265) then
            if b == 'mouse_wheel_down' then
                proximaPagina = proximaPagina + 1
                if (proximaPagina > #config.crosshairs - maxLinhas) then
                    proximaPagina = #config.crosshairs - maxLinhas
                end
            elseif b == 'mouse_wheel_up'  then
                if (proximaPagina > 0) then
                    proximaPagina = proximaPagina - 1
                end
            end
        end
    end
end

bindKey('mouse_wheel_up', 'down', UpDown)
bindKey('mouse_wheel_down', 'down', UpDown)

addEventHandler("onClientResourceStart", root, function()
    shader = dxCreateShader("files/texreplace.fx")

    for i,v in ipairs(config.crosshairs) do 
        addCrosshair(v[1])
    end

end)

function changeCrosshair(id)
    if not shader then
        return
    end

    if not id then
        return
    end

    local crosshairPath = crosshairs[id]
    local texture = dxCreateTexture(crosshairPath)

    engineApplyShaderToWorldTexture(shader, "siteM16")
    dxSetShaderValue(shader, "gTexture", texture)
    currentCrosshair = id
    triggerServerEvent("saveCrosshair", resourceRoot, localPlayer, id)
end
addEvent("changeCrosshair", true)
addEventHandler("changeCrosshair", root, changeCrosshair)


function resetCrosshair()
    engineRemoveShaderFromWorldTexture(shader, "siteM16")
    currentCrosshair = nil
end

function addCrosshair(path)
    table.insert(crosshairs, path)
end

function getCrosshairs()
    return #crosshairs, crosshairs
end

function dxDrawRoundedRectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius
    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)
        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end

function isMouseInPosition ( x, y, width, height )
    if ( not isCursorShowing( ) ) then
      return false
    end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    
    return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end
  
function mousePosition (x,y,w,h)
    if isCursorShowing() then
        local mx, my = getCursorPosition()
        local resx, resy = guiGetScreenSize()
        mousex, mousey = mx*resx, my*resy
        if mousex > x and mousex < x + w and mousey > y and mousey < y + h then
            return true
        else
            return false
        end
    end
end
  
function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function convertNumber ( number )
    local formatted = number
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if ( k==0 ) then
            break
        end
    end
    return formatted
end   
