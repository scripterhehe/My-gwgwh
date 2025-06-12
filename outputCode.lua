local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvent = ReplicatedStorage.Events.Remote.ShotTarget
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local targetTeamName = "Red"
local cooldown = 0
local bulletSpeed = 9999
local minPredictionDistance = 0
local maxPredictionDistance = 10
local lastShotTime = 0

local function animateNotification(notification)
    local endPos = UDim2.new(0.5, -100, 0.4, -50)
    
    local tweenInfo = TweenInfo.new(
        1,
        Enum.EasingStyle.Elastic,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    
    local tween = TweenService:Create(notification, tweenInfo, {Position = endPos})
    
    tween:Play()
    
    wait(2)
    
    tween:Destroy()
end

local function displayNotification(message)
    local notification = Instance.new("ScreenGui")
    notification.Name = "Notification"

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = notification
    textLabel.Size = UDim2.new(0, 200, 0, 50)
    textLabel.Position = UDim2.new(0.5, -100, 0.55, -50)
    textLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Text = message
    textLabel.TextSize = 20
    textLabel.Font = Enum.Font.SourceSans
    textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)

    notification.Parent = player.PlayerGui

    animateNotification(textLabel)

    wait(2)
    for transparency = 0, 1, 0.1 do
        textLabel.BackgroundTransparency = transparency
        wait(0.1)
    end
    notification:Destroy()
end

local function playSound(soundId, delay)
    delay = delay or 0
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. soundId
    sound.Parent = SoundService
    sound:Play()
    wait(delay)
    sound:Destroy()
end

spawn(function()
    playSound(2865227271, 0.5)
    wait(0.5)
    playSound(1676318332)
end)

local function findClosestPlayer()
    local players = game.Players:GetPlayers()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    local tool = player.Character:FindFirstChildOfClass("Tool")
    
    if tool then
        local toolHandle = tool:FindFirstChild("Handle")
        if toolHandle then
            local shooterPosition = toolHandle.Position
            
            for _, plyr in ipairs(players) do
                if plyr ~= player and plyr.Team and plyr.Team.Name == targetTeamName and plyr.Character and plyr.Character:FindFirstChild("Humanoid") and plyr.Character.Humanoid.Health > 0 then
                    local targetPosition = plyr.Character.HumanoidRootPart.Position
                    
                    local horizontalDistance = (targetPosition - shooterPosition).magnitude
                    local heightDifference = math.abs(targetPosition.Y - shooterPosition.Y)
                    local totalDistance = (horizontalDistance^2 + heightDifference^2)^0.5
                    
                    if totalDistance < shortestDistance then
                        shortestDistance = totalDistance
                        closestPlayer = plyr
                    end
                end
            end
        end
    end
    
    return closestPlayer
end
