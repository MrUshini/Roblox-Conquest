--!strict

local terrains = {}

terrains["field"] = {
	name = "Field",
	icon = "",
	color = "",
	
	modifiers = {
		length = 100,
		width = 100,
		
		artillaryMult = 1,
		defenceMult = 1,
		stealthMult = 1,
		rangeMult = 1
	}
}

return terrains
