function isMouseInPosition ( x, y, width, height )
    if ( not isCursorShowing( ) ) then
        return false
    end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    
    return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

local help_table = {
    {"How to play?", "files/icon_1.png", "Welcome to Invictum Academy. \nThis server is made for helping you\nbecome better at aiming and PVPing.\n\n-In order to play-\n* You may go to any arena marker.\n* Headshots are instant kill in arena.\n* For leaving use the command /leave\n* More commands are in command section."},
    {"Commands", "files/icon_1.png", "-Invictum Academy Commands-\n\n/pm player - For private messaging.\n/reply - For replying to private messages.\n/leave - For leaving an arena.\n\n-Team/Group Commands-\n\n/ct teamname - For creating a team.\n/dt - For deleting your team.\n/lt - For leaving your team.\n/stc ff4400 - For changing team color.\n/invite player - For inviting player.\n/rinvite accept - For accepting invite.\n/rinvite decline - For declining invite."},
    {"Team/Group System", "files/icon_1.png", "-Invictum Team/Group-\n\n*Use Y to talk with your group.\n/ct teamname - For creating a team.\n/dt - For deleting your team.\n/lt - For leaving your team.\n/stc ff4400 - For changing team color.\n/invite player - For inviting player.\n/rinvite accept - For accepting invite.\n/rinvite decline - For declining invite."},
    {"Binds", "files/icon_1.png", "-Invictum Panel Binds-\n\nF1 - Help Panel\nF2 - Weapon Crosshairs\nF3 - Sniper Crosshairs\nF4 - Server Changer\nF5 - Top List\nF6 - Skin Panel\nF7 - Ignore and Block PMs"},
    {"How to ignore?", "files/icon_1.png", "-Invictum Ignore System-\n\nIf someone is annoying you with PMs or\nspamming in the chat you can use F7.\n\n- Just pick a player from the left.\n- Press Block PM or Ignore button."},
    {"EMPTY", "files/icon_1.png", "EMPTY."},
    {"EMPTY", "files/icon_1.png", "EMPTY."},
    {"EMPTY", "files/icon_1.png", "EMPTY."}
}


local sx, sy = guiGetScreenSize();
local px = ( sx / 1920 );

function centerWindow()
    Weight = 750 * px;
    Height = 420 * px;
    PosX = ( sx / 2 ) - ( Weight / 2 )
    PosY = ( sy / 2 ) - ( Height / 2 )
end
centerWindow()

textures = {}
textures.bg = dxCreateTexture("files/bg.png")
textures.scroll = dxCreateTexture("files/scroll.png")

textures.icon_1 = dxCreateTexture("files/icon_1.png")
textures.icon_2 = dxCreateTexture("files/icon_2.png")
textures.icon_3 = dxCreateTexture("files/icon_3.png")
textures.icon_4 = dxCreateTexture("files/icon_4.png")

local selected = nil;
local helpmoon = false;

local scroll = 0;
local maxItems = 5*px
local gridYPos = PosY+130*px
local gridRowHeight = Height-360*px

local rowFont = "unifont"
local regular = "clear"


function drawWindow(button, state)
    if helpmoon then
        dxDrawImage(PosX, PosY, Weight, Height, textures.bg, 0, 0, 0, tocolor(255,255,255,255))
        dxDrawText("Need Help?", PosX+50*px, PosY + 20, Weight-415*px, PosY + 20, tocolor(255,255,255,255), 2, rowFont)
        local index = 0;
        for k,v in ipairs(help_table) do
            if k >= scroll then
                if index < maxItems then
                    local y = gridYPos+(index*62)
                    if isMouseInPosition(PosX, y-60*px, Weight-415*px, gridRowHeight) then
                        if getKeyState('mouse1') and not clk then
                            selected = k
                        end
                    end

                    if k == selected then
                        dxDrawText(v[3], PosX+350*px, PosY+30*px, 100, 100, tocolor(255,255,255,255), 1.45, regular)
                        dxDrawRectangle(PosX, y-60*px, Weight-415*px, gridRowHeight, tocolor(120,120,120,255))
                    else
                        dxDrawRectangle(PosX, y-60*px, Weight-415*px, gridRowHeight, tocolor(105,105,105,255))
                        dxDrawText("", PosX+450*px, PosY+50*px, 100, 100, tocolor(255,255,255,255), 1.2, regular)
                    end

                    dxDrawText(v[1], PosX+50*px, y-40*px, Weight-415*px, gridRowHeight, tocolor(255,255,255,255), 2, rowFont)
                    dxDrawImage(PosX+325*px, scroll*61+PosY+70*px, Weight-740*px, Height-298*px, textures.scroll, 0,0,0, tocolor(255,255,255,255))

                    dxDrawImage(PosX+10*px, y-43*px, Weight-730*px, gridRowHeight-35*px, v[2], tocolor(255,255,255,255))
                end
                index = index + 1
            end
        end
    end
end

addEventHandler('onClientKey', root, function(key, state)
	if not state then
		return
	end
	if helpmoon then
		if key == 'mouse_wheel_up' then
			if scroll > 1.01 then
				scroll = scroll - 1.01
			end
		end
		if key == 'mouse_wheel_down' then
			if scroll < #help_table - maxItems then
				scroll = scroll + 1.01
			end
		end
	end
end)

function visibleWindow()
	if not helpmoon then
		addEventHandler('onClientRender',root,drawWindow)
		showCursor(true)
	else
		removeEventHandler('onClientRender',root,drawWindow)
		showCursor(false)
	end
	helpmoon = not helpmoon
end
bindKey('F1','down',visibleWindow)