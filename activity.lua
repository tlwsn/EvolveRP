script_name("Activity checker") 
script_author('Edward_Franklin')
script_version("1.21")
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
  sessionStart = 0,
  authTime = 0,
  lvlAdmin = 0,
  onlineTime = 0,
  isALogin = false
}
local ips = {}
local dayName = {"Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"}
local nick = ""
--------------------------------------------------------------------
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
    sampRegisterChatCommand("activity", checkActivity)
    sampRegisterChatCommand("ppv", cmd_ppv)
    sampRegisterChatCommand("gip", cmd_gip)
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
      atext(string.format("Начался новый день. Итог прошлого дня (%s): %s", pInfo.info.day, secToTime(pInfo.info.dayOnline)))
      -----------------
      if weeknum == 0 then
        atext('Началась новая неделя. Итог прошлой недели: %s', secToTime(pInfo.info.weekOnline))
        for key in pairs(pInfo) do
          for k in pairs(pInfo[key]) do
            pInfo[key][k] = 0
          end
        end
      end
      pInfo.info.day = day
      pInfo.info.dayPM = 0
      pInfo.info.dayOnline = 0
      pInfo.info.dayAFK = 0
    end
    sInfo.authTime = os.date("%d.%m.%y %H:%M:%S")
    --------------------=========----------------------
    while not sampIsLocalPlayerSpawned() do wait(0) end
    local _, myid = sampGetPlayerIdByCharHandle(playerPed)
    nick = sampGetPlayerNickname(myid)
    while true do
      wait(1000)
      --if not sampIsPlayerConnected(myid) then sInfo.isALogin = false atext("not connected") end
      pInfo.info.dayOnline = pInfo.info.dayOnline + 1
      pInfo.info.weekOnline = pInfo.info.weekOnline + 1
      sInfo.onlineTime = sInfo.onlineTime + 1
      if sInfo.onlineTime >= 30 then
        if sInfo.sessionStart ~= 0 then
          pInfo.info.dayAFK = pInfo.info.dayAFK + (os.time() - sInfo.sessionStart - sInfo.onlineTime)
        end
        sInfo.onlineTime = 0
        sInfo.sessionStart = os.time()
        inicfg.save(pInfo, "activity-checker")
      end
    end
end

function cmd_gip(params)
  if #params == 0 then
    sampAddChatMessage("Введите: /gip [playerid / nick]", -1)
    return
  end
  local paramid = tonumber(params)
  if paramid ~= nil then
    sampSendChat("/getip "..params)
  else
    sampSendChat("/agetip "..params)
  end  
end

