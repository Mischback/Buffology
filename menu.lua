--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is menu.lua, where the menu is defined.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = ns.settings							-- get the settings
local strings = ns.strings								-- get the localization
local lib = ns.lib										-- get the lib
local menu = CreateFrame('Frame')						-- create the menu

local MENUFRAMENAME = 'BuffologyMenu'
menu.info = {}
-- *****************************************************

BuffologyMenuFunctions = {
	-- These are general functions
	['General'] = {
		-- this closes the menu (hide the frame and the buff-anchors)
		['CloseMenu'] = function()
			for _, v in pairs(_G['Buffology'].framelist) do	-- Hide the frame-anchors
				v:Hide()
			end
			menu.MenuFrame:Hide()							-- Hide the menu
		end,

		-- apply localized strings
		['OnShow'] = function()
			_G[MENUFRAMENAME..'ButtonFrames']:SetText(strings.buffology_menu.caption_frames)	-- set the text of the "Frames"-button
			_G[MENUFRAMENAME..'ButtonFilter']:SetText(strings.buffology_menu.caption_filter)	-- set the text of the "Filters"-button
		end,

		-- OnClick-Handler for tab-buttons
		['TabButtonOnClick'] = function(button)
			_G[MENUFRAMENAME..'TabFrames']:Hide()
			_G[MENUFRAMENAME..'TabFilter']:Hide()
			local _, item = string.find(button, MENUFRAMENAME..'Button')
			item = string.sub(button, item + 1)
			_G[MENUFRAMENAME..'Tab'..item]:Show()
		end,
	},
	
	-- These functions handle the "Frames"-tab
	['TabFrames'] = {
		-- This is executed, when the "Frames"-tab becomes visible
		['OnShow'] = function(name)
			_G[name..'Caption']:SetText(strings.buffology_menu.caption_frames)	-- set the panel's caption
			_G[name..'FrameTitle']:SetText(strings.buffology_menu.frame_dropdown_title)	-- set the panel's caption
			_G[name..'Option_anchorPointCaption']:SetText(strings.buffology_menu.frame_anchorPointCaption..':')
			_G[name..'Option_relativeToCaption']:SetText(strings.buffology_menu.frame_relativeToCaption..':')
			_G[name..'Option_relativePointCaption']:SetText(strings.buffology_menu.frame_relativePointCaption..':')
			_G[name..'Option_xOffsetCaption']:SetText(strings.buffology_menu.frame_xOffsetCaption..':')
			_G[name..'Option_yOffsetCaption']:SetText(strings.buffology_menu.frame_yOffsetCaption..':')
			_G[name..'Option_xGrowDirCaption']:SetText(strings.buffology_menu.frame_xGrowDirCaption..':')
			_G[name..'Option_yGrowDirCaption']:SetText(strings.buffology_menu.frame_yGrowDirCaption..':')
			_G[name..'Option_columnsCaption']:SetText(strings.buffology_menu.frame_columnsCaption..':')
			_G[name..'Option_xSpacingCaption']:SetText(strings.buffology_menu.frame_xSpacingCaption..':')
			_G[name..'Option_ySpacingCaption']:SetText(strings.buffology_menu.frame_ySpacingCaption..':')
			_G[name..'Option_anchorPointEditBox']:SetText('')
			_G[name..'Option_relativeToEditBox']:SetText('')
			_G[name..'Option_relativePointEditBox']:SetText('')
			_G[name..'Option_xOffsetEditBox']:SetText('')
			_G[name..'Option_yOffsetEditBox']:SetText('')
			_G[name..'Option_xGrowDirEditBox']:SetText('')
			_G[name..'Option_yGrowDirEditBox']:SetText('')
			_G[name..'Option_columnsEditBox']:SetText('')
			_G[name..'Option_xSpacingEditBox']:SetText('')
			_G[name..'Option_ySpacingEditBox']:SetText('')
		end,

		-- Builds the DropDownMenu
		['FrameDropDown_OnLoad'] = function()
			wipe(menu.info)
			menu.info.text = strings.buffology_menu.frame_dropdown_title
			menu.info.isTitle = 1
			UIDropDownMenu_AddButton(menu.info)

			for k, v in pairs(settings.frames) do
				wipe(menu.info)
				menu.info.text = k
				menu.info.func = menu.BuffologySetActiveFrame
				UIDropDownMenu_AddButton(menu.info)
			end

			wipe(menu.info)
			menu.info.text = strings.buffology_menu.frame_create_new
			menu.info.func = menu.BuffologyCreateNewFrame
			UIDropDownMenu_AddButton(menu.info)
		end,
	},
	
	-- These functions handle the "Filter"-tab
	['TabFilter'] = {
		-- This is executed, when the "Filter"-tab becomes visible
		['OnShow'] = function(name)
			_G[name..'Caption']:SetText(strings.buffology_menu.caption_filter)	-- set the panel's caption
		end,

		-- Updates the AuraList
		['AuraList_Update'] = function()
			lib.debugging('AuraList_Update()')
		end,
	},
}

