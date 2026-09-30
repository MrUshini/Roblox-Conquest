local CollectionService = game:GetService("CollectionService")
local SelectBattlegroupRemoteEvent = game.ReplicatedStorage.RemoteEvents.SelectBattlegroup

local function SetupClickDetector(battlegroupBody: Model) : ()
	local clickDetector = battlegroupBody:FindFirstChild("ClickDetector")
	if not clickDetector then
		warn(battlegroupBody.Name .. " has no ClickDetector")
		return
	end

	clickDetector.MouseClick:Connect(function(player)
		print("Clicked on " .. battlegroupBody.Name)
		SelectBattlegroupRemoteEvent:FireClient(player, battlegroupBody)
	end)
end

local function SetupBattlegroup(battlegroupBody: Model) : ()
	SetupClickDetector(battlegroupBody)
end

-- Existing battlegroups
for _, battlegroupBody in ipairs(CollectionService:GetTagged("Battlegroup")) do
	SetupBattlegroup(battlegroupBody)
end

-- Future battlegroups
CollectionService:GetInstanceAddedSignal("Battlegroup"):Connect(SetupBattlegroup)