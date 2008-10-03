--[[

	Shared:
	 - barFade [boolean]
	 - barFadeAlpha [value] default: 0.25

--]]
local function UpdateElement(self, unit)
	if(unit == 'player' and self.barFade) then
		local l, class = UnitClass('player')
		local notFull = (UnitHealth('player') ~= UnitHealthMax('player')) or
			(UnitPowerType('player') ~= 1 and UnitMana('player') ~= UnitManaMax('player')) or
			(UnitPowerType('player') == 1 and UnitMana('player') > 0)

		if(notFull) then
			self:SetAlpha(1)
		elseif(UnitAffectingCombat('player')) then
			self:SetAlpha(1)
		elseif(UnitExists('target')) then
			self:SetAlpha(1)
		elseif(self.Castbar) then
			self:SetAlpha(self.Castbar.casting and 1 or (self.barFadeAlpha or 0.25))
		else
			self:SetAlpha(self.barFadeAlpha or 0.25)
		end
	elseif(unit == 'pet' and self.barFade) then
		local happiness = GetPetHappiness()
		local notFull = (UnitHealth('pet') ~= UnitHealthMax('pet')) or
			(UnitMana('pet') ~= UnitManaMax('pet'))

		if(notFull) then
			self:SetAlpha(1)
		elseif(UnitAffectingCombat('pet')) then
			self:SetAlpha(1)
		elseif(UnitExists('pettarget')) then
			self:SetAlpha(1)
		elseif(happiness) then
			self:SetAlpha((happiness < 3) and 1 or (self.barFadeAlpha or 0.25))
		else
			self:SetAlpha(self.barFadeAlpha or 0.25)
		end
	elseif(unit == 'focus' and self.BarFade) then
		local notFull = (UnitHealth('focus') ~= UnitHealthMax('focus')) or
			(UnitPowerType('focus') ~= 1 and UnitMana('focus') ~= UnitManaMax('focus')) or
			(UnitPowerType('focus') == 1 and UnitMana('focus') > 0)

		if(notFull) then
			self:SetAlpha(1)
		elseif(UnitAffectingCombat('focus')) then
			self:SetAlpha(1)
		elseif(UnitExists('focustarget')) then
			self:SetAlpha(1)
		else
			self:SetAlpha(self.barFadeAlpha or 0.25)
		end	
	end
end

oUF:RegisterInitCallback(function(self)
	local addon = CreateFrame('Frame')
	addon:SetScript('OnEvent', function() UpdateElement(self, self.unit) end)
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
	addon:RegisterEvent('UNIT_TARGET')
	addon:RegisterEvent('UNIT_SPELLCAST_START')
	addon:RegisterEvent('UNIT_SPELLCAST_STOP')
	addon:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START')
	addon:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP')
end)