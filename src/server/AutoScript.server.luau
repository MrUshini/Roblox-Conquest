-- Disable default character movement
game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.WalkSpeed = 0 -- No Walking
		humanoid.JumpHeight = 0 -- No Jumping
		humanoid.AutoRotate = false -- No Rotation
	end)
end)