--[[

	Shared:
	 - BarFade [boolean]
	 - BarFadeMinAlpha [value] default: 0.25
	 - BarFadeMaxAlpha [value] default: 1

--]]
local function NotFull(unit)
	if(UnitHealth(unit) ~= UnitHealthMax(unit)) then
		return true
	else
		if(UnitPowerType(unit) == 6 or UnitPowerType(unit) == 1) then
			if(UnitMana(unit) > 0) then
				return true
			else
				return false
			end
		else
			if(UnitMana(unit) ~= UnitManaMax(unit)) then
				return true
			else
				return false
			end
		end
	end
end

local function UpdateElement(self)
	if(self.unit == 'player' or self.unit == 'pet' or self.unit == 'focus' or self.unit == 'focustarget' or self.unit == 'targettarget') then
		if(not self.BarFade) then return end

		if(NotFull(self.unit)) then
			self:SetAlpha(self.BarFadeMaxAlpha or 1)
		elseif(UnitAffectingCombat(self.unit)) then
			self:SetAlpha(self.BarFadeMaxAlpha or 1)
		elseif(UnitExists(self.unit..'target')) then
			self:SetAlpha(self.BarFadeMaxAlpha or 1)
		elseif(self.Castbar) then
			self:SetAlpha((self.Castbar.casting or self.Castbar.channeling) and (self.BarFadeMaxAlpha or 1) or (self.BarFadeMinAlpha or 0.25))
		elseif(self.unit == 'pet' and GetPetHappiness()) then
			self:SetAlpha((GetPetHappiness() < 3) and (self.BarFadeMaxAlpha or 1) or (self.BarFadeMinAlpha or 0.25))
		else
			self:SetAlpha(self.BarFadeMinAlpha or 0.25)
		end
	end
end

oUF:RegisterInitCallback(function(obj)
	local addon = CreateFrame('Frame')
	addon:SetScript('OnEvent', function() UpdateElement(obj) end)
	addon:RegisterEvent('PLAYER_LOGIN')
	addon:RegisterEvent('PLAYER_REGEN_ENABLED')
	addon:RegisterEvent('PLAYER_REGEN_DISABLED')
	addon:RegisterEvent('PLAYER_TARGET_CHANGED')
	addon:RegisterEvent('PLAYER_FOCUS_CHANGED')
	addon:RegisterEvent('UNIT_HAPPINESS')
	addon:RegisterEvent('UNIT_HEALTH')
	addon:RegisterEvent('UNIT_MANA')
	addon:RegisterEvent('UNIT_ENERGY')
	addon:RegisterEvent('UNIT_FOCUS')
	addon:RegisterEvent('UNIT_RAGE')
	addon:RegisterEvent('UNIT_RUNIC_POWER')
	addon:RegisterEvent('UNIT_POWER')
	addon:RegisterEvent('UNIT_TARGET')
	addon:RegisterEvent('UNIT_SPELLCAST_START')
	addon:RegisterEvent('UNIT_SPELLCAST_STOP')
	addon:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START')
	addon:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP')
end)