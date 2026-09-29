--!strict

local BattlegroupTemplateModule = require(game.ReplicatedStorage.Shared.ClassTypes.BattlegroupTemplate)
type BattlegroupTemplate = BattlegroupTemplateModule.BattlegroupTemplate

local AllianceUnits = require(game.ServerStorage.Content.Entities.Units.the_alliance)


local groupTemplates: {[string]: BattlegroupTemplate} = {
	["3CameraMan"] = {
		-- General
		Name = "SoloCameraMan",
		Icon = "rbxassetid://0",

		UnitSlots = {
			{Unit=AllianceUnits["CameraMan"], WeaponNames={}},
			{Unit=AllianceUnits["CameraMan"], WeaponNames={}},
			{Unit=AllianceUnits["CameraMan"], WeaponNames={}}
		}
	}
}


return groupTemplates