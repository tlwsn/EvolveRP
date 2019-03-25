--[[
  Îñòàëîñü: Ñäåëàòü âîçìîæíîñòü èçìåíÿòü îíëàéí è îòâåòû;
]]
script_name("Activity checker") 
script_author('Edward_Franklin')
script_version("1.28")
script_version_number(12854)
script_properties('work-in-pause')
script_url("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/activity.lua")
--------------------------------------------------------------------
require "lib.moonloader"
local inicfg = require 'inicfg'
local sampevents = require "lib.samp.events"
local encoding = require 'encoding'
encoding.default = 'CP1251'
local imgui = require 'imgui'
imgui.HotKey = require('imgui_addons').HotKey
imgui.ToggleButton = require('imgui_addons').ToggleButton
local u8 = encoding.UTF8
--------------------------------------------------------------------
local mainwindow = imgui.ImBool(false)
local weekonline = imgui.ImBool(false)
local punishments = imgui.ImBool(false)
local screenx, screeny = getScreenResolution()
local pInfo = inicfg.load({
  info = {
    day = "01.01.2019",
    dayOnline = 0,
    dayAFK = 0,
    dayPM = 0,
    weekPM = 0,
    thisWeek = 0,
    weekOnline = 0
  },
  weeks = {0,0,0,0,0,0,0},
  punish = {
  	ban = 0,
  	warn = 0,
  	kick = 0,
  	prison = 0,
  	mute = 0,
  	banip = 0,
  	rmute = 0,
  	jail = 0
  }
}, "activity-checker")

local sInfo = {
  updateAFK = 0,
  authTime = 0,
  lvlAdmin = 0,
  isALogin = false
}
local DEBUG_MODE = true
local dayName = {u8"Ïîíåäåëüíèê", u8"Âòîğíèê", u8"Ñğåäà", u8"×åòâåğã", u8"Ïÿòíèöà", u8"Ñóááîòà", u8"Âîñêğåñåíüå"}
local nick = ""
local playerid = -1
--------------------------------------------------------------------
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand("gip", cmd_gip)
    sampRegisterChatCommand('activitydebug', function()
      DEBUG_MODE = not DEBUG_MODE
      atext(("Debug mode %s"):format(DEBUG_MODE and "âêëş÷åí" or "îòêëş÷åí"))
    end)
    sampRegisterChatCommand('activity', function() mainwindow.v = not mainwindow.v end)
    --------------------=========----------------------
    if not doesDirectoryExist("moonloader\\config") then
      createDirectory("moonloader\\config")
    end
    if DEBUG_MODE == true then atext(("Ñêğèïò óñïåøíî çàãğóæåí. Âåğñèÿ: %s. Íîìåğ ñáîğêè: %s"):format(thisScript().version, thisScript().version_num)) end
    local day = os.date("%d.%m.%y")
    if pInfo.info.thisWeek == 0 then pInfo.info.thisWeek = os.date("%W") end
    if pInfo.info.day ~= day and tonumber(os.date("%H")) > 4 then
      local weeknum = dateToWeekNumber(pInfo.info.day)
      if weeknum == 0 then weeknum = 7 end
      pInfo.weeks[weeknum] = pInfo.info.dayOnline
      atext(string.format("Íà÷àëñÿ íîâûé äåíü. Èòîãè ïğåäûäóùåãî äíÿ (%s): %s", pInfo.info.day, secToTime(pInfo.info.dayOnline)))
      -----------------
      if tonumber(pInfo.info.thisWeek) ~= tonumber(os.date("%W")) then
        atext("Íà÷àëàñü íîâàÿ íåäåëÿ. Èòîãè ïğåäûäóùåé íåäåëè: "..secToTime(pInfo.info.weekOnline))
        for key in pairs(pInfo) do
          for k in pairs(pInfo[key]) do
            pInfo[key][k] = 0
          end
        end
        pInfo.info.thisWeek = os.date("%W")
      end
      pInfo.info.day = day
      pInfo.info.dayPM = 0
      pInfo.info.dayOnline = 0
      pInfo.info.dayAFK = 0
    end
    if sampGetGamestate() == 3 then
      sInfo.isALogin = true
    end
    --------------------=========----------------------
    while not sampIsLocalPlayerSpawned() do wait(0) end
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    sInfo.authTime = os.date("%d.%m.%y %H:%M:%S")
    sInfo.updateAFK = os.time()
    playerid = myid
    nick = sampGetPlayerNickname(myid)
    calculateOnline()
    while true do wait(0)
      if sampGetGamestate() ~= 3 then
        sInfo.isALogin = false
      end
      imgui.Process = mainwindow.v
    end
