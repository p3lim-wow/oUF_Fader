--[[

	Shared:
	 - BarFade [boolean]
	 - BarFadeMinAlpha [value] default: 0.25
	 - BarFadeMaxAlpha [value] default: 1

--]]

local function Validation(self, unit)
	if(self.Castbar and (self.Castbar.casting or self.Castbar.channeling)) then
		return false
	elseif(UnitAffectingCombat(unit)) then
		return false
	elseif(unit == 'pet' and GetPetHappiness() and GetPetHappiness() < 3) then
		return false
	elseif(UnitExists(unit..'target')) then	
		return false
	elseif(UnitHealth(unit) < UnitHealthMax(unit)) then
		return false
	elseif((UnitPowerType(unit) == 6 or UnitPowerType(unit) == 1) and UnitMana(unit) > 0) then
		return false
	elseif(UnitMana(unit) < UnitManaMax(unit)) then
		return false
	end

	return true
end

local function Update(self)
	if(Validation(self, self.unit)) then
		self:SetAlpha(self.BarFadeMinAlpha or 0.25)
	else
		self:SetAlpha(self.BarFadeMaxAlpha or 1)
	end
end

local function Enable(self)
	if(self.BarFade and self.unit) then
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