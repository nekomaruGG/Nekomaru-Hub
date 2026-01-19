--[[ 
    NEKOMARU AVATAR CHANGER GUI v1
    Created for User Request
    Theme: Modern Dark with Neon Gradients
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- == SETUP PROTECTION & RESET ==
-- Membersihkan UI lama jika ada biar tidak menumpuk
local guiName = "NekomaruVisualGUI"

if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(guiName) then LocalPlayer.PlayerGui[guiName]:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Proteksi deteksi (jika executor support)
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- == COLORS & ASSETS ==
local C_Dark = Color3.fromRGB(20, 20, 25)
local C_Panel = Color3.fromRGB(30, 30, 35)
local C_Text = Color3.fromRGB(240, 240, 240)
local Gradient1 = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)), -- Cyan
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 32, 240)) -- Purple
}

-- == MAIN FRAME (WINDOW) ==
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = C_Dark
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Gradient Border Effect
local GlowFrame = Instance.new("Frame")
GlowFrame.Name = "GlowBorder"
GlowFrame.Size = UDim2.new(1, 0, 0, 3)
GlowFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlowFrame.BorderSizePixel = 0
GlowFrame.Parent = MainFrame
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = Gradient1
UIGradient.Parent = GlowFrame

-- == TITLE BAR ==
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "NEKOMARU <font color=\"rgb(0,255,255)\">VISUAL</font>"
TitleLabel.RichText = true
TitleLabel.Size = UDim2.new(1, -100, 0, 40)
TitleLabel.Position = UDim2.new(0, 15, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = C_Text
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0, 5)
MinBtn.BackgroundColor3 = C_Panel
MinBtn.TextColor3 = C_Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.Parent = MainFrame
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- Destroy Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = C_Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- == SIDEBAR ==
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, -50)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundColor3 = C_Panel
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar
local UIList = Instance.new("UIListLayout", TabContainer)
UIList.Padding = UDim.new(0, 8)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.SortOrder = Enum.SortOrder.LayoutOrder
local UIPadding = Instance.new("UIPadding", TabContainer)
UIPadding.PaddingTop = UDim.new(0, 10)

-- == CONTENT PAGES ==
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -155, 1, -50)
ContentFrame.Position = UDim2.new(0, 150, 0, 50)
ContentFrame.BackgroundColor3 = Color3.TRANSPARENT
ContentFrame.Parent = MainFrame

local Pages = {}

-- Function to Create Tabs
local function CreateTab(name, iconID)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Text = name
    TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
    TabBtn.BackgroundColor3 = C_Dark
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 14
    TabBtn.Parent = TabContainer
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    -- Page logic
    local Page = Instance.new("Frame")
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = ContentFrame
    
    Pages[name] = {Btn = TabBtn, Page = Page}
    
    TabBtn.MouseButton1Click:Connect(function()
        for n, data in pairs(Pages) do
            data.Page.Visible = false
            TweenService:Create(data.Btn, TweenInfo.new(0.2), {BackgroundColor3 = C_Dark, TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end
        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60), TextColor3 = Color3.fromRGB(0, 255, 255)}):Play()
    end)
    
    return Page
end

-- == PAGE 1: INFO ==
local InfoPage = CreateTab("Info")
local InfoList = Instance.new("UIListLayout", InfoPage)
InfoList.Padding = UDim.new(0, 10)

local function AddInfoLabel(title, value, copyable)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = C_Panel
    Frame.Parent = InfoPage
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local T = Instance.new("TextLabel", Frame)
    T.Text = title
    T.Size = UDim2.new(1, -10, 0, 20)
    T.Position = UDim2.new(0, 10, 0, 5)
    T.BackgroundTransparency = 1
    T.TextColor3 = Color3.fromRGB(180, 180, 180)
    T.Font = Enum.Font.Gotham
    T.TextSize = 12
    T.TextXAlignment = Enum.TextXAlignment.Left
    
    if copyable then
        local Box = Instance.new("TextBox", Frame)
        Box.Text = value
        Box.Size = UDim2.new(1, -20, 0, 20)
        Box.Position = UDim2.new(0, 10, 0, 25)
        Box.BackgroundColor3 = C_Dark
        Box.TextColor3 = Color3.fromRGB(0, 255, 255)
        Box.Font = Enum.Font.GothamBold
        Box.TextSize = 14
        Box.TextEditable = false
        Box.ClearTextOnFocus = false
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
    else
        local V = Instance.new("TextLabel", Frame)
        V.Text = value
        V.Size = UDim2.new(1, -20, 0, 20)
        V.Position = UDim2.new(0, 10, 0, 25)
        V.BackgroundTransparency = 1
        V.TextColor3 = C_Text
        V.Font = Enum.Font.GothamBold
        V.TextSize = 14
        V.TextXAlignment = Enum.TextXAlignment.Left
    end
