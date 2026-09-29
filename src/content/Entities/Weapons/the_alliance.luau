local ServerStorage = game:GetService("ServerStorage")
local Projectiles = require(ServerStorage.Content.Entities.Projectile.General.Projectiles)
local WeaponDataModule = require(game.ReplicatedStorage.Shared.ClassTypes.WeaponData)
type WeaponData = WeaponDataModule.WeaponData

local weapons: {[string]: WeaponData} = {}

weapons["NormalCameraManFists"] = {
	-- General Data
	Name = "CameraManMelee",
	DisplayName = "Camera Baton",
	Description = "Standard issue baton used by CameraMen in close combat. Fast swings, reliable damage.",
	Icon = "rbxassetid://0", -- TODO: set your icon asset id

	-- Weapon Stats
	Damage = 18,
	Range = 3.5,
	FireRate = 2.2, -- attacks per second (roughly)
	Accuracy = 1, -- melee hits are basically guaranteed if in range
	BulletPerShot = 1,

	-- Weapon Physics
	ClipSize = 1, -- irrelevant for melee, but keep valid
	ReloadTime = 0,
	PickupTime = 0.35,
	Projectile = nil,

	-- Weapon Effects
	Pierce = 0,
	Splash = 0,
	VictimNumber = 1,

	-- Flags
	IsDefault = true,
	IsMelee = true,
	IsArtillary = false,
	IsInfiniteClip = true,
	IsInfiniteAmmo = true,
	IsDroppable = false,
}

weapons["XM5"] = {
	-- General Data
	Name = "CameraManMelee",
	DisplayName = "Camera Baton",
	Description = "Standard issue baton used by CameraMen in close combat. Fast swings, reliable damage.",
	Icon = "rbxassetid://0", -- TODO: set your icon asset id

	-- Weapon Stats
	Damage = 18,
	Range = 3.5,
	FireRate = 2.2, -- attacks per second (roughly)
	Accuracy = 1, -- melee hits are basically guaranteed if in range
	BulletPerShot = 1,

	-- Weapon Physics
	ClipSize = 1, -- irrelevant for melee, but keep valid
	ReloadTime = 0,
	PickupTime = 0.35,
	Projectile = Projectiles["5.56"],

	-- Weapon Effects
	Pierce = 0,
	Splash = 0,
	VictimNumber = 1,

	-- Flags
	IsDefault = true,
	IsMelee = true,
	IsArtillary = false,
	IsInfiniteClip = true,
	IsInfiniteAmmo = true,
	IsDroppable = true,
}

return weapons
