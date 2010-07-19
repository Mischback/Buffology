--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is settings.lua, where settings are initialized and stored
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = CreateFrame('Frame')					-- create the settings
-- *****************************************************

settings.static = {
	maxicons = 40,		-- number of buffs/debuffs to display (for each of them! 40 comes from Blizzard, not sure, if we can go higher)
}

-- *****************************************************
ns.settings = settings									-- handover of the settings to the namespace