end

AddInfoLabel("Author", "Nekomaru")
AddInfoLabel("Username", "nekomarugg1")
AddInfoLabel("Discord Link (Copy)", "https://discord.gg/nekomaru", true)


-- == PAGE 2: MENU (AVATAR) ==
local MenuPage = CreateTab("Visual Menu")
local MenuList = Instance.new("UIListLayout", MenuPage)
MenuList.Padding = UDim.new(0, 15)

-- Input Box
local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(1, 0, 0, 50)
InputFrame.BackgroundColor3 = C_Panel
InputFrame.Parent = MenuPage
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6)

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -20, 1, 0)
InputBox.Position = UDim2.new(0, 10, 0, 0)
InputBox.BackgroundTransparency = 1
InputBox.PlaceholderText = "Masukkan Username / User ID..."
InputBox.Text = ""
InputBox.TextColor3 = C_Text
InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 14
InputBox.Parent = InputFrame

-- Apply Button (Search & Toggle On)
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Text = "APPLY AVATAR (ON)"
ApplyBtn.Size = UDim2.new(1, 0, 0, 40)
ApplyBtn.BackgroundColor3 = C_Panel
ApplyBtn.TextColor3 = C_Text
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextSize = 14
ApplyBtn.Parent = MenuPage
Instance.new("UICorner", ApplyBtn).CornerRadius = UDim.new(0, 6)
local ApplyGradient = UIGradient:Clone()
ApplyGradient.Parent = ApplyBtn

-- Reset Button (Toggle Off)
local ResetBtn = Instance.new("TextButton")
ResetBtn.Text = "RESET CHARACTER (OFF)"
ResetBtn.Size = UDim2.new(1, 0, 0, 40)
ResetBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45) -- Grey plain
ResetBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.TextSize = 14
ResetBtn.Parent = MenuPage
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)


-- == LOGIC: AVATAR CHANGER ==
ApplyBtn.MouseButton1Click:Connect(function()
    local input = InputBox.Text
    if input == "" then return end
    
    ApplyBtn.Text = "Loading..."
    
    task.spawn(function()
        local userId = tonumber(input)
        
        -- Cek apakah input ID (angka) atau Username (huruf)
        if not userId then
            pcall(function()
                userId = Players:GetUserIdFromNameAsync(input)
            end)
        end
        
        if userId then
            local success, err = pcall(function()
                local desc = Players:GetHumanoidDescriptionFromUserId(userId)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid:ApplyDescription(desc)
                end
            end)
            
            if success then
                ApplyBtn.Text = "SUCCESS!"
                wait(1)
                ApplyBtn.Text = "APPLY AVATAR (ON)"
            else
                ApplyBtn.Text = "ERROR ID/NAME"
                wait(1)
                ApplyBtn.Text = "APPLY AVATAR (ON)"
            end
        else
            ApplyBtn.Text = "USER NOT FOUND"
            wait(1)
            ApplyBtn.Text = "APPLY AVATAR (ON)"
        end
    end)
end)

ResetBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints() -- Cara paling bersih reset appearance
    end
end)


-- == DRAGGABLE LOGIC ==
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then update(input) end
    end
end)

-- == MINIMIZE LOGIC ==
local FloatIcon = Instance.new("ImageButton")
FloatIcon.Name = "FloatIcon"
FloatIcon.Size = UDim2.new(0, 50, 0, 50)
FloatIcon.Position = UDim2.new(0.9, 0, 0.5, 0)
FloatIcon.BackgroundColor3 = C_Dark
FloatIcon.Image = "rbxassetid://10618644218" -- Cool User/Avatar Icon
FloatIcon.Visible = false
FloatIcon.Parent = ScreenGui
Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(1, 0)
local IconStroke = Instance.new("UIStroke", FloatIcon)
IconStroke.Color = Color3.fromRGB(0, 255, 255)
IconStroke.Thickness = 2

-- Function to handle dragging for icon too
local function MakeIconDraggable(frame)
    local dragToggle, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then update(input) end
        end
    end)
end
MakeIconDraggable(FloatIcon)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatIcon.Visible = true
end)

FloatIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatIcon.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- == INIT ==
Pages["Info"].Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
Pages["Info"].Btn.TextColor3 = Color3.fromRGB(0, 255, 255)
Pages["Info"].Page.Visible = true
