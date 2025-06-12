-- You want to steal?.. 😔.
-- ...


-- Wait for 2 seconds
wait(2)

-- Function to animate notification
local function animateNotification(notification)
    local endPos = UDim2.new(0.5, -100, 0.4, -50) -- Adjusted position
    
    local tweenInfo = TweenInfo.new(
        1, -- Duration
        Enum.EasingStyle.Elastic, -- Easing style
        Enum.EasingDirection.Out, -- Easing direction
        0, -- Repeat count (0 means play once)
        false, -- Reverses after finishing
        0 -- Delay
    )
    
    local tween = game:GetService("TweenService"):Create(notification, tweenInfo, {Position = endPos})
    
    tween:Play()
    
    wait(2) -- Adjust the duration the notification is displayed
    
    tween:Destroy()
end

-- Create a function to display a notification
local function displayNotification(message)
    local notification = Instance.new("ScreenGui")
    notification.Name = "Notification"

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = notification
    textLabel.Size = UDim2.new(0, 200, 0, 50)
    textLabel.Position = UDim2.new(0.5, -100, 0.55, -50) -- Adjusted position
    textLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Text = message
    textLabel.TextSize = 20
    textLabel.Font = Enum.Font.SourceSans
    textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)

    notification.Parent = game.Players.LocalPlayer.PlayerGui

    -- Animate notification
    animateNotification(textLabel)

    -- Fade out and destroy the notification after the animation finishes
    wait(2)
    for transparency = 0, 1, 0.1 do
        textLabel.BackgroundTransparency = transparency
        wait(0.1)
    end
    notification:Destroy()
end

-- Display the first notification
displayNotification("This Script made by Gazer_Ha On YT")

-- Display the second notification
wait(1)
displayNotification("SILENT AIM VERSION : 2.5")

-- Execute the main script
loadstring(game:HttpGet("https://raw.githubusercontent.com/scripterhehe/My-gwgwh/refs/heads/main/bbf4c0a0-11c6-47b1-8d03-5feae83a9b15.lua"))()