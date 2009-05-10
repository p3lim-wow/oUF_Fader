--[[

	Shared:
	 - BarFade [boolean]
	 - BarFadeMinAlpha [value] default: 0.25
	 - BarFadeMaxAlpha [value] default: 1

--]]

local function pending(self, unit)
	local num, str = UnitPowerType(unit)
	if(self.Castbar and (self.Castbar.casting or self.Castbar.channeling)) then return true end
	if(UnitAffectingCombat(unit)) then return true end
	if(unit == 'pet' and GetPetHappiness() and GetPetHappiness() < 3) then return true end
	if(UnitExists(unit..'target')) then	return true end
	if(UnitHealth(unit) < UnitHealthMax(unit)) then return true end
	if((str == 'RAGE' or str == 'RUNIC_POWER') and UnitPower(unit) > 0) then return true end
	if((str ~= 'RAGE' and str ~= 'RUNIC_POWER') and UnitMana(unit) < UnitManaMax(unit)) then return true end
end

local function Update(self, event, unit)
	if(unit and unit ~= self.unit) then return end

	if(not pending(self, self.unit)) then
		self:SetAlpha(self.BarFaderMinAlpha or 0.25)
	else
		self:SetAlpha(self.BarFaderMaxAlpha or 1)
	end
end

local function Enable(self, unit)
	if(unit and self.BarFade) then
		Update(self)

		self:RegisterEvent('UNIT_COMBAT', Update)
		self:RegisterEvent('UNIT_HAPPINESS', Update)
		self:RegisterEvent('UNIT_TARGET', Update)
		self:RegisterEvent('UNIT_FOCUS', Update)
		self:RegisterEvent('UNIT_HEALTH', Update)
		self:RegisterEvent('UNIT_POWER', Update)
		self:RegisterEvent('UNIT_ENERGY', Update)
		self:RegisterEvent('UNIT_RAGE', Update)
		self:RegisterEvent('UNIT_MANA', Update)
		self:RegisterEvent('UNIT_RUNIC_POWER', Update)

		if(self.Castbar) then
			self.PostCastStart = Update
			self.PostCastFailed = Update
			self.PostCastInterrupted = Update
			self.PostCastDelayed = Update
			self.PostCastStop = Update
			self.PostChannelStart = Update
			self.PostChannelUpdate = Update
			self.PostChannelStop = Update
		end

		return true
	end
end

local function Disable(self)
	if(self.BarFade) then
		self:UnregisterEvent('UNIT_COMBAT', Update)
		self:UnregisterEvent('UNIT_HAPPINESS', Update)
		self:UnregisterEvent('UNIT_TARGET', Update)
		self:UnregisterEvent('UNIT_FOCUS', Update)
		self:UnregisterEvent('UNIT_HEALTH', Update)
		self:UnregisterEvent('UNIT_POWER', Update)
		self:UnregisterEvent('UNIT_ENERGY', Update)
		self:UnregisterEvent('UNIT_RAGE', Update)
		self:UnregisterEvent('UNIT_MANA', Update)
		self:UnregisterEvent('UNIT_RUNIC_POWER', Update)

		if(self.Castbar) then
			self.PostCastStart = nil
			self.PostCastFailed = nil
			self.PostCastInterrupted = nil
			self.PostCastDelayed = nil
			self.PostCastStop = nil
			self.PostChannelStart = nil
			self.PostChannelUpdate = nil
			self.PostChannelStop = nil
		end
	end
end

oUF:AddElement('BarFader', Update, Enable, Disable)