--!strict

local UnitDataModule = require(game.ReplicatedStorage.Shared.ClassTypes.UnitData)
type UnitData = UnitDataModule.UnitData
type WeaponSlot = UnitDataModule.WeaponSlot
type UnitSlot = UnitDataModule.UnitSlot

export type BattlegroupTemplate = {
	-- General
	Name: string,
	Icon: string,
	
	-- Units
	UnitSlots: {UnitSlot},
}

return {}