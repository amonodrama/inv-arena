addEvent("serverEvent", true)
addEventHandler("serverEvent", resourceRoot,
function()
    local toplist = {}
    for _, v in ipairs(getAccounts()) do
        table.insert(toplist,
            {
                name = getAccountData(v, "noColorName") or getAccountName(v),
                kills = tonumber(getAccountData(v, "kills")) or 10,
                deaths = tonumber(getAccountData(v, "deaths")) or 0
            }
        )
    end
    table.sort(toplist, function(a, b) return a.kills > b.kills end)
    triggerClientEvent(client, "clientEvent", client, toplist)
end)

addEventHandler("onPlayerLogin", root,
function(_, acc)
    setAccountData(acc, "noColorName", string.gsub(getPlayerName(source), "#%x%x%x%x%x%x", ""))
end)

addEventHandler("onPlayerChangeNick", root,
function(old, new)
    local acc = getPlayerAccount(source)
    if isGuestAccount(acc) then return end
    setAccountData(acc, "noColorName", string.gsub(new, "#%x%x%x%x%x%x", ""))
end)