--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is menu.lua, where the menu is defined.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = ns.settings							-- get the settings
local strings = CreateFrame('Frame')					-- create the menu
-- *****************************************************

local localization = {
	['default'] = {
		['slashcommand'] = '/buffology'
	},
}

	--[[ Sets the current localization or defaults
		VOID loadLocalizedStrings()
	]]
	strings.loadLocalizedStrings = function()
		for k, v in pairs(localization['default']) do
			strings[k] = v
		end
	end

-- *****************************************************
ns.strings = strings									-- handover of the strings to the namespace