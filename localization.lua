--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is menu.lua, where the menu is defined.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = ns.settings							-- get the settings
local strings = CreateFrame('Frame')					-- create the menu
-- *****************************************************

local localization = {
	['default'] = {
		['slashcommand'] = '/buffology',		-- the slash-command to trigger buffology actions
		['menutrigger'] = 'menu',				-- option to slash-command to show buffology menu
		
		['buffology_menu'] = {
			['caption_frames'] = 'Frames', 
			['caption_filter'] = 'Filter',
			['frame_dropdown_title'] = 'Select frame to configure...',
			['frame_create_new'] = 'Create new Frame',
			['frame_create_text'] = 'Please enter the name of your new frame...', 
			['frame_double_text'] = 'This name is already used!', 
			['frame_create_ok'] = 'Accept', 
			['frame_create_cancel'] = 'Cancel',
			['frame_anchorPointCaption'] = 'anchorPoint',
			['frame_relativeToCaption'] = 'relativeTo',
			['frame_relativePointCaption'] = 'relativePoint',
			['frame_xOffsetCaption'] = 'xOffset',
			['frame_yOffsetCaption'] = 'yOffset',
			['frame_xGrowDirCaption'] = 'hor. growth direction',
			['frame_yGrowDirCaption'] = 'ver. growth direction',
			['frame_columnsCaption'] = 'columns',
			['frame_xSpacingCaption'] = 'hor. spacing',
			['frame_ySpacingCaption'] = 'ver. spacing',
		},
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