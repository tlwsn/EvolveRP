script_name('Admin Tools')
script_version(2.66)
script_author('Thomas_Lawson, Edward_Franklin')
script_description('Admin Tools for Evolve RP')
script_properties('work-in-pause')
require 'lib.moonloader'
require 'lib.sampfuncs'
local lfs                       = require 'lfs'
local lweapons, weapons         = pcall(require, 'game.weapons')
                                  assert(lweapons, 'not found lib game.weapons')
local lsampev, sampev           = pcall(require, 'lib.samp.events')
                                  assert(lsampev, 'not found lib lib.samp.events')
local lencoding, encoding       = pcall(require, 'encoding')
                                  assert(lencoding, 'not found lib encoding')
local lkey, key                 = pcall(require, 'vkeys')
                                  assert(lkey, 'not found lib vkeys')
local lMatrix3X3, Matrix3X3     = pcall(require, 'matrix3x3')
                                  assert(lMatrix3X3, 'not found lib matrix3x3')
local lVector3D, Vector3D       = pcall(require, 'vector3d')
                                  assert(lVector3D, 'not found lib vector3d')
local lffi, ffi                 = pcall(require, 'ffi')
                                  assert(lffi, 'not found lib ffi')
local lmem, mem                 = pcall(require, 'memory')
                                  assert(lmem, 'not found lib memory')
local lwm, wm                   = pcall(require, 'lib.windows.message')
                                  assert(lwm, 'not found lib lib.windows.message')
local limgui, imgui             = pcall(require, 'imgui')
                                  assert(limgui, 'not found lib imgui')
local limadd, imadd             = pcall(require, 'imgui_addons')
                                  assert(limadd, 'not found lib imgui_addons')
local lrkeys, rkeys             = pcall(require, 'rkeys')
                                  assert(lrkeys, 'not found lib rkeys')
local lcopas, copas             = pcall(require, 'copas')
                                  assert(lcopas, 'not found lib copas')
local lhttp, http               = pcall(require, 'copas.http')
                                  assert(lhttp, 'not found lib copas_http')
local lcrypto, crypto           = pcall(require, 'crypto_lua')
local d3dx9_43                  = ffi.load('d3dx9_43.dll')
local getBonePosition           = ffi.cast("int (__thiscall*)(void*, float*, int, bool)", 0x5E4280)
local dlstatus                  = require('moonloader').download_status
encoding.default                = 'CP1251'
local u8                        = encoding.UTF8
local prcheck                   = {pr = 0, prt = {}}
local imset                     = {}
local wrecon                    = {}
local adminslist                = {}
local imtext                    = {}
local tkilllist                 = {}
local checkf                    = {}
local ocheckf                   = {c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0}
local ips                       = {}
local ban                       = {}
local recon                     = {}
local smsids                    = {}
local admins                    = {}
local nametagCoords             = {}
local fonl                      = {}
local chatB                     = {}
local checkf                    = {f= {}}
local oocLimit                  = {state = true, msg = ""}
local mainwindow                = imgui.ImBool(false)
local settingwindows            = imgui.ImBool(false)
local tpwindow                  = imgui.ImBool(false)
local imrecon                   = imgui.ImBool(false)
local cmdwindow                 = imgui.ImBool(false)
local mpwindow                  = imgui.ImBool(false)
local bMainWindow               = imgui.ImBool(false)
local sInputEdit                = imgui.ImBuffer(256)
local bIsEnterEdit              = imgui.ImBool(false)
local leadwindow                = imgui.ImBool(false)
local mpend                     = imgui.ImBool(false)
local tunwindow                 = imgui.ImBool(false)
local tpname                    = imgui.ImBuffer(256)
local tpcoords                  = imgui.ImInt3(0, 0, 0)
local newtpname                 = imgui.ImBuffer(256)
local mpname                    = imgui.ImBuffer(256)
local mpsponsors                = imgui.ImBuffer(256)
local mpwinner                  = imgui.ImBuffer(256)
local mcolorb                   = imgui.ImInt(0)
local pcolorb                   = imgui.ImInt(0)
local bindname                  = imgui.ImBuffer(256)
local bindtext                  = imgui.ImBuffer(1024)
local nop                       = 0x90
local skoktp                    = 0
local killlistmode              = 0
local hfps                      = 0
local tpcount                   = 0
local countstart                = false
local swork                     = true
local nametag                   = true
local checkerEdit               = {
    window  = imgui.ImBool(false),
    select  = 0,
    admins  = {
        nick    = imgui.ImBuffer(256),
        color   = imgui.ImBuffer(128),
        desc    = imgui.ImBuffer(256),
        list    = 0
    },
    players  = {
        nick    = imgui.ImBuffer(256),
        color   = imgui.ImBuffer(128),
        desc    = imgui.ImBuffer(256),
        list    = 0
    },
}
local oCheat                    = {
    wind            = imgui.ImBool(false), 
    extra           = imgui.ImBool(false), 
    spread          = imgui.ImBool(false), 
    unlimBullets    = imgui.ImBool(false),
    aim             = imgui.ImBool(false)
}
local checker                   = {
    admins = {
        loaded = {}, 
        online = {}
    }, 
    players = {
        loaded = {}, 
        online = {}
    }, 
    temp = {
        loaded = {}, 
        online = {}
    }, 
    leaders = {
        loaded = {}, 
        online = {}
    }
}
local leaders = {
    ['LSPD'] = '-',
    ['FBI'] = '-',
    ['SFA'] = '-',
    ['LCN'] = '-',
    ['Yakuza'] = '-',
    ['Mayor'] = '-',
    ['SFN'] = '-',
    ['SFPD'] = '-',
    ['Instructors'] = '-',
    ['Ballas'] = '-',
    ['Vagos'] = '-',
    ['RM'] = '-',
    ['Grove'] = '-',
    ['LSN'] = '-',
    ['Aztec'] = '-',
    ['Rifa'] = '-',
    ['LVA'] = '-',
    ['LVN'] = '-',
    ['LVPD'] = '-',
    ['Medic'] = '-',
    ['Mongols MC'] = '-',
    ['Warlocks MC'] = '-',
    ['Pagans MC'] = '-'
}
local leaders1 = {
    ['LSPD'] = '110CE7',
    ['FBI'] = '333333',
    ['SFA'] = '51964D',
    ['LCN'] = 'DDA701',
    ['Yakuza'] = 'FF0000',
    ['Mayor'] = '114D71',
    ['SFN'] = '56FB4E',
    ['SFPD'] = '110CE7',
    ['Instructors'] = '139BEC',
    ['Ballas'] = 'B313E7',
    ['Vagos'] = 'FFDE24',
    ['RM'] = 'B4B5B7',
    ['Grove'] = '009F00',
    ['LSN'] = '758C9D',
    ['Aztec'] = '01FCFF',
    ['Rifa'] = '2A9170',
    ['LVA'] = '51964D',
    ['LVN'] = 'E6284E',
    ['LVPD'] = '110CE7',
    ['Medic'] = '483D8B',
    ['Mongols MC'] = '333333',
    ['Warlocks MC'] = 'F45000',
    ['Pagans MC'] = '2C9197'
}
local config_keys = {
    banipkey = {v = {190}},
    warningkey = {v = {key.VK_Z}},
    reportkey = {v = {key.VK_X}},
    saveposkey = {v = {key.VK_M}},
    goposkey = {v = {key.VK_J}},
    cwarningkey = {v = {key.VK_R}},
    punaccept = {v = {key.VK_Y}},
    pundeny = {v = {key.VK_N}},
    whkey = {v = {16,71}},
    skeletwhkey = {v = {16, 72}},
    airbrkkey = {v = key.VK_RSHIFT}
}
local tplist = {}
local config_colors = {
    admchat = {r = 255, g = 255, b = 0, color = 16776960},
    supchat = {r = 0, g = 255, b = 153, color = 65433},
    smschat = {r = 255, g = 255, b = 0, color = 16776960},
    repchat = {r = 217, g = 119, b = 0, color = 14251776},
    anschat = {r = 140, g = 255, b = 155, color = 9240475},
    askchat = {r = 233, g = 165, b = 40, color = 15312168},
    jbchat = {r = 217, g = 119, b = 0, color = 14251776},
    tracemiss = {r = 0, g = 0, b = 255, color = -16776961},
    tracehit = {r = 255, g = 0, b = 0, color = -65536},
    hudmain = {r = 255, g = 255, b = 255, color = -1},
    hudsecond = {r= 0, g = 255, b = 0, color = -16711936}
}
local tEditData = {
	id = -1,
	inputActive = false
}
local quitReason = {
    '�����',
    '���/���',
    '����-���'
}
local otletel = {
    grove = {},
    ballas = {},
    rifa = {},
    vagos = {},
    aztec = {}
}
local recon = {
    {
        name = 'Change',
        onclick = function() sampSendClickTextdraw(2189) end
    },
    {
        name = "Check >>",
        onclick = {
            {
                name = 'Check-GM',
                onclick = function() sampSendClickTextdraw(2198) end
            },
            {
                name = 'Check-GM2',
                onclick = function() sampSendClickTextdraw(2199) end
            },
            {
                name = 'Check-GMCar',
                onclick = function() sampSendClickTextdraw(2200) end
            },
            {
                name = 'ResetShot',
                onclick = function() sampSendClickTextdraw(2201) end
            }
        }
    },
    {
        name = 'Drop >>',
        onclick = {
            {
                name = 'Mute',
                onclick = function() sampSendClickTextdraw(2202) end
            },
            {
                name = "Slap",
                onclick = function() sampSendClickTextdraw(2203) end
            },
            {
                name = "Prison",
                onclick = function() sampSendClickTextdraw(2204) end
            },
            {
                name = 'Freeze',
                onclick = function() sampSendClickTextdraw(2205) end
            },
            {
                name = 'UnFreeze',
                onclick = function() sampSendClickTextdraw(2206) end
            }
        }
    },
    {
        name = "Kick >>",
        onclick = {
            {
                name = "SKick",
                onclick = function() sampSendClickTextdraw(2207) end
            },
            {
                name = 'Kick',
                onclick = function() sampSendClickTextdraw(2208) end
            }
        }
    },
    {
        name = "Warn",
        onclick = function() sampSendClickTextdraw(2193) end
    },
    {
        name = "Ban >>",
        onclick = {
            {
                name = 'Ban',
                onclick = function() sampSendClickTextdraw(2209) end
            },
            {
                name = "SBan",
                onclick = function() sampSendClickTextdraw(2210) end
            },
            {
                name = 'IBan',
                onclick = function() sampSendClickTextdraw(2211) end
            }
        }
    },
    {
        name = "Stats >>",
        onclick = {
            {
                name = "Stats",
                onclick = function() sampSendClickTextdraw(2212) end
            },
            {
                name = "IWep",
                onclick = function() sampSendClickTextdraw(2213) end
            },
            {
                name = "GetIP",
                onclick = function() sampSendClickTextdraw(2214) end
            },
            {
                name = "Serial/S0b",
                onclick = function() sampSendClickTextdraw(2215) end
            }
        }
    },
    {
        name = "Refresh",
        onclick = function() sampSendClickTextdraw(2196) end
    },
    {
        name = 'Exit',
        onclick = function() sampSendClickTextdraw(2197) end
    },
    id = -1
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
        inv = 3,
        max_8 = 25,
        max_9 = 20
    },
    Mafia = {
        rang_7 = 8,
        rang_8 = 10,
        rang_9 = 11,
        inv = 5,
        max_8 = 14,
        max_9 = 12
    },
    Bikers = {
        rang_5 = 6,
        rang_6 = 7,
        rang_7 = 8,
        rang_8 = 10,
        inv = 4,
        max_5 = 3,
        max_6 = 3,
        max_7 = 3,
        max_8 = 3
    }
}
local tBindList = {
    [1] = {
        text = "",
        v = {},
        name = '����1'
    },
    [2] = {
        text = "",
        v = {},
        name = '����2'
    },
    [3] = {
        text = "",
        v = {},
        name = '����3'
    }
}
local punkey = {warn = {}, ban = {}, prison = {}, re = {}, sban = {}, auninvite = {}, pspawn = {}, addabl = {}}
local flyInfo = {
    active = false,
    fly_active = false,
    update = os.clock(),
    isASvailable = true,
    ----------
    speed_none = 3.0,
    speed_accelerate = 16.0,
    speed_decelerate = 0.0,
    ----------
    currentSpeed = 0.0,
    rotationSpeed = 0.0,
    upSpeed = 0.0,
    ----------
    strafe_none = 0,
    strafe_left = 1,
    strafe_right = 2,
    strafe_up = 3,
    ----------
    keySpeedState = 0,
    keyStrafeState = 0,
    lastKeyStrafeState = 0,
    lastKeySpeedState = 0,
}
local tkills = {}
local BulletSync = {lastId = 0, maxLines = 25}
for i = 1, BulletSync.maxLines do
	BulletSync[i] = {enable = true, o = {x, y, z}, t = {x, y, z}, time = 0, tType = 0}
end
local savecoords = {x = 0, y = 0, z = 0}
local traceid = -1
local players = {}
local screenx, screeny = getScreenResolution()
local funcsStatus = {ClickWarp = false, Inv = false, AirBrk = false}
local tLastKeys = {}
local tCarsName = {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BFInjection", "Hunter",
"Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo",
"RCBandit", "Romero","Packer", "Monster", "Admiral", "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed",
"Yankee", "Caddy", "Solair", "Berkley'sRCVan", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RCBaron", "RCRaider", "Glendale", "Oceanic", "Sanchez", "Sparrow",
"Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage",
"Dozer", "Maverick", "NewsChopper", "Rancher", "FBIRancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "BlistaCompact", "PoliceMaverick",
"Boxvillde", "Benson", "Mesa", "RCGoblin", "HotringRacerA", "HotringRacerB", "BloodringBanger", "Rancher", "SuperGT", "Elegant", "Journey", "Bike",
"MountainBike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "hydra", "FCR-900", "NRG-500", "HPV1000",
"CementTruck", "TowTruck", "Fortune", "Cadrona", "FBITruck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan", "Blade", "Freight",
"Streak", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada",
"Yosemite", "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RCTiger", "Flash", "Tahoma", "Savanna", "Bandito",
"FreightFlat", "StreakCarriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400", "NewsVan",
"Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club", "FreightBox", "Trailer", "Andromada", "Dodo", "RCCam", "Launch", "PoliceCar", "PoliceCar",
"PoliceCar", "PoliceRanger", "Picador", "S.W.A.T", "Alpha", "Phoenix", "GlendaleShit", "SadlerShit", "Luggage A", "Luggage B", "Stairs", "Boxville", "Tiller",
"UtilityTrailer"}
local tCarsTypeName = {"����������", "���������", "�������", "������", "������", "�����", "������", "�����", "���������"}
local tCarsSpeed = {43, 40, 51, 30, 36, 45, 30, 41, 27, 43, 36, 61, 46, 30, 29, 53, 42, 30, 32, 41, 40, 42, 38, 27, 37,
54, 48, 45, 43, 55, 51, 36, 26, 30, 46, 0, 41, 43, 39, 46, 37, 21, 38, 35, 30, 45, 60, 35, 30, 52, 0, 53, 43, 16, 33, 43,
29, 26, 43, 37, 48, 43, 30, 29, 14, 13, 40, 39, 40, 34, 43, 30, 34, 29, 41, 48, 69, 51, 32, 38, 51, 20, 43, 34, 18, 27,
17, 47, 40, 38, 43, 41, 39, 49, 59, 49, 45, 48, 29, 34, 39, 8, 58, 59, 48, 38, 49, 46, 29, 21, 27, 40, 36, 45, 33, 39, 43,
43, 45, 75, 75, 43, 48, 41, 36, 44, 43, 41, 48, 41, 16, 19, 30, 46, 46, 43, 47, -1, -1, 27, 41, 56, 45, 41, 41, 40, 41,
39, 37, 42, 40, 43, 33, 64, 39, 43, 30, 30, 43, 49, 46, 42, 49, 39, 24, 45, 44, 49, 40, -1, -1, 25, 22, 30, 30, 43, 43, 75,
36, 43, 42, 42, 37, 23, 0, 42, 38, 45, 29, 45, 0, 0, 75, 52, 17, 32, 48, 48, 48, 44, 41, 30, 47, 47, 40, 41, 0, 0, 0, 29, 0, 0
}
local tCarsType = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1,
3, 1, 1, 1, 1, 6, 1, 1, 1, 1, 5, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 6, 3, 2, 8, 5, 1, 6, 6, 6, 1,
1, 1, 1, 1, 4, 2, 2, 2, 7, 7, 1, 1, 2, 3, 1, 7, 6, 6, 1, 1, 4, 1, 1, 1, 1, 9, 1, 1, 6, 1,
1, 3, 3, 1, 1, 1, 1, 6, 1, 1, 1, 3, 1, 1, 1, 7, 1, 1, 1, 1, 1, 1, 1, 9, 9, 4, 4, 4, 1, 1, 1,
1, 1, 4, 4, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 1, 1,
1, 3, 1, 1, 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 1, 1, 1, 1, 8, 8, 7, 1, 1, 1, 1, 1, 4,
1, 1, 1, 2, 1, 1, 5, 1, 2, 1, 1, 1, 7, 5, 4, 4, 7, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 5, 1, 5, 5
}
function saveData(table, path)
	if doesFileExist(path) then os.remove(path) end
    local sfa = io.open(path, "w")
    if sfa then
        sfa:write(encodeJson(table))
        sfa:close()
    end
end

function bgra_to_argb(bgra)
    local b, g, r, a = explode_argb(bgra)
    return join_argb(a, r, g, b)
  end

function argb_to_rgba(argb)
    local a, r, g, b = explode_argb(argb)
    return join_argb(r, g, b, a)
end

function set_argb_alpha(color, alpha)
    local _, r, g, b = explode_argb(color)
      return join_argb(alpha, r, g, b)
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

local vars = {
    bools = {
        recon = {
            isPopup = false
        }
    },
    others = {
        recon = {
            select = 1,
            selectPopup = 1
        }
    }
}

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
local cfg = {
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
    leadersChecker = {
        enable = true,
        posx = screenx/2,
        posy = screeny/2,
        cvetnick = true
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
    recon = {
        fPosX = screenx/2,
        fPosY = screeny/2,
        sPosX = screenx/2,
        sPosY = screeny/2,
		fSizeX = 150,
		fSizeY = 310,
		sSizeX = 260,
		sSizeY = 285,
        fCoff = 1,
        sCoff = 1,
        bSize = 28.720,
        enable = false,
        fFontSize = 1,
        sFontSize = 1
    },
	timers = {
		sbivtimer = 30,
		csbivtimer = 60,
        cbugtimer = 60,
        mnarkotimer = 7,
        mcbugtimer = 3,
        vkvtimer = 60
    },
    joinquit = {
        joinposx = 3,
        joinposy = screeny-45,
        quitposx = 3,
        quitposy = screeny-30,
        enable = true
    },
    killlist = {
        posx = screenx/2,
        posy = screeny/2,
        startenable = true
    },
    other = {
		passb = false,
		apassb = false,
        password = "",
        adminpass = "",
        reconw = true,
        checksize = 9,
        checkfont = 'Arial',
        whfont = "Verdana",
        whsize = 8,
        hudfont = "Arial",
        killfont = "Arial",
        killsize = 10,
        hudsize = 10,
        chatconsole = false,
        admlvl = 0,
        autoupdate = true,
        delay = 1200,
        skeletwh = true,
        socrpm = false,
        style = 1,
        resend = true,
        trace = true,
        spiartext = "���� ������� �� ����? ������� �� ����� ��������� - /ask",
        chatid = true
    }
}

local fraklist = {
    POLICE = {
        [1] = '�����',
        [2] = '������',
        [3] = '��.�������',
        [4] = '�������',
        [5] = '���������',
        [6] = '��.���������',
        [7] = '��.���������',
        [8] = '���������',
        [9] = '��.���������',
        [10] = '�������',
        [11] = '�����',
        [12] = '������������',
        [13] = '���������',
        [14] = '�����'
    },
    FBI = {
        [1] = '�����',
        [2] = '��������',
        [3] = '��.�����',
        [4] = '����� DEA',
        [5] = '����� CID',
        [6] = '����� DEA',
        [7] = '����� CID',
        [8] = '��������� FBI',
        [9] = '���.��������� FBI',
        [10] = '�������� FBI'
    },
    ARMY = {
        [1] = '�������',
        [2] = '��������',
        [3] = '��.�������',
        [4] = '�������',
        [5] = '��.�������',
        [6] = '��������',
        [7] = '���������',
        [8] = '��.���������',
        [9] = '���������',
        [10] = '��.���������',
        [11] = '�������',
        [12] = '�����',
        [13] = '������������',
        [14] = '���������',
        [15] = '�������'
    },
    LCN = {
        [1] = '�������',
        [2] = '���������',
        [3] = '�����������',
        [4] = '�������',
        [5] = '����',
        [6] = '�����-����',
        [7] = '����',
        [8] = '������� ����',
        [9] = '����������',
        [10] = '���'
    },
    YAKUZA = {
        [1] = '������',
        [2] = '�����',
        [3] = '�����',
        [4] = '����-�������',
        [5] = '����������',
        [6] = '��-�������',
        [7] = '�����',
        [8] = '�����-�����',
        [9] = '�����',
        [10] = '������'
    },
    MAYOR = {
        [1] = '���������',
        [2] = '��������',
        [3] = '�������',
        [4] = '��������� ������',
        [5] = '���. ����',
        [6] = '���'
    },
    NEWS = {
        [1] = '������',
        [2] = '�������������',
        [3] = '�������������',
        [4] = '��������',
        [5] = '�������',
        [6] = '��������',
        [7] = '��.��������',
        [8] = '���.��������',
        [9] = '���������� ��������',
        [10] = '���.��������'
    },
    SFPD = {
        [1] = '�����',
        [2] = '������',
        [3] = '��.�������',
        [4] = '�������',
        [5] = '���������',
        [6] = '��.���������',
        [7] = '��.���������',
        [8] = '���������',
        [9] = '��.���������',
        [10] = '�������',
        [11] = '�����',
        [12] = '������������',
        [13] = '���������',
        [14] = '�����'
    },
    INS = {
        [1] = '�����',
        [2] = '�����������',
        [3] = '�����������',
        [4] = '��.����������',
        [5] = '����������',
        [6] = '�����������',
        [7] = '��.��������',
        [8] = '��.��������',
        [9] = '��������',
        [10] = '�����������'
    },
    BALLAS = {
        [1] = '�����',
        [2] = '������� ����',
        [3] = '������',
        [4] = '��� ��o',
        [5] = '�� ���',
        [6] = '��������',
        [7] = '������� ����',
        [8] = '�����',
        [9] = '���� ����',
        [10] = '��� �����'
    },
    VAGOS = {
        [1] = '�������',
        [2] = '���������',
        [3] = '�����',
        [4] = '����������',
        [5] = '�������',
        [6] = 'V.E.G',
        [7] = '��������',
        [8] = '����� V.E.G',
        [9] = '�������',
        [10] = '�����'
    },
    RM = {
        [1] = '�����',
        [2] = '�����',
        [3] = '���',
        [4] = '������',
        [5] = '�������',
        [6] = '�����',
        [7] = '������',
        [8] = '���',
        [9] = '��� � ������',
        [10] = '���������'
    },
    GROVE = {
        [1] = '�����',
        [2] = '������',
        [3] = '�����',
        [4] = '����',
        [5] = '�������',
        [6] = '�.�.',
        [7] = '������',
        [8] = '�� ����',
        [9] = '������',
        [10] = '��� ���'
    },
    AZTEC = {
        [1] = '�����',
        [2] = '�������',
        [3] = '������',
        [4] = '��� �����',
        [5] = '�������',
        [6] = '�����',
        [7] = '�������',
        [8] = '��������',
        [9] = '������',
        [10] = '�����'
    },
    RIFA = {
        [1] = '������',
        [2] = '������',
        [3] = '�����',
        [4] = '����',
        [5] = '�������',
        [6] = '������',
        [7] = '�������',
        [8] = '���������',
        [9] = '�������',
        [10] = '�����'
    },
    MEDIC = {
        [1] = '������',
        [2] = '�������',
        [3] = '���.����',
        [4] = '���������',
        [5] = '��������',
        [6] = '������',
        [7] = '��������',
        [8] = '������',
        [9] = '���.����.�����',
        [10] = '����.����'
    },
    BIKERS = {
        [1] = 'Support', 
        [2] = 'Hang around',
        [3] = 'Prospect',
        [4] = 'Member',
        [5] = 'Road captain',
        [6] = 'Sergeant-at-arms',
        [7] = 'Treasurer',
        [8] = '���� ���������',
        [9] = '���������'
    }
}
local ID = {
    Fist = 0,
    Knuckles = 1,
    Golf = 2,
    Stick = 3,
    Knife = 4,
    Bat = 5,
    Shovel = 6,
    Cue = 7,
    Katana = 8,
    Chainsaw = 9,
    Dildo1 = 10,
    Dildo2 = 11,
    Dildo3 = 12,
    Dildo4 = 13,
    Flowers = 14,
    Cane = 15,
    Grenade = 16,
    Gas = 17,
    Molotov = 18,
    Pistol = 22,
    Slicend = 23,
    Deagle = 24,
    Shotgun = 25,
    Sawnoff = 26,
    Combat = 27,
    Uzi = 28,
    MP5 = 29,
    Ak47 = 30,
    M4 = 31,
    Tec9 = 32,
    Rifle = 33,
    Sniper = 34,
    RPG = 35,
    Launcher = 36,
    Flame = 37,
    Minigun = 38,
    Satchel = 39,
    Detonator = 40,
    Spray = 41,
    Extinguisher = 42,
    Camera = 43,
    Goggles1 = 44,
    Goggles2 = 45,
    Parachute = 46,
    Fake = 47,
    Huy2 = 48,
    Vehicle = 49,
    Helicopter = 50,
    Explosion = 51,
    Huy = 52,
    Drown = 53,
    Collision = 54,
    Connect = 200,
    Disconnect = 201,
    Suicide = 255
}
local RenderGun = {
    [ID.Fist] = 37,
    [ID.Knuckles] = 66,
    [ID.Golf] = 62,
    [ID.Stick] = 40,
    [ID.Knife] = 67,
    [ID.Bat] = 63,
    [ID.Shovel] = 38,
    [ID.Cue] = 34,
    [ID.Katana] = 33,
    [ID.Chainsaw] = 49,
    [ID.Dildo1] = 69,
	[ID.Dildo2] = 69,
	[ID.Dildo3] = 69,
    [ID.Dildo4] = 69,
    [ID.Flowers] = 36,
    [ID.Cane] = 35,
    [ID.Grenade] = 64,
    [ID.Gas] = 68,
    [ID.Molotov] = 39,
    [ID.Pistol] = 54,
    [ID.Slicend] = 50,
    [ID.Deagle] = 51,
    [ID.Shotgun] = 61,
    [ID.Sawnoff] = 48,
    [ID.Combat] = 43,
    [ID.Uzi] = 73,
    [ID.MP5] = 56,
    [ID.Ak47] = 72,
    [ID.M4] = 53,
    [ID.Tec9] = 55,
    [ID.Rifle] = 46,
    [ID.Sniper] = 65,
    [ID.RPG] = 52,
    [ID.Launcher] = 41,
    [ID.Flame] = 42,
    [ID.Minigun] = 70,
    [ID.Satchel] = 60,
    [ID.Detonator] = 59,
    [ID.Spray] = 47,
    [ID.Extinguisher] = 44,
    [ID.Camera] = 74,
    [ID.Goggles1] = 45,
    [ID.Goggles2] = 45,
    [ID.Parachute] = 74,
    [ID.Fake] = 74,
    [ID.Huy2] = 74,
    [ID.Vehicle] = 77,
    [ID.Helicopter] = 82,
    [ID.Explosion] = 81,
    [ID.Huy] = 74,
    [ID.Drown] = 74,
    [ID.Collision] = 75,
    [ID.Connect] = 78,
    [ID.Disconnect] = 78,
    [ID.Suicide] = 74
}

function httpRequest(request, body, handler) -- copas.http
    -- start polling task
    if not copas.running then
        copas.running = true
        lua_thread.create(function()
            wait(0)
            while not copas.finished() do
                local ok, err = copas.step(0)
                if ok == nil then error(err) end
                wait(0)
            end
            copas.running = false
        end)
    end
    -- do request
    if handler then
        return copas.addthread(function(r, b, h)
            copas.setErrorHandler(function(err) h(nil, err) end)
            h(http.request(r, b))
        end, request, body, handler)
    else
        local results
        local thread = copas.addthread(function(r, b)
            copas.setErrorHandler(function(err) results = {nil, err} end)
            results = table.pack(http.request(r, b))
        end, request, body)
        while coroutine.status(thread) ~= 'dead' do wait(0) end
        return table.unpack(results)
    end
end

function d3dxfont_create(name, height, charset)
    charset = charset or 1
    local d3ddev = ffi.cast('void*', getD3DDevicePtr())
    local pfont = ffi.new('ID3DXFont*[1]', {nil})
    if tonumber(d3dx9_43.D3DXCreateFontA(d3ddev, height, 0, 600, 1, false, charset, 0, 4, 0, name, pfont)) < 0 then
        return nil
    end
    return pfont[0]
end

function d3dxfont_draw(font, text, rect, color, format)
    local prect = ffi.new('RECT[1]', {{rect[1], rect[2], rect[3], rect[4]}})
    return font.vtbl.DrawTextA(font, nil, text, -1, prect, format, color)
end

function onD3DDeviceLost()
    if fonts_loaded then
        font_gtaweapon3.vtbl.OnLostDevice(font_gtaweapon3)
    end
end

function onD3DDeviceReset()
    if fonts_loaded then
        font_gtaweapon3.vtbl.OnResetDevice(font_gtaweapon3)
    end
end

function atext(text)
    sampAddChatMessage(string.format(' Admin Tools | {ffffff}%s', text), 0x66FF00)
end

function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
    style.WindowPadding = ImVec2(15, 15)
    style.WindowRounding = 5.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
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
    colors[clr.ChildWindowBg] = ImVec4(0.06, 0.05, 0.07, 1.00)
    colors[clr.PopupBg] = ImVec4(0.07, 0.07, 0.09, 1.00)
    colors[clr.Border] = ImVec4(0.80, 0.80, 0.83, 0.88)
    colors[clr.BorderShadow] = ImVec4(0.92, 0.91, 0.88, 0.00)
    colors[clr.FrameBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.FrameBgHovered] = ImVec4(0.24, 0.23, 0.29, 1.00)
    colors[clr.FrameBgActive] = ImVec4(0.56, 0.56, 0.58, 1.00)
    colors[clr.TitleBg] = ImVec4(0.10, 0.09, 0.12, 1.00)
    colors[clr.TitleBgCollapsed] = ImVec4(0.10, 0.09, 0.12, 1.00)
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
    colors[clr.ResizeGrip] = ImVec4(0.00, 0.00, 0.00, 1.00)
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



function transform2d(x, y, z)
    local view = require("ffi").cast("float *", 0xB6FA2C)
    local sx, sy = getScreenResolution()
    local nx, ny, nz

    nx = view[0] * x + view[4] * y + view[8] * z + view[12] * 1
    ny = view[1] * x + view[5] * y + view[9] * z + view[13] * 1
    nz = view[2] * x + view[6] * y + view[10] * z + view[14] * 1

    return nx * sx / nz, ny * sy / nz, nz
end

function calcScreenCoors(fX,fY,fZ)
	local dwM = 0xB6FA2C

	local m_11 = mem.getfloat(dwM + 0*4)
	local m_12 = mem.getfloat(dwM + 1*4)
	local m_13 = mem.getfloat(dwM + 2*4)
	local m_21 = mem.getfloat(dwM + 4*4)
	local m_22 = mem.getfloat(dwM + 5*4)
	local m_23 = mem.getfloat(dwM + 6*4)
	local m_31 = mem.getfloat(dwM + 8*4)
	local m_32 = mem.getfloat(dwM + 9*4)
	local m_33 = mem.getfloat(dwM + 10*4)
	local m_41 = mem.getfloat(dwM + 12*4)
	local m_42 = mem.getfloat(dwM + 13*4)
	local m_43 = mem.getfloat(dwM + 14*4)

	local dwLenX = mem.read(0xC17044, 4)
	local dwLenY = mem.read(0xC17048, 4)

	frX = fZ * m_31 + fY * m_21 + fX * m_11 + m_41
	frY = fZ * m_32 + fY * m_22 + fX * m_12 + m_42
	frZ = fZ * m_33 + fY * m_23 + fX * m_13 + m_43

	fRecip = 1.0/frZ
	frX = frX * (fRecip * dwLenX)
	frY = frY * (fRecip * dwLenY)

    --[[if(frX<=dwLenX and frY<=dwLenY and frZ>1)then
        return frX, frY, frZ
	else
		return -1, -1, -1
    end]]
    return frX, frY, frZ
end

ffi.cdef[[
bool DwmEnableComposition(int uCompositionAction);
]]
ffi.cdef [[
typedef struct stRECT
{
    int left, top, right, bottom;
} RECT;

typedef struct stID3DXFont
{
    struct ID3DXFont_vtbl* vtbl;
} ID3DXFont;

struct ID3DXFont_vtbl
{
        void* QueryInterface; // STDMETHOD(QueryInterface)(THIS_ REFIID iid, LPVOID *ppv) PURE;
    void* AddRef; // STDMETHOD_(ULONG, AddRef)(THIS) PURE;
    uint32_t (__stdcall * Release)(ID3DXFont* font); // STDMETHOD_(ULONG, Release)(THIS) PURE;

    // ID3DXFont
    void* GetDevice; // STDMETHOD(GetDevice)(THIS_ LPDIRECT3DDEVICE9 *ppDevice) PURE;
    void* GetDescA; // STDMETHOD(GetDescA)(THIS_ D3DXFONT_DESCA *pDesc) PURE;
    void* GetDescW; // STDMETHOD(GetDescW)(THIS_ D3DXFONT_DESCW *pDesc) PURE;
    void* GetTextMetricsA; // STDMETHOD_(BOOL, GetTextMetricsA)(THIS_ TEXTMETRICA *pTextMetrics) PURE;
    void* GetTextMetricsW; // STDMETHOD_(BOOL, GetTextMetricsW)(THIS_ TEXTMETRICW *pTextMetrics) PURE;

    void* GetDC; // STDMETHOD_(HDC, GetDC)(THIS) PURE;
    void* GetGlyphData; // STDMETHOD(GetGlyphData)(THIS_ UINT Glyph, LPDIRECT3DTEXTURE9 *ppTexture, RECT *pBlackBox, POINT *pCellInc) PURE;

    void* PreloadCharacters; // STDMETHOD(PreloadCharacters)(THIS_ UINT First, UINT Last) PURE;
    void* PreloadGlyphs; // STDMETHOD(PreloadGlyphs)(THIS_ UINT First, UINT Last) PURE;
    void* PreloadTextA; // STDMETHOD(PreloadTextA)(THIS_ LPCSTR pString, INT Count) PURE;
    void* PreloadTextW; // STDMETHOD(PreloadTextW)(THIS_ LPCWSTR pString, INT Count) PURE;

    int (__stdcall * DrawTextA)(ID3DXFont* font, void* pSprite, const char* pString, int Count, RECT* pRect, uint32_t Format, uint32_t Color); // STDMETHOD_(INT, DrawTextA)(THIS_ LPD3DXSPRITE pSprite, LPCSTR pString, INT Count, LPRECT pRect, DWORD Format, D3DCOLOR Color) PURE;
    void* DrawTextW; // STDMETHOD_(INT, DrawTextW)(THIS_ LPD3DXSPRITE pSprite, LPCWSTR pString, INT Count, LPRECT pRect, DWORD Format, D3DCOLOR Color) PURE;

    void (__stdcall * OnLostDevice)(ID3DXFont* font); // STDMETHOD(OnLostDevice)(THIS) PURE;
    void (__stdcall * OnResetDevice)(ID3DXFont* font); // STDMETHOD(OnResetDevice)(THIS) PURE;
};

uint32_t D3DXCreateFontA(void* pDevice, int Height, uint32_t Width, uint32_t Weight, uint32_t MipLevels, bool Italic, uint32_t CharSet, uint32_t OutputPrecision, uint32_t Quality, uint32_t PitchAndFamily, const char* pFaceName, ID3DXFont** ppFont);
]]
ffi.cdef[[
    typedef unsigned short WORD;

    typedef struct _SYSTEMTIME {
        WORD wYear;
        WORD wMonth;
        WORD wDayOfWeek;
        WORD wDay;
        WORD wHour;
        WORD wMinute;
        WORD wSecond;
        WORD wMilliseconds;
    } SYSTEMTIME, *PSYSTEMTIME;

    void GetSystemTime(
        PSYSTEMTIME lpSystemTime
    );

    void GetLocalTime(
        PSYSTEMTIME lpSystemTime
    );
]]

ffi.cdef[[
    struct stKillEntry
    {
    char                    szKiller[25];
    char                    szVictim[25];
    uint32_t                clKillerColor; // D3DCOLOR
    uint32_t                clVictimColor; // D3DCOLOR
    uint8_t                 byteType;
    } __attribute__ ((packed));

    struct stKillInfo
    {
    int                     iEnabled;
    struct stKillEntry      killEntry[5];
    int                     iLongestNickLength;
    int                     iOffsetX;
    int                     iOffsetY;
    void                  *pD3DFont; // ID3DXFont
    void                  *pWeaponFont1; // ID3DXFont
    void                *pWeaponFont2; // ID3DXFont
    void                    *pSprite;
    void                    *pD3DDevice;
    int                     iAuxFontInited;
    void                 *pAuxFont1; // ID3DXFont
    void                 *pAuxFont2; // ID3DXFont
    } __attribute__ ((packed));
]]

function isKillstatActive()
    local stKillInfo = ffi.cast('struct stKillInfo*', sampGetKillInfoPtr())
    return stKillInfo.iEnabled == 1
end

function systemTime()
    local time = ffi.new("SYSTEMTIME")
    ffi.C.GetSystemTime(time)
    return time
end

function localTime()
    local time = ffi.new("SYSTEMTIME")
    ffi.C.GetLocalTime(time)
    return time
end

function rainbow(speed, alpha)
	local r = math.sin(os.clock() * speed)
	local g = math.sin(os.clock() * speed + 2)
	local b = math.sin(os.clock() * speed + 4)
	return r,g,b,alpha
end

function sampGetStreamedPlayers()
	local t = {}
	for i = 0, sampGetMaxPlayerId(false) do
		if sampIsPlayerConnectedFixed(i) then
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
    if cfg.other.socrpm then
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
end

local russian_characters = {
    [168] = '�', [184] = '�', [192] = '�', [193] = '�', [194] = '�', [195] = '�', [196] = '�', [197] = '�', [198] = '�', [199] = '�', [200] = '�', [201] = '�', [202] = '�', [203] = '�', [204] = '�', [205] = '�', [206] = '�', [207] = '�', [208] = '�', [209] = '�', [210] = '�', [211] = '�', [212] = '�', [213] = '�', [214] = '�', [215] = '�', [216] = '�', [217] = '�', [218] = '�', [219] = '�', [220] = '�', [221] = '�', [222] = '�', [223] = '�', [224] = '�', [225] = '�', [226] = '�', [227] = '�', [228] = '�', [229] = '�', [230] = '�', [231] = '�', [232] = '�', [233] = '�', [234] = '�', [235] = '�', [236] = '�', [237] = '�', [238] = '�', [239] = '�', [240] = '�', [241] = '�', [242] = '�', [243] = '�', [244] = '�', [245] = '�', [246] = '�', [247] = '�', [248] = '�', [249] = '�', [250] = '�', [251] = '�', [252] = '�', [253] = '�', [254] = '�', [255] = '�',
}

function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end

function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end

function autoupdate(json_url, url)
    httpRequest(json_url, nil, function(response, code, headers, status)
        if response then
            local info = decodeJson(response)
            updatelink = info.admintools.url --testat ���� �� ��������
            updateversion = info.admintools.version
            if tonumber(updateversion) > tonumber(thisScript().version) then
                lua_thread.create(function()
                    local dlstatus = require('moonloader').download_status
                    atext(("���������� ����������. ������� ���������� � %s �� %s."):format(thisScript().version, updateversion))
                    atext("� ���� ���������� ���� ����� ��������� �� ���� ������.")
                    downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) 
                        if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                            thisScript():reload()
                        elseif status1 == 64 then
                            atext("���������� ���������� ������ �� �������. �������� ������ ������")
                        end
                    end)
                end)
            else
                print(("v%s: ���������� �� ���������"):format(thisScript().version))
            end
        else
            print(("v%s: �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� %s"):format(thisScript().version, url))
        end
    end)
