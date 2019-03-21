script_name('Admin Tools')
script_version('1.999995')
script_author('Thomas_Lawson, Edward_Franklin')
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
local effil = require 'effil'
local getBonePosition = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
local mem = require 'memory'
local wm = require 'lib.windows.message'
local screenx, screeny = getScreenResolution()
encoding.default = 'CP1251'
local imgui = require 'imgui'
imgui.HotKey = require('imgui_addons').HotKey
imgui.ToggleButton = require('imgui_addons').ToggleButton
local rkeys = require 'rkeys'
local mainwindow = imgui.ImBool(false)
local settingwindows = imgui.ImBool(false)
local tpwindow = imgui.ImBool(false)
local recon = imgui.ImBool(false)
local cmdwindow = imgui.ImBool(false)
local mpwindow = imgui.ImBool(false)
local bMainWindow = imgui.ImBool(false)
local sInputEdit = imgui.ImBuffer(256)
local bIsEnterEdit = imgui.ImBool(false)
local mpend = imgui.ImBool(false)
local mpname = imgui.ImBuffer(256)
local mpsponsors = imgui.ImBuffer(256)
local mpwinner = imgui.ImBuffer(256)
local wrecon = {}
local punishignor = {}
local nop = 0x90
local cursorenb = false
local u8 = encoding.UTF8
local airspeed = nil
local reid = '-1'
local cwid = nil
local check = false
local admins = {}
local nametagCoords = {}
local tpcount = 0
local tprep = false
local swork = true
local nametag = true
local skoktp = 0
local checkf = {}
local ips = {}
local temp_checker = {}
local temp_checker_online = {}
local rnick = nil
local notification_connect = nil
local notification_disconnect = nil
local smsids = {}
local PlayersNickname = {}
local reconstate = false
local config_keys = {
    banipkey = {v = {190}},
    warningkey = {v = {key.VK_Z}},
    reportkey = {v = {key.VK_X}},
    saveposkey = {v = {key.VK_M}},
    goposkey = {v = {key.VK_J}},
	tpmetka = {v = {key.VK_K}},
    cwarningkey = {v = {key.VK_R}},
    airbrkkey = {v = key.VK_RSHIFT}
}
local config_colors = {
    admchat = {r = 255, g = 255, b = 0, color = "FFFF00"},
    supchat = {r = 0, g = 255, b = 153, color = '00FF99'},
    smschat = {r = 255, g = 255, b = 0, color = "FFFF00"},
    repchat = {r = 217, g = 119, b = 0, color = "D97700"},
    anschat = {r = 140, g = 255, b = 155, color = "8CFF9B"},
    askchat = {r = 233, g = 165, b = 40, color = "E9A528"},
    jbchat = {r = 217, g = 119, b = 0, color = "D97700"}
}
local tEditData = {
	id = -1,
	inputActive = false
}
local frakrang = {
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
tBindList = {
	[1] = {
		text = "",
		v = {},
		time = 0
	},
	[2] = {
		text = "",
		v = {},
		time = 0
	},
	[3] = {
		text = "",
		v = {},
		time = 0
	}
}
local tkills = {}
local BulletSync = {lastId = 0, maxLines = 15}
for i = 1, BulletSync.maxLines do
	BulletSync[i] = {enable = true, o = {x, y, z}, t = {x, y, z}, time = 0, tType = 0}
end
local savecoords = {x = 0, y = 0, z = 0}
local traceid = -1
local players = {}
local admins_online = {}
local players_online = {}
local funcsStatus = {ClickWarp = false, Inv = false, AirBrk = false}
local tLastKeys = {}
local aafk = false
function WorkInBackground(wstate)
    local memory = require 'memory'
    if wstate then -- on
        memory.setuint8(7634870, 1)
        memory.setuint8(7635034, 1)
        memory.fill(7623723, 144, 8)
        memory.fill(5499528, 144, 6)
		aafk = true
    else -- off
        memory.setuint8(7634870, 0)
        memory.setuint8(7635034, 0)
        memory.hex2bin('5051FF1500838500', 7623723, 8)
        memory.hex2bin('0F847B010000', 5499528, 6)
		aafk = false
    end
end
function saveData(table, path)
	if doesFileExist(path) then os.remove(path) end
    local sfa = io.open(path, "w")
    if sfa then
        sfa:write(encodeJson(table))
        sfa:close()
    end
end
function argb_to_rgba(argb)
    local a, r, g, b = explode_argb(argb)
    return join_argb(r, g, b, a)
end
  
function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end
  
function join_argb(a, r, g, b)
     local argb = b
     argb = bit.bor(argb, bit.lshift(g, 8))
     argb = bit.bor(argb, bit.lshift(r, 16))
     argb = bit.bor(argb, bit.lshift(a, 24))
     return argb
end
  
function ARGBtoRGB(color) return bit32 or require'bit'.band(color, 0xFFFFFF) end
local data = {
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
        posy = screeny/2,
    },
    playerChecker = {
        enable = true,
        posx = screenx/2,
        posy = screeny/2,
    },
	tempChecker = {
		enable = true,
		posx = screenx/2,
        posy = screeny/2,
        wadd = true,
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
	timers = {
		sbivtimer = 30,
		csbivtimer = 60,
		cbugtimer = 60
    },
    joinquit = {
        joinposx = screenx/2,
        joinposy = screeny/2,
        quitposx = screenx/2,
        quitposy = screeny/2+20,
        enable = true
    },
    other = {
		passb = false,
		apassb = false,
        password = " ",
        adminpass = " ",
        reconw = true,
        checksize = 9,
        checkfont = 'Arial',
        whfont = "Verdana",
        whsize = 8,
        hudfont = "Times New Roman",
        hudsize = 10,
        fracstat = true,
        chatconsole = false,
        extraignor = false
    }
}
function asyncHttpRequest(method, url, args, resolve, reject)
   local request_thread = effil.thread(function (method, url, args)
      local requests = require 'requests'
      local result, response = pcall(requests.request, method, url, args)
      if result then
         response.json, response.xml = nil, nil
         return true, response
      else
         return false, response
      end
   end)(method, url, args)
   -- Если запрос без функций обработки ответа и ошибок.
   if not resolve then resolve = function() end end
   if not reject then reject = function() end end
   -- Проверка выполнения потока
   lua_thread.create(function()
      local runner = request_thread
      while true do
         local status, err = runner:status()
         if not err then
            if status == 'completed' then
               local result, response = runner:get()
               if result then
                  resolve(response)
               else
                  reject(response)
               end
               return
            elseif status == 'canceled' then
               return reject(status)
            end
         else
            return reject(err)
         end
         wait(0)
      end
   end)
end
function atext(text)
    sampAddChatMessage(string.format(' [Admin Tools] {ffffff}%s', text), 0x66FF00)
end
--[[function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    --[[style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0
    colors[clr.WindowBg]               = ImVec4(0.00, 0.00, 0.00, 0.9)
    colors[clr.FrameBg]                = ImVec4(0.11, 0.79, 0.07, 0.37)
    colors[clr.FrameBgHovered]         = ImVec4(0.11, 0.79, 0.07, 0.51)
    colors[clr.FrameBgActive]          = ImVec4(0.11, 0.79, 0.07, 0.76)
    colors[clr.TitleBg]                = ImVec4(0.07, 0.07, 0.08, 0.83)
    colors[clr.TitleBgActive]          = ImVec4(0.07, 0.07, 0.08, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.07, 0.07, 0.08, 0.42)
    colors[clr.ScrollbarBg]            = ImVec4(0.00, 0.00, 0.00, 0.15)
    colors[clr.ScrollbarGrab]          = ImVec4(0.11, 0.79, 0.07, 0.79)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.11, 0.79, 0.07, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.11, 0.79, 0.07, 0.40)
    colors[clr.Button]                 = ImVec4(0.11, 0.79, 0.07, 0.37)
    colors[clr.ButtonHovered]          = ImVec4(0.11, 0.79, 0.07, 0.51)
    colors[clr.ButtonActive]           = ImVec4(0.11, 0.79, 0.07, 0.76)
    colors[clr.Header]                 = ImVec4(0.11, 0.79, 0.07, 0.37)
    colors[clr.HeaderHovered]          = ImVec4(0.11, 0.79, 0.07, 0.51)
    colors[clr.HeaderActive]           = ImVec4(0.11, 0.79, 0.07, 0.76)
    colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.CloseButton]            = ImVec4(0.11, 0.79, 0.07, 0.37)
    colors[clr.CloseButtonHovered]     = ImVec4(0.11, 0.79, 0.07, 0.51)
    colors[clr.CloseButtonActive]      = ImVec4(0.11, 0.79, 0.07, 0.76) тут было ] ]
    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
    colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
    colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end]]
function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 5.0
    style.FramePadding = ImVec2(5, 5)
    style.FrameRounding = 4.0
    style.ItemSpacing = ImVec2(12, 8)
    style.ItemInnerSpacing = ImVec2(8, 6)
    style.IndentSpacing = 25.0
    style.ScrollbarSize = 15.0
    style.ScrollbarRounding = 9.0
    style.GrabMinSize = 5.0
    style.GrabRounding = 3.0

    colors[clr.Text] = ImVec4(0.80, 0.80, 0.83, 1.00)
    colors[clr.TextDisabled] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.WindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ChildWindowBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
    colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
    colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(1.00, 0.98, 0.95, 0.75)
    colors[clr.TitleBgActive] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.MenuBarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ScrollbarGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.ScrollbarGrabHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ScrollbarGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ComboBg] = ImVec4(0.19, 0.18, 0.21, 1.00)
    colors[clr.CheckMark] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrab] = ImVec4(0.80, 0.80, 0.83, 0.31)
    colors[clr.SliderGrabActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.Button] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.ButtonHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.ButtonActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.Header] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.HeaderHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.HeaderActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.ResizeGripHovered] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
    colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
    colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
    colors[clr.PlotLines] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotLinesHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.PlotHistogram] = ImVec4(0.40, 0.39, 0.38, 0.63)
    colors[clr.PlotHistogramHovered] = ImVec4(0.25, 1.00, 0.00, 1.00)
    colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
    colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
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
function rainbow(speed, alpha)
	local r = math.sin(os.clock() * speed)
	local g = math.sin(os.clock() * speed + 2)
	local b = math.sin(os.clock() * speed + 4)
	return r,g,b,alpha
end
function sampGetStreamedPlayers()
	local t = {}
	for i = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) then
			local result, sped = sampGetCharHandleBySampPlayerId(i)
			if result then
				if doesCharExist(sped) then
					table.insert(t, i)
				end
			end
		end
	end
	return t
end
function registerFastAnswer()
	for line in io.lines('moonloader/config/Admin Tools/fa.txt') do
        local cmd, text = line:match('(.+) = (.+)')
        if cmd and text then
            if sampIsChatCommandDefined(cmd) then sampUnregisterChatCommand(cmd) end
            sampRegisterChatCommand(cmd, function(pam)
                cID = tonumber(pam)
                if cID ~= nil then
                    sampSendChat('/pm '..cID..' '..text, -1)
                else
                    if pam ~= nil then
                        sampSendChat('/'..cmd..' '..pam, -1)
                    end
                end
            end)
        end
    end
