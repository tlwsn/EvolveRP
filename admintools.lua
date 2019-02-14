script_name('Admin Tools')
script_version('1')
script_author('Thomas_Lawson')
script_description('Admin Tools for Evolve RP')
require 'lib.moonloader'
require 'lib.sampfuncs'
local weapons = require 'game.weapons'
local sampev = require 'lib.samp.events'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local key = require 'vkeys'
local Matrix3X3 = require 'matrix3x3'
local Vector3D = require 'vector3d'
local ffi = require 'ffi'
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
local mem = require 'memory'
local screenx, screeny = getScreenResolution()
encoding.default = 'CP1251'
imgui = require 'imgui'
imgui.HotKey = require('imgui_addons').HotKey
imgui.ToggleButton = require('imgui_addons').ToggleButton
rkeys = require 'rkeys'
mainwindow = imgui.ImBool(false)
settingwindows = imgui.ImBool(false)
tpwindow = imgui.ImBool(false)
recon = imgui.ImBool(false)
cmdwindow = imgui.ImBool(false)
local nop = 0x90
u8 = encoding.UTF8
airspeed = nil
reid = '-1'
cwid = nil
admins = {}
checkf = {}
config_keys = {
    banipkey = {v = {190}},
    warningkey = {v = {key.VK_Z}},
    reportkey = {v = {key.VK_X}},
    saveposkey = {v = {key.VK_M}},
    goposkey = {v = {key.VK_J}}
}
frakrang = {
    Mayor = {
        rang_5 = 15,
        inv = 6
    },
    FBI = {
        rang_6 = 18,
        rang_7 = 18,
        rang_8 = 20,
        rang_9 = 25,
        inv = 15
    },
    PD = {
        rang_11 = 6,
        rang_12 = 7,
        rang_13 = 9,
        inv = 6
    },
    Army = {
        rang_12 = 12,
        rang_13 = 12,
        rang_14 = 12,
        inv = 3
    },
    MOH = {
        rang_7 = 7,
        rang_8 = 10,
        rang_9 = 12,
        inv = 3
    },
    Autoschool = {
        rang_7 = 7,
        rang_8 = 9,
        rang_9 = 12,
        inv = 6
    },
    News = {
        rang_7 = 7,
        rang_8 = 8,
        rang_9 = 10,
        inv = 4
    },
    Gangs = {
        rang_7 = 5,
        rang_8 = 8,
        rang_9 = 9,
        inv = 3
    },
    Mafia = {
        rang_7 = 9,
        rang_8 = 10,
        rang_9 = 12,
        inv = 7
    },
    Bikers = {
        rang_5 = 6,
        rang_6 = 7,
        rang_7 = 10,
        rang_8 = 11,
        inv = 4
    }
}
tkills = {}
BulletSync = {lastId = 0, maxLines = 15}
for i = 1, BulletSync.maxLines do
	BulletSync[i] = {enable = true, o = {x, y, z}, t = {x, y, z}, time = 0, tType = 0}
end
local savecoords = {x = 0, y = 0, z = 0}
traceid = -1
players = {}
admins_online = {}
players_online = {}
local funcsStatus = {ClickWarp = false, Inv = false, AirBrk = false}
tLastKeys = {}
data = {
    imgui = {
        menu = 1,
        cheat = 1,
        checker = 1,
        admcheckpos = false,
        reconpos = false
    }
}
config = {
    admchecker = {
        enable = true,
        posx = screenx/2,
        posy = screeny/2
    },
    playerChecker = {
        enable = true,
        posx = screenx/2,
        posy = screeny/2
    },
    cheat = {
        airbrkspeed = 0.5,
        autogm = true
    },
    crecon = {
        posx = screenx/2,
        posy = screeny/2,
        enable = false
    },
    other = {
        password = " ",
        adminpass = " "
    }
}

function atext(text)
    sampAddChatMessage(string.format(' [Admin Tools] {ffffff}%s', text), 0xa1dd4e)
end
function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 2.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0
	-- style.Alpha =
	-- style.WindowPadding =
	-- style.WindowMinSize =
	-- style.FramePadding =
	-- style.ItemInnerSpacing =
	-- style.TouchExtraPadding =
	-- style.IndentSpacing =
	-- style.ColumnsMinSpacing = ?
	-- style.ButtonTextAlign =
	-- style.DisplayWindowPadding =
	-- style.DisplaySafeAreaPadding =
	-- style.AntiAliasedLines =
	-- style.AntiAliasedShapes =
	-- style.CurveTessellationTol =

	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end
function calcScreenCoors(fX,fY,fZ)
    local memory = require 'memory'
	local dwM = 0xB6FA2C

	local m_11 = memory.getfloat(dwM + 0*4)
	local m_12 = memory.getfloat(dwM + 1*4)
	local m_13 = memory.getfloat(dwM + 2*4)
	local m_21 = memory.getfloat(dwM + 4*4)
	local m_22 = memory.getfloat(dwM + 5*4)
	local m_23 = memory.getfloat(dwM + 6*4)
	local m_31 = memory.getfloat(dwM + 8*4)
	local m_32 = memory.getfloat(dwM + 9*4)
	local m_33 = memory.getfloat(dwM + 10*4)
	local m_41 = memory.getfloat(dwM + 12*4)
	local m_42 = memory.getfloat(dwM + 13*4)
	local m_43 = memory.getfloat(dwM + 14*4)

	local dwLenX = memory.read(0xC17044, 4)
	local dwLenY = memory.read(0xC17048, 4)

	frX = fZ * m_31 + fY * m_21 + fX * m_11 + m_41
	frY = fZ * m_32 + fY * m_22 + fX * m_12 + m_42
	frZ = fZ * m_33 + fY * m_23 + fX * m_13 + m_43

	fRecip = 1.0/frZ
	frX = frX * (fRecip * dwLenX)
	frY = frY * (fRecip * dwLenY)

    if(frX<=dwLenX and frY<=dwLenY and frZ>1)then
        return frX, frY, frZ
	else
		return -1, -1, -1
	end
end
ffi.cdef[[
struct stKillEntry
{
	char					szKiller[25];
	char					szVictim[25];
	uint32_t				clKillerColor; // D3DCOLOR
	uint32_t				clVictimColor; // D3DCOLOR
	uint8_t					byteType;
} __attribute__ ((packed));

struct stKillInfo
{
	int						iEnabled;
	struct stKillEntry		killEntry[5];
	int 					iLongestNickLength;
  	int 					iOffsetX;
  	int 					iOffsetY;
	void			    	*pD3DFont; // ID3DXFont
	void		    		*pWeaponFont1; // ID3DXFont
	void		   	    	*pWeaponFont2; // ID3DXFont
	void					*pSprite;
	void					*pD3DDevice;
	int 					iAuxFontInited;
    void 		    		*pAuxFont1; // ID3DXFont
    void 			    	*pAuxFont2; // ID3DXFont
} __attribute__ ((packed));
bool DwmEnableComposition(int uCompositionAction);
]]
function main()
    local samp = getModuleHandle('samp.dll')
	mem.fill(samp + 0x9D31A, nop, 12, true)
	mem.fill(samp + 0x9D329, nop, 12, true)
    while not isSampAvailable() do wait(0) end
    cfg = inicfg.load(config, 'Admin Tools\\config.ini')
    lua_thread.create(wh)
    sampRegisterChatCommand('al', function() sampSendChat('/alogin') end)
    sampRegisterChatCommand('at_reload', function() showCursor(false); nameTagOn(); thisScript():reload() end)
    sampRegisterChatCommand('checkrangs', checkrangs)
    sampRegisterChatCommand('spiar', function() sampSendChat('/o Есть вопросы по игре? Задайте их нашим саппортам - /ask') end)
    sampRegisterChatCommand('fonl', fonl)
    sampRegisterChatCommand('kills', kills)
    sampRegisterChatCommand('cbug', cbug)
    sampRegisterChatCommand('sbiv', sbiv)
    sampRegisterChatCommand('csbiv', csbiv)
    sampRegisterChatCommand('gs', gs)
    sampRegisterChatCommand('ags', ags)
    sampRegisterChatCommand('wl', wl)
    sampRegisterChatCommand('gun', gun)
    sampRegisterChatCommand('ban', ban)
    sampRegisterChatCommand('warn', warn)
    sampRegisterChatCommand('at', function() mainwindow.v = not mainwindow.v end)
    sampRegisterChatCommand('addadm', addadm)
    sampRegisterChatCommand('tr', tr)
    sampRegisterChatCommand('addplayer', addplayer)
    sampRegisterChatCommand('delplayer', delplayer)
    sampRegisterChatCommand('deladm', deladm)
    initializeRender()
    apply_custom_style()
    loadadmins()
    if not doesFileExist("moonloader/config/Admin Tools/keys.json") then
        local fa = io.open("moonloader/config/Admin Tools/keys.json", "w")
        fa:close()
    else
        local fa = io.open("moonloader/config/Admin Tools/keys.json", 'r')
        if fa then
            config_keys = decodeJson(fa:read('*a'))
        end
    end
    if not doesFileExist("moonloader/config/Admin Tools/rangset.json") then
        local fr = io.open("moonloader/config/Admin Tools/rangset.json", "w")
        fr:write(encodeJson(frakrang))
        fr:close()
    else
        local fr = io.open("moonloader/config/Admin Tools/rangset.json", 'r')
        if fr then
            frakrang = decodeJson(fr:read('*a'))
        end
    end
    reportbind = rkeys.registerHotKey(config_keys.reportkey.v, true, reportk)
    warningbind = rkeys.registerHotKey(config_keys.warningkey.v, true, warningk)
    banipbind = rkeys.registerHotKey(config_keys.banipkey.v, true, banipk)
    saveposbind = rkeys.registerHotKey(config_keys.saveposkey.v, true, saveposk)
    goposbind = rkeys.registerHotKey(config_keys.goposkey.v, true, goposk)
    if cfg.cheat.autogm then
        funcsStatus.Inv = true
    end
	font = renderCreateFont("Arial", 9, 5)
	for k, v in ipairs(admins) do
		local id = sampGetPlayerIdByNickname(v)
		if id ~= nil then
			table.insert(admins_online, {nick = v, id = id})
		end
    end
    for k, v in ipairs(players) do
		local id = sampGetPlayerIdByNickname(v)
		if id ~= nil then
			table.insert(players_online, {nick = v, id = id})
		end
	end
    lua_thread.create(clickF)
    lua_thread.create(renderChecker)
    lua_thread.create(check_keystrokes)
    lua_thread.create(main_funcs)
    lua_thread.create(check_keys_fast)
    while true do wait(0)
        if #tkills > 50 then
            table.remove(tkills, 1)
        end
        warningsKey()
        local oTime = os.time()
        if not isPauseMenuActive() then
			for i = 1, BulletSync.maxLines do
				if BulletSync[i].enable == true and BulletSync[i].time >= oTime then
					local sx, sy, sz = calcScreenCoors(BulletSync[i].o.x, BulletSync[i].o.y, BulletSync[i].o.z)
					local fx, fy, fz = calcScreenCoors(BulletSync[i].t.x, BulletSync[i].t.y, BulletSync[i].t.z)
					if sz > 1 and fz > 1 then
						renderDrawLine(sx, sy, fx, fy, 1, BulletSync[i].tType == 0 and 0xFF0000FF or 0xffff0000)
                        renderDrawPolygon(fx, fy-1, 3, 3, 4.0, 10, BulletSync[i].tType == 0 and 0xFF0000FF or 0xffff0000)
					end
				end
			end
        end
        if data.imgui.reconpos then
            recon.v = true
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.crecon.posx = curX
            cfg.crecon.posy = curY
        end
        if data.imgui.admcheckpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.admchecker.posx = curX
            cfg.admchecker.posy = curY
        end
        if data.imgui.playercheckpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.playerChecker.posx = curX
            cfg.playerChecker.posy = curY
        end
        if isKeyJustPressed(key.VK_LBUTTON) and (data.imgui.admcheckpos or data.imgui.playercheckpos or data.imgui.reconpos) then
            data.imgui.admcheckpos = false
            data.imgui.playercheckpos = false
            data.imgui.reconpos = false
            recon.v = false
            sampToggleCursor(false)
            mainwindow.v = true
            inicfg.save(config, 'Admin Tools\\config.ini')
        end
        imgui.Process = mainwindow.v or recon.v
    end
