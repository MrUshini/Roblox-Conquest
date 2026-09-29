--!strict

-- Imports
local UnitDataModule = require(game.ReplicatedStorage.Shared.ClassTypes.UnitData)
type UnitData = UnitDataModule.UnitData
type WeaponSlot = UnitDataModule.WeaponSlot
type WeaponMultiplier = UnitDataModule.WeaponMultiplier


local WeaponDataModule = require(game.ReplicatedStorage.Shared.ClassTypes.WeaponData)
type WeaponData = WeaponDataModule.WeaponData

local SkibidiWeapons = require(game.ServerStorage.Content.Weapons.skibidi)

-- 

local Units: {[string]: UnitData} = {
	["NormalToilet"] = {
		-- General
		Name = "NormalToilet",
		Desc = "Basic Skibidi toilet unit. Cheap, aggressive and disposable.",
		DefaultIcon = "rbxassetid://0",

		-- Stats
		MaxHealth = 120,
		MoveSpeed = 10,
		Armor = 5,
		ArmorCoverPercent = 0.2,
		Agility = 8,
		Size = 1,

		-- Flags
		IsFlying = false,

		-- Weaponry
		AllowedWeapons = {
			["NormalToiletHeadbutt"] = {
				Weapon = SkibidiWeapons["NormalToiletHeadbutt"],
				MaxAmmo = 0,
				Multipliers = {
					Accuracy = 1,
					Range = 1,
					Damage = 1,
					ReloadTime = 1,
				} :: WeaponMultiplier,
				Icon = "rbxassetid://0",
			} :: WeaponSlot,
		},

		DefaultWeaponName = "NormalToiletHeadbutt",
	}
}

return Units