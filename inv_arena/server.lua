-- 0 = MAIN
-- 1 = DEAGLE
-- 2 = M4
local spawnPositions = { 
[0] = {"3382.06494, -2091.52490, 78.26875", "3381.94849, -2096.36377, 78.26875", "3381.77808, -2104.32324, 78.26875"},
[1] = {"2544.73242, 2805.76855, 10.82031, -605.6630859375, 132.5625", "2545.65015, 2844.41699, 10.82031", "2573.90308, 2848.79126, 10.82031", "2596.42236, 2805.25415, 10.82031", "2614.59009, 2816.50854, 10.82031", "2609.88770, 2849.06665, 10.82031", "2555.81055, 2832.46460, 19.99219", "2601.39575, 2805.59424, 19.99219","2605.04370, 2847.45166, 19.99219"},
[2] = {"1754.68127, 768.89001, 10.82031", "1731.78430, 780.36401, 10.82031", "1693.75391, 764.19360, 10.82031", "1694.42761, 737.23956, 10.82031", "1692.36804, 693.82666, 10.82031", "1677.09033, 664.93103, 10.82031", "1711.38220, 665.25873, 10.82031", "1756.70972, 683.52979, 10.82031", "1741.13196, 730.16565, 10.82031", "1712.01428, 708.48718, 10.82031", "1648.45728, 717.19104, 10.82031", "1635.28284, 751.46606, 10.82031", "1578.22974, 770.63983, 10.82031", "1592.16711, 707.97473, 10.82031", "1596.13171, 732.92896, 10.82031", "1593.99573, 665.60284, 10.82031", "1620.67175, 667.28351, 10.82031"},
}

local weapons = { 
[0] = {"0"},
[1] = {"0", "24"},
[2] = {"0", "31"},
}