end
function imgui.TextQuestion(text)
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end
function imgui.TeleportButton(text, coordx, coordy, coordz, interior)
    if imgui.MenuItem(u8('  '..text)) then
        setCharCoordinates(PLAYER_PED, coordx, coordy, coordz)
        setCharInterior(PLAYER_PED, interior)
        setInteriorVisible(interior)
    end
end
function imgui.CentrText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end
function rkeys.onHotKey(id, keys)
    if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
        return false
    end
end
function imgui.OnDrawFrame()
    if recon.v then
        imgui.ShowCursor = false
        local ImVec4 = imgui.ImVec4
        local imvsize = imgui.GetWindowSize()
        local spacing, height = 140.0, 162.0
        local imkx, imky = convertGameScreenCoordsToWindowScreenCoords(530, 199)
        imgui.SetNextWindowPos(imgui.ImVec2(cfg.crecon.posx, cfg.crecon.posy), imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(260, 280), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Слежка за игроком', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
        imgui.CentrText(imtextnick)
        imgui.CentrText(('ID: %s'):format(reid))
        if reafk then
            imgui.SameLine()
            imgui.TextColored(ImVec4(255, 0, 0, 1),'AFK')
        end
        imgui.Separator()
        imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1.0, 2.5))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Level:"); imgui.SameLine(spacing); imgui.Text(imtextlvl)
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Warns:"); imgui.SameLine(spacing); imgui.Text(imtextwarn)
        imgui.TextColored(ImVec4(255, 0, 0, 1), u8"Armour:"); imgui.SameLine(spacing); imgui.Text(imtextarm)
        imgui.TextColored(ImVec4(255, 0, 0, 1), u8"Health:"); imgui.SameLine(spacing); imgui.Text(imtexthp)
        imgui.TextColored(ImVec4(0, 49, 245, 1), u8"Car HP:"); imgui.SameLine(spacing); imgui.Text(imtextcarhp)
        imgui.TextColored(ImVec4(0, 49, 245, 1), u8"Speed:"); imgui.SameLine(spacing); imgui.Text(imtextspeed)
        imgui.TextColored(ImVec4(255, 255, 0, 1), u8"Ping:"); imgui.SameLine(spacing); imgui.Text(imtextping)
        imgui.TextColored(ImVec4(255, 255, 0, 1), u8"Ammo:"); imgui.SameLine(spacing); imgui.Text(imtextammo)
        imgui.TextColored(ImVec4(225, 0, 255, 1), u8"Shot:"); imgui.SameLine(spacing); imgui.Text(imtextshot)
        imgui.TextColored(ImVec4(225, 0, 255, 1), u8"Time Shot:"); imgui.SameLine(spacing); imgui.Text(imtexttimeshot)
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"AFK Time:"); imgui.SameLine(spacing); imgui.Text(imtextafktime)
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Engine:"); imgui.SameLine(spacing); imgui.Text(imtextengine)
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Pro Sport:"); imgui.SameLine(spacing); imgui.Text(imtextprosport)
        imgui.PopStyleVar()
        --[[imgui.SameLine()
        imgui.Text(string.format('%s', imgui.GetWindowSize().y))]]
        imgui.End()
    end
    if mainwindow.v then
        imgui.LockPlayer = true
        imgui.ShowCursor = true
        local btn_size = imgui.ImVec2(-0.1, 0)
        imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin('Admin Tools', mainwindow, imgui.WindowFlags.NoResize)
        if imgui.Button(u8 'Настройки', btn_size) then settingwindows.v = not settingwindows.v end
        if imgui.Button(u8 'Телепорты', btn_size) then tpwindow.v = not tpwindow.v end
        if imgui.Button(u8 'Команды скрипта', btn_size) then cmdwindow.v = not cmdwindow.v end
        imgui.End()
        if cmdwindow.v then
            imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8'Admin Tools | Команды', cmdwindow)
            if imgui.CollapsingHeader('/at_reload', btn_size) then
                imgui.TextWrapped(u8 'Описание: Перезагрузить скрипт')
                imgui.TextWrapped(u8 'Использование: /at_reload')
            end
            if imgui.CollapsingHeader('/al', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /alogin')
                imgui.TextWrapped(u8 'Использование: /al')
            end
            if imgui.CollapsingHeader('/spiar', btn_size) then
                imgui.TextWrapped(u8 'Описание: Написать пиар /ask в /o чат')
                imgui.TextWrapped(u8 'Использование: /spiar')
            end
            if imgui.CollapsingHeader('/fonl', btn_size) then
                imgui.TextWrapped(u8 'Описание: Узнать кол-во людей онлайн во фракции')
                imgui.TextWrapped(u8 'Использование: /fonl [id фракции]')
            end
            if imgui.CollapsingHeader('/checkrangs', btn_size) then
                imgui.TextWrapped(u8 'Описание: Проверить фракцию на несовпадения LVL - Ранг')
                imgui.TextWrapped(u8 'Использование: /checkrangs [id фракции]')
            end
            if imgui.CollapsingHeader('/gs', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /getstats')
                imgui.TextWrapped(u8 'Использование: /gs [id]')
            end
            if imgui.CollapsingHeader('/ags', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /agetstats')
                imgui.TextWrapped(u8 'Использование: /ags [id/nick]')
            end
            if imgui.CollapsingHeader('/sbiv', btn_size) then
                imgui.TextWrapped(u8 'Описание: Посадить игрока на 30 минут в деморган по причине "Сбив анимации"')
                imgui.TextWrapped(u8 'Использование: /sbiv [id]')
            end
            if imgui.CollapsingHeader('/csbiv', btn_size) then
                imgui.TextWrapped(u8 'Описание: Посадить игрока на 60 минут в деморган по причине "Сбив анимации"')
                imgui.TextWrapped(u8 'Использование: /csbiv [id]')
            end
            if imgui.CollapsingHeader('/cbug', btn_size) then
                imgui.TextWrapped(u8 'Описание: Посадить игрока на 60 минут в деморган по причине "+с вне гетто"')
                imgui.TextWrapped(u8 'Использование: /cbug [id]')
            end
            if imgui.CollapsingHeader('/kills', btn_size) then
                imgui.TextWrapped(u8 'Описание: Узнать 50 последний убийств из килл-листа')
                imgui.TextWrapped(u8 'Использование: /kills')
            end
            if imgui.CollapsingHeader('/wl', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /warnlog')
                imgui.TextWrapped(u8 'Использование: /wl [id/nick]')
            end
            if imgui.CollapsingHeader('/tr', btn_size) then
                imgui.TextWrapped(u8 'Описание: Переключить трейсера на определенного игрока')
                imgui.TextWrapped(u8 'Использование: /tr [id]')
            end
            if imgui.CollapsingHeader('/addadm', btn_size) then
                imgui.TextWrapped(u8 'Описание: Добавить игрока в чекер админов')
                imgui.TextWrapped(u8 'Использование: /addadm [id/nick]')
            end
            if imgui.CollapsingHeader('/addplayer', btn_size) then
                imgui.TextWrapped(u8 'Описание: Добавить игрока в чекер игроков')
                imgui.TextWrapped(u8 'Использование: /addplayer [id/nick]')
            end
            if imgui.CollapsingHeader('/deladm', btn_size) then
                imgui.TextWrapped(u8 'Описание: Удалить игрока из чекера админов')
                imgui.TextWrapped(u8 'Использование: /deladm [id/nick]')
            end
            if imgui.CollapsingHeader('/delplayer', btn_size) then
                imgui.TextWrapped(u8 'Описание: Удалить игрока из чекера игроков')
                imgui.TextWrapped(u8 'Использование: /delplayer [id/nick]')
            end
            imgui.End()
        end
        if tpwindow.v then
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2+350, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
            imgui.Begin(u8 'Admin Tools | Телепорты', tpwindow)
            if imgui.CollapsingHeader(u8 'Общественные места') then
                imgui.TeleportButton('Автовокзал ЛС', 1154.2769775391, -1756.1109619141, 13.634266853333, 0)
                imgui.TeleportButton('Автовокзал СФ', -1985.5826416016, 137.61878967285, 27.6875, 0)
                imgui.TeleportButton('Автовокзал ЛВ', 2838.7587890625, 1291.5477294922, 11.390625, 0)
                imgui.TeleportButton('Пейнтбол', 2586.6628417969, 2788.6235351563, 10.8203125, 0)
                imgui.TeleportButton('Бейсджамп', 1577.3891601563, -1331.9245605469, 16.484375, 0)
                imgui.TeleportButton('Центр регистрации семей', 2356.6359863281, 2377.3544921875, 10.8203125, 0)
                imgui.TeleportButton('Казино 4 дракона', 2030.9317626953, 1009.9556274414, 10.8203125, 0)
                imgui.TeleportButton('Казино калигула', 2177.9311523438, 1676.1583251953, 10.8203125, 0)
                imgui.TeleportButton('Наркопритон', 2196.3066, -1682.1842, 14.0373, 0)
            end
            if imgui.CollapsingHeader(u8 'Гос. фракции') then
                imgui.TeleportButton('LSPD', 1544.1212158203, -1675.3117675781, 13.557789802551, 0)
                imgui.TeleportButton('SFPD', -1606.0246582031, 719.93884277344, 12.054424285889, 0)
                imgui.TeleportButton('LVPD', 2333.9365234375, 2455.9772949219, 14.96875, 0)
                imgui.TeleportButton('FBI', -2444.9887695313, 502.21490478516, 30.094774246216, 0)
                imgui.TeleportButton('Армия СФ', -1335.8016357422, 471.39276123047, 7.1875, 0)
                imgui.TeleportButton('Армия ЛВ', 209.3503112793, 1916.1086425781, 17.640625, 0)
                imgui.TeleportButton('Мэрия', 1478.6057128906, -1738.2475585938, 13.546875, 0)
                imgui.TeleportButton('Автошкола', -2032.9953613281, -84.548896789551, 35.82837677002, 0)
            end
            if imgui.CollapsingHeader(u8 'Гетто') then
                imgui.TeleportButton('Rifa', 2184.4729003906, -1807.0772705078, 13.372615814209, 0)
                imgui.TeleportButton('Grove', 2492.5004882813, -1675.2270507813, 13.335947036743, 0)
                imgui.TeleportButton('Vagos', 2780.037109375, -1616.1085205078, 10.921875, 0)
                imgui.TeleportButton('Ballas', 2645.5832519531, -2009.6373291016, 13.5546875, 0)
                imgui.TeleportButton('Aztec', 1679.7568359375, -2112.7685546875, 13.546875, 0)
            end
            if imgui.CollapsingHeader(u8 'Мафии') then
                imgui.TeleportButton('RM', 948.29113769531, 1732.6284179688, 8.8515625, 0)
                imgui.TeleportButton('Yakuza', 1462.0941162109, 2773.9204101563, 10.8203125, 0)
                imgui.TeleportButton('LCN', 1448.5999755859, 752.29913330078, 11.0234375)
            end
            if imgui.CollapsingHeader(u8 'Новости') then
                imgui.TeleportButton('Los Santos News', 1658.7456054688, -1694.8518066406, 15.609375, 0)
                imgui.TeleportButton('San Fierro News', -2047.3449707031, 462.86468505859, 35.171875, 0)
                imgui.TeleportButton('Las Venturas News', 2647.6062011719, 1182.9040527344, 10.8203125, 0)
            end
            if imgui.CollapsingHeader(u8 'Байкеры') then
                imgui.TeleportButton('Warlocks MC', 657.96783447266, 1724.9599609375, 6.9921875, 0)
                imgui.TeleportButton('Pagans MC', -236.41778564453, 2602.8095703125, 62.703125, 0)
                imgui.TeleportButton('Mongols MC', 682.31365966797, -478.36148071289, 16.3359375, 0)
            end
            if imgui.CollapsingHeader(u8 'Работы') then
                imgui.TeleportButton('Такси 5+ скилла', 2460.7641601563, 1339.7041015625, 10.8203125, 0)
                imgui.TeleportButton('Грузчики', 2191.8410644531, -2255.1296386719, 13.533205986023, 0)
                imgui.TeleportButton('Стоянка хотдогов', -2462.2663574219, 717.34100341797, 35.009593963623, 0)
                imgui.TeleportButton('Стоянка механиков в ЛС', -87.400039672852, -1183.9016113281, 1.8439817428589, 0)
                imgui.TeleportButton('Стоянка механиков в СФ', -1915.9177246094, 286.88238525391, 41.046875, 0)
                imgui.TeleportButton('Стоянка механиков в ЛВ', 2131.244140625, 954.09143066406, 10.8203125, 0)
                imgui.TeleportButton('Склад продуктов', -495.78558349609, -486.47967529297, 25.517845153809, 0)
                imgui.TeleportButton('Дальнобойщики', 2382.5662, 2752.3003, 10.8203, 0)
            end
            if imgui.CollapsingHeader(u8 'Интерьеры') then
                imgui.TeleportButton('24/7 1', -25.884498,-185.868988,1003.546875, 17)
                imgui.TeleportButton('24/7 2', 6.091179,-29.271898,1003.549438, 10)
                imgui.TeleportButton('24/7 3', -30.946699,-89.609596,1003.546875, 18)
                imgui.TeleportButton('24/7 4', -25.132598,-139.066986,1003.546875, 16)
                imgui.TeleportButton('24/7 5', -27.312299,-29.277599,1003.557250, 4)
                imgui.TeleportButton('24/7 6', -26.691598,-55.714897,1003.546875, 6)
                imgui.TeleportButton('Airport ticket desk', -1827.147338,7.207417,1061.143554, 14)
                imgui.TeleportButton('Airport baggage reclaim', -1861.936889,54.908092,1061.143554, 14)
                imgui.TeleportButton('Shamal', 1.808619,32.384357,1199.593750, 1)
                imgui.TeleportButton('Andromada', 315.745086,984.969299,1958.919067, 9)
                imgui.TeleportButton('Ammunation 1', 286.148986,-40.644397,1001.515625, 1)
                imgui.TeleportButton('Ammunation 2', 286.800994,-82.547599,1001.515625, 4)
                imgui.TeleportButton('Ammunation 3', 296.919982,-108.071998,1001.515625, 6)
                imgui.TeleportButton('Ammunation 4', 314.820983,-141.431991,999.601562, 7)
                imgui.TeleportButton('Ammunation 5', 316.524993,-167.706985,999.593750, 6)
                imgui.TeleportButton('Ammunation booths', 302.292877,-143.139099,1004.062500, 7)
                imgui.TeleportButton('Ammunation range', 298.507934,-141.647048,1004.054748, 7)
                imgui.TeleportButton('Blastin fools hallway', 1038.531372,0.111030,1001.284484, 3)
                imgui.TeleportButton('Budget inn motel room', 444.646911,508.239044,1001.419494, 12)
                imgui.TeleportButton('Jefferson motel', 2215.454833,-1147.475585,1025.796875, 15)
                imgui.TeleportButton('Off track betting shop', 833.269775,10.588416,1004.179687, 3)
                imgui.TeleportButton('Sex shop', -103.559165,-24.225606,1000.718750, 3)
                imgui.TeleportButton('Meat factory', 963.418762,2108.292480,1011.030273, 1)
                imgui.TeleportButton("Zero's RC shop", -2240.468505,137.060440,1035.414062, 6)
                imgui.TeleportButton('Dillimore gas station', 663.836242,-575.605407,16.343263, 0)
                imgui.TeleportButton("Catigula's basement", 2169.461181,1618.798339,999.976562, 1)
                imgui.TeleportButton("FDC Janitors room", 1889.953369,1017.438293,31.882812, 10)
                imgui.TeleportButton("Woozie's office", -2159.122802,641.517517,1052.381713, 1)
                imgui.TeleportButton("Binco", 207.737991,-109.019996,1005.132812, 15)
                imgui.TeleportButton("Didier sachs", 204.332992,-166.694992,1000.523437, 14)
                imgui.TeleportButton("Prolaps", 207.054992,-138.804992,1003.507812, 3)
                imgui.TeleportButton("Suburban", 203.777999,-48.492397,1001.804687, 1)
                imgui.TeleportButton("Victim", 226.293991,-7.431529,1002.210937, 5)
                imgui.TeleportButton("Zip", 161.391006,-93.159156,1001.804687, 18)
                imgui.TeleportButton("Club", 493.390991,-22.722799,1000.679687, 17)
                imgui.TeleportButton("Bar", 501.980987,-69.150199,998.757812, 11)
                imgui.TeleportButton("Lil' probe inn", -227.027999,1401.229980,27.765625, 18)
                imgui.TeleportButton("Jay's diner", 457.304748,-88.428497,999.554687, 4)
                imgui.TeleportButton("Gant bridge diner", 454.973937,-110.104995,1000.077209, 5)
                imgui.TeleportButton("Secret valley diner", 435.271331,-80.958938,999.554687, 6)
                imgui.TeleportButton("World of coq", 452.489990,-18.179698,1001.132812, 1)
                imgui.TeleportButton("Welcome pump", 681.557861,-455.680053,-25.609874, 1)
                imgui.TeleportButton("Burger shot", 375.962463,-65.816848,1001.507812, 10)
                imgui.TeleportButton("Cluckin' bell", 369.579528,-4.487294,1001.858886, 9)
                imgui.TeleportButton("Well stacked pizza", 373.825653,-117.270904,1001.499511, 5)
                imgui.TeleportButton("Rusty browns donuts", 381.169189,-188.803024,1000.632812, 17)
                imgui.TeleportButton("Denise room", 244.411987,305.032989,999.148437, 1)
                imgui.TeleportButton("Katie room", 271.884979,306.631988,999.148437, 2)
                imgui.TeleportButton("Helena room", 291.282989,310.031982,999.148437, 3)
                imgui.TeleportButton("Michelle room", 302.180999,300.722991,999.14843, 4)
                imgui.TeleportButton("Barbara room", 322.197998,302.497985,999.14843, 5)
                imgui.TeleportButton("Millie room", 346.870025,309.259033,999.155700, 6)
                imgui.TeleportButton("Sherman dam", -959.564392,1848.576782,9.000000, 17)
                imgui.TeleportButton("Planning dept.", 384.808624,173.804992,1008.382812, 3)
                imgui.TeleportButton("Area 51", 223.431976,1872.400268,13.734375, 0)
                imgui.TeleportButton("LS gym", 772.111999,-3.898649,1000.728820, 5)
                imgui.TeleportButton("SF gym", 774.213989,-48.924297,1000.585937, 6)
                imgui.TeleportButton("LV gym", 773.579956,-77.096694,1000.655029, 7)
                imgui.TeleportButton("B Dup's house", 1527.229980,-11.574499,1002.097106, 3)
                imgui.TeleportButton("B Dup's crack pad", 1523.509887,-47.821197,1002.130981, 2)
                imgui.TeleportButton("Cj's house", 2496.049804,-1695.238159,1014.742187, 3)
                imgui.TeleportButton("Madd Doggs mansion", 1267.663208,-781.323242,1091.906250, 5)
                imgui.TeleportButton("Og Loc's house", 513.882507,-11.269994,1001.565307, 3)
                imgui.TeleportButton("Ryders house", 2454.717041,-1700.871582,1013.515197, 2)
                imgui.TeleportButton("Sweet's house", 2527.654052,-1679.388305,1015.498596, 1)
                imgui.TeleportButton("Crack factory", 2543.462646,-1308.379882,1026.728393, 2)
                imgui.TeleportButton("Big spread ranch", 1212.019897,-28.663099,1000.953125	, 3)
                imgui.TeleportButton("Fanny batters", 761.412963,1440.191650,1102.703125, 6)
                imgui.TeleportButton("Strip club", 1204.809936,-11.586799,1000.921875, 2)
                imgui.TeleportButton("Strip club private room", 1204.809936,13.897239,1000.921875, 2)
                imgui.TeleportButton("Unnamed brothel", 942.171997,-16.542755,1000.929687, 3)
                imgui.TeleportButton("Tiger skin brothel", 964.106994,-53.205497,1001.124572, 3)
                imgui.TeleportButton("Pleasure domes", -2640.762939,1406.682006,906.460937, 3)
                imgui.TeleportButton("Liberty city outside", -729.276000,503.086944,1371.971801, 1)
                imgui.TeleportButton("Liberty city inside", -794.806396,497.738037,1376.195312, 1)
                imgui.TeleportButton("Gang house", 2350.339843,-1181.649902,1027.976562, 5)
                imgui.TeleportButton("Colonel Furhberger's", 2807.619873,-1171.899902,1025.570312, 8)
                imgui.TeleportButton("Crack den", 318.564971,1118.209960,1083.882812, 5)
                imgui.TeleportButton("Warehouse 1", 1412.639892,-1.787510,1000.924377, 1)
                imgui.TeleportButton("Warehouse 2", 1302.519897,-1.787510,1001.028259, 18)
                imgui.TeleportButton("Sweets garage", 2522.000000,-1673.383911,14.866223, 0)
                imgui.TeleportButton("Lil' probe inn toilet", -221.059051,1408.984008,27.773437, 18)
                imgui.TeleportButton("Unused safe house", 2324.419921,-1145.568359,1050.710083, 12)
                imgui.TeleportButton("RC Battlefield", -975.975708,1060.983032,1345.671875, 10)
                imgui.TeleportButton("Barber 1", 411.625976,-21.433298,1001.804687, 2)
                imgui.TeleportButton("Barber 2", 418.652984,-82.639793,1001.804687, 3)
                imgui.TeleportButton("Barber 3", 412.021972,-52.649898,1001.898437, 12)
                imgui.TeleportButton("Tatoo parlour 1", -204.439987,-26.453998,1002.273437, 16)
                imgui.TeleportButton("Tatoo parlour 2", -204.439987,-8.469599,1002.273437, 17)
                imgui.TeleportButton("Tatoo parlour 3", -204.439987,-43.652496,1002.273437, 3)
                imgui.TeleportButton("LS police HQ", 246.783996,63.900199,1003.640625, 6)
                imgui.TeleportButton("SF police HQ", 246.375991,109.245994,1003.218750, 10)
                imgui.TeleportButton("LV police HQ", 288.745971,169.350997,1007.171875, 3)
                imgui.TeleportButton("Car school", -2029.798339,-106.675910,1035.171875, 3)
                imgui.TeleportButton("8-Track", -1398.065307,-217.028900,1051.115844, 7)
                imgui.TeleportButton("Bloodbowl", -1398.103515,937.631164,1036.479125, 15)
                imgui.TeleportButton("Dirt track", -1444.645507,-664.526000,1053.572998, 4)
                imgui.TeleportButton("Kickstart", -1465.268676,1557.868286,1052.531250, 14)
                imgui.TeleportButton("Vice stadium", -1401.829956,107.051300,1032.273437, 1)
                imgui.TeleportButton("SF Garage", -1790.378295,1436.949829,7.187500, 0)
                imgui.TeleportButton("LS Garage", 1643.839843,-1514.819580,13.566620, 0)
                imgui.TeleportButton("SF Bomb shop", -1685.636474,1035.476196,45.210937, 0)
                imgui.TeleportButton("Blueberry warehouse", 76.632553,-301.156829,1.578125, 0)
                imgui.TeleportButton("LV Warehouse 1", 1059.895996,2081.685791,10.820312, 0)
                imgui.TeleportButton("LV Warehouse 2 (hidden part)", 1059.180175,2148.938720,10.820312, 0)
                imgui.TeleportButton("Catigula's hidden room", 2131.507812,1600.818481,1008.359375, 1)
                imgui.TeleportButton("Bank", 2315.952880,-1.618174,26.742187, 0)
                imgui.TeleportButton("Bank (behind desk)", 2319.714843,-14.838361,26.749565, 0)
                imgui.TeleportButton("LS Atruim", 1710.433715,-1669.379272,20.225049, 18)
                imgui.TeleportButton("Bike School", 1494.325195,1304.942871,1093.289062, 3)
            end
            imgui.End()
        end
        if settingwindows.v then
            imgui.SetNextWindowPos(imgui.ImVec2(screenx / 2, screeny / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(15,6))
            imgui.Begin(u8 'Настройки', settingwindows, imgui.WindowFlags.NoResize)
            imgui.BeginChild('##set', imgui.ImVec2(200, 400), true)
            if imgui.Selectable(u8 'Настройка клавиш') then data.imgui.menu = 1 end
            if imgui.Selectable(u8 'Настройка читов') then data.imgui.menu = 2 end
            if data.imgui.menu == 2 then
                if imgui.MenuItem(u8 '  AirBrake') then data.imgui.cheat = 1 end
                if imgui.MenuItem(u8 '  GodMode') then data.imgui.cheat = 2 end
                if imgui.MenuItem(u8 '  WallHack') then data.imgui.cheat = 3 end
            end
            if imgui.Selectable(u8 'Настройка чекеров') then data.imgui.menu = 3 end
            if data.imgui.menu == 3 then
                if imgui.MenuItem(u8 '  Чекер админов') then data.imgui.checker = 1 end
                if imgui.MenuItem(u8 '  Чекер игроков') then data.imgui.checker = 2 end
            end
            imgui.EndChild()
            imgui.SameLine()
            imgui.BeginChild('##set1', imgui.ImVec2(740, 400), true)
            if data.imgui.menu == 1 then
                local creconB = imgui.ImBool(cfg.crecon.enable)
                if imgui.HotKey('##warningkey', config_keys.warningkey, tLastKeys, 100) then
                    rkeys.changeHotKey(warningbind, config_keys.warningkey.v)
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша перехода по варнингам')
                if imgui.HotKey('##reportkey', config_keys.reportkey, tLastKeys, 100) then
                    rkeys.changeHotKey(reportbind, config_keys.reportkey.v)
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша перехода по репорту')
                if imgui.HotKey('##banipkey', config_keys.banipkey, tLastKeys, 100) then
                    rkeys.changeHotKey(banipbind, config_keys.banipkey.v)
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша бана IP адреса')
                if imgui.HotKey('##saveposkey', config_keys.saveposkey, tLastKeys, 100) then
                    rkeys.changeHotKey(saveposbind, config_keys.saveposkey.v)
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша сохранения координат')
                if imgui.HotKey('##goposkey', config_keys.goposkey, tLastKeys, 100) then
                    rkeys.changeHotKey(goposbind, config_keys.goposkey.v)
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша телепорта на сохраненные координаты')
                imgui.Text(u8 'Местоположение рекона')
                imgui.SameLine()
                if imgui.Button(u8 'Изменить##3') then data.imgui.reconpos = true; mainwindow.v = false end
                if imgui.ToggleButton(u8 'Включить замененный рекон##1', creconB) then cfg.crecon.enable = creconB.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Включить замененный рекон')
            elseif data.imgui.menu == 2 then
                if data.imgui.cheat == 1 then
                    imgui.CentrText(u8 'AirBrake')
                    imgui.Separator()
                elseif data.imgui.cheat == 2 then
                    local godModeB = imgui.ImBool(cfg.cheat.autogm)
                    imgui.CentrText(u8 'GodMode')
                    imgui.Separator()
                    if imgui.ToggleButton(u8 'Включить чекер##1', godModeB) then cfg.cheat.autogm = godModeB.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Автоматически включать ГМ при входе в игру')
                elseif data.imgui.cheat == 3 then
                    imgui.CentrText(u8 'WallHack')
                    imgui.Separator()
                end
            elseif data.imgui.menu == 3 then
                if data.imgui.checker == 1 then
                    local admCheckerB = imgui.ImBool(cfg.admchecker.enable)
                    imgui.CentrText(u8 'Чекер админов')
                    imgui.Separator()
                    if imgui.ToggleButton(u8 'Включить чекер##1', admCheckerB) then cfg.admchecker.enable = admCheckerB.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Включить чекер')
                    if cfg.admchecker.enable then
                        imgui.Text(u8 'Местоположение чекера')
                        imgui.SameLine()
                        if imgui.Button(u8 'Изменить##1') then data.imgui.admcheckpos = true; mainwindow.v = false end
                    end
                elseif data.imgui.checker == 2 then
                    local playerCheckerB = imgui.ImBool(cfg.playerChecker.enable)
                    imgui.CentrText(u8 'Чекер игроков')
                    imgui.Separator()
                    if imgui.ToggleButton(u8 'Включить чекер##2', playerCheckerB) then cfg.playerChecker.enable = playerCheckerB.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Включить чекер')
                    if cfg.playerChecker.enable then
                        imgui.Text(u8 'Местоположение чекера')
                        imgui.SameLine()
                        if imgui.Button(u8 'Изменить##2') then data.imgui.playercheckpos = true; mainwindow.v = false end
                    end
                end
            end
            imgui.EndChild()
            imgui.End()
        end
    end
end
function getFrak(frak)
    if frak:match('.+ Gang') then
        frak = frak:match('(.+) Gang')
    end
    return frak
end
function getRank(frak, rang)
    local trangs = {}
    if frak == 'Mayor' then
        trangs = {
            ['Секретарь'] = 1,
            ['Охранник'] = 2,
            ['Адвокат'] = 3,
            ['Начальник охраны'] = 4,
            ['Зам. Мэра'] = 5,
            ['Мэр'] = 6
        }
    end
    if frak == 'LSPD' or frak == 'SFPD' or frak == 'LVPD' then
        trangs = {
            ['Кадет'] = 1,
            ['Офицер'] = 2,
            ['Мл.Сержант'] = 3,
            ['Сержант'] = 4,
            ['Прапорщик'] = 5,
            ['Ст.Прапорщик'] = 6,
            ['Мл.Лейтенант'] = 7,
            ['Лейтенант'] = 8,
            ['Ст.Лейтенант'] = 9,
            ['Капитан'] = 10,
            ['Майор'] = 11,
            ['Подполковник'] = 12,
            ['Полковник'] = 13,
            ['Шериф'] = 14,
        }
    end
    if frak == 'LS News' or frak == 'SF News' or frak == 'LV News' then
        trangs = {
            ['Стажер'] = 1,
            ['Звукооператор'] = 2,
            ['Звукорежиссер'] = 3,
            ['Репортер'] = 4,
            ['Ведущий'] = 5,
            ['Редактор'] = 6,
            ['Гл.Редактор'] = 7,
            ['Тех.Директор'] = 8,
            ['Программный директор'] = 9,
            ['Ген.Директор'] = 10,
        }
    end
    if frak == 'LVA' or frak == 'SFA' then
        trangs = {
            ['Рядовой'] = 1,
            ['Ефрейтор'] = 2,
            ['Мл.Сержант'] = 3,
            ['Сержант'] = 4,
            ['Ст.Сержант'] = 5,
            ['Старшина'] = 6,
            ['Прапорщик'] = 7,
            ['Мл.Лейтенант'] = 8,
            ['Лейтенант'] = 9,
            ['Ст.Лейтенант'] = 10,
            ['Капитан'] = 11,
            ['Майор'] = 12,
            ['Подполковник'] = 13,
            ['Полковник'] = 14,
            ['Генерал'] = 15
        }
    end
    if frak == 'FBI' then
        trangs = {
            ['Стажёр'] = 1,
            ['Дежурный'] = 2,
            ['Мл.Агент'] = 3,
            ['Агент DEA'] = 4,
            ['Агент CID'] = 5,
            ['Глава DEA'] = 6,
            ['Глава CID'] = 7,
            ['Инспектор FBI'] = 8,
            ['Зам.Директора FBI'] = 9,
            ['Директор FBI'] = 10,
        }
    end
    if frak == 'Hospital' then
        trangs = {
            ['Интерн'] = 1,
            ['Санитар'] = 2,
            ['Мед.Брат'] = 3,
            ['Спасатель'] = 4,
            ['Нарколог'] = 5,
            ['Доктор'] = 6,
            ['Психолог'] = 7,
            ['Хирург'] = 8,
            ['Зам.Глав.Врача'] = 9,
            ['Глав.Врач'] = 10,
        }
    end
    if frak == 'Aztecas Gang' then
        trangs = {
            ['Перро'] = 1,
            ['Тирадор'] = 2,
            ['Геттор'] = 3,
            ['Лас Геррас'] = 4,
            ['Мирандо'] = 5,
            ['Сабио'] = 6,
            ['Инвасор'] = 7,
            ['Тесореро'] = 8,
            ['Нестро'] = 9,
            ['Падре'] = 10,
        }
    end
    if frak == 'Ballas Gang' then
        trangs = {
            ['Блайд'] = 1,
            ['Младший Нига'] = 2,
            ['Крэкер'] = 3,
            ['Гун брo'] = 4,
            ['Ап Бро'] = 5,
            ['Гангстер'] = 6,
            ['Федерал Блок'] = 7,
            ['Фолкс'] = 8,
            ['Райч Нига'] = 9,
            ['Биг Вилли'] = 10,
        }
    end
    if frak == 'Grove Gang' then
        trangs = {
            ['Плейа'] = 1,
            ['Хастла'] = 2,
            ['Килла'] = 3,
            ['Йонг'] = 4,
            ['Гангста'] = 5,
            ['О.Г.'] = 6,
            ['Мобста'] = 7,
            ['Де Кинг'] = 8,
            ['Легенд'] = 9,
            ['Мэд Дог'] = 10,
        }
    end
    if frak == 'Rifa Gang' then
        trangs = {
            ['Новато'] = 1,
            ['Ладрон'] = 2,
            ['Амиго'] = 3,
            ['Мачо'] = 4,
            ['Джуниор'] = 5,
            ['Эрмано'] = 6,
            ['Бандидо'] = 7,
            ['Ауторидад'] = 8,
            ['Аджунто'] = 9,
            ['Падре'] = 10,
        }
    end
    if frak == 'Vagos Gang' then
        trangs = {
            ['Новатто'] = 1,
            ['Ординарио'] = 2,
            ['Локал'] = 3,
            ['Верификадо'] = 4,
            ['Бандито'] = 5,
            ['V.E.G'] = 6,
            ['Ассесино'] = 7,
            ['Лидер V.E.G'] = 8,
            ['Падрино'] = 9,
            ['Падре'] = 10,
        }
    end
    if frak == 'LCN' then
        trangs = {
            ['Новицио'] = 1,
            ['Ассосиато'] = 2,
            ['Сомбаттенте'] = 3,
            ['Солдато'] = 4,
            ['Боец'] = 5,
            ['Сотто-Капо'] = 6,
            ['Капо'] = 7,
            ['Младший Босс'] = 8,
            ['Консильери'] = 9,
            ['Дон'] = 10,
        }
    end
    if frak == 'Russian Mafia' then
        trangs = {
            ['Шнырь'] = 1,
            ['Фраер'] = 2,
            ['Бык'] = 3,
            ['Барыга'] = 4,
            ['Блатной'] = 5,
            ['Свояк'] = 6,
            ['Браток'] = 7,
            ['Вор'] = 8,
            ['Вор в законе'] = 9,
            ['Авторитет'] = 10,
        }
    end
    if frak == 'Yakuza' then
        trangs = {
            ['Вакасю'] = 1,
            ['Сятей'] = 2,
            ['Кедай'] = 3,
            ['Фуку-Комбуте'] = 4,
            ['Вагакасира'] = 5,
            ['Со-Хомбуте'] = 6,
            ['Камбу'] = 7,
            ['Cайко-Комон'] = 8,
            ['Оядзи'] = 9,
            ['Кумите'] = 10,
        }
    end
    if frak == 'Driving School' then
        trangs = {
            ['Стажёр'] = 1,
            ['Консультант'] = 2,
            ['Экзаменатор'] = 3,
            ['Мл.Инструктор'] = 4,
            ['Инструктор'] = 5,
            ['Координатор'] = 6,
            ['Мл.Менеджер'] = 7,
            ['Ст.Менеджер'] = 8,
            ['Директор'] = 9,
            ['Управляющий'] = 10,
        }
    end
    if frak == 'Mongols' or frak == 'Pagans MC' or frak == 'Warlocks MC' then
        trangs = {
            ['Support'] = 1,
            ['Hang around'] = 2,
            ['Prospect'] = 3,
            ['Member'] = 4,
            ['Road captain'] = 5,
            ['Sergeant-at-arms'] = 6,
            ['Treasurer'] = 7,
            ['Вице президент'] = 8,
            ['Президент'] = 9,
        }
    end
    return trangs[rang]
end
--------------------------------------------------------------------------------
---------------------------------CLICKWARPFUNCS---------------------------------
--------------------------------------------------------------------------------
function fps_correction()
	return representIntAsFloat(readMemory(0xB7CB5C, 4, false))
end
function initializeRender()
    font = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)
    font2 = renderCreateFont("Arial", 8, FCR_ITALICS + FCR_BORDER)
    deathfont = renderCreateFont('Arial', 10, 5)
    nizfont = renderCreateFont('Arial', 10, 0)
    gunfont = renderCreateFont(getGameDirectory()..'\\gtaweap3.ttf', 10, 0)
    whfont = renderCreateFont("Arial", 8, 5)
    whhpfont = renderCreateFont("Arial", 8, 5)
end
function rotateCarAroundUpAxis(car, vec)
    local mat = Matrix3X3(getVehicleRotationMatrix(car))
    local rotAxis = Vector3D(mat.up:get())
    vec:normalize()
    rotAxis:normalize()
    local theta = math.acos(rotAxis:dotProduct(vec))
    if theta ~= 0 then
        rotAxis:crossProduct(vec)
        rotAxis:normalize()
        rotAxis:zeroNearZero()
        mat = mat:rotate(rotAxis, -theta)
    end
    setVehicleRotationMatrix(car, mat:get())
end
function readFloatArray(ptr, idx)
    return representIntAsFloat(readMemory(ptr + idx * 4, 4, false))
end
function writeFloatArray(ptr, idx, value)
    writeMemory(ptr + idx * 4, 4, representFloatAsInt(value), false)
end
function getVehicleRotationMatrix(car)
    local entityPtr = getCarPointer(car)
    if entityPtr ~= 0 then
      local mat = readMemory(entityPtr + 0x14, 4, false)
      if mat ~= 0 then
        local rx, ry, rz, fx, fy, fz, ux, uy, uz
        rx = readFloatArray(mat, 0)
        ry = readFloatArray(mat, 1)
        rz = readFloatArray(mat, 2)

        fx = readFloatArray(mat, 4)
        fy = readFloatArray(mat, 5)
        fz = readFloatArray(mat, 6)

        ux = readFloatArray(mat, 8)
        uy = readFloatArray(mat, 9)
        uz = readFloatArray(mat, 10)
        return rx, ry, rz, fx, fy, fz, ux, uy, uz
      end
    end
end
function setVehicleRotationMatrix(car, rx, ry, rz, fx, fy, fz, ux, uy, uz)
    local entityPtr = getCarPointer(car)
    if entityPtr ~= 0 then
      local mat = readMemory(entityPtr + 0x14, 4, false)
      if mat ~= 0 then
        writeFloatArray(mat, 0, rx)
        writeFloatArray(mat, 1, ry)
        writeFloatArray(mat, 2, rz)

        writeFloatArray(mat, 4, fx)
        writeFloatArray(mat, 5, fy)
        writeFloatArray(mat, 6, fz)

        writeFloatArray(mat, 8, ux)
        writeFloatArray(mat, 9, uy)
        writeFloatArray(mat, 10, uz)
      end
    end
end
function displayVehicleName(x, y, gxt)
    x, y = convertWindowScreenCoordsToGameScreenCoords(x, y)
    useRenderCommands(true)
    setTextWrapx(640.0)
    setTextProportional(true)
    setTextJustify(false)
    setTextScale(0.33, 0.8)
    setTextDropshadow(0, 0, 0, 0, 0)
    setTextColour(255, 255, 255, 230)
    setTextEdge(1, 0, 0, 0, 100)
    setTextFont(1)
    displayText(x, y, gxt)
end
function createPointMarker(x, y, z)
    pointMarker = createUser3dMarker(x, y, z + 0.3, 4)
end
function removePointMarker()
    if pointMarker then
      removeUser3dMarker(pointMarker)
      pointMarker = nil
    end
end
function getCarFreeSeat(car)
    if doesCharExist(getDriverOfCar(car)) then
      local maxPassengers = getMaximumNumberOfPassengers(car)
      for i = 0, maxPassengers do
        if isCarPassengerSeatFree(car, i) then
          return i + 1
        end
      end
      return nil -- no free seats
    else
      return 0 -- driver seat
    end
end
function jumpIntoCar(car)
    local seat = getCarFreeSeat(car)
    if not seat then return false end                         -- no free seats
    if seat == 0 then warpCharIntoCar(playerPed, car)         -- driver seat
    else warpCharIntoCarAsPassenger(playerPed, car, seat - 1) -- passenger seat
    end
    restoreCameraJumpcut()
    return true
end
function teleportPlayer(x, y, z)
    if isCharInAnyCar(playerPed) then
      setCharCoordinates(playerPed, x, y, z)
    end
    setCharCoordinatesDontResetAnim(playerPed, x, y, z)
end
function setCharCoordinatesDontResetAnim(char, x, y, z)
    if doesCharExist(char) then
      local ptr = getCharPointer(char)
      setEntityCoordinates(ptr, x, y, z)
    end
end
function setEntityCoordinates(entityPtr, x, y, z)
    if entityPtr ~= 0 then
      local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
      if matrixPtr ~= 0 then
        local posPtr = matrixPtr + 0x30
        writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) -- X
        writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) -- Y
        writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) -- Z
      end
    end
end
function showCursorF(toggle)
    if toggle then
      sampSetCursorMode(CMODE_LOCKCAM)
    else
      sampToggleCursor(false)
    end
    funcsStatus.ClickWarp = toggle
end
function clickF()
    while true do
        if not imgui.Process then
            while isPauseMenuActive() do
                if funcsStatus.ClickWarp then
                    showCursorF(false)
                end
                wait(100)
            end
            if isKeyDown(key.VK_MBUTTON) then
                funcsStatus.ClickWarp = not funcsStatus.ClickWarp
                showCursorF(funcsStatus.ClickWarp)
                while isKeyDown(key.VK_MBUTTON) do wait(80) end
            end
            if funcsStatus.ClickWarp then
                local mode = sampGetCursorMode()
                if mode == 0 then
                    showCursorF(true)
                end
                local sx, sy = getCursorPos()
                local sw, sh = getScreenResolution()
                -- is cursor in game window bounds?
                if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
                    local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
                    local camX, camY, camZ = getActiveCameraCoordinates()
                    -- search for the collision point
                    local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
                    if result and colpoint.entity ~= 0 then
                        local normal = colpoint.normal
                        local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
                        local zOffset = 300
                        if normal[3] >= 0.5 then zOffset = 1 end
                            -- search for the ground position vertically down
                            local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
                                true, true, false, true, false, false, false)
                            if result then
                                pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)
                                local curX, curY, curZ  = getCharCoordinates(playerPed)
                                local dist              = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
                                local hoffs             = renderGetFontDrawHeight(font)
                                sy = sy - 2
                                sx = sx - 2
                                renderFontDrawText(font, string.format("%0.2fm", dist), sx, sy - hoffs, 0xEEEEEEEE)
                                local tpIntoCar = nil
                                if colpoint.entityType == 2 then
                                    local car = getVehiclePointerHandle(colpoint.entity)
                                    if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
                                        displayVehicleName(sx, sy - hoffs * 2, getNameOfVehicleModel(getCarModel(car)))
                                        local color = 0xAAFFFFFF
                                        if isKeyDown(VK_RBUTTON) then
                                            tpIntoCar = car
                                            color = 0xFFFFFFFF
                                        end
                                        renderFontDrawText(font2, "Hold right mouse button to teleport into the car", sx, sy - hoffs * 3, color)
                                    end
                                end
                                createPointMarker(pos.x, pos.y, pos.z)
                                -- teleport!
                                if isKeyDown(key.VK_LBUTTON) then
                                    if tpIntoCar then
                                        if not jumpIntoCar(tpIntoCar) then
                                            -- teleport to the car if there is no free seats
                                            teleportPlayer(pos.x, pos.y, pos.z)
                                        end
                                    else
                                        if isCharInAnyCar(playerPed) then
                                            local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
                                            local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
                                            rotateCarAroundUpAxis(storeCarCharIsInNoSave(playerPed), norm2)
                                            pos = pos - norm * 1.8
                                            pos.z = pos.z - 0.8
                                        end
                                        teleportPlayer(pos.x, pos.y, pos.z)
                                    end
                                    removePointMarker()
                                    while isKeyDown(key.VK_LBUTTON) do wait(0) end
                                    showCursorF(false)
                                end
                            end
                        end
                    end
                end
            end
        wait(0)
        removePointMarker()
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function onScriptTerminate(scr)
	if doesFileExist('moonloader/config/Admin Tools/keys.json') then
        os.remove('moonloader/config/Admin Tools/keys.json')
    end
    local fa = io.open("moonloader/config/Admin Tools/keys.json", "w")
    if fa then
        fa:write(encodeJson(config_keys))
        fa:close()
    end
