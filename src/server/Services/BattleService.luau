--!strict

local Unit = require(game.ServerScriptService.Server.Classes.Unit)
type Unit = Unit.UnitInstance

local BattleService = {}

function BattleService.Attack(attacker: Unit, victim: Unit)
	local activeWeapon = attacker.ActiveWeapon
	if (not activeWeapon) then print("NO ACTIVE WEAPON, YOU'RE STUPID IDIOT") end
	local weaponData = activeWeapon.weaponData
	local damage = weaponData.Damage
	local damageMult = attacker:GetWeaponMult(weaponData.Name).Damage
	local damageToDeal = damage * damageMult

	local isMissed = BattleService.IsMissed(attacker, victim)
	
	-- Calculate if bullet destroyed or not
	
	local healthBefore = victim.CurrentHealth
	victim:TakeDamage(damageToDeal)
	print(string.format("Unit %s(%d) attacked %s(%d). He dealth %d damage! Victim health: %d -> %d", attacker.Data.Name, attacker.id, victim.Data.Name, victim.id, damageToDeal, healthBefore, victim.CurrentHealth))


	if (not weaponData.IsInfiniteClip) then
		activeWeapon.clip = math.max(activeWeapon.clip - weaponData.BulletPerShot, 0)

		if (activeWeapon.clip == 0) then
			attacker:Reload()
		end
	end

end

function BattleService.IsMissed(attacker: Unit, victim: Unit) : boolean
	local totalAccuracy = attacker.ActiveWeapon.weaponData.Accuracy * attacker:GetWeaponMult(attacker.ActiveWeapon.weaponData.Name).Accuracy
	local projectileSpeed = attacker.ActiveWeapon.weaponData
	local victimAgility = victim.Data.Agility
	local victimSpeed = victim.Data.MoveSpeed

	--[[
	
	* Accuracy of weapon  +++
	* Attacker Accuracy Multiplier +++
	* Random 
	* Projectile Speed +++
	* Victim Agility ---
	* Victim Speed ---
	* Victim Size +++
	* Melee doesnt consider distance
	
	]]--
	return false
	
end

function BattleService.IsProjectileDestroyed() : boolean
	return false
end

return BattleService