local ayarlar = {
	renk = "#abadaa",
	prefix = "[INV] ",
}

local prefix = ayarlar.prefix
local renk = ayarlar.renk
function starter()
executeSQLQuery("CREATE TABLE IF NOT EXISTS clans (teamname TEXT, wins TEXT, owner TEXT, serial TEXT, color TEXT)")
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), starter)


function createATeam(player, cmd, name)
local pname = getPlayerName(player)
local serial = getPlayerSerial(player)
pname = string.gsub(pname, "#%x%x%x%x%x%x", "")
	if isInTeam(player) == "YOK" then
	local team = executeSQLQuery("SELECT teamname FROM clans WHERE teamname=?", name)
		if #team == 0 then
		executeSQLQuery("INSERT INTO clans(teamname,wins,owner,serial,color) VALUES(?,?,?,?,?)", name, "0", pname, serial,"#ffffff")
		local acc = getPlayerAccount(player)
		setAccountData(acc, "team", name)
		outputChatBox(renk..prefix..pname.." #ffffffcreated "..name.." clan.",root,255,255,255,true)
		checkTeam(player)
		else
		outputChatBox(renk..prefix.."A clan with that name already exists.",player,255,255,255,true)
		end 
	else
	outputChatBox(renk..prefix.."#ffffffYou are already in a clan.",player,255,255,255,true)
	end 
end
addCommandHandler("ct", createATeam)

function deleteATeam(player, cmd)
local myteam = isInTeam(player)
	if myteam ~= "YOK" then
	local teamowner = executeSQLQuery("SELECT serial FROM clans WHERE teamname=?", myteam)
	local myserial = getPlayerSerial(player)
		if teamowner[1].serial == myserial then
		executeSQLQuery("DELETE FROM clans WHERE teamname=?", myteam)
		local acc = getPlayerAccount(player)
		setAccountData(acc, "team", "YOK")
		local pname = getPlayerName(player)
		outputChatBox(renk..prefix..pname.." #ffffffdeleted "..myteam.." clan.",root,255,255,255,true)
		setPlayerTeam(player, nil)
		destroyElement(getTeamFromName(myteam))
		else
		outputChatBox(renk..prefix.."#ffffffYou can not delete a clan you do not own.",player,255,255,255,true)
		end
	else
	outputChatBox(renk..prefix.."#ffffffYou are not in a clan.",player,255,255,255,true)
	end
end
addCommandHandler("dt", deleteATeam)

function leaveATeam(player, cmd)
local myteam = isInTeam(player)
	if myteam ~= "YOK" then
	local teamowner = executeSQLQuery("SELECT serial FROM clans WHERE teamname=?", myteam)	
	local myserial = getPlayerSerial(player)
		if teamowner[1].serial ~= myserial then
		local acc = getPlayerAccount(player)
		setAccountData(acc, "team", "YOK")
		outputChatBox(renk..prefix.."#ffffffYou left your clan.",player,255,255,255,true)
		setPlayerTeam(player, nil)
		else
		outputChatBox(renk..prefix.."#ffffffYou can not leave a clan you own use /dt instead.",player,255,255,255,true)
		end
	else
	outputChatBox(renk..prefix.."#ffffffYou are not in a clan.",player,255,255,255,true)	
	end
end
addCommandHandler("lt", leaveATeam)

function setATeamcolor(player, cmd, color)
if string.len(color) ~= 6 then
outputChatBox(renk..prefix.."#ffffffThis is not a valid color.",player,255,255,255,true)
return end
local myteam = isInTeam(player)
	if myteam ~="YOK" then
		local teamowner = executeSQLQuery("SELECT serial FROM clans WHERE teamname=?", myteam)
		local myserial = getPlayerSerial(player)
		if teamowner[1].serial == myserial then
			executeSQLQuery("UPDATE clans SET color=? WHERE teamname=?", "#"..color, myteam)
			outputChatBox(renk..prefix.."#ffffffClan color changed.",player,255,255,255,true)
			local r, g, b = getColorFromString("#"..color)
			setTeamColor(getTeamFromName(myteam),r,g,b)
		else
		outputChatBox(renk..prefix.."#ffffffYou can not change color of a clan you do not own.",player,255,255,255,true)
		end
	else
	outputChatBox(renk..prefix.."#ffffffYou are not in a team.",player,255,255,255,true)
	end
end
addCommandHandler("stc", setATeamcolor)				

local invites = {}
function inviteToTeam(player,cmd,name)
	if isInTeam(player) == "YOK" then
		outputChatBox("You are not in a team", player, 255,255,255,true)
	else
	local target = findPlayerByName(name)
		if isInTeam(target) == "YOK" then
			if not invites[target] then
					local teamName = isInTeam(player)
					invites[target] = {['teamname'] = teamName}
					outputChatBox(renk..prefix.."#ffffffYou invited "..getPlayerName(target).." #ffffffto your clan.",player,255,255,255,true)
					outputChatBox(renk..prefix.."#ffffffYou recieved an invite from "..teamName.. " type /invite accept or decline.",target,255,255,255,true)
			else
				outputChatBox(renk..prefix.."#ffffffPlayer already has an invite tell them to decline it first.",player,255,255,255,true)
			end
		else
			outputChatBox(renk..prefix.."#ffffffPlayer is already in a team.",player,255,255,255,true)	
		end
	end	
end
addCommandHandler("invite", inviteToTeam)

function invitedToTeam(player, cmd, state)
if invites[player] then
	if state == "accept" then
	local name = invites[player].teamname	
	local pname = getPlayerName(player)
	pname = string.gsub(pname, "#%x%x%x%x%x%x", "")
	local serial = getPlayerSerial(player)
	local acc = getPlayerAccount(player)
	setAccountData(acc,"team", name)
	invites[player] = nil
	outputChatBox(renk..prefix..pname.." #ffffffjoined "..name.." clan.",root,255,255,255,true)
	setPlayerTeam(player, getTeamFromName(invites[player].teamname))
	elseif state == "decline" then
	invites[player] = nil
	outputChatBox(renk..prefix.."#ffffffYou declined the invite.",player,255,255,255,true)
	end
end
end
addCommandHandler("rinvite", invitedToTeam)

function findPlayerByName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

function isInTeam(player)
local acc = getPlayerAccount(player)
local team = getAccountData(acc, "team")
return team
end


function checkTeam(player)
	local pteam = isInTeam(player)
	if pteam ~= "YOK" then
		local team = executeSQLQuery("SELECT teamname FROM clans WHERE teamname=?", pteam)
		if not getTeamFromName(team[1].teamname) then
			local teamcolor = executeSQLQuery("SELECT color FROM clans WHERE teamname=?", pteam)	
			local r, g, b = getColorFromString(teamcolor[1].color)	
			createTeam(pteam, r,g,b)
			setPlayerTeam(player, getTeamFromName(pteam))
		else
			setPlayerTeam(player, getTeamFromName(pteam))
		end
	end
end

function checkJoin()
checkTeam(source)
end
addEventHandler("onPlayerLogin", root, checkJoin)

function removeTeam()
setTimer(emptyTeams,2000,1)
end
addEventHandler("onPlayerQuit", root, removeTeam)

function emptyTeams()
for id, team in ipairs ( getElementsByType ( "team" ) ) do
if team and #getPlayersInTeam(team) == 0 then
destroyElement(team)
end
end
end

