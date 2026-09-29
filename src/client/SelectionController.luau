-- SelectionController ModuleScript

local SelectionController = {}
local SelectBattlegroupRemoteEvent =
	game.ReplicatedStorage.RemoteEvents:WaitForChild("SelectBattlegroup") :: RemoteEvent

local ClientState = require(script.Parent.ClientState)

function SelectionController:SetSelectedGroup(battlegroupBody: Model)
	local previous = ClientState.SelectedBattlegroupId :: number?

	if previous then
		self:ClearSelectedGroup()
	end

	ClientState.SelectedBattlegroupId = battlegroupBody:GetAttribute("id")

	local outline = battlegroupBody:FindFirstChild("Outline")
	if outline and outline:IsA("BasePart") then
		outline.Color = Color3.fromRGB(255, 255, 0)
	end

	local groupId = battlegroupBody:GetAttribute("id")
	PinController:MakeVisible(groupId)
end

function SelectionController:ClearSelectedGroup()
	local selectedGroupId = ClientState.SelectedBattlegroupId

	if not selected then
		return
	end

	local selected = 
	local outline = selected:FindFirstChild("Outline")
	local originalColor = selected:GetAttribute("outline_color")

	if outline and outline:IsA("BasePart") then
		outline.Color = originalColor
	end

	local groupId = selected:GetAttribute("id")

	ClientState.SelectedBattlegroup = nil
	ClientState.SelectedUnitId = nil
end

function SelectionController:GetSelectedGroup(): Model?
	return ClientState.SelectedBattlegroup
end

SelectBattlegroupRemoteEvent.OnClientEvent:Connect(function(battlegroupBody: Model)
	SelectionController:SetSelectedGroup(battlegroupBody)
end)

return SelectionController