end

function split(str, delim, plain)
    local lines, pos, plain = {}, 1, not (plain == false)
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

function enableKillList(enabled)
    setStructElement(sampGetKillInfoPtr(), 0x0, 4, enabled and 1 or 0)
end

function genCode(skey)
    skey = basexx.from_base32(skey)
    value = math.floor(os.time() / 30)
    value = string.char(
    0, 0, 0, 0,
    band(value, 0xFF000000) / 0x1000000,
    band(value, 0xFF0000) / 0x10000,
    band(value, 0xFF00) / 0x100,
    band(value, 0xFF))
    local hash = sha1.hmac_binary(skey, value)
    local offset = band(hash:sub(-1):byte(1, 1), 0xF)
    local function bytesToInt(a,b,c,d)
      return a*0x1000000 + b*0x10000 + c*0x100 + d
    end
    hash = bytesToInt(hash:byte(offset + 1, offset + 4))
    hash = band(hash, 0x7FFFFFFF) % 1000000
    return ('%06d'):format(hash)
end

function libs()
    if not lcopas or not lhttp or not lcrypto then
        atext('������ �������� ����������� ���������')
        atext('�� ��������� �������� ������ ����� ������������')
        if not lcopas or not lhttp then
            local direct = {'copas'}
            local files = {'copas.lua', "copas/ftp.lua", 'copas/http.lua', 'copas/limit.lua', 'copas/smtp.lua'}
            for k, v in pairs(direct) do if not doesDirectoryExist("moonloader/lib/"..v) then createDirectory("moonloader/lib/"..v) end end
            for k, v in pairs(files) do
                copas_download_status = 'proccess'
                downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/'..v, 'moonloader/lib/'..v, function(id, status, p1, p2)
                    if status == dlstatus.STATUS_DOWNLOADINGDATA then
                        copas_download_status = 'proccess'
                        print(string.format('��������� %d �������� �� %d ��������.', p1, p2))
                    elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                        copas_download_status = 'succ'
                    elseif status == 64 then
                        copas_download_status = 'failed'
                    end
                end)
                while copas_download_status == 'proccess' do wait(0) end
                if copas_download_status == 'failed' then
                    print('�� ������� ��������� copas')
                    thisScript():unload()
                else
                    print(v..' ��� ��������')
                end
            end
        end
        if not lcrypto then
            crypto_download_status = 'proccess'
            downloadUrlToFile('https://raw.githubusercontent.com/WhackerH/kirya/master/lib/crypto_lua.dll', 'moonloader/lib/crypto_lua.dll', function(id, status, p1, p2)
                if status == dlstatus.STATUS_DOWNLOADINGDATA then
                    crypto_download_status = 'proccess'
                    print(string.format('��������� %d �������� �� %d ��������.', p1, p2))
                elseif status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    crypto_download_status = 'succ'
                elseif status == 64 then
                    crypto_download_status = 'failed'
                end
            end)
            while crypto_download_status == 'proccess' do wait(0) end
            if crypto_download_status == 'failed' then
                print('�� ������� ��������� crypto_lua.dll')
                thisScript():unload()
            else
                print('crypto_lua.dll ��� ��������')
            end
        end
        atext('��� ����������� ���������� ���� ���������')
        reloadScripts()
    end
end

function infRun(bool)
    if bool then
        mem.setint8(0xB7CEE4, 1)
    else
        mem.setint8(0xB7CEE4, 0)
    end
end

function memstart()
    local samp = getModuleHandle('samp.dll')
    --���������� ���
	mem.fill(samp + 0x9D31A, nop, 12, true)
    mem.fill(samp + 0x9D329, nop, 12, true)
    --������������
    mem.fill(sampGetBase() + 0x2D3C45, 0, 2, true)
    --���� ������
    mem.fill(0x00531155, 0x90, 5, true)
    --����������� ���
    infRun(true)
    --���������� F1
    mem.setuint8(samp + 0x67450, 0xC3, true)
    --����������
    local ressamp1, samp1 = loadDynamicLibrary('samp.dll')
    if ressamp1 then
        samp1 = samp1+0x5CF2C
        writeMemory(samp1, 4, 0x90909090, 1)
        samp1 = samp1 + 4
        writeMemory(samp1, 1, 0x90, 1)
        samp1 = samp1 + 9
        writeMemory(samp1, 4, 0x90909090, 1)
        samp1 = samp1 + 4
        writeMemory(samp1, 1, 0x90, 1)
    end
    --��� �����
    local ressamp2, samp2 = loadDynamicLibrary('samp.dll')
    if ressamp2 then
        samp2 = samp2 + 0x9D9D0
        writeMemory(samp2, 4, 0x5051FF15, 1)
    end
end

function main()
    memstart()
    if lcopas and lhttp then
        httpRequest("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/apr.txt", nil, function(response, code, headers, status)
            if response then
                for line in response:gmatch('[^\r\n]+') do
                    table.insert(prcheck.prt, line)
                end
            else
                prcheck.pr = 3
            end
        end)
    end
    local directors = {'moonloader/Admin Tools', 'moonloader/Admin Tools/hblist', 'moonloader/config', 'moonloader/config/Admin Tools', 'moonloader/Admin Tools/Check Banned'}
    local files = {'moonloader/Admin Tools/chatlog_all.txt', 'moonloader/config/Admin Tools/fa.txt', 'moonloader/Admin Tools/punishjb.txt', 'moonloader/Admin Tools/punishlogs.txt', 'moonloader/Admin Tools/Check Banned/players.txt', "moonloader/Admin Tools/setmatlog.txt"}
    --��������� � ������� �����
    for k, v in pairs(directors) do
		if not doesDirectoryExist(v) then createDirectory(v) end
    end
    --��������� � ������� �����
    for k, v in pairs(files) do
        if not doesFileExist(v) then io.open(v, 'w'):close() end
    end
    --�������� ���� �������
    if not doesFileExist('moonloader/config/Admin Tools/config.json') then
        saveData(cfg, 'moonloader/config/Admin Tools/config.json')
        local scx, scy = convertGameScreenCoordsToWindowScreenCoords(552.33337402344, 435)
        local tcx, tcy = convertGameScreenCoordsToWindowScreenCoords(490.33334350586, 435)
        local ascx, ascy = convertGameScreenCoordsToWindowScreenCoords(3, 272)
        local kscx, kscy = convertGameScreenCoordsToWindowScreenCoords(536, 110)
        local lscx, lscy = convertGameScreenCoordsToWindowScreenCoords(416.33334350586, 435)
        cfg.playerChecker.posx = scx
        cfg.playerChecker.posy = screeny-15
        cfg.tempChecker.posx = tcx
        cfg.tempChecker.posy = screeny-15
        cfg.admchecker.posx = ascx
        cfg.admchecker.posy = ascy
        cfg.killlist.posx = kscx
        cfg.killlist.posy = kscy
        cfg.leadersChecker.posx = lscx
        cfg.leadersChecker.posy = screeny-15
    else
        local file = io.open('moonloader/config/Admin Tools/config.json', 'r')
        if file then
            cfg = decodeJson(file:read('*a'))
            if cfg.recon == nil then
                cfg.recon = {
                    fPosX = screenx/2,
                    fPosY = screeny/2,
                    sPosX = screenx/2,
                    sPosY = screeny/2,
                    fSizeX = 150,
                    fSizeY = 310,
                    sSizeX = 260,
                    sSizeY = 285,
                    fCoff = 1,
                    sCoff = 1,
                    bSize = 28.720,
                    enable = false,
                    fFontSize = 1,
                    sFontSize = 1
                }
                cfg.crecon = nil
                saveData(cfg, 'moonloader/config/Admin Tools/config.json')
            end
            if cfg.other.chatid == nil then cfg.other.chatid = true end
            if cfg.other.spiartext == nil then cfg.other.spiartext = "���� ������� �� ����? ������� �� ����� ��������� - /ask" end
            if cfg.other.trace == nil then cfg.other.trace = true end
            if cfg.timers.vkvtimer == nil then cfg.timers.vkvtimer = 60 end
            if cfg.other.resend == nil then cfg.other.resend = true end
            if cfg.other.style == nil then cfg.other.style = 1 end
            if cfg.recon.fFontSize == nil then
                cfg.recon.fFontSize = 1
                cfg.recon.sFontSize = 1
                saveData(cfg, 'moonloader/config/Admin Tools/config.json')
            end
            file:close()
        end
    end

    -- ���������� ��������
    imset = {
        set = {
            chatid      = imgui.ImBool(cfg.other.chatid),
            trace       = imgui.ImBool(cfg.other.trace),
            recon       = imgui.ImBool(cfg.other.reconw),
            pass        = imgui.ImBool(cfg.other.passb),
            apass       = imgui.ImBool(cfg.other.apassb),
            sfchat      = imgui.ImBool(cfg.other.chatconsole),
            joinquit    = imgui.ImBool(cfg.joinquit.enable),
            autoupd     = imgui.ImBool(cfg.other.autoupdate),
            killist     = imgui.ImBool(cfg.killlist.startenable),
            socrpm      = imgui.ImBool(cfg.other.socrpm),
            resend      = imgui.ImBool(cfg.other.resend),

            passbuff    = imgui.ImBuffer(tostring(cfg.other.password), 256),
            apassbuff   = imgui.ImBuffer(tostring(cfg.other.adminpass), 256),
            hudfont     = imgui.ImBuffer(tostring(cfg.other.hudfont), 256),
            killfont    = imgui.ImBuffer(tostring(cfg.other.killfont), 256),
            spiar       = imgui.ImBuffer(u8(tostring(cfg.other.spiartext)), 256),

            killsize    = imgui.ImInt(cfg.other.killsize),
            hudsize     = imgui.ImInt(cfg.other.hudsize),
            delay       = imgui.ImInt(cfg.other.delay)                
        },
        timers = {
            sbiv        = imgui.ImInt(cfg.timers.sbivtimer),
            csbiv       = imgui.ImInt(cfg.timers.csbivtimer),
            cbug        = imgui.ImInt(cfg.timers.cbugtimer),
            mnarko      = imgui.ImInt(cfg.timers.mnarkotimer),
            mcbug       = imgui.ImInt(cfg.timers.mcbugtimer),
            vkv         = imgui.ImInt(cfg.timers.vkvtimer)
        },
        checkers = {
            checksize   = imgui.ImInt(cfg.other.checksize),
            checkfont   = imgui.ImBuffer(tostring(cfg.other.checkfont), 256),
            admcheck    = imgui.ImBool(cfg.admchecker.enable),
            playercheck = imgui.ImBool(cfg.playerChecker.enable),
            tempcheck   = imgui.ImBool(cfg.tempChecker.enable),
            tempwarning = imgui.ImBool(cfg.tempChecker.wadd),
            leadcheck   = imgui.ImBool(cfg.leadersChecker.enable),
            colornick   = imgui.ImBool(cfg.leadersChecker.cvetnick)
        },
        cheat = {
            whfont      = imgui.ImBuffer(tostring(cfg.other.whfont), 256),
            whsize      = imgui.ImInt(cfg.other.whsize),
            skeletwh    = imgui.ImBool(cfg.other.skeletwh),
            gm          = imgui.ImBool(cfg.cheat.autogm),
            airspeed    = imgui.ImFloat(cfg.cheat.airbrkspeed)
        },
        recon = {
            enable      = imgui.ImBool(cfg.recon.enable),
            fcoff       = imgui.ImFloat(cfg.recon.fCoff),
            scoff       = imgui.ImFloat(cfg.recon.sCoff),
            bsize       = imgui.ImFloat(cfg.recon.bSize),
            fsize       = imgui.ImFloat(cfg.recon.fFontSize),
            ssize       = imgui.ImFloat(cfg.recon.sFontSize)
        }
    }

    --���� ����� ����������
    if not doesFileExist("moonloader/config/Admin Tools/tplist.json") then
        saveData(tplist, "moonloader/config/Admin Tools/tplist.json")
    else
        local file = io.open('moonloader/config/Admin Tools/tplist.json', 'r')
        if file then
            tplist = decodeJson(file:read('*a'))
        end
    end
    --���� ����� / �����
    if not doesFileExist("moonloader/config/Admin Tools/fraklist.json") then
        saveData(fraklist, 'moonloader/config/Admin Tools/fraklist.json')
    else
        local file = io.open('moonloader/config/Admin Tools/fraklist.json', 'r')
        if file then
            fraklist = decodeJson(file:read('*a'))
        end
    end
    --���� ������
    if not doesFileExist("moonloader/config/Admin Tools/keys.json") then
        saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
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
                    cwarningkey = {v = {key.VK_R}},
                    punaccept = {v = {key.VK_Y}},
                    pundeny = {v = {key.VK_N}},
                    whkey = {v = {16,71}},
                    skeletwhkey = {v = {16, 72}},
                    airbrkkey = {v = key.VK_RSHIFT},
                }
			end
            if config_keys.cwarningkey == nil then config_keys.cwarningkey = {v = {key.VK_R}} end
            if config_keys.punaccept == nil then config_keys.punaccept = {v = {key.VK_Y}} end
            if config_keys.pundeny == nil then config_keys.pundeny = {v = {key.VK_N}} end
            if config_keys.whkey == nil then config_keys.whkey = {v = {16,71}} end
            if config_keys.skeletwhkey == nil then config_keys.skeletwhkey = {v = {16, 72}} end
            if config_keys.airbrkkey == nil then config_keys.airbrkkey = {v = key.VK_RSHIFT} end
        end
    end
    --���� �������
    if not doesFileExist("moonloader/config/Admin Tools/binder.json") then
        saveData(tBindList, "moonloader/config/Admin Tools/binder.json")
	else
		local fb = io.open("moonloader/config/Admin Tools/binder.json", "r")
		if fb then
			tBindList = decodeJson(fb:read('*a'))
            if tBindList == nil then
                tBindList = {
                    [1] = {
                        text = "",
                        v = {},
                        name = '����1'
                    },
                    [2] = {
                        text = "",
                        v = {},
                        name = '����2'
                    },
                    [3] = {
                        text = "",
                        v = {},
                        name = '����3'
                    }
                }
			end
		end
    end
    --���� ������
    if not doesFileExist("moonloader/config/Admin Tools/colors.json") then
        saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
    else
        local fc = io.open("moonloader/config/Admin Tools/colors.json", "r")
        if fc then
            config_colors = decodeJson(fc:read('*a'))
            if config_colors == nil then
                config_colors = {
                    admchat = {r = 255, g = 255, b = 0, color = 16776960},
                    supchat = {r = 0, g = 255, b = 153, color = 65433},
                    smschat = {r = 255, g = 255, b = 0, color = 16776960},
                    repchat = {r = 217, g = 119, b = 0, color = 14251776},
                    anschat = {r = 140, g = 255, b = 155, color = 9240475},
                    askchat = {r = 233, g = 165, b = 40, color = 15312168},
                    jbchat = {r = 217, g = 119, b = 0, color = 14251776},
                    tracemiss = {r = 0, g = 0, b = 255, color = -16776961},
                    tracehit = {r = 255, g = 0, b = 0, color = -65536},
                    hudmain = {r = 255, g = 255, b = 255, color = -1},
                    hudsecond = {r= 0, g = 255, b = 0, color = -16711936}
                }
            end
            if config_colors.tracemiss == nil then config_colors.tracemiss = {r = 0, g = 0, b = 255, color = -16776961} end
            if config_colors.tracehit == nil then config_colors.tracehit = {r = 255, g = 0, b = 0, color = -65536} end
            if type(config_colors.admchat.color) == 'string' then config_colors.admchat.color = ARGBtoRGB(join_argb(255, config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b)) end
            if type(config_colors.supchat.color) == 'string' then config_colors.supchat.color = ARGBtoRGB(join_argb(255, config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b)) end
            if type(config_colors.smschat.color) == 'string' then config_colors.smschat.color = ARGBtoRGB(join_argb(255, config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b)) end
            if type(config_colors.repchat.color) == 'string' then config_colors.repchat.color = ARGBtoRGB(join_argb(255, config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b)) end
            if type(config_colors.anschat.color) == 'string' then config_colors.anschat.color = ARGBtoRGB(join_argb(255, config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b)) end
            if type(config_colors.askchat.color) == 'string' then config_colors.askchat.color = ARGBtoRGB(join_argb(255, config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b)) end
            if type(config_colors.jbchat.color) == 'string' then config_colors.jbchat.color = ARGBtoRGB(join_argb(255, config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b)) end

            acolor      = imgui.ImFloat3(config_colors.admchat.r / 255, config_colors.admchat.g / 255, config_colors.admchat.b / 255)
            scolor      = imgui.ImFloat3(config_colors.supchat.r / 255, config_colors.supchat.g / 255, config_colors.supchat.b / 255)
            smscolor    = imgui.ImFloat3(config_colors.smschat.r / 255, config_colors.smschat.g / 255, config_colors.smschat.b / 255)
            jbcolor     = imgui.ImFloat3(config_colors.jbchat.r / 255, config_colors.jbchat.g / 255, config_colors.jbchat.b / 255)
            askcolor    = imgui.ImFloat3(config_colors.askchat.r / 255, config_colors.askchat.g / 255, config_colors.askchat.b / 255)
            repcolor    = imgui.ImFloat3(config_colors.repchat.r / 255, config_colors.repchat.g / 255, config_colors.repchat.b / 255)
            anscolor    = imgui.ImFloat3(config_colors.anschat.r / 255, config_colors.anschat.g / 255, config_colors.anschat.b / 255)
            trhitcolor  = imgui.ImFloat3(config_colors.tracehit.r / 255, config_colors.tracehit.g / 255, config_colors.tracehit.b / 255)
            trmisscolor = imgui.ImFloat3(config_colors.tracemiss.r / 255, config_colors.tracemiss.g / 255, config_colors.tracemiss.b / 255)

            bulletTypes = {
                [0] = config_colors.tracemiss.color,
                [1] = config_colors.tracehit.color,
                [2] = config_colors.tracemiss.color,
                [3] = config_colors.tracemiss.color,
                [4] = config_colors.tracemiss.color,
                [5] = 0xFF00FF00
            }

            if config_colors.hudmain == nil then 
                config_colors.hudmain = {r = 255, g = 255, b = 255, color = -1} 
            end
            if config_colors.hudsecond == nil then
                config_colors.hudsecond = {r= 0, g = 255, b = 0, color = -16711936}
            end

            hudmaincolor    = imgui.ImFloat3(config_colors.hudmain.r / 255, config_colors.hudmain.g / 255, config_colors.hudmain.b / 255)
            hudsecondcolor  = imgui.ImFloat3(config_colors.hudsecond.r / 255, config_colors.hudsecond.g / 255, config_colors.hudsecond.b / 255)
        end
    end
    --��� ��� �� � �������
    if not doesFileExist("moonloader/config/Admin Tools/rangset.json") then
        local fr = io.open("moonloader/config/Admin Tools/rangset.json", "w")
        fr:write(encodeJson(frakrang))
        fr:close()
    else
        local fr = io.open("moonloader/config/Admin Tools/rangset.json", 'r')
        if fr then
            frakrang = decodeJson(fr:read('*a'))
            if frakrang.Gangs.max_8 == nil then

                frakrang.Gangs.max_8 = 25
                frakrang.Gangs.max_9 = 20

                frakrang.Mafia.max_8 = 14
                frakrang.Mafia.max_9 = 12

                frakrang.Bikers.max_5 = 3
                frakrang.Bikers.max_6 = 3
                frakrang.Bikers.max_7 = 3
                frakrang.Bikers.max_8 = 3
                
                saveData(frakrang, "moonloader/config/Admin Tools/rangset.json")

            end
        end
    end
    --�������� ������������� �����
    repeat wait(0) until isSampAvailable()
    libs()
    --�������� �� ��������
    if prcheck.pr == 3 then
        atext("�� ������� ��������� ��������. ��������� ���������� � ����������")
        thisScript():unload()
    else
        while #prcheck.prt == 0 do wait(0) end
        if checkIntable(prcheck.prt, sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))) then
            if sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) == "Sam_Teller" then
                sampAddChatMessage(" ����� {FFC0CB}</3 {FFFFFF}����� {FFC0CB}</3 {FFFFFF}����� {FFC0CB}</3 {FFFFFF}����� {FFC0CB}</3 {FFFFFF}����� {FFC0CB}</3", -1)
            else
                atext("��� ������ ���� ������� ������� \"{66FF00}/at{ffffff}\"")
            end
            local DWMAPI = ffi.load('dwmapi')
            DWMAPI.DwmEnableComposition(1)
        else
            atext("�������� �� ����������. ��� ��������� �������� �������� {66FF00}Thomas_Lawson{ffffff} � �� {66FF00}vk.com/tlwsn")
            thisScript():unload()
        end
    end

    -- ��������� ���-�����
    if cfg.killlist.startenable then killlistmode = 1 end
    
    --����������
    if #tostring(cfg.other.adminpass) >=6 and cfg.other.apassb then autoal() end
    
    --��������������
    if cfg.other.autoupdate then autoupdate("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/update.json", "https://evolve-rp.su/viewtopic.php?f=21&t=151439") end
    
    --��������� ��
    lua_thread.create(wh)

    --������������ ������� ������
    registerFastAnswer()

    --��������� ������ �������
    httpRequest("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/admins.txt", nil, function(response, code, headers, status) 
        if response then
            for line in response:gmatch('[^\r\n]+') do
                table.insert(adminslist, line)
            end
            print("������ ������� ��� ������� ��������")
            print(("������ �������:\n%s"):format(table.concat(adminslist, '\n')))
        else
            print("�� ������� ��������� ������ �������")
        end
    end)

    --������������ �������
    sampRegisterChatCommand("checkSklad", checkSklad)
    sampRegisterChatCommand("oncapt", oncapt)
    sampRegisterChatCommand("vkv", vkv)
    sampRegisterChatCommand("ranks", ranks)
    sampRegisterChatCommand("atp", function() tpwindow.v = not tpwindow.v end)
    sampRegisterChatCommand('mnarko', mnarko)
    sampRegisterChatCommand('mcbug', mcbug)
    sampRegisterChatCommand('checkb', checkB)
    sampRegisterChatCommand('aunv', aunv)
    sampRegisterChatCommand('gip', gip)
    sampRegisterChatCommand('ml', ml)
    sampRegisterChatCommand('veh',veh)
    sampRegisterChatCommand('vehs', vehs)
    sampRegisterChatCommand('hblist', hblist)
    sampRegisterChatCommand('getlvl', getlvl)
    sampRegisterChatCommand('punish', punish)
    sampRegisterChatCommand('arecon', arecon)
    sampRegisterChatCommand('guns', function() sampShowDialog(3435, '{ffffff}ID ������', '{ffffff}ID\t{ffffff}��������\n1\t������\n2\t������ ��� ������\n3\t����������� �������\n4\t���\n5\t����\n6\t������\n7\t���\n8\t������\n9\t���������\n10\t�����\n11\t�����\n12\t��������\n13\t��������\n14\t�����\n15\t������\n16\t�������\n17\t������� �������\n18\t�������� ��������\n22\t9mm ��������\n23\tSDPistol\n24\tDesert Eagle\n25\tShotgun\n26\t�����\n27\tCombat Shotgun\n28\tUZI\n29\tMP5\n30\tAK-47\n31\tM4\n32\tTec-9\n33\tCountry Rifle\n34\tSniper Rifle\n35\tRPG\n36\tHS Rocket\n37\t������\n38\t�������\n39\tSatchel Charge\n40\t���������\n41\tSpraycan\n42\t������������\n43\t�����������\n44\tNight Vis Goggles\n45\tThermal Goggles\n46\tParachute', 'x', _, 5) end)
    sampRegisterChatCommand('tg', function() sampSendChat('/togphone') end)
    sampRegisterChatCommand('blog', blog)
    sampRegisterChatCommand('masstp', masstp)
    sampRegisterChatCommand('masshb', masshb)
    sampRegisterChatCommand('givehb', givehb)
	sampRegisterChatCommand('addtemp', addtemp)
    sampRegisterChatCommand('deltemp', deltemp)
    sampRegisterChatCommand('deltempall', function() checker.temp.loaded = {} checker.temp.online = {} atext('��������� ����� ������') end)
    sampRegisterChatCommand('cip', cip)
    sampRegisterChatCommand('al', function() sampSendChat('/alogin') end)
    sampRegisterChatCommand('at_reload', function() showCursor(false); nameTagOn(); thisScript():reload() end)
    sampRegisterChatCommand('checkrangs', checkrangs)
    sampRegisterChatCommand('ocheckrangs', ocheckrangs)
    sampRegisterChatCommand('spiar', function() sampSendChat(('/o %s'):format(cfg.other.spiartext)) end)
    sampRegisterChatCommand('fonl', fonline)
    sampRegisterChatCommand('kills', kills)
    sampRegisterChatCommand('cbug', cbug)
    sampRegisterChatCommand('sbiv', sbiv)
    sampRegisterChatCommand('csbiv', csbiv)
	sampRegisterChatCommand('cheat', cheat)
    sampRegisterChatCommand('gs', gs)
    sampRegisterChatCommand('ags', ags)
    sampRegisterChatCommand('wlog', wl)
    sampRegisterChatCommand('gun', gun)
    sampRegisterChatCommand('at', function() mainwindow.v = not mainwindow.v end)
    sampRegisterChatCommand('addadm', addadm)
    sampRegisterChatCommand('tr', tr)
    sampRegisterChatCommand('addplayer', addplayer)
    sampRegisterChatCommand('delplayer', delplayer)
    sampRegisterChatCommand('deladm', deladm)
    
    --������� ������
    initializeRender()
    
    --��������� ����� ImGui
    apply_custom_style()
    
    --������������ �����
	for k, v in pairs(tBindList) do
        rkeys.registerHotKey(v.v, true, onHotKey)
        if v.time ~= nil then v.time = nil end
        if v.name == nil then v.name = "����"..k end
        v.text = v.text:gsub("%[enter%]", ""):gsub("{noenter}", "{noe}")
    end
    reportbind      = rkeys.registerHotKey(config_keys.reportkey.v, true, reportk)
    warningbind     = rkeys.registerHotKey(config_keys.warningkey.v, true, warningk)
    banipbind       = rkeys.registerHotKey(config_keys.banipkey.v, true, banipk)
    saveposbind     = rkeys.registerHotKey(config_keys.saveposkey.v, true, saveposk)
    goposbind       = rkeys.registerHotKey(config_keys.goposkey.v, true, goposk)
    cwarningbind    = rkeys.registerHotKey(config_keys.cwarningkey.v, true, cwarningk)
    punacceptbind   = rkeys.registerHotKey(config_keys.punaccept.v, true, punaccept)
    pundenybind     = rkeys.registerHotKey(config_keys.pundeny.v, true, pundeny)
    whbind          = rkeys.registerHotKey(config_keys.whkey.v, true, whkey)
    skeletwhbind    = rkeys.registerHotKey(config_keys.skeletwhkey.v, true, skeletwh)
    
    --���������� onWindowMessage
	addEventHandler("onWindowMessage", function (msg, wparam, lparam)
        if msg == wm.WM_KEYDOWN then
            if tEditData.id > -1 then
                if wparam == key.VK_ESCAPE then
                    tEditData.id = -1
                    consumeWindowMessage(true, true)
                end
            end
            if wparam == key.VK_ESCAPE then
                if mainwindow.v then mainwindow.v = false consumeWindowMessage(true, true) end
                if tpwindow.v then tpwindow.v = false consumeWindowMessage(true, true) end
            end
        end
    end)

    --������
    if cfg.cheat.autogm then funcsStatus.Inv = true end

    --������� ������
    lua_thread.create(upd_locals)
    lua_thread.create(upd_checker)
    lua_thread.create(clickF)
    lua_thread.create(renders)
    lua_thread.create(main_funcs)
    lua_thread.create(check_keys_fast)
    lua_thread.create(warningsKey)
    lua_thread.create(admchat)
    lua_thread.create(whon)

    --��������� ������ ��� �������
    loadUsers()

    --��������� �������� ��� ����
    requestAnimation("SWIM")
    requestAnimation("PARACHUTE")

    --���� ����
    while true do wait(0)

        --����������� �������
        if not recon.state then
            unlimBullets(oCheat.unlimBullets.v)
        else
            unlimBullets(false)
        end

        --aim
        if oCheat.aim.v then
            if isKeyDown(1) then
                local _, ped = storeClosestEntities(1)
                if ped ~= -1 then
                    local x, y, z = getCharCoordinates(ped)
                    TurnCamTo(x, y, z)
                end
            end
        end

        --Reset remove
        if mem.read(0x8E4CB4, 4, true) > 419430400 then cleanStreamMemoryBuffer() end
        --����� �� ������ ���������
        if punkey.delay ~= nil then
            if (os.time() - punkey.delay) > 20 then
                atext('����� ������ ��������� �������.')
                punkey = {warn = {}, ban = {}, prison = {}, re = {}, sban = {}, auninvite = {}, pspawn = {}, addabl = {}}
            end
        end
        --�������
        if swork then 
            if killlistmode == 1 or killlistmode == 2 then
                if isKillstatActive() then
                    enableKillList(false)
                end
            elseif killlistmode == 0 then 
                if not isKillstatActive() then
                    enableKillList(true) 
                end
            end 
        end
        --�� �� �����
        if not recon.state then
            local result, x, y, z = getTargetBlipCoordinatesFixed()
            if result and swork then
                setCharCoordinates(PLAYER_PED, x, y, z)
                removeWaypoint()
            end
        end
        --�������� �� ���� ���������
        for k, v in ipairs(wrecon) do
            if os.clock() > v["time"] then
                table.remove(wrecon, k)
            end
        end
        --���������� �� F12
        if wasKeyPressed(key.VK_F12) then swork = not swork 
            if not swork then
                nameTagOn()
                if killlistmode == 1 then enableKillList(true) end
                infRun(false)
            else
                nameTagOff()
                if killlistmode == 1 then enableKillList(false) end
                infRun(true)
            end
        end
        --���������� ����-����� �� F9
        if wasKeyPressed(key.VK_F9) then
            if killlistmode == 0 then
                enableKillList(false)
                killlistmode = 1
            elseif killlistmode == 1 then
                killlistmode = 2
            elseif killlistmode == 2 then
                enableKillList(true)
                killlistmode = 0
            end
        end
        --������ ������ ������
        if #tkills > 50 then table.remove(tkills, 1) end
        --������ ���������
        if cfg.other.trace then
            local oTime = os.time()
            if not isPauseMenuActive() then
                for i = 1, BulletSync.maxLines do
                    if BulletSync[i].enable == true and BulletSync[i].time >= oTime then
                        local scX, scY = getScreenResolution()

                        -----------------------------------����� ��������-----------------------------------

                        --[[local sx, sy, sz = convert3DCoordsToScreen(BulletSync[i].o.x, BulletSync[i].o.y, BulletSync[i].o.z)
                        local fx, fy, fz = convert3DCoordsToScreen(BulletSync[i].t.x, BulletSync[i].t.y, BulletSync[i].t.z)]]

                        --[[if sx < 0 then sx = scX end
                        if fx < 0 then fx = scX end
                        if sy < 0 then sy = scY end
                        if fy < 0 then fy = scY end]]
                        --if sz > -0.03125 and fz > -0.03125 then
                            --[[print(("%s / %s / %s / %s"):format(sx, sy, fx, fy))
                            renderDrawLine(sx, sy, fx, fy, 1, bulletTypes[BulletSync[i].tType])
                            renderDrawPolygon(fx, fy-1, 3, 3, 4.0, 10, bulletTypes[BulletSync[i].tType])]]
                        --end

                        ----------------------------------------------------------------------------------
                        
                        local sx, sy, sz = calcScreenCoors(BulletSync[i].o.x, BulletSync[i].o.y, BulletSync[i].o.z)
                        local fx, fy, fz = calcScreenCoors(BulletSync[i].t.x, BulletSync[i].t.y, BulletSync[i].t.z)
                        if sz > -0.03125 and fz > -0.03125 then
                            renderDrawLine(sx, sy, fx, fy, 1, bulletTypes[BulletSync[i].tType])
                            renderDrawPolygon(fx, fy-1, 3, 3, 4.0, 10, bulletTypes[BulletSync[i].tType])
                        end
                    end
                end
            end
        end
        --����� �������
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
        if data.imgui.killlist then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.killlist.posx = curX
            cfg.killlist.posy = curY
        end
        if data.imgui.leadercheckerpos then
            sampToggleCursor(true)
            local curX, curY = getCursorPos()
            cfg.leadersChecker.posx = curX
            cfg.leadersChecker.posy = curY
        end
        if isKeyJustPressed(key.VK_LBUTTON) and (data.imgui.admcheckpos or data.imgui.playercheckpos  or data.imgui.tempcheckpos or data.imgui.joinpos or data.imgui.quitpos or data.imgui.killlist or data.imgui.leadercheckerpos) then
            data.imgui.admcheckpos = false
            data.imgui.playercheckpos = false
            data.imgui.tempcheckpos = false
            data.imgui.joinpos = false
            data.imgui.quitpos = false
            data.imgui.killlist = false
            data.imgui.leadercheckerpos = false
            sampToggleCursor(false)
            mainwindow.v = true
            saveData(cfg, 'moonloader/config/Admin Tools/config.json')
        end
        imgui.Process = mainwindow.v or imrecon.v or tpwindow.v
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
        sampSendInteriorChange(interior)
    end
