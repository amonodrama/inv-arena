function reloadSkinList(player, acc)
    local mySkins = {}
    for i = 1, #skinTable do
        if getAccountData(acc, "boughtSkin"..i) then
            table.insert(mySkins, i)
        end
    end
    triggerClientEvent(player, "clientEvent", player, "Reload List", mySkins)
    mySkins = {}
end

addEvent("serverEvent", true)
addEventHandler("serverEvent", resourceRoot,
function(arg1, arg2)
    local acc = getPlayerAccount(client)
    if isGuestAccount(acc) then return outputChatBox("#abadaa[SKIN] #ffffffYou have a guest account.", client, 255,255,255,true) end
    if arg1 == "Buy Skin" then
        if getAccountData(acc, "boughtSkin"..arg2) then
            setPedSkin(client, skinTable[arg2][2])
            setAccountData(acc, "skin", skinTable[arg2][2])
            outputChatBox("#abadaa[SKIN] #ffffffSkin applied.", client, 255,255,255,true)
            return 
        end 
        local money = getPlayerMoney(client)
        if money >= skinTable[arg2][3] then
            setPlayerMoney(client, money - skinTable[arg2][3])
            setAccountData(acc, "money", money-skinTable[arg2][3])
            setAccountData(acc, "boughtSkin"..arg2, true)
            setPedSkin(client, skinTable[arg2][2])
            setAccountData(acc, "skin", skinTable[arg2][2])
            print(getAccountData(acc, "money"))
            outputChatBox("#abadaa[SKIN] #ffffffYou bought the "..skinTable[arg2][1].." for $"..skinTable[arg2][3], client, 255,255,255,true)
            reloadSkinList(client, acc)
        else
            outputChatBox("#abadaa[SKIN] #ffffffYou do not have enough money.", client, 255,255,255,true)
        end
    elseif arg1 == "Downloaded" then
        reloadSkinList(client, acc)
    end
end)

addEventHandler("onPlayerLogin", root,
function(_, acc)
    reloadSkinList(source, acc)
end)