function handleArena(player, dimension, weps)
	setElementDimension(player, dimension)
	local randomSpawnpoint = spawnPositions[dimension][math.random(#spawnPositions[dimension])]
	local x, y, z = gettok(randomSpawnpoint, 1, ","), gettok(randomSpawnpoint, 2, ","), gettok(randomSpawnpoint, 3, ",")
	setElementPosition(player, x, y, z)
	if weps then
		setPedWalkingStyle(player, 69) 
		local weapons = split(weps, ",")
		for i, v in ipairs(weapons) do
			giveWeapon(player, tonumber(v), 9999)
		end
	else
		takeAllWeapons(player)
	end
end
addEvent("handleArena", true)
addEventHandler("handleArena", resourceRoot, handleArena)


function onPlayerKill(a, killer, b, bodypart)
	if killer then
		updatePlayerStats(killer, source)
		if bodypart == 9 then
			triggerClientEvent(killer, "gotHeadshot", killer)
		end
	end
	startPlayer(source)
end
addEventHandler("onPlayerWasted", root, onPlayerKill)

local damageImmunity = {}
function onPlayerDamage(attacker, weapon, bodypart, loss)
	if damageImmunity[source] then
		setElementHealth(source, 100)
		setPedArmor(source, 100)
	end
	local dimension = getElementDimension(source)
	if dimension == 0 then
		setElementHealth(source, 100)
		setPedArmor(source, 100)
	end
	if attacker ~= source then
		if bodypart == 9 then
			if not damageImmunity[source] then
				triggerClientEvent(attacker, "gotDamage", attack, "9999", "attack")
				triggerClientEvent(source, "gotDamage", source, "9999", "attacked")
				killPed(source, attacker, weapon, bodypart)
			end
		else
			if not damageImmunity[source] then
				triggerClientEvent(attacker, "gotDamage", attacker, loss, "attack")
				triggerClientEvent(source, "gotDamage", source, loss, "attacked")
			end
		end
	end
end
addEventHandler("onPlayerDamage", root, onPlayerDamage)
			


function updatePlayerStats(killer, killed)
	if killer then
		local killerAccount = getPlayerAccount(killer)
		local killerstreak = getElementData(killer, "killstreak")
		local killedAccount = getPlayerAccount(killed)
		if killerstreak then
			setElementData(killer,"killstreak", killerstreak+1)
		else
			setElementData(killer, "killstreak", 1)
		end
		local sourcestreak = getElementData(killed, "killstreak")
		if sourcestreak then
			if sourcestreak > 3 then
				local killerName = getPlayerName(killer)
				local sourceName = getPlayerName(killed)
				outputChatBox("#abadaa*streak #ffffff"..killerName.." #ffffffjust ended "..sourceName.."'s #abadaax"..sourcestreak.."#ffffff killstreak.", root, 255,255,255,true)
			end
		else
			setElementData(killed, "killstreak", 0)
		end
		setElementData(killed, "killstreak", 0)
		local kills = tonumber(getAccountData(killerAccount, "kills"))
		if kills then
			setAccountData(killerAccount, "kills", kills+1)
		else
			setAccountData(killerAccount, "kills", 1)
		end
		local deaths = tonumber(getAccountData(killedAccount, "deaths"))
		if deaths then
			setAccountData(killedAccount, "deaths", deaths+1)
		else
			setAccountData(killedAccount, "deaths", 1)
		end
		setElementData(killer, "kills", kills)
		setElementData(killed, "deaths", deaths)
		local killerStreak = getElementData(killer, "killstreak")
		local money = getPlayerMoney(killer)
		if killerStreak > 1 then
			local award = 500*killerStreak
			setPlayerMoney(killer, money+award, true)
			setAccountData(killerAccount, "money", money+award)
		else
			setPlayerMoney(killer, money+500, true)
			setAccountData(killerAccount, "money", money+500)
		end
	end
end

function playerLogin()
	startPlayer(source)
	local account = getPlayerAccount(source)
	local crosshair = getAccountData(account, "crosshair")
	if crosshair then
		triggerClientEvent(source,"changeCrosshair", source, crosshair)
	end
	local kills = tonumber(getAccountData(account, "kills"))
	if kills then
		setElementData(source,"kills", kills)
	end
	local deaths = tonumber(getAccountData(account, "deaths"))
	if deaths then
		setElementData(source, "deaths", deaths)
	end
	local team = getAccountData(account, "team")
	if not team then
		setAccountData(account, "team", "YOK")
	end
	local money = tonumber(getAccountData(account, "money"))
	if money then
		setPlayerMoney(source, money, true)
	end
	setElementData(source, "arena", "LOBBY")
end
addEventHandler("onPlayerLogin", root, playerLogin)

function startPlayer(player)
	local dimension = getElementDimension(player)
	local randomSpawnpoint = spawnPositions[dimension][math.random(#spawnPositions[dimension])]
	local x, y, z = gettok(randomSpawnpoint, 1, ","), gettok(randomSpawnpoint, 2, ","), gettok(randomSpawnpoint, 3, ",")
	spawnPlayer(player, x,y,z)
	local account = getPlayerAccount(player)
	local skin = getAccountData(account, "skin")
	if skin then
		setElementModel(player, skin)
	end
	setElementDimension(player, dimension)
	fadeCamera(player, true)
	setCameraTarget(player, player)
	setPedArmor(player, 100)
	giveWeaponSkills(player)
	setElementAlpha(player, 100)
	damageImmunity[player] = true
	for i, v in ipairs(weapons[dimension]) do
		giveWeapon(player, tonumber(v), 9999)
	end
	setTimer ( function()
		setElementAlpha(player, 255)
		damageImmunity[player] = nil
	end, 2000, 1 )
end

local weaponSkills = {69, 70, 71, 72, 73, 74 ,75, 76, 77, 78, 79}
function giveWeaponSkills(player)
	for i, v in ipairs(weaponSkills) do
		setPedStat(player, v, 1000)
	end
end

local messages = {"Our discord server is discord.gg/invuctumgg", "CBUG is active in this server."}
function sendAdvert()
	for i,v in ipairs(messages) do
		outputChatBox("#abadaa[INV] #ffffff"..v, root, 255,255,255,true)
	end
end
setTimer(sendAdvert, 2000*60, 0)


local countryNames = {
AD="Andorra",
AE="Arabia",
AF="Afghanistan",
AG="Antigua and Barbuda",
AI="Anguilla",
AL="Albania",
AM="Armenia",
AN="Netherlands Antilles",
AO="Angola",
AP="Asia",
AR="Argentina",
AS="American Samoa",
AT="Austria",
AU="Australia",
AW="Aruba",
AZ="Azerbaijan",
BA="Bosnia and Herzegovina",
BB="Barbados",
BD="Bangladesh",
BE="Belgium",
BF="Burkina Faso",
BG="Bulgaria",
BH="Bahrain",
BI="Burundi",
BJ="Benin",
BM="Bermuda",
BN="Brunei Darussalam",
BO="Bolivia",
BR="Brazil",
BS="Bahamas",
BT="Bhutan",
BW="Botswana",
BY="Belarus",
BZ="Belize",
CA="Canada",
CD="Congo The Democratic",
CF="Central African Republic",
CH="Switzerland",
CI="Ivory Coast ",
CK="Cook Islands",
CL="Chile",
CM="Cameroon",
CN="China",
CO="Colombia",
CR="Costa Rica",
CS="Serbia and Montenegro",
CU="Cuba",
CY="CY",
CZ="Czech Republic",
DE="Germany",
DJ="Djibouti",
DK="Denmark",
DO="Dominican Republic",
DZ="Algeria",
EC="Ecuador",
EE="Estonia",
EG="Egypt",
ER="Eritrea",
ES="Spain",
ET="Ethiopia",
EU="Europa",
FI="Finland",
FJ="Fiji",
FM="Micronesia, Federal States",
FO="Faeroe Islands",
FR="France",
GA="Gabon",
GB="United Kingdom",
GD="Grenada",
GE="Georgia",
GF="French Guiana",
GH="Ghana",
GI="GibraItar",
GL="Greenland",
GM="Gambia",
GR="Greece",
GT="Guatemala",
GU="Guam",
GW="Guinea",
GY="Guyana",
HK="Hong Kong",
HN="Honduras",
HR="Croatia",
HT="Haiti",
HU="Hungary",
ID="Indonesia",
IE="Ireland",
IL="Israel",
IN="India",
IO="India",
IQ="Iraq",
IR="Iran",
IS="Iceland",
IT="Italy",
JM="Jamaica",
JO="Jordan",
JP="Japan",
KE="Kenya",
KG="Kyrgyzstan",
KH="Cambodia",
KI="Kiribati",
KN="Saint Kitts",
KR="Korea",
KW="Kuwait",
KY="Cayman Islands",
KZ="Kazakhstan",
LA="Democratic Republic",
LB="Lebanon",
LC="Santa Lucia",
LI="Liechtenstein",
LK="Sri Lanka",
LR="Liberia",
LS="Lesotho",
LT="Lithuania",
LU="Luxembourg",
LV="Latvia",
LY="Libya",
MA="Morocco",
MC="Monaco",
MD="Moldova",
MG="Madagascar",
MK="MK",
ML="Mali",
MM="Myanmar",
MN="Mongolia",
MO="Macau",
MP="MP",
MR="Mauritania",
MT="Malta",
MU="Mauricio",
MV="Maldivas",
MW="Malawi",
MX="Mexico",
MY="Malaysia",
MZ="Mozambique",
NA="NAMIBIA",
NC="New Caledonia",
NE="Nigger",
NF="Norfolk Island",
NG="Nigeria",
NI="Nicaragua",
NL="Netherlands",
NO="Norway",
NP="Nepal",
NR="Nauru",
NU="Niue",
NZ="New Zealand",
OM="Oman",
PA="Panama",
PE="Peru",
PF="French Polynesia",
PG="Papua New Guinea",
PH="Philippines",
PK="Pakistan",
PL="Poland",
PR="Puerto Rico",
PS="Palestinian",
PT="Portugal",
PW="Palau",
PY="Paraguay",
QA="Qatar",
RO="Romania",
RU="Russian",
RS="Serbia",
RW="Rwanda",
SA="Saudi Arabian",
SB="Solomon Islands",
SC="Seychelles",
SD="Sudan",
SE="Sweden",
SG="Singapore",
SI="Slovenia",
SK="Slovak Republic",
SL="Sierra Leone",
SM="San Marino",
SN="Senegal",
SR="Suriname",
SV="El Salvador",
SY="Syrian Arab Republic",
SZ="Swaziland",
TG="Togo",
TH="Thailand",
TJ="Tajikistan",
TM="Turkmenistan",
TN="Tunisia",
TO="Tonga",
TR="Turkey",
TT="Trinidad Tobago",
TV="Tuvalu",
TW="Taiwan Province China",
TZ="Tanzania",
UA="Ukraine",
UG="Uganda",
US="United States",
UY="Uruguay",
UZ="Uzbekistan",
VA="Vatican City",
VE="Venezuela",
VG="Virgin Islands",
VI="Virgin Islands",
VN="Vietnam",
VU="Vanuatu",
WS="Samoa",
YE="Yemen",
YU="Formally Yugoslavia",
ZA="South Africa",
ZM="Zambia",
ZW="Zimbabwe",
ZZ="Reserved"
}

local cc = "#abadaa"
addEventHandler('onPlayerJoin',root,
function ()
    local country = exports['admin']:getPlayerCountry(source)
    setElementData(source,'Country',country)
    outputChatBox('#FFFFFF'..getPlayerName(source)..cc..' has joined the game [#FFFFFF' ..countryNames[tostring(country)]..cc..'] ', root, 120, 124, 227, true)
	end
)

addEventHandler('onPlayerChangeNick', root,
    function(oldNick, newNick)
        outputChatBox('#FFFFFF' ..oldNick..cc..' is now known as #FFFFFF'..newNick, getRootElement(), 255, 172, 17, true)
    end
)
 
addEventHandler('onPlayerQuit', root,
    function(reason)
        outputChatBox('#FFFFFF'..getPlayerName(source)..cc..' has left the game [#FFFFFF' .. reason ..cc.. ']', getRootElement(), 255, 0, 0, true)
    end
)

