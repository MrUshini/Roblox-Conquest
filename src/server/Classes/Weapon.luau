local WeaponDataModule = require(game.ReplicatedStorage.Types.WeaponData)
type WeaponData = WeaponDataModule.WeaponData

local Weapon = {}
Weapon.__index = Weapon

export type Weapon = {
	weaponData: WeaponData,
	maxAmmo: number,
	currentAmmo: number,
	clip: number
}

function Weapon.new(weaponData: WeaponData, maxAmmo: number) 
	local self = setmetatable({}, Weapon) :: Weapon
	
	self.weaponData = weaponData
	self.maxAmmo = maxAmmo
	self.currentAmmo = maxAmmo
	self.clip = weaponData.ClipSize
	
	return self :: Weapon
end

return Weapon