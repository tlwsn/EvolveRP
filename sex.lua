script_properties("work-in-pause")
local sampev = require 'lib.samp.events'
local imgui = require 'imgui'
local mainwinod = imgui.ImBool(false)
local gsexb = false
local gchatb = false
local canpress = true
local drugstimer = false
local zbivlomki = false
local gtime = 60
local timeonscreen = 60
local cmdsb = '/usedrugs'
local msscreen = 10
local work = false
local skrivatnarko = false
local x, y = getScreenResolution()
function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0
    colors[clr.WindowBg]               = ImVec4(0.00, 0.00, 0.00, 0.52)
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
    colors[clr.CloseButton]            = ImVec4(0.11, 0.79, 0.07, 0.37)
    colors[clr.CloseButtonHovered]     = ImVec4(0.11, 0.79, 0.07, 0.51)
    colors[clr.CloseButtonActive]      = ImVec4(0.11, 0.79, 0.07, 0.76)
end
apply_custom_style()  
function imgui.OnDrawFrame()
    if mainwinod.v then
        local sexb = imgui.ImBool(gsexb)
        local chatb = imgui.ImBool(gchatb)
        local time = imgui.ImInt(gtime)
        local skr = imgui.ImBool(skrivatnarko)
        local command = imgui.ImBuffer(cmdsb, 256)
        imgui.SetNextWindowPos(imgui.ImVec2(x/2, y/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin('Sex', mainwinod, imgui.WindowFlags.AlwaysAutoResize)
        if imgui.Checkbox('No Anim', sexb) then
            gsexb = not gsexb
        end
        if imgui.Checkbox('Sbiv Chat', chatb) then
            gchatb = not gchatb
        end
        if imgui.Checkbox('Hide Drugs', skr) then
            skrivatnarko = not skrivatnarko
        end
        imgui.Separator()
        if imgui.SliderInt('Timer', time, 1, 60) then
            gtime = time.v
        end
        if imgui.InputText('Command', command) then
            cmdsb = command.v
        end
        imgui.End()
    end
end
function sampev.onApplyPlayerAnimation(playerId, animLib, animName, loop, lockX, lockY, freeze, time)
    if gsexb and animName == 'M_smk_drag' then
        return false 
    end
    if zbivlomki and animName == 'crckdeth1' or animName == 'crckdeth3' then return false end
end
function sampev.onServerMessage(color, message)
    if skrivatnarko then
        if message:match('%(%( Остаток%: %d+ грамм %)%)') then
            local mati = message:match('%(%( Остаток%: (%d+) грамм %)%)')
            printStyledString('~y~You have~n~~g~Drugs ~w~'..mati, 5000, 2)
            return false
        end
    end
end
function WorkInBackground(work)
    local memory = require 'memory'
    if work then -- on
        memory.setuint8(7634870, 1) 
        memory.setuint8(7635034, 1)
        memory.fill(7623723, 144, 8)
        memory.fill(5499528, 144, 6)
    else -- off
        memory.setuint8(7634870, 0)
        memory.setuint8(7635034, 0)
        memory.hex2bin('5051FF1500838500', 7623723, 8)
        memory.hex2bin('0F847B010000', 5499528, 6)
    end 
end
function main()
    local memory = require 'memory'
    memory.setfloat(0xB793E0, 910.4)
    while not isSampAvailable() do wait(0) end
    sampRegisterChatCommand('sex', function() mainwinod.v = not mainwinod.v end)
    sampRegisterChatCommand('ddd', function() x, y, z = getCharCoordinates(PLAYER_PED)
        print(string.format('%s, %s, %s', x, y, z))
        x, y, z = nil
    end)
    sampfuncsRegisterConsoleCommand('nuni', function() zbivlomki = not zbivlomki; printString(zbivlomki and 'Activated' or 'Ne activated', 1000) end)
    font = renderCreateFont("Arial", 11, 5)
    font1 = renderCreateFont('Arial', 9, 5)
    lua_thread.create(render)
    WorkInBackground(false)
    while true do wait(0)
        imgui.Process = mainwinod.v
        if isKeyJustPressed(101) and not sampIsDialogActive() and not isSampfuncsConsoleCommandDefined() and not sampIsChatInputActive() then
            mainwinod.v = not mainwinod.v
        end
        if isKeyJustPressed(88) and canpress and not sampIsDialogActive() and not isSampfuncsConsoleCommandDefined() and not sampIsChatInputActive() then
            addOneOffSound(0.0, 0.0, 0.0, 1052)
			health = getCharHealth(PLAYER_PED)
			wannadrugs = 160 - health
			wannadrugs = wannadrugs / 10
			wannadrugs = math.ceil(wannadrugs)
            if wannadrugs >= 16 then wannadrugs = 15 end
            if wannadrugs == 0 then wannadrugs = 1 end
            sampSendChat(string.format('%s %s', cmdsb, wannadrugs))
            timeonscreen = os.clock() + gtime + 1
            drugstimer = true
            canpress = false
            if gchatb then
                wait(700)
                sampSendChat(' ')
            end
        end
        if drugstimer and timeonscreen <= os.clock() then
            addOneOffSound(0.0, 0.0, 0.0, 1057)
            timeonscreen = gtime
            canpress = true
            drugstimer = false
		end
    end
end
function render()
    while true do wait(0)
        local hpx, hpy = convertGameScreenCoordsToWindowScreenCoords(555.0, 77.1)
        local armx, army = convertGameScreenCoordsToWindowScreenCoords(572.5, 48.5)
        local usx, usy = convertGameScreenCoordsToWindowScreenCoords(576, 69.274070739746)
        local s1, s2 = convertWindowScreenCoordsToGameScreenCoords(1728,167)
        print(s1, s2)
        renderFontDrawText(font, getCharHealth(PLAYER_PED), hpx, hpy, -1)
        if getCharArmour(PLAYER_PED) > 0 then
            renderFontDrawText(font, getCharArmour(PLAYER_PED), armx, army, -1)
        end
        if canpress then
            
            renderFontDrawText(font1, 'Можно юзать!', usx, usy, -16724900)
        else
            renderFontDrawText(font1, string.format('%s',  'Осталось: '..math.floor(timeonscreen - os.clock())), usx, usy, -1)
        end
    end
end