end

function calculateOnline()
  lua_thread.create(function()
    local updatecount = 0
    while true do wait(1000)
      if sInfo.isALogin == true then
        pInfo.info.dayOnline = pInfo.info.dayOnline + 1
        pInfo.info.weekOnline = pInfo.info.weekOnline + 1
        pInfo.info.dayAFK = pInfo.info.dayAFK + (os.time() - sInfo.updateAFK - 1)
        if updatecount >= 10 then inicfg.save(pInfo, "activity-checker"); updatecount = 0 end
        updatecount = updatecount + 1
      end
      sInfo.updateAFK = os.time()
    end  
  end)
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

function imgui.OnDrawFrame()
  if mainwindow.v then
    imgui.ShowCursor = true
    local btn_size = imgui.ImVec2(-0.1, 0)
    local ImVec4 = imgui.ImVec4
    local spacing = 165.0
    imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
    imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.Begin('Activity Helper', mainwindow, imgui.WindowFlags.NoResize)
    ---------
    imgui.Text(u8"Íèê:"); imgui.SameLine(spacing); imgui.Text(('%s[%d]'):format(nick, playerid))
    imgui.Text(u8"Àâòîğèçàöèÿ â ALogin:"); imgui.SameLine(spacing); imgui.TextColored(ImVec4(0, 49, 245, 1), string.format('%s', sInfo.isALogin == true and u8"Àâòîğèçèğîâàí" or u8"Îòñóòñòâóåò"))
    if sInfo.isALogin == true then
      imgui.Text(u8"Óğîâåíü ìîäåğàòîğà:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(sInfo.lvlAdmin))
    end
    imgui.Text(u8"Âğåìÿ àâòîğèçàöèè:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(sInfo.authTime))
    imgui.Separator()
    imgui.Text(u8"Îòûãğàíî çà ñåãîäíÿ:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.dayOnline)))
    imgui.Text(u8"AFK çà ñåãîäíÿ:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.dayAFK)))
    imgui.Text(u8"Îòâåòîâ çà ñåãîäíÿ:"); imgui.SameLine(spacing); imgui.Text(('%d'):format(pInfo.info.dayPM))
    imgui.Separator()
    imgui.Text(u8"Îòûãğàíî çà íåäåëş:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.weekOnline)))
    imgui.Text(u8"Îòâåòîâ çà íåäåëş:"); imgui.SameLine(spacing); imgui.Text(('%d'):format(pInfo.info.weekPM))
    imgui.Separator()
    if imgui.Button(u8 'Ñòàòèñòèêà ïî äíÿì', btn_size) then weekonline.v = not weekonline.v end
    if imgui.Button(u8 'Ñòàòèñòèêà íàêàçàíèé', btn_size) then punishments.v = not punishments.v end
    if imgui.Button(u8 'Ïåğåçàãğóçèòü ñêğèïò', btn_size) then
      atext("Ïåğåçàãğóæàåìñÿ...")
      showCursor(false)
      thisScript():reload()
    end
    if imgui.Button(u8 'Ñîîáùèòü îá îøèáêå', btn_size) then
      atext("Ñâÿçü ñ ğàçğàáî÷èêîì:")
      atext("VK - https://vk.com/the_redx | Discord - redx#0763")
    end
    --imgui.PopStyleColor() -- êğàøèò
    imgui.End()
    ----------------------
    if weekonline.v then
      imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8 'Ñòàòèñòèêà ïî äíÿì', weekonline, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
      local daynumber = dateToWeekNumber(os.date("%d.%m.%y"))
      if daynumber == 0 then daynumber = 7 end
      for key, value in ipairs(pInfo.weeks) do
        --[[local colour = ""
        if daynumber > 0 then
          if daynumber < key then colour = "ec3737"
          elseif daynumber == key then colour = "FFFFFF"
          else colour = "00BF80" end
        else
          if daynumber == 0 and key == 7 then colour = "FFFFFF"
          else colour = "00BF80" end
        end]]
        imgui.Text(dayName[key]); imgui.SameLine(spacing); imgui.TextColored(ImVec4(0, 49, 245, 1), ('%s'):format(daynumber == key and secToTime(pInfo.info.dayOnline) or secToTime(value)))
      end
      imgui.End()
    end
    if punishments.v then
      imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
      imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
      imgui.Begin(u8 'Ñòàòèñòèêà íàêàçàíèé', punishments, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
      local i = 1
      for key, value in pairs(pInfo.punish) do
        imgui.Text(key); imgui.SameLine(spacing); imgui.Text(value)
        i = i + 1
      end
      imgui.End()
    end
  end
end

------------------------ CMD'S ------------------------
function cmd_gip(params)
  if #params == 0 then
    sampAddChatMessage("Ââåäèòå /gip [playerid / nick]", -1)
    return
  end
  local paramid = tonumber(params)
  if paramid ~= nil then
    sampSendChat("/getip "..params)
  else
    sampSendChat("/agetip "..params)
  end  
end

------------------------ HOOKS ------------------------
function onScriptTerminate(script, quitGame)
  if script == thisScript() then
    inicfg.save(pInfo, "activity-checker")
  end
end

function sampevents.onServerMessage(color, text)
  if text:match(nick) then
    if text:match("OffBan") or text:match("çàáàíèë (.+) Ïğè÷èíà") or text:match("SBan") or text:match("IOffBan") then
      pInfo.punish.ban = pInfo.punish.ban + 1
    end
    if text:match("âûäàë warn") or text:match("ïîëó÷èë ïğåäóïğåæäåíèå äî") then
      pInfo.punish.warn = pInfo.punish.warn + 1
    end
    if text:match("êèêíóë .+ Ïğè÷èíà") then
      pInfo.punish.kick = pInfo.punish.kick + 1
    end
    if text:match("ïîìåñòèë â ÄåÌîğãàí") or text:match("ïîñàæåí â prison") then
      pInfo.punish.prison = pInfo.punish.prison + 1
    end
    if text:match("çàáëîêèğîâàë ÷àò èãğîêà") or text:match("OffMute") then
      pInfo.punish.mute = pInfo.punish.mute + 1
    end
    if text:match("çàáàíèë IP") then
      pInfo.punish.banip = pInfo.punish.banip + 1
    end
    if text:match("âûäàë çàòû÷êó íà ğåïîğò") then
      pInfo.punish.rmute = pInfo.punish.rmute + 1
    end
  end
  if text:match("Âû ïîñàäèëè .+ â òşğüìó") then
  	pInfo.punish.jail = pInfo.punish.jail + 1
  end
  if text:match("Âû àâòîğèçèğîâàëèñü êàê ìîäåğàòîğ .+ óğîâíÿ") then
    sInfo.lvlAdmin = tonumber(text:match("Âû àâòîğèçèğîâàëèñü êàê ìîäåğàòîğ (.+) óğîâíÿ"))
    sInfo.isALogin = true
    sInfo.sessionStart = os.time()
  end
  if text:match("Îòâåò îò "..nick) then
    pInfo.info.dayPM = pInfo.info.dayPM + 1
    pInfo.info.weekPM = pInfo.info.weekPM + 1
  end
  if text:match("Âğåìÿ online çà òåêóùèé äåíü") then
    sampAddChatMessage(string.format(" Âğåìÿ online çà íåäåëş - %s (Áåç ó÷åòà ÀÔÊ) | Îòâåòîâ: %d", secToTime(pInfo.info.weekOnline), pInfo.info.weekPM), 0xCCCCCC)
  end
end

------------------------ SECONDARY FUNCTIONS ------------------------
function checkIntable(t, key)
  for k, v in pairs(t) do
      if v == key then return true end
  end
  return false
end

function dateToWeekNumber(date) -- Start on Sunday(0)
  local wsplit = string.split(date, ".")
  local day = tonumber(wsplit[1])
  local month = tonumber(wsplit[2])
  local year = tonumber(wsplit[3])
  local a = math.floor((14 - month) / 12)
  local y = year - a
  local m = month + 12 * a - 2
  return math.floor((day + y + math.floor(y / 4) - math.floor(y / 100) + math.floor(y / 400) + (31 * m) / 12) % 7)
  -- Îòâåò ìîæåò áûòü íåïğàâèëüíûé ò.ê. ôóíêöèÿ äåëàëàñü â 2 íî÷è ïî ôîğìóëå èç Âèêèïåäèè
end

function secToTime(sec)
  local hour, minute, second = sec / 3600, math.floor(sec / 60), sec % 60
  return string.format("%02d:%02d:%02d", math.floor(hour) ,  minute - (math.floor(hour) * 60), second)
  -- Äîäåëàòü äèíàìè÷åñêîå èçìåíåíèå äàò
end

function string.split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

function atext(text)
  sampAddChatMessage("Activity Helper | {FFFFFF}"..text, 0x954F4F)
end

------------------------ HLAM ------------------------
--[[
function getLocalPlayerId()
  local _, id = sampGetPlayerIdByCharHandle(playerPed)
  return id
end

function getCurrentNickname(id)
  local _, myId = sampGetPlayerIdByCharHandle(playerPed)
  if id == nil then
    id = myId
  end
  if sampIsPlayerConnected(id) or id == myId then
    local name = sampGetPlayerNickname(id)
    local prefix = nil
    if string.find(name, "^%[GW%]") or string.find(name, "^%[DM%]") or string.find(name, "^%[TR%]") or string.find(name, "^%[LC%]") then
      prefix = string.match(name, "^%[([A-Z]+)%].*")
      name = string.gsub(name, "^%[[A-Z]+%]", "")
    end
    return name, prefix
  end
  return ""
end

function getDistanceToPlayer(playerId) 
  if sampIsPlayerConnected(playerId) then
    local result, ped = sampGetCharHandleBySampPlayerId(playerId)
    if result and doesCharExist(ped) then
      local myX, myY, myZ = getCharCoordinates(playerPed)
      local playerX, playerY, playerZ = getCharCoordinates(ped)
      return getDistanceBetweenCoords3d(myX, myY, myZ, playerX, playerY, playerZ)
    end
  end
  return -1
end

function ARGBtoRGB(color)
    local a = bit.band(bit.rshift(color, 24), 0xFF)
    local r = bit.band(bit.rshift(color, 16), 0xFF)
    local g = bit.band(bit.rshift(color, 8), 0xFF)
    local b = bit.band(color, 0xFF)
    local rgb = b
    rgb = bit.bor(rgb, bit.lshift(g, 8))
    rgb = bit.bor(rgb, bit.lshift(r, 16))
    return rgb
end

function checkActivity()
  local zstring = "{ffffff}˜˜˜˜˜˜˜˜\t{FFFFFF}˜˜˜˜˜˜˜˜\n"
  zstring = zstring.."˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜ ˜˜ ˜˜˜˜ ˜˜˜˜˜˜\n"
  zstring = zstring.."˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜\n"
  zstring = zstring..string.format("˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜\t%s ˜˜˜˜˜˜ ˜˜˜˜˜\n", sInfo.sessionStart == 0 and "-" or (os.time() - sInfo.sessionStart))
  zstring = zstring..string.format("˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜\t%s\n", sInfo.authTime)
  zstring = zstring..string.format("˜˜˜˜˜˜˜˜˜˜˜ ˜ ALogin\t%s\n", sInfo.isALogin and "˜˜˜˜˜˜˜˜˜˜˜˜˜" or "˜˜˜˜˜˜˜˜˜˜˜")
  if sInfo.isALogin then
    zstring = zstring..string.format("˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜\t%s\n", sInfo.lvlAdmin)
  end  
  zstring = zstring..string.format("˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜\t%s\n", secToTime(pInfo.info.dayOnline))
  zstring = zstring..string.format("AFK ˜˜ ˜˜˜˜˜˜˜\t%s\n", sInfo.sessionStart == 0 and secToTime(pInfo.info.dayAFK) or secToTime(pInfo.info.dayAFK + (os.time() - sInfo.sessionStart - sInfo.onlineTime)))
  zstring = zstring..string.format("˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜˜\t%d\n", pInfo.info.dayPM)
  zstring = zstring..string.format("˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜\t%d\n", pInfo.info.weekPM)
  zstring = zstring..string.format("˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜\t%s\n", secToTime(pInfo.info.weekOnline))
  -------
  lua_thread.create(function()
    sampShowDialog(827453, string.format("{FFFFFF}˜˜˜˜˜˜˜˜˜˜ | {954F4F}%s", nick), zstring, "˜˜˜˜˜˜˜", "˜˜˜˜˜˜˜", DIALOG_STYLE_TABLIST_HEADERS)
    while sampIsDialogActive(827453) do wait(50) end
    local _, button, list, _ = sampHasDialogRespond(827453)
    if button == 1 and list == 0 then
      checkWeek()
    elseif button == 1 and list == 1 then
      checkPunishments()
    end
  end)
end

function checkPunishments()
  local zstring = "{FFFFFF}˜˜˜˜˜˜˜˜˜\t{FFFFFF}˜˜˜˜˜˜˜˜˜˜\n"
  local i = 1
  for key, value in pairs(pInfo.punish) do
    zstring = zstring..string.format("%s\t%s\n", key, value)
    i = i + 1
  end
  lua_thread.create(function()
    sampShowDialog(835163, string.format("{FFFFFF}˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜˜˜ | {954F4F}%s", nick), zstring, "˜˜˜˜˜˜˜", "˜˜˜˜˜", DIALOG_STYLE_TABLIST_HEADERS)
    while sampIsDialogActive(835163) do wait(50) end
    local _, button, _, _ = sampHasDialogRespond(835163)
    if button == 0 then
      checkActivity()
    end
  end)
end

function checkWeek()
  local daynumber = dateToWeekNumber(os.date("%d.%m.%y"))
  local i = 1
  local zstring = "{FFFFFF}˜˜˜˜\t{FFFFFF}˜˜˜˜˜˜\n"
  for key, value in pairs(pInfo.weeks) do
    local colour = ""
    if daynumber > 0 then
      if daynumber < i then colour = "ec3737"
      elseif daynumber == i then colour = "FFFFFF"
      else colour = "00BF80" end
    else
      if daynumber == 0 and i == 7 then colour = "FFFFFF"
      else colour = "00BF80" end
    end
    zstring = zstring..string.format("%s\t{%s}%s\n", dayName[i], colour, daynumber == i and secToTime(pInfo.info.dayOnline) or secToTime(value))
    i = i + 1
  end
  lua_thread.create(function()
    sampShowDialog(837763, string.format("{FFFFFF}˜˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜ ˜˜˜˜˜˜ | {954F4F}%s", nick), zstring, "˜˜˜˜˜˜˜", "˜˜˜˜˜", DIALOG_STYLE_TABLIST_HEADERS)
    while sampIsDialogActive(837763) do wait(50) end
    local _, button, _, _ = sampHasDialogRespond(837763)
    if button == 0 then
      checkActivity()
    end
  end)
end
]]