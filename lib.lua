--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is lib.lua, where general functions are implemented.
	
	VOID debugging(STRING text) - prints a message to the chat-frame
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = ns.settings							-- get the settings
local lib = CreateFrame('Frame')						-- create the lib
-- *****************************************************

	--[[ Debugging to ChatFrame
		VOID debugging(STRING text)
		Adds the given 'text' to the ChatFrame1
	]]
	lib.debugging = function(text)
		DEFAULT_CHAT_FRAME:AddMessage('|cffffff00Buffology:|r |cffeeeeee'..text..'|r')
	end

	--[[ Creates a buff-/debuff-icon. It's a clickable button
		FRAME CreateIcon()
		TODO: Work on COUNT, TIME and TOOLTIP, make it CANCELABLE, perhaps DEBUFF-coloring
	]]
	lib.CreateIcon = function()
		lib.debugging('CreateIcon()')

		local icon = CreateFrame("Button", nil, UIParent)
		-- icon:EnableMouse(true)
		-- icon:RegisterForClicks'RightButtonUp'

		icon:SetWidth(32)
		icon:SetHeight(32)

		local cd = CreateFrame("Cooldown", nil, icon)
		cd:SetAllPoints(icon)
		icon.cd = cd

		local texture = icon:CreateTexture(nil, "BACKGROUND")
		texture:SetAllPoints(icon)
		icon.texture = texture

		-- local count = icon:CreateFontString(nil, "OVERLAY")
		-- count:SetFontObject(NumberFontNormal)
		-- count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -1, 0)
		-- icon.count = count

		-- local overlay = icon:CreateTexture(nil, "OVERLAY")
		-- overlay:SetTexture"Interface\\Buttons\\UI-Debuff-Overlays"
		-- overlay:SetAllPoints(icon)
		-- overlay:SetTexCoord(.296875, .5703125, 0, .515625)
		-- icon.overlay = overlay

		-- TODO: Get a tooltip
		-- icon.UpdateTooltip = UpdateTooltip
		-- icon:SetScript("OnEnter", OnEnter)
		-- icon:SetScript("OnLeave", OnLeave)

		icon:SetPoint('CENTER')

		return icon
	end

-- *****************************************************
ns.lib = lib											-- handover of the lib to the namespace