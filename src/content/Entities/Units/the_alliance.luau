--!strict

-- Imports
local UnitDataModule = require(game.ReplicatedStorage.Types.UnitData)
type UnitData = UnitDataModule.UnitData
type WeaponSlot = UnitDataModule.WeaponSlot
type WeaponMultiplier = UnitDataModule.WeaponMultiplier


local WeaponDataModule = require(game.ReplicatedStorage.Types.WeaponData)
type WeaponData = WeaponDataModule.WeaponData

local AllianceWeapons = require(game.ServerStorage.Content.Weapons.the_alliance)

-- 

type UnitsDict = {
	[string]: UnitData
}

local Units: UnitsDict = {
	["CameraMan"] = {
		-- General
		Name = "CameraMan",
		Desc = "Basic Camera infantry. Reliable, flexible, and cheap. Good starter unit.",
		DefaultIcon = "rbxassetid://0", -- TODO

		-- Stats
		MaxHealth = 100,
		MoveSpeed = 12,
		Armor = 10,
		ArmorCoverPercent = 0.35, -- 35% of cover bonus applies (example meaning)
		Agility = 12,
		Size = 1,

		-- Flags
		IsFlying = false,

		-- Weaponry
		AllowedWeapons = {
			["CameraManMelee"] = {
				Weapon = AllianceWeapons["NormalCameraManFists"],
				MaxAmmo = 0, -- melee
				Multipliers = {
					Accuracy = 1,
					Range = 1,
					Damage = 1,
					ReloadTime = 1,
				} :: WeaponMultiplier,
				Icon = "rbxassetid://0",
			} :: WeaponSlot,
		},

		DefaultWeaponName = "CameraManMelee",
	}
}


return Units