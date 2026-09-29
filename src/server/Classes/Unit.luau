
-- Imports
local UnitDataModule = require(game.ReplicatedStorage.Shared.ClassTypes.UnitData)
type UnitSlot = UnitDataModule.UnitSlot
type WeaponMult = UnitDataModule.WeaponMultiplier

local WeaponDataModule = require(game.ReplicatedStorage.Shared.ClassTypes.WeaponData)
type WeaponData = WeaponDataModule.WeaponData

local Weapon = require(game.ServerScriptService.Server.Classes.Weapon)
type Weapon = Weapon.Weapon

--

local Unit = {}
Unit.__index = Unit

export type UnitInstance = typeof(setmetatable({} ::
	{
	-- General
	OwnerId: number,
	Data: UnitDataModule.UnitData,
	CurrentHealth: number,
	id: number,
	
	-- Weapons
	Weapons: {Weapon},
	EmptyWeapons: {Weapon},
	ActiveWeapon: Weapon,
	

}, Unit))

function Unit.new(ownerId: number, unitSlot: UnitSlot): UnitInstance	
	local unitData = unitSlot.Unit
	assert(unitData ~= nil, "UnitSlot.Unit is nil")

	local weaponNames = unitSlot.WeaponNames
	table.insert(weaponNames, unitData.DefaultWeaponName) -- Add default weapon
	
	local self = {}
	setmetatable(self, Unit)
	self.OwnerId = ownerId
	self.Data = unitData
	self.CurrentHealth = unitData.MaxHealth
	self.id = 0

	self.Weapons = self:InitializeWeapons(weaponNames)
	self.EmptyWeapons = {}
	
	self.ActiveWeapon = self.Weapons[1]
	 
	return self
end

function Unit.InitializeWeapons(self: UnitInstance, weaponNames: {string}) : {Weapon}
	local weapons = {}
	for _, weaponName in ipairs(weaponNames) do
		local weaponSlot = self.Data.AllowedWeapons[weaponName]
		local errorText = string.format("Unit %s has invalid weapon name: %s", self.Data.Name, weaponName)
		assert(weaponSlot ~= nil, errorText)
		
		local maxAmmo = weaponSlot.MaxAmmo
		local weaponData = weaponSlot.Weapon
		assert(weaponData ~= nil, "WeaponData is nil")
		assert(maxAmmo ~= nil, "MaxAmmo is nil")
		
		local weapon = Weapon.new(weaponData, maxAmmo)
		table.insert(weapons, weapon)
	end
	return weapons
end

function Unit.IsAlive(self: UnitInstance)
	return self.CurrentHealth > 0
end

function Unit.TakeDamage(self: UnitInstance, damage: number)
	self.CurrentHealth = math.max(self.CurrentHealth - damage, 0)
end

function Unit.CalculateNextShotTiming(self: UnitInstance)
	local activeWeapon = self.ActiveWeapon
	local weaponData = activeWeapon.weaponData
	local currentClip = activeWeapon.clip
	local fireRate = weaponData.FireRate
	local reloadTime = weaponData.ReloadTime
	local isInfiniteClip = weaponData.IsInfiniteClip
	local isInfiniteAmmo = weaponData.IsInfiniteAmmo
	local nextShotTiming: number
	
	if not isInfiniteClip and currentClip <= 0 then
		local reloadTimeMult = self:GetWeaponMult(weaponData.Name).ReloadTime
		nextShotTiming = (reloadTime * reloadTimeMult) + fireRate
	else
		nextShotTiming = fireRate
	end
	
	return nextShotTiming	
end

function Unit.GetWeaponMult(self: UnitInstance, weaponName: string) : WeaponMult
	return self.Data.AllowedWeapons[weaponName].Multipliers
end

function Unit.Reload(self: UnitInstance)
	local activeWeapon = self.ActiveWeapon
	if activeWeapon.currentAmmo > 0 then
		local ammoToFill = math.min(activeWeapon.weaponData.ClipSize, activeWeapon.currentAmmo)
		activeWeapon.currentAmmo -= ammoToFill
		activeWeapon.clip = ammoToFill
	else
		self:ChangeToNextWeapon()
	end
end

function Unit.ChangeToNextWeapon(self: UnitInstance)
	local activeWeapon = self.ActiveWeapon
	table.remove(self.Weapons, 1)
	table.insert(self.EmptyWeapons, activeWeapon)
	local text = string.format("%s has changed their weapon to %s", self.Data.Name, activeWeapon.weaponData.Name)
	print(text)
	if #self.Weapons == 0 then
		print("Unit has no more weapons left")
	end
	if self.ActiveWeapon.clip == 0 and not self.ActiveWeapon.weaponData.IsInfiniteClip  then 
		self:Reload() -- Checking NEW active weapon
	end
end

function Unit.GetSize(self: UnitInstance)
	return self.Data.BodyArea * self.Data.Height -- Returns volume of the unit
end

return Unit