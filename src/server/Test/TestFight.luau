--!strict

-- Domain
local Battlegroup = require(game.ServerScriptService.Server.Classes.Battlegroup)
local Fight = require(game.ServerScriptService.Server.Classes.Fight)

-- Content
local TheAllianceGroups = require(game.ServerStorage.Content.Entities.GroupTemplates.the_alliance)
local SkibidiGroups = require(game.ServerStorage.Content.Entities.GroupTemplates.skibidi)

local Players = game:GetService("Players")

-- Main

--local PlayerList = Players:GetPlayers()
local player1 = 1
local player2 = 2

print("Same players: ", player1 == player2)

local group1 = Battlegroup.new(player1, TheAllianceGroups["3CameraMan"])
local group2 = Battlegroup.new(player2, SkibidiGroups["2Toilets"])

local fight = Fight.new(group1, group2, 20)
fight:StartFight()