end

function imgui.CentrText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

function imgui.CustomButton(name, color, colorHovered, colorActive, size)
    local clr = imgui.Col
    imgui.PushStyleColor(clr.Button, color)
    imgui.PushStyleColor(clr.ButtonHovered, colorHovered)
    imgui.PushStyleColor(clr.ButtonActive, colorActive)
    if not size then size = imgui.ImVec2(0, 0) end
    local result = imgui.Button(name, size)
    imgui.PopStyleColor(3)
    return result
end

function imgui.TextColoredRGB(text)
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else imgui.TextWrapped(u8(w)) end
        end
    end

    render_text(text)
end

function rkeys.onHotKey(id, keys)
    if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() or isPauseMenuActive() then
        return false
    end
end

local teleports = {
    ["������������ �����"] = {
        {'���������� ��', 1154.2769775391, -1756.1109619141, 13.634266853333, 0},
        {'���������� ��', -1985.5826416016, 137.61878967285, 27.6875, 0},
        {'���������� ��', 2838.7587890625, 1291.5477294922, 11.390625, 0},
        {'��������', 2586.6628417969, 2788.6235351563, 10.8203125, 0},
        {'���������', 1577.3891601563, -1331.9245605469, 16.484375, 0},
        {'����� ����������� �����', 2356.6359863281, 2377.3544921875, 10.8203125, 0},
        {'������ 4 �������', 2030.9317626953, 1009.9556274414, 10.8203125, 0},
        {'������ ��������', 2177.9311523438, 1676.1583251953, 10.8203125, 0},
        {'�����������', 2196.3066, -1682.1842, 14.0373, 0}
    },
    ["���. �������"] = {
        {'LSPD', 1544.1212158203, -1675.3117675781, 13.557789802551, 0},
        {'SFPD', -1606.0246582031, 719.93884277344, 12.054424285889, 0},
        {'LVPD', 2333.9365234375, 2455.9772949219, 14.96875, 0},
        {'FBI', -2444.9887695313, 502.21490478516, 30.094774246216, 0},
        {'����� ��', -1335.8016357422, 471.39276123047, 7.1875, 0},
        {'����� ��', 209.3503112793, 1916.1086425781, 17.640625, 0},
        {'�����', 1478.6057128906, -1738.2475585938, 13.546875, 0},
        {'���������', -2032.9953613281, -84.548896789551, 35.82837677002, 0},
        {'������ ��', 1188.4862, -1323.5518, 13.5668, 0},
        {'������ ��', -2662.4634, 628.8812, 14.4531, 0},
        {'������ ��', 1608.7927, 1827.4063, 10.8203, 0},
        {'������ ��', -315.7561, 1060.4156, 19.7422, 0}
    },
    ["�����"] = {
        {'Rifa', 2184.4729003906, -1807.0772705078, 13.372615814209, 0},
        {'Grove', 2492.5004882813, -1675.2270507813, 13.335947036743, 0},
        {'Vagos', 2780.037109375, -1616.1085205078, 10.921875, 0},
        {'Ballas', 2645.5832519531, -2009.6373291016, 13.5546875, 0},
        {'Aztec', 1679.7568359375, -2112.7685546875, 13.546875, 0}
    },
    ["�����"] = {
        {'RM', 948.29113769531, 1732.6284179688, 8.8515625, 0},
        {'Yakuza', 1462.0941162109, 2773.9204101563, 10.8203125, 0},
        {'LCN', 1448.5999755859, 752.29913330078, 11.0234375, 0}
    },
    ["�������"] = {
        {'Los Santos News', 1658.7456054688, -1694.8518066406, 15.609375, 0},
        {'San Fierro News', -2047.3449707031, 462.86468505859, 35.171875, 0},
        {'Las Venturas News', 2647.6062011719, 1182.9040527344, 10.8203125, 0}
    },
    ["�������"] = {
        {'Warlocks MC', 657.96783447266, 1724.9599609375, 6.9921875, 0},
        {'Pagans MC', -236.41778564453, 2602.8095703125, 62.703125, 0},
        {'Mongols MC', 682.31365966797, -478.36148071289, 16.3359375, 0}
    },
    ["������"] = {
        {'����� 5+ ������', 2460.7641601563, 1339.7041015625, 10.8203125, 0},
        {'��������', 2191.8410644531, -2255.1296386719, 13.533205986023, 0},
        {'������� ��������', -2462.2663574219, 717.34100341797, 35.009593963623, 0},
        {'������� ��������� � ��', -87.400039672852, -1183.9016113281, 1.8439817428589, 0},
        {'������� ��������� � ��', -1915.9177246094, 286.88238525391, 41.046875, 0},
        {'������� ��������� � ��', 2131.244140625, 954.09143066406, 10.8203125, 0},
        {'����� ���������', -495.78558349609, -486.47967529297, 25.517845153809, 0},
        {'�������������', 2382.5662, 2752.3003, 10.8203, 0}
    }
}

function imadd.fHotKey(name, xuy1, xuy2, xyu3, xuy4)
    if imadd.HotKey("##"..name, xuy1, xuy2, xuy3) then
        rkeys.changeHotKey(xuy4, xuy1.v)
        saveData(config_keys, "moonloader/config/Admin Tools/keys.json")
    end
    imgui.SameLine()
    imgui.Text(u8(name))
end

