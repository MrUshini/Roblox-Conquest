--!strict

-- Imports
local BattlegroupModule = require(game.ServerScriptService.Server.Classes.Battlegroup)
type Battlegroup = BattlegroupModule.BattlegroupInstance

local UnitModule = require(game.ServerScriptService.Server.Classes.Unit)
type UnitInstance = UnitModule.UnitInstance

local RunService = game:GetService("RunService")
--


type ShootTiming = {
	Unit: UnitInstance,
	NextShotTime: number,
}

local Fight = {}
Fight.__index = Fight

export type FightInstance = {
	Running: boolean,
	Group1: Battlegroup,
	Group2: Battlegroup,
	ShootTimings: {ShootTiming},
	UnitStates: {[UnitInstance]: {position: number}},
	fightConnection: RBXScriptConnection?,
	
	InitUnitStates: (self: FightInstance) -> {[UnitInstance]: {position: number}},
	InitFightConnection: (self: FightInstance) -> RBXScriptConnection,
	InitShootTimings: (self: FightInstance) -> (),
	AddShootTiming: (self: FightInstance, shootTiming: ShootTiming) -> (),
	NextShootTiming: (self: FightInstance, pop: boolean?) -> ShootTiming,
	StartFight: (self: FightInstance) -> (),
	EndFight: (self: FightInstance) -> (),
	PerformAttack: (self: FightInstance, shootTiming: ShootTiming) -> (),
	GetVictims: (self: FightInstance, attacker: UnitInstance, victimNumber: number) -> {UnitInstance},
	UpdateShootTiming: (self: FightInstance, shootTiming: ShootTiming) -> ShootTiming,
	CheckForEnd: (self: FightInstance) -> ()
}

function Fight.new(group1: Battlegroup, group2: Battlegroup, startDistance: number): FightInstance
	local self = setmetatable({}, Fight) :: any
	local fight = self :: FightInstance

	fight.ShootTimings = {}
	fight.Running = false
	fight.Group1 = group1
	fight.Group2 = group2
	fight.UnitStates = fight:InitUnitStates()

	fight:InitShootTimings()
	fight:StartFight()
	self.fightConnection = fight:InitFightConnection()

	return fight
end

function Fight.InitFightConnection(self: FightInstance)
	return RunService.Heartbeat:Connect(function(deltaTime: number) 
		if not self.Running then
			return
		end
		while true do
			local currentTime = workspace:GetServerTimeNow()
			if currentTime < self:NextShootTiming().NextShotTime then break end
			local popTiming = true
			local nextShootTiming = self:NextShootTiming(popTiming)
			self:PerformAttack(nextShootTiming)
			nextShootTiming = self:UpdateShootTiming(nextShootTiming)
			self:AddShootTiming(nextShootTiming)
		end
	end)
end

function Fight.InitShootTimings(self: FightInstance)
	for _, group in ipairs({ self.Group1, self.Group2 }) do
		for _, unit in ipairs(group.Units) do
			local currentTime = workspace:GetServerTimeNow()
			local nextShotTiming = currentTime + unit:CalculateNextShotTiming()
			local shootTiming: ShootTiming = {
				Unit = unit,
				NextShotTime = nextShotTiming,
			}
			self:AddShootTiming(shootTiming)
		end
	end
end

function Fight.AddShootTiming(self: FightInstance, shootTiming: ShootTiming)
	for i, existingTiming in ipairs(self.ShootTimings) do
		if existingTiming.NextShotTime > shootTiming.NextShotTime then
			table.insert(self.ShootTimings, i, shootTiming)
			return
		end
	end
	table.insert(self.ShootTimings, shootTiming)
end

function Fight.NextShootTiming(self: FightInstance, pop: boolean?): ShootTiming
	pop = pop or false
	local first = self.ShootTimings[1]
	if pop then
		table.remove(self.ShootTimings, 1)
	end
	assert(first ~= nil, "No shoot timings available")
	return first
end

function Fight.UpdateShootTiming(self: FightInstance, shootTiming: ShootTiming)
	local currentTime = workspace:GetServerTimeNow()
	local nextShotTiming = currentTime + shootTiming.Unit:CalculateNextShotTiming()
	shootTiming.NextShotTime = nextShotTiming
	return shootTiming
end


function Fight.StartFight(self: FightInstance)
	self.Running = true
end

function Fight.EndFight(self: FightInstance)
	self.Running = false
	if self.fightConnection then
		self.fightConnection:Disconnect()
		self.fightConnection = nil
	end
end

function Fight.PerformAttack(self: FightInstance, shootTiming: ShootTiming)
	local attacker = shootTiming.Unit
	local victimNumber = attacker.ActiveWeapon.weaponData.VictimNumber
	local victims = self:GetVictims(attacker, victimNumber)
	if victims == nil or #victims == 0 then return nil end
	for _, victim in ipairs(victims) do
		attacker:Attack(victim)
	end
	
	-- Check for dead units
	self:CheckForEnd()
	
	return nil
end

function Fight.CheckForEnd(self: FightInstance)
	for _, group in ipairs({ self.Group1, self.Group2 }) do
		if #group:UnitsAlive() == 0 then
			self:EndFight()
			print(string.format("Fight ended! Group %s has lost!", group.Template.Name))
		end
	end
end

function Fight.GetVictims(self: FightInstance, attacker: UnitInstance, victimNumber: number) : {UnitInstance}?
	local victims = {}
	local attackerOwnerId = attacker.OwnerId
	local unitsChosen = 0
	for _, group in ipairs({ self.Group1, self.Group2 }) do
		if group.OwnerId == attackerOwnerId then 
			continue
		end
		if #group:UnitsAlive() == 0 then
			 continue
		end 
		local text = string.format("Group %s has %d units alive", group.Template.Name, #group:UnitsAlive())
		for _, unit in ipairs(group:UnitsAlive()) do
			table.insert(victims, unit)
			local text = string.format("Unit %s was added to group %s", unit.Data.Name, group.Template.Name)
			unitsChosen += 1
			if unitsChosen == victimNumber then return victims end
		end
	end
	
	if (#victims == 0) then
		print("An alive unit couldn't be found")
		self.Running = false
		return nil
	else
		return victims
	end
end -- TO BE REFACTORED. Change how the victim is being chosen. Use random + attack range and etc

return Fight