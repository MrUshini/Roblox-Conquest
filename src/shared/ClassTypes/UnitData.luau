--!strict

local WeaponDataModule = require(game.ReplicatedStorage.Shared.ClassTypes.WeaponData)
type WeaponData = WeaponDataModule.WeaponData

export type UnitData = {
	-- General
	Name: string,
	Desc: string,
	DefaultIcon: string,
	
	-- Stats
	MaxHealth: number,
	MoveSpeed: number,
	Armor: number,
	ArmorCoverPercent: number,
	Agility: number,
	
	-- Size
	BodyArea: number,
	Height: number,
	
	-- Flags
	IsFlying: boolean,	
	
	-- Weaponry
	AllowedWeapons: {[string]: WeaponSlot},
	DefaultWeaponName: string,
}

export type WeaponSlot = {
	Weapon: WeaponData,
	MaxAmmo: number,
	Multipliers: WeaponMultiplier,
	Icon: string,
}

export type WeaponMultiplier = {
	Accuracy: number,
	Range: number,
	Damage: number,
	ReloadTime: number
}

export type UnitSlot = {
	Unit: UnitData,
	WeaponNames: {string},
}

return {}