end
function sampev.onServerMessage(color, text)
    if checkfraks then
        if text:match('^ ID: %d+ |.+') then
            local cid, cnick, crang = text:match('^ ID%: (%d+) | %d+%:%d+ %d+%.%d+%.%d+ | (.+)%: .+%[(%d+)%]')
            local lvl = sampGetPlayerScore(cid)
            local crang = tonumber(crang)
            if check_frak == 1 or check_frak == 10 or check_frak == 21 then
                if lvl < frakrang.PD.inv and lvl ~= 0 then
                    table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                end
                if crang == 11 then
                    if lvl < frakrang.PD.rang_11 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 12 then
                    if lvl < frakrang.PD.rang_12 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 13 then
                    if lvl < frakrang.PD.rang_13 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
            elseif check_frak == 2 then
                if lvl < frakrang.FBI.inv and lvl ~= 0 then
                    table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                end
                if crang == 6 then
                    if lvl < frakrang.FBI.rang_6 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 7 then
                    if lvl < frakrang.FBI.rang_7 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 8 then
                    if lvl < frakrang.FBI.rang_8 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 9 then
                    if lvl < frakrang.FBI.rang_9 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
            elseif check_frak == 3 or check_frak == 19 then
                if lvl < frakrang.Army.inv and lvl ~= 0 then
                    table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                end
                if crang == 12 then
                    if lvl < frakrang.Army.rang_12 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 13 then
                    if lvl < frakrang.Army.rang_13 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 14 then
                    if lvl < frakrang.Army.rang_14 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
            elseif check_frak == 5 or check_frak == 6 or check_frak == 14 then
                if lvl < frakrang.Mafia.inv and lvl ~= 0 then
                    table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                end
                if crang == 7 then
                    if lvl < frakrang.Mafia.rang_7 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 8 then
                    if lvl < frakrang.Mafia.rang_8 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 9 then
                    if lvl < frakrang.Mafia.rang_9 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
            elseif check_frak == 11 then
                if lvl < frakrang.Autoschool.inv and lvl ~= 0 then
                    table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                end
                if crang == 7 then
                    if lvl < frakrang.Autoschool.rang_7 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 8 then
                    if lvl < frakrang.Autoschool.rang_8 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 9 then
                    if lvl < frakrang.Autoschool.rang_9 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
            elseif check_frak == 12 or check_frak == 13 or check_frak == 15 or check_frak == 17 or check_frak == 18 then
                if lvl < frakrang.Gangs.inv and lvl ~= 0 then
                    table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                end
                if crang == 7 then
                    if lvl < frakrang.Gangs.rang_7 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 8 then
                    if lvl < frakrang.Gangs.rang_8 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 9 then
                    if lvl < frakrang.Gangs.rang_9 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
            elseif check_frak == 22 then
                if lvl < frakrang.MOH.inv and lvl ~= 0 then
                    table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                end
                if crang == 7 then
                    if lvl < frakrang.MOH.rang_7 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 8 then
                    if lvl < frakrang.MOH.rang_8 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 9 then
                    if lvl < frakrang.MOH.rang_9 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
            elseif check_frak == 24 or check_frak == 26 or check_frak == 29 then
                if lvl < frakrang.Bikers.inv and lvl ~= 0 then
                    table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                end
                if crang == 5 then
                    if lvl < frakrang.Bikers.rang_5 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 6 then
                    if lvl < frakrang.Bikers.rang_6 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 7 then
                    if lvl < frakrang.Bikers.rang_7 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 8 then
                    if lvl < frakrang.Bikers.rang_8 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
            elseif check_frak == 9 or check_frak == 16 or check_frak == 20 then
                if lvl < frakrang.News.inv and lvl ~= 0 then
                    table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                end
                if crang == 7 then
                    if lvl < frakrang.News.rang_7 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 8 then
                    if lvl < frakrang.News.rang_8 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
                if crang == 9 then
                    if lvl < frakrang.News.rang_9 then
                        table.insert(checkf, string.format('Nick: %s | LVL: %s | Rang: %s', cnick, lvl, crang))
                    end
                end
            end
            return false
        end
        if text:match('Всего: %d+ человек') then
            checkfraksdone = true
            return false
        end
        if text:find('Члены организации Он%-лайн%:') then return false end
        if text == ' ' and color == -1 then return false end
    end
    if fonlcheck then
        if text:match('^ ID: %d+ |.+') then
            return false
        end
        if text:match('Всего: %d+ человек') then
            fonlnum = text:match('Всего: (%d+) человек')
            fonldone = true
            return false
        end
        if text:find('Члены организации Он%-лайн%:') then return false end
        if text == ' ' and color == -1 then return false end
    end
    if text:match("Жалоба от .+%[%d+%] на .+%[%d+%]%: .+") and color == -646512470 then
        reportid = text:match("Жалоба от .+%[%d+%] на .+%[(%d+)%]%: .+")
    end
    if text:match("Nik %[.+%]  R%-IP %[.+%]  L%-IP %[.+%]  IP %[(.+)%]") and color == -10270806 then
        bip = text:match("Nik %[.+%]  R%-IP %[.+%]  L%-IP %[.+%]  IP %[(.+)%]")
    end
    if text:match('<Warning> .+%[%d+%]%: .+') and color == -16763905 then
        cwid = text:match('<Warning> .+%[(%d+)%]%: .+')
    end
    if text:match('Репорт от .+%[%d+%]%:') and color == -646512470 then
        reportid = text:match('Репорт от .+%[(%d+)%]%:')
    end
    if text:match('Жалоба от%: .+%[%d+%]%:') and color == -646512470 then
        reportid = text:match('Жалоба от%: .+%[(%d+)%]%:')
    end
