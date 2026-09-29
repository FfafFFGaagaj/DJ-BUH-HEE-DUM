-- LocalScript (วางไว้ใน StarterPlayerScripts หรือ StarterGui)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomControlUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Window
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 340, 0, 420)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

-- Title / Logo
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 45)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SYSTEM CONTROL"
titleLabel.TextColor3 = Color3.fromRGB(255, 20, 147) -- สีชมพู คมชัด (Deep Pink)
titleLabel.TextSize = 22
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.Parent = mainFrame

-- Global On/Off Toggle
local globalToggle = Instance.new("TextButton")
globalToggle.Size = UDim2.new(0, 90, 0, 25)
globalToggle.Position = UDim2.new(1, -100, 0, 10)
globalToggle.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
globalToggle.Text = "ON"
globalToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
globalToggle.Font = Enum.Font.SourceSansBold
globalToggle.Parent = mainFrame
Instance.new("UICorner", globalToggle).CornerRadius = UDim.new(0, 6)

local isScriptEnabled = true
globalToggle.MouseButton1Click:Connect(function()
	isScriptEnabled = not isScriptEnabled
	globalToggle.Text = isScriptEnabled and "ON" or "OFF"
	globalToggle.BackgroundColor3 = isScriptEnabled and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(231, 76, 60)
end)

-- Mode Buttons Panel
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 35)
tabFrame.Position = UDim2.new(0, 10, 0, 50)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local btnMode1 = Instance.new("TextButton")
btnMode1.Size = UDim2.new(0.48, 0, 1, 0)
btnMode1.Position = UDim2.new(0, 0, 0, 0)
btnMode1.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
btnMode1.Text = "รายชื่อผู้เล่น"
btnMode1.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMode1.Font = Enum.Font.SourceSansBold
btnMode1.TextSize = 16
btnMode1.Parent = tabFrame
Instance.new("UICorner", btnMode1)

local btnMode2 = Instance.new("TextButton")
btnMode2.Size = UDim2.new(0.48, 0, 1, 0)
btnMode2.Position = UDim2.new(0.52, 0, 0, 0)
btnMode2.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
btnMode2.Text = "วาป + ผลัก"
btnMode2.TextColor3 = Color3.fromRGB(100, 100, 100)
btnMode2.Font = Enum.Font.SourceSansBold
btnMode2.TextSize = 16
btnMode2.Parent = tabFrame
Instance.new("UICorner", btnMode2)

---------------------------------------------------------
-- MODE 1: PLAYER LIST
---------------------------------------------------------
local panelMode1 = Instance.new("Frame")
panelMode1.Size = UDim2.new(1, -20, 1, -100)
panelMode1.Position = UDim2.new(0, 10, 0, 90)
panelMode1.BackgroundTransparency = 1
panelMode1.Parent = mainFrame

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(1, 0, 0, 30)
refreshBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
refreshBtn.Text = "🔄 รีเฟรชรายชื่อ"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.Font = Enum.Font.SourceSansBold
refreshBtn.TextSize = 16
refreshBtn.Parent = panelMode1
Instance.new("UICorner", refreshBtn)

local scrollList = Instance.new("ScrollingFrame")
scrollList.Size = UDim2.new(1, 0, 1, -40)
scrollList.Position = UDim2.new(0, 0, 0, 40)
scrollList.BackgroundTransparency = 1
scrollList.BorderSizePixel = 0
scrollList.Parent = panelMode1

local uiList = Instance.new("UIListLayout")
uiList.Parent = scrollList
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 5)

local function updatePlayerList()
	for _, child in pairs(scrollList:GetChildren()) do
		if child:IsA("TextLabel") then child:Destroy() end
	end
	for _, plr in pairs(Players:GetPlayers()) do
		local pLabel = Instance.new("TextLabel")
		pLabel.Size = UDim2.new(1, 0, 0, 30)
		pLabel.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
		pLabel.Text = "  " .. plr.DisplayName .. " (@" .. plr.Name .. ")"
		pLabel.TextColor3 = Color3.fromRGB(255, 20, 147)
		pLabel.TextXAlignment = Enum.TextXAlignment.Left
		pLabel.Font = Enum.Font.SourceSansBold
		pLabel.TextSize = 14
		pLabel.Parent = scrollList
		Instance.new("UICorner", pLabel)
	end
end

refreshBtn.MouseButton1Click:Connect(updatePlayerList)