-- *****************************************************

	--[[
	
	]]
	menu.BuffologySetActiveFrame = function()
		if (not _G[MENUFRAMENAME]) then return end
		local frame = this.value or this:GetName()
		_G[MENUFRAMENAME..'TabFramesFrameTitle']:SetText(frame)
		_G[MENUFRAMENAME..'TabFramesOption_anchorPointEditBox']:SetText(settings.frames[frame].anchorPoint)
		_G[MENUFRAMENAME..'TabFramesOption_relativeToEditBox']:SetText(settings.frames[frame].relativeTo)
		_G[MENUFRAMENAME..'TabFramesOption_relativePointEditBox']:SetText(settings.frames[frame].relativePoint)
		_G[MENUFRAMENAME..'TabFramesOption_xOffsetEditBox']:SetText(settings.frames[frame].xOffset)
		_G[MENUFRAMENAME..'TabFramesOption_yOffsetEditBox']:SetText(settings.frames[frame].yOffset)
		_G[MENUFRAMENAME..'TabFramesOption_xGrowDirEditBox']:SetText(settings.frames[frame].xGrowDir)
		_G[MENUFRAMENAME..'TabFramesOption_yGrowDirEditBox']:SetText(settings.frames[frame].yGrowDir)
		_G[MENUFRAMENAME..'TabFramesOption_columnsEditBox']:SetText(settings.frames[frame].columns)
		_G[MENUFRAMENAME..'TabFramesOption_xSpacingEditBox']:SetText(settings.frames[frame].xSpacing)
		_G[MENUFRAMENAME..'TabFramesOption_ySpacingEditBox']:SetText(settings.frames[frame].ySpacing)
	end

	--[[
	
	]]
	menu.BuffologyCreateNewFrame = function()
		StaticPopup_Show('BUFFOLOGY_CREATE_FRAME_DIALOG1')
	end

	--[[
	
	]]
	menu.BuffologyInitializeNewFrame = function(newName)
		if ( (not newName) or (newName == '') ) then return end
		if (settings.frames[newName]) then
			StaticPopup_Show('BUFFOLOGY_CREATE_FRAME_DIALOG2')
		else
			settings.frames[newName] = {
				['anchorPoint'] = 'CENTER',
				['relativeTo'] = 'UIParent',
				['relativePoint'] = 'CENTER', 
				['xOffset'] = 0,
				['yOffset'] = 0,
				['xGrowDir'] = 'LEFT', 
				['yGrowDir'] = 'DOWN',
				['columns'] = 16,
				['xSpacing'] = 6,
				['ySpacing'] = 10,
			}
			lib.SetUpFrames(settings.frames, _G['Buffology'])
			_G['Buffology'].framelist[newName]:Show()
		end
	end

	--[[
	
	]]
	menu.CreateMenu = function()
		if menu.MenuFrame then return end

		StaticPopupDialogs['BUFFOLOGY_CREATE_FRAME_DIALOG1'] = {
			text = strings.buffology_menu.frame_create_text,
			button1 = strings.buffology_menu.frame_create_ok,
			button2 = strings.buffology_menu.frame_create_cancel,
			hasEditBox = true,
			OnAccept = function(self)
				menu.BuffologyInitializeNewFrame(self.editBox:GetText())
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}

		StaticPopupDialogs['BUFFOLOGY_CREATE_FRAME_DIALOG2'] = {
			text = strings.buffology_menu.frame_double_text,
			button1 = strings.buffology_menu.frame_create_ok,
			button2 = strings.buffology_menu.frame_create_cancel,
			OnAccept = function(self)
				return
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}

		local frame = CreateFrame('Frame', MENUFRAMENAME, UIParent, 'BuffologyMenuSkel')

		frame:Hide()
		menu.MenuFrame = frame
	end

-- *****************************************************
ns.menu = menu											-- handover of the menu to the namespace