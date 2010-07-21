--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is settings.lua, where settings are initialized and stored
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = CreateFrame('Frame')					-- create the settings
-- *****************************************************

settings.static = {
	['updateInterval'] = 1,			-- update-interval of the buff-durations
	['enchant_maxicons'] = 2,
	['buff_maxicons'] = 32,			-- number of buffs to display
	['debuff_maxicons'] = 16,		-- number of buffs to display
}

settings.options = {
	fonts = {
		['duration'] = 'Fonts\\FRIZQT__.TTF',
		['count'] = 'Fonts\\FRIZQT__.TTF',
	},
}

-- *****************************************************
ns.settings = settings									-- handover of the settings to the namespace