end
function sampev.onTextDrawSetString(id, text)
    if id == 2163 then
        imtextlvl, imtextwarn, imtextarm, imtexthp, imtextcarhp, imtextspeed, imtextping, imtextammo, imtextshot, imtexttimeshot, imtextafktime, imtextengine, imtextprosport = text:match('~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)')
    end
    if id == 2164 then
        if text:match('~w~.+') then
            imtextnick = text:match('~w~(.+)~n~ID:')
            reafk = true
        else
            imtextnick = text:match('(.+)~n~ID:')
            reafk = false
        end

        reid = text:match('.+~n~ID%: (%d+)')
        traceid = reid
    end
end
function sampev.onShowTextDraw(id, textdraw)
    if cfg.crecon.enable then
        if id == 2163 then recon.v = true return false end
        if id == 2164 then return false end
        if id == 2162 then return false end
        if id == 2158 then return false end
        if id == 2159 then return false end
    end
end
function sampev.onTextDrawHide(id)
    if cfg.crecon.enable then if id == 2164 then recon.v = false; reid = nil end end
end
function sampev.onPlayerQuit(id, reason)
	for i, v in ipairs(admins_online) do
		if v["id"] == id then
			table.remove(admins_online, i)
			break
		end
    end
    for i, v in ipairs(players_online) do
		if v["id"] == id then
			table.remove(players_online, i)
			break
		end
    end
