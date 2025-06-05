--[[ PRESS T TO ACTIVATE THE SCRIPT
]]



local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	Players.PlayerAdded:Wait()
	LocalPlayer = Players.LocalPlayer
end

local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse() -- Retained as it might be needed for other game interactions, though not directly by this script's core logic.

local gameFolder = Workspace:WaitForChild("#GAME", 10)
local foldersFolder = gameFolder and gameFolder:WaitForChild("Folders", 5)
local humanoidFolder = foldersFolder and foldersFolder:WaitForChild("HumanoidFolder", 5)
local mainFolder = humanoidFolder and humanoidFolder:WaitForChild("NPCFolder", 5) -- Your target folder

local eventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
local remote = eventsFolder and eventsFolder:WaitForChild("MainAttack", 5)

if not mainFolder then
	warn("Auto Attack: Could not find NPCFolder at expected path.")
	return
end
if not remote then
	warn("Auto Attack: Could not find MainAttack RemoteEvent.")
	return
end


local isActive = false

local priorityNames1 = { "Amethyst", "Ruby", "Emerald", "Diamond", "Golden", "Silver" }
local priorityNames2 = { "Werewolf", "Berend" }

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.T then
		isActive = not isActive
		print(isActive and "Auto Attack ON" or "Auto Attack OFF")
	end
end)

local function getDeadNPCs()
	local deadList = {}
	if not mainFolder then return deadList end

	for _, npc in ipairs(mainFolder:GetChildren()) do
		if npc:IsA("Model") then
			local humanoid = npc:FindFirstChildOfClass("Humanoid")
			-- Check if Humanoid exists AND (Health is 0 or less OR its name contains "Dead")
			if humanoid and (humanoid.Health <= 0 or string.find(humanoid.Name, "Dead", 1, true)) then
				table.insert(deadList, npc)
			end
		end
	end
	return deadList
end

local function getPriorityTarget(npcList)
	local function findByPriority(list, keywords)
		for _, keyword in ipairs(keywords) do
			for _, npc in ipairs(list) do
				if npc.Name:find(keyword, 1, true) then
					return npc
				end
			end
		end
		return nil
	end

	local target = findByPriority(npcList, priorityNames1)
	if target then return target end

	target = findByPriority(npcList, priorityNames2)
	if target then return target end

	if #npcList > 0 then
		return npcList[math.random(1, #npcList)]
	end

	return nil
end

local function getValidBodyParts(model)
	local validParts = {}
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			local isGettingEaten = part:GetAttribute("IsGettingEaten")
			if not isGettingEaten then
				table.insert(validParts, part)
			end
		end
	end
	return validParts
end

local USE_DEVIATION = true
local MAX_DEVIATION_STUDS = 0.5

RunService.Heartbeat:Connect(function()
	if not isActive then return end

	local deadNPCList = getDeadNPCs()
	if #deadNPCList == 0 then return end

	local targetNpc = getPriorityTarget(deadNPCList)
	if not targetNpc or not targetNpc.Parent then return end

	local validParts = getValidBodyParts(targetNpc)
	if #validParts == 0 then
		return
	end

	local bodyPart = validParts[math.random(1, #validParts)]

	local origin = Camera.CFrame.Position

	local targetPosition = bodyPart.Position

	if USE_DEVIATION and MAX_DEVIATION_STUDS > 0 then
		local offsetX = (math.random() - 0.5) * 2 * MAX_DEVIATION_STUDS
		local offsetY = (math.random() - 0.5) * 2 * MAX_DEVIATION_STUDS
		local offsetZ = (math.random() - 0.5) * 2 * MAX_DEVIATION_STUDS
		targetPosition = targetPosition + Vector3.new(offsetX, offsetY, offsetZ)
	end

	local direction = (targetPosition - origin).Unit

    if direction.X ~= direction.X or direction.Y ~= direction.Y or direction.Z ~= direction.Z then
        warn("Calculated NaN direction! Falling back to LookVector. Origin:", origin, "Target:", targetPosition)
        direction = Camera.CFrame.LookVector
    end

	local args = {
		[1] = {
			["AN"] = "Eat",
			["D"] = direction,
			["O"] = origin,
			["FBP"] = bodyPart
		}
	}
	remote:FireServer(unpack(args))
end)