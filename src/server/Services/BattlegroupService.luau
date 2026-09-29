local BattlegroupModule = require(game.ServerScriptService.Server.Classes.Battlegroup)
type TBattlegroupInstance = BattlegroupModule.BattlegroupInstance
local SetPin = game.ReplicatedStorage.RemoteEvents.SetPin
local PinReached = game.ReplicatedStorage.RemoteEvents.PinReached
local RunService = game:GetService("RunService")
local movementConnection = nil

-- TEST
local Players = game:GetService("Players")
local TESTSPEED = 5
-- TEST

local groupNumber = 0

local BattlegroupService = {}


export type BattlegroupState = {
	owner: Player,
	groupModel: Model,
	pinPos: Vector3,
	units: {Model},
	currentOrder: string,
	pinModel: Model
}

type TBattlegroupDict = { [number]: TBattlegroupInstance }

local BattlegroupDict = {} :: TBattlegroupDict

function BattlegroupService:AddBattlegroup(battlegroupBody: Model)
	-- Set Attributes
	battlegroupBody:SetAttribute("id", groupNumber)
	battlegroupBody:SetAttribute("primary_color", Color3.fromRGB(0, 180, 255))
	battlegroupBody:SetAttribute("outline_color", Color3.fromRGB(85, 255, 255))
	
	local localplayer = Players:GetPlayers()[1]

	if not localplayer then
		localplayer = Players.PlayerAdded:Wait()
	end
	
	-- Add to the table AND increment the group number
	BattlegroupDict[groupNumber] = battle
	groupNumber += 1
end

function BattlegroupService.Attack(attacker, victim)
	local text = string.format("%s", attacker.Name)
end

SetPin.OnServerEvent:Connect(function(player, battlegroupID: number, position: Vector3)
	print("Received")
	BattlegroupService.BattlegroupStates[battlegroupID].pinPos = position
end)

function BattlegroupService.MoveGroupTowardsPin(groupId: number)
	--print("Pos: "..module.BattlegroupStates[groupId])
	if not BattlegroupService.BattlegroupStates[groupId] then return end	
	if not BattlegroupService.BattlegroupStates[groupId].pinPos then return end
	
	local groupModel = BattlegroupService.BattlegroupStates[groupId].groupModel
	local direction = (BattlegroupService.BattlegroupStates[groupId].pinPos - BattlegroupService.BattlegroupStates[groupId].groupModel:GetPivot().Position).Unit
	local distance = (BattlegroupService.BattlegroupStates[groupId].pinPos - BattlegroupService.BattlegroupStates[groupId].groupModel:GetPivot().Position).Magnitude
	local speed = TESTSPEED
	local moveStep = direction * speed * RunService.Heartbeat:Wait()
	moveStep = Vector3.new(moveStep.X, 0, moveStep.Z)
	
	-- Final Step
	if distance < moveStep.magnitude then
		local targetPos = BattlegroupService.BattlegroupStates[groupId].pinPos
		local currentPivot = groupModel:GetPivot()
		local currentRotation = currentPivot.Rotation
		groupModel:PivotTo(CFrame.new(targetPos) * currentRotation)
		BattlegroupService.BattlegroupStates[groupId].pinPos = nil
		PinReached:FireClient(BattlegroupService.BattlegroupStates[groupId].owner, groupId)
		return
	end
	
	groupModel:PivotTo(groupModel:GetPivot() + moveStep)
end

function BattlegroupService.ActivateMovement()
	movementConnection = RunService.Heartbeat:Connect(function()
		local groupId = 0
		while groupId < groupNumber do
			BattlegroupService.MoveGroupTowardsPin(groupId)
			groupId += 1
		end
	end)	
end

function BattlegroupService.DisableMovement()
	if movementConnection then
		movementConnection:Disconnect()
	end
end

function BattlegroupService.GetUnitData()
	-- TODO	
end

return BattlegroupService
