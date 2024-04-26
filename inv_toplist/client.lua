local sX, sY = guiGetScreenSize()
local wH, wW = 700, 400
local wX, wY = (sX - wH) / 2, (sY - wW) / 2

function mainWindow()
    window = guiCreateWindow(wX, wY, wH, wW, "TOP LIST", false)
    guiSetVisible(window, false)
    decoration = guiCreateMemo(0, 20, wH, wW-25, "", false, window)
    toplist = guiCreateGridList(0, 0, wH, wW-25, false, decoration)
    guiSetAlpha(toplist, 0.7)
    guiGridListAddColumn(toplist, "Name", 0.37)
    guiGridListAddColumn(toplist, "Kills", 0.2)
    guiGridListAddColumn(toplist, "Deaths", 0.2)
    guiGridListAddColumn(toplist, "K/D", 0.2)
end mainWindow()

bindKey("F5", "down",
function()
    guiSetVisible(window, not guiGetVisible(window))
    showCursor(guiGetVisible(window))
    if not guiGetVisible(window) then return end
    if isTimer(eventTimer) then return end
    eventTimer = setTimer(function()end, 10000, 1)
    triggerServerEvent("serverEvent", resourceRoot)
end)

addEvent("clientEvent", true)
addEventHandler("clientEvent", localPlayer,
function(list)
    guiGridListClear(toplist)
    for i, v in ipairs(list) do
        local kills, deaths = v.kills == 0 and 1 or v.kills, v.deaths == 0 and 1 or v.deaths
        guiGridListAddRow(toplist, v.name, v.kills, v.deaths, kills / deaths)
    end
end)