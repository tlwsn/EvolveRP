script_name("Activity") 
script_authors({"Edward_Frankin", "Thomas_Lawson"})
script_version("1.9")
-----------------------------------------------------
local sampev        = require "lib.samp.events"
local imgui         = require "imgui"
local encoding      = require "encoding"
local copas         = require "copas"
local http          = require "copas.http"
local crypto        = require "crypto_lua"
encoding.default    = 'CP1251'
local u8 = encoding.UTF8
-----------------------------------------------------

local mainw = imgui.ImBool(false)
local weekonline = imgui.ImBool(false)
local punishments = imgui.ImBool(false)

local dostup = false

local cfg = {
    info = {
        day = "01.01.2019",
        dayOnline = 0,
        dayAFK = 0,
        dayPM = 0,
        weekPM = 0,
        thisWeek = -1,
        weekOnline = 0,
        admLvl = 0
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
}

local sInfo = {
    updateAFK = 0,
    authTime = 0,
    isAlogin = false
}

local dayName = {u8"Понедельник", u8"Вторник", u8"Среда", u8"Четверг", u8"Пятница", u8"Суббота", u8"Воскресенье"}

function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
  
    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
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
end
apply_custom_style()

function atext(text) sampAddChatMessage((" Activity Helper | {FFFFFF}%s"):format(text), 0x954F4F) end

function main()

    if not doesDirectoryExist("moonloader/config") then createDirectory("moonloader/config") end
    if doesFileExist("moonloader/config/activity_config.json") then
        local file = io.open('moonloader/config/activity_config.json', 'r')
        if file then
            pInfo = decodeJson(file:read("*a"))
            if pInfo == nil then -- Проверка, на случай, если слетел конфиг
                atext("Произошла ошибка чтения конфига, все значения сброшены.")
                pInfo = cfg 
            end
            file:close()
        end
    else
        pInfo = cfg
        saveData(pInfo, "moonloader/config/activity_config.json")
    end

    repeat wait(0) until isSampAvailable()
    autoupdate("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/update.json", '[Activity Helper]', "https://evolve-rp.su/viewtopic.php?f=21&t=151439")
    sampRegisterChatCommand("activity", function() mainw.v = not mainw.v end)
    
    --https://raw.githubusercontent.com/WhackerH/EvolveRP/master/activity_online.txt
    local tdostup
    httpRequest("https://raw.githubusercontent.com/WhackerH/EvolveRP/master/activity_online.txt", nil, function(response, code, headers, status)
        if response then
            tdostup = {}
            for line in response:gmatch('[^\r\n]+') do
                table.insert(tdostup, line)
            end
        end
    end)
    while tdostup == nil do wait(0) end
    if checkIntable(tdostup, sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))) then dostup = true end


    local day = os.date("%d.%m.%y")
    if pInfo.info.thisWeek == -1 then pInfo.info.thisWeek = os.date("%W") end -- Запись в конфиг номер недели при первом запуске скрипта

    if pInfo.info.day ~= day and tonumber(os.date("%H")) > 4 then -- Проверка на смену дня / недели
        local weeknum = dateToWeekNumber(pInfo.info.day) -- День недели
        if weeknum == 0 then weeknum = 7 end -- Потому что начинается с воскресенья
        pInfo.weeks[weeknum] = pInfo.info.dayOnline -- Записываем онлайн за прошлый день в конфиг
        atext(("Начался новый день. Итоги предыдущего дня (%s): %s"):format(pInfo.info.day, secToTime(pInfo.info.dayOnline)))

        if tonumber(pInfo.info.thisWeek) ~= tonumber(os.date("%W")) then -- Проверка на смену недели [ есть баг с новым годом, как пофиксить хз. ]
            atext(("Началась новая неделя. Итоги предыдущей недели: %s"):format(secToTime(pInfo.info.weekOnline)))
            -- Обнуление всех переменных в конфиге
            for key in pairs(pInfo) do
                for k in pairs(pInfo[key]) do
                  pInfo[key][k] = 0
                end
            end
            pInfo.info.thisWeek = os.date("%W") -- Запись в конфиг номер недели
        end

        pInfo.info.day = day
        pInfo.info.dayPM = 0
        pInfo.info.dayOnline = 0
        pInfo.info.dayAFK = 0

        saveData(pInfo, "moonloader/config/activity_config.json")
    end

    if sampGetGamestate() == 3 then -- Проверка, если скрипт был запущен когда игрок уже играет
        sampSendChat("/a")
        sendStat(false)
    end

    while not sampIsLocalPlayerSpawned() do wait(0) end
    sInfo.authTime = os.date("%d.%m.%y %H:%M:%S")
    sInfo.updateAFK = os.time()
    calculateOnline() -- Счетчик онлайна
    sendOnline()
    
    while true do wait(0)
        if sampGetGamestate() ~= 3 then sInfo.isAlogin = false end -- В случае, если было потеряно соединение с сервером
        imgui.Process = mainw.v
    end
end

