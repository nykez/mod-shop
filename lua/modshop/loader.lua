// This file main purpose is to load all the files needed for the addon //
// Not recommend to edit, unless you know what you're doing //

modshop = modshop or {}

local function client(file)
	if SERVER then AddCSLuaFile(file) end

	if CLIENT then
		return include(file)
	end
end

local function server(file)
	if SERVER then
		return include(file)
	end
end

local function shared(file)
	return client(file) or server(file)
end


shared("vars.lua")

server("core/sv_mysql.lua")
server("sql.lua")
server("core/sv_player.lua")

shared("core/sh_currency.lua")

client("core/cl_tdlib.lua")
client("core/cl_mod_sheet.lua")
client("core/cl_menu.lua")

print("loaded modshop")