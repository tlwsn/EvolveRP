script_name("Activity checker") 
script_author('Edward_Franklin')
script_version("1.1")
script_properties('work-in-pause')
--------------------------------------------------------------------
require "lib.moonloader"
local inicfg = require 'inicfg'
local sampevents = require "lib.samp.events"
--------------------------------------------------------------------
local pInfo = inicfg.load({
  info = {
    day = "01.01.2019",
    dayOnline = 0,
    dayAFK = 0,
    dayPM = 0,
    weekPM = 0,
    weekOnline = 0
  },
  weeks = {
    Monday = 0,
    Tuesday = 0,
    Wednesday = 0,
    Thursday = 0,
    Friday = 0,
    Saturday = 0,
    Sunday = 0
  },
}, "activity-checker")

local sInfo = {
  sessionStart = 0,
  authTime = 0,
  lvlAdmin = 0,
  onlineTime = 0,
  isALogin = false
}
local nick = ""
local autoupdate = 0

--------------------------------------------------------------------
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand("activity", checkActivity)
    --------------------=========----------------------
    if not doesDirectoryExist("moonloader\\config") then
      createDirectory("moonloader\\config")
    end
    local day = os.date("%d.%m.%y")
    local weekday = os.date("%w")
    if pInfo.info.day ~= day and tonumber(os.date("%H")) > 4 then
      local weeknum = dateToWeekNumber(pInfo.info.day)
      -----------------
      if weeknum == 1 then pInfo.weeks.Monday = pInfo.info.dayOnline
      elseif weeknum == 2 then pInfo.weeks.Tuesday = pInfo.info.dayOnline
      elseif weeknum == 3 then pInfo.weeks.Wednesday = pInfo.info.dayOnline
      elseif weeknum == 4 then pInfo.weeks.Thursday = pInfo.info.dayOnline
      elseif weeknum == 5 then pInfo.weeks.Friday = pInfo.info.dayOnline
      elseif weeknum == 6 then pInfo.weeks.Saturday = pInfo.info.dayOnline
      elseif weeknum == 0 then pInfo.weeks.Sunday = pInfo.info.dayOnline end
      print(string.format("Начался новый день. Итог прошлого дня (%s): %s", pInfo.info.day, secToTime(pInfo.info.dayOnline)))
      -----------------
      if weeknum > tonumber(weekday) then
        print('Началась новая неделя. Итог прошлой недели: %s', secToTime(pInfo.info.weekOnline))
        pInfo.info.weekOnline = 0
        pInfo.info.weekPM = 0
        pInfo.weeks.Monday = 0
        pInfo.weeks.Tuesday = 0
        pInfo.weeks.Wednesday = 0
        pInfo.weeks.Thursday = 0
        pInfo.weeks.Friday = 0
        pInfo.weeks.Saturday = 0
        pInfo.weeks.Sunday = 0
      end
      pInfo.info.day = day
      pInfo.info.dayPM = 0
      pInfo.info.dayOnline = 0
      pInfo.info.dayAFK = 0
    end
    sInfo.sessionStart = os.time()
    sInfo.authTime = os.date("%d.%m.%y %H:%M:%S")
    --------------------=========----------------------
    while not sampIsLocalPlayerSpawned() do wait(0) end
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    nick = sampGetPlayerNickname(myid)
    while true do
      wait(1000)
      if sInfo.isALogin then
        pInfo.info.dayOnline = pInfo.info.dayOnline + 1
        pInfo.info.weekOnline = pInfo.info.weekOnline + 1
        sInfo.onlineTime = sInfo.onlineTime + 1
        autoupdate = autoupdate + 1
        if autoupdate >= 60 then
          if sInfo.sessionStart ~= 0 then
            pInfo.info.dayAFK = pInfo.info.dayAFK + (os.time() - sInfo.sessionStart - sInfo.onlineTime)
          end
          sInfo.onlineTime = 0
          sInfo.sessionStart = os.time()
          inicfg.save(pInfo, "activity-checker")
          autoupdate = 0
        end
      end
    end
end

