--image
local imageTexture = dxCreateTexture(1, 1)
local imagePixels = dxGetTexturePixels(imageTexture)
dxSetPixelColor(imagePixels, 0, 0, 255, 255, 255, 255)
dxSetTexturePixels(imageTexture, imagePixels)
if fileExists("image.png") then fileDelete("image.png")end
local imageType = dxConvertPixels(dxGetTexturePixels(imageTexture), "png")
local file = fileCreate("image.png")fileWrite(file, imageType)fileClose(file)
local lib = {
    button = {
        labels = {},
        state = {},
        color = {
            normal = "FFFF0000",
            hover = "FFFF5555",
            click = "FF990000",
        }
    }
}

function jujuCreateButton(x, y, w, h, text, bool, parent)
    local tbl = lib.button
    local bg = guiCreateStaticImage(x, y, w, h, "image.png", bool, parent)
    tbl[bg] = true
    tbl.state[bg] = 1
	guiSetProperty(bg, "ImageColours", "tl:"..tbl.color.normal.." tr:"..tbl.color.normal.." bl:"..tbl.color.normal.." br:"..tbl.color.normal)
    w, h = guiGetSize(bg, false)
    tbl.labels[bg] = guiCreateLabel(0, 0, w, h, text, false, bg)
    guiSetEnabled(tbl.labels[bg], false)
    guiSetFont(tbl.labels[bg], "sans")
	guiLabelSetHorizontalAlign(tbl.labels[bg], "center")
	guiLabelSetVerticalAlign(tbl.labels[bg], "center")
    return bg
end

addEventHandler("onClientMouseEnter", root,
function()
    local tbl = lib.button
	if tbl[source] then
		tbl.state[source] = 2
		guiSetProperty(source, "ImageColours", "tl:"..tbl.color.hover.." tr:"..tbl.color.hover.." bl:"..tbl.color.hover.." br:"..tbl.color.hover)
	end
end)

addEventHandler("onClientMouseLeave", root,
function()
    local tbl = lib.button
	if tbl[source] then
		tbl.state[source] = 1
		guiSetProperty(source, "ImageColours", "tl:"..tbl.color.normal.." tr:"..tbl.color.normal.." bl:"..tbl.color.normal.." br:"..tbl.color.normal)
	end
end)

addEventHandler("onClientGUIClick", resourceRoot,
function(btn)
	if btn == "left" then
        local tbl = lib.button
        if tbl[source] then
			guiSetProperty(source, "ImageColours", "tl:"..tbl.color.click.." tr:"..tbl.color.click.." bl:"..tbl.color.click.." br:"..tbl.color.click)
			local btn = source
			setTimer(function()
				if not isElement(btn) then return end
				if tbl.state[btn] == 2 then
					guiSetProperty(btn, "ImageColours", "tl:"..tbl.color.hover.." tr:"..tbl.color.hover.." bl:"..tbl.color.hover.." br:"..tbl.color.hover)
				elseif tbl.state[btn] == 1 then
					guiSetProperty(btn, "ImageColours", "tl:"..tbl.color.normal.." tr:"..tbl.color.normal.." bl:"..tbl.color.normal.." br:"..tbl.color.normal)
				end
			end, 100, 1)
		end
	end
end)

local sX, sY = guiGetScreenSize()
local wH, wW = 600, 500
local wX, wY = (sX - wH) / 2, (sY - wW) / 2

    window = guiCreateStaticImage(wX, wY, wH, wW, "image.png", false)
	guiSetProperty(window, "ImageColours", "tl:AF000000 tr:AF000000 bl:AF000000 br:AF000000")
    title = guiCreateStaticImage(0, 0, wH, 25, "image.png", false, window)
	guiSetProperty(title, "ImageColours", "tl:FFFF0000 tr:FFFF0000 bl:FFFF0000 br:FFFF0000")
    skins = jujuCreateButton(0, 0, 50, 25, "Skins", false, title)
    inventory = jujuCreateButton(51, 0, 80, 25, "Inventory", false, title)
    skinList = guiCreateGridList(175, 60, 200, 300, false, window)
    guiGridListAddColumn(skinList, "Name", 0.6)
    guiGridListAddColumn(skinList, "Price", 0.32)
    for _, v in ipairs(skinTable) do
        local row = guiGridListAddRow(skinList, v[1], "$"..v[3])
    end
    guiGridListSetSelectedItem(skinList, 0, 1)
    buySkin = jujuCreateButton(175, 400, 200, 25, "Buy", false, window)
    guiSetVisible(window, false)

addEventHandler("onClientGUIClick", resourceRoot,
function(btn)
    if btn == "left" then
        if source == skinList then
            local r, c = guiGridListGetSelectedItem(skinList)
            if r == -1 then return end
            setElementModel(skin, skinTable[r+1][2])
        elseif source == buySkin then
            if isTimer(clickTimer) then return end
            clickTimer = setTimer(function()end, 1000, 1)
            local i = guiGridListGetSelectedItem(skinList) i = i + 1
            if i == 0 then return outputChatBox("Select a skin") end
            triggerServerEvent("serverEvent", resourceRoot, "Buy Skin", i)
        end
    end
end)

addEventHandler("onClientPreRender", root,
function()
	if not skin or not objectPreview then return end
	if getKeyState("num_2") then myRotation[1] = myRotation[1] - 5 end
	if getKeyState("num_8") then myRotation[1] = myRotation[1] + 5 end
	if getKeyState("num_add") then myRotation[2] = myRotation[2] - 5 end
	if getKeyState("num_sub") then myRotation[2] = myRotation[2] + 5 end
	if getKeyState("num_4") then myRotation[3] = myRotation[3] - 5 end
	if getKeyState("num_6") then myRotation[3] = myRotation[3] + 5 end
    exports.object_preview:setRotation(objectPreview, unpack(myRotation))
end, true, "high" )

addEvent("clientEvent", true)
addEventHandler("clientEvent", localPlayer,
function(arg1, arg2)
    if arg1 == "Reload List" then
        for k, v in pairs(arg2) do
            skinTable[v][3] = "Bought"
            guiGridListSetItemText(skinList, v-1, 2, "Bought", false, false)
        end
    end
end)

triggerServerEvent("serverEvent", resourceRoot, "Downloaded")

bindKey("F6", "down",
function()
    if not guiGetVisible(window) then
        myRotation = {0, 0, 180}
        skin = createPed(skinTable[1][2], 0, 0, 0)
        objectPreview = exports.object_preview:createObjectPreview(skin, 0, 0, 0, wX - 150, wY, 450, 450, false, true, true)    
        guiSetVisible(window, true)
        showCursor(true)
    else
        myRotation = nil
        exports.object_preview:destroyObjectPreview(objectPreview)
        destroyElement(skin)
        skin = nil
        objectPreview = nil
        guiSetVisible(window, false)
        showCursor(false)
    end 
end)