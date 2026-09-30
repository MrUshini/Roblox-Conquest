--!strict

local BattlegroupTemplateModule = require(game.ReplicatedStorage.Shared.ClassTypes.BattlegroupTemplate)
type BattlegroupTemplate = BattlegroupTemplateModule.BattlegroupTemplate

local UnitDataModule = require(game.ReplicatedStorage.Shared.ClassTypes.UnitData)
type UnitData = UnitDataModule.UnitData
type WeaponSlot = UnitDataModule.WeaponSlot
type UnitSlot = UnitDataModule.UnitSlot

local Unit = require(game.ServerScriptService.Server.Classes.Unit)
type UnitInstance = Unit.UnitInstance

local Battlegroup = {}
Battlegroup.__index = Battlegroup

export type BattlegroupInstance = typeof(setmetatable({} :: 
		{
			OwnerId: number,
			Template: BattlegroupTemplate,
			Units: {UnitInstance},
			Body: Model?,
			Destination: Vector3?
		},
		Battlegroup
	)
)

function Battlegroup.new(ownerId: number, template: BattlegroupTemplate, body: Model)
	assert(template ~= nil, "Battlegroup.new: Template is nil")
	local self = {
		OwnerId = ownerId,
		Template = template,
		Units = {} :: {UnitInstance},
		Body = body :: Model,
		Destination = nil :: Vector3?
	}
	setmetatable(self, Battlegroup) -- Linking all missing attributes and methods of self to Battlegroup	
	self.Units = self:InitUnits()
	
	return self
end

function Battlegroup.InitUnits(self: BattlegroupInstance) : {UnitInstance}
	local ownerId = self.OwnerId
	local unitSlots = self.Template.UnitSlots
	if unitSlots == nil then return {} end
	
	local units = {}
	for _, unitSlot in ipairs(unitSlots) do
		local unit = Unit.new(ownerId, unitSlot)
		unit.id = #units + 1
		table.insert(units, unit)
	end
	
	return units
end

function Battlegroup.UnitsAlive(self: BattlegroupInstance) : {UnitInstance}
	local aliveUnits = {}
	for _, unit in ipairs(self.Units) do
		if unit:IsAlive() then
			table.insert(aliveUnits, unit)
		end
	end
	return aliveUnits
end

function Battlegroup:ChangeDestination(position: Vector3) : ()
	self.Destination = position
end

return Battlegroup