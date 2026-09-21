local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Checkpoint Coordinates
local CP_POSITIONS = {
    [0]  = Vector3.new(-0.97, 10.00, 86.00),
    [1]  = Vector3.new(-130.99, 116.19, -1372.50),
    [2]  = Vector3.new(505.00, 128.82, -1835.00),
    [3]  = Vector3.new(1147.58, 32.02, -1802.75),
    [4]  = Vector3.new(2168.38, 29.00, -2177.92),
    [5]  = Vector3.new(2204.93, 363.88, -2466.55),
    [6]  = Vector3.new(1967.41, 397.23, -3490.34),
    [7]  = Vector3.new(1139.40, 531.08, -3775.81),
    [8]  = Vector3.new(423.74, 421.14, -3569.16),
    [9]  = Vector3.new(-178.38, 441.00, -3776.25),
    [10] = Vector3.new(-879.96, 446.89, -4191.94),
    [11] = Vector3.new(-1483.62, 690.94, -3858.36),
    [12] = Vector3.new(-1678.90, 1122.41, -3867.33),
    [13] = Vector3.new(-2470.61, 944.36, -4494.25),
    [14] = Vector3.new(-3078.74, 943.02, -5129.45),
    [15] = Vector3.new(-3857.90, 975.98, -5654.64),
    [16] = Vector3.new(-4118.67, 1009.34, -4841.02),
    [17] = Vector3.new(-4234.82, 1250.92, -3872.11),
    [18] = Vector3.new(-3761.86, 1386.83, -3351.00),
    [19] = Vector3.new(-3749.11, 1687.03, -3104.00),
    [20] = Vector3.new(-3714.44, 1735.94, -2444.25),
    [21] = Vector3.new(-3415.44, 1837.12, -1917.75)
}

-- Status States
local isAutoSummitActive = false
local flySpeed = 100
local currentTween = nil
local noclipEnabled = false
local infJumpEnabled = false
local antiAfkEnabled = false
local noclipConnection = nil

-- Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MasensDev_Lonely_GUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--------------------------------------------------------------------------------
-- TOMBOL TOGGLE BULAT KECIL (MD)
--------------------------------------------------------------------------------
local openBtn = Instance.new("TextButton")
openBtn.Name = "MDToggleBtn"
openBtn.Size = UDim2.new(0, 42, 0, 42)
openBtn.Position = UDim2.new(0, 20, 0.4, 0)
openBtn.Text = "MD"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
openBtn.BorderSizePixel = 0
openBtn.Font = Enum.Font.SourceSansBold
openBtn.TextSize = 16
openBtn.Active = true
openBtn.Draggable = true
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0) -- Membuat tombol jadi bulat
openCorner.Parent = openBtn

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(255, 60, 60)
openStroke.Thickness = 2
openStroke.Parent = openBtn

--------------------------------------------------------------------------------
-- FRAME UTAMA (MERAH HITAM)
--------------------------------------------------------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 310, 0, 400)
mainFrame.Position = UDim2.new(0.5, -155, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(180, 20, 20)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Title Bar
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 35)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.Text = "MasensDev Lonely v1.0"
titleLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = mainFrame

-- Tombol Close (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 13
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

--------------------------------------------------------------------------------
-- SCROLLING CONTAINER
--------------------------------------------------------------------------------
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -50)
scrollFrame.Position = UDim2.new(0, 10, 0, 40)
scrollFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 20, 20)
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 6)
scrollCorner.Parent = scrollFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = scrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 6)
listPadding.PaddingLeft = UDim.new(0, 6)
listPadding.PaddingRight = UDim.new(0, 6)
listPadding.Parent = scrollFrame

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 12)
end)

-- Helper Function Bikin Tombol
local function createButton(text, bgCol)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = bgCol or Color3.fromRGB(35, 35, 42)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = scrollFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    return btn
end

--------------------------------------------------------------------------------
-- ELEMENT UI & ELEMEN KONTROL
--------------------------------------------------------------------------------

-- 1. Auto Summit Toggle
local autoSummitBtn = createButton("Auto Summit: OFF", Color3.fromRGB(45, 20, 20))

-- 2. Input Fly Speed & Label
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, 0, 0, 32)
speedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
speedFrame.BorderSizePixel = 0
speedFrame.Parent = scrollFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.6, 0, 1, 0)
speedLabel.Position = UDim2.new(0, 8, 0, 0)
speedLabel.Text = "Fly Speed:"
speedLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextSize = 13
speedLabel.BackgroundTransparency = 1
speedLabel.Parent = speedFrame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.35, -5, 0, 24)
speedInput.Position = UDim2.new(0.65, 0, 0.5, -12)
speedInput.Text = "100"
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
speedInput.BorderSizePixel = 0
speedInput.Font = Enum.Font.SourceSansBold
speedInput.TextSize = 13
speedInput.Parent = speedFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = speedInput