end
function sampev.onPlayerDeathNotification(killerId, killedId, reason)
	local kill = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr())
	local _, myid = sampGetPlayerIdByCharHandle(playerPed)

	local n_killer = ( sampIsPlayerConnected(killerId) or killerId == myid ) and sampGetPlayerNickname(killerId) or nil
	local n_killed = ( sampIsPlayerConnected(killedId) or killedId == myid ) and sampGetPlayerNickname(killedId) or nil
	lua_thread.create(function()
		wait(0)
		if n_killer then kill.killEntry[4].szKiller = ffi.new('char[25]', ( n_killer .. '[' .. killerId .. ']' ):sub(1, 24) ) end
		if n_killed then kill.killEntry[4].szVictim = ffi.new('char[25]', ( n_killed .. '[' .. killedId .. ']' ):sub(1, 24) ) end
    end)
    table.insert(tkills, ('{'..("%06X"):format(bit.band(sampGetPlayerColor(killerId), 0xFFFFFF))..'}%s[%s]\t{'..("%06X"):format(bit.band(sampGetPlayerColor(killedId), 0xFFFFFF))..'}%s[%s]\t{ffffff}%s'):format(sampGetPlayerNickname(killerId),killerId, sampGetPlayerNickname(killedId),killedId, weapons.get_name(reason)))
