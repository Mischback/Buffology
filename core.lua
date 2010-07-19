--[[ Buffology is a World of Warcraft-addon by Mischback.

	This is core.lua, where the addon-core is defined.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local settings = ns.settings							-- get the settings
local lib = ns.lib										-- get the lib
local menu = ns.menu									-- get the menu
local core = CreateFrame('Frame')						-- create the core
-- *****************************************************

	local Buffology = CreateFrame('Frame', 'Buffology', UIParent)
	local Buffology_trigger = CreateFrame('Frame', 'Buffology_trigger', Buffology)
	local Buffs = {}
	local Debuffs = {}


	--[[ Gets the buff-/debuff-details and creates a new icon, if necessary.
		VOID UpdateIcon(TABLE iconType, STRING unit, INT index, STRING filter)
	]]
	core.UpdateIcon = function(iconType, unit, index, filter)
		local name, rank, texture, count, dtype, duration, timeLeft, caster, _, _, spellID = UnitAura(unit, index, filter)
		if ( name ) then
			local icon = iconType[index]
			if ( not icon ) then
				icon = lib.CreateIcon()
			end

			icon.texture:SetTexture(texture)			-- set the texture

			if ( icon.cd ) then							-- apply the cooldown-spiral TODO: Do we want this?
				if ( duration and duration > 0 ) then
					icon.cd:SetCooldown(timeLeft - duration, duration)
					icon.cd:Show()
				else
					icon.cd:Hide()
				end
			end

			iconType[index] = icon
		end
	end

	--[[
	
	]]
	core.GetBuff = function(unit, index)
		core.UpdateIcon(Buffs, unit, index, 'HELPFUL')
	end

	--[[
	
	]]
	core.GetDebuff = function(unit, index)
		core.UpdateIcon(Debuffs, unit, index, 'HARMFUL')
	end

	--[[ This function is triggered by UNIT_AURA. It just walks over ALL of your buffs/debuffs to make sure, none is missed.
		VOID Trigger(STRING unit)
	]]
	core.Trigger = function(_, _, unit)
		if ( unit ~= 'player' ) then return end			-- jump out, if we're not on 'player'
														-- TODO: Do we want to manage more than player-buffs?!?
		lib.debugging('Trigger()')
		local index = 1
		while ( index < settings.static.maxicons ) do	-- since this goes to settings.static.maxicons EVERY time, we can use FOR... But why? TODO: Improve this!
			core.GetBuff(unit, index)
			core.GetDebuff(unit, index)
			index = index + 1
		end
	end

	Buffology:RegisterEvent('ADDON_LOADED')
	Buffology:SetScript('OnEvent', function(self, event, addon)
		if ( addon ~= ADDON_NAME ) then return end		-- jump out, if it's not our addon
		if not ( Buffology_trigger ) then return end	-- jump out, if we don't got a trigger

		-- lib.debugging('Buffology loaded...')

		Buffology_trigger:RegisterEvent('UNIT_AURA')
		Buffology_trigger:SetScript('OnEvent', core.Trigger)
	end)

-- *****************************************************
ns.core = core											-- handover of the core to the namespace