local function UpdateElement(self)
	local notFull = UnitHealth('player') ~= UnitHealthMax('player') or
		(UnitPowerType("player") == 1 and UnitMana('player') > 0) or
		(UnitPowerType("player") ~= 1 and UnitMana('player') ~= UnitManaMax('player'))

	if(notFull) then
		self:SetAlpha(1)
	elseif(UnitAffectingCombat('player')) then
		self:SetAlpha(1)
	elseif(UnitExists('target')) then
		self:SetAlpha(1)
	elseif(self.Castbar.casting) then
		self:SetAlpha(1)
	else
		self:SetAlpha(self.BarFade.alpha or 0.25)
	end
end

oUF:RegisterInitCallback(function(self)
	local unit = self.unit
	if(self.BarFade) then
		local val = 0
		local event = CreateFrame('Frame')
		event:SetScript('OnUpdate', function(_, al)
			val = val + al
			if(val > 0.25) then
				UpdateElement(self)
				val = 0
			end
		end)
	end
end)
