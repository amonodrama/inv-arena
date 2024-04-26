function onResourceStart() 
    local players = getElementsByType ("player")
    for key, player in ipairs (players) do
        setPlayerNametagShowing(player, false)
    end 
end 
addEventHandler("onResourceStart", resourceRoot, onResourceStart) 

function onPlayerJoin() 
    setPlayerNametagShowing (source, false) 
end 
addEventHandler("onPlayerJoin", root, onPlayerJoin)
