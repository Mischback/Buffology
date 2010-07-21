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
	local Buffology_enchant = CreateFrame('Frame', 'Buffology_enchant', Buffology)
	local Buffology_Icons = {}

	--[[ Updates the duration-time of fading auras
		VOID WeaponEnchantWatcher(FRAME self, INT elapsed)
		This is an OnUpdate-Eventhandler, which checks, if you have a temporary weapon-enchant.
	]]
	core.WeaponEnchantWatcher = function(self, elapsed)
		self.lastUpdate = self.lastUpdate + elapsed
		if ( self.lastUpdate > settings.static.updateInterval) then
			-- lib.debugging('checking for WeaponEnchant')

			if ( not PlayerFrame.unit or PlayerFrame.unit ~= "player" ) then
				return									-- don't check, if the player doesn't control his char
			end

			local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()

			local icon
			if ( hasMainHandEnchant ) then
				icon = Buffology_Icons[1]
				if ( not icon ) then
					icon = lib.CreateIcon()
				end
				icon.name = 'Mainhand'
				icon.texture:SetTexture(GetInventoryItemTexture('player', 16))
				if ( mainHandExpiration ) then
					icon.duration:SetText(lib.TimeFormat(mainHandExpiration/1000))
					icon.duration:Show()
				else
					icon.duration:Hide()
				end
				icon:Show()
				Buffology_Icons[1] = icon
			else
				if ( Buffology_Icons[1] ) then							-- hide icon, if one has already been created
					Buffology_Icons[1]:Hide()							-- hide icon, if one has already been created
				end
			end

			if ( offMainHandEnchant ) then
				icon = Buffology_Icons[2]
				if ( not icon ) then
					icon = lib.CreateIcon()
				end
				icon.name = 'Mainhand'
				icon.texture:SetTexture(GetInventoryItemTexture('player', 17))
				if ( offHandExpiration ) then
					icon.duration:SetText(lib.TimeFormat(offHandExpiration/1000))
					icon.duration:Show()
				else
					icon.duration:Hide()
				end
				icon:Show()
				Buffology_Icons[2] = icon
			else
				if ( Buffology_Icons[2] ) then							-- hide icon, if one has already been created
					Buffology_Icons[2]:Hide()							-- hide icon, if one has already been created
				end
			end

			self.lastUpdate = 0
		end
	end

	--[[ Gets the buff-/debuff-details and creates a new icon, if necessary.
		VOID UpdateIcon(STRING unit, INT index, INT offset, STRING filter)
	]]
	core.UpdateIcon = function(unit, index, offset, filter)
		local name, rank, texture, count, dtype, duration, timeleft, caster, _, _, spellID = UnitAura(unit, index, filter)
		local icon = Buffology_Icons[index+offset]
		if ( not name ) then							-- UNIT_AURA was triggered, but there is no aura on this index (works damn good, when an aura faded, 'cause UNIT_AURA is triggered in this case, too)
			if ( icon ) then							-- hide icon, if one has already been created
				icon:Hide()								-- hide icon, if one has already been created
			end
		else
			if ( not icon ) then						-- UNIT_AURA was triggered, but there is no icon for this index -> let's create one
				icon = lib.CreateIcon()					-- create Icon if necessary
			end

			icon.name = name							-- set the name
			icon.spellID = spellID						-- set the spellID
			icon.texture:SetTexture(texture)			-- set the texture
			if ( filter == 'HARMFUL' ) then
				icon.isDebuff = true					-- set debuff-flag
			end

			if ( duration > 0 ) then					-- we got a time-limited aura
				icon.timeleft = timeleft				-- apply timeleft
				icon:SetScript('OnUpdate', lib.UpdateAuraTime)	-- apply the OnUpdate-handler
				icon.duration:Show()					-- show the text
			else										-- we got a permanent aura
				icon.timeleft = nil						-- no timeleft
				icon:SetScript('OnUpdate', nil)			-- no OnUpdate-handler necessary
				icon.duration:Hide()					-- hide the text
			end

			if ( icon.cd ) then							-- apply the cooldown-spiral TODO: Do we want this?
				if ( duration and duration > 0 ) then
					icon.cd:SetCooldown(timeleft - duration, duration)
					icon.cd:Show()
				else
					icon.cd:Hide()
				end
			end

			icon:Show()
			Buffology_Icons[index+offset] = icon
		end
	end

	--[[ This function is triggered by UNIT_AURA. It just walks over ALL of your buffs/debuffs to make sure, none is missed.
		VOID Trigger(STRING unit)
	]]
	core.Trigger = function(_, _, unit)
		if ( unit ~= 'player' ) then return end			-- jump out, if we're not on 'player'
														-- TODO: Do we want to manage more than player-buffs?!?
		-- lib.debugging('Trigger()')
		local index
		for index = 1, settings.static.buff_maxicons do		-- handle BUFFS
			core.UpdateIcon(unit, index, settings.static.enchant_maxicons, 'HELPFUL')
		end

		for index = 1, settings.static.debuff_maxicons do		-- handle DEBUFFS
			core.UpdateIcon(unit, index, (settings.static.buff_maxicons + settings.static.enchant_maxicons), 'HARMFUL')
		end

-- QUICK'n'DIRTY positioning START
		for k, v in pairs(Buffology_Icons) do
			if (v.isDebuff) then
				if (k == settings.static.buff_maxicons + settings.static.enchant_maxicons + 1) then
					v:SetPoint('CENTER', UIParent, 'CENTER', 0, -60)
				else
					v:SetPoint('CENTER', Buffology_Icons[k-1], 40, 0)
				end
			else 
				if (k == 1) then
					v:SetPoint('CENTER', UIParent, 'CENTER', 0, 60)
				elseif (k == settings.static.enchant_maxicons + 1) then
					v:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
				else
					v:SetPoint('CENTER', Buffology_Icons[k-1], 40, 0)
				end
			end
		end
-- QUICK'n'DIRTY positioning END
	end

	Buffology:RegisterEvent('ADDON_LOADED')
	Buffology:SetScript('OnEvent', function(self, event, addon)
		if ( addon ~= ADDON_NAME ) then return end		-- jump out, if it's not our addon
		if not ( Buffology_trigger ) then return end	-- jump out, if we don't got a trigger

		-- lib.debugging('Buffology loaded...')

		Buffology_trigger:RegisterEvent('UNIT_AURA')
		Buffology_trigger:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		Buffology_trigger:RegisterEvent('CHARACTER_POINTS_CHANGED')
		Buffology_trigger:RegisterEvent('PLAYER_ENTERING_WORLD')
		Buffology_trigger:RegisterEvent('PLAYER_XP_UPDATE')		-- DEBUG-purposes
		Buffology_trigger:SetScript('OnEvent', core.Trigger)

		Buffology_enchant.lastUpdate = 0
		Buffology_enchant:SetScript('OnUpdate', core.WeaponEnchantWatcher)

		core.Trigger(_, _, 'player')
	end)

-- *****************************************************
ns.core = core											-- handover of the core to the namespace