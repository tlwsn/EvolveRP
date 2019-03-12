script_name('TimeFormat')
script_version('2.0')
script_author('imring')

local memory = require'memory'
local ffi = require'ffi'
local inicfg = require'inicfg'
local ini = inicfg.load(nil, 'moonloader/TimeFormat.ini')

------------------------- FUNCTIONS

local function GET_POINTER(cdata) return tonumber(ffi.cast('intptr_t', ffi.cast('void*', cdata))) end

local function hook_return_func(h, i, bool)
	if bool then
		memory.setuint8(h, i[1], true)
		memory.setuint32(h + 1, i[2], true)
		memory.setuint8(h + 5, i[3], true)
	else
		memory.setuint8(h, 0xE9, true)
		memory.setuint32(h + 1, i - h - 5, true)
		memory.setuint8(h + 5, 0xC3, true)
	end
end

local function getMillisecond()
	local a, b = math.modf(os.clock())
	return ('%03d'):format(b*1000)
end

-----------------------------------

local hook_addr, inf_addr, call_addr, detour_addr

ffi.cdef[[
typedef void(__cdecl* CALLBACK)(char*str, int size, char*format, int *time);
]]

local last
local ms = {}

local function cmdhook(str, size, form, time)
	local index = ('%02d%02d%02d'):format(time[2], time[1], time[0])
	if not ms[index] then ms[index] = { c = { getMillisecond() }, index = 0, calls = 1 } end
	local this = ms[index]
	if last then
		if last == index then
			this.calls = this.calls + 1
			if not this.max or this.calls > this.max then 
				this.c[#this.c + 1] = getMillisecond()
				if this.max and this.calls > this.max then this.max = #this.c end
			end
		else
			ms[last].calls = 1
			ms[last].index = 0
			if not this.max then this.max = #this.c end
		end
	end
	if this.index == ( this.max or #this.c ) then this.index = 1 else this.index = this.index + 1 end
	local t = ini.Main.format:gsub('%%MM', this.c[this.index] or '')
	local ss = ffi.cast('char*', t)
	hook_return_func(hook_addr, inf_addr, true)
	call_addr(str, 255, ss, time)
	hook_return_func(hook_addr, detour_addr, false)
	last = index
end

function main()
	if not isSampLoaded() then return end

	local callback = ffi.cast('CALLBACK', cmdhook)
	detour_addr = GET_POINTER(callback)
	
	hook_addr = getModuleHandle('samp.dll') + 0xB87E7
	inf_addr = { memory.getuint8(hook_addr, true), memory.getuint32(hook_addr + 1, true), memory.getuint8(hook_addr + 5, true) } 
	call_addr = ffi.cast('CALLBACK', hook_addr)
	hook_return_func(hook_addr, detour_addr, false)

	memory.setuint8(getModuleHandle('samp.dll') + 0x63EAF + 0x8, ini.Main.space, true)
	memory.setuint8(getModuleHandle('samp.dll') + 0x63F10 + 0x8, ini.Main.space, true)
	wait(-1)
end

function onScriptTerminate(scr)
	if scr == script.this then
		hook_return_func(hook_addr, inf_addr, true)
	end
end
