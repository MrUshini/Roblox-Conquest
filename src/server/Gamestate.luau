local GameState = {}
local BattlegroupService = require(game.ServerScriptService.Server.Services.BattlegroupService)

-- TEST
local ChangeGameState = game.ReplicatedStorage.RemoteEvents.ChangeGameState
-- TEST

GameState.TacticalPhase = true

ChangeGameState.OnServerEvent:Connect(function()
	GameState.TacticalPhase = not GameState.TacticalPhase
	if GameState.TacticalPhase then
		BattlegroupService.DisableMovement()		
	else
		BattlegroupService.ActivateMovement()
	end
end)

return GameState