function imgui.OnDrawFrame()
    imgui.ShowCursor = mainwindow.v
    local btn_size = imgui.ImVec2(-0.1, 0)
    local ir, ig, ib, ia = rainbow(1, 1)
    if tpwindow.v then
        imgui.ShowCursor = true
        imgui.SetNextWindowPos(imgui.ImVec2(screenx/2+400, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 'Admin Tools | ���������', tpwindow)

        for k, v in pairs(teleports) do
            if imgui.CollapsingHeader(u8(k)) then
                for k1, v1 in pairs(v) do
                    imgui.TeleportButton(v1[1], v1[2], v1[3], v1[4])
                end
            end
        end

        if imgui.CollapsingHeader(u8 '���������') then
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

        if imgui.CollapsingHeader(u8 '����������� �����') then
            for k, v in ipairs(tplist) do
                imgui.TeleportButton(v['text']..'##'..k, v['coords'][1], v['coords'][2], v['coords'][3], 0)
                if imgui.BeginPopupContextItem("##menu"..k) then
                    if imgui.Button(u8 '�������##'..k) then
                        table.remove(tplist, k)
                        saveData(tplist, "moonloader/config/Admin Tools/tplist.json")
                    end
                    if imgui.Button(u8 '�������������##'..k) then imgui.OpenPopup("##rename"..k) end
                    if imgui.BeginPopupModal('##rename'..k, _, imgui.WindowFlags.AlwaysAutoResize) then
                        imgui.InputText(u8 '������� ����� ��������', newtpname)
                        if imgui.Button(u8 '��������##'..k) then
                            v['text'] = u8:decode(newtpname.v)
                            newtpname.v = ''
                            saveData(tplist, "moonloader/config/Admin Tools/tplist.json")
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(u8 '������##'..k) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.EndPopup()
                    end
                    imgui.EndPopup()
                end
            end
            imgui.Separator()
            imgui.PushItemWidth(100)
            imgui.InputText(u8 '�������� ���������', tpname)
            imgui.PopItemWidth()
            imgui.PushItemWidth(150)
            imgui.InputInt3(u8 '���������� ���������', tpcoords, 0)
            imgui.SameLine()
            if imgui.Button(u8 '������� ����������') then
                local myx, myy, myz = getCharCoordinates(PLAYER_PED)
                tpcoords.v[1] = myx
                tpcoords.v[2] = myy
                tpcoords.v[3] = myz
            end
            imgui.PopItemWidth()
            if imgui.Button(u8 '��������##tp') then 
                tplist[#tplist + 1] = {text = u8:decode(tpname.v), coords = {tpcoords.v[1], tpcoords.v[2], tpcoords.v[3]}} 
                tpname.v = ''
                tpcoords.v[1], tpcoords.v[2], tpcoords.v[3] = 0,0,0
                saveData(tplist, "moonloader/config/Admin Tools/tplist.json")  end
        end

        imgui.End()
    end
    if imrecon.v or (data.imgui.menu == 7 and settingwindows.v and mainwindow.v) then
        local flags =  imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar
        if data.imgui.menu ~= 7 or not settingwindows.v or not mainwindow.v then
            flags = flags + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove
        end
        local ImVec4 = imgui.ImVec4
        local spacing, height = 140.0, 162.0
        imgui.SetNextWindowPos(imgui.ImVec2(cfg.recon.sPosX, cfg.recon.sPosY), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(cfg.recon.sSizeX, cfg.recon.sSizeY), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'������ �� �������', _, flags)
        imgui.SetWindowFontScale(cfg.recon.sFontSize)
        imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(8*cfg.recon.sCoff, 4*cfg.recon.sCoff))
        imgui.CentrText(('%s'):format(imtext.nick))
        imgui.CentrText(('ID: %s'):format(recon.id))
        if reafk then
            imgui.SameLine()
            imgui.TextColored(ImVec4(255, 0, 0, 1),'AFK')
        end
        imgui.Separator()
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Level:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.lvl))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Warns:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.warn))
        imgui.TextColored(ImVec4(255, 0, 0, 1), u8"Armour:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.arm))
        imgui.TextColored(ImVec4(255, 0, 0, 1), u8"Health:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.hp))
        imgui.TextColored(ImVec4(0, 49, 245, 1), u8"Car HP:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.carhp))
        imgui.TextColored(ImVec4(0, 49, 245, 1), u8"Speed:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.speed))
        imgui.TextColored(ImVec4(225, 0, 255, 1), u8"Ammo:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.ammo))
        imgui.TextColored(ImVec4(225, 0, 255, 1), u8"Shot:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.shot))
        imgui.TextColored(ImVec4(225, 0, 255, 1), u8"Time Shot:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.timeshot))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Engine:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.engine))
        imgui.TextColored(ImVec4(0, 255, 0, 1), u8"Pro Sport:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.prosport))
        imgui.TextColored(ImVec4(255, 255, 0, 1), u8"AFK Time:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.afktime))
        imgui.TextColored(ImVec4(255, 255, 0, 1), u8"Ping:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(imtext.ping))
        imgui.TextColored(ImVec4(255, 255, 0, 1), "Packet Loss:"); imgui.SameLine(spacing); imgui.Text(("%s"):format(imtext.packetloss))
        imgui.PopStyleVar()
        if data.imgui.menu == 7 then
            local wX, wY = imgui.GetWindowWidth(), imgui.GetWindowHeight()
            cfg.recon.sSizeX, cfg.recon.sSizeY = wX, wY
            local pos =  imgui.GetWindowPos()
            cfg.recon.sPosX, cfg.recon.sPosY = pos.x, pos.y
        end
        imgui.End()
        imgui.SetNextWindowPos(imgui.ImVec2(cfg.recon.fPosX, cfg.recon.fPosY), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(cfg.recon.fSizeX, cfg.recon.fSizeY), imgui.Cond.FirstUseEver)
        imgui.Begin(u8 '������1', _, flags)
        imgui.SetWindowFontScale(cfg.recon.fFontSize)
        local style = imgui.GetStyle()
        local colors = style.Colors
        local clr = imgui.Col
        local ImVec4 = imgui.ImVec4
        local rbtn_size = imgui.ImVec2(120, cfg.recon.bSize)
        local wS = imgui.GetWindowSize()
        if not sampIsDialogActive() and not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
            if wasKeyPressed(key.VK_S) or wasKeyPressed(key.VK_DOWN) then
                if not vars.bools.recon.isPopup then
                    vars.others.recon.select = vars.others.recon.select + 1
                    if vars.others.recon.select > #recon then vars.others.recon.select = 1 end
                else
                    vars.others.recon.selectPopup = vars.others.recon.selectPopup + 1
                    if vars.others.recon.selectPopup > vars.others.recon.popupCount then vars.others.recon.selectPopup = 1 end
                end
            end
            if wasKeyPressed(key.VK_W) or wasKeyPressed(key.VK_UP) then
                if not vars.bools.recon.isPopup then
                    vars.others.recon.select = vars.others.recon.select - 1
                    if vars.others.recon.select < 1 then vars.others.recon.select = #recon end
                else
                    vars.others.recon.selectPopup = vars.others.recon.selectPopup - 1
                    if vars.others.recon.selectPopup < 1 then vars.others.recon.selectPopup = vars.others.recon.popupCount end
                end
            end
            if wasKeyPressed(key.VK_SPACE) or wasKeyPressed(key.VK_RIGHT) or wasKeyPressed(key.VK_D) then
                if not vars.bools.recon.isPopup then
                    if type(recon[vars.others.recon.select].onclick) == 'function' then recon[vars.others.recon.select].onclick()
                    elseif type(recon[vars.others.recon.select].onclick) == 'table' then
                        vars.bools.recon.isPopup = true
                        vars.others.recon.popupCount = #recon[vars.others.recon.select].onclick
                        vars.others.recon.selectPopup = 1
                        imgui.OpenPopup("##check_recon"..vars.others.recon.select)
                    end
                else
                    recon[vars.others.recon.select].onclick[vars.others.recon.selectPopup].onclick()
                end
            end
            if wasKeyPressed(key.VK_LEFT) or wasKeyPressed(key.VK_A) then
                if vars.bools.recon.isPopup then
                    local select = vars.others.recon.select
                    vars.others.recon.select = 1
                    vars.others.recon.select = select
                    vars.bools.recon.isPopup = false
                end
            end
        end
        imgui.PushStyleVar(imgui.StyleVar.ItemSpacing, imgui.ImVec2(8 * cfg.recon.fCoff, 4 * cfg.recon.fCoff))
        for k, v in ipairs(recon) do
            if k == vars.others.recon.select then bColor = colors[clr.ButtonActive] else bColor = colors[clr.Button] end
            imgui.CustomButton(v.name.."##"..k, bColor, colors[clr.ButtonHovered], colors[clr.ButtonActive], rbtn_size)
            imgui.SetNextWindowPos(imgui.ImVec2(cfg.recon.fPosX + 150, cfg.recon.fPosY))
            if imgui.BeginPopup('##check_recon'..vars.others.recon.select) then
                if vars.others.recon.select == k then
                    for k1, v1 in pairs(v.onclick) do
                        if k1 == vars.others.recon.selectPopup then pColor = colors[clr.ButtonActive] else pColor = colors[clr.Button] end
                        imgui.CustomButton(v1.name.."##"..k1, pColor, colors[clr.ButtonHovered], colors[clr.ButtonActive], imgui.ImVec2(100, cfg.recon.bSize)) --��� ��� ��� ��, ��� ������ ��� ������������
                    end
                    if not vars.bools.recon.isPopup then imgui.CloseCurrentPopup() end
                end
                imgui.EndPopup()
            else
                vars.bools.recon.isPopup = false
            end
        end
        imgui.PopStyleVar()
        if data.imgui.menu == 7 then
            local wX, wY = imgui.GetWindowWidth(), imgui.GetWindowHeight()
            local pos =  imgui.GetWindowPos()
            cfg.recon.fSizeX, cfg.recon.fSizeY = wX, wY
            cfg.recon.fPosX, cfg.recon.fPosY = pos.x, pos.y
        end
        imgui.End()
    end
    if mainwindow.v then
        imgui.SetNextWindowSize(imgui.ImVec2(310, 300), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(u8(('Admin Tools | ������� ���� | ������ %s'):format(thisScript().version)), mainwindow, imgui.WindowFlags.NoResize)
        if imgui.Button(u8 '���������', btn_size) then settingwindows.v = not settingwindows.v end
        if imgui.Button(u8 '���������', btn_size) then tpwindow.v = not tpwindow.v end
        if imgui.Button(u8 '������� �������', btn_size) then cmdwindow.v = not cmdwindow.v end
        --if imgui.Button(u8 '�����������', btn_size) then imgui.OpenPopup('##1') mpwindow.v = not mpwindow.v end
        if imgui.Button(u8 '������', btn_size) then leadwindow.v = not leadwindow.v end
        if imgui.Button(u8 '������', btn_size) then bMainWindow.v = not bMainWindow.v end
        if imgui.Button(u8 "������ ����", btn_size) then oCheat.wind.v = not oCheat.wind.v end
        if imgui.Button(u8 "�������� ������", btn_size) then checkerEdit.window.v = not checkerEdit.window.v end
        --if imgui.Button(u8 '������ ����', btn_size) then tunwindow.v = not tunwindow.v end
        imgui.End()

        if checkerEdit.window.v then
            imgui.SetNextWindowSize(imgui.ImVec2(780, 522), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8 "�������� ������", checkerEdit.window)
            imgui.BeginChild("##selectchecker", imgui.ImVec2(750, 60), true)
            if imgui.Button(u8 "����� �������", imgui.ImVec2(355, 30)) then checkerEdit.select = 1 end
            imgui.SameLine()
            if imgui.Button(u8 "����� �������", imgui.ImVec2(355, 30)) then checkerEdit.select = 2 end
            imgui.EndChild()
            imgui.BeginChild("editchecker", imgui.ImVec2(750, 400), true)
            if checkerEdit.select ~= 0 then
                imgui.BeginChild("##select player", imgui.ImVec2(200, 370), true)
                if checkerEdit.select == 1 then --�������� ����� �������
                    for k, v in pairs(checker.admins.loaded) do
                        if imgui.Selectable(u8(("%s##adm%s"):format(v["nick"], k)), checkerEdit.admins.list == k) then 
                            checkerEdit.admins.list         = k
                            checkerEdit.admins.nick.v       = u8(tostring(v["nick"]))
                            checkerEdit.admins.color.v      = tostring(v["color"])
                            checkerEdit.admins.desc.v       = u8(tostring(v["text"]))
                            local a, r, g, b                = explode_argb(tonumber("0x"..checkerEdit.admins.color.v))
                            checkerEdit.admins.ImColor      = imgui.ImFloat3(r / 255, g / 255, b / 255)
                        end
                    end
                    imgui.Separator()
                    if imgui.Button(u8 "��������", btn_size) then
                        checkerEdit.admins.ImColor = imgui.ImFloat3(1, 1, 1)
                        checkerEdit.admins.list     = 0
                        checkerEdit.admins.nick.v   = ""
                        checkerEdit.admins.color.v  = "FFFFFF"
                        checkerEdit.admins.desc.v   = ""
                        imgui.OpenPopup(u8 "�������� ������##1") end --�������� ������ � �����
                    if imgui.BeginPopupModal(u8 "�������� ������##1", _, imgui.WindowFlags.NoResize) then
                        imgui.InputText(u8 "������� ���##addadm", checkerEdit.admins.nick)
                        imgui.InputText(u8 "������� ����##addadm", checkerEdit.admins.color)
                        imgui.InputText(u8 "������� ��������##addadm", checkerEdit.admins.desc)
                        if imgui.ColorEdit3(u8 "����##addadm", checkerEdit.admins.ImColor) then
                            local hex = bit.tohex(ARGBtoRGB(join_argb(255, checkerEdit.admins.ImColor.v[1] * 255, checkerEdit.admins.ImColor.v[2] * 255, checkerEdit.admins.ImColor.v[3] * 255)))
                            checkerEdit.admins.color.v = tostring(hex:match("^00(.+)")):upper()
                        end
                        if imgui.Button(u8 "���������##addadm", imgui.ImVec2(233.5, 30)) then
                            if not isHex(checkerEdit.admins.color.v) then checkerEdit.admins.color.v = "FFFFFF" end
                            table.insert(checker.admins.loaded, {nick = checkerEdit.admins.nick.v, color = checkerEdit.admins.color.v, text = u8:decode(checkerEdit.admins.desc.v)})
                            saveData(checker.admins.loaded, 'moonloader/config/Admin Tools/admchecker.json')
                            rebuildUsers()
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(u8 "������", imgui.ImVec2(233.5, 30)) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.EndPopup()
                    end
                elseif checkerEdit.select == 2 then --�������� ����� �������
                    for k, v in pairs(checker.players.loaded) do
                        if imgui.Selectable(u8(("%s##players%s"):format(v["nick"], k)), checkerEdit.players.list == k) then 
                            checkerEdit.players.list         = k
                            checkerEdit.players.nick.v       = u8(tostring(v["nick"]))
                            checkerEdit.players.color.v      = tostring(v["color"])
                            checkerEdit.players.desc.v       = u8(tostring(v["text"]))
                            local a, r, g, b                 = explode_argb(tonumber("0x"..checkerEdit.players.color.v))
                            checkerEdit.players.ImColor      = imgui.ImFloat3(r / 255, g / 255, b / 255)
                        end
                    end
                    imgui.Separator()
                    if imgui.Button(u8 "��������##2", btn_size) then 
                        checkerEdit.players.ImColor = imgui.ImFloat3(1, 1, 1)
                        checkerEdit.players.list     = 0
                        checkerEdit.players.nick.v   = ""
                        checkerEdit.players.color.v  = "FFFFFF"
                        checkerEdit.players.desc.v   = ""
                        imgui.OpenPopup(u8 "�������� ������##2") end --�������� ������ � �����
                    if imgui.BeginPopupModal(u8 "�������� ������##2", _, imgui.WindowFlags.NoResize) then
                        imgui.InputText(u8 "������� ���##addp", checkerEdit.players.nick)
                        imgui.InputText(u8 "������� ����##addp", checkerEdit.players.color)
                        imgui.InputText(u8 "������� ��������##addp", checkerEdit.players.desc)
                        if imgui.ColorEdit3(u8 "����##addp", checkerEdit.players.ImColor) then
                            local hex = bit.tohex(ARGBtoRGB(join_argb(255, checkerEdit.players.ImColor.v[1] * 255, checkerEdit.players.ImColor.v[2] * 255, checkerEdit.players.ImColor.v[3] * 255)))
                            checkerEdit.players.color.v = tostring(hex:match("^00(.+)")):upper()
                        end
                        if imgui.Button(u8 "���������##addp", imgui.ImVec2(233.5, 30)) then
                            if not isHex(checkerEdit.players.color.v) then checkerEdit.players.color.v = "FFFFFF" end
                            table.insert(checker.players.loaded, {nick = checkerEdit.players.nick.v, color = checkerEdit.players.color.v, text = u8:decode(checkerEdit.players.desc.v)})
                            saveData(checker.players.loaded, 'moonloader/config/Admin Tools/playerchecker.json')
                            rebuildUsers()
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if imgui.Button(u8 "������", imgui.ImVec2(233.5, 30)) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.EndPopup()
                    end
                end
                imgui.EndChild()
                imgui.SameLine()
                imgui.BeginChild("##edit player", imgui.ImVec2(507, 370), true)
                if checkerEdit.select == 1 then
                    for k, v in pairs(checker.admins.loaded) do
                        if checkerEdit.admins.list == k then
                            imgui.InputText(u8 "������� ���##editadm", checkerEdit.admins.nick)
                            imgui.InputText(u8 "������� ����##editadm", checkerEdit.admins.color)
                            imgui.InputText(u8 "������� ��������##editadm", checkerEdit.admins.desc)
                            if imgui.ColorEdit3(u8 "����##1", checkerEdit.admins.ImColor) then
                                local hex = bit.tohex(ARGBtoRGB(join_argb(255, checkerEdit.admins.ImColor.v[1] * 255, checkerEdit.admins.ImColor.v[2] * 255, checkerEdit.admins.ImColor.v[3] * 255)))
                                checkerEdit.admins.color.v = tostring(hex:match("^00(.+)")):upper()
                            end
                            if imgui.Button(u8 "��������� ������##editadm", imgui.ImVec2(233.5, 30)) then
                                if not isHex(checkerEdit.admins.color.v) then checkerEdit.admins.color.v = "FFFFFF" end
                                v["nick"]   = u8:decode(checkerEdit.admins.nick.v)
                                v["color"]  = checkerEdit.admins.color.v
                                v["text"]   = u8:decode(checkerEdit.admins.desc.v)
                                saveData(checker.admins.loaded, 'moonloader/config/Admin Tools/admchecker.json')
                                rebuildUsers()
                            end
                            imgui.SameLine()
                            if imgui.Button(u8 "������� ������##k##editadm", imgui.ImVec2(233.5, 30)) then imgui.OpenPopup(u8 "������� ������##"..k) end
                            if imgui.BeginPopupModal(u8 "������� ������##"..k, _, imgui.WindowFlags.NoResize) then
                                imgui.CentrText(u8 "�� ������������� ������ ������� ������ �� ������")
                                if imgui.Button(u8 "�������##check####editadm"..k, imgui.ImVec2(233.5, 30)) then
                                    table.remove(checker.admins.loaded, k)
                                    saveData(checker.admins.loaded, 'moonloader/config/Admin Tools/admchecker.json')
                                    checkerEdit.admins.list     = 0
                                    checkerEdit.admins.nick.v   = ""
                                    checkerEdit.admins.color.v  = ""
                                    checkerEdit.admins.desc.v   = ""
                                    rebuildUsers()
                                    imgui.CloseCurrentPopup()
                                end
                                imgui.SameLine()
                                if imgui.Button(u8 "������", imgui.ImVec2(233.5, 30)) then
                                    imgui.CloseCurrentPopup()
                                end
                                imgui.EndPopup()
                            end
                        end
                    end
                elseif checkerEdit.select == 2 then
                    for k, v in pairs(checker.players.loaded) do
                        if checkerEdit.players.list == k then
                            imgui.InputText(u8 "������� ���##editp", checkerEdit.players.nick)
                            imgui.InputText(u8 "������� ����##editp", checkerEdit.players.color)
                            imgui.InputText(u8 "������� ��������##editp", checkerEdit.players.desc)
                            if imgui.ColorEdit3(u8 "����##2", checkerEdit.players.ImColor) then
                                local hex = bit.tohex(ARGBtoRGB(join_argb(255, checkerEdit.players.ImColor.v[1] * 255, checkerEdit.players.ImColor.v[2] * 255, checkerEdit.players.ImColor.v[3] * 255)))
                                checkerEdit.players.color.v = tostring(hex:match("^00(.+)")):upper()
                            end
                            if imgui.Button(u8 "��������� ������##editp", imgui.ImVec2(233.5, 30)) then
                                if not isHex(checkerEdit.players.color.v) then checkerEdit.players.color.v = "FFFFFF" end
                                v["nick"]   = u8:decode(checkerEdit.players.nick.v)
                                v["color"]  = checkerEdit.players.color.v
                                v["text"]   = u8:decode(checkerEdit.players.desc.v)
                                saveData(checker.players.loaded, 'moonloader/config/Admin Tools/playerchecker.json')
                                rebuildUsers()
                            end
                            imgui.SameLine()
                            if imgui.Button(u8 "������� ������##k##editp", imgui.ImVec2(233.5, 30)) then imgui.OpenPopup(u8 "������� ������##"..k) end
                            if imgui.BeginPopupModal(u8 "������� ������##"..k, _, imgui.WindowFlags.NoResize) then
                                imgui.CentrText(u8 "�� ������������� ������ ������� ������ �� ������")
                                if imgui.Button(u8 "�������##check##"..k, imgui.ImVec2(233.5, 30)) then
                                    table.remove(checker.players.loaded, k)
                                    saveData(checker.players.loaded, 'moonloader/config/Admin Tools/playerchecker.json')
                                    checkerEdit.players.list     = 0
                                    checkerEdit.players.nick.v   = ""
                                    checkerEdit.players.color.v  = ""
                                    checkerEdit.players.desc.v   = ""
                                    rebuildUsers()
                                    imgui.CloseCurrentPopup()
                                end
                                imgui.SameLine()
                                if imgui.Button(u8 "������", imgui.ImVec2(233.5, 30)) then
                                    imgui.CloseCurrentPopup()
                                end
                                imgui.EndPopup()
                            end
                        end
                    end
                end
                imgui.End()
            end
            imgui.EndChild()
            imgui.End()
        end
        if oCheat.wind.v then
            imgui.SetNextWindowSize(imgui.ImVec2(220, 300), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2-300, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8 "Admin Tools | ������ ����", oCheat.wind)
            if imgui.Checkbox(u8 "Extra WS", oCheat.extra) then
                cameraRestorePatch(oCheat.extra.v)
            end
            if imgui.Checkbox(u8 "No spread", oCheat.spread) then
                noRecoilDynamicCrosshair(oCheat.spread.v)
            end
            imgui.Checkbox(u8 "No reload", oCheat.unlimBullets)
            imgui.Checkbox("Aim", oCheat.aim)
            imgui.End()
        end
        if leadwindow.v then
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
            imgui.Begin(u8 'Admin Tools | ������', leadwindow)
            for k,v in pairs(checker.leaders.loaded) do
                local leadbuff = imgui.ImBuffer(checker.leaders.loaded[k], 256)
                imgui.Text(u8(k))
                imgui.SameLine(200)
                imgui.PushItemWidth(270)
                if imgui.InputText(u8 '##��� ������'..k, leadbuff) then
                    if #leadbuff.v > 0 then
                        checker.leaders.loaded[k] = leadbuff.v
                        local id = sampGetPlayerIdByNickname(leadbuff.v)
                        if id ~= nil then
                            table.insert(checker.leaders.online, {nick = leadbuff.v, id = id, frak = k})
                        end
                    else
                        checker.leaders.loaded[k] = '-'
                    end
                    saveData(checker.leaders.loaded, 'moonloader/config/Admin Tools/leaders.json')
                    rebuildUsers()
                end
            end
            imgui.End()
        end
        if tunwindow.v then
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2+350, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(300, 300), imgui.Cond.FirstUseEver)
            imgui.Begin(u8 'Admin Tools | ������ ����', tunwindow)
            if isCharInAnyCar(PLAYER_PED) then
                local carh = storeCarCharIsInNoSave(PLAYER_PED)
                local result, carid = sampGetVehicleIdByCarHandle(carh)
                if result then
                    if getDriverOfCar(carh) == PLAYER_PED then
                        imgui.PushItemWidth(100)
                        if imgui.InputInt(u8 '���� 1', mcolorb) then
                            changeCarColour(carh, mcolorb.v, pcolorb.v) 
                        end
                        if imgui.InputInt(u8 '���� 2', pcolorb) then 
                            changeCarColour(carh, mcolorb.v, pcolorb.v) 
                        end
                        imgui.PopItemWidth()
                    else
                        imgui.TextWrapped(u8 '�� ������ ���������� �� ����� ����������')
                    end
                end
            else
                imgui.TextWrapped(u8 '�� ������ ���������� � ����������')
            end
            imgui.End()
        end
        if mpwindow.v then
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.SetNextWindowSize(imgui.ImVec2(500, 300), imgui.Cond.FirstUseEver)
            imgui.Begin(u8 'Admin Tools | �����������', mpwindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
            imgui.Checkbox(u8 '����� ��', mpend)
            imgui.Separator()
            if not mpend.v then
                imgui.InputText(u8 '�������� �����������', mpname)
                imgui.InputText(u8 '�������� �����������', mpsponsors)
                imgui.Text(u8'�����:')
                imgui.Separator()
                imgui.TextWrapped((u8'�������� �� �� "%s" + � SMS. ����� �� ����� ��������'):format(mpname.v))
            else
                imgui.InputText(u8 '���������� �����������', mpwinner)
                imgui.InputText(u8 '�������� �����������', mpsponsors)
                imgui.Text(u8'�����:')
                imgui.Separator()
                imgui.TextWrapped((u8'���������� �� "%s" - %s'):format(mpname.v, mpwinner.v))
                imgui.TextWrapped((u8'��������: %s'):format(mpsponsors.v))
            end
            if imgui.Button(u8 '�������� � /o') then
                lua_thread.create(function()
                    if mpend.v then
                        sampSendChat(('/o ���������� �� "%s" - %s'):format(u8:decode(mpname.v), u8:decode(mpwinner.v)))
                        wait(cfg.other.delay)
                        sampSendChat(('/o ��������: %s'):format(u8:decode(mpsponsors.v)))
                    else
                        sampSendChat((('/o �������� �� �� "%s" + � SMS. ����� �� ����� ��������'):format(u8:decode(mpname.v))))
                    end
                end)
            end
            imgui.SameLine()
            if imgui.Button(u8 '�������� ����') then
                mpname.v = ''
                mpwinner.v = ''
                mpsponsors.v = ''
            end
            imgui.End()
        end
        if cmdwindow.v then
            imgui.SetNextWindowSize(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8'Admin Tools | �������', cmdwindow)
            if imgui.CollapsingHeader('/at_reload', btn_size) then
                imgui.TextWrapped(u8 '��������: ������������� ������')
                imgui.TextWrapped(u8 '�������������: /at_reload')
            end
            if imgui.CollapsingHeader('/al', btn_size) then
                imgui.TextWrapped(u8 '��������: ���������� ������� /alogin')
                imgui.TextWrapped(u8 '�������������: /al')
            end
            if imgui.CollapsingHeader('/arecon', btn_size) then
                imgui.TextWrapped(u8 '��������: ���������������� � �������')
                imgui.TextWrapped(u8 '�������������: /arecon')
            end
            if imgui.CollapsingHeader('/tg', btn_size) then
                imgui.TextWrapped(u8 '��������: ���������� ������� /togphone')
                imgui.TextWrapped(u8 '�������������: /tg')
            end
            if imgui.CollapsingHeader('/spiar', btn_size) then
                imgui.TextWrapped(u8 '��������: �������� ���� /ask � /o ���')
                imgui.TextWrapped(u8 '�������������: /spiar')
            end
            if imgui.CollapsingHeader('/getlvl', btn_size) then
                imgui.TextWrapped(u8 '��������: ������ ���� ������� � ������������ ������� �� �������')
                imgui.TextWrapped(u8 '�������������: /getlvl [�������]')
            end
            if imgui.CollapsingHeader('/cip', btn_size) then
                imgui.TextWrapped(u8 '��������: �������� IP ������')
                imgui.TextWrapped(u8 '�������������: /cip')
            end
            if imgui.CollapsingHeader('/fonl', btn_size) then
                imgui.TextWrapped(u8 '��������: ������ ���-�� ����� ������ �� �������')
                imgui.TextWrapped(u8 '�������������: /fonl [id �������]')
            end
            if imgui.CollapsingHeader('/checkrangs', btn_size) then
                imgui.TextWrapped(u8 '��������: ��������� ������� �� ������������ LVL - ����')
                imgui.TextWrapped(u8 '�������������: /checkrangs [id �������]')
            end
            if imgui.CollapsingHeader('/ocheckrangs', btn_size) then
                imgui.TextWrapped(u8 '��������: ��������� /offmembers ������� �� ������� ������')
                imgui.TextWrapped(u8 '�������������: /ocheckrangs [id �������]')
            end
            if imgui.CollapsingHeader('/gs', btn_size) then
                imgui.TextWrapped(u8 '��������: ���������� ������� /getstats.\n� ������ ����� �� �� ���������, ����� �������� ���������� ������, �� ������� ������')
                imgui.TextWrapped(u8 '�������������: /gs [id]')
            end
            if imgui.CollapsingHeader('/ags', btn_size) then
                imgui.TextWrapped(u8 '��������: ���������� ������� /agetstats\n� ������ ����� �� �� ���������, ����� �������� ���������� ������, �� ������� ������')
                imgui.TextWrapped(u8 '�������������: /ags [id/nick]')
            end
            if imgui.CollapsingHeader('/sbiv', btn_size) then
                imgui.TextWrapped(u8 ('��������: �������� ������ �� %s ����� � �������� �� ������� "���� ��������".'):format(cfg.timers.sbivtimer))
                imgui.TextWrapped(u8 '�������������: /sbiv [id]')
            end
            if imgui.CollapsingHeader('/csbiv', btn_size) then
                imgui.TextWrapped(u8 ('��������: �������� ������ �� %s ����� � �������� �� ������� "���� ��������".'):format(cfg.timers.csbivtimer))
                imgui.TextWrapped(u8 '�������������: /csbiv [id]')
            end
            if imgui.CollapsingHeader('/cbug', btn_size) then
                imgui.TextWrapped(u8 ('��������: �������� ������ �� %s ����� � �������� �� ������� "+� ��� �����".'):format(cfg.timers.cbugtimer))
                imgui.TextWrapped(u8 '�������������: /cbug [id]')
            end
            if imgui.CollapsingHeader('/mnarko', btn_size) then
                imgui.TextWrapped(u8 ('��������: �������� ������ � �� ����� �� %s ���� �� ������� "��������� � �����"'):format(cfg.timers.mnarkotimer))
                imgui.TextWrapped(u8 '�������������: /mnarko [id]')
            end
            if imgui.CollapsingHeader('/mcbug', btn_size) then
                imgui.TextWrapped(u8 ('��������: �������� ������ � �� ����� �� %s ��� �� ������� "��� ��������"'):format(cfg.timers.mcbugtimer))
                imgui.TextWrapped(u8 '�������������: /mcbug [id]')
            end
            if imgui.CollapsingHeader('/vkv', btn_size) then
                imgui.TextWrapped(u8 ('��������: �������� ������ �� %s ����� �� ������� "����� ��� ��������"'):format(cfg.timers.vkvtimer))
                imgui.TextWrapped(u8 '�������������: /vkv [id]')
            end
			if imgui.CollapsingHeader('/cheat', btn_size) then
                imgui.TextWrapped(u8 '��������: ��������(1 �������) / ���������(2+ ������) �� ������� "cheat"\n� ������ ����� �� �� ���������, ����� ������� ������, �� ������� ������')
                imgui.TextWrapped(u8 '�������������: /cheat [id]')
            end
            if imgui.CollapsingHeader('/kills', btn_size) then
                imgui.TextWrapped(u8 '��������: ������ 50 ��������� ������� �� ����-�����')
                imgui.TextWrapped(u8 '�������������: /kills')
            end
            if imgui.CollapsingHeader('/guns', btn_size) then
                imgui.TextWrapped(u8 '��������: ������� ������ � ID ������')
                imgui.TextWrapped(u8 '�������������: /guns')
            end
            if imgui.CollapsingHeader('/vehs', btn_size) then
                imgui.TextWrapped(u8 '��������: ������� ������ � ID ����� / ������ ID ������ �� �� ��������')
                imgui.TextWrapped(u8 '�������������: /vehs [��������]')
            end
            if imgui.CollapsingHeader('/wlog', btn_size) then
                imgui.TextWrapped(u8 '��������: ���������� ������� /warnlog')
                imgui.TextWrapped(u8 '�������������: /wlog [id/nick]')
            end
            if imgui.CollapsingHeader('/blog', btn_size) then
                imgui.TextWrapped(u8 '��������: ���������� ������� /banlog')
                imgui.TextWrapped(u8 '�������������: /blog [id/nick]')
            end
            if imgui.CollapsingHeader('/tr', btn_size) then
                imgui.TextWrapped(u8 '��������: ����������� �������� �� ������������� ������')
                imgui.TextWrapped(u8 '�������������: /tr [id/-1]')
            end
            if imgui.CollapsingHeader('/ml', btn_size) then
                imgui.TextWrapped(u8 '��������: ������ ������� ������')
                imgui.TextWrapped(u8 '�������������: /ml [id] [id �������(�� �����������)]')
            end
            if imgui.CollapsingHeader('/addadm', btn_size) then
                imgui.TextWrapped(u8 '��������: �������� ������ � ����� �������')
                imgui.TextWrapped(u8 '�������������: /addadm [id/nick]')
            end
            if imgui.CollapsingHeader('/addplayer', btn_size) then
                imgui.TextWrapped(u8 '��������: �������� ������ � ����� �������')
                imgui.TextWrapped(u8 '�������������: /addplayer [id/nick]')
            end
			if imgui.CollapsingHeader('/addtemp', btn_size) then
                imgui.TextWrapped(u8 '��������: �������� ������ � ��������� �����')
                imgui.TextWrapped(u8 '�������������: /addtemp [id/nick]')
            end
            if imgui.CollapsingHeader('/deladm', btn_size) then
                imgui.TextWrapped(u8 '��������: ������� ������ �� ������ �������')
                imgui.TextWrapped(u8 '�������������: /deladm [id/nick]')
            end
            if imgui.CollapsingHeader('/delplayer', btn_size) then
                imgui.TextWrapped(u8 '��������: ������� ������ �� ������ �������')
                imgui.TextWrapped(u8 '�������������: /delplayer [id/nick]')
            end
			if imgui.CollapsingHeader('/deltemp', btn_size) then
                imgui.TextWrapped(u8 '��������: ������� ������ �� ���������� ������')
                imgui.TextWrapped(u8 '�������������: /deltemp [id/nick]')
            end
            if imgui.CollapsingHeader('/deltempall', btn_size) then
                imgui.TextWrapped(u8 '��������: ������� ���� ������� �� ���������� ������')
                imgui.TextWrapped(u8 '�������������: /deltempall')
            end
            if imgui.CollapsingHeader('/masstp', btn_size) then
                imgui.TextWrapped(u8 '��������: ������ / �������� ������������ �� ���')
                imgui.TextWrapped(u8 '�������������: /masstp')
            end
            if imgui.CollapsingHeader('/masshb', btn_size) then
                imgui.TextWrapped(u8 '��������: ������ �������� �������� ������� � ���� ������')
                imgui.TextWrapped(u8 '�������������: /masshb [��� ���������]')
            end
            if imgui.CollapsingHeader('/hblist', btn_size) then
                imgui.TextWrapped(u8 '��������: ������ ������ ���������� � ��������� (��������� ��������� �� ���� moonloader/Admin Tools/hblist)')
                imgui.TextWrapped(u8 '�������������: /hblist')
            end
            if imgui.CollapsingHeader('/givehb', btn_size) then
                imgui.TextWrapped(u8 '��������: ������ �������� �������� ������')
                imgui.TextWrapped(u8 '�������������: /givehb [id] [��� ���������]')
            end
            if imgui.CollapsingHeader('/punish', btn_size) then
                imgui.TextWrapped(u8 '��������: ������ ��������� �� ������� �� ������, ������������ ��������� �������')
                imgui.TextWrapped(u8 '�������������: /punish')
            end
            if imgui.CollapsingHeader('/gip', btn_size) then
                imgui.TextWrapped(u8 '��������: ���������� ������� /getip (���� ����� ������) /agetip (���� ����� �������) ')
                imgui.TextWrapped(u8 '�������������: /gip [id/nick]')
            end
            if imgui.CollapsingHeader('/aunv', btn_size) then
                imgui.TextWrapped(u8 '��������: ���������� ������� /auninvite')
                imgui.TextWrapped(u8 '�������������: /aunv [id] [�������]')
            end
            if imgui.CollapsingHeader('/checkb', btn_size) then
                imgui.TextWrapped(u8 '��������: ��������� �������� �� ����� �� ���������� (���� ��������� �� ���� moonloader/Admin Tools/Check Banned/players.txt)')
                imgui.TextWrapped(u8 '�������������: /checkb')
            end
            if imgui.CollapsingHeader('/atp', btn_size) then
                imgui.TextWrapped(u8 '��������: ������� ���� ���������')
                imgui.TextWrapped(u8 '�������������: /atp')
            end
            if imgui.CollapsingHeader('/ranks', btn_size) then
                imgui.TextWrapped(u8 '��������: ������ ����� �� �������')
                imgui.TextWrapped(u8 '�������������: /ranks [�������]')
            end
            if imgui.CollapsingHeader('/oncapt', btn_size) then
                imgui.TextWrapped(u8 '��������: ������ / ���������� ������ ���������� � �����')
                imgui.TextWrapped(u8 '�������������: /oncapt')
            end
            if imgui.CollapsingHeader("/checksklad") then
                imgui.TextWrapped(u8 "������ ������� �� ������ � ����")
                imgui.TextWrapped(u8 '�������������: /checksklad')
            end
            imgui.End()
        end
        if settingwindows.v then
            imgui.SetNextWindowPos(imgui.ImVec2(screenx / 2, screeny / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(15,6))
            imgui.Begin(u8 'Admin Tools | ���������', settingwindows, imgui.WindowFlags.NoResize)
            imgui.BeginChild('##set', imgui.ImVec2(200, 400), true)
            if imgui.Selectable(u8 '��������� ������', data.imgui.menu == 1 ) then data.imgui.menu = 1 end
            if imgui.Selectable(u8 '��������� �����', data.imgui.menu == 2) then data.imgui.menu = 2 end
            if data.imgui.menu == 2 then
                if imgui.Selectable(u8 '  AirBrake', data.imgui.cheat == 1) then data.imgui.cheat = 1 end
                if imgui.Selectable(u8 '  GodMode', data.imgui.cheat == 2) then data.imgui.cheat = 2 end
                if imgui.Selectable(u8 '  WallHack', data.imgui.cheat == 3) then data.imgui.cheat = 3 end
            end
            if imgui.Selectable(u8 '��������� �������', data.imgui.menu == 3) then data.imgui.menu = 3 end
            if data.imgui.menu == 3 then
                if imgui.Selectable(u8 '  ����� �������', data.imgui.checker == 1) then data.imgui.checker = 1 end
                if imgui.Selectable(u8 '  ����� �������', data.imgui.checker == 2) then data.imgui.checker = 2 end
                if imgui.Selectable(u8 '  ��������� �����', data.imgui.checker == 3) then data.imgui.checker = 3 end
                if imgui.Selectable(u8 '  ����� �������', data.imgui.checker == 4) then data.imgui.checker = 4 end
            end
            if imgui.Selectable(u8 '��������� ������ ���������', data.imgui.menu == 4) then data.imgui.menu = 4 end
            if imgui.Selectable(u8 '��������� ������', data.imgui.menu == 6) then data.imgui.menu = 6 end
            if imgui.Selectable(u8 '��������� ������', data.imgui.menu == 7) then data.imgui.menu = 7 end
			if imgui.Selectable(u8 '��������� ���������', data.imgui.menu == 5) then data.imgui.menu = 5 end
            imgui.EndChild()
            imgui.SameLine()
            imgui.BeginChild('##set1', imgui.ImVec2(840, 400), true)
            if data.imgui.menu == 1 then

                imadd.fHotKey("������� �������� �� ��������� ���������", config_keys.warningkey, tLastKeys, 100, warningbind)
                imadd.fHotKey('������� �������� �� ���������� ���������', config_keys.cwarningkey, tLastKeys, 100, cwarningbind)
                imadd.fHotKey('������� �������� �� �������', config_keys.reportkey, tLastKeys, 100, reportbind)
                imadd.fHotKey('������� ���� IP ������', config_keys.banipkey, tLastKeys, 100, banipbind)
                imadd.fHotKey('������� ���������� ���������', config_keys.saveposkey, tLastKeys, 100, saveposbind)
                imadd.fHotKey('������� ��������� �� ����������� ����������', config_keys.goposkey, tLastKeys, 100, goposbind)
            
            elseif data.imgui.menu == 2 then
                if data.imgui.cheat == 1 then

                    imgui.CentrText(u8 'AirBrake')
                    imgui.Separator()

                    if imgui.SliderFloat(u8 '��������� ��������', imset.cheat.airspeed, 0.05, 10, '%0.2f') then cfg.cheat.airbrkspeed = imset.cheat.airspeed.v saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                    
                    imgui.TextWrapped(u8 '��������� �������� - ��� �� ��������, ������� ����� ������ ��� ��������� AirBrake. ���� �������� ����� �������� �� ����� ������ ��������� ������(��������� ��������) ��� ����� ����(��������� ���������)')
                
                elseif data.imgui.cheat == 2 then

                    imgui.CentrText(u8 'GodMode')
                    imgui.Separator()

                    if imadd.ToggleButton(u8 '�������� ���##11', imset.cheat.gm) then cfg.cheat.autogm = imset.cheat.gm.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '������������� �������� �� ��� ����� � ����')
                elseif data.imgui.cheat == 3 then

                    imgui.CentrText(u8 'WallHack')
                    imgui.Separator()

                    if imadd.ToggleButton(u8 '�� �� ��������', imset.cheat.skeletwh) then cfg.other.skeletwh = imset.cheat.skeletwh.v saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '�� �� ��������')
                    
                    imadd.fHotKey('�������� / ��������� ��', config_keys.whkey, tLastKeys, 100, whbind)
                    imadd.fHotKey('�������� / ��������� �� �� ��������', config_keys.skeletwhkey, tLastKeys, 100, skeletwhbind)

                    if imgui.InputText(u8 '�����##wh', imset.cheat.whfont) then cfg.other.whfont = imset.cheat.whfont.v whfont = renderCreateFont(cfg.other.whfont, cfg.other.whsize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                    if imgui.InputInt(u8 '������ ������##wh', imset.cheat.whsize, 0) then cfg.other.whsize = imset.cheat.whsize.v whfont = renderCreateFont(cfg.other.whfont, cfg.other.whsize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                end
            
            elseif data.imgui.menu == 3 then

                if data.imgui.checker == 1 then

                    imgui.CentrText(u8 '����� �������')
                    imgui.Separator()

                    if imadd.ToggleButton(u8 '�������� �����##1', imset.checkers.admcheck) then cfg.admchecker.enable = imset.checkers.admcheck.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '�������� �����')
                    
                    if cfg.admchecker.enable then
                        imgui.Text(u8 '�������������� ������')
                        imgui.SameLine()
                        if imgui.Button(u8 '��������##1') then data.imgui.admcheckpos = true; mainwindow.v = false end
                    end

                elseif data.imgui.checker == 2 then

                    imgui.CentrText(u8 '����� �������')
                    imgui.Separator()

                    if imadd.ToggleButton(u8 '�������� �����##2', imset.checkers.playercheck) then cfg.playerChecker.enable = imset.checkers.playercheck.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '�������� �����')
                    
                    if cfg.playerChecker.enable then
                        imgui.Text(u8 '�������������� ������')
                        imgui.SameLine()
                        if imgui.Button(u8 '��������##2') then data.imgui.playercheckpos = true; mainwindow.v = false end
                    end

                elseif data.imgui.checker == 3 then

                    imgui.CentrText(u8 '��������� �����')
					imgui.Separator()
                    
                    if imadd.ToggleButton(u8 '�������� �����##3', imset.checkers.tempcheck) then cfg.tempChecker.enable = imset.checkers.tempcheck.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '�������� �����')
                    
                    if cfg.tempChecker.enable then
                        imgui.Text(u8 '�������������� ������')
                        imgui.SameLine()
                        if imgui.Button(u8 '��������##3') then data.imgui.tempcheckpos = true; mainwindow.v = false end
                        if imadd.ToggleButton(u8 '��������� � ����� ������� �� ��������', imset.checkers.tempwarning) then cfg.tempChecker.wadd = imset.checkers.tempwarning.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '��������� � ����� ������� �� ��������')
                    end

                elseif data.imgui.checker == 4 then

                    imgui.CentrText(u8 '����� �������')
                    imgui.Separator()

                    if imadd.ToggleButton(u8 '�������� �����##4', imset.checkers.leadcheck) then cfg.leadersChecker.enable = imset.checkers.leadcheck.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '�������� �����')
                    
                    if cfg.leadersChecker.enable then
                        imgui.Text(u8 '�������������� ������')
                        imgui.SameLine()
                        if imgui.Button(u8 '��������##2') then data.imgui.leadercheckerpos = true; mainwindow.v = false end
                        if imadd.ToggleButton(u8 '���� ����', imset.checkers.colornick) then cfg.leadersChecker.cvetnick = imset.checkers.colornick.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '���� ���� � ���� �������')
                    end
                end

                imgui.Separator()

                if imgui.InputText(u8 '�����', imset.checkers.checkfont) then cfg.other.checkfont = imset.checkers.checkfont.v checkfont = renderCreateFont(cfg.other.checkfont, cfg.other.checksize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 '������ ������', imset.checkers.checksize, 0) then cfg.other.checksize = imset.checkers.checksize.v; checkfont = renderCreateFont(cfg.other.checkfont, cfg.other.checksize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
            
            elseif data.imgui.menu == 4 then

				imgui.CentrText(u8 '��������� ������ ���������')
                imgui.Separator()

                imadd.fHotKey('������� ������ ��������� �� ������� � /a', config_keys.punaccept, tLastKeys, 100, punacceptbind)
                imadd.fHotKey('������� ������ ������ ��������� �� ������� � /a', config_keys.pundeny, tLastKeys, 100, pundenybind)

				if imgui.InputInt(u8 '������ ����� (/sbiv)', imset.timers.sbiv, 0) then cfg.timers.sbivtimer = imset.timers.sbiv.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
				if imgui.InputInt(u8 '������ ���� ����� (/csbiv)', imset.timers.csbiv, 0) then cfg.timers.csbivtimer = cimset.timers.sbiv.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 '������ +C ��� ����� (/cbug)', imset.timers.cbug, 0) then cfg.timers.cbugtimer = imset.timers.cbug.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 '������ ���������� � ����� [���] (/mnarko)', imset.timers.mnarko, 0) then cfg.timers.mnarkotimer = imset.timers.mnarko.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 '������ ��� �������� [���] (/mcbug)', imset.timers.mcbug, 0) then cfg.timers.mcbugtimer = imset.timers.mcbug.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 '������ ����� ��� �������� (/vkv)', imset.timers.vkv, 0) then cfg.timers.vkvtimer = imset.timers.vkv.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
            
            elseif data.imgui.menu == 5 then

				imgui.CentrText(u8 '���������')
                imgui.Separator()

                if imgui.InputText(u8 "����� ����� ��������� [/spiar] (����� /o)", imset.set.spiar) then cfg.other.spiartext = u8:decode(imset.set.spiar.v) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end

                if imadd.ToggleButton(u8 "chatid", imset.set.chatid) then cfg.other.chatid = imset.set.chatid.v saveData(cfg, 'moonloader/config/Admin Tools/config.json') end imgui.SameLine() imgui.Text(u8 "�������� / ��������� ID ������� � ����")
                if imadd.ToggleButton(u8 "��������", imset.set.trace) then cfg.other.trace = imset.set.trace.v saveData(cfg, 'moonloader/config/Admin Tools/config.json') end imgui.SameLine() imgui.Text(u8 "�������� / ��������� ��������")
				if imadd.ToggleButton(u8 'reconw##1', imset.set.recon) then cfg.other.reconw = imset.set.recon.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '�������� �� ���� ���������')
				if imadd.ToggleButton(u8 '���������##11', imset.set.pass) then cfg.other.passb = imset.set.pass.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '���������')
                if imadd.ToggleButton(u8 '����������##11', imset.set.apass) then cfg.other.apassb = imset.set.apass.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '����������')
                if imadd.ToggleButton(u8 '������ � �������##11', imset.set.sfchat) then cfg.other.chatconsole = imset.set.sfchat.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '������ � �������')
                if imadd.ToggleButton(u8 'joinquit##11', imset.set.joinquit) then cfg.joinquit.enable = imset.set.joinquit.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '��� �������������/������������� �������')
                if imadd.ToggleButton(u8 'autoupd##11', imset.set.autoupd) then cfg.other.autoupdate = imset.set.autoupd.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '�������������� �������')
                if imadd.ToggleButton(u8 'resend##11', imset.set.resend) then cfg.other.resend = imset.set.resend.v saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '������ "�����" ��� �������� � ����� �� �������')
                if imadd.ToggleButton(u8 'killlist##11', imset.set.killist) then cfg.killlist.startenable = imset.set.killist.v end; imgui.SameLine(); imgui.Text(u8 '���������� ���-���� ��� ����� � ����')
                if imadd.ToggleButton(u8 'socrpm', imset.set.socrpm) then cfg.other.socrpm = imset.set.socrpm.v
                    if cfg.other.socrpm then
                        registerFastAnswer()
                    else
                        for line in io.lines('moonloader/config/Admin Tools/fa.txt') do
                            local cmd, text = line:match('(.+) = (.+)')
                            if cmd and text then
                                if sampIsChatCommandDefined(cmd) then sampUnregisterChatCommand(cmd) end
                            end
                        end
                    end
                    saveData(cfg, 'moonloader/config/Admin Tools/config.json') 
                end
                imgui.SameLine(); imgui.Text(u8 '���������� ������� �� ������ (��������� � ���� moonloader/config/Admin Tools/fa.txt ������� = �����)')
                
                if imgui.InputInt(u8 '��������� ��������', imset.set.delay, 0) then cfg.other.delay = imset.set.delay.v saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                
                if imgui.Button(u8 '�������� ��������') then 
                    lua_thread.create(function()
                        for i = 1, 7 do
                            sampSendChat(("/do ���� ��������: %s [%s/7]"):format(cfg.other.delay, i))
                            wait(cfg.other.delay)
                        end
                    end)
                end
                if imgui.InputText(u8 '����� ���-�����##hud', imset.set.killfont) then cfg.other.killfont = imset.set.killfont.v killfont = renderCreateFont(cfg.other.killfont, cfg.other.killsize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                
                if imgui.InputInt(u8 '������ ������ ���-�����##hud', imset.set.killsize, 0) then 
                    lua_thread.create(function()
                        cfg.other.killsize = imset.set.killsize.v 
                        killfont = renderCreateFont(cfg.other.killfont, cfg.other.killsize, 4)
                        if fonts_loaded then
                            fonts_loaded = false
                            font_gtaweapon3.vtbl.Release(font_gtaweapon3)
                        end 
                        while renderGetFontDrawHeight(killfont) == 0 do wait(0) end
                        font_gtaweapon3 = d3dxfont_create('gtaweapon3', cfg.other.killsize*1.35, 4)
                        fonts_loaded = true
                        saveData(cfg, 'moonloader/config/Admin Tools/config.json')
                    end)
                end
                
                if imgui.Button(u8 '�������� �������������� ���-�����') then data.imgui.killlist = true mainwindow.v = false end
                
                if imset.set.joinquit.v then 
                    if imgui.Button(u8'�������� �������������� ��������������##1') then data.imgui.joinpos = true; mainwindow.v = false end
                    imgui.SameLine()
                    if imgui.Button(u8'�������� �������������� �������������##1') then data.imgui.quitpos = true; mainwindow.v = false end
                end
                
                if imset.set.pass.v then
					if imgui.InputText(u8 '������� ��� ������', imset.set.passbuff, imgui.InputTextFlags.Password) then cfg.other.password = u8:decode(imset.set.passbuff.v) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
					if imgui.Button(u8 '������ ������##1') then atext('��� ������: {66FF00}'..cfg.other.password) end
				end
                
                if imset.set.apass.v then
					if imgui.InputText(u8 '������� ��� ��������� ������', imset.set.apassbuff, imgui.InputTextFlags.Password) then cfg.other.adminpass = u8:decode(imset.set.apassbuff.v) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
					if imgui.Button(u8 '������ ������##2') then atext('��� ��������� ������: {66FF00}'..cfg.other.adminpass) end
                end
                
                if imgui.RadioButton(u8 "����� ������ ������: "..1, cfg.other.style == 1) then cfg.other.style = 1 saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                imgui.SameLine()
                if imgui.RadioButton(u8 "����� ������ ������: "..2, cfg.other.style == 2) then cfg.other.style = 2 saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                imgui.SameLine()
                if imgui.RadioButton(u8 "����� ������ ������: "..3, cfg.other.style == 3) then cfg.other.style = 3 saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                
                if imgui.InputText(u8 '����� ������ ������##hud', imset.set.hudfont) then cfg.other.hudfont = imset.set.hudfont.v hudfont = renderCreateFont(cfg.other.hudfont, cfg.other.hudsize, 4) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
                if imgui.InputInt(u8 '������ ������ ������ ������##hud', imset.set.hudsize, 0) then 
                    cfg.other.hudsize = imset.set.hudsize.v 
                    hudfont = renderCreateFont(cfg.other.hudfont, cfg.other.hudsize, 4)
                    saveData(cfg, 'moonloader/config/Admin Tools/config.json') 
                end

            elseif data.imgui.menu == 6 then
                imgui.CentrText(u8 '��������� ������')
                imgui.Separator()
                if imgui.ColorEdit3(u8 '����� ���', acolor) then
                    config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b = acolor.v[1] * 255, acolor.v[2] * 255, acolor.v[3] * 255
                    config_colors.admchat.color = ARGBtoRGB(join_argb(255, acolor.v[1] * 255, acolor.v[2] * 255, acolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 '������ ������##1') then sampAddChatMessage(" <ADM-CHAT> Thomas_Lawson [0]: Test", join_argb(255, config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b)) end
                if imgui.ColorEdit3(u8 '������� ���', scolor) then
                    config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b = scolor.v[1] * 255, scolor.v[2] * 255, scolor.v[3] * 255
                    config_colors.supchat.color = ARGBtoRGB(join_argb(255, scolor.v[1] * 255, scolor.v[2] * 255, scolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 '������ ������##2') then sampAddChatMessage(" <SUPPORT-CHAT> Thomas_Lawson [0]: Test", join_argb(255, config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b)) end
                if imgui.ColorEdit3(u8 'SMS', smscolor) then
                    config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b = smscolor.v[1] * 255, smscolor.v[2] * 255, smscolor.v[3] * 255
                    config_colors.smschat.color = ARGBtoRGB(join_argb(255, smscolor.v[1] * 255, smscolor.v[2] * 255, smscolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 '������ ������##3') then sampAddChatMessage(" SMS: Test. �����������: Thomas_Lawson[0]", join_argb(255, config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b)) end
                if imgui.ColorEdit3(u8 '������', jbcolor) then
                    config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b = jbcolor.v[1] * 255, jbcolor.v[2] * 255, jbcolor.v[3] * 255
                    config_colors.jbchat.color = ARGBtoRGB(join_argb(255, jbcolor.v[1] * 255, jbcolor.v[2] * 255, jbcolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 '������ ������##4') then sampAddChatMessage(" ������ �� Thomas_Lawson[0] �� Thomas_Lawson[0]: Test", join_argb(255, config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b)) end
                if imgui.ColorEdit3(u8 '������', repcolor) then
                    config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b = repcolor.v[1] * 255, repcolor.v[2] * 255, repcolor.v[3] * 255
                    config_colors.repchat.color =ARGBtoRGB(join_argb(255, repcolor.v[1] * 255, repcolor.v[2] * 255, repcolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 '������ ������##5') then sampAddChatMessage(" ������ �� Thomas_Lawson[0]: Test", join_argb(255, config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b)) end
                if imgui.ColorEdit3(u8 '������', askcolor) then
                    config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b = askcolor.v[1] * 255, askcolor.v[2] * 255, askcolor.v[3] * 255
                    config_colors.askchat.color = ARGBtoRGB(join_argb(255, askcolor.v[1] * 255, askcolor.v[2] * 255, askcolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 '������ ������##6') then sampAddChatMessage(" ->������ Thomas_Lawson[0]: Test", join_argb(255, config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b)) end
                if imgui.ColorEdit3(u8 '�����', anscolor) then
                    config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b = anscolor.v[1] * 255, anscolor.v[2] * 255, anscolor.v[3] * 255
                    config_colors.anschat.color = ARGBtoRGB(join_argb(255, anscolor.v[1] * 255, anscolor.v[2] * 255, anscolor.v[3] * 255))
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                imgui.SameLine(650)
                if imgui.Button(u8 '������ ������##7') then sampAddChatMessage(" ����� �� Thomas_Lawson[0] � Thomas_Lawson[0]: Test", join_argb(255, config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b)) end
                if imgui.ColorEdit3(u8 '��������� � ������ (��������)', trhitcolor) then
                    config_colors.tracehit.r, config_colors.tracehit.g, config_colors.tracehit.b = trhitcolor.v[1] * 255, trhitcolor.v[2] * 255, trhitcolor.v[3] * 255
                    config_colors.tracehit.color = join_argb(255, trhitcolor.v[1] * 255, trhitcolor.v[2] * 255, trhitcolor.v[3] * 255)
                    bulletTypes = {
                        [0] = config_colors.tracemiss.color,
                        [1] = config_colors.tracehit.color,
                        [2] = config_colors.tracemiss.color,
                        [3] = config_colors.tracemiss.color,
                        [4] = config_colors.tracemiss.color,
                        [5] = 0xFF00FF00
                    }
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.ColorEdit3(u8 '������ (��������)', trmisscolor) then
                    config_colors.tracemiss.r, config_colors.tracemiss.g, config_colors.tracemiss.b = trmisscolor.v[1] * 255, trmisscolor.v[2] * 255, trmisscolor.v[3] * 255
                    config_colors.tracemiss.color = join_argb(255, trmisscolor.v[1] * 255, trmisscolor.v[2] * 255, trmisscolor.v[3] * 255)
                    bulletTypes = {
                        [0] = config_colors.tracemiss.color,
                        [1] = config_colors.tracehit.color,
                        [2] = config_colors.tracemiss.color,
                        [3] = config_colors.tracemiss.color,
                        [4] = config_colors.tracemiss.color,
                        [5] = 0xFF00FF00
                    }
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.ColorEdit3(u8 "���� ������� ����� ������ ������", hudmaincolor) then
                    config_colors.hudmain.r, config_colors.hudmain.g, config_colors.hudmain.b = hudmaincolor.v[1] * 255, hudmaincolor.v[2] * 255, hudmaincolor.v[3] * 255
                    config_colors.hudmain.color = join_argb(255, hudmaincolor.v[1] * 255, hudmaincolor.v[2] * 255, hudmaincolor.v[3] * 255)
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.ColorEdit3(u8 "���� ������� ����� ������ ������", hudsecondcolor) then
                    config_colors.hudsecond.r, config_colors.hudsecond.g, config_colors.hudsecond.b = hudsecondcolor.v[1] * 255, hudsecondcolor.v[2] * 255, hudsecondcolor.v[3] * 255
                    config_colors.hudsecond.color = join_argb(255, hudsecondcolor.v[1] * 255, hudsecondcolor.v[2] * 255, hudsecondcolor.v[3] * 255)
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
                if imgui.Button(u8 '�������� �����') then
                    config_colors = {
                        admchat = {r = 255, g = 255, b = 0, color = 16776960},
                        supchat = {r = 0, g = 255, b = 153, color = 65433},
                        smschat = {r = 255, g = 255, b = 0, color = 16776960},
                        repchat = {r = 217, g = 119, b = 0, color = 14251776},
                        anschat = {r = 140, g = 255, b = 155, color = 9240475},
                        askchat = {r = 233, g = 165, b = 40, color = 15312168},
                        jbchat = {r = 217, g = 119, b = 0, color = 14251776},
                        tracemiss = {r = 0, g = 0, b = 255, color = -16776961},
                        tracehit = {r = 255, g = 0, b = 0, color = -65536},
                        hudmain = {r = 255, g = 255, b = 255, color = -1},
                        hudsecond = {r= 0, g = 255, b = 0, color = -16711936}
                    }

                    acolor          = imgui.ImFloat3(config_colors.admchat.r / 255, config_colors.admchat.g / 255, config_colors.admchat.b / 255)
                    scolor          = imgui.ImFloat3(config_colors.supchat.r / 255, config_colors.supchat.g / 255, config_colors.supchat.b / 255)
                    smscolor        = imgui.ImFloat3(config_colors.smschat.r / 255, config_colors.smschat.g / 255, config_colors.smschat.b / 255)
                    jbcolor         = imgui.ImFloat3(config_colors.jbchat.r / 255, config_colors.jbchat.g / 255, config_colors.jbchat.b / 255)
                    askcolor        = imgui.ImFloat3(config_colors.askchat.r / 255, config_colors.askchat.g / 255, config_colors.askchat.b / 255)
                    repcolor        = imgui.ImFloat3(config_colors.repchat.r / 255, config_colors.repchat.g / 255, config_colors.repchat.b / 255)
                    anscolor        = imgui.ImFloat3(config_colors.anschat.r / 255, config_colors.anschat.g / 255, config_colors.anschat.b / 255)
                    trhitcolor      = imgui.ImFloat3(config_colors.tracehit.r / 255, config_colors.tracehit.g / 255, config_colors.tracehit.b / 255)
                    trmisscolor     = imgui.ImFloat3(config_colors.tracemiss.r / 255, config_colors.tracemiss.g / 255, config_colors.tracemiss.b / 255)
                    hudmaincolor    = imgui.ImFloat3(config_colors.hudmain.r / 255, config_colors.hudmain.g / 255, config_colors.hudmain.b / 255)
                    hudsecondcolor  = imgui.ImFloat3(config_colors.hudsecond.r / 255, config_colors.hudsecond.g / 255, config_colors.hudsecond.b / 255)

                    bulletTypes = {
                        [0] = config_colors.tracemiss.color,
                        [1] = config_colors.tracehit.color,
                        [2] = config_colors.tracemiss.color,
                        [3] = config_colors.tracemiss.color,
                        [4] = config_colors.tracemiss.color,
                        [5] = 0xFF00FF00
                    }
                    saveData(config_colors, "moonloader/config/Admin Tools/colors.json")
                end
            elseif data.imgui.menu == 7 then

                imgui.CentrText(u8 "��������� ������")
                imgui.Separator()

                if imadd.ToggleButton(u8 '�������� ���������� �����##1', imset.recon.enable) then cfg.recon.enable = imset.recon.enable.v; saveData(cfg, 'moonloader/config/Admin Tools/config.json') end; imgui.SameLine(); imgui.Text(u8 '�������� ���������� �����')
                
                if imgui.SliderFloat(u8 "������ ������", imset.recon.scoff, 0.01, 2) then cfg.recon.sCoff = imset.recon.scoff.v end
                if imgui.SliderFloat(u8 "������ ������ ����� ��������", imset.recon.fcoff, 0.01, 2) then cfg.recon.fCoff = imset.recon.fcoff.v end
                if imgui.SliderFloat(u8 "������ ������", imset.recon.bsize, 5, 30) then cfg.recon.bSize = imset.recon.bsize.v end
                if imgui.SliderFloat(u8 "������ ������ ����� ������", imset.recon.fsize, 0, 5) then cfg.recon.fFontSize = imset.recon.fsize.v end
                if imgui.SliderFloat(u8 "������ ������ ������ ������", imset.recon.ssize, 0, 5) then cfg.recon.sFontSize = imset.recon.ssize.v end
                
                if imgui.Button(u8 "��������� ���������##recon") then
                    saveData(cfg, 'moonloader/config/Admin Tools/config.json')
                end

            end

            imgui.EndChild()
            imgui.End()

        end
		if bMainWindow.v then
			imgui.ShowCursor = true
			local iScreenWidth, iScreenHeight = getScreenResolution()
			imgui.SetNextWindowPos(imgui.ImVec2(iScreenWidth / 2, iScreenHeight / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(1000, 530), imgui.Cond.FirstUseEver)
			imgui.Begin(u8("Admin Tools | ������##main"), bMainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			imgui.BeginChild("##bindlist", imgui.ImVec2(995, 442))
            for k, v in ipairs(tBindList) do
                if imadd.HotKey("##HK" .. k, v, tLastKeys, 100) then
                    if not rkeys.isHotKeyDefined(v.v) then
                        if rkeys.isHotKeyDefined(tLastKeys.v) then
                            rkeys.unRegisterHotKey(tLastKeys.v)
                        end
                        rkeys.registerHotKey(v.v, true, onHotKey)
                    end
                    saveData(tBindList, "moonloader/config/Admin Tools/binder.json")
                end
                imgui.SameLine()
                imgui.CentrText(u8(v.name))
                imgui.SameLine(850)
                imgui.SetCursorPosX(imgui.GetWindowWidth() - 150 - (imgui.GetStyle().ItemSpacing.x)*2)
                if imgui.Button(u8 '������������� ����##'..k) then imgui.OpenPopup(u8 "�������������� �������##editbind"..k) 
                    bindname.v = u8(v.name) 
                    bindtext.v = u8(v.text)
                end
                if imgui.BeginPopupModal(u8 '�������������� �������##editbind'..k, _, imgui.WindowFlags.NoResize) then
                    imgui.Text(u8 "������� �������� �������:")
                    imgui.InputText("##������� �������� �������", bindname)
                    imgui.Text(u8 "������� ����� �������:")
                    imgui.InputTextMultiline("##������� ����� �������", bindtext, imgui.ImVec2(500, 200))
                    imgui.Separator()
                    if imgui.Button(u8 '�����', imgui.ImVec2(90, 25)) then imgui.OpenPopup('##bindkey') end
                    if imgui.BeginPopup('##bindkey') then
                        imgui.Text(u8 '����������� ����� ������� ��� ����� �������� ������������� �������')
                        imgui.Separator()
                        imgui.Text(u8 '{f6} - ��������� ��������� � ��� ����� �������� ���� (������������ � ����� ������)')
                        imgui.Text(u8 '{noe} - �������� ��������� � ����� ����� � �� ���������� ��� � ��� (������������ � ����� ������)')
                        imgui.Text(u8 '{wait:sek} - �������� ����� ��������, ��� sek - ���-�� �����������. ������: {wait:2000} - �������� 2 �������. (������������ �������� �� ����� �������)')
                        imgui.Text(u8 '{screen} - ������� �������� ������ (������������ �������� �� ����� �������)')
                        imgui.EndPopup()
                    end
                    imgui.SameLine()
                    imgui.SetCursorPosX((imgui.GetWindowWidth() - 90 - imgui.GetStyle().ItemSpacing.x))
                    if imgui.Button(u8 "������� ����##"..k, imgui.ImVec2(90, 25)) then
                        table.remove(tBindList, k)
                        saveData(tBindList, "moonloader/config/Admin Tools/binder.json")
                        imgui.CloseCurrentPopup()
                    end
                    imgui.SameLine()
                    imgui.SetCursorPosX((imgui.GetWindowWidth() - 180 + imgui.GetStyle().ItemSpacing.x) / 2)
                    if imgui.Button(u8 "���������##"..k, imgui.ImVec2(90, 25)) then
                        v.name = u8:decode(bindname.v)
                        v.text = u8:decode(bindtext.v)
                        bindname.v = ''
                        bindtext.v = ''
                        saveData(tBindList, "moonloader/config/Admin Tools/binder.json")
                        imgui.CloseCurrentPopup()
                    end
                    imgui.SameLine()
                    if imgui.Button(u8 "�������##"..k, imgui.ImVec2(90, 25)) then imgui.CloseCurrentPopup() end
                    imgui.EndPopup()
                end
            end
            imgui.EndChild()
            imgui.Separator()
            if imgui.Button(u8"�������� �������") then
                tBindList[#tBindList + 1] = {text = "", v = {}, time = 0, name = "����"..#tBindList + 1}
                saveData(tBindList, "moonloader/config/Admin Tools/binder.json")
            end
		imgui.End()
		end
    end
end

function onHotKey(id, keys)
    lua_thread.create(function()
        local sKeys = tostring(table.concat(keys, " "))
        for k, v in pairs(tBindList) do
            if sKeys == tostring(table.concat(v.v, " ")) then
                local tostr = tostring(v.text)
                if tostr:len() > 0 then
                    for line in tostr:gmatch('[^\r\n]+') do
                        if line:match("^{wait%:%d+}$") then
                            wait(line:match("^%{wait%:(%d+)}$"))
                        elseif line:match("^{screen}$") then
                            screen()
                        else
                            local bIsEnter = string.match(line, "^{noe}(.+)") ~= nil
                            local bIsF6 = string.match(line, "^{f6}(.+)") ~= nil
                            if not bIsEnter then
                                if bIsF6 then
                                    sampProcessChatInput(line:gsub("{f6}", ""))
                                else
                                    sampSendChat(line)
                                end
                            else
                                sampSetChatInputText(line:gsub("{noe}", ""))
                                sampSetChatInputEnabled(true)
                            end
                        end
                    end
                end
            end
        end
    end)
end

function isHex(str)
    local str = tostring(str):upper()
    if #str ~= 6 then return false end
    for i = 1, #str do
        if str:byte(i) < 48 or str:byte(i) > 70 or (str:byte(i) < 65 and str:byte(i) > 57) then
            return false
        end
    end
    return true
end

function fps_correction()
	return representIntAsFloat(readMemory(0xB7CB5C, 4, false))
end

function initializeRender()
    gunfont = renderCreateFont(getGameDirectory()..'\\gtaweap3.ttf', cfg.other.hudsize, 4)
    whfont = renderCreateFont(cfg.other.whfont, cfg.other.whsize, 4)
	checkfont = renderCreateFont(cfg.other.checkfont, cfg.other.checksize, 4)
    hudfont = renderCreateFont(cfg.other.hudfont, cfg.other.hudsize, 4)
    killfont = renderCreateFont(cfg.other.killfont, cfg.other.killsize, 4)
    lua_thread.create(function()
        while renderGetFontDrawHeight(killfont) == 0 do wait(0) end
        font_gtaweapon3 = d3dxfont_create('gtaweapon3', cfg.other.killsize*1.35, 4)
        fonts_loaded = true
    end)
end
--clickwarp
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
        return nil
    else
        return 0
    end
end

function jumpIntoCar(car)
    local seat = getCarFreeSeat(car)
    if not seat then return false end                     
    if seat == 0 then warpCharIntoCar(playerPed, car)         
    else warpCharIntoCarAsPassenger(playerPed, car, seat - 1) 
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
            writeMemory(posPtr + 0, 4, representFloatAsInt(x), false)
            writeMemory(posPtr + 4, 4, representFloatAsInt(y), false)
            writeMemory(posPtr + 8, 4, representFloatAsInt(z), false)
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
                if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
                    local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
                    local camX, camY, camZ = getActiveCameraCoordinates()
                    local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
                    if result and colpoint.entity ~= 0 then
                        local normal = colpoint.normal
                        local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
                        local zOffset = 300
                        if normal[3] >= 0.5 then zOffset = 1 end
                            local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
                                true, true, false, true, false, false, false)
                            if result then
                                pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)
                                local curX, curY, curZ  = getCharCoordinates(playerPed)
                                local dist              = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
                                local hoffs             = renderGetFontDrawHeight(hudfont)
                                sy = sy - 2
                                sx = sx - 2
                                if colpoint.entityType ~= 2 then renderFontDrawText(hudfont, string.format("%0.2fm", dist), sx, sy - hoffs, 0xEEEEEEEE) end
                                local tpIntoCar = nil
                                if colpoint.entityType == 2 then
                                    local car = getVehiclePointerHandle(colpoint.entity)
                                    if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
                                        local carx, cary, carz = getCarCoordinates(car)
                                        local scarx, scary = convert3DCoordsToScreen(carx, cary, carz)
                                        renderFontDrawText(hudfont,'TP: '..tCarsName[getCarModel(car)-399],scarx, scary, 0xEEEEEEEE)
                                        --displayVehicleName(sx, sy - hoffs * 2, getNameOfVehicleModel(getCarModel(car)))
                                        local color = 0xAAFFFFFF
                                        tpIntoCar = car
                                        color = 0xFFFFFFFF
                                    end
                                    removePointMarker()
                                end
                                if colpoint.entityType ~= 2 then createPointMarker(pos.x, pos.y, pos.z) end
                                if isKeyDown(key.VK_LBUTTON) then
                                    if tpIntoCar then
                                        if not jumpIntoCar(tpIntoCar) then
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
---
function onScriptTerminate(scr, quit)
    if scr == script.this then
        if killlistmode == 1 then enableKillList(true) end
        nameTag = true
        if not quit then 
            nameTagOn() 
            infRun(false)
            noRecoilDynamicCrosshair(false)
            cameraRestorePatch(false)
            unlimBullets(false)
         end
        showCursor(false)
        removePointMarker()
        if fonts_loaded then
            font_gtaweapon3.vtbl.Release(font_gtaweapon3)
        end
    end
end

local frakcolor = {
    ['���� 51:'] = '{51964D}���� 51{ffffff}:',
    ['����� ���������:'] = '{51964D}����� ���������{ffffff}:',
    ['FBI'] = '{313131}FBI{ffffff}',
    ['LSPD'] = '{110CE7}LSPD{ffffff}',
    ['SFPD'] = '{110CE7}SFPD{ffffff}',
    ['LVPD'] = '{110CE7}LVPD{ffffff}',
    ['����� ������'] = '{FF0000}����� ������{ffffff}',
    ['����� LCN'] = '{DDA701}����� LCN{ffffff}',
    ['������� �����'] = '{B4B5B7}������� �����{ffffff}',
    ['Ballas'] = '{B313E7}Ballas{ffffff}',
    ['Vagos'] = '{DBD604}Vagos{ffffff}',
    ['Groove'] = '{009F00}Grove{ffffff}',
    ['Aztecas'] = '{01FCFF}Aztecas{ffffff}',
    ['Rifa'] = '{2A9170}Rifa{ffffff}',
    ['Warlocks MC'] = '{F45000}Warlocks MC{ffffff}',
    ['Mongols MC'] = '{333333}Mongols MC{ffffff}',
    ['Pagans MC'] = '{2C9197}Pagans MC{ffffff}'
}

function sampev.onSpectatePlayer(id, type)
    recon.id = id
    traceid = id
end

function sampev.onTogglePlayerSpectating(state)
    if not state then recon.id = -1 end
end

function sampev.onSetPlayerPos()
    if flyInfo.active then
        lua_thread.create(function()
            flyInfo.isASvailable = false
            wait(300)
            flyInfo.isASvailable = true
        end)
    end
end

function sampev.onPlayerChatBubble(playerId, color, distance, duration, message)
    if sampIsPlayerConnected(playerId) then
        if not message:match("%[AFK%] %[%S+ ������%]") then
            color = bgra_to_argb(color)
            --color = set_argb_alpha(color, 0xA0)
            table.insert(chatB, {nick = sampGetPlayerNickname(playerId), id = playerId, color = color, message = message})
        end
    end
end

function sampev.onUnoccupiedSync(id, data)
    if data.roll.x >= 10000.0 or data.roll.y >= 10000.0 or data.roll.z >= 10000.0 or data.roll.x <= -10000.0 or data.roll.y <= -10000.0 or data.roll.z <= -10000.0 then
        cwid = id
        local pcol = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
        sampAddChatMessage(("<Warning>{%s} ����� %s [%s] �������� ���������� ������"):format(pcol, sampGetPlayerNickname(id), id), 0xFF2424)
        return false
	end
end

function sampev.onTrailerSync(playerId, data)
	if isCharInAnyCar(PLAYER_PED) then
		local veh = storeCarCharIsInNoSave(PLAYER_PED)
		local _, v = sampGetVehicleIdByCarHandle(veh) 
        if data.trailerId == v then
            cwid = playerId
            local pcol = ("%06X"):format(bit.band(sampGetPlayerColor(playerId), 0xFFFFFF))
            sampAddChatMessage(("<Warning>{%s} ����� %s [%s] �������� ���������� ������"):format(pcol, sampGetPlayerNickname(playerId), playerId), 0xFF2424)
			return false
		end
	end
end

function sampev.onServerMessage(color, text)

    local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    --��� ���������
    punishlog(text)
    --��� �������� ����������
    otletfunc(text, color)
    --��� � ������� ����������
    if cfg.other.chatconsole then sampfuncsLog(text) end

    --�������� ��� �������
    if text:match('^ �� ���������������� ��� ��������� %d+ ������$') then cfg.other.admlvl = tonumber(text:match('^ �� ���������������� ��� ��������� (%d+) ������$')) saveData(cfg, 'moonloader/config/Admin Tools/config.json') end
    --��� ������ ��������� �� ������
    if cfg.other.admlvl > 1 and color == -10270806 then
        if punkey.re.id or punkey.warn.id or punkey.ban.id or punkey.prison.id or punkey.auninvite.id or punkey.sban.id or punkey.pspawn.id or punkey.addabl.id then
            for k, v in pairs(punkey) do
                if type(v) == "table" then
                    if v.id ~= nil then
                        if sampIsPlayerConnected(v.id) then
                            if text:find(sampGetPlayerNickname(v.id)) then
                                if not text:find(mynick) then
                                    atext('������� �������� ������ �������������')
                                    punkey = {warn = {}, ban = {}, prison = {}, re = {}, sban = {}, auninvite = {}, pspawn = {}, addabl = {}}
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    --/checkb
    if ban.check and text:find("����� �� ������") then 
        atext(("����� %s �� ������������"):format(ban.nick)) 
        if not doesFileExist('moonloader/Admin Tools/Check Banned/result.txt') then
            local file = io.open("moonloader/Admin Tools/Check Banned/result.txt", 'w')
            file:write(ban.nick.."\n")
            file:close()
        else
            local file = io.open('moonloader/Admin Tools/Check Banned/result.txt', 'a')
            file:write(ban.nick.."\n")
            file:close()
        end
        ban.check = false 
        return false 
    end

    --������ � ������ ������
    chatlogfile = io.open('moonloader/Admin Tools/chatlog_all.txt', 'a')
    local time = localTime()
    chatlogfile:write(('[%s || %s]\t%s\n'):format(os.date('%d.%m.%Y'), ("%s:%s:%s.%s"):format(time.wHour, time.wMinute, time.wSecond, time.wMilliseconds), text))
    chatlogfile:close()

    --�����
    if text:match('^ ����� �� .+%[%d+%] � .+%[%d+%]:') then color = argb_to_rgba(join_argb(255, config_colors.anschat.r, config_colors.anschat.g, config_colors.anschat.b)) end
    if text:match('^ <ADM%-CHAT> .+: .+') then color = argb_to_rgba(join_argb(255, config_colors.admchat.r, config_colors.admchat.g, config_colors.admchat.b)) end
    if text:match('^ <SUPPORT%-CHAT> .+: .+') then color = argb_to_rgba(join_argb(255, config_colors.supchat.r, config_colors.supchat.g, config_colors.supchat.b)) end
    if text:match('^ SMS:') then 
        local smsid = text:match('^ SMS: .+ �����������: .+%[(%d+)%]$')
        if masstpon then --�������� ��
            if not checkIntable(smsids, smsid) then table.insert(smsids, smsid) end
            return false
        end
        return {argb_to_rgba(join_argb(255, config_colors.smschat.r, config_colors.smschat.g, config_colors.smschat.b)), text} 
    end
    if text:match('^ %->������ .+') then color = argb_to_rgba(join_argb(255, config_colors.askchat.r, config_colors.askchat.g, config_colors.askchat.b)) end

    --�������� ID �� �������
    if text:match("^ ������ �� .+%[%d+%] �� .+%[%d+%]%: .+") then
        whorep, reportid = text:match("������ �� .+%[(%d+)%] �� .+%[(%d+)%]%: .+")
        color = argb_to_rgba(join_argb(255, config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b))
    end
    
    if text:match('^ ������ �� .+%[%d+%]%:') then
        reportid = text:match('������ �� .+%[(%d+)%]%:')
        whorep = nil
        color = argb_to_rgba(join_argb(255, config_colors.repchat.r, config_colors.repchat.g, config_colors.repchat.b))
    end

    if text:match('^ ������ ��%: .+%[%d+%]%:') then
        reportid = text:match('������ ��%: .+%[(%d+)%]%:')
        whorep = nil
        color = argb_to_rgba(join_argb(255, config_colors.jbchat.r, config_colors.jbchat.g, config_colors.jbchat.b))
    end

    --������� /warehouse
    if text:match('^ �� ������ .+ %d+/%d+') and color == -1 then
        local mfrak = text:match('^ �� ������ (.+) %d+/%d+')
        if frakcolor[mfrak] ~= nil then text = text:gsub(mfrak, frakcolor[mfrak]) end
    end

    --�������� ��� / ����
    if checkf.state then
        if text:match('^ ID: %d+ |.+') then
            local cid, cday, cmonth, cyear, cnick, crang = text:match('^ ID%: (%d+) | %d+%:%d+ (%d+)%.(%d+)%.(%d+) | (.+)%: .+%[(%d+)%]')
            local lvl = sampGetPlayerScore(cid)
            if lvl ~= 0 then
                local crang = tonumber(crang)
                if checkf.frak == 1 or checkf.frak == 10 or checkf.frak == 21 then
                    if lvl < frakrang.PD.inv and lvl ~= 0 then
                        table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 11 then
                        if lvl < frakrang.PD.rang_11 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 12 then
                        if lvl < frakrang.PD.rang_12 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 13 then
                        if lvl < frakrang.PD.rang_13 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif checkf.frak == 2 then
                    if lvl < frakrang.FBI.inv and lvl ~= 0 then
                        table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 6 then
                        if lvl < frakrang.FBI.rang_6 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 7 then
                        if lvl < frakrang.FBI.rang_7 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.FBI.rang_8 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.FBI.rang_9 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif checkf.frak == 3 or checkf.frak == 19 then
                    if lvl < frakrang.Army.inv and lvl ~= 0 then
                        table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 12 then
                        if lvl < frakrang.Army.rang_12 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 13 then
                        if lvl < frakrang.Army.rang_13 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 14 then
                        if lvl < frakrang.Army.rang_14 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif checkf.frak == 5 or checkf.frak == 6 or checkf.frak == 14 then
                    if lvl < frakrang.Mafia.inv and lvl ~= 0 then
                        table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.Mafia.rang_7 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Mafia.rang_8 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.Mafia.rang_9 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    --[[if crang == 7 or crang == 8 or crang == 9 then
                        local dayInvite = os.time({ day = cday, month = cmonth, year = cyear })
                        local today = os.time({day = os.date('%d'), month = os.date('%m'), year = os.date('%Y')})
                        if today - dayInvite < 345600 then
                            table.insert(checkf.f, string.format("Nick: %s [%s] | LVL: %s | Rang: %s � ��������� �� ������� ����� 4-�� ����. ���� ��������: %s.%s.%s", cnick, cid, lvl, crang, cday,cmonth,cyear))
                        end
                    end]]
                elseif checkf.frak == 11 then
                    if lvl < frakrang.Autoschool.inv and lvl ~= 0 then
                        table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.Autoschool.rang_7 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Autoschool.rang_8 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.Autoschool.rang_9 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif checkf.frak == 12 or checkf.frak == 13 or checkf.frak == 15 or checkf.frak == 17 or checkf.frak == 18 then
                    if lvl < frakrang.Gangs.inv and lvl ~= 0 then
                        table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.Gangs.rang_7 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Gangs.rang_8 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.Gangs.rang_9 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif checkf.frak == 22 then
                    if lvl < frakrang.MOH.inv and lvl ~= 0 then
                        table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.MOH.rang_7 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.MOH.rang_8 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.MOH.rang_9 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif checkf.frak == 24 or checkf.frak == 26 or checkf.frak == 29 then
                    if lvl < frakrang.Bikers.inv and lvl ~= 0 then
                        table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 5 then
                        if lvl < frakrang.Bikers.rang_5 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 6 then
                        if lvl < frakrang.Bikers.rang_6 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 7 then
                        if lvl < frakrang.Bikers.rang_7 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.Bikers.rang_8 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                elseif checkf.frak == 9 or checkf.frak == 16 or checkf.frak == 20 then
                    if lvl < frakrang.News.inv and lvl ~= 0 then
                        table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                    end
                    if crang == 7 then
                        if lvl < frakrang.News.rang_7 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 8 then
                        if lvl < frakrang.News.rang_8 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                    if crang == 9 then
                        if lvl < frakrang.News.rang_9 then
                            table.insert(checkf.f, string.format('Nick: %s [%s] | LVL: %s | Rang: %s', cnick, cid, lvl, crang))
                        end
                    end
                end
            end
            return false
        end
        if text:match('�����: %d+ �������') then
            checkf.done = true
            return false
        end
        if text:find('����� ����������� ��%-����%:') then return false end
        if text == ' ' and color == -1 then return false end
    end

    --����������
    if ocheckf.state then

        if text == " �� �� �������� �� �������" then

            ocheckf.error = true
            ocheckf.done = true

            return false

        end
        
        if text:match(" ������ ������� �������� � %d+ �����") then 
            
            ocheckf.error = true
            ocheckf.done = true

            return false

        end

        if text == " ������ �������: [����] [���] [���� ��������] [��������� ����]" then

            return false

        elseif text:match("%[%d+%] %[%S+%] %[%d+:%d+ %d+.%d+.%d+%] %[%d+-%d+-%d+ %d+:%d+:%d+]") then

            local rang = tonumber(text:match("%[(%d+)%] %[%S+%] %[%d+:%d+ %d+.%d+.%d+%] %[%d+-%d+-%d+ %d+:%d+:%d+]"))
            
            if rang == 5 then ocheckf.c5 = ocheckf.c5 + 1 end
            if rang == 6 then ocheckf.c6 = ocheckf.c6 + 1 end
            if rang == 7 then ocheckf.c7 = ocheckf.c7 + 1 end
            if rang == 8 then ocheckf.c8 = ocheckf.c8 + 1 end
            if rang == 9 then ocheckf.c9 = ocheckf.c9 + 1 end
            
            if rang < 5 then ocheckf.done = true end

            return false

        else
            
            ocheckf.state = false

            if ocheckf.state == false and not ocheckf.done then ocheckf.done = true end

        end
    end

    --��������� ���-�� ��������� �� �������
    if fonl.check then
        if text:match('^ ID: %d+ |.+') then
            return false
        end
        if text:match('�����: %d+ �������') then
            fonl.num = text:match('�����: (%d+) �������')
            fonl.done = true
            return false
        end
        if text:find('����� ����������� ��%-����%:') then return false end
        if text == ' ' and color == -1 then return false end
    end

    --��������� IP ��� �������� �����
    if text:match("Nik %[.+%]  R%-IP %[.+%]  L%-IP %[.+%]  IP %[(.+)%]") and color == -10270806 then
        local nick, rip, ip = text:match("Nik %[(.+)%]  R%-IP %[(.+)%]  L%-IP %[.+%]  IP %[(.+)%]")
        ips = {rip, ip}
		rnick = nick
		bip = ip
    end
	if text:match('^ Nik %[.+%]   R%-IP %[.+%]   L%-IP %[.+%]   IP %[.+%]$') then
		local nick, rip, ip = text:match('^ Nik %[(.+)%]   R%-IP %[(.+)%]   L%-IP %[.+%]   IP %[(.+)%]$')
        ips = {rip, ip}
		rnick = nick
    end

    --��������� ID �� ���������� ��������
    if text:match('<Warning> .+%[%d+%]%: .+') and color == -16763905 then
        local cnick, ccwid = text:match('<Warning> (.+)%[(%d+)%]%: .+')
		wid = ccwid
        if cfg.tempChecker.wadd then
            local result, key = checkInTableChecker(checker.temp.loaded, cnick)
            if not result then table.insert(checker.temp.loaded, {{nick = cnick, color = 'FFFFFF', text = ''}}) end
		end
    end

    --��� ID [ChatID]
    if cfg.other.chatid then

        for i = 0, sampGetMaxPlayerId(false) do
            if sampIsPlayerConnectedFixed(i) then

                local nick = sampGetPlayerNickname(i):gsub('%p', '%%%1')

                if text:find(nick) and not text:find(nick..'%['..i..'%]') and not text:find('%['..i..'%] '..nick) and not text:find(nick..' %['..i..'%]') then
                    text = text:gsub(replaceNick(sampGetPlayerNickname(i)), ('%s [%s]'):format(replaceNick(sampGetPlayerNickname(i)), i))
                end

            end
        end

    end

    return {color, text:sub(1, 144)}

end

function replaceNick(nick)
    local name = ""
    for i = 1, #nick do
        local c = nick:sub(i,i)
        if c == "[" or c == "]" or c == "(" or c == ")" then
            name = name.."\\"..c
        else name = name..c end
    end
    return name
end

function addMsg(color, text)
    BS = raknetNewBitStream()
    raknetBitStreamWriteInt32(BS, color)
    raknetBitStreamWriteInt32(BS, #text)
    raknetBitStreamWriteString(BS, text)
    raknetEmulRpcReceiveBitStream(93, BS)
    raknetDeleteBitStream(BS)
end

function sampev.onTextDrawSetString(id, text)
    if id == 2187 then
        imtext.lvl, imtext.warn, imtext.arm, imtext.hp, imtext.carhp, imtext.speed, imtext.ammo, imtext.shot, imtext.timeshot, imtext.engine, imtext.prosport, imtext.afktime, imtext.ping, imtext.packetloss = text:match('~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)~n~(.+)')
    end
    if id == 2188 then
        if text:match('~w~.+~n~ID:') then
            imtext.nick = (text:match('~w~(.+)~n~ID:')):gsub("_", " ")
            reafk = true
        elseif text:match(".+~n~ID:") then
            imtext.nick = (text:match('(.+)~n~ID:')):gsub("_", " ")
            reafk = false
        end
        if recon.id ~= text:match('.+~n~ID%: (%d+)') then
            recon.id = text:match('.+~n~ID%: (%d+)')
            traceid = tonumber(recon.id)
        end
    end
end

function sampev.onShowTextDraw(id, textdraw)
    if id == 2187 then if textdraw.text ~= 10 then recon.state = true end end
    if cfg.recon.enable then
        if id == 2187 then imrecon.v = true vars.others.recon.select = 1 return false end
        local ids = {2182, 2183, 2184, 2185, 2186, 2187, 2188, 2189, 2190, 2191, 2192, 2193, 2194, 2195, 2196, 2197}
        for k, v in pairs(ids) do if v == id then return false end end
    end
end

function sampev.onSendSpectatorSync(d)
    if cfg.recon.enable and recon.state then
        d.leftRightKeys = 0
        d.upDownKeys = 0
        d.keysData = 0
    end
end

function sampev.onTextDrawHide(id)
    if id == 2187 then
        if flyInfo.active then
            lua_thread.create(function()
                flyInfo.isASvailable = false
                wait(300)
                flyInfo.isASvailable = true
            end)
        end
        recon.state = false 
    end
    if cfg.recon.enable then 
        if id == 2187 then 
            imrecon.v = false
        end 
    end
end

function sampev.onPlayerQuit(id, reason)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local color = ("%06X"):format(bit.band(sampGetPlayerColor(id), 0xFFFFFF))
    text_notify_disconnect('{ff0000}����������: {ffffff}'..sampGetPlayerNickname(id)..' ['..id..']')
    if reason == 2 or reason == 1 then table.insert(wrecon, {nick = sampGetPlayerNickname(id), time = os.time()}) end
    for k, v in pairs(checker) do
        for k1, v1 in pairs(v.online) do
            if v1.id == id then table.remove(v.online, k1) end
        end
    end
end

function sampev.onPlayerDeathNotification(killerId, killedId, reason)
    if killerId ~= nil and reason ~= nil and killedId ~= nil then
        local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
        if sampIsPlayerConnectedFixed(killerId) and sampIsPlayerConnectedFixed(killedId) then
            local killercolor   = ("%06X"):format(bit.band(sampGetPlayerColor(killerId), 0xFFFFFF))
            local killedcolor   = ("%06X"):format(bit.band(sampGetPlayerColor(killedId), 0xFFFFFF))
            local killerNick    = sampGetPlayerNickname(killerId)
            local killedNick    = sampGetPlayerNickname(killedId)
            table.insert(tkills, ("{%s}%s [%s]\t{%s}%s [%s]\t%s"):format(killercolor, killerNick, killerId, killedcolor, killedNick, killedId, sampGetDeathReason(reason)))
            table.insert(tkilllist, {killer = ('{%s}%s [%s]'):format(killercolor, killerNick, killerId), killed = ('{%s} %s [%s]'):format(killedcolor, killedNick, killedId), reason = reason})
        end
    end
    if #tkilllist > 5 then table.remove(tkilllist, 1) end
end

function sampev.onTogglePlayerControllable(bool) if swork then return false end end

function sampev.onAimSync(playerId, data)
    if tonumber(playerId) == tonumber(traceid) then
        if sampIsPlayerConnected(playerId) then
            local file = io.open("moonloader/Admin Tools/aimdata.txt", "a")
            file:write(("%s [%s] camMode: %s / weaponstate: %s / aimZ: %s\n"):format(sampGetPlayerNickname(playerId), playerId, data.camMode, data.weaponState, data.aimZ))
            file:close()
        end
    end
end

function sampev.onBulletSync(playerId, data)
    if tonumber(playerId) == tonumber(traceid) then
        if sampIsPlayerConnected(playerId) then
            --------
            local file = io.open("moonloader/Admin Tools/shotlog.txt", "a")
            file:write(("%s [%s] origin: %s %s %s / target: %s %s %s / type: %s\n"):format(sampGetPlayerNickname(playerId), playerId, data.origin.x, data.origin.y, data.origin.z, data.target.x, data.target.y, data.target.z, data.targetType))
            file:close()
            --------
            BulletSync.lastId = BulletSync.lastId + 1
            if BulletSync.lastId < 1 or BulletSync.lastId > BulletSync.maxLines then
                BulletSync.lastId = 1
            end
            local id = BulletSync.lastId
            --print(("%s [%s] / origin: %s %s %s / target: %s %s %s / type: %s"):format(sampGetPlayerNickname(playerId), playerId, data.origin.x, data.origin.y, data.origin.z, data.target.x, data.target.y, data.target.z, data.targetType))
            if data.target.x ~= nil and data.target.y ~= nil and data.target.z ~= nil then 
                if data.target.x <= 6 and  data.target.y <= 6 and data.target.z <= 0 then
                    if data.targetType == 1 then
                        if data.targetId ~= 65535 then
                            local tX, tY, tZ = getCharCoordinates(select(2, sampGetCharHandleBySampPlayerId(data.targetId)))
                            data.target.x, data.target.y, data.target.z = tX, tY, tZ
                        else
                            data.targetType = 5
                        end
                    else
                        data.targetType = 5
                    end
                end
                BulletSync[id].enable = true
                BulletSync[id].tType = data.targetType
                BulletSync[id].time = os.time() + 15
                BulletSync[id].o.x, BulletSync[id].o.y, BulletSync[id].o.z = data.origin.x, data.origin.y, data.origin.z
                BulletSync[id].t.x, BulletSync[id].t.y, BulletSync[id].t.z = data.target.x, data.target.y, data.target.z
            end
        end
    end
end

function sampev.onPlayerJoin(id, clist, isNPC, nick)
    text_notify_connect(('{00ff00}�����������: {ffffff}%s [%s]'):format(nick, id))
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	for i, v in ipairs(wrecon) do
		if v["nick"] == nick then
			if (os.time() - v["time"]) < 5 and (os.time() - v["time"]) > 0 then
				if cfg.other.reconw then
					atext(('����� {66FF00}%s [%s] {ffffff}�������� ���� ���������. ����� ��������: %s ������'):format(nick, id, os.time() - v["time"]))
				end
			end
			table.remove(wrecon, i)
		end
    end
    for i, v in ipairs(checker.admins.loaded) do
		if nick == v['nick'] then
            table.insert(checker.admins.online, {nick = nick, id = id, color = v['color'], text = v['text']})
            rebuildUsers()
			break
		end
    end
    for i, v in ipairs(checker.players.loaded) do
		if nick == v['nick'] then
            table.insert(checker.players.online, {nick = nick, id = id, color = v['color'], text = v['text']})
            rebuildUsers()
			break
		end
	end
	for i, v in ipairs(checker.temp.loaded) do
		if nick == v['nick'] then
            table.insert(checker.temp.online, {nick = nick, id = id, color = v['color'], text = v['text']})
            rebuildUsers()
			break
		end
    end
    for i, v in pairs(checker.leaders.loaded) do
        if nick == checker.leaders.loaded[i] then
            table.insert(checker.leaders.online, {nick = nick, id = id, frak = i})
            rebuildUsers()
            break
        end
    end
end

function onD3DPresent()
    local sw, sh = getScreenResolution()
    if #tkilllist ~= 0 and fonts_loaded and not isPauseMenuActive() and swork then
        if killlistmode == 1 then
            local killsy = cfg.killlist.posy + cfg.other.killsize/4
            for k, v in ipairs(tkilllist) do
                d3dxfont_draw(font_gtaweapon3, 'G', {cfg.killlist.posx ,killsy, sw, sh}, 0xFF000000, 0x10)
                d3dxfont_draw(font_gtaweapon3, string.char(RenderGun[v['reason']]), {cfg.killlist.posx ,killsy, sw, sh}, 0xFFFFFFFF, 0x10)
                killsy = killsy + renderGetFontDrawHeight(killfont)
            end
        end
    end
end

function upd_locals()
    while true do wait(100)
        hfps = math.floor(mem.getfloat(0xB7CB50, 4, false))
    end
end

function renders()
    local tempRender = 0
    local admRender = 0
    local playerRender = 0
    local leaderRender = 0
    while true do wait(0)
        if swork and not isPauseMenuActive() then
            local admrenderPosY = cfg.admchecker.posy
            local playerRenderPosY = cfg.playerChecker.posy
            local tempRenderPosY = cfg.tempChecker.posy
            local leadersRenderPosY = cfg.leadersChecker.posy
            local chatBposx = 1920/2
            local chatBposy = 1080/2
            local hposx, hposy, hposz = getCharCoordinates(PLAYER_PED)
            local hposint = getActiveInterior()
            screenx, screeny = getScreenResolution()
            local hpos = ("%0.2f %0.2f %0.2f"):format(hposx, hposy, hposz)
            local checkerheight = renderGetFontDrawHeight(checkfont)
            local hudheight = renderGetFontDrawHeight(hudfont)
            local killheight = renderGetFontDrawHeight(killfont)
            local hudtext = ""

            if #checker.temp.online == 0 then
                tempRender = tempRenderPosY-(#checker.temp.online + 1)*checkerheight
            else
                tempRender = tempRenderPosY - #checker.temp.online*checkerheight
            end
            if #checker.admins.online == 0 then
                admRender = admrenderPosY-(#checker.admins.online+1)*checkerheight
            else
                admRender = admrenderPosY - #checker.admins.online*checkerheight
            end
            if #checker.players.online == 0 then
                playerRender = playerRenderPosY - (#checker.players.online+1)*checkerheight
            else
                playerRender = playerRenderPosY - #checker.players.online*checkerheight
            end
            if #checker.leaders.online == 0 then
                leaderRender = leadersRenderPosY - (#checker.leaders.online+1)*checkerheight
            else
                leaderRender = leadersRenderPosY - #checker.leaders.online*checkerheight
            end

            --[[for k, v in pairs(chatB) do
                local color = bit.tohex(ARGBtoRGB(v.color)):match("00(.+)")
                renderFontDrawText(hudfont, ("%s | %s | %s [%s]: {%s}%s"):format(v.color, color, v.nick, v.id, color, v.message), chatBposx, chatBposy, -1)
                chatBposy = chatBposy + renderGetFontDrawHeight(hudfont)
            end]]

            if #chatB > 7 then table.remove(chatB, 1) end

            if killlistmode == 1 then
                local killsy = cfg.killlist.posy
                for k, v in ipairs(tkilllist) do
                    local killlenght = renderGetFontDrawTextLength(killfont,v['killer'])
                    local gunlenght = renderGetFontDrawTextLength(gunfont, v['reason'])
                    local deathlenght = renderGetFontDrawTextLength(killfont,v['killed'])
                    renderFontDrawText(killfont, v['killer'], cfg.killlist.posx-killlenght-3, killsy, -1)
                    renderFontDrawText(killfont, v['killed'], cfg.killlist.posx+cfg.other.killsize*1.35 ,killsy, -1)
                    killsy = killsy + killheight
                end
            end

            if cfg.joinquit.enable then
                if notification_connect then
                    if localClock() - notification_connect.tick <= notification_connect.duration then
                        local alpha = 255 * math.min(1, notification_connect.duration - (localClock() - notification_connect.tick))
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
                        local alpha = 255 * math.min(1, notification_disconnect.duration - (localClock() - notification_disconnect.tick))
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

            local mainColor     = ("%06X"):format(bit.band(config_colors.hudmain.color, 0xFFFFFF))
            local secondColor   = ("%06X"):format(bit.band(config_colors.hudsecond.color, 0xFFFFFF))

            if cfg.other.style == 1 then
                hudtext = ('%s %s %s %s [%s %s] [FPS: %s]'):format(os.date("[%H:%M:%S]"), 
                funcsStatus.Inv and '{'..secondColor..'}[Inv]{'..mainColor..'}' or '[Inv]', 
                funcsStatus.AirBrk and '{'..secondColor..'}[AirBrk]{'..mainColor..'}' or '[AirBrk]', 
                flyInfo.active and '{'..secondColor..'}[Fly]{'..mainColor..'}' or '[Fly]', 
                hpos, 
                hposint, 
                hfps)
            elseif cfg.other.style == 2 then
                hudtext = ('%s {'..secondColor..'}/{'..mainColor..'} %s {'..secondColor..'}/{'..mainColor..'} %s {'..secondColor..'}/{'..mainColor..'} %s {'..secondColor..'}/{'..mainColor..'} %s %s {'..secondColor..'}/{'..mainColor..'} FPS: %s'):format(os.date("%H:%M:%S"), 
                funcsStatus.Inv and '{'..secondColor..'}Inv{'..mainColor..'}' or 'Inv', 
                funcsStatus.AirBrk and '{'..secondColor..'}AirBrk{'..mainColor..'}' or 'AirBrk', 
                flyInfo.active and '{'..secondColor..'}Fly{'..mainColor..'}' or 'Fly', 
                hpos, 
                hposint, 
                hfps)
            elseif cfg.other.style == 3 then
                hudtext = ('%s %s %s %s %s %s FPS: %s'):format(os.date("%H:%M:%S"), 
                funcsStatus.Inv and '{'..secondColor..'}Inv{'..mainColor..'}' or 'Inv', 
                funcsStatus.AirBrk and '{'..secondColor..'}AirBrk{'..mainColor..'}' or 'AirBrk', 
                flyInfo.active and '{'..secondColor..'}Fly{'..mainColor..'}' or 'Fly', 
                hpos, 
                hposint, 
                hfps)
            end

            renderFontDrawText(hudfont, hudtext, 0, screeny-hudheight, config_colors.hudmain.color)
            
            if cfg.admchecker.enable then
                renderFontDrawText(checkfont, "������������� ������ ["..#checker.admins.online.."]:", cfg.admchecker.posx, admRender, 0xFF00FF00)
                if #checker.admins.online > 0 then
                    for k, v in pairs(checker.admins.online) do
                        local cText = ("{%s}%s [%s] %s{5AA0AA} %s"):format(v['color'], v["nick"], v["id"], select(1, sampGetCharHandleBySampPlayerId(v["id"])) and '{5aa0aa}(�)' or '', v['text'])
                        renderFontDrawText(checkfont, cText, cfg.admchecker.posx, (admrenderPosY - k*checkerheight)+checkerheight, -1)
                    end
                else
                    renderFontDrawText(checkfont, "����� ����", cfg.admchecker.posx, admrenderPosY, 0xFF808080)
                end
            end
            if cfg.playerChecker.enable then
                renderFontDrawText(checkfont, "������ ������ ["..#checker.players.online.."]:", cfg.playerChecker.posx, playerRender, 0xFFFFFF00)
                if #checker.players.online > 0 then
                    for k, v in pairs(checker.players.online) do
                        local cText = ("{%s}%s [%s] %s{5AA0AA} %s"):format(v['color'], v["nick"], v["id"], select(1, sampGetCharHandleBySampPlayerId(v["id"])) and '{5aa0aa}(�)' or '', v['text'])
                        renderFontDrawText(checkfont, cText , cfg.playerChecker.posx, (playerRenderPosY - k*checkerheight)+checkerheight, -1)
                    end
                else
                    renderFontDrawText(checkfont, "����� ����", cfg.playerChecker.posx, playerRenderPosY, 0xFF808080)
                end
            end
            if cfg.tempChecker.enable then
                renderFontDrawText(checkfont, "Temp ����� ["..#checker.temp.online.."]:", cfg.tempChecker.posx, tempRender, 0xFFFF0000)
                if #checker.temp.online > 0 then
                    for k, v in pairs(checker.temp.online) do
                        local cText = ("{%s}%s [%s] %s{5AA0AA} %s"):format(v['color'], v["nick"], v["id"], select(1, sampGetCharHandleBySampPlayerId(v["id"])) and '{5aa0aa}(�)' or '', v['text'])
                        renderFontDrawText(checkfont, cText, cfg.tempChecker.posx, (tempRenderPosY - k*checkerheight)+checkerheight, -1)
                    end
                else
                    renderFontDrawText(checkfont, "����� ����", cfg.tempChecker.posx, tempRenderPosY, 0xFF808080)
                end
            end
            if cfg.leadersChecker.enable then
                renderFontDrawText(checkfont, "������ ������ ["..#checker.leaders.online.."]:", cfg.leadersChecker.posx, leaderRender, 0xFFD76E00)
                if #checker.leaders.online > 0 then
                    for k, v in pairs(checker.leaders.online) do
                        if cfg.leadersChecker.cvetnick then
                            renderFontDrawText(checkfont,string.format('{%s}%s [%s] %s{5aa0aa} {%s}%s',leaders1[v['frak']], v["nick"], v["id"], doesCharExist(select(2, sampGetCharHandleBySampPlayerId(v["id"]))) and '{5aa0aa}(�)' or '', leaders1[v['frak']], v['frak']) , cfg.leadersChecker.posx, (leadersRenderPosY - k*checkerheight)+checkerheight, -1)
                        else
                            renderFontDrawText(checkfont,string.format('%s [%s] %s{5aa0aa} {%s}%s',v["nick"], v["id"], select(1, sampGetCharHandleBySampPlayerId(v["id"])) and '{5aa0aa}(�)' or '', leaders1[v['frak']], v['frak']) , cfg.leadersChecker.posx, (leadersRenderPosY - k*checkerheight)+checkerheight, -1)
                        end
                    end
                else
                    renderFontDrawText(checkfont, "����� ����", cfg.leadersChecker.posx, leadersRenderPosY, 0xFF808080)
                end
            end
        end
    end
end

function sampGetPlayerIdByNickname(nick)
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    if tostring(nick) == sampGetPlayerNickname(myid) then return myid end
    for i = 0, 1000 do if sampIsPlayerConnectedFixed(i) and sampGetPlayerNickname(i) == tostring(nick) then return i end end
end

function check_keystrokes()
    while true do wait(0)
        if swork then
            if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
                if isKeyJustPressed(key.VK_F3) then
                    setCharHealth(PLAYER_PED, 0)
                end
                if isKeyJustPressed(key.VK_INSERT) then
                    funcsStatus.Inv = not funcsStatus.Inv
                end
                if wasKeyPressed(config_keys.airbrkkey.v) then
                    airspeed = cfg.cheat.airbrkspeed
                    funcsStatus.AirBrk = not funcsStatus.AirBrk
                    if funcsStatus.AirBrk then
                        if not recon.state then
                            local posX, posY, posZ = getCharCoordinates(playerPed)
                            airBrkCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(playerPed)}
                        end
                    end
                end
            end
        end
    end
end

function main_funcs()
    while true do wait(0)
        if swork then
            if funcsStatus.Inv then
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
            if funcsStatus.AirBrk then
                if not recon.state then
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
    end
end

function check_keys_fast()
    while true do wait(0)
        if swork then
            local isInVeh = isCharInAnyCar(playerPed)
            local veh = nil
            if isInVeh then veh = storeCarCharIsInNoSave(playerPed) end
            if flyInfo.active then
                fly()
            end
            if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
                if wasKeyPressed(190) then
                    if flyInfo.active == true then
                        clearCharTasks(playerPed)
                        flyInfo.active = false
                    else
                        flyInfo.active = true
                    end
                end
                if isKeyJustPressed(key.VK_F3) then
                    setCharHealth(PLAYER_PED, 0)
                end
                if isKeyJustPressed(key.VK_INSERT) then
                    funcsStatus.Inv = not funcsStatus.Inv
                end
                if isKeyJustPressed(config_keys.airbrkkey.v) then
                    airspeed = cfg.cheat.airbrkspeed
                    funcsStatus.AirBrk = not funcsStatus.AirBrk
                    if funcsStatus.AirBrk then
                        local posX, posY, posZ = getCharCoordinates(playerPed)
                        airBrkCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(playerPed)}
                    end
                end
                if isKeyJustPressed(key.VK_B) then 
                    if isCharInAnyCar(playerPed) then
                        local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
                        if cVecZ < 7.0 then applyForceToCar(storeCarCharIsInNoSave(playerPed), 0.0, 0.0, 0.3, 0.0, 0.0, 0.0) end
                    else
                        local pVecX, pVecY, pVecZ = getCharVelocity(playerPed)
                        if pVecZ < 7.0 then setCharVelocity(playerPed, 0.0, 0.0, 10.0) end
                    end
                end
                if isKeyJustPressed(key.VK_BACK) and isCharInAnyCar(playerPed) then
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
                if isKeyJustPressed(key.VK_N) and isCharInAnyCar(playerPed) then 
                    local posX, posY, posZ = getCarCoordinates(storeCarCharIsInNoSave(playerPed))
                    warpCharFromCarToCoord(playerPed, posX, posY, posZ)
                end
                if isKeyJustPressed(key.VK_F3) then 
                    if not isCharInAnyCar(playerPed) then
                        setCharHealth(playerPed, 0.0)
                    else
                        setCarHealth(storeCarCharIsInNoSave(playerPed), 0.0)
                    end
                end
                if isKeyDown(key.VK_DELETE) then 
                    if veh ~= nil then
                        local heading = getCarHeading(veh)
                        heading = heading + 2 * fps_correction()
                        if heading > 360 then heading = heading - 360 end
                        setCarHeading(veh, heading)
                    end
                end
                if isKeyDown(key.VK_LMENU) and isCharInAnyCar(playerPed) then 
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

function onReceiveRpc(id, bs) 
    if id == 91 and swork and isKeyDown(key.VK_LMENU) then --����� / �� ��� ��������
        return false 
    end
end

function tr(pam)
    local idd = tonumber(pam)
    if idd ~= nil then
        if idd == -1 then
            atext('�������� ���������')
            traceid = -1
        else
            if sampIsPlayerConnectedFixed(idd) then
                if idd == traceid then
                    atext(('�������� ��� {66FF00}%s [%s]{ffffff} ���������'):format(sampGetPlayerNickname(idd), idd))
                    traceid = -1
                else
                    atext(('�������� ����������� �� {66ff00}%s [%s]'):format(sampGetPlayerNickname(idd), idd))
                    traceid = idd
                end
            else
                atext('����� �������')
            end
        end
    else
        atext('�������: /tr [id/-1]')
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
                    for wi = 0, sampGetMaxPlayerId(true) do
                        if sampIsPlayerConnectedFixed(wi) then
                            local result, cped = sampGetCharHandleBySampPlayerId(wi)
                            if result then
                                if doesCharExist(cped) and isCharOnScreen(cped) then
                                    local cpos1X, cpos1Y, cpos1Z = getBodyPartCoordinates(6, cped)
                                    local wnick = sampGetPlayerNickname(wi)
                                    local wheadposx, wheadposy = convert3DCoordsToScreen(cpos1X, cpos1Y, cpos1Z)
                                    local wisAfk = sampIsPlayerPaused(wi)
                                    local wcpedHealth = sampGetPlayerHealth(wi)
                                    local hp2 = wcpedHealth
                                    local wcpedArmor = sampGetPlayerArmor(wi)
                                    local wcpedlvl = sampGetPlayerScore(wi)
                                    local whhight = renderGetFontDrawHeight(whfont)
                                    local whlenght = renderGetFontDrawTextLength(whfont,string.format('%s [%s]', wnick, wi))
                                    local hplenght = renderGetFontDrawTextLength(whfont, wcpedHealth)
                                    local aa, rr, gg, bb = explode_argb(sampGetPlayerColor(wi))
                                    local color = join_argb(255, rr, gg, bb)
                                    local wposy = wheadposy - 40
                                    local wposx = wheadposx - 60

                                    for _, v in ipairs(nametagCoords) do
                                        if v["pos_y"] > wposy-whhight*2.33 and v["pos_y"] < wposy+whhight*2.33 and v["pos_x"] > wposx-whlenght and v["pos_x"] < wposx+whlenght then
                                            wposy = v["pos_y"] - whhight*2.33
                                        end
                                    end

                                    nametagCoords[#nametagCoords+1] = {
                                        pos_y = wposy,
                                        pos_x = wposx
                                    }

                                    renderFontDrawText(whfont, string.format('%s [%s] %s', wnick, wi, wisAfk and '{CCCCCC}[AFK]' or ''), wposx, wposy, color)

                                    if wcpedHealth > 100 then wcpedHealth = 100 end
                                    if wcpedArmor > 100 then wcpedArmor = 100 end

                                    renderDrawBoxWithBorder(wposx+1, wposy+whhight*1.33, math.floor(100 / 2) + 2, whhight/3+1, 0x80000000, 1, 0xFF000000)
                                    renderDrawBox(wposx+2, wposy+whhight*1.33, math.floor(wcpedHealth / 2) , whhight/3, 0xAACC0000)

                                    renderFontDrawText(whfont, ('%s'):format(hp2), wposx+60, wposy+whhight, 0xFFFF0000)
                                    renderFontDrawText(whfont, 'LVL: '..wcpedlvl, wposx+70+hplenght, wposy+whhight, -1)

                                    if wcpedArmor ~= 0 then
                                        renderDrawBoxWithBorder(wposx+1, wposy+whhight*2.33, math.floor(100 / 2) + 2, whhight/3+1, 0x80000000, 1, 0xFF000000)
                                        renderDrawBox(wposx+2, wposy+whhight*2.33, math.floor(wcpedArmor / 2) , whhight/3, 0xAAAAAAAA)
                                        renderFontDrawText(whfont, ('%s'):format(wcpedArmor), wposx+60, wposy+whhight*2, -1)
                                    end

                                    if cfg.other.skeletwh then
                                        local t = {3, 4, 5, 51, 52, 41, 42, 31, 32, 33, 21, 22, 23, 2}
                                        for v = 1, #t do
                                            pos1X, pos1Y, pos1Z = getBodyPartCoordinates(t[v], cped)
                                            pos2X, pos2Y, pos2Z = getBodyPartCoordinates(t[v] + 1, cped)
                                            pos1, pos2 = convert3DCoordsToScreen(pos1X, pos1Y, pos1Z)
                                            pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
                                            renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
                                        end
                                        for v = 4, 5 do
                                            pos2X, pos2Y, pos2Z = getBodyPartCoordinates(v * 10 + 1, cped)
                                            pos3, pos4 = convert3DCoordsToScreen(pos2X, pos2Y, pos2Z)
                                            renderDrawLine(pos1, pos2, pos3, pos4, 1, color)
                                        end
                                        local t = {53, 43, 24, 34, 6}
                                        for v = 1, #t do
                                            posX, posY, posZ = getBodyPartCoordinates(t[v], cped)
                                            pos1, pos2 = convert3DCoordsToScreen(posX, posY, posZ)
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
end

function nameTagOn()
    nameTag = true
    local pStSet = sampGetServerSettingsPtr();
    NTdist = mem.getfloat(pStSet + 39)
    NTwalls = mem.getint8(pStSet + 47)
    NTshow = mem.getint8(pStSet + 56)
    mem.setfloat(pStSet + 39, 36.0)
    mem.setint8(pStSet + 47, 1)
    mem.setint8(pStSet + 56, 1)
end

function sampGetDeathReason(id)
	local names = {
		[0] = '�����',
		[1] = '������',
		[2] = '������ ��� ������',
		[3] = '����������� �������',
		[4] = '���',
		[5] = '����',
		[6] = '������',
		[7] = '���',
		[8] = '������',
		[9] = '���������',
		[10] = '���������� �����',
		[11] = '�������� ��������',
		[12] = '������� ��������',
		[13] = '����� �����',
		[14] = '�����',
		[15] = '������',
		[16] = '�������',
		[17] = 'C����������� ���',
		[18] = '������������ ���',
		[22] = '��������',
		[23] = '�������� � ����������',
		[24] = '����',
		[25] = '������',
		[26] = '�����',
		[27] = '������ ��������',
		[28] = '���',
		[29] = '��5',
		[30] = '��47',
		[31] = '�4',
		[32] = 'Tec 9',
		[33] = '��������',
		[34] = '����������� ��������',
		[35] = '���',
		[36] = '��� � ������������',
		[37] = '�������',
		[38] = '�������',
		[39] = '����� ��� �������',
		[40] = '���������',
		[41] = '�������� � �������',
		[42] = '������������',
		[43] = '����������',
		[44] = '���� ������� �������',
		[45] = '����������',
		[46] = '�������',
		[47] = '���� ��������',
		[49] = '���������',
		[50] = '����� ���������',
		[51] = '�����',
		[53] = '������',
		[54] = '�� �������',
		[255] = '������'
	}
	return names[id]
end

function nameTagOff()
    nameTag = false
    local pStSet = sampGetServerSettingsPtr();
    NTdist = mem.getfloat(pStSet)
    NTwalls = mem.getint8(pStSet)
    NTshow = mem.getint8(pStSet)
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
    while true do wait(0)
        local i = 99
        while i > 1 do 
            local wtext, wprefix, wcolor, wpcolor = sampGetChatString(i)
            if wtext:match('%[SWarning%]%:{%S+}  �����  %S+ %[%d+%] - .+') then -- �������� ������.
                cwid = wtext:match('%[SWarning%]:%{%S+%}  �����  %S+ %[(%d+)%] - .+')
                break
            end
            if wtext:match('<Warning> {%S+}%S+%[%d+%] .+') then --������� ��������
                cwid = wtext:match('<Warning> {%S+}%S+%[(%d+)%] .+')
                break
            end
            if wtext:match('<Warning> {%S+}%S+%[%d+%] {FFFFFF}.+') then --������� ������ �����
                cwid = wtext:match('<Warning> {%S+}%S+%[(%d+)%] {FFFFFF}.+')
                break
            end
            if wtext:match('Warning:{%S+} %S+%[(%d+)%] .+') then --������� �������� (������)
                cwid = wtext:match('Warning:{%S+} %S+%[(%d+)%] .+')
                break
            end
            if wtext:match('%[mkrn wrn%]%:{%S+} %S+%[%d+%] .+') then --������� �������� (�����)
                cwid = wtext:match('%[mkrn wrn%]:{%S+} %S+%[(%d+)%] .+')
                break
            end
            i = i - 1
        end
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

function sampev.onSendClientJoin(version, mod, nick) rebuildUsers() end

function sampev.onSendCommand(text)

    if text:match("^/o .+") or text:match("^/ooc .+") then --����� /o ��� 1 ���-��
        if cfg.other.admlvl < 2 then
            local msg = text:match("^/%S+ (.+)")
            if oocLimit.state then
                oocLimit.msg = msg
                oocLimit.state = false
                atext("�� ������������� ������ ��������� ��������� � ����� ���? ��� ������������� ������� ������� ��� ���.")
                return false
            else
                if msg ~= oocLimit.msg then
                    oocLimit.msg = msg
                    atext("�� ������������� ������ ��������� ��������� � ����� ���? ��� ������������� ������� ������� ��� ���.")
                    return false
                else
                    oocLimit.msg = ""
                    oocLimit.state = true
                end
            end
        end
    end

    local aCommands = {"warn", "ban", "prison", "pspawn", "addabl"} --�������� ������ � /a

    for k, v in pairs(aCommands) do

        if cfg.other.admlvl == 1 then
            if text:match("^/"..v.." .+") then
                return {"/a "..text}
            end
        end

        if cfg.other.admlvl < 3 then
            if text:match("^/addabl .+") then
                return {"/a "..text}
            end
        end

    end

end

function sampev.onSendClickPlayer(id, source)
    sampSendChat(("/re %s"):format(id))
end

function sampev.onShowDialog(id, style, title, button1, button2, text)
    if id == 0 then
        if ban.check then
            if title == ban.nick then
                for line in text:gmatch('[^\r\n]+') do
                    if not line:find("����") then
                        local adm, reason, data1, data2 = line:match("(%S+)\t(.+)\t(.+)\t(.+)")
                        atext(("����� %s ������������ �� %s. �������: %s"):format(ban.nick, data2, reason))
                        sampSendDialogResponse(id, 1, 1, nil)
                        ban.check = false
                        return false
                    end
                end
            end
        end
    end
    if id == 1 and #tostring(cfg.other.password) >=6  and cfg.other.passb then
        sampSendDialogResponse(id, 1, _, tostring(cfg.other.password))
        return false
    end
    if id == 1227 and #tostring(cfg.other.adminpass) >=6 and cfg.other.apassb then
        sampSendDialogResponse(id, 1, _, tostring(cfg.other.adminpass))
        return false
    end
end

function wl(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnectedFixed(id) then
                sampSendChat('/warnlog '..sampGetPlayerNickname(id))
            else
                sampSendChat('/warnlog ' ..id)
            end
        else
            sampSendChat('/warnlog '..pam)
        end
    else
        atext('�������: /wlog [id/nick]')
    end
end

function gs(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnectedFixed(id) then
            sampSendChat(("/getstats %s"):format(id))
        else
            atext("����� �������")
        end
    else
        if recon.id ~= -1 then
            sampSendChat(("/getstats %s"):format(recon.id))
        else
            atext("������� /gs [id]")
        end
    end
end

function sbiv(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnectedFixed(id) then
            sampSendChat(("/prison %s %s ���� ��������"):format(id, cfg.timers.sbivtimer))
        else
            atext('����� �������')
        end
    else
        atext("�������: /sbiv [id]")
    end
end

function csbiv(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnectedFixed(id) then
            sampSendChat(("/prison %s %s ���� ��������"):format(id, cfg.timers.csbivtimer))
        else
            atext('����� �������')
        end
    else
        atext("�������: /csbiv [id]")
    end
end

function cbug(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnectedFixed(id) then
            sampSendChat(("/prison %s %s +C ��� �����"):format(id, cfg.timers.cbugtimer))
        else
            atext('����� �������')
        end
    else
        atext("�������: /cbug [id]")
    end
end

function kills() sampShowDialog(21321, '{ffffff}��������� ��������', '{ffffff}������\t{ffffff}������\t{ffffff}������\n'..table.concat(tkills, '\n'), 'x', _, 5) end
--�����
function reportk()
    if reportid ~= nil then
        lua_thread.create(function()
            sampSendChat('/re '..reportid)
            if cfg.other.resend then
                while not recon.state do wait(0) end
                wait(1400)
                if whorep ~= nil then
                    if tonumber(recon.id) == tonumber(reportid) then
                        sampSendChat(("/pm %s �����."):format(whorep))
                    end
                end
            end
        end)
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
    atext('������� ���������� ���������. ��� ���������������� ������� {66FF00}'..table.concat(rkeys.getKeysName(config_keys.goposkey.v)))
    cango = true
end

function goposk()
    if cango then
        setCharCoordinates(PLAYER_PED, savecoords.x, savecoords.y, savecoords.z)
    end
end

function whkey()
    if swork then if nameTag then nameTagOff() else nameTagOn() end end
end

function skeletwh()
    cfg.other.skeletwh = not cfg.other.skeletwh
    saveData(cfg, 'moonloader/config/Admin Tools/config.json')
end
------
function fonline(pam)
    lua_thread.create(function()
        local num = tonumber(pam)
        if num ~= nil then
            if num > 0 and num <= 29 then
                fonl.check = true
                sampSendChat('/amembers '..num)
                while not fonl.done do wait(0) end
                atext('�� ������� �{66FF00}'..num..' {ffffff}������ {66FF00}'..fonl.num..' {ffffff}��������')
                fonl.check = false
                fonl.done = false
                fonl.num = nil
            else
                atext('�������� �� ������ ���� ������ 1 � ������ 29!')
            end
        else
            atext('�������: /fonl [id �������]')
        end
    end)
end

function checkrangs(pam)
    lua_thread.create(function()
        local num = tonumber(pam)
        if num ~= nil then
            if num > 0 and num <= 29 then
                checkf.frak = num
                checkf.state = true
                sampSendChat('/amembers '..num)
                while not checkf.done do wait(0) end
                if #checkf.f == 0 then
                    atext('�� ������� �{66FF00}'..checkf.frak..'{ffffff} ��� ��������� � �������.')
                else
                    sampAddChatMessage(' ', -1)
                    for k, v in pairs(checkf.f) do
                        sampAddChatMessage(' '..v, -1)
                    end
                    sampAddChatMessage(' ', -1)
                    atext('������� �{66FF00}'..checkf.frak)
                end
                checkf.state = false
                checkf.done = false
                checkf.frak = nil
                checkf.f = {}
            else
                atext('�������� �� ������ ���� ������ 1 � ������ 29!')
            end
        else
            atext('�������: /checkrangs [id �������]')
        end
    end)
end

function ags(pam)
    local id = tonumber(pam)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnectedFixed(id) then
                sampSendChat('/agetstats '..sampGetPlayerNickname(id))
            else
                sampSendChat('/agetstats ' ..id)
            end
        else
            sampSendChat('/agetstats '..pam)
        end
    else
        if recon.id ~= -1 then
            if sampIsPlayerConnected(recon.id) then
                local nick = sampGetPlayerNickname(recon.id)
                sampSendChat(("/agetstats %s"):format(nick))
            else
                atext('�������: /ags [id/nick]')
            end
        else
            atext('�������: /ags [id/nick]')
        end
    end
end

function cheat(pam)
    local id = tonumber(pam)
    if id ~= nil then
        if sampIsPlayerConnectedFixed(id) then
            local lvl = sampGetPlayerScore(id)
            if lvl > 1 then
                sampSendChat(("/warn %s 21 cheat"):format(id))
            else
                sampSendChat(("/ban %s cheat"):format(id))
            end
        else
            atext("����� �������")
        end
    else
        if recon.id ~= -1 then
            local lvl = sampGetPlayerScore(recon.id)
            if lvl > 1 then
                sampSendChat(("/warn %s 21 cheat"):format(recon.id))
            else
                sampSendChat(("/ban %s cheat"):format(recon.id))
            end
        else
            atext("������� /cheat [id]")
        end
    end
end

function getTargetBlipCoordinatesFixed()
    local bool, x, y, z = getTargetBlipCoordinates(); if not bool then return false end
    requestCollision(x, y); loadScene(x, y, z)
    local bool, x, y, z = getTargetBlipCoordinates()
    return bool, x, y, z
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
    local rdata = {}
    local isRdata = false
    if #ips == 2 then
        atext('���� �������� IP �������. ��������..')
        local site = "http://a0380695.xsph.ru/?ip1="..ips[1].."&ip2="..ips[2]
        httpRequest(site, _, function(response, code, headers, status)
            if response then
                rdata = decodeJson(response)
                if rdata.ipone.success and rdata.iptwo.success then
                    isRdata = true
                else
                    atext('��������� ������ �������� IP �������')
                end
            else
                atext('��������� ������ �������� IP �������')
            end
        end)
        lua_thread.create(function()
            while not isRdata do wait(0) end
            local distances2 = distance_cord(rdata.ipone.latitude, rdata.ipone.longitude,rdata.iptwo.latitude, rdata.iptwo.longitude)
            if tonumber(pam) == nil then
                sampAddChatMessage((' ������: {66FF00}%s{ffffff} | �����: {66FF00}%s{ffffff} | ISP: {66FF00}%s [R-IP: %s]'):format(u8:decode(rdata.ipone.country), u8:decode(rdata.ipone.city), u8:decode(rdata.ipone.isp), u8:decode(rdata.ipone.ip)), -1)
                sampAddChatMessage((' ������: {66FF00}%s{ffffff} | �����:{66FF00} %s{ffffff} | ISP: {66FF00}%s [IP: %s]'):format(u8:decode(rdata.iptwo.country), u8:decode(rdata.iptwo.city), u8:decode(rdata.iptwo.isp), u8:decode(rdata.iptwo.ip)), -1)
                sampAddChatMessage((' ����������: {66FF00}%s {ffffff}��. | ���: {66FF00}%s %s'):format(math.floor(distances2), rnick, sampGetPlayerIdByNickname(rnick) and '['..sampGetPlayerIdByNickname(rnick)..']' or ''), -1)
            else
                sampSendChat(('/a ������: %s | �����: %s | ISP: %s [R-IP: %s]'):format(u8:decode(rdata.ipone.country), u8:decode(rdata.ipone.city), u8:decode(rdata.ipone.isp), u8:decode(rdata.ipone.ip)))
                wait(cfg.other.delay)
                sampSendChat(('/a ������: %s | �����: %s | ISP: %s [IP: %s]'):format(u8:decode(rdata.iptwo.country), u8:decode(rdata.iptwo.city), u8:decode(rdata.iptwo.isp), u8:decode(rdata.iptwo.ip)))
                wait(cfg.other.delay)
                sampSendChat(('/a ����������: %s ��. | ���: %s %s'):format(math.floor(distances2), rnick, sampGetPlayerIdByNickname(rnick) and '['..sampGetPlayerIdByNickname(rnick)..']' or ''))
            end
        end)
    else
        atext('�� ������� IP ������� ��� ���������')
    end
    local rdata = {}
    local isRdata = false
end

function givehb(pam)
    lua_thread.create(function()
        local params = string.split(pam, " ", 2)
        if #params < 2 then
            atext('�������: /givehb [id] [��� ��������]')
        else
            local id = tonumber(params[1])
            if id == nil then
                atext('�������: /givehb [id] [��� ��������]')
            else
                if sampIsPlayerConnectedFixed(id) then
                    if doesFileExist('moonloader/Admin Tools/hblist/'..params[2]..'.txt') then
                        atext('������ ������ �������� ������ {66FF00}'..sampGetPlayerNickname(id)..' ['..id..']')
                        for line in io.lines('moonloader/Admin Tools/hblist/'..params[2]..'.txt') do
                            sampSendChat('/hbject '..id..' '..u8:decode(line))
                            wait(cfg.other.delay)
                        end
                        atext('������ ��������')
                    else
                        atext(("�� ���������� ������� \"%s\""):format(params[2]))
                    end
                else
                    atext('����� �������')
                end
            end
        end
    end)
end

function masshb(pam)
    lua_thread.create(function()
        local strp = sampGetStreamedPlayers()
        if #pam ~= 0 then
            if doesFileExist('moonloader/Admin Tools/hblist/'..pam..'.txt') then
                atext('�������� ������ �������� ������')
                for k, v in pairs(strp) do
                    if sampIsPlayerConnectedFixed(v) then
                        atext('������ ������ �������� ������ '..sampGetPlayerNickname(v)..' ['..v..']')
                        for line in io.lines('moonloader/Admin Tools/hblist/'..pam..'.txt') do
                            sampSendChat('/hbject '..v..' '..line)
                            wait(cfg.other.delay)
                        end
                        atext('������ �������� ������ '..sampGetPlayerNickname(v)..' ['..v..'] ��������')
                        wait(cfg.other.delay)
                    end
                end
                atext('�������� ������ �������� ��������')
            else
                atext('�� ���������� ��������� "'..pam..'"')
            end
        else
            atext('�������: /masshb [��� ��������]')
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
        atext(masstpon and '������������ ������' or '������������ ��������. ����� ���������������: {66FF00}'..skoktp..'{ffffff} �������')
        skoktp = 0
        if not masstpon then 
            wait(cfg.other.delay)
            sampSendChat('/togphone')
        else
            lua_thread.create(function()
                while true do wait(cfg.other.delay)
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
                    renderFontDrawText(hudfont, '������������ �������. ��������: {66FF00}'..#smsids..'\n{ffffff}����� ���������������: {66FF00}'..skoktp, smsx, smsy, -1)
                else return end
            end
        end    
    end)
end

function blog(pam)
    local id = tonumber(pam)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnectedFixed(id) then
                sampSendChat('/banlog '..sampGetPlayerNickname(id))
            else
                sampSendChat('/banlog ' ..id)
            end
        else
            sampSendChat('/banlog '..pam)
        end
    else
        atext('�������: /blog [id/nick]')
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

function punish()
    lua_thread.create(function()
        if doesFileExist(os.getenv('TEMP')..'\\Punishment.txt') then
            atext('������ ��������� �� ������� ������')
            for line in io.lines(os.getenv('TEMP')..'\\Punishment.txt') do
                local type, nick, hour, reason = line:match("(.+) ���: (.+) ���������� %S+: (%d*) �������: (.+)")
                if nick:match(".+%s$") then nick = nick:match("(.+)%s$") end
                local nick = nick:gsub(" ", '_')
                if sampGetPlayerIdByNickname(nick) ~= nil then
                    if type == "[W]" then sampSendChat(("/warn %s %s %s"):format(sampGetPlayerIdByNickname(nick), hour, reason))
                    elseif type == "[B]" then sampSendChat(("/ban %s %s"):format(sampGetPlayerIdByNickname(nick), reason))
                    elseif type == '[M]' then sampSendChat(('/mute %s %s %s'):format(sampGetPlayerIdByNickname(nick), hour, reason))
                    elseif type == '[P]' then sampSendChat(("/prison %s %s %s"):format(sampGetPlayerIdByNickname(nick), hour, reason))
                    elseif type == '[IB]' then sampSendChat(("/iban %s %s"):format(sampGetPlayerIdByNickname(nick), reason))
                    end
                else
                    if type == '[W]' then sampSendChat(("/offwarn %s %s %s"):format(nick, hour, reason))
                    elseif type == '[B]' then sampSendChat(("/offban %s %s"):format(nick, reason))
                    elseif type == '[M]' then sampSendChat(("/offmute %s %s %s"):format(nick, reason:gsub(" ", '_'), hour))
                    elseif type == '[P]' then sampSendChat(("/offprison %s %s %s"):format(nick, reason:gsub(" ", '_'), hour))
                    elseif type == '[IB]' then sampSendChat(("/ioffban %s %s"):format(nick, reason))
                    end
                end
                wait(cfg.other.delay)
            end
            atext('������ ��������� �� ������� ��������')
            local pfile = io.open('moonloader/Admin Tools/punishjb.txt', 'a')
            pfile:write('\n')
            pfile:write(os.date()..'\n')
            for line in io.lines(os.getenv('TEMP')..'\\Punishment.txt') do
                pfile:write(line..'\n')
            end
            pfile:close()
            local ppfile = io.open(os.getenv('TEMP')..'\\Punishment.txt', 'w')
            ppfile:close()
        else
            atext("���� � ������������� ����������� �� ���������.")
        end
    end)
end

function punishlog(text)
    local triggers = {'OffBan', "������� %S+ �������", 'SBan', 'IOffBan', '����� warn', "������� �������������� ��", "������ %S+ �������", "�������� � ��������", "������� � prison", "������������ ��� ������", "OffMute", "������� IP", "����� ������� �� ������", "�� �������� .+ � ������"}
    local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
    if text:find(mynick) then
        for k, v in pairs(triggers) do
            if text:match(v) then
                local time = localTime()
                local file = io.open('moonloader/Admin Tools/punishlogs.txt', 'a')
                file:write(('[%s || %s] %s\n'):format(os.date('%d.%m.%Y'), ("%s:%s:%s.%s"):format(time.wHour, time.wMinute, time.wSecond, time.wMilliseconds), text))
                file:close()
                break
            end
        end
    end
end

function getlvl(pam)
    lua_thread.create(function()
        local t = {}
        local cid = tonumber(pam)
        if cid ~= nil then
            for i = 0, 999 do
                if sampIsPlayerConnectedFixed(i) then
                    if sampGetPlayerScore(i) == cid then
                        table.insert(t, ('%s [%s]'):format(sampGetPlayerNickname(i), i))
                    end
                end
            end
            sampShowDialog(2131, '{ffffff}������ � �������: {66FF00}'..cid, table.concat(t, '\n'), '�', 'x', 2)
            while sampIsDialogActive(2131) do wait(0) end
            local result, button, list, input = sampHasDialogRespond(2131)
            if result and button ==  1 then
                local text = sampGetListboxItemText(list)
                local id = text:match("(%S+) %[(%d+)%]")
                sampSendChat(("/re %s"):format(id))
            end
        else
            atext('�������: /getlvl [�������]')
        end
    end)
end

function hblist()
    local hlist = {}
    for line in lfs.dir('moonloader/Admin Tools/hblist') do
        if line:match('.+.txt') then
            table.insert(hlist, line)
        end
    end
    sampShowDialog(3213,'������ ��������',table.concat(hlist, "\n"),'x',_,2)
end

function admchat()
    while true do wait(0)

        local wtext, wprefix, wcolor, wpcolor = sampGetChatString(99)
        local mynick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        local w1color = ("%06X"):format(bit.band(wcolor, 0xFFFFFF))

        if string.rlower(w1color) == string.match(bit.tohex(config_colors.admchat.color), '00(.+)') and wtext:match('^ <ADM%-CHAT> ') then
            local nick, id, text

            if cfg.other.chatid then
                nick, id, text = wtext:match('^ <ADM%-CHAT> (%S+) %[(%d+)%]: (.+)')
            else
                nick, text = wtext:match('^ <ADM%-CHAT> (%S+): (.+)')
                id = sampGetPlayerIdByNickname(nick)
            end 

            if nick and id and text then -- �������� �� ������ ������� ���� ������� ����������, ��� ��� ������ ������ � ���� --

                if cfg.other.admlvl > 1 and nick ~= mynick then

                    if not (punkey.re.id or punkey.warn.id or punkey.ban.id or punkey.prison.id or punkey.auninvite.id or punkey.sban.id or punkey.pspawn.id or punkey.addabl.id) then

                        if text:match('^re %d+') or text:match('^/re %d+') then
                            if sampIsPlayerConnected(tonumber(text:match('re (%d+)'))) then
                                if not checkIntable(adminslist, sampGetPlayerNickname(tonumber(text:match('re (%d+)')))) then
                                    punkey.re.id = text:match('re (%d+)')
                                    punkey.re.nick = nick
                                    punkey.delay = os.time()
                                    atext(('������������� %s [%s] ������ ����� � ������ �� ������� %s [%s]'):format(nick, id, sampGetPlayerNickname(punkey.re.id), punkey.re.id))
                                    atext(("������� {66FF00}%s{FFFFFF} ��� ������������� ��� {66FF00}%s{ffffff} ��� ������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                                end
                            end
                        end

                        if text:match('^warn %d+ %d+ .+') or text:match('^/warn %d+ %d+ .+') then
                            if sampIsPlayerConnected(tonumber(text:match('warn (%d+) %d+ .+'))) then
                                if not checkIntable(adminslist, sampGetPlayerNickname(tonumber(text:match('warn (%d+) %d+ .+')))) then
                                    punkey.warn.id, punkey.warn.day, punkey.warn.reason = text:match('warn (%d+) (%d+) (.+)')
                                    punkey.warn.admin = nick
                                    punkey.delay = os.time()
                                    atext(("������������� %s [%s] ����� ��������� ������ %s [%s] �� �������: %s"):format(nick, id, sampGetPlayerNickname(punkey.warn.id), punkey.warn.id, punkey.warn.reason))
                                    atext(("������� {66FF00}%s{FFFFFF} ��� ������������� ��� {66FF00}%s{ffffff} ��� ������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                                end
                            end
                        end

                        if text:match('^ban %d+ .+') or text:match('^/ban %d+ .+') then
                            if sampIsPlayerConnected(tonumber(text:match('ban (%d+) .+'))) then
                                if not checkIntable(adminslist, sampGetPlayerNickname(tonumber(text:match('ban (%d+) .+')))) then
                                    punkey.ban.id, punkey.ban.reason = text:match('ban (%d+) (.+)')
                                    punkey.ban.admin = nick
                                    punkey.delay = os.time()
                                    atext(("������������� %s [%s] ����� �������� ������ %s [%s] �� �������: %s"):format(nick, id, sampGetPlayerNickname(punkey.ban.id), punkey.ban.id, punkey.ban.reason))
                                    atext(("������� {66FF00}%s{FFFFFF} ��� ������������� ��� {66FF00}%s{ffffff} ��� ������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                                end
                            end
                        end

                        if text:match('^prison %d+ %d+ .+') or text:match('^/prison %d+ %d+ .+') then
                            if sampIsPlayerConnected(tonumber(text:match('prison (%d+) %d+ .+'))) then
                                if not checkIntable(adminslist, sampGetPlayerNickname(tonumber(text:match('prison (%d+) %d+ .+')))) then
                                    punkey.prison.id, punkey.prison.day, punkey.prison.reason = text:match('prison (%d+) (%d+) (.+)')
                                    punkey.prison.admin = nick
                                    punkey.delay = os.time()
                                    atext(("������������� %s [%s] ����� �������� � ������ ������ %s [%s] �� �������: %s"):format(nick, id, sampGetPlayerNickname(punkey.prison.id), punkey.prison.id, punkey.prison.reason))
                                    atext(("������� {66FF00}%s{FFFFFF} ��� ������������� ��� {66FF00}%s{ffffff} ��� ������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                                end
                            end
                        end

                        if text:match('^pspawn %d+') or text:match('^/pspawn %d+') then
                            if sampIsPlayerConnected(tonumber(text:match('pspawn (%d+)'))) then
                                punkey.pspawn.id = text:match('pspawn (%d+)')
                                punkey.pspawn.admin = nick
                                punkey.delay = os.time()
                                atext(("������������� %s [%s] ����� ���������� ������ %s [%s]"):format(nick, id, sampGetPlayerNickname(punkey.pspawn.id), punkey.pspawn.id))
                                atext(("������� {66FF00}%s{FFFFFF} ��� ������������� ��� {66FF00}%s{ffffff} ��� ������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                            end
                        end

                        if cfg.other.admlvl >= 3 then

                            if text:match("^/addabl %d+ %d+ %d+ .+") or text:match("^addabl %d+ %d+ %d+ .+") then
                                if sampIsPlayerConnected(tonumber(text:match("addabl (%d+) %d+ %d+ .+"))) then
                                    if not checkIntable(adminslist, sampGetPlayerNickname(tonumber(text:match("addabl (%d+) %d+ %d+ .+")))) then
                                        punkey.addabl.id, punkey.addabl.day, punkey.addabl.group, punkey.addabl.reason = text:match("addabl (%d+) (%d+) (%d+) (.+)")
                                        punkey.addabl.admin = nick
                                        punkey.delay = os.time()
                                        atext(("������������� %s [%s] ����� ������ �� ������ %s [%s]. ������: %s. �������: %s"):format(nick, id, sampGetPlayerNickname(punkey.addabl.id), punkey.addabl.id, punkey.addabl.group, punkey.addabl.reason))
                                        atext(("������� {66FF00}%s{FFFFFF} ��� ������������� ��� {66FF00}%s{ffffff} ��� ������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                                    end
                                end
                            end

                        end

                        if cfg.other.admlvl >= 4 then

                            if text:match('^auninvite %d+ .+') or text:match('^/auninvite %d+ .+') then
                                if sampIsPlayerConnected(tonumber(text:match('auninvite (%d+) .+'))) then
                                    punkey.auninvite.id, punkey.auninvite.reason = text:match('auninvite (%d+) (.+)')
                                    punkey.auninvite.admin = nick
                                    punkey.delay = os.time()
                                    atext(("������������� %s [%s] ����� ������� ������ %s [%s] �� �������: %s"):format(nick, id, sampGetPlayerNickname(punkey.auninvite.id), punkey.auninvite.id, punkey.auninvite.reason))
                                    atext(("������� {66FF00}%s{FFFFFF} ��� ������������� ��� {66FF00}%s{ffffff} ��� ������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                                end
                            end

                            if text:match('^sban %d+ .+') or text:match('^/sban %d+ .+') then
                                if sampIsPlayerConnected(tonumber(text:match('sban (%d+) .+'))) then
                                    if not checkIntable(adminslist, sampGetPlayerNickname(tonumber(text:match('sban (%d+) .+')))) then
                                        punkey.sban.id, punkey.sban.reason = text:match('sban (%d+) (.+)')
                                        punkey.sban.admin = nick
                                        punkey.delay = os.time()
                                        atext(("������������� %s [%s] ����� ���� �������� ������ %s [%s] �� �������: %s"):format(nick, id, sampGetPlayerNickname(punkey.sban.id), punkey.sban.id, punkey.sban.reason))
                                        atext(("������� {66FF00}%s{FFFFFF} ��� ������������� ��� {66FF00}%s{ffffff} ��� ������"):format(table.concat(rkeys.getKeysName(config_keys.punaccept.v), " + "), table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                                    end
                                end
                            end

                        end

                    else
                        atext(("� ��� ���� �������� ������ �� ������ ���������. �� ������ �������� ��� ����� {66FF00}%s{FFFFFF}."):format(table.concat(rkeys.getKeysName(config_keys.pundeny.v), " + ")))
                    end
                end

            end

        end

    end
end

function punaccept()

    if punkey.pspawn.id then
        sampSendChat(("/pspawn %s"):format(punkey.pspawn.id))
        punkey.pspawn.id, punkey.pspawn.nick, punkey.delay = nil, nil, nil
    end

    if punkey.re.id then
        sampSendChat(('/re %s'):format(punkey.re.id))
        punkey.re.id, punkey.re.nick, punkey.delay = nil, nil
    end

    if punkey.prison.id then
        local admnick, admfam = punkey.prison.admin:match('(.+)_(.+)')
        sampSendChat(('/prison %s %s %s � %s.%s'):format(punkey.prison.id, punkey.prison.day, punkey.prison.reason, admnick:sub(1,1), admfam))
        punkey.prison.id, punkey.prison.day, punkey.prison.reason, punkey.prison.admin, punkey.delay = nil, nil, nil, nil, nil
    end

    if punkey.warn.id then
        local admnick, admfam = punkey.warn.admin:match('(.+)_(.+)')
        sampSendChat(('/warn %s %s %s � %s.%s'):format(punkey.warn.id, punkey.warn.day, punkey.warn.reason, admnick:sub(1,1), admfam))
        punkey.warn.id, punkey.warn.day, punkey.warn.reason, punkey.warn.admin, punkey.delay = nil, nil, nil, nil, nil
    end

    if punkey.ban.id then
        local admnick, admfam = punkey.ban.admin:match('(.+)_(.+)')
        sampSendChat(('/ban %s %s � %s.%s'):format(punkey.ban.id, punkey.ban.reason, admnick:sub(1,1), admfam))
        punkey.ban.id, punkey.ban.reason, punkey.ban.admin, punkey.delay = nil, nil, nil, nil
    end

    if punkey.sban.id then
        local admnick, admfam = punkey.sban.admin:match('(.+)_(.+)')
        sampSendChat(('/sban %s %s � %s.%s'):format(punkey.sban.id, punkey.sban.reason, admnick:sub(1,1), admfam))
        punkey.sban.id, punkey.sban.reason, punkey.sban.admin, punkey.delay = nil, nil, nil, nil
    end

    if punkey.auninvite.id then
        local admnick, admfam = punkey.auninvite.admin:match('(.+)_(.+)')
        sampSendChat(('/auninvite %s %s � %s.%s'):format(punkey.auninvite.id, punkey.auninvite.reason, admnick:sub(1,1), admfam))
        punkey.auninvite.id, punkey.auninvite.reason, punkey.auninvite.admin, punkey.delay = nil, nil, nil, nil
    end

    if punkey.addabl.id then
        local admnick, admfam = punkey.addabl.admin:match('(.+)_(.+)')
        sampSendChat(("/addabl %s %s %s %s � %s.%s"):format(punkey.addabl.id, punkey.addabl.day, punkey.addabl.group, punkey.addabl.reason, admnick:sub(1,1), admfam))
        punkey.addabl.id, punkey.addabl.day, punkey.addabl.group, punkey.addabl.reason, punkey.addabl.admin, punkey.delay = nil, nil, nil, nil, nil, nil
    end

end

function pundeny()
    if punkey.re.id or punkey.warn.id or punkey.ban.id or punkey.prison.id or punkey.auninvite.id or punkey.sban.id or punkey.pspawn.id or punkey.addabl.id then
        punkey = {warn = {}, ban = {}, prison = {}, re = {}, sban = {}, auninvite = {}, pspawn = {}, addabl = {}}
        atext('������ ��������� ��������')
    end
end

function whon()
    while true do wait(0)
        if sampGetGamestate() ~= 3 then
            while not sampIsLocalPlayerSpawned() do wait(0) end
            nameTagOff()
        end
    end
end

function vehs(pam)
    local vtext = ''
    if #pam == 0 then 
        for k, v in pairs(tCarsName) do
            vtext = ("%s%s\t%s\n"):format(vtext, 399+k, v)
        end
        sampShowDialog(323211,"{FFFFFF}ID �����","{ffffff}ID\t{fffffF}��������\n"..vtext,'x',_,5)
        atext("�������: /vehs [��������]")
    else
        for k, v in pairs(tCarsName) do
            if string.rlower(v):find(string.rlower(pam)) then
                atext(("[%s] %s"):format(399+k, v))
            end
        end
    end
end

function veh(pam)
    local params = string.split(pam, " ", 3)
    if #params < 1 then
        atext("�������: /veh [id/��������] [����1(�� �����������)] [����2(�� �����������)]")
    else
        if params[2] == nil then params[2] = 1 end
        if params[3] == nil then params[3] = params[2] end
        local id = tonumber(params[1])
        if id ~= nil then
            sampSendChat(("/veh %s %s %s"):format(params[1], params[2], params[3]))
        else
            for k, v in pairs(tCarsName) do
                if string.rlower(v):find(string.rlower(params[1])) then
                    local id = 399+k
                    sampSendChat(("/veh %s %s %s"):format(id, params[2], params[3]))
                    break
                end
            end
        end
    end
end

function ml(pam)
    local params = string.split(pam, " ", 2)
    if #params < 1 then
        atext('�������: /ml [id] [id �������(�� �����������)]')
    else
        local id = tonumber(params[1])
        if id == nil then
            atext('�������: /ml [id] [id �������(�� �����������)]')
        else
            if sampIsPlayerConnectedFixed(id) then
                if params[2] ~= nil then
                    local frak = tonumber(params[2])
                    if frak ~= nil then
                        sampSendChat(("/makeleader %s %s"):format(id, frak))
                    else
                        lua_thread.create(function()
                            sampShowDialog(23145,("{ffffff}������ ������� ������: {66FF00}%s [%s]"):format(sampGetPlayerNickname(id), id),'LSPD\nFBI\nSFA\nLCN\nYakuza\nMayor\nSFN\nSFPD\nInstructors\nBallas\nVagos\nRM\nGrove\nLSN\nAztec\nRifa\nLVA\nLVN\nLVPD\nHospital\nMongols\nWarlocks\nPagans','�','x',2)
                            while sampIsDialogActive(23145) do wait(0) end
                            local result, button, list, text = sampHasDialogRespond(23145)
                            if result then
                                if button == 1 then
                                    local fid = {[0] = 1, 2, 3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 24, 26, 29} 
                                    local frac = fid[list] 
                                    if frac ~= nil then 
                                        sampSendChat(("/makeleader %s %s"):format(id, frac))
                                    end
                                end
                            end
                        end)
                    end
                else
                    lua_thread.create(function()
                        sampShowDialog(23145,("{ffffff}������ ������� ������: {66FF00}%s [%s]"):format(sampGetPlayerNickname(id), id),'LSPD\nFBI\nSFA\nLCN\nYakuza\nMayor\nSFN\nSFPD\nInstructors\nBallas\nVagos\nRM\nGrove\nLSN\nAztec\nRifa\nLVA\nLVN\nLVPD\nHospital\nMongols\nWarlocks\nPagans','�','x',2)
                        while sampIsDialogActive(23145) do wait(0) end
                        local result, button, list, text = sampHasDialogRespond(23145)
                        if result then
                            if button == 1 then
                                local fid = {[0] = 1, 2, 3, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 24, 26, 29} 
                                local frac = fid[list] 
                                if frac ~= nil then 
                                    sampSendChat(("/makeleader %s %s"):format(id, frac))
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
end

function gip(pam)
    local id = tonumber(pam)
    if #pam ~= 0 then
        if id ~= nil then
            if sampIsPlayerConnectedFixed(id) then
                sampSendChat('/getip '..sampGetPlayerNickname(id))
            else
                sampSendChat('/agetip ' ..id)
            end
        else
            local gid = sampGetPlayerIdByNickname(pam)
            if gid ~= nil then
                sampSendChat('/getip '..gid)
            else
                sampSendChat('/agetip '..pam)
            end
        end
    else
        atext('�������: /gip [id/nick]')
    end
end

function aunv(pam)
    local params = string.split(pam, " ", 2)
    if #params < 2 then
        atext("�������: /aunv [id] [�������]")
    else
        local id = tonumber(params[1])
        if id == nil then
            atext("�������: /aunv [id] [�������]")
        else
            if sampIsPlayerConnectedFixed(id) then
                sampSendChat(("/auninvite %s %s"):format(id, params[2]))
            else
                atext("����� �������")
            end
        end
    end
end

function checkB()
    if cfg.other.admlvl >=3 then
        lcheckb = lua_thread.create(function()
            ban.check = not ban.check
            if ban.check then
                atext("�������� ������")
                for line in io.lines('moonloader/Admin Tools/Check Banned/players.txt') do
                    for v in line:gmatch("%S+%s?$") do
                        if v ~= '[IP:' and not v:match("%d+.%d+.%d+.%d+%]") and v ~= '[R_IP:' then
                            if #v >= 3 then
                                ban.nick = v
                                ban.check = true
                                sampSendChat(("/banlog %s"):format(ban.nick))
                                while ban.check do wait(0) end
                                wait(cfg.other.delay)
                                break
                            end
                        end
                    end
                end
                atext("�������� ��������")
                ban.nick = nil
                ban.check = false
                ban.check = false
            else
                atext("�������� ��������")
                lcheckb:terminate()
                ban.nick = nil
                ban.check = false
            end
        end)
    else
        atext('������� �������� � 3 ��� �����������������')
    end
end

function autoal()
    lua_thread.create(function()
        while not sampIsLocalPlayerSpawned() do wait(0) end
        sampSendChat('/alogin')
    end)
end

function checkInTableChecker(table, nick)
    for k, v in ipairs(table) do
        if table[k]['nick'] == nick then return true, k end
    end
    return false, -1
end

function mnarko(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnectedFixed(id) then
            sampSendChat(("/addabl %s %s 4 ��������� � �����"):format(id, cfg.timers.mnarkotimer))
        else
            atext('����� �������')
        end
    else
        atext("�������: /mnarko [id]")
    end
end

function mcbug(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnectedFixed(id) then
            sampSendChat(("/addabl %s %s 4 ��� ��������"):format(id, cfg.timers.mcbugtimer))
        else
            atext('����� �������')
        end
    else
        atext("�������: /mcbug [id]")
    end
end

function ranks(pam)
    lua_thread.create(function()
        local t = {}
        for k, v in pairs(fraklist) do
            table.insert(t, k)
        end
        if #pam ~= 0 then
            if checkIntable(t, string.rupper(pam)) then
                for k,v in pairs(fraklist[string.rupper(pam)]) do
                    atext(("[%s] %s"):format(k, v))
                end
            else
                sampShowDialog(33121, '{66FF00}������ �������:', "{ffffff}"..table.concat(t, '\n'), 'x', _, 2)
                while sampIsDialogActive(33121) do wait(0) end
                local result, button, list, input = sampHasDialogRespond(33121)
                if result and button ==  1 then
                    local text = sampGetListboxItemText(list)
                    for k,v in pairs(fraklist[text]) do
                        atext(("[%s] %s"):format(k, v))
                    end
                end
            end
        else
            atext("�������: /ranks [�������]")
        end
    end)
end

function vkv(pam)
    local id = tonumber(pam)
    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
    if id ~= nil then
        if sampIsPlayerConnectedFixed(id) then
            sampSendChat(("/prison %s %s ����� ��� ��������"):format(id, cfg.timers.vkvtimer))
        else
            atext('����� �������')
        end
    else
        atext("�������: /vkv [id]")
    end
end

function oncapt()
    lua_thread.create(function()
        text = ("{ffffff}�����\t���-�� ����������\nGrove\t%s\nBallas\t%s\nRifa\t%s\nVagos\t%s\nAztec\t%s\n \n��������� �������\n���������� �������\n�������� �������"):format(#otletel.grove, #otletel.ballas, #otletel.rifa, #otletel.vagos, #otletel.aztec)
        sampShowDialog(2134, ("���������� | ���������: %s"):format(countstart and '�������' or '��������'), text, '�', 'x', 5)
        while sampIsDialogActive(2134) do wait(0) end
        local result, button, list, input = sampHasDialogRespond(2134)
        if result and button ==  1 then
            if list == 0 then
                otext = ''
                for k, v in pairs(otletel.grove) do otext = otext..v.."\n" end
                sampShowDialog(2135,"����������: Grove",otext,'x',_,2)
            elseif list == 1 then
                otext = ''
                for k, v in pairs(otletel.ballas) do otext = otext..v.."\n" end
                sampShowDialog(2135,"����������: Ballas",otext,'x',_,2)
            elseif list == 2 then
                otext = ''
                for k, v in pairs(otletel.rifa) do otext = otext..v.."\n" end
                sampShowDialog(2135,"����������: Rifa",otext,'x',_,2)
            elseif list == 3 then
                otext = ''
                for k, v in pairs(otletel.vagos) do otext = otext..v.."\n" end
                sampShowDialog(2135,"����������: Vagos",otext,'x',_,2)
            elseif list == 4 then
                otext = ''
                for k, v in pairs(otletel.aztec) do otext = otext..v.."\n" end
                sampShowDialog(2135,"����������: Aztec",otext,'x',_,2)
            elseif list == 6 then
                countstart = true
                atext("������ ���������� ��������.")
            elseif list == 7 then
                countstart = false
                atext("������ ���������� ���������.")
            elseif list == 8 then
                atext("������ ���������� �������.")
                otletel = {
                    grove = {},
                    ballas = {},
                    rifa = {},
                    vagos = {},
                    aztec = {}
                }
            end
        end
    end)
end

function otletfunc(text, color)
    if countstart then
        if color == -10270806 then
            if text:find("����� warn") or text:find("�������") then
                if string.rlower(text):find("grove") then
                    table.insert(otletel.grove, text)
                elseif string.rlower(text):find("ballas") then
                    table.insert(otletel.ballas, text)
                elseif string.rlower(text):find("rifa") then
                    table.insert(otletel.rifa, text)
                elseif string.rlower(text):find("aztec") then
                    table.insert(otletel.aztec, text)
                elseif string.rlower(text):find("vagos") then
                    table.insert(otletel.vagos, text)
                end
            end
        end
    end
end

function fly()
    local posX, posY, posZ = getCharCoordinates(playerPed)
    local angle = getCharHeading(playerPed)
    local cx, cy, cz = getActiveCameraCoordinates()
    local groundZ = getGroundZFor3dCoord(posX, posY, posZ)
    local speed = getCharSpeed(playerPed)
    local vecX, vecY, vecZ = getCharVelocity(playerPed)
    local boostX, boostY, boostZ = 0.0, 0.0, 0.0
    local rotation, upstream = 0.0, 0.0
  
    ----- ����������� �� Fly
    if recon.state then return end
    if funcsStatus.AirBrk then return end
    if isCharInAnyCar(PLAYER_PED) then return end
    if posX < -20000 or posX > 20000 or posY < -20000 or posY > 20000 or posZ < -20000 or posZ > 20000 then return end
    if not flyInfo.isASvailable then return end
    if not isPlayerPlaying() then return end
  
    ----- ����� �� �����
    if groundZ + 1.2 > posZ and groundZ - 1.2 < posZ then
        if flyInfo.fly_active == true then
            flyInfo.fly_active = false
            clearCharTasks(playerPed)
        end
        return
    end
  
    ----- ������ ����� ���������
    if not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() and not isGamePaused() then
        if isKeyDown(key.VK_W) then
            flyInfo.keySpeedState = flyInfo.speed_accelerate
        elseif isKeyDown(key.VK_S) then
            flyInfo.keySpeedState = flyInfo.speed_decelerate
        else
            flyInfo.keySpeedState = flyInfo.speed_none
        end
        if isKeyDown(key.VK_A) then
            flyInfo.keyStrafeState = flyInfo.strafe_left
            rotation = 6.0
        elseif isKeyDown(key.VK_D) then
            flyInfo.keyStrafeState = flyInfo.strafe_right
            rotation = 6.0
        elseif isKeyDown(key.VK_SPACE) then
            flyInfo.keyStrafeState = flyInfo.strafe_up
            upstream = 50.0
        else
            flyInfo.keyStrafeState = flyInfo.strafe_none
        end
    end
  
    ----- ��������� ��������
    if flyInfo.fly_active == false then
        flyInfo.fly_active = true
        flyInfo.lastKeyStrafeState = flyInfo.strafe_none
        if posZ - cz > 0 then
            boostZ = flyInfo.speed_none + 10.0
        else
            boostZ = (flyInfo.speed_none + 10.0) * -1
        end
        taskPlayAnimNonInterruptable(playerPed, "Swim_Tread", "SWIM", 4.0, 1, 0, 0, 0, -1)
    end
  
    ----- �������� �������� � ����������� �� ��������
    if flyInfo.keyStrafeState ~= flyInfo.lastKeyStrafeState or flyInfo.keySpeedState ~= flyInfo.lastKeySpeedState then
        flyInfo.lastKeyStrafeState = flyInfo.keyStrafeState
        flyInfo.lastKeySpeedState = flyInfo.keySpeedState
        if flyInfo.keySpeedState == flyInfo.speed_none then
            taskPlayAnimNonInterruptable(playerPed, "Swim_Breast", "SWIM", 4.0, 1, 0, 0, 0, -1)
        elseif flyInfo.keySpeedState == flyInfo.speed_accelerate then
            taskPlayAnimNonInterruptable(playerPed, "SWIM_crawl", "SWIM", 4.0, 1, 0, 0, 0, -1)
        elseif flyInfo.keySpeedState == flyInfo.speed_decelerate then
            if speed > 15.0 then
                taskPlayAnimNonInterruptable(playerPed, "FALL_skyDive", "PARACHUTE", 4.0, 1, 0, 0, 0, -1)
            else
                taskPlayAnimNonInterruptable(playerPed, "Swim_Tread", "SWIM", 4.0, 1, 0, 0, 0, -1)
            end
        end
    end
  
    ------ ��������� / ����������
    local time = tonumber(string.format("%.2f", os.clock()))
    if flyInfo.update < time - 0.01 then
        local chSpeed = flyInfo.keySpeedState - flyInfo.currentSpeed
        local chRotation = rotation - flyInfo.rotationSpeed
        local chUp = upstream - flyInfo.upSpeed
        flyInfo.rotationSpeed = flyInfo.rotationSpeed + (chRotation / 50)
        flyInfo.upSpeed = flyInfo.upSpeed + (chUp / 50)
        flyInfo.currentSpeed = flyInfo.currentSpeed + (chSpeed / 50)
        flyInfo.update = time
    end
  
    local coordsX = (posX - cx) * (boostX + flyInfo.currentSpeed)
    local coordsY = (posY - cy) * (boostY + flyInfo.currentSpeed)
    local coordsZ = ((posZ - cz) * (boostZ + flyInfo.currentSpeed)) + 0.3
  
    ----- ��������� �������� ��������� � ���������� �������� ���������
    local qx, qy, qz, qw = getCharQuaternion(playerPed)
    if flyInfo.keyStrafeState == flyInfo.strafe_left then
        local ang = angle + 90
        if ang >= 360.0 then ang = ang - 360.0 end
        local atX = math.sin(math.rad(-ang))
        local atY = math.cos(math.rad(-ang))
        if (coordsX > 0 and atX > 0) or (coordsX < 0 and atX < 0) then
            coordsX = coordsX + (atX * flyInfo.rotationSpeed)
        elseif (coordsX > 0 and atX < 0) or (coordsX < 0 and atX > 0) then
            coordsX = (coordsX - (atX * flyInfo.rotationSpeed)) * -1
        end 
        if (coordsY > 0 and atY > 0) or (coordsY < 0 and atY < 0) then
            coordsY = coordsY + (atY * flyInfo.rotationSpeed)
        elseif (coordsY > 0 and atY < 0) or (coordsY < 0 and atY > 0) then
            coordsY = (coordsY - (atY * flyInfo.rotationSpeed)) * -1
        end
    elseif flyInfo.keyStrafeState == flyInfo.strafe_right then
        local ang = angle - 90
        if ang >= 360.0 then ang = ang - 360.0 end
        local atX = math.sin(math.rad(-ang))
        local atY = math.cos(math.rad(-ang))
        if (coordsX > 0 and atX > 0) or (coordsX < 0 and atX < 0) then
            coordsX = coordsX + (atX * flyInfo.rotationSpeed)
        elseif (coordsX > 0 and atX < 0) or (coordsX < 0 and atX > 0) then
            coordsX = (coordsX - (atX * flyInfo.rotationSpeed)) * -1
        end 
        if (coordsY > 0 and atY > 0) or (coordsY < 0 and atY < 0) then
            coordsY = coordsY + (atY * flyInfo.rotationSpeed)
        elseif (coordsY > 0 and atY < 0) or (coordsY < 0 and atY > 0) then
                coordsY = (coordsY - (atY * flyInfo.rotationSpeed)) * -1
        end  
    end
    if flyInfo.keyStrafeState == flyInfo.strafe_up then
        coordsZ = flyInfo.upSpeed
    end
    if flyInfo.keySpeedState ~= flyInfo.speed_decelerate then
        if coordsZ > 1.0 then coordsZ = coordsZ * 1.5
        else coordsZ = coordsZ / 2 end
    end
    --setCharQuaternion(playerPed, qqx, qqy, qqz, qqw)
  
    ----- ������������� �������� ���������
    local zAngle = getHeadingFromVector2d(posX - cx, posY - cy)
    setCharHeading(playerPed, zAngle)
    setCharVelocity(playerPed, coordsX, coordsY, coordsZ)
end

function string.split(inputstr, sep, limit)
    if limit == nil then limit = 0 end
    if sep == nil then sep = "%s" end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        if i >= limit and limit > 0 then
            if t[i] == nil then
                t[i] = ""..str
            else
                t[i] = t[i]..sep..str
            end
        else
            t[i] = str
            i = i + 1
        end
    end
    return t
end

function sampIsPlayerConnectedFixed(id)
    local id = tonumber(id)
    local myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
    if sampIsPlayerConnected(id) or id == myid then 
        return true
    else
        return false 
    end
end

function rebuildUsers()
    checker.admins.online   = {} 
    checker.players.online  = {} 
    checker.temp.online     = {} 
    checker.leaders.online  = {}
    for k, v in pairs(checker) do
        local i = sampGetMaxPlayerId(false)
        while i ~= -1 do
            if sampIsPlayerConnectedFixed(i) then
                for k1, v1 in pairs(v.loaded) do
                    if type(v1) == 'string' then
                        if v1 == sampGetPlayerNickname(i) then
                            table.insert(checker.leaders.online, {nick = v1, id = i, frak = k1})
                        end
                    else
                        if v1.nick == sampGetPlayerNickname(i) then
                            table.insert(v.online, {nick = v1.nick, color = v1.color, id = i, text = v1.text})
                        end
                    end
                end
            end
            i = i -1
        end
        --[[for i = 0, sampGetMaxPlayerId(false) do
            if sampIsPlayerConnectedFixed(i) then
                for k1, v1 in pairs(v.loaded) do
                    if type(v1) == 'string' then
                        if v1 == sampGetPlayerNickname(i) then
                            table.insert(checker.leaders.online, {nick = v1, id = i, frak = k1})
                        end
                    else
                        if v1.nick == sampGetPlayerNickname(i) then
                            table.insert(v.online, {nick = v1.nick, color = v1.color, id = i, text = v1.text})
                        end
                    end
                end
            end
        end]]
    end
end

function txtLinesCounts(path)
    local t = 0
    for line in io.lines(path) do
        t = t + 1
    end
    return t
end

function loadUsers()
    --�������� txt ������
    if not doesFileExist('moonloader/config/Admin Tools/adminlist.txt') then io.open('moonloader/config/Admin Tools/adminlist.txt', 'w'):close() end
    if not doesFileExist('moonloader/config/Admin Tools/playerlist.txt') then io.open('moonloader/config/Admin Tools/playerlist.txt', 'w'):close() end
    --���������� �������
    if doesFileExist('moonloader/config/Admin Tools/admchecker.json') then
        local f = io.open('moonloader/config/Admin Tools/admchecker.json', 'r')
        if f then
            checker.admins.loaded = decodeJson(f:read('*a'))
            f:close()
        end
    end
    --���������� �������
    if doesFileExist('moonloader/config/Admin Tools/playerchecker.json') then
        local f = io.open('moonloader/config/Admin Tools/playerchecker.json', 'r')
        if f then
            checker.players.loaded = decodeJson(f:read('*a'))
            f:close()
        end
    end
    --���������� �������
    if doesFileExist('moonloader/config/Admin Tools/leaders.json') then
        local f = io.open('moonloader/config/Admin Tools/leaders.json', 'r')
        if f then
            checker.leaders.loaded = decodeJson(f:read("*a"))
            f:close()
        end
    end
    --���������� ������� �� txt �����
    if txtLinesCounts('moonloader/config/Admin Tools/adminlist.txt') > 0 then
        for line in io.lines('moonloader/config/Admin Tools/adminlist.txt') do
            table.insert(checker.admins.loaded, {
                nick = line,
                color = 'ffffff',
                text = ''
            })
        end
        saveData(checker.admins.loaded, 'moonloader/config/Admin Tools/admchecker.json')
        io.open('moonloader/config/Admin Tools/adminlist.txt', 'w'):close()
    end
    --���������� ������� �� txt �����
    if txtLinesCounts('moonloader/config/Admin Tools/playerlist.txt') > 0 then
        for line in io.lines('moonloader/config/Admin Tools/playerlist.txt') do
            table.insert(checker.players.loaded, {
                nick = line,
                color = 'ffffff',
                text = ''
            })
        end
        saveData(checker.players.loaded, 'moonloader/config/Admin Tools/playerchecker.json')
        io.open('moonloader/config/Admin Tools/playerlist.txt', 'w'):close()
    end
end

function addadm(pam)
    local params = string.split(pam, " ", 3)
    if #params < 1 then
        atext('�������: /addadm [id/nick] [color(������: FFFFFF)/-1] [����������]')
    else
        local connected = false
        local id = tonumber(params[1])
        local nick = tostring(params[1])
        if id ~= nil then
            if sampIsPlayerConnectedFixed(id) then nick = sampGetPlayerNickname(id) connected = true end
        else
            id = sampGetPlayerIdByNickname(nick)
            if id ~= nil and sampIsPlayerConnectedFixed(id) then connected = true end
        end
        if params[2] == nil then params[2] = "FFFFFF" end
        if params[3] == nil then params[3] = "" end
        if not isHex(params[2]) then params[3] = params[2] .. ' ' .. params[3]
            params[2] = 'FFFFFF'
        end
        local result, key = checkInTableChecker(checker.admins.loaded, nick)
        if result then
            if #params[3] > 0 then
                checker.admins.loaded[key].text = params[3]
            end
            checker.admins.loaded[key].color    = params[2]
            atext("���������� ���������")
        else 
            table.insert(checker.admins.loaded, {nick = nick, color = params[2], text = params[3]})
            atext(("����� {66FF00}%s%s{FFFFFF} �������� � ����� �������"):format(nick, connected and (" [%s]"):format(id) or "" ))
        end
        saveData(checker.admins.loaded, 'moonloader/config/Admin Tools/admchecker.json')
        rebuildUsers()
    end
end

function addplayer(pam)
    local params = string.split(pam, " ", 3)
    if #params < 1 then
        atext('�������: /addplayer [id/nick] [color(������: FFFFFF)/-1] [����������]')
    else
        local connected = false
        local id = tonumber(params[1])
        local nick = tostring(params[1])
        if id ~= nil then
            if sampIsPlayerConnectedFixed(id) then nick = sampGetPlayerNickname(id) connected = true end
        else
            id = sampGetPlayerIdByNickname(nick)
            if id ~= nil and sampIsPlayerConnectedFixed(id) then connected = true end
        end
        if params[2] == nil then params[2] = "FFFFFF" end
        if params[3] == nil then params[3] = "" end
        if not isHex(params[2]) then params[3] = params[2] .. ' ' .. params[3]
            params[2] = 'FFFFFF'
        end
        local result, key = checkInTableChecker(checker.players.loaded, nick)
        if result then
            if #params[3] > 0 then
                checker.players.loaded[key].text = params[3]
            end
            checker.players.loaded[key].color    = params[2]
            atext("���������� ���������")
        else 
            table.insert(checker.players.loaded, {nick = nick, color = params[2], text = params[3]})
            atext(("����� {66FF00}%s%s{FFFFFF} �������� � ����� �������"):format(nick, connected and (" [%s]"):format(id) or "" ))
        end
        saveData(checker.players.loaded, 'moonloader/config/Admin Tools/playerchecker.json')
        rebuildUsers()
    end
end

function addtemp(pam)
    local params = string.split(pam, " ", 3)
    if #params < 1 then
        atext('�������: /addtemp [id/nick] [color(������: FFFFFF)/-1] [����������]')
    else
        local connected = false
        local id = tonumber(params[1])
        local nick = tostring(params[1])
        if id ~= nil then
            if sampIsPlayerConnectedFixed(id) then nick = sampGetPlayerNickname(id) connected = true end
        else
            id = sampGetPlayerIdByNickname(nick)
            if id ~= nil and sampIsPlayerConnectedFixed(id) then connected = true end
        end
        if params[2] == nil then params[2] = "FFFFFF" end
        if params[3] == nil then params[3] = "" end
        if not isHex(params[2]) then params[3] = params[2] .. ' ' .. params[3]
            params[2] = 'FFFFFF'
        end
        local result, key = checkInTableChecker(checker.temp.loaded, nick)
        if result then
            if #params[3] > 0 then
                checker.temp.loaded[key].text = params[3]
            end
            checker.temp.loaded[key].color    = params[2]
            atext("���������� ���������")
        else 
            table.insert(checker.temp.loaded, {nick = nick, color = params[2], text = params[3]})
            atext(("����� {66FF00}%s%s{FFFFFF} �������� � ��������� �����"):format(nick, connected and (" [%s]"):format(id) or "" ))
        end
        rebuildUsers()
    end
end

function deladm(pam)
    local params = string.split(pam, " ", 1)
    if #params < 1 then
        atext("�������: /deladm [id/nick]")
    else
        local connected = false
        local id = tonumber(params[1])
        local nick = tostring(params[1])
        if id ~= nil then
            if sampIsPlayerConnectedFixed(id) then nick = sampGetPlayerNickname(id) connected = true end
        else
            id = sampGetPlayerIdByNickname(nick)
            if id ~= nil and sampIsPlayerConnectedFixed(id) then connected = true end
        end
        local result, key = checkInTableChecker(checker.admins.loaded, nick)
        if result then table.remove(checker.admins.loaded, key)
            atext(("����� {66FF00}%s%s{FFFFFF} ������ �� ������ �������"):format(nick, connected and (" [%s]"):format(id) or "" ))
            saveData(checker.admins.loaded, 'moonloader/config/Admin Tools/admchecker.json')
            rebuildUsers()
        else
            atext(("����� {66FF00}%s%s{FFFFFF} �� ��������� � ������ �������"):format(nick, connected and (" [%s]"):format(id) or "" ))
        end
    end
end

function delplayer(pam)
    local params = string.split(pam, " ", 1)
    if #params < 1 then
        atext("�������: /delplayer [id/nick]")
    else
        local connected = false
        local id = tonumber(params[1])
        local nick = tostring(params[1])
        if id ~= nil then
            if sampIsPlayerConnectedFixed(id) then nick = sampGetPlayerNickname(id) connected = true end
        else
            id = sampGetPlayerIdByNickname(nick)
            if id ~= nil and sampIsPlayerConnectedFixed(id) then connected = true end
        end
        local result, key = checkInTableChecker(checker.players.loaded, nick)
        if result then table.remove(checker.players.loaded, key)
            atext(("����� {66FF00}%s%s{FFFFFF} ������ �� ������ ��������"):format(nick, connected and (" [%s]"):format(id) or "" ))
            saveData(checker.players.loaded, 'moonloader/config/Admin Tools/playerchecker.json')
            rebuildUsers()
        else
            atext(("����� {66FF00}%s%s{FFFFFF} �� ��������� � ������ ��������"):format(nick, connected and (" [%s]"):format(id) or "" ))
        end
    end
end

function deltemp(pam)
    local params = string.split(pam, " ", 1)
    if #params < 1 then
        atext("�������: /deltemp [id/nick]")
    else
        local connected = false
        local id = tonumber(params[1])
        local nick = tostring(params[1])
        if id ~= nil then
            if sampIsPlayerConnectedFixed(id) then nick = sampGetPlayerNickname(id) connected = true end
        else
            id = sampGetPlayerIdByNickname(nick)
            if id ~= nil and sampIsPlayerConnectedFixed(id) then connected = true end
        end
        local result, key = checkInTableChecker(checker.temp.loaded, nick)
        if result then table.remove(checker.temp.loaded, key)
            atext(("����� {66FF00}%s%s{FFFFFF} ������ �� ���������� ������"):format(nick, connected and (" [%s]"):format(id) or "" ))
            rebuildUsers()
        else
            atext(("����� {66FF00}%s%s{FFFFFF} �� ��������� � ���������� ������"):format(nick, connected and (" [%s]"):format(id) or "" ))
        end
    end
end

function upd_checker()
    while true do wait(2000)
        rebuildUsers()
    end
end

function cleanStreamMemoryBuffer() --fix crash
    local h0 = callFunction(0x53C500, 2, 2, true, true)
    local h1 = callFunction(0x53C810, 1, 1, true)
    local h2 = callFunction(0x40CF80, 0, 0)
    local h3 = callFunction(0x4090A0, 0, 0)
    local h4 = callFunction(0x5A18B0, 0, 0)
    local h5 = callFunction(0x707770, 0, 0)
    local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
    requestCollision(pX, pY)
    loadScene(pX, pY, pZ)
end

function cameraRestorePatch(bool) --extra WS
	if bool then
		if not patch_cameraRestore then
			patch_cameraRestore1 = mem.read(0x5109AC, 1, true)
			patch_cameraRestore2 = mem.read(0x5109C5, 1, true)
			patch_cameraRestore3 = mem.read(0x5231A6, 1, true)
			patch_cameraRestore4 = mem.read(0x52322D, 1, true)
			patch_cameraRestore5 = mem.read(0x5233BA, 1, true)
		end
		mem.write(0x5109AC, 235, 1, true)
		mem.write(0x5109C5, 235, 1, true)
		mem.write(0x5231A6, 235, 1, true)
		mem.write(0x52322D, 235, 1, true)
		mem.write(0x5233BA, 235, 1, true)
	elseif patch_cameraRestore1 ~= nil then
		mem.write(0x5109AC, patch_cameraRestore1, 1, true)
		mem.write(0x5109C5, patch_cameraRestore2, 1, true)
		mem.write(0x5231A6, patch_cameraRestore3, 1, true)
		mem.write(0x52322D, patch_cameraRestore4, 1, true)
		mem.write(0x5233BA, patch_cameraRestore5, 1, true)
		patch_cameraRestore1 = nil
	end
end

function noRecoilDynamicCrosshair(bool) --no spread
	if bool then
		if not patch_noRecoilDynamicCrosshair then
			patch_noRecoilDynamicCrosshair = mem.read(0x00740460, 1, true)
		end
		mem.write(0x00740460, 0x90, 1, true)
	elseif patch_noRecoilDynamicCrosshair ~= nil then
		mem.write(0x00740460, patch_noRecoilDynamicCrosshair, 1, true)
		patch_noRecoilDynamicCrosshair = nil
	end
end

function unlimBullets(bool)
    if bool then 
        mem.write(0x969178, 1, 1, true)
    else
        mem.write(0x969178, 0, 1, true)
    end
end

function ocheckrangs(pam)

    lua_thread.create(function()

        ocheckf = {c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0}
        local fraks = {5, 6, 12, 13, 14, 15, 17, 18, 24, 26, 29}
        local gangs = {12, 13, 15, 17, 18}
        local mafia = {5, 6, 14}
        local biker = {24, 26, 29}

        local frak = tonumber(pam)
        local perebor = false

        if frak ~= nil then


            if checkIntable(fraks, frak) then

                ocheckf.state = true

                sampSendChat(("/offmembers %s"):format(frak))

            else

                atext("������� �������� ������ ��� ��������� �������:")
                atext("������ �������: "..table.concat(fraks, ", ")..".")

            end

        else

            if cfg.other.admlvl < 5 then

            atext("�������: /ocheckrangs [id ������� (���� �� �� 5 ���, ������������ ��� �����������, � ����� ������ ������� ���������)]")
            atext("����������: ���� �� �� 5 ��� �������, �� ������ ������ ��� �������� ��� ��������")

            else
                atext("�������: /ocheckrangs [id �������]")
                
            end

        end

        while not ocheckf.done do wait(0) end

        if ocheckf.error then atext("�� ������ ������ ��� �������� ��� �������� �����������") return end

        if checkIntable(gangs, frak) then

            if ocheckf.c8 > frakrang.Gangs.max_8 then atext(("�� ������� �%s ������� 8 ������. ������: %s / ������: %s"):format(frak, ocheckf.c8, frakrang.Gangs.max_8)) perebor = true end
            if ocheckf.c9 > frakrang.Gangs.max_9 then atext(("�� ������� �%s ������� 9 ������. ������: %s / ������: %s"):format(frak, ocheckf.c9, frakrang.Gangs.max_9)) perebor = true end
            
        elseif checkIntable(mafia, frak) then

            if ocheckf.c8 > frakrang.Mafia.max_8 then atext(("�� ������� �%s ������� 8 ������. ������: %s / ������: %s"):format(frak, ocheckf.c8, frakrang.Mafia.max_8)) perebor = true end
            if ocheckf.c9 > frakrang.Mafia.max_9 then atext(("�� ������� �%s ������� 9 ������. ������: %s / ������: %s"):format(frak, ocheckf.c9, frakrang.Mafia.max_9)) perebor = true end

        elseif checkIntable(biker, frak) then

            if ocheckf.c5 > frakrang.Bikers.max_5 then atext(("�� ������� �%s ������� 5 ������. ������: %s / ������: %s"):format(frak, ocheckf.c5, frakrang.Bikers.max_5)) perebor = true end
            if ocheckf.c6 > frakrang.Bikers.max_6 then atext(("�� ������� �%s ������� 6 ������. ������: %s / ������: %s"):format(frak, ocheckf.c6, frakrang.Bikers.max_6)) perebor = true end
            if ocheckf.c7 > frakrang.Bikers.max_7 then atext(("�� ������� �%s ������� 7 ������. ������: %s / ������: %s"):format(frak, ocheckf.c7, frakrang.Bikers.max_7)) perebor = true end
            if ocheckf.c8 > frakrang.Bikers.max_8 then atext(("�� ������� �%s ������� 8 ������. ������: %s / ������: %s"):format(frak, ocheckf.c8, frakrang.Bikers.max_8)) perebor = true end
            
        end

        if not perebor then atext(("�� ������� �%s ��� ��������� � ���-�������."):format(frak)) end

    end)

end

function TurnCamTo(coordX, coordY, coordZ)
    local camX, camY, camZ = getActiveCameraCoordinates()
    local vector = {
        fX = camX - coordX,
        fY = camY - coordY,
        fZ = camZ - coordZ
    }
    local AngleX = math.atan2(vector.fY, -vector.fX) - (math.pi / 2)
    local AngleZ = math.atan2(math.sqrt((vector.fX * vector.fX) + (vector.fY * vector.fY)), -vector.fZ)
    local FIXED_X = AngleX - (math.pi / 2 + 0.04)
    local FIXED_Z = AngleZ - (math.pi / 2 - 0.103)
    setCameraPositionUnfixed(-FIXED_Z, -FIXED_X)
end

function checkSklad()
    local isDownloaded = false
    local result
    
    atext("���� �������� ������..")
    httpRequest("https://script.google.com/macros/s/AKfycbwbUxndx1iUJlTinfdyy5_xCCKGqkWJFmjph35Qyza5tkspeQs/exec", nil, function(response, code, headers, status)
        if response then
            result = decodeJson(response)
            isDownloaded = true
        else
            isDownloaded = true
        end
    end)

    lua_thread.create(function()
        while not isDownloaded do wait(0) end
        if result then
            local text = "{FFFFFF}�����\t{FFFFFF}���-�� �����\nGrove\t"..result["GROVE"].."\nBallas\t"..result["BALLAS"].."\nVagos\t"..result["VAGOS"].."\nAztec\t"..result["AZTEC"].."\nRifa\t"..result["RIFA"]
            sampShowDialog(2281337, "���-�� ����� | {AE433D}�� �����", text, "�", "x", 5)
        else
            atext("��������� ������ ��������.")
        end
    end)
end