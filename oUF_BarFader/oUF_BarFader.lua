--[[

	Shared:
	 - BarFade [boolean]
	 - BarFadeMinAlpha [value] default: 0.25
	 - BarFadeMaxAlpha [value] default: 1

--]]

local function Regenerating(unit)
	if(UnitHealth(unit) ~= UnitHealthMax(unit)) then
		return true
	else
		if(UnitPowerType(unit) == 6 or UnitPowerType(unit) == 1) then
			if(UnitMana(unit) > 0) then return true end
		else
			if(UnitMana(unit) ~= UnitManaMax(unit)) then return true end
		end
	end
end

local function Update(self)
	local unit = self.unit
	
	if(self.Castbar and (self.Castbar.casting or self.Castbar.channeling)) then
		self:SetAlpha(self.BarFadeMaxAlpha or 1)
	elseif(UnitAffectingCombat(unit)) then
		self:SetAlpha(self.BarFadeMaxAlpha or 1)
	elseif(unit == 'pet' and GetPetHappiness()) then
		self:SetAlpha((GetPetHappiness() < 3) and (self.BarFadeMaxAlpha or 1) or (self.BarFadeMinAlpha or 0.25))
	elseif(UnitExists(unit..'target')) then
		self:SetAlpha(self.BarFadeMaxAlpha or 1)
	elseif(Regenerating(unit)) then
		self:SetAlpha(self.BarFadeMaxAlpha or 1)
	else
		self:SetAlpha(self.BarFadeMinAlpha or 0.25)
	end
end

local function Enable(self)
	if(self.BarFade) then
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