function sampev.onServerMessage(color, text)
    local myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
    local nick = sampGetPlayerNickname(myid)

    if text:match("Время online за текущий день") and dostup then sampAddChatMessage(string.format(" Время online за неделю - %s (Без учета АФК) | Ответов: %d", secToTime(pInfo.info.weekOnline), pInfo.info.weekPM), 0xBFC0C2) end

    if text:match("Вы авторизировались как модератор .+ уровня") then
        pInfo.info.admLvl = tonumber(text:match("Вы авторизировались как модератор (.+) уровня"))
        sInfo.isALogin = true
        sInfo.sessionStart = os.time()
        sendStat(true)
        saveconfig()
    end

    if text:match("Введите: %(/a%)dmin") and not sInfo.isAlogin then -- Проверка на админку при перезагрузке скрипита в игре
        sInfo.isALogin = true
        sInfo.sessionStart = os.time()
        return false
    end

    if text:find(nick) then
        if text:match("Ответ от "..nick.."%["..myid.."%] к") then
            pInfo.info.dayPM = pInfo.info.dayPM + 1
            pInfo.info.weekPM = pInfo.info.weekPM + 1
        end

        if text:match("Вы посадили .+ в тюрьму") then
            pInfo.punish.jail = pInfo.punish.jail + 1
        end

        if text:match("OffBan") or text:match("забанил (.+) Причина") or text:match("SBan") or text:match("IOffBan") then
            pInfo.punish.ban = pInfo.punish.ban + 1
        end

        if text:match("выдал warn") or text:match("получил предупреждение до") then
            pInfo.punish.warn = pInfo.punish.warn + 1
        end

        if text:match("кикнул .+ Причина") then
            pInfo.punish.kick = pInfo.punish.kick + 1
        end

        if text:match("поместил в ДеМорган") or text:match("посажен в prison") then
            pInfo.punish.prison = pInfo.punish.prison + 1
        end

        if text:match("заблокировал чат игрока") or text:match("OffMute") then
            pInfo.punish.mute = pInfo.punish.mute + 1
        end

        if text:match("забанил IP") then
            pInfo.punish.banip = pInfo.punish.banip + 1
        end

        if text:match("запретил репорт игроку") then
            pInfo.punish.rmute = pInfo.punish.rmute + 1
        end
    end
end

