module = {}

local WeaponModule = require(game.ReplicatedStorage.Shared.ClassTypes.WeaponData)
type WeaponData = WeaponModule.WeaponData

local UnitDataModule = require(game.ReplicatedStorage.Shared.ClassTypes.UnitData)
type UnitData = UnitDataModule.UnitData

export type BattleGroupRef = {
    owner: number,
}

export type WeaponClientData = {
    weaponData: WeaponData,
	maxAmmo: number,
	currentAmmo: number,
	clip: number
}

export type UnitClientData = {
	Group: BattleGroupRef,
	Data: UnitData,
	CurrentHealth: number,
	id: number,
	
	-- Weapons
	Weapons: {WeaponClientData},
	EmptyWeapons: {WeaponClientData},
	ActiveWeapon: WeaponClientData,
}

export type BattlegroupClientData = {
	
}

return module