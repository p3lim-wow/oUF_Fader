local function UpdateElement(self)
	if(self.BarFade) then
		local notFull = UnitHealth('player') ~= UnitHealthMax('player') or
			(UnitPowerType("player") == 1 and UnitMana('player') > 0) or
			(UnitPowerType("player") ~= 1 and UnitMana('player') ~= UnitManaMax('player'))

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
	end
end

oUF:RegisterInitCallback(function(self)
	local event = CreateFrame('Frame')
	event:SetScript('OnEvent', function() UpdateElement(self) end)
	event:RegisterEvent('PLAYER_REGEN_ENABLED')
	event:RegisterEvent('PLAYER_REGEN_DISABLED')
	event:RegisterEvent('PLAYER_TARGET_CHANGED')
	event:RegisterEvent('UNIT_HEALTH')
	event:RegisterEvent('UNIT_MANA')
	event:RegisterEvent('PLAYER_LOGIN')
end)