--!strict

local BattlegroupTemplateModule = require(game.ReplicatedStorage.Shared.ClassTypes.BattlegroupTemplate)
type BattlegroupTemplate = BattlegroupTemplateModule.BattlegroupTemplate

local SkibidiUnits = require(game.ServerStorage.Content.Entities.Units.skibidi)

local groupTemplates: {[string]: BattlegroupTemplate} = {
	["2Toilets"] = {
		-- General
		Name = "SoloToilet",
		Icon = "rbxassetid://0",
		
		UnitSlots = {
			{Unit=SkibidiUnits["NormalToilet"], WeaponNames={}},
			{Unit=SkibidiUnits["NormalToilet"], WeaponNames={}},
		}
	}
}


return groupTemplates