---------------------------------------------------------
-- MODE 2: TELEPORT & KNOCKBACK
---------------------------------------------------------
local panelMode2 = Instance.new("Frame")
panelMode2.Size = UDim2.new(1, -20, 1, -100)
panelMode2.Position = UDim2.new(0, 10, 0, 90)
panelMode2.BackgroundTransparency = 1
panelMode2.Visible = false
panelMode2.Parent = mainFrame

local targetInput = Instance.new("TextBox")
targetInput.Size = UDim2.new(1, 0, 0, 35)
targetInput.Position = UDim2.new(0, 0, 0, 0)
targetInput.PlaceholderText = "พิมพ์ชื่อผู้เล่นที่ต้องการ..."
targetInput.Text = ""
targetInput.TextColor3 = Color3.fromRGB(0, 0, 0)
targetInput.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
targetInput.Font = Enum.Font.SourceSans
targetInput.TextSize = 14
targetInput.Parent = panelMode2
Instance.new("UICorner", targetInput)

local powerLabel = Instance.new("TextLabel")
powerLabel.Size = UDim2.new(1, 0, 0, 25)
powerLabel.Position = UDim2.new(0, 0, 0, 45)
powerLabel.BackgroundTransparency = 1
powerLabel.Text = "ปรับความแรงกระเด็น: 1000"
powerLabel.TextColor3 = Color3.fromRGB(255, 20, 147)
powerLabel.Font = Enum.Font.SourceSansBold
powerLabel.TextSize = 14
powerLabel.Parent = panelMode2

local powerInput = Instance.new("TextBox")
powerInput.Size = UDim2.new(1, 0, 0, 35)
powerInput.Position = UDim2.new(0, 0, 0, 75)
powerInput.Text = "1000"
powerInput.PlaceholderText = "ตั้งค่าแรงผลัก (1 - 4000)"
powerInput.TextColor3 = Color3.fromRGB(0, 0, 0)
powerInput.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
powerInput.Font = Enum.Font.SourceSans
powerInput.TextSize = 14
powerInput.Parent = panelMode2
Instance.new("UICorner", powerInput)

powerInput.FocusLost:Connect(function()
	local val = tonumber(powerInput.Text) or 1000
	val = math.clamp(val, 1, 4000)
	powerInput.Text = tostring(val)
	powerLabel.Text = "ปรับความแรงกระเด็น: " .. tostring(val)
end)

local actionBtn = Instance.new("TextButton")
actionBtn.Size = UDim2.new(1, 0, 0, 40)
actionBtn.Position = UDim2.new(0, 0, 0, 125)
actionBtn.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
actionBtn.Text = "🚀 วาร์ป + ผลักออกจากแมพ"
actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
actionBtn.Font = Enum.Font.SourceSansBold
actionBtn.TextSize = 16
actionBtn.Parent = panelMode2
Instance.new("UICorner", actionBtn)

-- Action Execution
actionBtn.MouseButton1Click:Connect(function()
	if not isScriptEnabled then return end
	
	local targetName = targetInput.Text:lower()
	local power = tonumber(powerInput.Text) or 1000
	power = math.clamp(power, 1, 4000)
	
	local targetPlayer = nil
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and (p.Name:lower():find(targetName) or p.DisplayName:lower():find(targetName)) then
			targetPlayer = p
			break
		end
	end
	
	if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local myChar = LocalPlayer.Character
		if myChar and myChar:FindFirstChild("HumanoidRootPart") then
			local myHRP = myChar.HumanoidRootPart
			local targetHRP = targetPlayer.Character.HumanoidRootPart
			
			-- 1. วาร์ปไปหาเป้าหมาย
			myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
			
			-- 2. ผลักเป้าหมาย
			task.wait(0.1)
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Velocity = (targetHRP.Position - myHRP.Position).Unit * power + Vector3.new(0, power/2, 0)
			bodyVelocity.Parent = targetHRP
			
			game:GetService("Debris"):AddItem(bodyVelocity, 0.3)
		end
	end
end)

---------------------------------------------------------
-- TAB SWITCHING LOGIC
---------------------------------------------------------
btnMode1.MouseButton1Click:Connect(function()
	panelMode1.Visible = true
	panelMode2.Visible = false
	btnMode1.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
	btnMode1.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnMode2.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	btnMode2.TextColor3 = Color3.fromRGB(100, 100, 100)
	updatePlayerList()
end)

btnMode2.MouseButton1Click:Connect(function()
	panelMode1.Visible = false
	panelMode2.Visible = true
	btnMode2.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
	btnMode2.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnMode1.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	btnMode1.TextColor3 = Color3.fromRGB(100, 100, 100)
end)

-- Initial Load
updatePlayerList()
