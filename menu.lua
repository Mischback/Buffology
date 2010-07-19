--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is menu.lua, where the menu is defined.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = ns.settings							-- get the settings
local lib = ns.lib										-- get the lib
local menu = CreateFrame('Frame')						-- create the menu
-- *****************************************************

-- *****************************************************
ns.menu = menu											-- handover of the menu to the namespace