end
function autoupdate(json_url, prefix, url)
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile(json_url, json,
      function(id, status, p1, p2)
        if status == dlstatus.STATUSEX_ENDDOWNLOAD then
          if doesFileExist(json) then
            local f = io.open(json, 'r')
            if f then
              local info = decodeJson(f:read('*a'))
              updatelink = info.updateurl
              updateversion = info.latest
              f:close()
              os.remove(json)
              if updateversion > thisScript().version then
                lua_thread.create(function()
                  local dlstatus = require('moonloader').download_status
                  local color = -1
                  atext('Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion)
                  wait(250)
                  downloadUrlToFile(updatelink, thisScript().path,
                    function(id3, status1, p13, p23)
                      if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                        print(string.format('Загружено %d из %d.', p13, p23))
                      elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                        print('Загрузка обновления завершена.')
                        atext('Обновление завершено!')
                        goupdatestatus = true
                        lua_thread.create(function() wait(500) thisScript():reload() end)
                      end
                      if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                        if goupdatestatus == nil then
                            atext('Обновление прошло неудачно. Запускаю устаревшую версию..')
                          update = false
                        end
                      end
                    end
                  )
                  end, prefix
                )
              else
                update = false
                print('v'..thisScript().version..': Обновление не требуется.')
              end
            end
          else
            print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
            update = false
          end
        end
      end
    )
    while update ~= false do wait(100) end
end
function split(str, delim, plain)
    local lines, pos, plain = {}, 1, not (plain == false) --[[ delimiter is plain text by default ]]
    repeat
        local npos, epos = string.find(str, delim, pos, plain)
        table.insert(lines, string.sub(str, pos, npos and npos - 1))
        pos = epos and epos + 1
    until not pos
    return lines
end

function text_notify_connect(msg, color)
    if not msg then return end
    local displayDuration = math.max(#msg * 0.065, 3)
    notification_connect = {
        color = bit.band(color or 0xEEEEEE, 0xFFFFFF),
        lines = split(msg, '\n'),
        duration = displayDuration,
        tick = localClock()
    }
end
function text_notify_disconnect(msg, color)
    if not msg then return end
    local displayDuration = math.max(#msg * 0.065, 3)
    notification_disconnect = {
        color = bit.band(color or 0xEEEEEE, 0xFFFFFF),
        lines = split(msg, '\n'),
        duration = displayDuration,
        tick = localClock()
    }
end
function main()
    local samp = getModuleHandle('samp.dll')
	mem.fill(samp + 0x9D31A, nop, 12, true)
    mem.fill(samp + 0x9D329, nop, 12, true)
    mem.fill(sampGetBase() + 0x2D3C45, 0, 2, true)
	mem.fill(0x00531155, 0x90, 5, true)
    local DWMAPI = ffi.load('dwmapi')
    local directors = {'moonloader/Admin Tools', 'moonloader/Admin Tools/hblist', 'moonloader/config', 'moonloader/config/Admin Tools'}
    local files = {'moonloader/Admin Tools/chatlog_all.txt', 'moonloader/config/Admin Tools/fa.txt', 'moonloader/Admin Tools/punishjb.txt', 'moonloader/Admin Tools/punishlogs.txt'}
	for k, v in pairs(directors) do
		if not doesDirectoryExist(v) then createDirectory(v) end
	end
    for k, v in pairs(files) do
        if not doesFileExist(v) then 
            local file = io.open(v, 'w')
            file:close()
        end
    end
    if not doesFileExist('moonloader/config/Admin Tools/punishignor.txt') then
        local file = io.open('moonloader/config/Admin Tools/punishignor.txt', 'w')
        file:write('1\n!\ndmg')
        file:close()
    end
    for line in io.lines('moonloader/config/Admin Tools/punishignor.txt') do table.insert(punishignor, line) end
    DWMAPI.DwmEnableComposition(1)
    cfg = inicfg.load(config, 'Admin Tools\\config.ini')
    repeat wait(0) until isSampAvailable()
    autoupdate("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/update.json", '[Admin Tools]', "https://evolve-rp.su/viewtopic.php?f=21&t=151439")
    lua_thread.create(wh)
    registerFastAnswer()
    sampRegisterChatCommand('aafk', function()
		if aafk then
            WorkInBackground(false)
		else
			WorkInBackground(true)
        end
        atext(tostring(aafk))
    end)
    sampRegisterChatCommand('hblist', hblist)
    sampRegisterChatCommand('getlvl', getlvl)
    sampRegisterChatCommand('punish', punish)
    sampRegisterChatCommand('fid', function() sampShowDialog(3435, '{ffffff}ID Фракций', '{ffffff}ID\t{ffffff}Фракция\n1\tLSPD\n2\tFBI\n3\tSFA\n5\tLCN\n6\tYakuza\n7\tMayor\n9\tSFN\n10\tSFPD\n11\tInstructors\n12\tBallas\n13\tVagos\n14\tRM\n15\tGrove\n16\tLSN\n17\tAztec\n18\tRifa\n19\tLVA\n20\tLVN\n21\tLVPD\n22\tHospital\n24\tMongols\n26\tWarlocks\n29\tPagans', 'x', _, 5) end)
    sampRegisterChatCommand('arecon', arecon)
    sampRegisterChatCommand('guns', function() sampShowDialog(3435, '{ffffff}Оружия', '{ffffff}ID\t{ffffff}Название\n1\tКастет\n2\tКлюшка для гольфа\n3\tПолицейская дубинка\n4\tНож\n5\tБита\n6\tЛопата\n7\tКий\n8\tКатана\n9\tБензопила\n10\tДилдо\n11\tДилдо\n12\tВибратор\n13\tВибратор\n14\tЦветы\n15\tТрость\n16\tГраната\n17\tДымовая граната\n18\tКоктейль Молотова\n22\t9mm пистолет\n23\tSDPistol\n24\tDesert Eagle\n25\tShotgun\n26\tОбрез\n27\tCombat Shotgun\n28\tUZI\n29\tMP5\n30\tAK-47\n31\tM4\n32\tTec-9\n33\tCountry Rifle\n34\tSniper Rifle\n35\tRPG\n36\tHS Rocket\n37\tОгнемёт\n38\tМиниган\n39\tSatchel Charge\n40\tДетонатор\n41\tSpraycan\n42\tОгнетушитель\n43\tФотоаппарат\n44\tNight Vis Goggles\n45\tThermal Goggles\n46\tParachute', 'x', _, 5) end)
    sampRegisterChatCommand('tg', function() sampSendChat('/togphone') end)
    sampRegisterChatCommand('blog', blog)
    sampRegisterChatCommand('masstp', masstp)
    sampRegisterChatCommand('masshb', masshb)
    sampRegisterChatCommand('givehb', givehb)
	sampRegisterChatCommand('addtemp', addtemp)
    sampRegisterChatCommand('deltemp', deltemp)
    sampRegisterChatCommand('deltempall', function() temp_checker = {} temp_checker_online = {} end)
	sampRegisterChatCommand('massgun', massgun)
	sampRegisterChatCommand('masshp', masshp)
	sampRegisterChatCommand('massarm', massarm)
	sampRegisterChatCommand('cip', cip)
    sampRegisterChatCommand('al', function() sampSendChat('/alogin') end)
    sampRegisterChatCommand('at_reload', function() showCursor(false); nameTagOn(); thisScript():reload() end)
    sampRegisterChatCommand('checkrangs', checkrangs)
    sampRegisterChatCommand('spiar', function() sampSendChat('/o Есть вопросы по игре? Задайте их нашим саппортам - /ask') end)
    sampRegisterChatCommand('fonl', fonl)
    sampRegisterChatCommand('kills', kills)
    sampRegisterChatCommand('cbug', cbug)
    sampRegisterChatCommand('sbiv', sbiv)
    sampRegisterChatCommand('csbiv', csbiv)
	sampRegisterChatCommand('cheat', cheat)
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
    --loadadmins()
    admchecker()
    if not doesFileExist("moonloader/config/Admin Tools/keys.json") then
        local fa = io.open("moonloader/config/Admin Tools/keys.json", "w")
        fa:close()
    else
        local fa = io.open("moonloader/config/Admin Tools/keys.json", 'r')
        if fa then
            config_keys = decodeJson(fa:read('*a'))
			if config_keys == nil then
				config_keys = {
				    banipkey = {v = {190}},
				    warningkey = {v = {key.VK_Z}},
				    reportkey = {v = {key.VK_X}},
				    saveposkey = {v = {key.VK_M}},
				    goposkey = {v = {key.VK_J}},
					tpmetka = {v = {key.VK_K}},
                    cwarningkey = {v = {key.VK_R}},
                    airbrkkey = {v = key.VK_RSHIFT}
				}
			end
			if config_keys.cwarningkey == nil then config_keys.cwarningkey = {v = {key.VK_R}} end
            if config_keys.airbrkkey == nil then config_keys.airbrkkey = {v = key.VK_RSHIFT} end
        end
    end
    saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
	if not doesFileExist("moonloader/config/Admin Tools/binder.json") then
		local fb = io.open("moonloader/config/Admin Tools/binder.json", "w")
		fb:close()
	else
		local fb = io.open("moonloader/config/Admin Tools/binder.json", "r")
		if fb then
			tBindList = decodeJson(fb:read('*a'))
			if tBindList == nil then
				tBindList = {
			        [1] = {
			            text = "",
			            v = {},
			            time = 0
			        },
			        [2] = {
			            text = "",
			            v = {},
			            time = 0
			        },
			        [3] = {
			            text = "",
			            v = {},
			            time = 0
			        }
			    }
			end
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
    if not doesFileExist("moonloader/config/Admin Tools/colors.json") then
        local fc = io.open("moonloader/config/Admin Tools/colors.json", 'w')
        fc:close()
    else
        local fc = io.open("moonloader/config/Admin Tools/colors.json", "r")
        if fc then
            config_colors = decodeJson(fc:read('*a'))
            if config_colors == nil then
                config_colors = {
                    admchat = {r = 255, g = 255, b = 0, color = "FFFF00"},
                    supchat = {r = 0, g = 255, b = 153, color = '00FF99'},
                    smschat = {r = 255, g = 255, b = 0, color = "FFFF00"},
                    repchat = {r = 217, g = 119, b = 0, color = "D97700"},
                    anschat = {r = 140, g = 255, b = 155, color = "8CFF9B"},
                    askchat = {r = 233, g = 165, b = 40, color = "E9A528"},
                    jbchat = {r = 217, g = 119, b = 0, color = "D97700"}
                }
            end
        end
    end
    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
    ar, ag, ab = imgui.ImColor(config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b):GetFloat4()
    acolor = imgui.ImFloat3(ar, ag, ab)
    sr, sg, sb = imgui.ImColor(config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b):GetFloat4()
    scolor = imgui.ImFloat3(sr, sg, sb)
    smsr, smsg, smsb = imgui.ImColor(config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b):GetFloat4()
    smscolor = imgui.ImFloat3(smsr, smsg, smsb)
    jbr, jbg, jbb = imgui.ImColor(config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b):GetFloat4()
    jbcolor = imgui.ImFloat3(jbr, jbg, jbb)
    askr, askg, askb = imgui.ImColor(config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b):GetFloat4()
    askcolor = imgui.ImFloat3(askr, askg, askb)
    repr, repg, repb = imgui.ImColor(config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b):GetFloat4()
    repcolor = imgui.ImFloat3(repr, repg, repb)
    ansr, ansg, ansb = imgui.ImColor(config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b):GetFloat4()
    anscolor = imgui.ImFloat3(ansr, ansg, ansb)
	for k, v in pairs(tBindList) do
        rkeys.registerHotKey(v.v, true, onHotKey)
        if v.time == nil then v.time = 0 end
    end
    reportbind = rkeys.registerHotKey(config_keys.reportkey.v, true, reportk)
    warningbind = rkeys.registerHotKey(config_keys.warningkey.v, true, warningk)
    banipbind = rkeys.registerHotKey(config_keys.banipkey.v, true, banipk)
    saveposbind = rkeys.registerHotKey(config_keys.saveposkey.v, true, saveposk)
    goposbind = rkeys.registerHotKey(config_keys.goposkey.v, true, goposk)
	tpmetkabind = rkeys.registerHotKey(config_keys.tpmetka.v, true, tpmetkak)
	cwarningbind = rkeys.registerHotKey(config_keys.cwarningkey.v, true, cwarningk)
	addEventHandler("onWindowMessage", function (msg, wparam, lparam)
        if msg == wm.WM_KEYDOWN or msg == wm.WM_SYSKEYDOWN then
            if tEditData.id > -1 then
                if wparam == key.VK_ESCAPE then
                    tEditData.id = -1
                    consumeWindowMessage(true, true)
                elseif wparam == key.VK_TAB then
                    bIsEnterEdit.v = not bIsEnterEdit.v
                    consumeWindowMessage(true, true)
                end
            end
        end
    end)
    if cfg.cheat.autogm then
        funcsStatus.Inv = true
    end
	for k, v in ipairs(admins) do
		local id = sampGetPlayerIdByNickname(v['nick'])
		if id ~= nil then
			table.insert(admins_online, {nick = v['nick'], id = id, color = v['color'], text = v['text']})
		end
    end
    for k, v in ipairs(players) do
		local id = sampGetPlayerIdByNickname(v['nick'])
		if id ~= nil then
			table.insert(players_online, {nick = v['nick'], id = id, color = v['color'], text = v['text']})
		end
	end
    lua_thread.create(clickF)
    lua_thread.create(renders)
    lua_thread.create(main_funcs)
    lua_thread.create(check_keys_fast)
    while true do wait(0)
        if wasKeyPressed(key.VK_F12) and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then swork = not swork 
            if not swork then
                nameTagOn()
            else
                nameTagOff()
            end
        end
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
		if data.imgui.tempcheckpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.tempChecker.posx = curX
            cfg.tempChecker.posy = curY
        end
        if data.imgui.joinpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.joinquit.joinposx = curX
            cfg.joinquit.joinposy = curY
        end
        if data.imgui.quitpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.joinquit.quitposx = curX
            cfg.joinquit.quitposy = curY
        end
        if isKeyJustPressed(key.VK_LBUTTON) and (data.imgui.admcheckpos or data.imgui.playercheckpos or data.imgui.reconpos or data.imgui.tempcheckpos or data.imgui.joinpos or data.imgui.quitpos) then
            data.imgui.admcheckpos = false
            data.imgui.playercheckpos = false
            data.imgui.reconpos = false
            data.imgui.tempcheckpos = false
            data.imgui.joinpos = false
            data.imgui.quitpos = false
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
    local btn_size = imgui.ImVec2(-0.1, 0)
	local ir, ig, ib, ia = rainbow(1, 1)
	--imgui.PushStyleColor(imgui.Col.Border, imgui.ImVec4(ir, ig, ib, ia))
    --
    if recon.v then
		local style = imgui.GetStyle()
		local colors = style.Colors
		local clr = imgui.Col
		local ImVec4 = imgui.ImVec4
        imgui.ShowCursor = false
		imgui.LockPlayer = false
        local imvsize = imgui.GetWindowSize()
        local spacing, height = 140.0, 162.0
        local imkx, imky = convertGameScreenCoordsToWindowScreenCoords(530, 199)
        imgui.PushStyleColor(imgui.Col.Separator, imgui.ImVec4(ir, ig, ib, ia))
		--imgui.PushStyleColor(imgui.Col.WindowBg, imgui.ImVec4(1, 0, 0, 1))
        imgui.SetNextWindowPos(imgui.ImVec2(cfg.crecon.posx, cfg.crecon.posy), imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(260, 285), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Слежка за игроком', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
        imgui.CentrText(('%s'):format(imtextnick))
        imgui.CentrText(('ID: %s'):format(reid))
        if reafk then
            imgui.SameLine()
            imgui.TextColored(ImVec4(255, 0, 0, 1),'AFK')
        end
        imgui.Separator()
        imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(1.0, 2.5))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Level:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextlvl))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Warns:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextwarn))
        imgui.TextColored(ImVec4(255, 0, 0, 1), u8"Armour:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextarm))
        imgui.TextColored(ImVec4(255, 0, 0, 1), u8"Health:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtexthp))
        imgui.TextColored(ImVec4(0, 49, 245, 1), u8"Car HP:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextcarhp))
        imgui.TextColored(ImVec4(0, 49, 245, 1), u8"Speed:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextspeed))
        imgui.TextColored(ImVec4(255, 255, 0, 1), u8"Ping:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextping))
        imgui.TextColored(ImVec4(255, 255, 0, 1), u8"Ammo:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextammo))
        imgui.TextColored(ImVec4(225, 0, 255, 1), u8"Shot:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextshot))
        imgui.TextColored(ImVec4(225, 0, 255, 1), u8"Time Shot:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtexttimeshot))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"AFK Time:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextafktime))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Engine:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextengine))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Pro Sport:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtextprosport))
        imgui.PopStyleVar()
        --[[imgui.SameLine()
        imgui.Text(string.format('%s', imgui.GetWindowSize().y))]]
        imgui.End()
        --imgui.PopStyleColor()
        imgui.PopStyleColor()
        --[[local rbtn_size = imgui.ImVec2(150, 33)
        imgui.SetNextWindowPos(imgui.ImVec2(20, cfg.crecon.posy), imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(150, 308), imgui.Cond.FirstUseEver)
        imgui.Begin('##1112312321321321321312',_, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove + imgui.WindowFlags.NoTitleBar)
        if imgui.Button(u8 'Change', btn_size) then sampSendClickTextdraw(2165) end
        if imgui.Button(u8 'Check »', btn_size) then end
        if imgui.Button(u8 'Drop »', btn_size) then end
        if imgui.Button(u8 'Kick »', btn_size) then end
        if imgui.Button(u8 'Warn', btn_size) then sampSendClickTextdraw(2169) end
        if imgui.Button(u8 'Ban »', btn_size) then end
        if imgui.Button(u8 'Stats »', btn_size) then end
        if imgui.Button(u8 'Refresh', btn_size) then sampSendClickTextdraw(2172) end
        if imgui.Button(u8 'Exit', btn_size) then sampSendClickTextdraw(2173) end
        if imgui.IsKeyDown(0x04) then imgui.ShowCursor = not imgui.ShowCursor end
        imgui.End()]]
    end
    if mainwindow.v then
        imgui.ShowCursor = true
        local btn_size = imgui.ImVec2(-0.1, 0)
        imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin('Admin Tools', mainwindow, imgui.WindowFlags.NoResize)
        if imgui.Button(u8 'Настройки', btn_size) then settingwindows.v = not settingwindows.v end
        if imgui.Button(u8 'Телепорты', btn_size) then tpwindow.v = not tpwindow.v end
        if imgui.Button(u8 'Команды скрипта', btn_size) then cmdwindow.v = not cmdwindow.v end
        if imgui.Button(u8 'Мероприятие', btn_size) then mpwindow.v = not mpwindow.v end
		if imgui.Button(u8 'Биндер', btn_size) then bMainWindow.v = not bMainWindow.v end
        imgui.End()
        if mpwindow.v then
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
            imgui.Begin(u8 'Admin Tools | Мероприятие', mpwindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
            imgui.Checkbox(u8 'Конец МП', mpend)
            imgui.Separator()
            if not mpend.v then
                imgui.InputText(u8 'Название мероприятия', mpname)
                imgui.InputText(u8 'Спонсоры мероприятия', mpsponsors)
                imgui.Text(u8'Вывод:')
                imgui.Separator()
                imgui.TextWrapped((u8'Желающие на МП "%s" + в SMS. Сразу из машин выходите'):format(mpname.v))
            else
                imgui.InputText(u8 'Победитель мероприятия', mpwinner)
                imgui.InputText(u8 'Спонсоры мероприятия', mpsponsors)
                imgui.Text(u8'Вывод:')
                imgui.Separator()
                imgui.TextWrapped((u8'Победитель МП "%s" - %s'):format(mpname.v, mpwinner.v))
                imgui.TextWrapped((u8'Спонсоры: %s'):format(mpsponsors.v))
            end
            if imgui.Button(u8 'Объявить в /o') then
                lua_thread.create(function()
                    if mpend.v then
                        sampSendChat(('/o Победитель МП "%s" - %s'):format(u8:decode(mpname.v), u8:decode(mpwinner.v)))
                        wait(1200)
                        sampSendChat(('/o Спонсоры: %s'):format(u8:decode(mpsponsors.v)))
                    else
                        sampSendChat((('/o Желающие на МП "%s" + в SMS. Сразу из машин выходите'):format(u8:decode(mpname.v))))
                    end
                end)
            end
            imgui.SameLine()
            if imgui.Button(u8 'Очистить поля') then
                mpname.v = ''
                mpwinner.v = ''
                mpsponsors.v = ''
            end
            imgui.End()
        end
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
            if imgui.CollapsingHeader('/arecon', btn_size) then
                imgui.TextWrapped(u8 'Описание: Переподключиться к серверу')
                imgui.TextWrapped(u8 'Использование: /arecon')
            end
            if imgui.CollapsingHeader('/tg', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /togphone')
                imgui.TextWrapped(u8 'Использование: /tg')
            end
            if imgui.CollapsingHeader('/spiar', btn_size) then
                imgui.TextWrapped(u8 'Описание: Написать пиар /ask в /o чат')
                imgui.TextWrapped(u8 'Использование: /spiar')
            end
            if imgui.CollapsingHeader('/getlvl', btn_size) then
                imgui.TextWrapped(u8 'Описание: Узнать всех игроков с определенным уровнем на сервере')
                imgui.TextWrapped(u8 'Использование: /getlvl [уровень]')
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
                imgui.TextWrapped(u8 ('Описание: Посадить игрока на %s минут в деморган по причине "Сбив анимации"'):format(cfg.timers.sbivtimer))
                imgui.TextWrapped(u8 'Использование: /sbiv [id]')
            end
            if imgui.CollapsingHeader('/csbiv', btn_size) then
                imgui.TextWrapped(u8 ('Описание: Посадить игрока на %s минут в деморган по причине "Сбив анимации"'):format(cfg.timers.csbivtimer))
                imgui.TextWrapped(u8 'Использование: /csbiv [id]')
            end
            if imgui.CollapsingHeader('/cbug', btn_size) then
                imgui.TextWrapped(u8 ('Описание: Посадить игрока на %s минут в деморган по причине "+с вне гетто"'):format(cfg.timers.cbugtimer))
                imgui.TextWrapped(u8 'Использование: /cbug [id]')
            end
			if imgui.CollapsingHeader('/cheat', btn_size) then
                imgui.TextWrapped(u8 'Описание: Забанить(1-2 уровни) / заварнить(3+ уровни) по причине "cheat"')
                imgui.TextWrapped(u8 'Использование: /cheat [id]')
            end
            if imgui.CollapsingHeader('/kills', btn_size) then
                imgui.TextWrapped(u8 'Описание: Узнать 50 последний убийств из килл-листа')
                imgui.TextWrapped(u8 'Использование: /kills')
            end
            if imgui.CollapsingHeader('/guns', btn_size) then
                imgui.TextWrapped(u8 'Описание: Открыть диалог с ID оружий')
                imgui.TextWrapped(u8 'Использование: /guns')
            end
            if imgui.CollapsingHeader('/wl', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /warnlog')
                imgui.TextWrapped(u8 'Использование: /wl [id/nick]')
            end
            if imgui.CollapsingHeader('/blog', btn_size) then
                imgui.TextWrapped(u8 'Описание: Сокращение команды /banlog')
                imgui.TextWrapped(u8 'Использование: /blog [id/nick]')
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
			if imgui.CollapsingHeader('/addtemp', btn_size) then
                imgui.TextWrapped(u8 'Описание: Добавить игрока в временный чекер')
                imgui.TextWrapped(u8 'Использование: /addtemp [id/nick]')
            end
            if imgui.CollapsingHeader('/deladm', btn_size) then
                imgui.TextWrapped(u8 'Описание: Удалить игрока из чекера админов')
                imgui.TextWrapped(u8 'Использование: /deladm [id/nick]')
            end
            if imgui.CollapsingHeader('/delplayer', btn_size) then
                imgui.TextWrapped(u8 'Описание: Удалить игрока из чекера игроков')
                imgui.TextWrapped(u8 'Использование: /delplayer [id/nick]')
            end
			if imgui.CollapsingHeader('/deltemp', btn_size) then
                imgui.TextWrapped(u8 'Описание: Удалить игрока из временного чекера')
                imgui.TextWrapped(u8 'Использование: /deltemp [id/nick]')
            end
            if imgui.CollapsingHeader('/deltempall', btn_size) then
                imgui.TextWrapped(u8 'Описание: Удалить всех игроков из временного чекера')
                imgui.TextWrapped(u8 'Использование: /deltempall')
            end
            if imgui.CollapsingHeader('/masstp', btn_size) then
                imgui.TextWrapped(u8 'Описание: Начать / окончить телепортацию по СМС')
                imgui.TextWrapped(u8 'Использование: /masstp')
            end
			if imgui.CollapsingHeader('/masshp', btn_size) then
                imgui.TextWrapped(u8 'Описание: Выдать ХП игрока в зоне стрима')
                imgui.TextWrapped(u8 'Использование: /masshp [кол-во хп]')
            end
			if imgui.CollapsingHeader('/massarm', btn_size) then
                imgui.TextWrapped(u8 'Описание: Выдать броню игрокам в зоне стрима')
                imgui.TextWrapped(u8 'Использование: /massarm [кол-во брони]')
            end
			if imgui.CollapsingHeader('/massgun', btn_size) then
                imgui.TextWrapped(u8 'Описание: Выдать оружие игрокам в зоне стрима')
                imgui.TextWrapped(u8 'Использование: /massgun [id оружия] [кол-во патронов]')
            end
            if imgui.CollapsingHeader('/masshb', btn_size) then
                imgui.TextWrapped(u8 'Описание: Выдать комплект объектов игрокам в зоне стрима')
                imgui.TextWrapped(u8 'Использование: /masshb [имя комплекта]')
            end
            if imgui.CollapsingHeader('/hblist', btn_size) then
                imgui.TextWrapped(u8 'Описание: Узнать список комплектов с объевтами (Комплекты находятся по пути moonloader/Admin Tools/hblist)')
                imgui.TextWrapped(u8 'Использование: /hblist')
            end
            if imgui.CollapsingHeader('/givehb', btn_size) then
                imgui.TextWrapped(u8 'Описание: Выдать комлпект объектов игроку')
                imgui.TextWrapped(u8 'Использование: /givehb [id] [имя комплекта]')
            end
            if imgui.CollapsingHeader('/punish', btn_size) then
                imgui.TextWrapped(u8 'Описание: Выдать наказания по жалобам из списка, заготовленым прогаммой Стронга')
                imgui.TextWrapped(u8 'Использование: /punish')
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
            imgui.LockPlayer = true
            imgui.SetNextWindowPos(imgui.ImVec2(screenx / 2, screeny / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(15,6))
            imgui.Begin(u8 'Admin Tools | Настройки', settingwindows, imgui.WindowFlags.NoResize)
            imgui.BeginChild('##set', imgui.ImVec2(200, 400), true)
            if imgui.Selectable(u8 'Настройка клавиш', data.imgui.menu == 1 ) then data.imgui.menu = 1 end
            if imgui.Selectable(u8 'Настройка читов', data.imgui.menu == 2) then data.imgui.menu = 2 end
            if data.imgui.menu == 2 then
                if imgui.Selectable(u8 '  AirBrake', data.imgui.cheat == 1) then data.imgui.cheat = 1 end
                if imgui.Selectable(u8 '  GodMode', data.imgui.cheat == 2) then data.imgui.cheat = 2 end
                if imgui.Selectable(u8 '  WallHack', data.imgui.cheat == 3) then data.imgui.cheat = 3 end
            end
            if imgui.Selectable(u8 'Настройка чекеров', data.imgui.menu == 3) then data.imgui.menu = 3 end
            if data.imgui.menu == 3 then
                if imgui.Selectable(u8 '  Чекер админов', data.imgui.checker == 1) then data.imgui.checker = 1 end
                if imgui.Selectable(u8 '  Чекер игроков', data.imgui.checker == 2) then data.imgui.checker = 2 end
				if imgui.Selectable(u8 '  Временный чекер', data.imgui.checker == 3) then data.imgui.checker = 3 end
            end
            if imgui.Selectable(u8 'Настройка выдачи наказаний', data.imgui.menu == 4) then data.imgui.menu = 4 end
            if imgui.Selectable(u8 'Насройка цветов', data.imgui.menu == 6) then data.imgui.menu = 6 end
			if imgui.Selectable(u8 'Остальные настройки', data.imgui.menu == 5) then data.imgui.menu = 5 end
            imgui.EndChild()
            imgui.SameLine()
            imgui.BeginChild('##set1', imgui.ImVec2(740, 400), true)
            if data.imgui.menu == 1 then
                if imgui.HotKey('##warningkey', config_keys.warningkey, tLastKeys, 100) then
                    rkeys.changeHotKey(warningbind, config_keys.warningkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша перехода по серверным варнингам')
				if imgui.HotKey('##warningkey1', config_keys.cwarningkey, tLastKeys, 100) then
                    rkeys.changeHotKey(cwarningbind, config_keys.cwarningkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша перехода по скриптовым варнингам')
                if imgui.HotKey('##reportkey', config_keys.reportkey, tLastKeys, 100) then
                    rkeys.changeHotKey(reportbind, config_keys.reportkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша перехода по репорту')
                if imgui.HotKey('##banipkey', config_keys.banipkey, tLastKeys, 100) then
                    rkeys.changeHotKey(banipbind, config_keys.banipkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша бана IP адреса')
                if imgui.HotKey('##saveposkey', config_keys.saveposkey, tLastKeys, 100) then
                    rkeys.changeHotKey(saveposbind, config_keys.saveposkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша сохранения координат')
                if imgui.HotKey('##goposkey', config_keys.goposkey, tLastKeys, 100) then
                    rkeys.changeHotKey(goposbind, config_keys.goposkey.v)
					saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
                end
                imgui.SameLine(); imgui.Text(u8 'Клавиша телепорта на сохраненные координаты')
            elseif data.imgui.menu == 2 then
                if data.imgui.cheat == 1 then
					local airfloat = imgui.ImFloat(cfg.cheat.airbrkspeed)
                    imgui.CentrText(u8 'AirBrake')
                    imgui.Separator()
					if imgui.SliderFloat(u8 'Начальная скорость', airfloat, 0.05, 10, '%0.2f') then cfg.cheat.airbrkspeed = airfloat.v inicfg.save(config, 'Admin Tools\\config.ini') end
                elseif data.imgui.cheat == 2 then
                    local godModeB = imgui.ImBool(cfg.cheat.autogm)
                    imgui.CentrText(u8 'GodMode')
                    imgui.Separator()
                    if imgui.ToggleButton(u8 'Включить гмм##11', godModeB) then cfg.cheat.autogm = godModeB.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Автоматически включать ГМ при входе в игру')
                elseif data.imgui.cheat == 3 then
                    local whfontb = imgui.ImBuffer(tostring(cfg.other.whfont), 256)
                    local whsizeb = imgui.ImInt(cfg.other.whsize)
                    imgui.CentrText(u8 'WallHack')
                    imgui.Separator()
                    if imgui.InputText(u8 'Шрифт##wh', whfontb) then cfg.other.whfont = whfontb.v whfont = renderCreateFont(cfg.other.whfont, cfg.other.whsize, 4) inicfg.save(config, 'Admin Tools\\config.ini') end
                    if imgui.InputInt(u8 'Размер шрифта##wh', whsizeb, 0) then cfg.other.whsize = whsizeb.v whfont = renderCreateFont(cfg.other.whfont, cfg.other.whsize, 4) inicfg.save(config, 'Admin Tools\\config.ini') end
                end
            elseif data.imgui.menu == 3 then
                local checksizeb = imgui.ImInt(cfg.other.checksize)
                local checkfontb = imgui.ImBuffer(tostring(cfg.other.checkfont), 256)
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
                elseif data.imgui.checker == 3 then
					local tempChetckerB = imgui.ImBool(cfg.tempChecker.enable)
					imgui.CentrText(u8 'Временный чекер')
					imgui.Separator()
					if imgui.ToggleButton(u8 'Включить чекер##3', tempChetckerB) then cfg.tempChecker.enable = tempChetckerB.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Включить чекер')
					if cfg.tempChecker.enable then
						local tempWarningB = imgui.ImBool(cfg.tempChecker.wadd)
                        imgui.Text(u8 'Местоположение чекера')
                        imgui.SameLine()
                        if imgui.Button(u8 'Изменить##3') then data.imgui.tempcheckpos = true; mainwindow.v = false end
						if imgui.ToggleButton(u8 'Добавлять в черер игроков по варнингу', tempWarningB) then cfg.tempChecker.wadd = tempWarningB.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Добавлять в черер игроков по варнингу')
                    end
                end
                imgui.Separator()
                if imgui.InputText(u8 'Шрифт', checkfontb) then cfg.other.checkfont = checkfontb.v checkfont = renderCreateFont(cfg.other.checkfont, cfg.other.checksize, 4) inicfg.save(config, 'Admin Tools\\config.ini') end
                if imgui.InputInt(u8 'Размер шрифта', checksizeb, 0) then cfg.other.checksize = checksizeb.v; checkfont = renderCreateFont(cfg.other.checkfont, cfg.other.checksize, 4) inicfg.save(config, 'Admin Tools\\config.ini') end
            elseif data.imgui.menu == 4 then
				local sbivb = imgui.ImInt(cfg.timers.sbivtimer)
				local csbivb = imgui.ImInt(cfg.timers.csbivtimer)
                local cbugb = imgui.ImInt(cfg.timers.cbugtimer)
                local fracstatb = imgui.ImBool(cfg.other.fracstat)
				imgui.CentrText(u8 'Настройка выдачи наказаний')
				imgui.Separator()
				if imgui.InputInt(u8 'Таймер сбива (/sbiv)', sbivb, 0) then cfg.timers.sbivtimer = sbivb.v; inicfg.save(config, 'Admin Tools\\config.ini') end
				if imgui.InputInt(u8 'Таймер клео сбива (/csbiv)', csbivb, 0) then cfg.timers.csbivtimer = csbivb.v; inicfg.save(config, 'Admin Tools\\config.ini') end
                if imgui.InputInt(u8 'Таймер +с вне гетто (/cbug)', cbugb, 0) then cfg.timers.cbugtimer = cbugb.v; inicfg.save(config, 'Admin Tools\\config.ini') end
                if imgui.Checkbox(u8 'Проверка статистики при warn / ban', fracstatb) then cfg.other.fracstat = fracstatb.v inicfg.save(config, 'Admin Tools\\config.ini') end
                imgui.TextWrapped(u8 ('Игнор проверки статистики будет происходить, если причина бана равна: %s'):format(table.concat(punishignor, ', ')))
                imgui.TextWrapped(u8 'Настроить список игнора можно по пути moonloader/config/Admin Tools/punishingor.txt')
                if imgui.Button(u8 'Обновисть список игнона') then punishignor = {} for line in io.lines('moonloader/config/Admin Tools/punishignor.txt') do table.insert(punishignor, line) end end
			elseif data.imgui.menu == 5 then
				local creconB = imgui.ImBool(cfg.crecon.enable)
				local ipassb = imgui.ImBool(cfg.other.passb)
				local iapassb = imgui.ImBool(cfg.other.apassb)
                local reconwb = imgui.ImBool(cfg.other.reconw)
                local conschat = imgui.ImBool(cfg.other.chatconsole)
                local extraignorb = imgui.ImBool(cfg.other.extraignor)
                local joinquitb = imgui.ImBool(cfg.joinquit.enable)
				local ipass = imgui.ImBuffer(tostring(cfg.other.password), 256)
                local iapass = imgui.ImBuffer(tostring(cfg.other.adminpass), 256)
                local hudfontb = imgui.ImBuffer(tostring(cfg.other.hudfont), 256)
                local hudsizeb = imgui.ImInt(cfg.other.hudsize)
				imgui.CentrText(u8 'Остальное')
				imgui.Separator()
				if imgui.ToggleButton(u8 'reconw##1', reconwb) then cfg.other.reconw = reconwb.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Варнинги на клео реконнект')
				imgui.Text(u8 'Местоположение рекона')
                imgui.SameLine()
                if imgui.Button(u8 'Изменить##3') then data.imgui.reconpos = true; mainwindow.v = false end
                if imgui.ToggleButton(u8 'Включить замененный рекон##1', creconB) then cfg.crecon.enable = creconB.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Включить замененный рекон')
				if imgui.ToggleButton(u8 'Автологин##11', ipassb) then cfg.other.passb = ipassb.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Автологин')
                if imgui.ToggleButton(u8 'Автоалогин##11', iapassb) then cfg.other.apassb = iapassb.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Автоалогин')
                if imgui.ToggleButton(u8 'Чатлог в консоли##11', conschat) then cfg.other.chatconsole = conschat.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Чатлог в консоли')
                if imgui.ToggleButton(u8 'Игнор варнингов печени на ExtraWS##11', extraignorb) then cfg.other.extraignor = extraignorb.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Игнор варнингов печени на ExtraWS') imgui.SameLine() imgui.TextQuestion(u8 'При переходе в рекон по варнингу будет игнорироваться варнинг на Екстру')
                if imgui.ToggleButton(u8 'joinquit##11', joinquitb) then cfg.joinquit.enable = joinquitb.v; inicfg.save(config, 'Admin Tools\\config.ini') end; imgui.SameLine(); imgui.Text(u8 'Лог подключившися/отключивашися игроков')
                if joinquitb.v then 
                    if imgui.Button(u8'Изменить местоположения подключившихся##1') then data.imgui.joinpos = true; mainwindow.v = false end
                    imgui.SameLine()
                    if imgui.Button(u8'Изменить местоположения отключившихся##1') then data.imgui.quitpos = true; mainwindow.v = false end
                end
				if ipassb.v then
					if imgui.InputText(u8 'Введите ваш пароль', ipass, imgui.InputTextFlags.Password) then cfg.other.password = u8:decode(ipass.v) inicfg.save(config, 'Admin Tools\\config.ini') end
					if imgui.Button(u8 'Узнать пароль##1') then atext('Ваш пароль: {66FF00}'..cfg.other.password) end
				end
				if iapassb.v then
					if imgui.InputText(u8 'Введите ваш админский пароль', iapass, imgui.InputTextFlags.Password) then cfg.other.adminpass = u8:decode(iapass.v) inicfg.save(config, 'Admin Tools\\config.ini') end
					if imgui.Button(u8 'Узнать пароль##2') then atext('Ваш админский пароль: {66FF00}'..cfg.other.adminpass) end
                end
                if imgui.InputText(u8 'Шрифт нижней панели##hud', hudfontb) then cfg.other.hudfont = hudfontb.v hudfont = renderCreateFont(cfg.other.hudfont, cfg.other.hudsize, 4) inicfg.save(config, 'Admin Tools\\config.ini') end
                if imgui.InputInt(u8 'Размер шрифта нижней панели##hud', hudsizeb, 0) then cfg.other.hudsize = hudsizeb.v hudfont = renderCreateFont(cfg.other.hudfont, cfg.other.hudsize, 4) inicfg.save(config, 'Admin Tools\\config.ini') end
            elseif data.imgui.menu == 6 then
                imgui.CentrText(u8 'Настройка цветов')
                imgui.Separator()
                if imgui.ColorEdit3(u8 'Админ чат', acolor) then
                    config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b = acolor.v[1] * 255, acolor.v[2] * 255, acolor.v[3] * 255
                    config_colors.admchat.color = string.format("%06X", ARGBtoRGB(join_argb(255, acolor.v[1] * 255, acolor.v[2] * 255, acolor.v[3] * 255)))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.ColorEdit3(u8 'Саппорт чат', scolor) then
                    config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b = scolor.v[1] * 255, scolor.v[2] * 255, scolor.v[3] * 255
                    config_colors.supchat.color = string.format("%06X", ARGBtoRGB(join_argb(255, scolor.v[1] * 255, scolor.v[2] * 255, scolor.v[3] * 255)))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.ColorEdit3(u8 'SMS', smscolor) then
                    config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b = smscolor.v[1] * 255, smscolor.v[2] * 255, smscolor.v[3] * 255
                    config_colors.smschat.color = string.format("%06X", ARGBtoRGB(join_argb(255, smscolor.v[1] * 255, smscolor.v[2] * 255, smscolor.v[3] * 255)))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.ColorEdit3(u8 'Жалоба', jbcolor) then
                    config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b = jbcolor.v[1] * 255, jbcolor.v[2] * 255, jbcolor.v[3] * 255
                    config_colors.jbchat.color = string.format("%06X", ARGBtoRGB(join_argb(255, jbcolor.v[1] * 255, jbcolor.v[2] * 255, jbcolor.v[3] * 255)))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.ColorEdit3(u8 'Репорт', repcolor) then
                    config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b = repcolor.v[1] * 255, repcolor.v[2] * 255, repcolor.v[3] * 255
                    config_colors.repchat.color = string.format("%06X", ARGBtoRGB(join_argb(255, repcolor.v[1] * 255, repcolor.v[2] * 255, repcolor.v[3] * 255)))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.ColorEdit3(u8 'Вопрос', askcolor) then
                    config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b = askcolor.v[1] * 255, askcolor.v[2] * 255, askcolor.v[3] * 255
                    config_colors.askchat.color = string.format("%06X", ARGBtoRGB(join_argb(255, askcolor.v[1] * 255, askcolor.v[2] * 255, askcolor.v[3] * 255)))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.ColorEdit3(u8 'Ответ', anscolor) then
                    config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b = anscolor.v[1] * 255, anscolor.v[2] * 255, anscolor.v[3] * 255
                    config_colors.anschat.color = string.format("%06X", ARGBtoRGB(join_argb(255, anscolor.v[1] * 255, anscolor.v[2] * 255, anscolor.v[3] * 255)))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.Button(u8 'Сбросить цвета') then
                    config_colors = {
                        admchat = {r = 255, g = 255, b = 0, color = "FFFF00"},
                        supchat = {r = 0, g = 255, b = 153, color = '00FF99'},
                        smschat = {r = 255, g = 255, b = 0, color = "FFFF00"},
                        repchat = {r = 217, g = 119, b = 0, color = "D97700"},
                        anschat = {r = 140, g = 255, b = 155, color = "8CFF9B"},
                        askchat = {r = 233, g = 165, b = 40, color = "E9A528"},
                        jbchat = {r = 217, g = 119, b = 0, color = "D97700"}
                    }
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
            end
            --imgui.ShowStyleEditor()
            imgui.EndChild()
            imgui.End()
        end
		if bMainWindow.v then
			imgui.LockPlayer = true
			imgui.ShowCursor = true
			imgui.DisableInput = false
			local iScreenWidth, iScreenHeight = getScreenResolution()
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(1000, 560), imgui.Cond.FirstUseEver)
			imgui.Begin(u8("Admin Tools | Биндер##main"), bMainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			imgui.Text(u8'Для корректной работы биндера рекомендуется перезагрузить скрипт после изменения настроек биндера.')
			imgui.Separator()
			imgui.BeginChild("##bindlist", imgui.ImVec2(995, 442))
			for k, v in ipairs(tBindList) do
				if imgui.HotKey("##HK" .. k, v, tLastKeys, 100) then
					if not rkeys.isHotKeyDefined(v.v) then
						if rkeys.isHotKeyDefined(tLastKeys.v) then
							rkeys.unRegisterHotKey(tLastKeys.v)
						end
						rkeys.registerHotKey(v.v, true, onHotKey)
					end
				end
				imgui.SameLine()
				if tEditData.id ~= k then
					local sText = v.text:gsub("%[enter%]$", "")
					imgui.BeginChild("##cliclzone" .. k, imgui.ImVec2(500, 30))
					imgui.AlignTextToFramePadding()
					if sText:len() > 0 then
						imgui.Text(u8(sText))
					else
						imgui.TextDisabled(u8("Пустое сообщение ..."))
					end
					imgui.EndChild()
					if imgui.IsItemClicked() then
						sInputEdit.v = sText:len() > 0 and u8(sText) or ""
						bIsEnterEdit.v = string.match(v.text, "(.)%[enter%]$") ~= nil
						tEditData.id = k
						tEditData.inputActve = true
					end
				else
					local btimeb = imgui.ImInt(v.time)
					imgui.PushAllowKeyboardFocus(false)
					imgui.PushItemWidth(500)
					local save = imgui.InputText("##Edit" .. k, sInputEdit, imgui.InputTextFlags.EnterReturnsTrue)
					imgui.PopItemWidth()
					imgui.PopAllowKeyboardFocus()
					imgui.SameLine()
					imgui.Checkbox(u8("Ввод") .. "##editCH" .. k, bIsEnterEdit)
					imgui.SameLine()
					imgui.PushItemWidth(50)
					if imgui.InputInt(u8'Задержка', btimeb, 0) then v.time = btimeb.v end
					imgui.PopItemWidth()
					if save then
						tBindList[tEditData.id].text = u8:decode(sInputEdit.v) .. (bIsEnterEdit.v and "[enter]" or "")
						tEditData.id = -1
						saveData(tBindList, "moonloader/config/Admin Tools/binder.json")
					end
					if tEditData.inputActve then
						tEditData.inputActve = false
						imgui.SetKeyboardFocusHere(-1)
					end
				end
			end
			imgui.EndChild()
			imgui.Separator()
			if imgui.Button(u8"Добавить клавишу") then
				tBindList[#tBindList + 1] = {text = "", v = {}, time = 0}
			end
			imgui.SameLine()
			if imgui.Button(u8'Сохранить биндер') then saveData(tBindList, "moonloader/config/Admin Tools/binder.json") end
			imgui.End()
		end
    end
	--imgui.PopStyleColor()
	--imgui.PopStyleColor()
end
function onHotKey(id, keys)
    lua_thread.create(function()
        local sKeys = tostring(table.concat(keys, " "))
        for k, v in pairs(tBindList) do
            if sKeys == tostring(table.concat(v.v, " ")) then
                if tostring(v.text):len() > 0 then
                    local bIsEnter = string.match(v.text, "(.)%[enter%]$") ~= nil
                    if bIsEnter then
                        sampSendChat(v.text:gsub("%[enter%]$", ""))
                    else
                        sampSetChatInputText(v.text)
                        sampSetChatInputEnabled(true)
                    end
                    wait(v.time)
                end
            end
        end
    end)
end
function getFrak(frak)
    if frak == nil then return nil
    else
        if frak:match('.+ Gang') then
            frak = frak:match('(.+) Gang')
        end
        if frak == 'Russian Mafia' then frak = 'RM' end
        return frak
    end
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
function fps_correction()
	return representIntAsFloat(readMemory(0xB7CB5C, 4, false))
end
function initializeRender()
    font = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)
    font2 = renderCreateFont("Arial", 8, FCR_ITALICS + FCR_BORDER)
    deathfont = renderCreateFont('Arial', 10, 5)
    nizfont = renderCreateFont('Arial', 10, 0)
    gunfont = renderCreateFont(getGameDirectory()..'\\gtaweap3.ttf', 10, 0)
    whfont = renderCreateFont(cfg.other.whfont, cfg.other.whsize, 4)
    whhpfont = renderCreateFont("Verdana", 8, 4)
	checkfont = renderCreateFont(cfg.other.checkfont, cfg.other.checksize, 4)
	hudfont = renderCreateFont(cfg.other.hudfont, cfg.other.hudsize, 4)
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
                                        renderFontDrawText(font2, "Зажмите правую кнопку мыши для телепорта в авто", sx, sy - hoffs * 3, color)
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
function onScriptTerminate(scr)
    if scr == script.this then
        nameTagOn()
        showCursor(false)
        removePointMarker()
    end
end
frakcolor = {
    ['Зоны 51:'] = '{33AA33}Зоны 51{ffffff}:',
    ['армии Авианосца:'] = '{33AA33}армии Авианосца{ffffff}:',
    ['FBI'] = '{313131}FBI{ffffff}',
    ['LSPD'] = '{110CE7}LSPD{ffffff}',
    ['SFPD'] = '{110CE7}SFPD{ffffff}',
    ['LVPD'] = '{110CE7}LVPD{ffffff}',
    ['мафии Якудза'] = '{ff0000}мафии Якудза{ffffff}',
    ['мафии LCN'] = '{DDA701}мафии LCN{ffffff}',
    ['Русской Мафии'] = '{B4B5B7}Русской Мафии{ffffff}',
    ['Ballas'] = '{B313E7}Ballas{ffffff}',
    ['Vagos'] = '{DBD604}Vagos{ffffff}',
    ['Groove'] = '{009F00}Grove{ffffff}',
    ['Aztecas'] = '{01FCFF}Aztecas{ffffff}',
    ['Rifa'] = '{2A9170}Rifa{ffffff}'
}
function sampev.onConnectionRejected(reason)
    temp_checker_online = {}
    admins_online = {}
    players_online = {}
end
function sampev.onServerMessage(color, text)
    punishlog(text)
    if cfg.other.chatconsole then sampfuncsLog(text) end
	if doesFileExist('moonloader/Admin Tools/chatlog_all.txt') then
		local file = io.open('moonloader/Admin Tools/chatlog_all.txt', 'a')
		file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
		file:close()
		file = nil
    end
    if text:match('^ Ответ от .+%[%d+%] к .+%[%d+%]:') then
        local color = '0x'..config_colors.anschat.color..'FF'
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    text = text:gsub(sampGetPlayerNickname(i), sampGetPlayerNickname(i)..' ['..i..']')
                end
            end
        end
        return {color, text} 
    end
    if text:match('^ <ADM%-CHAT> .+: .+') then
        local color = '0x'..config_colors.admchat.color..'FF'
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    text = text:gsub(sampGetPlayerNickname(i), sampGetPlayerNickname(i)..' ['..i..']')
                end
            end
        end
        return {color, text} 
    end
    if text:match('^ <SUPPORT%-CHAT> .+: .+') then
        local color = '0x'..config_colors.supchat.color..'FF'
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    text = text:gsub(sampGetPlayerNickname(i), sampGetPlayerNickname(i)..' ['..i..']')
                end
            end
        end
        return {color, text} 
    end
    if masstpon and text:match('^ SMS: .+ Отправитель: .+%[%d+%]$') then
        local smsid = text:match('^ SMS: .+ Отправитель: .+%[(%d+)%]$')
        if not checkIntable(smsids, smsid) then
            table.insert(smsids, smsid)
        end
        return false
    end
    if text:match('^ SMS:') then
        local color = '0x'..config_colors.smschat.color..'FF'
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    text = text:gsub(sampGetPlayerNickname(i), sampGetPlayerNickname(i)..' ['..i..']')
                end
            end
        end
        return {color, text} 
    end
    if text:match('^ %->Вопрос .+') then
        local color = '0x'..config_colors.askchat.color..'FF'
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    text = text:gsub(sampGetPlayerNickname(i), sampGetPlayerNickname(i)..' ['..i..']')
                end
            end
        end
        return {color, text} 
    end
    if text:match('^ На складе .+ %d+/%d+ материалов') and color == -1 then
        local mfrak, mati, ogran = text:match('^ На складе (.+) (%d+)/(%d+) материалов')
        return {color, (' На складе %s %s/%s материалов'):format(frakcolor[mfrak], mati, ogran)}
    end
    if checkfraks then
        if text:match('^ ID: %d+ |.+') then
            local cid, cnick, crang = text:match('^ ID%: (%d+) | %d+%:%d+ %d+%.%d+%.%d+ | (.+)%: .+%[(%d+)%]')
            local lvl = sampGetPlayerScore(cid)
            if lvl ~= 0 then
                local crang = tonumber(crang)
                if check_frak == 1 or check_frak == 10 or check_frak == 21 then
                    if lvl < frakrang.PD.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 11 then
                        if lvl < frakrang.PD.rang_11 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 12 then
                        if lvl < frakrang.PD.rang_12 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 13 then
                        if lvl < frakrang.PD.rang_13 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 2 then
                    if lvl < frakrang.FBI.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 6 then
                        if lvl < frakrang.FBI.rang_6 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 7 then
                        if lvl < frakrang.FBI.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.FBI.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.FBI.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 3 or check_frak == 19 then
                    if lvl < frakrang.Army.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 12 then
                        if lvl < frakrang.Army.rang_12 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 13 then
                        if lvl < frakrang.Army.rang_13 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 14 then
                        if lvl < frakrang.Army.rang_14 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 5 or check_frak == 6 or check_frak == 14 then
                    if lvl < frakrang.Mafia.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.Mafia.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Mafia.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.Mafia.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 11 then
                    if lvl < frakrang.Autoschool.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.Autoschool.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Autoschool.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.Autoschool.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 12 or check_frak == 13 or check_frak == 15 or check_frak == 17 or check_frak == 18 then
                    if lvl < frakrang.Gangs.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.Gangs.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Gangs.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.Gangs.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 22 then
                    if lvl < frakrang.MOH.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.MOH.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.MOH.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.MOH.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 24 or check_frak == 26 or check_frak == 29 then
                    if lvl < frakrang.Bikers.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 5 then
                        if lvl < frakrang.Bikers.rang_5 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 6 then
                        if lvl < frakrang.Bikers.rang_6 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 7 then
                        if lvl < frakrang.Bikers.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Bikers.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif check_frak == 9 or check_frak == 16 or check_frak == 20 then
                    if lvl < frakrang.News.inv and lvl ~= 0 then
                        table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.News.rang_7 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.News.rang_8 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.News.rang_9 then
                            table.insert(checkf, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
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
    if text:match("^ Жалоба от .+%[%d+%] на .+%[%d+%]%: .+") then
        reportid = text:match("Жалоба от .+%[%d+%] на .+%[(%d+)%]%: .+")
        local color = '0x'..config_colors.jbchat.color..'FF'
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    text = text:gsub(sampGetPlayerNickname(i), sampGetPlayerNickname(i)..' ['..i..']')
                end
            end
        end
        return {color, text}
    end
    if text:match("Nik %[.+%]  R%-IP %[.+%]  L%-IP %[.+%]  IP %[(.+)%]") and color == -10270806 then
        local nick, rip, ip = text:match("Nik %[(.+)%]  R%-IP %[(.+)%]  L%-IP %[.+%]  IP %[(.+)%]")
		ips = {{query = rip}, {query = ip}}
		rnick = nick
		bip = ip
    end
	if text:match('^ Nik %[.+%]   R%-IP %[.+%]   L%-IP %[.+%]   IP %[.+%]$') then
		local nick, rip, ip = text:match('^ Nik %[(.+)%]   R%-IP %[(.+)%]   L%-IP %[.+%]   IP %[(.+)%]$')
		ips = {{query = rip}, {query = ip}}
		rnick = nick
	end
    if text:match('<Warning> .+%[%d+%]%: .+') and color == -16763905 then
        local cnick, ccwid = text:match('<Warning> (.+)%[(%d+)%]%: .+')
		wid = ccwid
        if cfg.tempChecker.wadd then
            if not checkIntable(temp_checker, cnick) then
                table.insert(temp_checker_online, {nick = cnick, id = tonumber(ccwid), color = 'ffffff', text = ''})
                table.insert(temp_checker, {{nick = cnick, color = 'ffffff', text = ''}})
            end
		end
    end
    if text:match('^ Репорт от .+%[%d+%]%:') then
        reportid = text:match('Репорт от .+%[(%d+)%]%:')
        local color = '0x'..config_colors.repchat.color..'FF'
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    text = text:gsub(sampGetPlayerNickname(i), sampGetPlayerNickname(i)..' ['..i..']')
                end
            end
        end
        return {color, text}
    end
    if text:match('^ Жалоба от%: .+%[%d+%]%:') then
        reportid = text:match('Жалоба от%: .+%[(%d+)%]%:')
        local color = '0x'..config_colors.jbchat.color..'FF'
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        for i = 0, 1000 do
            if sampIsPlayerConnected(i) or i == myid then
                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
                local a = text:gsub('{.+}', '')
                if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
                    text = text:gsub(sampGetPlayerNickname(i), sampGetPlayerNickname(i)..' ['..i..']')
                end
            end
        end
        return {color, text}
    end
	local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    for i = 0, 1000 do
       if sampIsPlayerConnected(i) or i == myid then
         local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')
         local a = text:gsub('{.+}', '')
           if a:find(nick) and not a:find(nick..'%['..i..'%]') and not a:find('%['..i..'%] '..nick) and not a:find(nick..' %['..i..'%]') then
              text = text:gsub(sampGetPlayerNickname(i), sampGetPlayerNickname(i)..' ['..i..']')
          end
        end
      end
    return { color, text }
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
    if id == 2163 then reconstate = true end
    if cfg.crecon.enable then
        if id == 2163 then recon.v = true return false end
        if id == 2164 then return false end
        if id == 2162 then return false end
        if id == 2158 then return false end
        if id == 2159 then return false end
        --for i = 2160, 2191 do if id == i then return false end end
    end
end
function sampev.onTextDrawHide(id)
    if id == 2164 then reconstate = false end
    if cfg.crecon.enable then if id == 2164 then recon.v = false; reid = nil end end
end
function sampev.onPlayerQuit(id, reason)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    text_notify_disconnect('{ff0000}Отключился: {ffffff}'..sampGetPlayerNickname(id)..' ['..id..']')
	if reason == 2 or reason == 3 then table.insert(wrecon, {nick = sampGetPlayerNickname(id), time = os.time()}) end
	for i, v in ipairs(admins_online) do
		if tonumber(v["id"]) == id then
			table.remove(admins_online, i)
			break
		end
    end
    for i, v in ipairs(players_online) do
		if tonumber(v["id"]) == id then
			table.remove(players_online, i)
			break
		end
    end
	for i, v in ipairs(temp_checker_online) do
		if tonumber(v["id"]) == id then
			table.remove(temp_checker_online, i)
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
    table.insert(tkills, ('{'..("%06X"):format(bit.band(sampGetPlayerColor(killerId), 0xFFFFFF))..'}%s[%s]\t{'..("%06X"):format(bit.band(sampGetPlayerColor(killedId), 0xFFFFFF))..'}%s[%s]\t{ffffff}%s'):format(sampGetPlayerNickname(killerId),killerId, sampGetPlayerNickname(killedId),killedId, sampGetDeathReason(reason)))
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
    text_notify_connect('{00ff00}Подключился: {ffffff}'..nick..' ['..id..']')
	for i, v in ipairs(wrecon) do
		if v["nick"] == nick then
			if (os.time() - v["time"]) < 5 and (os.time() - v["time"]) > 0 then
				if cfg.other.reconw then
					atext(('Игрок {66FF00}%s [%s] {ffffff}возможно клео реконнект. Время перехода: %s секунд'):format(nick, id, os.time() - v["time"]))
				end
			end
			table.remove(wrecon, i)
		end
	end
	for i, v in ipairs(admins) do
		if nick == v['nick'] then
			table.insert(admins_online, {nick = nick, id = id, color = v['color'], text = v['text']})
			break
		end
    end
    for i, v in ipairs(players) do
		if nick == v['nick'] then
			table.insert(players_online, {nick = nick, id = id, color = v['color'], text = v['text']})
			break
		end
	end
	for i, v in ipairs(temp_checker) do
		if nick == v['nick'] then
			table.insert(temp_checker_online, {nick = nick, id = id, color = v['color'], text = v['text']})
			break
		end
	end
end
function renders()
    while true do wait(0)
        if swork then
            local admrenderPosY = cfg.admchecker.posy
            local playerRenderPosY = cfg.playerChecker.posy
            local tempRenderPosY = cfg.tempChecker.posy
            local memory = require 'memory'
            local posx, posy, posz = getCharCoordinates(PLAYER_PED)
            local posint = getActiveInterior()
            local hpos = ("%0.2f %0.2f %0.2f"):format(posx, posy, posz)
            local fps = memory.getfloat(0xB7CB50, 4, false)
            local sx, sy = getScreenResolution()
            if cfg.joinquit.enable then
                if notification_connect then
                    if localClock() - notification_connect.tick <= notification_connect.duration then
                        local alpha = 255 * math.min(1, notification_connect.duration - (localClock() - notification_connect.tick)) -- затухание на последней секунде
                        local color = bit.bor(notification_connect.color, bit.lshift(alpha, 24))
                        for k = #notification_connect.lines, 1, -1 do
                            local text = notification_connect.lines[k]
                            if #text > 0 then
                                renderFontDrawText(hudfont, text, cfg.joinquit.joinposx, cfg.joinquit.joinposy, color)
                            end
                        end
                    else
                        notification_connect = nil
                    end
                end
                if notification_disconnect then
                    if localClock() - notification_disconnect.tick <= notification_disconnect.duration then
                        local alpha = 255 * math.min(1, notification_disconnect.duration - (localClock() - notification_disconnect.tick)) -- затухание на последней секунде
                        local color = bit.bor(notification_disconnect.color, bit.lshift(alpha, 24))
                        for k = #notification_disconnect.lines, 1, -1 do
                            local text = notification_disconnect.lines[k]
                            if #text > 0 then
                                renderFontDrawText(hudfont, text, cfg.joinquit.quitposx, cfg.joinquit.quitposy, color)
                            end
                        end
                    else
                        notification_disconnect = nil
                    end
                end
            end
            renderFontDrawText(hudfont, ('%s %s %s [%s %s]'):format(os.date("[%H:%M:%S]"), funcsStatus.Inv and '{00FF00}[Inv]{ffffff}' or '[Inv]', funcsStatus.AirBrk and '{00FF00}[AirBrk]{ffffff}' or '[AirBrk]', hpos, posint), 5, sy-20, -1)
            if cfg.admchecker.enable then
                renderFontDrawText(checkfont, "{00ff00}Админы онлайн ["..#admins_online.."]:", cfg.admchecker.posx, admrenderPosY-#admins_online*15, -1)
                for k, v in ipairs(admins_online) do
                    renderFontDrawText(checkfont,string.format('{%s}%s [%s] %s{5aa0aa} %s',v['color'], v["nick"], sampGetPlayerIdByNickname(v["nick"]), doesCharExist(select(2, sampGetCharHandleBySampPlayerId(v["id"]))) and '{5aa0aa}(Р)' or '', v['text']) , cfg.admchecker.posx, (admrenderPosY - k*15)+15, -1)
                end
            end
            if cfg.playerChecker.enable then
                renderFontDrawText(checkfont, "{FFFF00}Игроки онлайн ["..#players_online.."]:", cfg.playerChecker.posx, playerRenderPosY-#players_online*15, -1)
                for k, v in ipairs(players_online) do
                    renderFontDrawText(checkfont,string.format('{%s}%s [%s] %s{5aa0aa} %s',v['color'], v["nick"], sampGetPlayerIdByNickname(v["nick"]), doesCharExist(select(2, sampGetCharHandleBySampPlayerId(v["id"]))) and '{5aa0aa}(Р)' or '', v['text']) , cfg.playerChecker.posx, (playerRenderPosY - k*15)+15, -1)
                end
            end
            if cfg.tempChecker.enable then
                renderFontDrawText(checkfont, "{ff0000}Temp Checker ["..#temp_checker_online.."]:", cfg.tempChecker.posx, tempRenderPosY-#temp_checker_online*15, -1)
                for k, v in ipairs(temp_checker_online) do
                    renderFontDrawText(checkfont,string.format('{%s}%s [%s] %s{5aa0aa} %s',v['color'], v["nick"], sampGetPlayerIdByNickname(v["nick"]), doesCharExist(select(2, sampGetCharHandleBySampPlayerId(v["id"]))) and '{5aa0aa}(Р)' or '', v['text']) , cfg.tempChecker.posx, (tempRenderPosY - k*15)+15, -1)
                end
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
--[[function addadm(pam)
    local pId = tonumber(pam)
    if pId ~= nil then
        if sampIsPlayerConnected(pId) then
            local nick = sampGetPlayerNickname(pId)
            table.insert(admins_online, {nick = nick, id = pId})
            table.insert(admins, nick)
            atext('Игрок '..nick..' ['..pId..'] добавлен в чекер админов')
            local open = io.open("moonloader/config/Admin Tools/adminlist.txt", 'a')
            open:write('\n'..nick)
            open:close()
        else
            table.insert(admins, pId)
            atext('Игрок '..pId..' добавлен в чекер админов')
            local open = io.open("moonloader/config/Admin Tools/adminlist.txt", 'a')
            open:write('\n'..pId)
            open:close()
        end
    elseif pId == nil and #pam ~= 0 then
        if sampGetPlayerIdByNickname(tostring(pam)) ~= nil then
            local bpId = sampGetPlayerIdByNickname(tostring(pam))
            table.insert(admins_online, {nick = pam, id = bpId})
            atext('Игрок '..pam..' ['..bpId..'] добавлен в чекер админов')
        else
            atext('Игрок '..pam..' добавлен в чекер админов')
        end
        table.insert(admins, pam)
        local open = io.open("moonloader/config/Admin Tools/adminlist.txt", 'a')
        open:write('\n'..pam)
        open:close()
    elseif #pam == 0 then
        atext('Введите /addadm [id/nick]')
    end
end
--function addplayer(pam)
    local pId = tonumber(pam)
    if pId ~= nil then
        if sampIsPlayerConnected(pId) then
            local nick = sampGetPlayerNickname(pId)
            table.insert(players_online, {nick = nick, id = pId})
            table.insert(players, nick)
            atext('Игрок '..nick..' ['..pId..'] добавлен в чекер игроков')
            local open = io.open("moonloader/config/Admin Tools/playerlist.txt", 'a')
            open:write('\n'..nick)
            open:close()
        else
            table.insert(players, pId)
            atext('Игрок '..pId..' добавлен в чекер игроков')
            local open = io.open("moonloader/config/Admin Tools/playerlist.txt", 'a')
            open:write('\n'..pId)
            open:close()
        end
    elseif pId == nil and #pam ~= 0 then
        if sampGetPlayerIdByNickname(tostring(pam)) ~= nil then
            local bpId = sampGetPlayerIdByNickname(tostring(pam))
            table.insert(players_online, {nick = pam, id = bpId})
            atext('Игрок '..pam..' ['..bpId..'] добавлен в чекер игроков')
        else
            atext('Игрок '..pam..' добавлен в чекер игроков')
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
                atext('Игрок '..pId..' удален из чекера админов')
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
                atext('Игрок '..pam..' ['..bpId..'] удален из чекера админов')
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
end]]
function check_keystrokes() -- inv
    while true do wait(0)
        if swork then
            if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
                if isKeyJustPressed(key.VK_F3) then
                    setCharHealth(PLAYER_PED, 0)
                end
                if isKeyJustPressed(key.VK_INSERT) then
                    funcsStatus.Inv = not funcsStatus.Inv
                end
                if isKeyJustPressed(config_keys.airbrkkey.v) then -- airbrake
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
end
function main_funcs()
    while true do wait(0)
        if swork then
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
                    if not reconstate then
                        if isKeyDown(key.VK_UP) then airBrkCoords[3] = airBrkCoords[3] + airspeed / 2.0 end
                        if isKeyDown(key.VK_DOWN) and airBrkCoords[3] > -95.0 then airBrkCoords[3] = airBrkCoords[3] - airspeed / 2.0 end
                        if isKeyDown(key.VK_LSHIFT) and not isKeyDown(key.VK_RSHIFT) and airspeed > 0.06 then airspeed = airspeed - 0.050; printStringNow('Speed: '..airspeed, 1000) end
                        if isKeyDown(key.VK_SPACE) then airspeed = airspeed + 0.050; printStringNow('Speed: '..airspeed, 1000) end
                    end
                end
            end
        end
    end
end
function check_keys_fast()
    while true do wait(0)
        if swork then
            local isInVeh = isCharInAnyCar(playerPed)
            local veh = nil
            if isInVeh then veh = storeCarCharIsInNoSave(playerPed) end
            if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
                if isKeyJustPressed(key.VK_F3) then
                    setCharHealth(PLAYER_PED, 0)
                end
                if isKeyJustPressed(key.VK_INSERT) then
                    funcsStatus.Inv = not funcsStatus.Inv
                end
                if isKeyJustPressed(config_keys.airbrkkey.v) then -- airbrake
                    airspeed = cfg.cheat.airbrkspeed
                    funcsStatus.AirBrk = not funcsStatus.AirBrk
                    if funcsStatus.AirBrk then
                        local posX, posY, posZ = getCharCoordinates(playerPed)
                        airBrkCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(playerPed)}
                    end
                end
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
end
function onReceiveRpc(id, bs) --перехватываем все входящие рпс
    if id == 91 and swork then --делаем проверку на нужный нам, в данном случае это RPC_SetVehicleVelocity
        return false -- блокируем рпс
    end
end
function tr(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local idd = tonumber(pam)
    if idd ~= nil and sampIsPlayerConnected(idd) or idd == myid then
        traceid = idd
        atext("Трейсера сменены на: {66FF00}"..traceid)
    else
        atext('Используйте: /tr [id]')
        traceid = '-1'
    end
end
function wh()
    while not sampIsLocalPlayerSpawned() do wait(0) end
    nameTagOff()
    while true do wait(0)
        if swork then
            if not nameTag then
                if not isPauseMenuActive() then
                    nametagCoords = {}
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
                                    local posy = headposy - 40
                                    local posx = headposx - 60
                                    local sdsd = posy
                                    for _, v in ipairs(nametagCoords) do
                                        if v["pos_y"] > posy-22.5 and v["pos_y"] < posy+22.5 and v["pos_x"] > posx-50 and v["pos_x"] < posx+50 then
                                            posy = v["pos_y"] - 22.5
                                        end
                                    end
                                    nametagCoords[#nametagCoords+1] = {
                                        pos_y = posy,
                                        pos_x = posx
                                    }
                                    renderFontDrawText(whfont, string.format('{%s}%s [%s] %s', color, nick, i, isAfk and '{cccccc}[AFK]' or ''), posx, posy, -1)
                                    local hp2 = cpedHealth
                                    if cpedHealth > 100 then cpedHealth = 100 end
                                    if cpedArmor > 100 then cpedArmor = 100 end
                                    renderDrawBoxWithBorder(posx+1, posy+15, math.floor(100 / 2) + 1, 5, 0x80000000, 1, 0xFF000000)
                                    renderDrawBox(posx, posy+15, math.floor(cpedHealth / 2) + 1, 5, 0xAACC0000)
                                    --renderFontDrawText(font2, 'HP: ' .. tostring(hp2), 1, resY - 11, 0xFFFFFFFF)
                                    renderFontDrawText(whhpfont, cpedHealth, posx+60, posy+12.5, 0xFFFF0000)
                                    renderFontDrawText(whfont, 'LVL: '..cpedlvl, posx+85, posy+14.5, -1)
                                    if cpedArmor ~= 0 then
                                        renderDrawBoxWithBorder(posx, posy+25, math.floor(100 / 2) + 1, 5, 0x80000000, 1, 0xFF000000)
                                        renderDrawBox(posx, posy+25, math.floor(cpedArmor / 2) + 1, 5, 0xAAAAAAAA)
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
end
function nameTagOn()
    local pStSet = sampGetServerSettingsPtr();
    NTdist = mem.getfloat(pStSet + 39)
    NTwalls = mem.getint8(pStSet + 47)
    NTshow = mem.getint8(pStSet + 56)
    mem.setfloat(pStSet + 39, 36.0)
    mem.setint8(pStSet + 47, 1)
    mem.setint8(pStSet + 56, 1)
    nameTag = true
end
function sampGetDeathReason(id)
	local names = {
		[0] = 'Кулак',
		[1] = 'Кастет',
		[2] = 'Клюшка для гольфа',
		[3] = 'Полицейская дубинка',
		[4] = 'Нож',
		[5] = 'Бита',
		[6] = 'Лопата',
		[7] = 'Кий',
		[8] = 'Катана',
		[9] = 'Бензопила',
		[10] = 'Фиолетовый дилдо',
		[11] = 'Короткий вибратор',
		[12] = 'Длинный вибратор',
		[13] = 'Белый дилдо',
		[14] = 'Цветы',
		[15] = 'Трость',
		[16] = 'Граната',
		[17] = 'Cлезоточивый газ',
		[18] = 'Слезоточивый газ',
		[22] = 'Пистолет',
		[23] = 'Пистолет с глушителем',
		[24] = 'Дигл',
		[25] = 'Шотган',
		[26] = 'Обрез',
		[27] = 'Боевой дробовик',
		[28] = 'Узи',
		[29] = 'МП5',
		[30] = 'АК47',
		[31] = 'М4',
		[32] = 'Tec 9',
		[33] = 'Винтовка',
		[34] = 'Снайперская винтовка',
		[35] = 'РПГ',
		[36] = 'РПГ с самонаводкой',
		[37] = 'Огнемет',
		[38] = 'Миниган',
		[39] = 'Сумка для зарядки',
		[40] = 'Детонатор',
		[41] = 'Балончик с краской',
		[42] = 'Огнетушитель',
		[43] = 'Фотоопарат',
		[44] = 'Очки ночного виденья',
		[45] = 'Тепловизор',
		[46] = 'Парашют',
		[47] = 'Фейк пистолет',
		[49] = 'Транспорт',
		[50] = 'Винты вертолета',
		[51] = 'Взрыв',
		[53] = 'Утонул',
		[54] = 'От падения',
		[255] = 'Суицид'
	}
	return names[id]
end
function nameTagOff()
	local pStSet = sampGetServerSettingsPtr();
	mem.setfloat(pStSet + 39, NTdist)
	mem.setint8(pStSet + 47, NTwalls)
	mem.setint8(pStSet + 56, NTshow)
	nameTag = false
end
function whoff()
	local pStSet = sampGetServerSettingsPtr()
	mem.setfloat(pStSet + 39, NTdist)
	mem.setint8(pStSet + 47, NTwalls)
	mem.setint8(pStSet + 56, NTshow)
end
function getBodyPartCoordinates(id, handle)
    local pedptr = getCharPointer(handle)
    local vec = ffi.new("float[3]")
    getBonePosition(ffi.cast("void*", pedptr), vec, id, true)
    return vec[0], vec[1], vec[2]
end
function warningsKey()
    local wtext, wprefix, wcolor, wpcolor = sampGetChatString(99)
    if wcolor == 4294967295 and wtext:match('%[SWarning%]%:{.+}  Игрок  .+ %[%d+%] - .+') and not wtext:find('ExtraWS') then
        cwid = wtext:match('%[SWarning%]%:{.+}  Игрок  .+ %[(%d+)%] - .+')
    end
    if wtext:match('%[SWarning%]%:{.+}  Игрок  .+ %[%d+%] - .+') and wcolor == 4294967295 and wtext:find('ExtraWS') then
        if not cfg.other.extraignor then
            cwid = wtext:match('%[SWarning%]%:{.+}  Игрок  .+ %[(%d+)%] - .+')
        end
    end
    if wcolor == 4294911012 and wtext:match('<Warning> {.+}.+%[%d+%]% .+') and not wtext:match("<Warning> {.+}.+%[%d+%] возможно попал сквозь текстуру в {.+}.+%[%d+%] из .+ %(model: %d+%)") then
        cwid = wtext:match('<Warning> {.+}.+%[(%d+)%]% .+')
    end
    if wtext:match("<Warning> {.+}.+%[%d+%] возможно попал сквозь текстуру в {.+}.+%[%d+%] из .+ %(model: %d+%)") then
        cwid = wtext:match("<Warning> {.+}.+%[(%d+)%] возможно попал сквозь текстуру в {.+}.+%[%d+%] из .+ %(model: %d+%)")
    end
	if wtext:match('^<Warning> {.+}.+%[%d+%] {FFFFFF}.+') then
		cwid = wtext:match('^<Warning> {.+}.+%[(%d+)%] {FFFFFF}.+')
	end
	if wtext:match('^Warning:{.+} .+%[%d+%] .+') and not wtext:match('^Warning:{.+} .+%[%d+%] возможно попал сквозь текстуру в{.+} .+%[%d+%] из: .+ %(texture: %d+%)') then
		cwid = wtext:match('^Warning:{.+} .+%[(%d+)%] .+')
	end
	if wtext:match('^Warning:{.+} .+%[%d+%] возможно попал сквозь текстуру в{.+} .+%[%d+%] из: .+ %(texture: %d+%)') then
		cwid = wtext:match('^Warning:{.+} .+%[(%d+)%] возможно попал сквозь текстуру в{.+} .+%[%d+%] из: .+ %(texture: %d+%)')
    end
    if wcolor == 16722731 and wtext:match('^%[mkrn wrn%]:%{.+%} .+%[%d+%].+') and not wtext:match('^%[mkrn wrn%]:%{.+%} .+%[%d+%] возможно дамажит%/стреляет из сайлента в игрока%{.+%} .+%[%d+%] из .+') and not wtext:match('^%[mkrn wrn%]:%{.+%} .+%[%d+%] попал сквозь текстуру в%{.+%} .+%[%d+%] из: .+, texture: %d+ %[.+%]') then
        cwid = wtext:match('^%[mkrn wrn%]:%{.+%} .+%[(%d+)%].+')
    end
    if wcolor == 16722731 and wtext:match('^%[mkrn wrn%]:%{.+%} .+%[%d+%] возможно дамажит%/стреляет из сайлента в игрока%{.+%} .+%[%d+%] из .+') then
        cwid = wtext:match('^%[mkrn wrn%]:%{.+%} .+%[(%d+)%] возможно дамажит/стреляет из сайлента в игрока%{.+%} .+%[%d+%] из .+')
    end
    if wcolor == 16722731 and wtext:match('^%[mkrn wrn%]:%{.+%} .+%[%d+%] попал сквозь текстуру в%{.+%} .+%[%d+%] из: .+, texture: %d+ %[.+%]') then
        cwid = wtext:match('^%[mkrn wrn%]:%{.+%} .+%[(%d+)%] попал сквозь текстуру в%{.+%} .+%[%d+%] из: .+, texture: %d+ %[.+%]')
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
			if title == 'Статистика персонажа' then
	            wbfrak = text:match('.+Организация%:%s+(.+)%s+Ранг')
	            wbrang = text:match('.+Ранг%:%s+(.+)%s+Работа')
				wbstyle = 1
	            sampSendDialogResponse(id, 1, 1, nil)
	            checkstatdone = true
	            return false
			elseif title == '{FFFFFF}Статистика | {ae433d}Администрирование' then
				wbfrak = text:match('.+Организация\t(.+)\nДолжность')
				wbrang = text:match('.+Должность\t.+%[(.+)%]\nРабота')
				wbstyle = 2
				sampSendDialogResponse(id, 1, 1, nil)
				checkstatdone = true
				return false
			end
        end
    end
    if id == 1 and #tostring(cfg.other.password) >=6 then
        sampSendDialogResponse(id, 1, _, tostring(cfg.other.password))
        return false
    end
    if id == 1227 and #tostring(cfg.other.adminpass) >=6 and cfg.other.apassb then
        sampSendDialogResponse(id, 1, _, tostring(cfg.other.adminpass))
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
                    if cfg.other.fracstat then
                        warnst = true
                        local wnick = sampGetPlayerNickname(id)
                        sampSendChat('/getstats '..id)
                        local wtime = os.clock() + 10
                        while not checkstatdone or wtime < os.clock() do wait(0) end
                        wait(1200)
                        if sampIsPlayerConnected(id) then
                            if sampGetPlayerNickname(id) ~= nil then
                                if sampGetPlayerNickname(id) == wnick then
                                    if wbstyle == 1 then
                                        if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                                            sampSendChat(string.format('/warn %s %s %s [%s/%s]', id, days, reason, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                                        else
                                            sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                                        end
                                    elseif wbstyle == 2 then
                                        if getFrak(wbfrak) ~= nil and wbfrak ~= 'Нет' then
                                            sampSendChat(string.format('/warn %s %s %s [%s/%s]', id, days, reason, getFrak(wbfrak), wbrang))
                                        else
                                            sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                                        end
                                    end
                                else
                                    atext('Игрок '..wnick..' вышел из игры')
                                end
                            else
                                atext('Игрок '..wnick..' вышел из игры')
                            end
                        else
                            atext('Игрок '..wnick..' вышел из игры')
                        end
                    else
                        sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                    end
                    checkstatdone = false
                    warnst = false
                    wbfrak = nil
                    wbrang = nil
                    wnick = nil
                    wtime = nil
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
                    if cfg.other.fracstat then
                        if not checkIntable(punishignor, reason) then
                            local wnick = sampGetPlayerNickname(id)
                            warnst = true
                            sampSendChat('/getstats '..id)
                            local wtime = os.clock() + 10
                            while not checkstatdone or wtime < os.clock() do wait(0) end
                            wait(1200)
                            if sampIsPlayerConnected(id) then
                                if sampGetPlayerNickname(id)~= nil then
                                    if sampGetPlayerNickname(id) == wnick then
                                        if wbstyle == 1 then
                                            if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                                                sampSendChat(string.format('/ban %s %s [%s/%s]', id, reason, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                                            else
                                                sampSendChat(string.format('/ban %s %s', id, reason))
                                            end
                                        elseif wbstyle == 2 then
                                            if getFrak(wbfrak) ~= nil and wbfrak ~= 'Нет' then
                                                sampSendChat(string.format('/ban %s %s [%s/%s]', id, reason, getFrak(wbfrak), wbrang))
                                            else
                                                sampSendChat(string.format('/ban %s %s', id, reason))
                                            end
                                        end
                                    else
                                        atext('Игрок '..wnick..' вышел из игры')
                                    end
                                else
                                    atext('Игрок '..wnick..' вышел из игры')
                                end
                            else
                                atext('Игрок '..wnick..' вышел из игры')
                            end
                        else
                            sampSendChat(string.format('/ban %s %s', id, reason))
                        end
                        wnick = nil
                        checkstatdone = false
                        wbfrak = nil
                        wbrang = nil
                        warnst = false
                        wtime = nil
                    else
                        sampSendChat(string.format('/ban %s %s', id, reason))
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
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnected(id) or id == myid then
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
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnected(id) or id == myid then
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
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnected(id) or id == myid then
            sampSendChat('/prison '..id..' '..cfg.timers.sbivtimer..' Сбив анимации')
        else
            atext('Игрок оффлайн')
        end
    else
        atext("Введите /sbiv [id]")
    end
end
function csbiv(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnected(id) or id == myid then
            sampSendChat('/prison '..id..' '..cfg.timers.csbivtimer..' Сбив анимации')
        else
            atext('Игрок оффлайн')
        end
    else
        atext("Введите /csbiv [id]")
    end
end
function cbug(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnected(id) or id == myid then
            sampSendChat('/prison '..id..' '..cfg.timers.cbugtimer..' +с вне гетто')
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
    end
end
function warningk()
	if wid ~= nil then
		sampSendChat('/re '..wid)
	end
end
function cwarningk()
	if cwid ~= nil then
		sampSendChat('/re '..cwid)
	end
end
function banipk()
	if bip ~= nil then
		sampSendChat('/banip '..bip)
	end
end
function saveposk()
    savecoords.x, savecoords.y, savecoords.z = getCharCoordinates(PLAYER_PED)
    atext('Текущие координаты сохранены. Для телепортирования нажмите {66FF00}'..table.concat(rkeys.getKeysName(config_keys.goposkey.v)))
    cango = true
end
function goposk()
    if cango then
        setCharCoordinates(PLAYER_PED, savecoords.x, savecoords.y, savecoords.z)
    end
end
function fonl(pam)
    lua_thread.create(function()
        local num = tonumber(pam)
        if num ~= nil then
            if num > 0 and num <= 29 then
                fonlcheck = true
                sampSendChat('/amembers '..num)
                while not fonldone do wait(0) end
                atext('Во фракции №{66FF00}'..num..' {ffffff}онлайн {66FF00}'..fonlnum..' {ffffff}человека')
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
                    atext('Во фракции №{66FF00}'..check_frak..'{ffffff} все нормально с рангами.')
                else
                    sampAddChatMessage(' ', -1)
                    for k, v in pairs(checkf) do
                        sampAddChatMessage(' '..v, -1)
                    end
                    sampAddChatMessage(' ', -1)
                    atext('Фракция №{66FF00}'..check_frak)
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
function cheat(pam)
	lua_thread.create(function()
		local id = tonumber(pam)
		if id ~= nil then
			if sampIsPlayerConnected(id) then
				local lvl = sampGetPlayerScore(id)
				if lvl < 3 then
					sampSendChat(string.format('/ban %s cheat', id))
				else
					warnst = true
					local wnick = sampGetPlayerNickname(id)
					sampSendChat('/getstats '..id)
					local wtime = os.clock() + 10
                    while not checkstatdone or wtime < os.clock() do wait(0) end
                    wait(1200)
                    if sampIsPlayerConnected(id) then
                        if sampGetPlayerNickname(id) ~= nil then
                            if sampGetPlayerNickname(id) == wnick then
                                if wbstyle == 1 then
                                    if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                                        sampSendChat(string.format('/warn %s 21 cheat [%s/%s]', id, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                                    else
                                        sampSendChat(string.format('/warn %s 21 cheat', id))
                                    end
                                elseif wbstyle == 2 then
                                    if getFrak(wbfrak) ~= nil and wbfrak ~= 'Нет' then
                                        sampSendChat(string.format('/warn %s 21 cheat [%s/%s]', id, getFrak(wbfrak), wbrang))
                                    else
                                        sampSendChat(string.format('/warn %s 21 cheat', id))
                                    end
                                end
                            else
                                atext('Игрок '..wnick..' вышел из игры')
                            end
                        else
                            atext('Игрок '..wnick..' вышел из игры')
                        end
                    else
                        atext('Игрок '..wnick..' вышел из игры')
                    end
					checkstatdone = false
					warnst = false
					wbfrak = nil
					wbrang = nil
                    wnick = nil
                    wtime = nil
				end
			else
				atext('Игрок оффлайн')
			end
		else
			atext('Введите /cheat [id]')
		end
	end)
end
function getTargetBlipCoordinatesFixed()
    local bool, x, y, z = getTargetBlipCoordinates(); if not bool then return false end
    requestCollision(x, y); loadScene(x, y, z)
    local bool, x, y, z = getTargetBlipCoordinates()
    return bool, x, y, z
end
function tpmetkak()
	local result, x, y, z = getTargetBlipCoordinatesFixed()
	if result then
		setCharCoordinates(PLAYER_PED, x, y, z)
	end
end
function distance_cord(lat1, lon1, lat2, lon2)
	if lat1 == nil or lon1 == nil or lat2 == nil or lon2 == nil or lat1 == "" or lon1 == "" or lat2 == "" or lon2 == "" then
		return 0
	end
	local dlat = math.rad(lat2 - lat1)
	local dlon = math.rad(lon2 - lon1)
	local sin_dlat = math.sin(dlat / 2)
	local sin_dlon = math.sin(dlon / 2)
	local a =
		sin_dlat * sin_dlat + math.cos(math.rad(lat1)) * math.cos(
			math.rad(lat2)
		) * sin_dlon * sin_dlon
	local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
	local d = 6378 * c
	return d
end
function cip(pam)
	if #ips == 2 then
		local jsonips = encodeJson(ips)
		atext('Идет проверка IP адресов. Ожидайте..')
		asyncHttpRequest("POST", "http://ip-api.com/batch?fields=25305&lang=ru", { data = jsonips },
		function(response)
			local rdata = decodeJson(u8:decode(response.text))
			if rdata[1]["status"] == "success" and rdata[2]["status"] == "success" then
				local distances = distance_cord(rdata[1]["lat"], rdata[1]["lon"], rdata[2]["lat"], rdata[2]["lon"])
				if tonumber(pam) == nil then
					sampAddChatMessage((' Страна: {66FF00}%s{ffffff} | Город: {66FF00}%s{ffffff} | ISP: {66FF00}%s [R-IP: %s]'):format(rdata[1]["country"], rdata[1]["city"], rdata[1]["isp"], rdata[1]["query"]), -1)
					sampAddChatMessage((' Страна: {66FF00}%s{ffffff} | Город:{66FF00} %s{ffffff} | ISP: {66FF00}%s [IP: %s]'):format(rdata[2]["country"], rdata[2]["city"], rdata[2]["isp"], rdata[2]["query"]), -1)
					sampAddChatMessage((' Расстояние: {66FF00}%s {ffffff}км. | Ник: {66FF00}%s'):format(math.floor(distances), rnick), -1)
				else
					lua_thread.create(function()
						sampSendChat(('/a Страна: %s | Город: %s | ISP: %s [R-IP: %s]'):format(rdata[1]["country"], rdata[1]["city"], rdata[1]["isp"], rdata[1]["query"]), -1)
						wait(1200)
						sampSendChat(('/a Страна: %s | Город: %s | ISP: %s [IP: %s]'):format(rdata[2]["country"], rdata[2]["city"], rdata[2]["isp"], rdata[2]["query"]), -1)
						wait(1200)
						sampSendChat(('/a Расстояние: %s км. | Ник: %s'):format(math.floor(distances), rnick), -1)
					end)
				end
			end
		end,
		function(err)
			atext('Произошла ошибка проверки IP адресов')
		end
		)
	else
		atext('Не найдено IP адресов для сравнения')
	end
end
function massgun(pam)
	lua_thread.create(function()
		local gun, pt = pam:match('(%d+) (%d+)')
		if gun and pt then
			for k, v in pairs(sampGetStreamedPlayers()) do
				sampSendChat(("/givegun %s %s %s"):format(v, gun, pt))
				wait(1200)
			end
			atext('Выдача закончена')
		else
			atext('Введите /massgun [оружие] [патроны]')
		end
	end)
end
function masshp(pam)
	lua_thread.create(function()
		local hp = pam:match('(%d+)')
		if hp then
			for k, v in pairs(sampGetStreamedPlayers()) do
				sampSendChat(("/sethp %s %s"):format(v, hp))
				wait(1200)
			end
			atext('Выдача закончена')
		else
			atext('Введите /masshp [уровень хп]')
		end
	end)
end
function massarm(pam)
	lua_thread.create(function()
		local arm = pam:match('(%d+)')
		if arm then
			for k, v in pairs(sampGetStreamedPlayers()) do
				sampSendChat(("/setarm %s %s"):format(v, arm))
				wait(1200)
			end
			atext('Выдача закончена')
		else
			atext('Введите /massarm [уровень брони]')
		end
	end)
end
--[[function addtemp(pam)
    local pId = tonumber(pam)
    if pId ~= nil then
        if sampIsPlayerConnected(pId) then
            local nick = sampGetPlayerNickname(pId)
            table.insert(temp_checker_online, {nick = nick, id = pId})
            table.insert(temp_checker, nick)
            atext('Игрок '..nick..' ['..pId..'] добавлен в временный чекер')
        else
            table.insert(temp_checker, pId)
            atext('Игрок '..pId..' добавлен в временный чекер')
        end
    elseif pId == nil and #pam ~= 0 then
        if sampGetPlayerIdByNickname(tostring(pam)) ~= nil then
            local bpId = sampGetPlayerIdByNickname(tostring(pam))
            table.insert(temp_checker, {nick = pam, id = bpId})
			table.insert(temp_checker_online, {nick = nick, id = pId})
            atext('Игрок '..pam..' ['..bpId..'] добавлен в временный чекер')
        else
            atext('Игрок '..pam..' добавлен в временный чекер')
        end
        table.insert(temp_checker, pam)
    elseif #pam == 0 then
        atext('Введите /addtemp [id/nick]')
    end
end
function deltemp(pam)
    lua_thread.create(function()
        local pId = tonumber(pam)
        if pId ~= nil then
            if sampIsPlayerConnected(pId) then
                local nick = sampGetPlayerNickname(pId)
                local i = 1
                while i <= #temp_checker do
                    if temp_checker[i] == nick then
                        table.remove(temp_checker, i)
                    else
                        i = i + 1
                    end
                end
                atext('Игрок '..nick..' ['..pId..'] удален из временного чекера')
                local oi = 1
                while oi <= #temp_checker_online do
                    if temp_checker_online[oi].nick == nick then
                        table.remove(temp_checker_online, oi)
                    else
                        oi = oi + 1
                    end
                end
            else
                local i = 1
                while i <= #temp_checker do
                    if temp_checker[i] == pId then
                        table.remove(temp_checker, i)
                    else
                        i = i + 1
                    end
                end
				atext('Игрок '..pId.. 'удален из временного чекера')
            end
        elseif pId == nil and #pam ~= 0 then
            if sampGetPlayerIdByNickname(tostring(pam)) ~= nil then
                local bpId = sampGetPlayerIdByNickname(tostring(pam))
                local i = 1
                while i <= #temp_checker do
                    if temp_checker[i] == tostring(pam) then
                        table.remove(temp_checker, i)
                    else
                        i = i + 1
                    end
                end
                local oi = 1
                while oi <= #temp_checker_online do
                    if temp_checker_online[oi].nick == tostring(pam) then
                        table.remove(temp_checker_online, oi)
                    else
                        oi = oi + 1
                    end
                end
				atext('Игрок '..pam..' ['..bpId..'] удален из временного чекера')
            else
                local i = 1
                while i <= #temp_checker do
                    if temp_checker[i] == tostring(pam) then
                        table.remove(temp_checker, i)
                    else
                        i = i + 1
                    end
                end
				atext('Игрок '..pam.. 'удален из временного чекера')
            end
        end
    end)
end]]
function givehb(pam)
    lua_thread.create(function()
        local _, myid = sampGetPlayerIdByCharHandle(playerPed)
        local id, pack = pam:match('(%d+)%s+(.+)')
        if id and pack then
            if sampIsPlayerConnected(id) or tonumber(id) == myid then
                if doesFileExist('moonloader/Admin Tools/hblist/'..pack..'.txt') then
                    atext('Начата выдача объектов игроку '..sampGetPlayerNickname(id)..' ['..id..']')
                    for line in io.lines('moonloader/Admin Tools/hblist/'..pack..'.txt') do
                        sampSendChat('/hbject '..id..' '..line)
                        wait(1200)
                    end
                    atext('Выдача окончена')
                else
                    atext('Не обнаружено комплекта "'..pack..'"')
                end
            else
                atext('Игрок оффлайн')
            end
        else
            atext('Введите: /givehb [id] [имя комлекта]')
        end
    end)
end
function masshb(pam)
    lua_thread.create(function()
        local strp = sampGetStreamedPlayers()
        if #pam ~= 0 then
            if doesFileExist('moonloader/Admin Tools/hblist/'..pam..'.txt') then
                atext('Массовая выдача объектов начата')
                for k, v in pairs(strp) do
                    if sampIsPlayerConnected(v) then
                        atext('Начата выдача объектов игроку '..sampGetPlayerNickname(v)..' ['..v..']')
                        for line in io.lines('moonloader/Admin Tools/hblist/'..pam..'.txt') do
                            sampSendChat('/hbject '..v..' '..line)
                            wait(1200)
                        end
                        atext('Выдача объектов игроку '..sampGetPlayerNickname(v)..' ['..v..'] окончена')
                        wait(1200)
                    end
                end
                atext('Массовая выдача объектов окончена')
            else
                atext('Не обнаружено комплекта "'..pam..'"')
            end
        else
            atext('Введите: /masshb [имя комлекта]')
        end
    end)
end
function checkIntable(t, key)
    for k, v in pairs(t) do
        if v == key then return true end
    end
    return false
end
function masstp()
    lua_thread.create(function()
        masstpon = not masstpon
        smsids = {}
        atext(masstpon and 'Телепортация начата' or 'Телепортация окончена. Всего телепортировано: {66FF00}'..skoktp..'{ffffff} игроков')
        skoktp = 0
        if not masstpon then 
            wait(1200)
            sampSendChat('/togphone')
        else
            lua_thread.create(function()
                while true do wait(1200)
                    if not masstpon then return end
                    if #smsids > 0 then
                        sampSendChat('/gethere '..table.remove(smsids, 1))
                        skoktp = skoktp + 1
                    end    
                end
            end)
            while true do wait(0)
                if masstpon then
                    local smsx, smsy = convertGameScreenCoordsToWindowScreenCoords(242, 366)
                    renderFontDrawText(hudfont, 'Телепортация игроков. Осталось: {66FF00}'..#smsids..'\n{ffffff}Всего телепортировано: {66FF00}'..skoktp, smsx, smsy, -1)
                else return end
            end
        end    
    end)
end
function blog(pam)
    local id = tonumber(pam)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnected(id) then
                sampSendChat('/banlog '..sampGetPlayerNickname(id))
            else
                sampSendChat('/banlog ' ..id)
            end
        else
            sampSendChat('/banlog '..pam)
        end
    else
        atext('Введите /blog [id/nick]')
    end
end
function arecon()
    lua_thread.create(function()
        local ip, port = sampGetCurrentServerAddress()
        sampDisconnectWithReason(quit)
        wait(200)
        sampConnectToServer(ip, port)
    end)
end
function pwarn(pam)
        local id, days, reason = pam:match('(%d+) (%d+) (.+)')
        if id and days and reason then
            if sampIsPlayerConnected(id) then
                if sampGetPlayerScore(id) < 3 then
                    sampSendChat(string.format("/warn %s %s %s", id, days, reason))
                else
                    if cfg.other.fracstat then
                        warnst = true
                        local wnick = sampGetPlayerNickname(id)
                        sampSendChat('/getstats '..id)
                        local wtime = os.clock() + 10
                        while not checkstatdone or wtime < os.clock() do wait(0) end
                        wait(1200)
                        if sampIsPlayerConnected(id) then
                            if sampGetPlayerNickname(id) ~= nil then
                                if sampGetPlayerNickname(id) == wnick then
                                    if wbstyle == 1 then
                                        if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                                            sampSendChat(string.format('/warn %s %s %s [%s/%s]', id, days, reason, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                                        else
                                            sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                                        end
                                    elseif wbstyle == 2 then
                                        if getFrak(wbfrak) ~= nil and wbfrak ~= 'Нет' then
                                            sampSendChat(string.format('/warn %s %s %s [%s/%s]', id, days, reason, getFrak(wbfrak), wbrang))
                                        else
                                            sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                                        end
                                    end
                                else
                                    atext('Игрок '..wnick..' вышел из игры')
                                end
                            else
                                atext('Игрок '..wnick..' вышел из игры')
                            end
                        else
                            atext('Игрок '..wnick..' вышел из игры')
                        end
                    else
                        sampSendChat(string.format('/warn %s %s %s', id, days, reason))
                    end
                    checkstatdone = false
                    warnst = false
                    wbfrak = nil
                    wbrang = nil
                    wnick = nil
                    wtime = nil
                end
            else
                atext("Игрок оффлайн")
            end
        else
            atext('Введите: /warn [id] [дни] [причина]')
        end
end
function pban(pam)
        local id, reason = pam:match('(%d+) (.+)')
        if id and reason then
            if sampIsPlayerConnected(id) then
                if sampGetPlayerScore(id) < 3 then
                    sampSendChat(string.format('/ban %s %s', id, reason))
                else
                    if cfg.other.fracstat then
                        if not checkIntable(punishignor, reason) then
                            local wnick = sampGetPlayerNickname(id)
                            warnst = true
                            sampSendChat('/getstats '..id)
                            local wtime = os.clock() + 10
                            while not checkstatdone or wtime < os.clock() do wait(0) end
                            wait(1200)
                            if sampIsPlayerConnected(id) then
                                if sampGetPlayerNickname(id)~= nil then
                                    if sampGetPlayerNickname(id) == wnick then
                                        if wbstyle == 1 then
                                            if getRank(wbfrak, wbrang) ~= nil and getFrak(wbfrak) ~= nil then
                                                sampSendChat(string.format('/ban %s %s [%s/%s]', id, reason, getFrak(wbfrak), getRank(wbfrak, wbrang)))
                                            else
                                                sampSendChat(string.format('/ban %s %s', id, reason))
                                            end
                                        elseif wbstyle == 2 then
                                            if getFrak(wbfrak) ~= nil and wbfrak ~= 'Нет' then
                                                sampSendChat(string.format('/ban %s %s [%s/%s]', id, reason, getFrak(wbfrak), wbrang))
                                            else
                                                sampSendChat(string.format('/ban %s %s', id, reason))
                                            end
                                        end
                                    else
                                        atext('Игрок '..wnick..' вышел из игры')
                                    end
                                else
                                    atext('Игрок '..wnick..' вышел из игры')
                                end
                            else
                                atext('Игрок '..wnick..' вышел из игры')
                            end
                        else
                            sampSendChat(string.format('/ban %s %s', id, reason))
                        end
                        wnick = nil
                        checkstatdone = false
                        wbfrak = nil
                        wbrang = nil
                        warnst = false
                        wtime = nil
                    else
                        sampSendChat(string.format('/ban %s %s', id, reason))
                    end
                end
            else
                atext("Игрок оффлайн")
            end
        else
            atext('Введите: /ban [id] [причина]')
        end
end
function punish()
    lua_thread.create(function()
        atext('Выдача наказаний по жалобам начата')
        for line in io.lines(os.getenv('TEMP')..'\\Punishment.txt') do
            if line:match('%[W%] Ник: .+ Количество дней: %d+ Причина: .+') then
                local pnick, pdays, preason = line:match('%[W%] Ник: (.+) Количество дней: (%d+) Причина: (.+)')
                local pnick = pnick:gsub(' ', '_')
                if sampGetPlayerIdByNickname(pnick) ~= nil then
                    pwarn(('%s %s %s'):format(sampGetPlayerIdByNickname(pnick), pdays, preason))
                else
                    sampSendChat(('/offwarn %s %s %s'):format(pnick, pdays, preason))
                end
                local pnick, pdays, preason = nil, nil, nil
                wait(1200)
            end
            if line:match('%[B%] Ник: .+ Количество дней:  Причина: .+') then
                local pnick, preason = line:match('%[B%] Ник: (.+) Количество дней:  Причина: (.+)')
                local pnick = pnick:gsub(' ', '_')
                if sampGetPlayerIdByNickname(pnick) ~= nil then
                    pban(('%s %s'):format(sampGetPlayerIdByNickname(pnick), preason))
                else
                    sampSendChat(('/offban %s %s'):format(pnick, preason))
                end
                local pnick, preason = nil, nil
                wait(1200)
            end
            if line:match('%[P%] Ник: .+ Количество минут: %d+ Причина: .+') then
                local pnick, pminutes, preason = line:match('%[P%] Ник: (.+) Количество минут: (%d+) Причина: (.+)')
                local pnick = pnick:gsub(' ', '_')
                if sampGetPlayerIdByNickname(pnick) ~= nil then
                    sampSendChat(('/prison %s %s %s'):format(sampGetPlayerIdByNickname(pnick), pminutes, preason))
                else
                    sampSendChat(('/offprison %s %s %s'):format(pnick, preason, pminutes))
                end
                local pnick, pminutes, preason = nil, nil, nil
                wait(1200)
            end
            if line:match('%[M%] Ник: .+ Количество минут: %d+ Причина: .+') then
                local pnick, pminutes, preason = line:match('%[M%] Ник: (.+) Количество минут: (%d+) Причина: (.+)')
                local pnick = pnick:gsub(' ', '_')
                if sampGetPlayerIdByNickname(pnick) ~= nil then
                    sampSendChat(('/mute %s %s %s'):format(sampGetPlayerIdByNickname(pnick), pminutes, preason))
                else
                    sampSendChat(('/offmute %s %s %s'):format(pnick, preason, pminutes))
                end
                local pnick, pminutes, preason = nil, nil, nil
                wait(1200)
            end
            if line:match('%[IB%] Ник: .+ Количество дней: 2038 Причина: .+') then
                local pnick, preason = line:match('%[IB%] Ник: (.+) Количество дней: 2038 Причина: (.+)')
                local pnick = pnick:gsub(' ', '_')
                if sampGetPlayerIdByNickname(pnick) ~= nil then
                    sampSendChat(('/iban %s %s'):format(sampGetPlayerIdByNickname(pnick), preason))
                else
                    sampSendChat(('/ioffban %s %s'):format(pnick, preason))
                end
                local pnick, preason = nil, nil
                wait(1200)
            end
        end
        atext('Выдача наказаний по жалобам окончена')
        local pfile = io.open('moonloader/Admin Tools/punishjb.txt', 'a')
        pfile:write('\n')
        pfile:write(os.date()..'\n')
        for line in io.lines(os.getenv('TEMP')..'\\Punishment.txt') do
            pfile:write(line..'\n')
        end
        pfile:close()
        local ppfile = io.open(os.getenv('TEMP')..'\\Punishment.txt', 'w')
        ppfile:close()
    end)
end
function punishlog(text)
    local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    if text:match('^ .+ получил предупреждение до .+ от .+') then
        local nick = text:match('^ .+ получил предупреждение до .+ от (.+)')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
    if text:match('^ Администратор .+ поместил в ДеМорган .+ на %d+ минут. Причина: .+') then
        local nick = text:match('^ Администратор (.+) поместил в ДеМорган .+ на %d+ минут. Причина: .+')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
    if text:match('^ Администратор: .+ выдал warn .+. Причина: .+') then
        local nick = text:match('^ Администратор: (.+) выдал warn .+. Причина: .+')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
    if text:match('^ Администратор: .+ забанил .+. Причина: .+') then
        local nick = text:match('^ Администратор: (.+) забанил .+. Причина: .+ ')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
    if text:match('^ IOffBan%[забанил: .+%]%[забанен: .+%]%[Причина: .+%]%[.+%]') then
        local nick = text:match('^ IOffBan%[забанил: (.+)%]%[забанен: .+%]%[Причина: .+%]%[.+%]')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
    if text:match('^ OffBan%[забанил: .+%]%[забанен: .+%]%[Причина: .+%]%[дней: %d+%]%[.+%]') then
        local nick = text:match('^ OffBan%[забанил: (.+)%]%[забанен: .+%]%[Причина: .+%]%[дней: %d+%]%[.+%]')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
    if text:match('^ .+ посажен в prison на %d+ минут. Администратор: .+. Причина: .+') then
        local nick = text:match('^ .+ посажен в prison на %d+ минут. Администратор: (.+). Причина: .+')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
    if text:match('^ OffMute%[Заткнул: .+%]%[Заткнут: .+%]%[Причина: .+%]%[минут: %d+%]') then
        local nick = text:match('^ OffMute%[Заткнул: (.+)%]%[Заткнут: .+%]%[Причина: .+%]%[минут: %d+%]')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
    if text:match('^ Администратор .+ заблокировал чат игрока .+, на %d+ минут. Причина: .+') then
        local nick = text:match('^ Администратор (.+) заблокировал чат игрока .+, на %d+ минут. Причина: .+')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
    if text:match('^ Вы посадили .+ в тюрьму на %d+ минут') then
        local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
        file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
        file:close()
    end
    if text:match('^ Администратор: .+ забанил .+ %[3 Предупреждения%]. Причина: .+ ') then
        local nick = text:match('^ Администратор: (.+) забанил .+ %[3 Предупреждения%]. Причина: .+ ')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
    if text:match('^ Администратор: .+ кикнул .+. Причина: .+') then
        local nick = text:match('^ Администратор: (.+) кикнул .+. Причина: .+')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
    if text:match('^ SBan%[забанил: .+%]%[забанен: .+%]%[причина: .+%]%[.+%]') then
        local nick = text:match('^ SBan%[забанил: (.+)%]%[забанен: .+%]%[причина: .+%]%[.+%]')
        if nick == mynick then
            local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
            file:write(('[%s || %s] %s\n'):format(os.date('%H:%M:%S'), os.date('%d.%m.%Y'), text))
            file:close()
        end
    end
end
function getlvl(pam)
    local t = {}
    local cid = tonumber(pam)
    if cid ~= nil then
        for i = 0, 999 do
            if sampIsPlayerConnected(i) then
                if sampGetPlayerScore(i) == cid then
                    table.insert(t, ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                end
            end
        end
        sampShowDialog(2131, '{ffffff}Игроки с уровнем: {66FF00}'..cid, table.concat(t, '\n'), 'x', _, 2)
    else
        atext('Введите: /getlvl [уровень]')
    end
end
function hblist()
    local lfs = require 'lfs'
    for line in lfs.dir('moonloader/Admin Tools/hblist') do
        if line:match('.+.txt') then
            atext(line)
        end
    end
end
function admchecker()
    if not doesFileExist('moonloader/config/Admin Tools/adminlist.txt') then io.open('moonloader/config/Admin Tools/adminlist.txt', 'w'):close() end
    if not doesFileExist('moonloader/config/Admin Tools/playerlist.txt') then io.open('moonloader/config/Admin Tools/playerlist.txt', 'w'):close() end
    if not doesFileExist('moonloader/config/Admin Tools/admchecker.json') then
        local file = io.open('moonloader/config/Admin Tools/admchecker.json', 'w')
        file:close()
    else
        local f = io.open('moonloader/config/Admin Tools/admchecker.json', 'r')
        if f then
            admins = decodeJson(f:read('*a'))
            f:close()
        end
    end
    for line in io.lines('moonloader/config/Admin Tools/adminlist.txt') do
        table.insert(admins, {
            nick = line,
            color = 'ffffff',
            text = ''
        })
    end
    if not doesFileExist('moonloader/config/Admin Tools/playerchecker.json') then
        local file = io.open('moonloader/config/Admin Tools/playerchecker.json', 'w')
        file:close()
    else
        local f = io.open('moonloader/config/Admin Tools/playerchecker.json', 'r')
        if f then
            players = decodeJson(f:read('*a'))
            f:close()
        end
    end
    for line in io.lines('moonloader/config/Admin Tools/playerlist.txt') do
        table.insert(players, {
            nick = line,
            color = 'ffffff',
            text = ''
        })
    end
    saveData(admins, 'moonloader/config/Admin Tools/admchecker.json')
    saveData(players, 'moonloader/config/Admin Tools/playerchecker.json')
    io.open('moonloader/config/Admin Tools/adminlist.txt', 'w'):close()
    io.open('moonloader/config/Admin Tools/playerlist.txt', 'w'):close()
end
function addplayer(pam)
    if pam:match('(%d+) (%S+) (.+)') then
        local id, color, text = pam:match('(%d+) (%S+) (.+)')
        if color == '-1' then color = 'ffffff' end
        if sampIsPlayerConnected(tonumber(id)) then
            table.insert(players, {nick = sampGetPlayerNickname(tonumber(id)), color = color, text = text})
            table.insert(players_online, {nick = sampGetPlayerNickname(tonumber(id)), id = id, color = color, text = text})
            atext(('Игрок %s [%s] добавлен в чекер игроков'):format(sampGetPlayerNickname(tonumber(id)), id))
        else
            table.insert(players, {nick = id, color = color, text = text})
            atext(('Игрок %s добавлен в чекер игроков'):format(id))
        end
    elseif pam:match("(%a+) (%S+) (.+)") then
        local nick, color, text = pam:match("(%a+) (%S+) (.+)")
        local id = sampGetPlayerIdByNickname(nick)
        table.insert(players, {nick = nick, color = color, text = text})
        if id ~= nil then
            table.insert(players_online, {nick = nick, id = id, color = color, text = text})
            atext(('Игрок %s [%s] добавлен в чекер игроков'):format(nick, id))
        else
            atext(('Игрок %s добавлен в чекер игроков'):format(nick))
        end
    elseif pam:match("(%d+)") then
        local id = pam:match('(%d+)')
        if sampIsPlayerConnected(tonumber(id)) then
            table.insert(players, {nick = sampGetPlayerNickname(tonumber(id)), color = 'ffffff', text = ''})
            table.insert(players_online, {nick = sampGetPlayerNickname(tonumber(id)), id = id, color = 'ffffff', text = ''})
            atext(('Игрок %s [%s] добавлен в чекер игроков'):format(sampGetPlayerNickname(tonumber(id)), id))
        else
            table.insert(players, {nick = id, color = 'ffffff', text = ''})
            atext(('Игрок %s добавлен в чекер игроков'):format(id))
        end
    elseif pam:match('(%S+)') then
        local nick = pam:match('(%S+)')
        local id = sampGetPlayerIdByNickname(nick)
        table.insert(players, {nick = nick, color = 'ffffff', text = ''})
        if id ~= nil then
            table.insert(players_online, {nick = nick, id = id, color = 'ffffff', text = ''})
            atext(('Игрок %s [%s] добавлен в чекер игроков'):format(nick, id))
        else
            atext(('Игрок %s добавлен в чекер игроков'):format(nick))
        end
    elseif #pam == 0 or not pam:match('(%S+)') or not pam:match("(%d+)") or not pam:match("(%a+) (%S+) (.+)") or not pam:match('(%d+) (%S+) (.+)') then
        atext('Введите: /addplayer [id/nick] [color(Пример: ffffff)/-1] [примечание]')
    end
    saveData(players, 'moonloader/config/Admin Tools/playerchecker.json')
end
function addadm(pam)
    if pam:match('(%d+) (%S+) (.+)') then
        local id, color, text = pam:match('(%d+) (%S+) (.+)')
        if color == '-1' then color = 'ffffff' end
        if sampIsPlayerConnected(tonumber(id)) then
            table.insert(admins, {nick = sampGetPlayerNickname(tonumber(id)), color = color, text = text})
            table.insert(admins_online, {nick = sampGetPlayerNickname(tonumber(id)), id = id, color = color, text = text})
            atext(('Игрок %s [%s] добавлен в чекер админов'):format(sampGetPlayerNickname(tonumber(id)), id))
        else
            table.insert(admins, {nick = id, color = color, text = text})
            atext(('Игрок %s добавлен в чекер админов'):format(id))
        end
    elseif pam:match("(%a+) (%S+) (.+)") then
        local nick, color, text = pam:match("(%a+) (%S+) (.+)")
        local id = sampGetPlayerIdByNickname(nick)
        table.insert(admins, {nick = nick, color = color, text = text})
        if id ~= nil then
            table.insert(admins_online, {nick = nick, id = id, color = color, text = text})
            atext(('Игрок %s [%s] добавлен в чекер админов'):format(nick, id))
        else
            atext(('Игрок %s добавлен в чекер админов'):format(nick))
        end
    elseif pam:match("(%d+)") then
        local id = pam:match('(%d+)')
        if sampIsPlayerConnected(tonumber(id)) then
            table.insert(admins, {nick = sampGetPlayerNickname(tonumber(id)), color = 'ffffff', text = ''})
            table.insert(admins_online, {nick = sampGetPlayerNickname(tonumber(id)), id = id, color = 'ffffff', text = ''})
            atext(('Игрок %s [%s] добавлен в чекер админов'):format(sampGetPlayerNickname(tonumber(id)), id))
        else
            table.insert(players, {nick = id, color = 'ffffff', text = ''})
            atext(('Игрок %s добавлен в чекер админов'):format(id))
        end
    elseif pam:match('(%S+)') then
        local nick = pam:match('(%S+)')
        local id = sampGetPlayerIdByNickname(nick)
        table.insert(admins, {nick = nick, color = 'ffffff', text = ''})
        if id ~= nil then
            table.insert(admins_online, {nick = nick, id = id, color = 'ffffff', text = ''})
            atext(('Игрок %s [%s] добавлен в чекер админов'):format(nick, id))
        else
            atext(('Игрок %s добавлен в чекер админов'):format(nick))
        end
    elseif #pam == 0 or not pam:match('(%S+)') or not pam:match("(%d+)") or not pam:match("(%a+) (%S+) (.+)") or not pam:match('(%d+) (%S+) (.+)') then
        atext('Введите: /addadm [id/nick] [color(Пример: ffffff)/-1] [примечание]')
    end
    saveData(admins, 'moonloader/config/Admin Tools/admchecker.json')
end
function delplayer(pam)
    if pam:match("(%d+)") then
        local id = pam:match("(%d+)")
        local i = 1
        local k = 1
        if sampIsPlayerConnected(tonumber(id)) then
            local nick = sampGetPlayerNickname(tonumber(id))
            while i <= #players_online do
                if players_online[i]['nick'] == nick then
                    table.remove(players_online, i)
                else
                    i = i + 1
                end
            end
            while k <= #players do
                if players[k]['nick'] == nick then
                    table.remove(players, k)
                else
                    k = k + 1
                end
            end
            atext(('Игрок %s [%s] удален из чекера игроков'):format(nick, id))
        else
            local v = 1
            while v <= #players do
                if players[v]['nick'] == id then
                    table.remove(players, v)
                else
                    v = v + 1
                end
            end
            atext(('Игрок %s удален из чекера игроков'):format(id))
        end
    elseif pam:match('(%S+)') then
        local nick = pam:match('(%S+)')
        local i = 1
        local k = 1
        local id = sampGetPlayerIdByNickname(nick)
        if id ~= nil then
            while i <= #players_online do
                if players_online[i]['nick'] == nick then
                    table.remove(players_online, i)
                else
                    i = i + 1
                end
            end
            atext(('Игрок %s [%s] удален из чекера игроков'):format(nick, id))
        else
            atext(('Игрок %s удален из чекера игроков'):format(nick))
        end
        while k <= #players do
            if players[k]['nick'] == nick then
                table.remove(players, k)
            else
                k = k + 1
            end
        end
    elseif #pam == 0 or not pam:match('(%S+)') or not pam:match("(%d+)") then
        atext('Введите: /delplayer [id/nick]')
    end
    saveData(players, 'moonloader/config/Admin Tools/playerchecker.json')
end
function deladm(pam)
    if pam:match("(%d+)") then
        local id = pam:match("(%d+)")
        local i = 1
        local k = 1
        if sampIsPlayerConnected(tonumber(id)) then
            local nick = sampGetPlayerNickname(tonumber(id))
            while i <= #admins_online do
                if admins_online[i]['nick'] == nick then
                    table.remove(admins_online, i)
                else
                    i = i + 1
                end
            end
            while k <= #admins do
                if admins[k]['nick'] == nick then
                    table.remove(admins, k)
                else
                    k = k + 1
                end
            end
            atext(('Игрок %s [%s] удален из чекера игроков'):format(nick, id))
        else
            local v = 1
            while v <= #admins do
                if admins[v]['nick'] == id then
                    table.remove(admins, v)
                else
                    v = v + 1
                end
            end
            atext(('Игрок %s удален из чекера игроков'):format(id))
        end
    elseif pam:match('(%S+)') then
        local nick = pam:match('(%S+)')
        local i = 1
        local k = 1
        local id = sampGetPlayerIdByNickname(nick)
        if id ~= nil then
            while i <= #admins_online do
                if admins_online[i]['nick'] == nick then
                    table.remove(admins_online, i)
                else
                    i = i + 1
                end
            end
            atext(('Игрок %s [%s] удален из чекера игроков'):format(nick, id))
        else
            atext(('Игрок %s удален из чекера игроков'):format(nick))
        end
        while k <= #admins do
            if admins[k]['nick'] == nick then
                table.remove(admins, k)
            else
                k = k + 1
            end
        end
    elseif #pam == 0 or not pam:match('(%S+)') or not pam:match("(%d+)") then
        atext('Введите: /deladm [id/nick]')
    end
    saveData(admins, 'moonloader/config/Admin Tools/admchecker.json')
end
function addtemp(pam)
    if pam:match('(%d+) (%S+) (.+)') then
        local id, color, text = pam:match('(%d+) (%S+) (.+)')
        if color == '-1' then color = 'ffffff' end
        if sampIsPlayerConnected(tonumber(id)) then
            table.insert(temp_checker, {nick = sampGetPlayerNickname(tonumber(id)), color = color, text = text})
            table.insert(temp_checker_online, {nick = sampGetPlayerNickname(tonumber(id)), id = id, color = color, text = text})
            atext(('Игрок %s [%s] добавлен в временный чекер'):format(sampGetPlayerNickname(tonumber(id)), id))
        else
            table.insert(temp_checker, {nick = id, color = color, text = text})
            atext(('Игрок %s добавлен в временный чекер'):format(id))
        end
    elseif pam:match("(%a+) (%S+) (.+)") then
        local nick, color, text = pam:match("(%a+) (%S+) (.+)")
        local id = sampGetPlayerIdByNickname(nick)
        table.insert(temp_checker, {nick = nick, color = color, text = text})
        if id ~= nil then
            table.insert(temp_checker_online, {nick = nick, id = id, color = color, text = text})
            atext(('Игрок %s [%s] добавлен в временный чекер'):format(nick, id))
        else
            atext(('Игрок %s добавлен в временный чекер'):format(nick))
        end
    elseif pam:match("(%d+)") then
        local id = pam:match('(%d+)')
        if sampIsPlayerConnected(tonumber(id)) then
            table.insert(temp_checker, {nick = sampGetPlayerNickname(tonumber(id)), color = 'ffffff', text = ''})
            table.insert(temp_checker_online, {nick = sampGetPlayerNickname(tonumber(id)), id = id, color = 'ffffff', text = ''})
            atext(('Игрок %s [%s] добавлен в временный чекер'):format(sampGetPlayerNickname(tonumber(id)), id))
        else
            table.insert(players, {nick = id, color = 'ffffff', text = ''})
            atext(('Игрок %s добавлен в временный чекер'):format(id))
        end
    elseif pam:match('(%S+)') then
        local nick = pam:match('(%S+)')
        local id = sampGetPlayerIdByNickname(nick)
        table.insert(temp_checker, {nick = nick, color = 'ffffff', text = ''})
        if id ~= nil then
            table.insert(temp_checker_online, {nick = nick, id = id, color = 'ffffff', text = ''})
            atext(('Игрок %s [%s] добавлен в временный чекер'):format(nick, id))
        else
            atext(('Игрок %s добавлен в временный чекер'):format(nick))
        end
    elseif #pam == 0 or not pam:match('(%S+)') or not pam:match("(%d+)") or not pam:match("(%a+) (%S+) (.+)") or not pam:match('(%d+) (%S+) (.+)') then
        atext('Введите: /addtemp [id/nick] [color(Пример: ffffff)/-1] [примечание]')
    end
end
function deltemp(pam)
    if pam:match("(%d+)") then
        local id = pam:match("(%d+)")
        local i = 1
        local k = 1
        if sampIsPlayerConnected(tonumber(id)) then
            local nick = sampGetPlayerNickname(tonumber(id))
            while i <= #temp_checker_online do
                if temp_checker_online[i]['nick'] == nick then
                    table.remove(temp_checker_online, i)
                else
                    i = i + 1
                end
            end
            while k <= #temp_checker do
                if temp_checker[k]['nick'] == nick then
                    table.remove(temp_checker, k)
                else
                    k = k + 1
                end
            end
            atext(('Игрок %s [%s] удален из временного чекера'):format(nick, id))
        else
            local v = 1
            while v <= #temp_checker do
                if temp_checker[v]['nick'] == id then
                    table.remove(temp_checker, v)
                else
                    v = v + 1
                end
            end
            atext(('Игрок %s удален из временного чекера'):format(id))
        end
    elseif pam:match('(%S+)') then
        local nick = pam:match('(%S+)')
        local i = 1
        local k = 1
        local id = sampGetPlayerIdByNickname(nick)
        if id ~= nil then
            while i <= #temp_checker_online do
                if temp_checker_online[i]['nick'] == nick then
                    table.remove(temp_checker_online, i)
                else
                    i = i + 1
                end
            end
            atext(('Игрок %s [%s] удален из временного чекера'):format(nick, id))
        else
            atext(('Игрок %s удален из временного чекера'):format(nick))
        end
        while k <= #temp_checker do
            if temp_checker[k]['nick'] == nick then
                table.remove(temp_checker, k)
            else
                k = k + 1
            end
        end
    elseif #pam == 0 or not pam:match('(%S+)') or not pam:match("(%d+)") then
        atext('Введите: /deltemp [id/nick]')
    end
end