function checkWeek()
  local daynumber = dateToWeekNumber(os.date("%d.%m.%y"))
  local colour = {}
  for i = 1, 7 do
    if daynumber > 0 then
      if daynumber < i then colour[i] = "ec3737"
      elseif daynumber == i then colour[i] = "FFFFFF"
      else colour[i] = "00BF80" end
    else
      if daynumber == 0 and i == 7 then colour[i] = "FFFFFF"
      else colour[i] = "00BF80" end
    end
  end
  local dayonline = pInfo.info.dayOnline + os.time() - sInfo.sessionStart
  local zstring = "{FFFFFF}День\t{FFFFFF}Онлайн\n"
  zstring = zstring..string.format("Понедельник\t{%s}%s\n", colour[1], daynumber == 1 and secToTime(dayonline) or secToTime(pInfo.weeks.Monday))
  zstring = zstring..string.format("Вторник\t{%s}%s\n", colour[2], daynumber == 2 and secToTime(dayonline) or secToTime(pInfo.weeks.Tuesday))
  zstring = zstring..string.format("Среда\t{%s}%s\n", colour[3], daynumber == 3 and secToTime(dayonline) or secToTime(pInfo.weeks.Wednesday))
  zstring = zstring..string.format("Четверг\t{%s}%s\n", colour[4], daynumber == 4 and secToTime(dayonline) or secToTime(pInfo.weeks.Thursday))
  zstring = zstring..string.format("Пятница\t{%s}%s\n", colour[5], daynumber == 5 and secToTime(dayonline) or secToTime(pInfo.weeks.Friday))
  zstring = zstring..string.format("Суббота\t{%s}%s\n", colour[6], daynumber == 6 and secToTime(dayonline) or secToTime(pInfo.weeks.Saturday))
  zstring = zstring..string.format("Воскресенье\t{%s}%s\n", colour[7], daynumber == 0 and secToTime(dayonline) or secToTime(pInfo.weeks.Sunday))
  sampShowDialog(837763, string.format("{FFFFFF}Активность по дням недели | {954F4F}%s", nick), zstring, "Закрыть", "", DIALOG_STYLE_TABLIST_HEADERS)
end

function checkActivity()
  local zstring = "{ffffff}Параметр\t{FFFFFF}Значение\n"
  zstring = zstring.."Просмотреть онлайн по дням недели\n"
  zstring = zstring..string.format("Последнее обновление\t%s секунд назад\n", os.time() - sInfo.sessionStart)
  zstring = zstring..string.format("Время авторизации\t%s\n", sInfo.authTime)
  zstring = zstring..string.format("Авторизация в ALogin\t%s\n", sInfo.isALogin and "Авторизирован" or "Отсутствует")
  if sInfo.isALogin then
    zstring = zstring..string.format("Уровень модератора\t%s\n", sInfo.lvlAdmin)
  end  
  zstring = zstring..string.format("Отыграно за сегодня\t%s\n", secToTime(pInfo.info.dayOnline))
  zstring = zstring..string.format(" - Из них в AFK\t%s\n", sInfo.sessionStart == 0 and secToTime(pInfo.info.dayAFK) or secToTime(pInfo.info.dayAFK + (os.time() - sInfo.sessionStart - sInfo.onlineTime)))
  zstring = zstring..string.format("Ответов за сегодня\t%d\n", pInfo.info.dayPM)
  zstring = zstring..string.format("Ответов за неделю\t%d\n", pInfo.info.weekPM)
  zstring = zstring..string.format("Отыграно за неделю\t%s\n", secToTime(pInfo.info.weekOnline))
  -------
  lua_thread.create(function()
    sampShowDialog(837453, string.format("{FFFFFF}Активность | {954F4F}%s", nick), zstring, "Закрыть", "", DIALOG_STYLE_TABLIST_HEADERS)
    while sampIsDialogActive(837453) do wait(50) end
    local _, button, list, _ = sampHasDialogRespond(837453)
    if button == 1 and list == 0 then
      checkWeek()
    end  
  end)
end

function onScriptTerminate(script, quitGame)
  if script == thisScript() then
    if sInfo.sessionStart ~= 0 then
      pInfo.info.dayAFK = pInfo.info.dayAFK + (os.time() - sInfo.sessionStart - sInfo.onlineTime)
    end
    inicfg.save(pInfo, "activity-checker")
  end
end

function sampevents.onServerMessage(color, text)
  if text:match("Вы авторизировались как модератор .+ уровня") then
    sInfo.lvlAdmin = tonumber(text:match("Вы авторизировались как модератор (.+) уровня"))
    sInfo.isALogin = true
  end
  if text:match("Ответ от "..nick) then
    pInfo.info.dayPM = pInfo.info.dayPM + 1
    pInfo.info.weekPM = pInfo.info.weekPM + 1
  end
  -- -- Время online за текущий день - 0:09 (Без учета АФК) | Ответов: 0
  if text:match("Время online за текущий день") then -- CP1251
    sampAddChatMessage(string.format(" Время online за неделю - %s (Без учета АФК) | Ответов: %d", secToTime(pInfo.info.weekOnline), pInfo.info.weekPM), 0xCCCCCC)
  end
end
--------------------------------------------------------------------
function dateToWeekNumber(date) -- Start on Sunday(0)
  --print(date)
  local wsplit = string.split(date, ".")
  local day = tonumber(wsplit[1])
  local month = tonumber(wsplit[2])
  local year = tonumber(wsplit[3])
  local a = math.floor((14 - month) / 12)
  local y = year - a
  local m = month + 12 * a - 2
  return math.floor((day + y + math.floor(y / 4) - math.floor(y / 100) + math.floor(y / 400) + (31 * m) / 12) % 7)
end

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

function secToTime(sec)
  local hour, minute, second = sec / 3600, math.floor(sec / 60), sec % 60
  return string.format("%02d:%02d:%02d", math.floor(hour) ,  minute - (math.floor(hour) * 60), second)
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

function atext(text)
  sampAddChatMessage("[Activity Helper] {FFFFFF}"..text, 0x008B8B)
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