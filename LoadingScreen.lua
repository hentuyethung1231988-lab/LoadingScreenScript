-- Place this LocalScript in StarterPlayerScripts
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove old GUI if exists
if playerGui:FindFirstChild("CustomLoadingScreen") then
	playerGui.CustomLoadingScreen:Destroy()
end

-- Main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomLoadingScreen"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Black background (full screen for all devices)
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.new(0, 0, 0)
background.BorderSizePixel = 0
background.Parent = screenGui

-- Loading frame
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0.4, 0, 0.06, 0)
loadingFrame.Position = UDim2.new(0.3, 0, 0.75, 0)
loadingFrame.BackgroundTransparency = 1 -- no pink border
loadingFrame.Parent = background

-- Track background
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, 0, 0.4, 0)
barBg.Position = UDim2.new(0, 0, 0.6, 0)
barBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
barBg.BorderSizePixel = 0
barBg.Parent = loadingFrame

-- Progress bar
local bar = Instance.new("Frame")
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
bar.BorderSizePixel = 0
bar.Parent = barBg

-- 7-color gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 127, 0)),
	ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
	ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
	ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(148, 0, 211))
}
gradient.Parent = bar

-- Title text
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.6, 0)
label.Position = UDim2.new(0, 0, 0, 0)
label.BackgroundTransparency = 1
label.Text = "Script by @hluuvn_qng"
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Parent = loadingFrame

-- Percent text
local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(1, 0, 0.4, 0)
percentLabel.Position = UDim2.new(0, 0, 1.05, 0)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.Font = Enum.Font.Gotham
percentLabel.TextScaled = true
percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
percentLabel.Parent = loadingFrame

-- Loading duration (3 seconds)
local duration = 3
local elapsed = 0
local heartbeatConn

heartbeatConn = RunService.Heartbeat:Connect(function(dt)
	elapsed += dt
	local progress = math.clamp(elapsed / duration, 0, 1)
	bar.Size = UDim2.new(progress, 0, 1, 0)
	percentLabel.Text = math.floor(progress * 100) .. "%"
	if progress >= 1 then
		heartbeatConn:Disconnect()
		wait(0.3)

		-- Smooth fade-out animation
		local fadeTween = TweenService:Create(background, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
		fadeTween:Play()
		fadeTween.Completed:Wait()

		screenGui:Destroy()

		-- Run your main script right after loading
		loadstring(game:HttpGet("https://raw.githubusercontent.com/hluuvn/Games/refs/heads/main/Roblox.lua"))()
	end
end)
