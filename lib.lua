--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is lib.lua, where general functions are implemented.
	
	VOID debugging(STRING text) - prints a message to the chat-frame
	FONTOBJECT CreateFontObject(FRAME parent, INT size, STRING font) - Creates a font-object
	STRING TimeFormat(FLOAT left) - Formats a timestring
	VOID SetUpFrames(TABLE frames, FRAME parent) - Creates the buff-frames
	FRAME CreateIcon() - Creates an aura-icon
	VOID UpdateAuraTime(FRAME self, INT elapsed) - Updates the time of an icon
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

    --[[ Creates a font-object
		FONTOBJECT CreateFontObject(FRAME parent, INT size, STRING font)
	]]
	lib.CreateFontObject = function(parent, size, font)
    	local fo = parent:CreateFontString(nil, 'OVERLAY')
    	fo:SetFont(font, size, 'OUTLINE')
    	fo:SetJustifyH('LEFT')
    	fo:SetShadowColor(0,0,0)
    	fo:SetShadowOffset(1, -1)
    	return fo
    end

	--[[ Formats a float into a time
		STRING TimeFormat(FLOAT left)
	]]
	lib.TimeFormat = function(left)
		local rtime = '00:00'
		left = math.floor(left)
		if ( left > 59 ) then
			local minutes = math.floor(left/60)
			local seconds = left-(minutes*60)
			if seconds < 10 then seconds = '0'..seconds end
			rtime = minutes..':'..seconds
		else
			local seconds = left
			if seconds < 10 then seconds = '0'..seconds end
			rtime = '00:'..seconds
		end
		return rtime
	end

	--[[ Creates the buff-frames
		VOID SetUpFrames(TABLE frames, FRAME parent)
	]]
	lib.SetUpFrames = function(frames, parent)
		-- lib.debugging('SetUpFrames()')
		for k, v in pairs(frames) do
			-- lib.debugging(k)
			if ( not parent.framelist[k] ) then
				local frame = CreateFrame('Frame', k, parent)

				frame.icons = 0

				frame:SetWidth(32)
				frame:SetHeight(32)

				frame.texture = frame:CreateTexture()
				frame.texture:SetAllPoints(frame)
				frame.texture:SetTexture(1, 0, 0, 0.7)

				frame.caption = lib.CreateFontObject(frame, 12, settings.options.fonts.count)
				frame.caption:SetPoint(v['anchorPoint'], frame, v['anchorPoint'], 0, 0)
				frame.caption:SetText(k)

				frame:SetPoint(v['anchorPoint'], v['relativeTo'], v['relativePoint'], v['xOffset'], v['yOffset'])
				frame:Hide()

				parent.framelist[k] = frame
			end
		end
	end

	--[[
	
	]]
	lib.FindDisplayFrame = function(icon)
		if (icon.isDebuff) then
			return 'Buffology_debuffs'
		else
			return 'Buffology_buffs'
		end
	end

	--[[ Creates a buff-/debuff-icon. It's a clickable button
		FRAME CreateIcon()
		TODO: Work on COUNT, TIME and TOOLTIP, make it CANCELABLE, perhaps DEBUFF-coloring
	]]
	lib.CreateIcon = function()
		-- lib.debugging('CreateIcon()')

		local icon = CreateFrame("Button", nil, UIParent)
		-- icon:EnableMouse(true)
		-- icon:RegisterForClicks'RightButtonUp'

		icon:SetWidth(30)
		icon:SetHeight(30)

		local cd = CreateFrame("Cooldown", nil, icon)
		cd:SetAllPoints(icon)
		icon.cd = cd

		local texture = icon:CreateTexture(nil, "BACKGROUND")
		texture:SetAllPoints(icon)
		icon.texture = texture

		local duration = lib.CreateFontObject(icon, 11, settings.options.fonts.duration)
		duration:SetPoint('TOP', icon, 'BOTTOM', 0, 0)
		icon.duration = duration
		icon.duration:SetText('00:00')

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

		icon.lastUpdate = 0

		return icon
	end

	--[[ Updates the duration-time of fading auras
		VOID UpdateAuraTime(FRAME self, INT elapsed)
		This is an OnUpdate-Eventhandler and is therefore called for every button with a timer.
	]]
	lib.UpdateAuraTime = function(self, elapsed)
		self.lastUpdate = self.lastUpdate + elapsed
		if ( self.lastUpdate > settings.static.updateInterval) then
			-- lib.debugging('update '..self.name)
			self.duration:SetText(lib.TimeFormat(self.timeleft - GetTime()))
			self.lastUpdate = 0
		end
	end

-- *****************************************************
ns.lib = lib											-- handover of the lib to the namespace