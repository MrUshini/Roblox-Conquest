local module = {}

export type Terrain = {
	name: string,
	icon: string,
	color: string,
	
	modifiers: TerrainModifiers,
}

export type TerrainModifiers = {
	spawnLength: number,
	spawnWidth: number,
	
	centerLength: number,
	centerWidth: number,
	
	artillaryMult: number,
	defenceMult: number,
	stealthMult: number,
	rangeMult: number
}

return module