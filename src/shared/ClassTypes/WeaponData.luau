--!strict

local Projectile = require(game.ReplicatedStorage.Shared.ClassTypes.Projectile)
type Projectile = Projectile.Projectile

export type WeaponData = {
	-- General Data
	Name: string,
	DisplayName: string,
	Description: string,
	Icon: string,
	
	-- Weapon Stats
	Damage: number,
	Range: number,
	FireRate: number,
	Accuracy: number,
	BulletPerShot: number,
	
	-- Weapon Physics
	ClipSize: number,
	ReloadTime: number,
	PickupTime: number,
	Projectile: Projectile?,
	
	-- Weapon Effects
	Pierce: number,
	Splash: number,
	VictimNumber: number,
	
	-- Flags
	IsDefault: boolean,
	IsMelee: boolean,
	IsArtillary: boolean,
	IsInfiniteClip: boolean,
	IsInfiniteAmmo: boolean,
	IsDroppable: boolean,
}

--Name = "Name",
--DisplayName: string,
--Description: string,
--Icon: string,

---- Weapon Stats
--Damage: number,
--Range: number,
--FireRate: number,
--Accuracy: number,
--BulletPerShot: number,

---- Weapon Physics
--ClipSize: number,
--ReloadTime: number,
--PickupTime: number,

---- Weapon Effects
--Pierce: number,
--Splash: number,

---- Flags
--IsDefault: boolean,
--IsMelee: boolean,
--IsArtillary: boolean,
--IsInfiniteClip: boolean,
--IsInfiniteAmmo: boolean

return {}