-- Label Warning Speed
local warnLabel = Instance.new("TextLabel")
warnLabel.Size = UDim2.new(1, 0, 0, 28)
warnLabel.Text = "RISK !! JANGAN LEBIH DARI 100, SANTAY AJA COY"
warnLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
warnLabel.Font = Enum.Font.SourceSansBold
warnLabel.TextSize = 11
warnLabel.BackgroundTransparency = 1
warnLabel.Visible = false
warnLabel.TextWrapped = true
warnLabel.Parent = scrollFrame

-- 3. No Clip Toggle
local noclipBtn = createButton("No Clip: OFF", Color3.fromRGB(35, 35, 42))

-- 4. Infinite Jump Toggle
local infJumpBtn = createButton("Infinite Jump: OFF", Color3.fromRGB(35, 35, 42))

-- 5. Anti AFK Toggle
local antiAfkBtn = createButton("Anti AFK: OFF", Color3.fromRGB(35, 35, 42))

-- 6. Rejoin Server
local rejoinBtn = createButton("🔄 Rejoin Server", Color3.fromRGB(120, 30, 30))

-- 7. Hop Server (Cari Server Sepi)
local hopBtn = createButton("🌐 Hop Server (Server Sepi)", Color3.fromRGB(150, 20, 20))

--------------------------------------------------------------------------------
-- LOGIKA FITUR & EVENT HANDLERS
--------------------------------------------------------------------------------

-- Validation Speed & Warning
speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then
        flySpeed = val
        if val > 100 then
            warnLabel.Visible = true
        else
            warnLabel.Visible = false
        end
    else
        speedInput.Text = tostring(flySpeed)
    end
end)

-- Auto Summit Logic
local function getCurrentCP()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local cpVal = leaderstats:FindFirstChild("Checkpoint")
        if cpVal then return cpVal.Value end
    end
    return 0
end

local function flyToTarget(targetPos)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    local distance = (hrp.Position - targetPos).Magnitude
    local duration = distance / flySpeed

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.MaxForce = Vector3.new(4e5, 4e5, 4e5)
    bodyVelocity.Parent = hrp

    humanoid:ChangeState(Enum.HumanoidStateType.Flying)

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    currentTween:Play()
    currentTween.Completed:Wait()

    bodyVelocity:Destroy()
end

autoSummitBtn.MouseButton1Click:Connect(function()
    isAutoSummitActive = not isAutoSummitActive
    if isAutoSummitActive then
        autoSummitBtn.Text = "Auto Summit: ON"
        autoSummitBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
        
        task.spawn(function()
            while isAutoSummitActive do
                local currentCP = getCurrentCP()
                local nextCP = currentCP + 1
                if currentCP >= 21 then nextCP = 0 end

                local targetPos = CP_POSITIONS[nextCP]
                if targetPos then
                    flyToTarget(targetPos)
                    task.wait(0.5)
                else
                    break
                end
            end
        end)
    else
        autoSummitBtn.Text = "Auto Summit: OFF"
        autoSummitBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 20)
        if currentTween then currentTween:Cancel() end
    end
end)

-- No Clip Logic
noclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipBtn.Text = "No Clip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipBtn.Text = "No Clip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end)

-- Infinite Jump Logic
infJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    if infJumpEnabled then
        infJumpBtn.Text = "Infinite Jump: ON"
        infJumpBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
    else
        infJumpBtn.Text = "Infinite Jump: OFF"
        infJumpBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Anti AFK Logic
antiAfkBtn.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        antiAfkBtn.Text = "Anti AFK: ON"
        antiAfkBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
    else
        antiAfkBtn.Text = "Anti AFK: OFF"
        antiAfkBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    end
end)

LocalPlayer.Idled:Connect(function()
    if antiAfkEnabled then
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.zero)
    end
end)

-- Rejoin Server Logic
rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- Hop Server Logic (Cari Server Sepi)
hopBtn.MouseButton1Click:Connect(function()
    hopBtn.Text = "Mencari Server..."
    task.spawn(function()
        local placeId = game.PlaceId
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)

        if success and result and result.data then
            for _, server in ipairs(result.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                    return
                end
            end
        end
        hopBtn.Text = "Gagal / Server Tidak Ada"
        task.wait(2)
        hopBtn.Text = "🌐 Hop Server (Server Sepi)"
    end)
end)