end
function sampev.onTogglePlayerControllable(bool)
    return false
end
function sampev.onBulletSync(playerid, data)
	if tonumber(playerid) == tonumber(traceid) then
		if data.target.x == -1 or data.target.y == -1 or data.target.z == -1 then
			return true
		end
		BulletSync.lastId = BulletSync.lastId + 1
		if BulletSync.lastId < 1 or BulletSync.lastId > BulletSync.maxLines then
			BulletSync.lastId = 1
		end
		local id = BulletSync.lastId
		BulletSync[id].enable = true
		BulletSync[id].tType = data.targetType
		BulletSync[id].time = os.time() + 15
		BulletSync[id].o.x, BulletSync[id].o.y, BulletSync[id].o.z = data.origin.x, data.origin.y, data.origin.z
		BulletSync[id].t.x, BulletSync[id].t.y, BulletSync[id].t.z = data.target.x, data.target.y, data.target.z
	end
end
function sampev.onPlayerJoin(id, clist, isNPC, nick)
	for i, v in ipairs(admins) do
		if nick == v then
			table.insert(admins_online, {nick = nick, id = id})
			break
		end
    end
    for i, v in ipairs(players) do
		if nick == v then
			table.insert(players_online, {nick = nick, id = id})
			break
		end
	end
end
function renderChecker()
    while true do wait(0)
        local admrenderPosY = cfg.admchecker.posy
        local playerRenderPosY = cfg.playerChecker.posy
        if cfg.admchecker.enable then
            renderFontDrawText(font, "Admins Online ["..#admins_online.."]:", cfg.admchecker.posx, admrenderPosY, -1)
            for _, v in ipairs(admins_online) do
                renderFontDrawText(font,string.format('%s [%s] %s', v["nick"], sampGetPlayerIdByNickname(v["nick"]), doesCharExist(select(2, sampGetCharHandleBySampPlayerId(v["id"]))) and '{5aa0aa}(Р)' or '') , cfg.admchecker.posx, admrenderPosY + 20, -1)
                admrenderPosY = admrenderPosY + 15
            end
        end
        if cfg.playerChecker.enable then
            renderFontDrawText(font, "Players Online ["..#players_online.."]:", cfg.playerChecker.posx, playerRenderPosY, -1)
            for _, v in ipairs(players_online) do
                renderFontDrawText(font,string.format('%s [%s] %s', v["nick"], sampGetPlayerIdByNickname(v["nick"]), doesCharExist(select(2, sampGetCharHandleBySampPlayerId(v["id"]))) and '{5aa0aa}(Р)' or '') , cfg.playerChecker.posx, playerRenderPosY + 20, -1)
                playerRenderPosY = playerRenderPosY + 15
            end
        end
    end
end
function loadadmins()
    if doesFileExist("moonloader/config/Admin Tools/adminlist.txt") then
        for admin in io.lines("moonloader/config/Admin Tools/adminlist.txt") do
			table.insert(admins, admin:match("(%S+)"))
        end
    else
        io.open("moonloader/config/Admin Tools/adminlist.txt", "w"):close()
    end
    if doesFileExist("moonloader/config/Admin Tools/playerlist.txt") then
        for admin in io.lines("moonloader/config/Admin Tools/playerlist.txt") do
			table.insert(players, admin:match("(%S+)"))
        end
    else
        io.open("moonloader/config/Admin Tools/playerlist.txt", "w"):close()
    end
end
function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnected(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
end
function addadm(pam)
    local pId = tonumber(pam)
    if pId ~= nil then
        if sampIsPlayerConnected(pId) then
            local nick = sampGetPlayerNickname(pId)
            table.insert(admins_online, {nick = nick, id = pId})
            table.insert(admins, nick)
            atext('Игрок с ником '..nick..' ['..pId..'] добавлен в чекер админов')
            local open = io.open("moonloader/config/Admin Tools/adminlist.txt", 'a')
            open:write('\n'..nick)
            open:close()
        else
            table.insert(admins, pId)
            atext('Игрок с ником '..pId..' добавлен в чекер админов')
            local open = io.open("moonloader/config/Admin Tools/adminlist.txt", 'a')
            open:write('\n'..pId)
            open:close()
        end
    elseif pId == nil and #pam ~= 0 then
        if sampGetPlayerIdByNickname(tostring(pam)) ~= nil then
            local bpId = sampGetPlayerIdByNickname(tostring(pam))
            table.insert(admins_online, {nick = pam, id = bpId})
            atext('Игрок с ником '..pam..' ['..bpId..'] добавлен в чекер админов')
        else
            atext('Игрок с ником '..pam..' добавлен в чекер админов')
        end
        table.insert(admins, pam)
        local open = io.open("moonloader/config/Admin Tools/adminlist.txt", 'a')
        open:write('\n'..pam)
        open:close()
    elseif #pam == 0 then
        atext('Введите /addadm [id/nick]')
    end
end
function addplayer(pam)
    local pId = tonumber(pam)
    if pId ~= nil then
        if sampIsPlayerConnected(pId) then
            local nick = sampGetPlayerNickname(pId)
            table.insert(players_online, {nick = nick, id = pId})
            table.insert(players, nick)
            atext('Игрок с ником '..nick..' ['..pId..'] добавлен в чекер игроков')
            local open = io.open("moonloader/config/Admin Tools/playerlist.txt", 'a')
            open:write('\n'..nick)
            open:close()
        else
            table.insert(players, pId)
            atext('Игрок с ником '..pId..' добавлен в чекер игроков')
            local open = io.open("moonloader/config/Admin Tools/playerlist.txt", 'a')
            open:write('\n'..pId)
            open:close()
        end
    elseif pId == nil and #pam ~= 0 then
        if sampGetPlayerIdByNickname(tostring(pam)) ~= nil then
            local bpId = sampGetPlayerIdByNickname(tostring(pam))
            table.insert(players_online, {nick = pam, id = bpId})
            atext('Игрок с ником '..pam..' ['..bpId..'] добавлен в чекер игроков')
        else
            atext('Игрок с ником '..pam..' добавлен в чекер игроков')
        end
        table.insert(players, pam)
        local open = io.open("moonloader/config/Admin Tools/playerlist.txt", 'a')
        open:write('\n'..pam)
        open:close()
    elseif #pam == 0 then
        atext('Введите /addplayer [id/nick]')
    end
end
function delplayer(pam)
    lua_thread.create(function()
        local pId = tonumber(pam)
        if pId ~= nil then
            if sampIsPlayerConnected(pId) then
                local nick = sampGetPlayerNickname(pId)
                local i = 1
                while i <= #players do
                    if players[i] == nick then
                        table.remove(players, i)
                    else
                        i = i + 1
                    end
                end
                atext('Игрок '..nick..' ['..pId..'] удален из чекера игроков')
                local oi = 1
                while oi <= #players_online do
                    if players_online[oi].nick == nick then
                        table.remove(players_online, oi)
                    else
                        oi = oi + 1
                    end
                end
                local open = io.open("moonloader/config/Admin Tools/playerlist.txt", "w")
                for k, v in pairs(players) do
                    open:write('\n'..v)
                end
                open:close()
                open = nil
            else
                local i = 1
                while i <= #players do
                    if players[i] == pId then
                        table.remove(players, i)
                    else
                        i = i + 1
                    end
                end
                atext('Игрок '..pId..' удален из чекера игроков')
                local open = io.open("moonloader/config/Admin Tools/playerlist.txt", "w")
                for k, v in pairs(players) do
                    open:write('\n'..v)
                end
                open:close()
                open = nil
            end
        elseif pId == nil and #pam ~= 0 then
            if sampGetPlayerIdByNickname(tostring(pam)) ~= nil then
                local bpId = sampGetPlayerIdByNickname(tostring(pam))
                local i = 1
                while i <= #players do
                    if players[i] == tostring(pam) then
                        table.remove(players, i)
                    else
                        i = i + 1
                    end
                end
                local oi = 1
                while oi <= #players_online do
                    if players_online[oi].nick == tostring(pam) then
                        table.remove(players_online, oi)
                    else
                        oi = oi + 1
                    end
                end
                local open = io.open("moonloader/config/Admin Tools/playerlist.txt", "w")
                for k, v in pairs(players) do
                    open:write('\n'..v)
                end
                open:close()
                open = nil
                atext('Игрок '..pam..' ['..bpId..'] удален из чекера игроков')
            else
                local i = 1
                while i <= #players do
                    if players[i] == tostring(pam) then
                        table.remove(players, i)
                    else
                        i = i + 1
                    end
                end
                local open = io.open("moonloader/config/Admin Tools/playerlist.txt", "w")
                for k, v in pairs(players) do
                    open:write('\n'..v)
                end
                open:close()
                open = nil
            end
        end
    end)
end
function deladm(pam)
    lua_thread.create(function()
        local pId = tonumber(pam)
        if pId ~= nil then
            if sampIsPlayerConnected(pId) then
                local nick = sampGetPlayerNickname(pId)
                local i = 1
                while i <= #admins do
                    if admins[i] == nick then
                        table.remove(admins, i)
                    else
                        i = i + 1
                    end
                end
                atext('Игрок '..nick..' ['..pId..'] удален из чекера админов')
                local oi = 1
                while oi <= #admins_online do
                    if admins_online[oi].nick == nick then
                        table.remove(admins_online, oi)
                    else
                        oi = oi + 1
                    end
                end
                local open = io.open("moonloader/config/Admin Tools/adminlist.txt", "w")
                for k, v in pairs(admins) do
                    open:write('\n'..v)
                end
                open:close()
                open = nil
            else
                local i = 1
                while i <= #admins do
                    if admins[i] == pId then
                        table.remove(admins, i)
                    else
                        i = i + 1
                    end
                end
                atext('Игрок '..pId..' удален из чекера игроков')
                local open = io.open("moonloader/config/Admin Tools/adminlist.txt", "w")
                for k, v in pairs(admins) do
                    open:write('\n'..v)
                end
                open:close()
                open = nil
            end
        elseif pId == nil and #pam ~= 0 then
            if sampGetPlayerIdByNickname(tostring(pam)) ~= nil then
                local bpId = sampGetPlayerIdByNickname(tostring(pam))
                local i = 1
                while i <= #admins do
                    if admins[i] == tostring(pam) then
                        table.remove(admins, i)
                    else
                        i = i + 1
                    end
                end
                local oi = 1
                while oi <= #admins_online do
                    if admins_online[oi].nick == tostring(pam) then
                        table.remove(admins_online, oi)
                    else
                        oi = oi + 1
                    end
                end
                local open = io.open("moonloader/config/Admin Tools/adminlist.txt", "w")
                for k, v in pairs(admins) do
                    open:write('\n'..v)
                end
                open:close()
                open = nil
                atext('Игрок '..pam..' ['..bpId..'] удален из чекера игроков')
            else
                local i = 1
                while i <= #admins do
                    if admins[i] == tostring(pam) then
                        table.remove(admins, i)
                    else
                        i = i + 1
                    end
                end
                local open = io.open("moonloader/config/Admin Tools/adminlist.txt", "w")
                for k, v in pairs(admins) do
                    open:write('\n'..v)
                end
                open:close()
                open = nil
            end
        end
    end)
end
function check_keystrokes() -- inv
    while true do wait(0)
        if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
            if isKeyJustPressed(key.VK_F3) then
                setCharHealth(PLAYER_PED, 0)
            end
            if isKeyJustPressed(key.VK_INSERT) then
                funcsStatus.Inv = not funcsStatus.Inv
            end
            if isKeyJustPressed(key.VK_RSHIFT) then -- airbrake
                airspeed = cfg.cheat.airbrkspeed
                funcsStatus.AirBrk = not funcsStatus.AirBrk
                if funcsStatus.AirBrk then
                    local posX, posY, posZ = getCharCoordinates(playerPed)
                    airBrkCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(playerPed)}
                end
            end
        end
    end
end
function main_funcs()
    while true do wait(0)
        if funcsStatus.Inv then -- inv
            if isCharInAnyCar(playerPed) then
                setCarProofs(storeCarCharIsInNoSave(playerPed), true, true, true, true, true)
                setCharCanBeKnockedOffBike(playerPed, true)
                setCanBurstCarTires(storeCarCharIsInNoSave(playerPed), false)
            end
            setCharProofs(playerPed, true, true, true, true, true)
        else
            if isCharInAnyCar(playerPed) then
                setCarProofs(storeCarCharIsInNoSave(playerPed), false, false, false, false, false)
                setCharCanBeKnockedOffBike(playerPed, false)
            end
            setCharProofs(playerPed, false, false, false, false, false)
        end

        local time = os.clock() * 1000
        if funcsStatus.AirBrk then -- airbrake
            if isCharInAnyCar(playerPed) then heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
            else heading = getCharHeading(playerPed) end
            local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
            local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
            local angle = getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY)
            if isCharInAnyCar(playerPed) then difference = 0.79 else difference = 1.0 end
            setCharCoordinates(playerPed, airBrkCoords[1], airBrkCoords[2], airBrkCoords[3] - difference)
            if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
                if isKeyDown(key.VK_W) then
                    airBrkCoords[1] = airBrkCoords[1] + airspeed * math.sin(-math.rad(angle))
                    airBrkCoords[2] = airBrkCoords[2] + airspeed * math.cos(-math.rad(angle))
                    if not isCharInAnyCar(playerPed) then setCharHeading(playerPed, angle)
                    else setCarHeading(storeCarCharIsInNoSave(playerPed), angle) end
                elseif isKeyDown(key.VK_S) then
                    airBrkCoords[1] = airBrkCoords[1] - airspeed * math.sin(-math.rad(heading))
                    airBrkCoords[2] = airBrkCoords[2] - airspeed * math.cos(-math.rad(heading))
                end
                if isKeyDown(key.VK_A) then
                    airBrkCoords[1] = airBrkCoords[1] - airspeed * math.sin(-math.rad(heading - 90))
                    airBrkCoords[2] = airBrkCoords[2] - airspeed * math.cos(-math.rad(heading - 90))
                elseif isKeyDown(key.VK_D) then
                    airBrkCoords[1] = airBrkCoords[1] - airspeed * math.sin(-math.rad(heading + 90))
                    airBrkCoords[2] = airBrkCoords[2] - airspeed * math.cos(-math.rad(heading + 90))
                end
                if isKeyDown(key.VK_UP) then airBrkCoords[3] = airBrkCoords[3] + airspeed / 2.0 end
                if isKeyDown(key.VK_DOWN) and airBrkCoords[3] > -95.0 then airBrkCoords[3] = airBrkCoords[3] - airspeed / 2.0 end
                if isKeyDown(key.VK_LSHIFT) and not isKeyDown(key.VK_RSHIFT) and airspeed > 0.06 then airspeed = airspeed - 0.050; printStringNow('Speed: '..airspeed, 1000) end
                if isKeyDown(key.VK_SPACE) then airspeed = airspeed + 0.050; printStringNow('Speed: '..airspeed, 1000) end
            end
        end
    end
end
function check_keys_fast()
    while true do wait(0)
        local isInVeh = isCharInAnyCar(playerPed)
        local veh = nil
        if isInVeh then veh = storeCarCharIsInNoSave(playerPed) end
        if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
            if isKeyJustPressed(key.VK_B) then -- hop
                if isCharInAnyCar(playerPed) then
                    local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
                    if cVecZ < 7.0 then applyForceToCar(storeCarCharIsInNoSave(playerPed), 0.0, 0.0, 0.3, 0.0, 0.0, 0.0) end
                else
                    local pVecX, pVecY, pVecZ = getCharVelocity(playerPed)
                    if pVecZ < 7.0 then setCharVelocity(playerPed, 0.0, 0.0, 10.0) end
                end
            end
            if isKeyJustPressed(key.VK_BACK) and isCharInAnyCar(playerPed) then -- turn back
                local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
                applyForceToCar(storeCarCharIsInNoSave(playerPed), -cVecX / 25, -cVecY / 25, -cVecZ / 25, 0.0, 0.0, 0.0)
                local x, y, z, w = getVehicleQuaternion(storeCarCharIsInNoSave(playerPed))
                local matrix = {convertQuaternionToMatrix(w, x, y, z)}
                matrix[1] = -matrix[1]
                matrix[2] = -matrix[2]
                matrix[4] = -matrix[4]
                matrix[5] = -matrix[5]
                matrix[7] = -matrix[7]
                matrix[8] = -matrix[8]
                local w, x, y, z = convertMatrixToQuaternion(matrix[1], matrix[2], matrix[3], matrix[4], matrix[5], matrix[6], matrix[7], matrix[8], matrix[9])
                setVehicleQuaternion(storeCarCharIsInNoSave(playerPed), x, y, z, w)
            end
            if isKeyJustPressed(key.VK_N) and isCharInAnyCar(playerPed) then -- fast exit
                local posX, posY, posZ = getCarCoordinates(storeCarCharIsInNoSave(playerPed))
                warpCharFromCarToCoord(playerPed, posX, posY, posZ)
            end
            if isKeyJustPressed(key.VK_F3) then -- suicide
                if not isCharInAnyCar(playerPed) then
                    setCharHealth(playerPed, 0.0)
                else
                    setCarHealth(storeCarCharIsInNoSave(playerPed), 0.0)
                end
            end
            if isKeyDown(key.VK_DELETE) then -- flip
                if veh ~= nil then
                    local heading = getCarHeading(veh)
                    heading = heading + 2 * fps_correction()
                    if heading > 360 then heading = heading - 360 end
                    setCarHeading(veh, heading)
                end
            end
            if isKeyDown(key.VK_LMENU) and isCharInAnyCar(playerPed) then -- speedhack
                if getCarSpeed(storeCarCharIsInNoSave(playerPed)) * 2.01 <= 200 then
                    local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
                    local heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
                    local turbo = fps_correction() / 85
                    local xforce, yforce, zforce = turbo, turbo, turbo
                    local Sin, Cos = math.sin(-math.rad(heading)), math.cos(-math.rad(heading))
                    if cVecX > -0.01 and cVecX < 0.01 then xforce = 0.0 end
                    if cVecY > -0.01 and cVecY < 0.01 then yforce = 0.0 end
                    if cVecZ < 0 then zforce = -zforce end
                    if cVecZ > -2 and cVecZ < 15 then zforce = 0.0 end
                    if Sin > 0 and cVecX < 0 then xforce = -xforce end
                    if Sin < 0 and cVecX > 0 then xforce = -xforce end
                    if Cos > 0 and cVecY < 0 then yforce = -yforce end
                    if Cos < 0 and cVecY > 0 then yforce = -yforce end
                    applyForceToCar(storeCarCharIsInNoSave(playerPed), xforce * Sin, yforce * Cos, zforce / 2, 0.0, 0.0, 0.0)
                end
            end
        end
    end
end
function onReceiveRpc(id, bs) --перехватываем все входящие рпс
    if id == 91 then --делаем проверку на нужный нам, в данном случае это RPC_SetVehicleVelocity
        return false -- блокируем рпс
    end
end
function tr(pam)
    local idd = tonumber(pam)
    if idd ~= nil and sampIsPlayerConnected(idd) then
        traceid = idd
        atext("Трейсера сменены на: {a1dd4e}"..traceid)
    else
        atext('Используйте: /tr [id]')
    end
end
function wh()
    while not sampIsLocalPlayerSpawned() do wait(0) end
    nameTagOff()
    while true do wait(0)
        if not nameTag then
            if not isPauseMenuActive() then
                for i = 0, sampGetMaxPlayerId(true) do
                    if sampIsPlayerConnected(i) then
                        local result, cped = sampGetCharHandleBySampPlayerId(i)
                        if result then
                            if doesCharExist(cped) and isCharOnScreen(cped) then
                                local color = ("%06X"):format(bit.band(sampGetPlayerColor(i), 0xFFFFFF))
                                cpos1X, cpos1Y, cpos1Z = getBodyPartCoordinates(6, cped)
                                local cpedx, cpedy, cpedz = getCharCoordinates(cped)
                                local nick = sampGetPlayerNickname(i)
                                local screencoordx, screencoordy = convert3DCoordsToScreen(cpedx, cpedy, cpedz)
                                local headposx, headposy = convert3DCoordsToScreen(cpos1X, cpos1Y, cpos1Z)
                                local isAfk = sampIsPlayerPaused(i)
                                local cpedHealth = sampGetPlayerHealth(i)
                                local cpedArmor = sampGetPlayerArmor(i)
                                local cpedlvl = sampGetPlayerScore(i)
                                local posy = headposy
                                local posx = headposx - 50
                                renderFontDrawText(whfont, string.format('{%s}%s[%s] %s', color, nick, i, isAfk and '{cccccc}[AFK]' or ''), posx, posy, -1)
                                local hp2 = cpedHealth
                                if cpedHealth > 100 then cpedHealth = 100 end
                                if cpedArmor > 100 then cpedArmor = 100 end
                                renderDrawBoxWithBorder(posx+1, posy+15, math.floor(100 / 2) + 1, 7, 0x80000000, 1, 0xFF000000)
                                renderDrawBox(posx, posy+15, math.floor(cpedHealth / 2) + 1, 7, 0xAACC0000)
                                --renderFontDrawText(font2, 'HP: ' .. tostring(hp2), 1, resY - 11, 0xFFFFFFFF)
                                renderFontDrawText(whhpfont, cpedHealth, posx+60, posy+12.5, 0xFFFF0000)
                                renderFontDrawText(whfont, 'LVL: '..cpedlvl, posx+85, posy+14.5, -1)
                                if cpedArmor ~= 0 then
                                    renderDrawBoxWithBorder(posx, posy+25, math.floor(100 / 2) + 1, 7, 0x80000000, 1, 0xFF000000)
                                    renderDrawBox(posx, posy+25, math.floor(cpedArmor / 2) + 1, 7, 0xAAAAAAAA)
                                    --renderFontDrawText(font, 'Armor: '..cpedArmor, posx, posy+25, -1)
                                    renderFontDrawText(whhpfont, cpedArmor, posx+60, posy+22.5, -1)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
function nameTagOn()
	local pStSet = sampGetServerSettingsPtr();
	NTdist = mem.getfloat(pStSet + 39)
	NTwalls = mem.getint8(pStSet + 47)
	NTshow = mem.getint8(pStSet + 56)
	mem.setfloat(pStSet + 39, 1488.0)
	mem.setint8(pStSet + 47, 0)
	mem.setint8(pStSet + 56, 1)
	nameTag = true
end

function nameTagOff()
	local pStSet = sampGetServerSettingsPtr();
	mem.setfloat(pStSet + 39, NTdist)
	mem.setint8(pStSet + 47, NTwalls)
	mem.setint8(pStSet + 56, NTshow)
	nameTag = false
end
function getBodyPartCoordinates(id, handle)
    local pedptr = getCharPointer(handle)
    local vec = ffi.new("float[3]")
    getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
    return vec[0], vec[1], vec[2]
end
function warningsKey()
    local wtext, wprefix, wcolor, wpcolor = sampGetChatString(99)
    if wcolor == 4294967295 and wtext:match('%[SWarning%]%:{.+}  Игрок  .+ %[%d+%] - .+') then
        cwid = wtext:match('%[SWarning%]%:{.+}  Игрок  .+ %[(%d+)%] - .+')
    end
    if wcolor == 4294911012 and wtext:match('<Warning> {.+}.+%[%d+%]% .+') and not wtext:match("<Warning> {.+}.+%[%d+%] возможно попал сквозь текстуру в {.+}.+%[%d+%] из .+ %(model: %d+%)") then
        cwid = wtext:match('<Warning> {.+}.+%[(%d+)%]% .+')
    end
    if wtext:match("<Warning> {.+}.+%[%d+%] возможно попал сквозь текстуру в {.+}.+%[%d+%] из .+ %(model: %d+%)") then
        cwid = wtext:match("<Warning> {.+}.+%[(%d+)%] возможно попал сквозь текстуру в {.+}.+%[%d+%] из .+ %(model: %d+%)")
    end
end
function gun(pam)
    lua_thread.create(function()
        local id, pt = pam:match('(%d+) (%d+)')
        if id and pt then
            requestModel(getWeapontypeModel(id))
            while not isModelAvailable(getWeapontypeModel(id)) do wait(0) end
            giveWeaponToChar(PLAYER_PED, id, pt)
        end
    end)
end
function sampev.onShowDialog(id, style, title, button1, button2, text)
    if id == 0 then
        if warnst then
            wbfrak = text:match('.+Организация%:%s+(.+)%s+Ранг')
            wbrang = text:match('.+Ранг%:%s+(.+)%s+Работа')
            sampSendDialogResponse(id, 1, 1, nil)
            checkstatdone = true
            return false
        end
    end
    if id == 1 and #cfg.other.password >=6 then
        sampSendDialogResponse(id, 1, _, cfg.other.password)
        return false
    end
    if id == 1227 and #cfg.other.adminpass >=6 then
        sampSendDialogResponse(id, 1, _, cfg.other.adminpass)
        return false
    end
end
function warn(pam)
    lua_thread.create(function()
        local id, days, reason = pam:match('(%d+) (%d+) (.+)')
        if id and days and reason then
            if sampIsPlayerConnected(id) then
                if sampGetPlayerScore(id) < 3 then
                    sampSendChat(string.format("/warn %s %s %s", id, days, reason))
                else
                    warnst = true
                    local wnick = sampGetPlayerNickname(id)
                    sampSendChat('/getstats '..id)
                    while not checkstatdone do wait(0) end
                    wait(1200)
                    if sampGetPlayerNickname(id) == wnick then
                        if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                            sampSendChat(string.format('/warn %s %s %s [%s/%s]', id, days, reason, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                        else
                            sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                        end
                    else
                        atext('Игрок '..wnick..' вышел из игры')
                    end
                    checkstatdone = false
                    warnst = false
                    wbfrak = nil
                    wbrang = nil
                    wnick = nil
                end
            else
                atext("Игрок оффлайн")
            end
        else
            atext('Введите: /warn [id] [дни] [причина]')
        end
    end)
end
function ban(pam)
    lua_thread.create(function()
        local id, reason = pam:match('(%d+) (.+)')
        if id and reason then
            if sampIsPlayerConnected(id) then
                if sampGetPlayerScore(id) < 3 then
                    sampSendChat(string.format('/ban %s %s', id, reason))
                else
                    if reason == '1' or reason == 'dmg' then
                        sampSendChat(string.format('/ban %s %s', id, reason))
                    else
                        local wnick = sampGetPlayerNickname(id)
                        warnst = true
                        sampSendChat('/getstats '..id)
                        while not checkstatdone do wait(0) end
                        wait(1200)
                        if sampGetPlayerNickname(id) == wnick then
                            if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                                sampSendChat(string.format('/ban %s %s [%s/%s]', id, reason, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                            else
                                sampSendChat(string.format('/ban %s %s', id, reason))
                            end
                        else
                            atext('Игрок '..wnick..' вышел из игры')
                        end
                        wnick = nil
                        checkstatdone = false
                        wbfrak = nil
                        wbrang = nil
                        warnst = false
                    end
                end
            else
                atext("Игрок оффлайн")
            end
        else
            atext('Введите: /ban [id] [причина]')
        end
    end)
end
function wl(pam)
    local id = tonumber(pam)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnected(id) then
                sampSendChat('/warnlog '..sampGetPlayerNickname(id))
            else
                sampSendChat('/warnlog ' ..id)
            end
        else
            sampSendChat('/warnlog '..pam)
        end
    else
        atext('Введите /wl [id/nick]')
    end
end
function gs(pam)
    local id = tonumber(pam)
    if id ~= nil then
        if sampIsPlayerConnected(id) then
            sampSendChat('/getstats '..id)
        else
            atext('Игрок оффлайн')
        end
    else
        if reid ~= nil then
            sampSendChat('/getstats '..reid)
        else
            atext('Введите /gs [id]')
        end
    end
end
function sbiv(pam)
    local id = tonumber(pam)
    if id ~= nil then
        if sampIsPlayerConnected(id) then
            sampSendChat('/prison '..id..' 30 Сбив анимации')
        else
            atext('Игрок оффлайн')
        end
    else
        atext("Введите /sbiv [id]")
    end
end
function csbiv(pam)
    local id = tonumber(pam)
    if id ~= nil then
        if sampIsPlayerConnected(id) then
            sampSendChat('/prison '..id..' 60 Сбив анимации')
        else
            atext('Игрок оффлайн')
        end
    else
        atext("Введите /csbiv [id]")
    end
end
function cbug(pam)
    local id = tonumber(pam)
    if id ~= nil then
        if sampIsPlayerConnected(id) then
            sampSendChat('/prison '..id..' 60 +с вне гетто')
        else
            atext('Игрок оффлайн')
        end
    else
        atext("Введите /cbug [id]")
    end
end
function kills()
    sampShowDialog(21321, '{ffffff}Последние убийства', '{ffffff}Убийца\t{ffffff}Жертва\t{ffffff}Оружие\n'..table.concat(tkills, '\n'), 'x', _, 5)
end
function reportk()
    if reportid ~= nil then
        sampSendChat('/re '..reportid)
        traceid = reportid
    end
end
function warningk()
	if cwid ~= nil then
		sampSendChat('/re '..cwid)
	    traceid = cwid
	end
end
function banipk()
	if bip ~= nil then
		sampSendChat('/banip '..bip)
	end
end
function saveposk()
    savecoords.x, savecoords.y, savecoords.z = getCharCoordinates(PLAYER_PED)
    atext('Текущие координаты сохранены. Для телепортирования нажмите {a1dd4e}'..table.concat(rkeys.getKeysName(config_keys.goposkey.v)))
    cango = true
end
function goposk()
    if cango then
        setCharCoordinates(PLAYER_PED, savecoords.x, savecoords.y, savecoords.z)
    end
end
--24 = mongols
--26 = warlocks
--29 = pagans
function fonl(pam)
    lua_thread.create(function()
        local num = tonumber(pam)
        if num ~= nil then
            if num > 0 and num <= 29 then
                fonlcheck = true
                sampSendChat('/amembers '..num)
                while not fonldone do wait(0) end
                atext('Во фракции №{a1dd4e}'..num..' {ffffff}онлайн {a1dd4e}'..fonlnum..' {ffffff}человека')
                fonlcheck = false
                fonldone = false
                fonlnum = nil
            else
                atext('Значение не должно быть меньше 1 и больше 29!')
            end
        else
            atext('Введите /fonl [id фракции]')
        end
    end)
end
function checkrangs(pam)
    lua_thread.create(function()
        local num = tonumber(pam)
        if num ~= nil then
            if num > 0 and num <= 29 then
                check_frak = num
                checkfraks = true
                sampSendChat('/amembers '..num)
                while not checkfraksdone do wait(0) end
                if #checkf == 0 then
                    atext('Во фракции №{a1dd4e}'..check_frak..'{ffffff} все нормально с рангами.')
                else
                    sampAddChatMessage(' ', -1)
                    for k, v in pairs(checkf) do
                        sampAddChatMessage(' '..v, -1)
                    end
                    sampAddChatMessage(' ', -1)
                    atext('Фракция №{a1dd4e}'..check_frak)
                end
                checkfraks = false
                checkfraksdone = false
                check_frak = nil
                checkf = {}
            else
                atext('Значение не должно быть меньше 1 и больше 29!')
            end
        else
            atext('Введите /checkrangs [id фракции]')
        end
    end)
end
function ags(pam)
    local id = tonumber(pam)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnected(id) then
                sampSendChat('/agetstats '..sampGetPlayerNickname(id))
            else
                sampSendChat('/agetstats ' ..id)
            end
        else
            sampSendChat('/agetstats '..pam)
        end
    else
        atext('Введите /ags [id/nick]')
    end
end
