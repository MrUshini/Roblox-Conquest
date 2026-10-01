local WeaponDataModule = require(game.ReplicatedStorage.Shared.ClassTypes.WeaponData)
type WeaponData = WeaponDataModule.WeaponData

local Weapon = {}
Weapon.__index = Weapon

export type TWeapon = {
	weaponData: WeaponData,
	maxAmmo: number,
	currentAmmo: number,
	clip: number
}

function Weapon.new(weaponData: WeaponData, maxAmmo: number) 
	local self = {} :: TWeapon
	setmetatable(self, Weapon)
	
	self.weaponData = weaponData
	self.maxAmmo = maxAmmo
	self.currentAmmo = maxAmmo
	self.clip = weaponData.ClipSize
	
	return self :: TWeapon
end

return Weapon