local WeaponDataModule = require(game.ReplicatedStorage.Shared.ClassTypes.WeaponData)
type WeaponData = WeaponDataModule.WeaponData

local weapons: {[string]: WeaponData} = {
	["NormalToiletHeadbutt"] = {
		Name = "NormalToiletHeadbutt",
		DisplayName = "Headbutt",
		Description = "A brutal ceramic headbutt attack.",
		Icon = "rbxassetid://0", -- TODO

		-- Weapon Stats
		Damage = 18,
		Range = 4,
		FireRate = 1.2,
		Accuracy = 1,
		BulletPerShot = 1,

		-- Weapon Physics
		ClipSize = 0,
		ReloadTime = 0,
		PickupTime = 0.3,

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
	} :: WeaponData
}

return weapons
