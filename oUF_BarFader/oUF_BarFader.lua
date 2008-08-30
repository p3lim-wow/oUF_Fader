local function UpdateElement(self, unit)
	if(unit == 'player' and self.BarFade) then
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
			self:SetAlpha(self.Castbar.casting and 1 or (self.BarFadeAlpha or 0.25))
		else
			self:SetAlpha(self.BarFadeAlpha or 0.25)
		end
	elseif(unit == 'pet' and self.BarFade) then
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
			self:SetAlpha((happiness < 3) and 1 or (self.BarFadeAlpha or 0.25))
		else
			self:SetAlpha(self.BarFadeAlpha or 0.25)
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
			self:SetAlpha(self.BarFadeAlpha or 0.25)
		end	
	end
end

oUF:RegisterInitCallback(function(self)
	local event = CreateFrame('Frame')
	event:SetScript('OnEvent', function() UpdateElement(self, self.unit) end)
	event:RegisterEvent('PLAYER_LOGIN')
	event:RegisterEvent('PLAYER_REGEN_ENABLED')
	event:RegisterEvent('PLAYER_REGEN_DISABLED')
	event:RegisterEvent('PLAYER_TARGET_CHANGED')
	event:RegisterEvent('PLAYER_FOCUS_CHANGED')
	event:RegisterEvent('UNIT_HAPPINESS')
	event:RegisterEvent('UNIT_HEALTH')
	event:RegisterEvent('UNIT_MANA')
	event:RegisterEvent('UNIT_TARGET')
	event:RegisterEvent('UNIT_SPELLCAST_START')
	event:RegisterEvent('UNIT_SPELLCAST_STOP')
	event:RegisterEvent('UNIT_SPELLCAST_CHANNEL_START')
	event:RegisterEvent('UNIT_SPELLCAST_CHANNEL_STOP')
end)