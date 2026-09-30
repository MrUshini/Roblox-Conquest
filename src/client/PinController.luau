local ClientState = require(script.Parent.ClientState)
local SelectBattlegroupRemoteEvent = game.ReplicatedStorage.Shared.RemoteEvents:WaitForChild("SelectBattlegroup") :: RemoteEvent

local PinController = {}

type TPinInfo = {
	pinModel: Model?,
	pinPos: Vector3?
}

local pins = {} :: {[number]: TPinInfo}

local pinTempalte = game.ReplicatedStorage.Assests.pinTemplate
local SetPin = game.ReplicatedStorage.RemoteEvents.SetPin
local PinReached = game.ReplicatedStorage.RemoteEvents.PinReached
local HIDDEN_POS = Vector3.new(0, 10000, 0)

function PinController:GetOrCreate(battlegroupID: number): Model
	local pinInfo = pins[battlegroupID]
	
	if pinInfo then
		return pinInfo.pinModel
	end
	
	local newPin = pinTempalte:Clone()
	newPin.Name = 'MovementPin_{battlegroupId}'
	newPin.Parent = workspace.ClientVisuals.Pins
	pins[battlegroupID] = { nil, nil }
	pins[battlegroupID].pinModel = newPin
	pins[battlegroupID].pinPos = nil
	return newPin
end

function PinController:SetPosition(battlegroupID: number, position: Vector3)
	local pin = self:GetOrCreate(battlegroupID)
	pin:PivotTo(CFrame.new(position))
	pins[battlegroupID].pinPos = position
	SetPin:FireServer(battlegroupID, position)
end

function PinController:Remove(battlegroupID: number)
	local pin = pins[battlegroupID]
	if pin then
		pin.pinModel:Destroy()
		pins[battlegroupID] = nil
	end
	SetPin:FireServer(battlegroupID, nil)
end

function PinController:MakeVisible(battlegroupID: number)
	local pinModel: Model = pins[battlegroupID].pinModel
	local pinPos = pins[battlegroupID].pinPos
	
	pinModel:PivotTo(CFrame.new(pinPos))
end

function PinController:Hide(battlegroupID: number)
	local pinModel: Model = pins[battlegroupID].pinModel
	pinModel:PivotTo(CFrame.new(HIDDEN_POS))
end

-- Temporary Function, Until "HideAll" wont be added with feature of multiple groups being selected
function PinController:HideSelected() : ()
	PinController:Hide(ClientState.SelectedBattlegroupId)
end

PinReached.OnClientEvent:Connect(function(groupId)
	PinController:Remove(groupId)
end)

SelectBattlegroupRemoteEvent.OnClientEvent:Connect(function(battlegroupBody: Model) -- One of multiple actions at group selection
	local battlegroupID = battlegroupBody:GetAttribute("id") :: number
	PinController:MakeVisible(battlegroupID)
end)


return PinController