function cmd_ppv()
  -- ips[#ips+1] = { "name" = nick, "regip" = rip, "ip" = ip }
  local zstring = "{FFFFFF}Ник\t{FFFFFF}R-IP\t{FFFFFF}IP\n"
  local count = #ips
  for i = 1, count do
    zstring = zstring..string.format("%s\t%s\t%s\n", ips[i].name, ips[i].regip, ips[i].lip)
  end
  lua_thread.create(function()
    sampShowDialog(811653, "{FFFFFF}Проверенные аккаунты | {954F4F}Список", zstring, "Удалить", "Закрыть", DIALOG_STYLE_TABLIST_HEADERS)
    while sampIsDialogActive(811653) do wait(50) end
    local _, button, list, _ = sampHasDialogRespond(811653)
    if button == 1 then
      table.remove(ips, list+1)
      cmd_ppv()
    end
  end)  
end

function checkPunishments()
  local zstring = "{FFFFFF}Наказание\t{FFFFFF}Количество\n"
  local i = 1
  for key, value in pairs(pInfo.punish) do
    zstring = zstring..string.format("%s\t%s\n", key, value)
    i = i + 1
  end
  lua_thread.create(function()
    sampShowDialog(835163, string.format("{FFFFFF}Наказания за неделю | {954F4F}%s", nick), zstring, "Закрыть", "Назад", DIALOG_STYLE_TABLIST_HEADERS)
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
  local zstring = "{FFFFFF}День\t{FFFFFF}Онлайн\n"
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
    sampShowDialog(837763, string.format("{FFFFFF}Активность по дням недели | {954F4F}%s", nick), zstring, "Закрыть", "Назад", DIALOG_STYLE_TABLIST_HEADERS)
    while sampIsDialogActive(837763) do wait(50) end
    local _, button, _, _ = sampHasDialogRespond(837763)
    if button == 0 then
      checkActivity()
    end
  end)
end

function checkActivity()
  local zstring = "{ffffff}Параметр\t{FFFFFF}Значение\n"
  zstring = zstring.."Просмотреть онлайн по дням недели\n"
  zstring = zstring.."Посмотреть счётчик наказаний за неделю\n"
  zstring = zstring..string.format("Последнее обновление\t%s секунд назад\n", sInfo.sessionStart == 0 and "-" or (os.time() - sInfo.sessionStart))
  zstring = zstring..string.format("Время авторизации\t%s\n", sInfo.authTime)
  zstring = zstring..string.format("Авторизация в ALogin\t%s\n", sInfo.isALogin and "Авторизирован" or "Отсутствует")
  if sInfo.isALogin then
    zstring = zstring..string.format("Уровень модератора\t%s\n", sInfo.lvlAdmin)
  end  
  zstring = zstring..string.format("Отыграно за сегодня\t%s\n", secToTime(pInfo.info.dayOnline))
  zstring = zstring..string.format("AFK за сегодня\t%s\n", sInfo.sessionStart == 0 and secToTime(pInfo.info.dayAFK) or secToTime(pInfo.info.dayAFK + (os.time() - sInfo.sessionStart - sInfo.onlineTime)))
  zstring = zstring..string.format("Ответов за сегодня\t%d\n", pInfo.info.dayPM)
  zstring = zstring..string.format("Ответов за неделю\t%d\n", pInfo.info.weekPM)
  zstring = zstring..string.format("Отыграно за неделю\t%s\n", secToTime(pInfo.info.weekOnline))
  -------
  lua_thread.create(function()
    sampShowDialog(827453, string.format("{FFFFFF}Активность | {954F4F}%s", nick), zstring, "Закрыть", "", DIALOG_STYLE_TABLIST_HEADERS)
    while sampIsDialogActive(827453) do wait(50) end
    local _, button, list, _ = sampHasDialogRespond(827453)
    if button == 1 and list == 0 then
      checkWeek()
    elseif button == 1 and list == 1 then
      checkPunishments()
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
  if text:match(nick) then
    -- OffBan[забанил: Laurence_Lawson][забанен: Raffaell_Vailiane][Причина: upom_rodnix_JB 30][дней: 30][27/12/2018  0:6]
    -- Администратор: Maks_Wirense забанил Skylar_Love. Причина: Мультиаккаунт
    -- SBan[забанил: Native_Pechenkov][забанен: CblH_Admina][причина: nick][27/12/2018  18:24]
    -- IOffBan[забанил: Salvatore_Amici][забанен: Jonathans_Wilsons][Причина: akk_prodavca/ppv][27/12/2018  18:36]
    if text:match("OffBan") or text:match("забанил (.+) Причина") or text:match("SBan") or text:match("IOffBan") then
      pInfo.punish.ban = pInfo.punish.ban + 1
    end
    -- Администратор: Diego_Hudson выдал warn Dean_Voodoo. Причина: cheat [ballas/6]
    -- Skot_Foster получил предупреждение до 14:32 18.01.19 от Laurence_Lawson
    if text:match("выдал warn") or text:match("получил предупреждение до") then
      pInfo.punish.warn = pInfo.punish.warn + 1
    end
    -- Администратор: William_Marshal кикнул Fabio_Vercetti. Причина: offtop in /ask
    if text:match("кикнул .+ Причина") then
      pInfo.punish.kick = pInfo.punish.kick + 1
    end
    -- Kirill_Baka посажен в prison на 60 минут. Администратор: Edward_Franklin. Причина: dm
    --  Администратор Jay_Rise поместил в ДеМорган Danik_Star на 30 минут. Причина: DB
    if text:match("поместил в ДеМорган") or text:match("посажен в prison") then
      pInfo.punish.prison = pInfo.punish.prison + 1
    end
    -- Администратор Jay_Rise [476] заблокировал чат игрока Miroslav_Vhoot [501], на 10 минут. Причина: Оск
    -- OffMute[Заткнул: Laurence_Lawson][Заткнут: Diego_Pink][Причина: osk_JB][минут: 60]
    if text:match("заблокировал чат") or text:match("OffMute") then
      pInfo.punish.mute = pInfo.punish.mute + 1
    end
    -- Laurence_Lawson забанил IP: 178.216.230.192
    if text:match("забанил IP") then
      pInfo.punish.banip = pInfo.punish.banip + 1
    end
    -- Администратор Chrisstian_Norton выдал затычку на репорт Semyon_Lobanov' у
    if text:match("выдал затычку на репорт") then
      pInfo.punish.rmute = pInfo.punish.rmute + 1
    end
  end
  -- Вы посадили Edward_Franklin [541] в тюрьму на 1 минут
  if text:match("Вы посадили .+ в тюрьму на") then
  	pInfo.punish.jail = pInfo.punish.jail + 1
  end
  if text:match("Вы авторизировались как модератор .+ уровня") then
    sInfo.lvlAdmin = tonumber(text:match("Вы авторизировались как модератор (.+) уровня"))
    sInfo.isALogin = true
    sInfo.sessionStart = os.time()
  end
  if text:match("Ответ от "..nick) then
    pInfo.info.dayPM = pInfo.info.dayPM + 1
    pInfo.info.weekPM = pInfo.info.weekPM + 1
  end
  -- -- Время online за текущий день - 0:09 (Без учета АФК) | Ответов: 0
  if text:match("Время online за текущий день") then -- CP1251
    sampAddChatMessage(string.format(" Время online за неделю - %s (Без учета АФК) | Ответов: %d", secToTime(pInfo.info.weekOnline), pInfo.info.weekPM), 0xCCCCCC)
  end
  if text:match("Nik %[.+%]  R%-IP %[.+%]  L%-IP %[.+%]  IP %[(.+)%]") and color == -10270806 then
    local nick, rip, ip = text:match("Nik %[(.+)%]  R%-IP %[(.+)%]  L%-IP %[.+%]  IP %[(.+)%]")
    local checked = false
    for i = 1, #ips do
      if checkIntable(ips[i], nick) then
        checked = true
      end
    end
    if not checked then
      local sp = string.split(rip, ".")
      local sp2 = string.split(ip, ".")
      if sp[1] ~= sp2[1] or sp[2] ~= sp2[2] then 
        ips[#ips+1] = { name = nick, regip = rip, lip = ip }
      end  
    end   
  end
  if text:match('^ Nik %[.+%]   R%-IP %[.+%]   L%-IP %[.+%]   IP %[.+%]$') then
    local nick, rip, ip = text:match('^ Nik %[(.+)%]   R%-IP %[(.+)%]   L%-IP %[.+%]   IP %[(.+)%]$')
    local checked = false
    for i = 1, #ips do
      if checkIntable(ips[i], nick) then
        checked = true
      end
    end
    if not checked then
      local sp = string.split(rip, ".")
      local sp2 = string.split(ip, ".")
      if sp[1] ~= sp2[1] or sp[2] ~= sp2[2] then 
        ips[#ips+1] = { name = nick, regip = rip, lip = ip }
      end  
    end  
  end
end
--------------------------------------------------------------------
function checkIntable(t, key)
  for k, v in pairs(t) do
      if v == key then return true end
  end
  return false
end
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