function imgui.OnDrawFrame()
    local myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
    local nick = sampGetPlayerNickname(myid)
    local screenx, screeny = getScreenResolution()
    local btn_size = imgui.ImVec2(-0.1, 0)
    local spacing = 165.0

    if mainw.v then
        imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin("Activity", mainw, imgui.WindowFlags.NoResize)

        imgui.Text(u8"Ник:"); imgui.SameLine(spacing); imgui.Text(('%s [%s]'):format(nick, myid))
        imgui.Text(u8 "Авторизация в ALogin:"); imgui.SameLine(spacing); imgui.Text(("%s"):format(u8(sInfo.isALogin and  "Авторизирован" or "Отсутствует")))
        if sInfo.isALogin == true and pInfo.info.admLvl > 0 then
            imgui.Text(u8"Уровень модератора:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(pInfo.info.admLvl))
        end
        imgui.Text(u8"Время авторизации:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(sInfo.authTime))
        imgui.Separator()
        imgui.Text(u8"Отыграно за сегодня:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.dayOnline)))
        imgui.Text(u8"AFK за сегодня:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.dayAFK)))
        imgui.Text(u8"Ответов за сегодня:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(pInfo.info.dayPM))
        imgui.Separator()
        if dostup then
            imgui.Text(u8"Отыграно за неделю:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(secToTime(pInfo.info.weekOnline)))
            imgui.Text(u8"Ответов за неделю:"); imgui.SameLine(spacing); imgui.Text(('%s'):format(pInfo.info.weekPM))
            imgui.Separator()
        end

        if dostup then if imgui.Button(u8 'Статистика по дням', btn_size) then weekonline.v = not weekonline.v end end
        if imgui.Button(u8 'Статистика наказаний', btn_size) then punishments.v = not punishments.v end
        if imgui.Button(u8 'Перезагрузить скрипт', btn_size) then
            atext("Перезагружаемся...")
            showCursor(false)
            thisScript():reload()
        end
        if imgui.Button(u8 'Сообщить об ошибке', btn_size) then
            atext("Связь с разрабочиком:")
            atext("VK - https://vk.com/tlwsn | https://vk.com/the_redx")
        end

        if weekonline.v then
            imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8 'Статистика по дням', weekonline, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
            local daynumber = dateToWeekNumber(os.date("%d.%m.%y"))
            if daynumber == 0 then daynumber = 7 end
            for key, value in ipairs(pInfo.weeks) do
                imgui.Text(dayName[key]); imgui.SameLine(spacing); imgui.Text(('%s'):format(daynumber == key and secToTime(pInfo.info.dayOnline) or secToTime(value)))
            end
            imgui.End()
        end

        if punishments.v then
            imgui.SetNextWindowSize(imgui.ImVec2(325, 300), imgui.Cond.FirstUseEver)
            imgui.SetNextWindowPos(imgui.ImVec2(screenx/2, screeny/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
            imgui.Begin(u8 'Статистика наказаний', punishments, imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
            local i = 1
            for key, value in pairs(pInfo.punish) do
                imgui.Text(('%s'):format(key)); imgui.SameLine(spacing); imgui.Text(('%s'):format(value))
                i = i + 1
            end
            imgui.End()
        end

        imgui.End()
    end
end

function saveData(table, path) -- Запись таблицы в файл
	if doesFileExist(path) then os.remove(path) end
    local sfa = io.open(path, "w")
    if sfa then
        sfa:write(encodeJson(table))
        sfa:close()
    end
end

function calculateOnline() -- Счетчик онлайна
    lua_thread.create(function()
        local updatecount = 0
        while true do wait(1000) -- Каждую секунду запись онлайна
            if sInfo.isALogin == true then
                pInfo.info.dayOnline = pInfo.info.dayOnline + 1
                pInfo.info.weekOnline = pInfo.info.weekOnline + 1
                pInfo.info.dayAFK = pInfo.info.dayAFK + (os.time() - sInfo.updateAFK - 1)
                if updatecount >= 10 then saveconfig() updatecount = 0 end -- Запись в конфиг каждые 10 секунд
                updatecount = updatecount + 1
            end
            sInfo.updateAFK = os.time()
        end  
    end)
end

function saveconfig() -- Вызов сохранения конфига
    if pInfo.info.dayOnline > 0 and pInfo.info.weekOnline > 0 then
        saveData(pInfo, "moonloader/config/activity_config.json")
    end
end

function sendOnline()
    lua_thread.create(function()
      while true do wait(900000)
        sendStat(false)
      end
    end)
end

function sendStat(bool)
    local zaprosTable = {
        {
          jsonrpc = '2.0',
          id = os.time(),
          method = 'set.Online',
          params = {
            nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))),
            hash = string.lower(crypto.md5(os.time()..'activity-@-helper'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))),
            level = pInfo.info.admLvl,
            dayOnline = pInfo.info.dayOnline,
            dayPM = pInfo.info.dayPM,
            dayAFK = pInfo.info.dayAFK,
            weekOnline = pInfo.info.weekOnline,
            weekPM = pInfo.info.weekPM
          }
        },
        {
          jsonrpc = '2.0',
          id = os.time(),
          method = 'set.Punish',
          params = {
            nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))),
            hash = string.lower(crypto.md5(os.time()..'activity-@-helper'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))),
            ban = pInfo.punish.ban,
            warn = pInfo.punish.warn,
            kick = pInfo.punish.kick,
            prison = pInfo.punish.prison,
            mute = pInfo.punish.mute,
            banip = pInfo.punish.banip,
            rmute = pInfo.punish.rmute,
            jail = pInfo.punish.jail
          }
        },
        {
          jsonrpc = '2.0',
          id = os.time(),
          method = 'set.Weeks',
          params = {
            nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))),
            hash = string.lower(crypto.md5(os.time()..'activity-@-helper'..sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))),
            [1] = pInfo.weeks[1],
            [2] = pInfo.weeks[2],
            [3] = pInfo.weeks[3],
            [4] = pInfo.weeks[4],
            [5] = pInfo.weeks[5],
            [6] = pInfo.weeks[6],
            [7] = pInfo.weeks[7]
          }
        }
    }
    if bool then zaprosTable[1].params.alogin = true end
    --url = ("https://redx-dev.web.app/api.html?dayAFK=%s&dayOnline=%s&dayPM=%s&level=%s&nick=%s&weekOnline=%s&weekPM=%s"):format(pInfo.info.dayAFK, pInfo.info.dayOnline, pInfo.info.dayPM, pInfo.info.admLvl, sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))), pInfo.info.weekOnline,pInfo.info.weekPM)
    httpRequest("https://redx-dev.web.app/api?data="..encodeJson(zaprosTable), nil, function(response, code, headers, status)
        if not response then
            print(url, code)
        end
    end)
    --downloadUrlToFile(url, os.getenv('TEMP') .. '\\activity')
    --print("https://redx-dev.web.app/api?data="..encodeJson(zaprosTable))
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

function checkIntable(t, key)
    for k, v in pairs(t) do
        if v == key then return true end
    end
    return false
end

function onScriptTerminate(scr, quit)
    if scr == script.this then
        if not quit then
            atext("Скрипт завершил свою работу.")
        end
    end
end

function autoupdate(json_url, prefix, url)
    lua_thread.create(function()
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
              updatelink = info.activity.url
              updateversion = info.activity.version
              f:close()
              os.remove(json)
              if updateversion > thisScript().version then
                lua_thread.create(function()
                  local dlstatus = require('moonloader').download_status
                  local color = -1
                  local path = thisScript().path
                  atext('Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion)
                  wait(250)
                  if thisScript().filename == "activity.lua" then
                    os.rename('moonloader/activity.lua', 'moonloader/activity.luac')
                    path = path.."c"
                  end
                  downloadUrlToFile(updatelink, path,
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
    end)
end