local Selection = game:GetService("Selection")
local UserInputService = game:GetService("UserInputService")
local ClientState = require(script.Parent:WaitForChild("ClientState"))
local SelectionController = require(script.Parent:WaitForChild("SelectionController"))
local PinController = require(script.Parent:WaitForChild("PinController"))
local camera = workspace.CurrentCamera
local pinHeightY = 11

-- TEST
local ChangeGameState = game.ReplicatedStorage.RemoteEvents.ChangeGameState
local tacticalPhase = true
-- TEST

local function getWorldMousePos() : Vector3?
	local mousePos = UserInputService:GetMouseLocation()
	
	local mouseRay = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {
		workspace.ClientVisuals,
	}
	
	local result = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000)
	
	if result == nil then
		return nil
	end
	
	return result.Position
end

local function setSelectedGroupDestination()
	local selected = SelectionController:GetSelectedGroup()
	if selected == nil then
		return
	end

	local groupId = selected:GetAttribute("id")
	if typeof(groupId) ~= "number" then
		return
	end

	local targetPos = getWorldMousePos()
	if targetPos == nil then
		return
	end

	targetPos = Vector3.new(
		targetPos.X,
		pinHeightY,
		targetPos.Z
	)

	PinController:SetPosition(groupId, targetPos)
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then
		return
	end
	
	-- Setting Pin for selected Group
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		setSelectedGroupDestination()
	end
	
	-- Clearing Selected Group
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		PinController:Hide(groupId)
		SelectionController:ClearSelectedGroup()
		print("Selected Cleared")
	end
	
	-- (TEST) Change Game State
	if input.KeyCode == Enum.KeyCode.R then
		ChangeGameState:FireServer()
		print("Game State Changed")
		tacticalPhase = not tacticalPhase
		local player = game.Players.LocalPlayer
		local screenGUI = player.PlayerGui:WaitForChild("ScreenGui")
		local phaseIndicator = screenGUI:WaitForChild("PhaseIndicator")
		if tacticalPhase then
			phaseIndicator.Image = "rbxassetid://79138495645006"
			print("Changed1")
		else
			phaseIndicator.Image = "rbxassetid://118902621233700"
			print("Changed2")
		end
	end	
end)