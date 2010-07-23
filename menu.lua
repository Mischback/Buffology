--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is menu.lua, where the menu is defined.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = ns.settings							-- get the settings
local strings = ns.strings								-- get the localization
local lib = ns.lib										-- get the lib
local menu = CreateFrame('Frame')						-- create the menu
-- *****************************************************

	--[[
	
	]]
	function Buffology_MenuFrameClose()
		for _, v in pairs(_G['Buffology'].framelist) do	-- Hide the frame-anchors
			v:Hide()
		end
		menu.MenuFrame:Hide()							-- Hide the menu
	end
	
-- *****************************************************

	--[[
	
	]]
	menu.CreateMenu = function()
		if menu.MenuFrame then return end
		
		lib.debugging('creating menu...')
		
		local frame = CreateFrame('Frame', 'Buffology_Menu', UIParent, 'BuffologyMenuSkel')
		
		frame:Hide()
		menu.MenuFrame = frame
	end

-- *****************************************************
ns.menu = menu											-- handover of the menu to the namespace