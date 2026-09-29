--!strict

-- Imports

local Projectile = require(game.ReplicatedStorage.Shared.ClassTypes.Projectile)
type Projectile = Projectile.Projectile

--

local Projectiles: {[string]: Projectile} = {}
	
Projectiles["5.56"] = {
	name = "5.56mm",
	health = 1,
	speed = 800,
	icon = "rbxassetid://0",	
	isDestroyable = false,
}


return Projectiles