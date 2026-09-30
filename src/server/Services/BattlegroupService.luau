local BattlegroupModule = require(game.ServerScriptService.Server.Classes.Battlegroup)
type TBattlegroupInstance = BattlegroupModule.BattlegroupInstance

local BattlegroupTemplateModule = require(game.ReplicatedStorage.Shared.ClassTypes.BattlegroupTemplate)
type TBattlegroupTemplate = BattlegroupTemplateModule.BattlegroupTemplate

local BattlegroupBodyTemplate = game.ServerStorage:WaitForChild("Assests"):WaitForChild("BattlegroupBody") :: Model

local SetPin = game.ReplicatedStorage.RemoteEvents.SetPin
local PinReached = game.ReplicatedStorage.RemoteEvents.PinReached
local RunService = game:GetService("RunService")
local movementConnection = nil

-- TEST
local Players = game:GetService("Players")
local TESTSPEED = 5
-- TEST

-- Config
local BattlegroupBodyHeight = 11 :: number
local workspaceBattlegroupsFolder = workspace.Entities.Battlegroups
-- Config

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

function BattlegroupService.CreateBattlegroupModel(position: Vector2) : Model
	local battlegroupBody = BattlegroupBodyTemplate:Clone() :: Model

	local position3d = Vector3.new(position.X, BattlegroupBodyHeight, position.Y) :: Vector3
	battlegroupBody:PivotTo(CFrame.new(position3d))
	battlegroupBody:SetAttribute("id", groupNumber)
	battlegroupBody:SetAttribute("primary_color", Color3.fromRGB(0, 180, 255))
	battlegroupBody:SetAttribute("outline_color", Color3.fromRGB(85, 255, 255))

	battlegroupBody.Parent = workspaceBattlegroupsFolder

	return battlegroupBody
end

function BattlegroupService.CreateBattlegroup(
	ownerId: number,
	template: TBattlegroupTemplate,
	position: Vector2
) : TBattlegroupInstance

	local battlegroupBody = BattlegroupService.CreateBattlegroupModel(position) :: Model
	local battlegroupInstance = BattlegroupModule.new(ownerId, template, battlegroupBody) :: TBattlegroupInstance

	BattlegroupDict[groupNumber] = battlegroupInstance
	groupNumber += 1

	return battlegroupInstance
end

function BattlegroupService.Attack(attacker, victim) : ()
	local text = string.format("%s", attacker.Name)
end

function BattlegroupService:GetBattlegroupInstance(id: number) : TBattlegroupInstance?
	return BattlegroupDict[id]
end

SetPin.OnServerEvent:Connect(function(player, battlegroupID: number, position: Vector3)
	print("Received")
	local battlegroupInstance = BattlegroupService:GetBattlegroupInstance(battlegroupID)
	battlegroupInstance:ChangeDestination(position)
end)

function BattlegroupService.MoveGroupTowardsPin(groupId: number)
	--print("Pos: "..module.BattlegroupStates[groupId])
	local battlegroupInstance = BattlegroupService:GetBattlegroupInstance(groupId)

	if not battlegroupInstance then return end	
	if not battlegroupInstance.Destination then return end
	
	local groupBody = battlegroupInstance.Body :: Model
	local destination = battlegroupInstance.Destination :: Vector3

	local direction = (destination - groupBody:GetPivot().Position).Unit
	local distance = (destination - groupBody:GetPivot().Position).Magnitude
	local speed = TESTSPEED
	local moveStep = direction * speed * RunService.Heartbeat:Wait()
	moveStep = Vector3.new(moveStep.X, 0, moveStep.Z)
	
	-- Final Step
	if distance < moveStep.magnitude then
		local currentPivot = groupBody:GetPivot()
		local currentRotation = currentPivot.Rotation
		groupBody:PivotTo(CFrame.new(destination) * currentRotation)
		battlegroupInstance.Destination = nil
		PinReached:FireClient(battlegroupInstance.owner, groupId)
		return
	end
	
	groupBody:PivotTo(groupBody:GetPivot() + moveStep)
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
