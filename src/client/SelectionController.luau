local BattlegroupRegistry = require(game.ReplicatedStorage.Shared.BattlegroupRegistry)
type TGroupData = BattlegroupRegistry.TGroupData

local SelectionController = {}
local SelectBattlegroupRemoteEvent =
	game.ReplicatedStorage.RemoteEvents:WaitForChild("SelectBattlegroup") :: RemoteEvent

local ClientState = require(script.Parent.ClientState)

function SelectionController:SetSelectedGroup(battlegroupBody: Model) : ()
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
end

function SelectionController:ClearSelectedGroup() : ()
	local selectedGroupId = ClientState.SelectedBattlegroupId
	if not selectedGroupId then
		return -- No Group to clear
	end
	local model = BattlegroupRegistry:GetGroupModel(selectedGroupId) :: Model?
	if not model then
		print("Model couldnt be found")
		return
	end

	local outline = model:FindFirstChild("Outline")
	local originalColor = model:GetAttribute("outline_color")

	if outline and outline:IsA("BasePart") then
		outline.Color = originalColor
	end
end

function SelectionController:GetSelectedGroup(): Model?
	return ClientState.SelectedBattlegroup
end

SelectBattlegroupRemoteEvent.OnClientEvent:Connect(function(battlegroupBody: Model)
	SelectionController:SetSelectedGroup(battlegroupBody)
end)

return SelectionController