--[[ 
    SIMPLE MODERN GUI BASE (DEBUG VERSION)
    Fokus: Memastikan Tombol & Dragging Berfungsi
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 1. Hapus UI Lama (Supaya tidak numpuk)
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("NekoBaseGUI") then
        LocalPlayer.PlayerGui.NekoBaseGUI:Destroy()
    end
end)

-- 2. Buat ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NekoBaseGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

print("GUI Created...")

-- 3. Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 300) -- Ukuran Window
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150) -- Tengah Layar
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- Warna Gelap
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Sudut Melengkung
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Garis Atas Warna-Warni (Gradient)
local TopLine = Instance.new("Frame")
TopLine.Name = "TopGradient"
TopLine.Size = UDim2.new(1, 0, 0, 5)
TopLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopLine.BorderSizePixel = 0
TopLine.Parent = MainFrame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)), -- Cyan
    ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 0, 255))  -- Ungu
}
Gradient.Parent = TopLine
local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopLine

-- Judul
local Title = Instance.new("TextLabel")
Title.Text = "MENU DEBUG"
Title.Size = UDim2.new(1, -100, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- == TOMBOL CLOSE (DESTROY) ==
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseButton"
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.ZIndex = 10 -- Pastikan paling atas
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- == TOMBOL MINIMIZE ==
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinButton"
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -75, 0, 10)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55) -- Abu
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.ZIndex = 10 -- Pastikan paling atas
MinBtn.Parent = MainFrame
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

-- == SIDEBAR (KOSONG) ==
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -50)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

-- == CONTENT AREA (KOSONG) ==
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -140, 1, -50)
Content.Position = UDim2.new(0, 140, 0, 50)
Content.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Content.BackgroundTransparency = 0.5
Content.Parent = MainFrame
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 8)

-- == FLOATING ICON (Saat Minimize) ==
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Text = "OPEN"
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false -- Sembunyi dulu
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0) -- Jadi Bulat
local OpenStroke = Instance.new("UIStroke") -- Garis pinggir
OpenStroke.Color = Color3.fromRGB(0, 255, 255)
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenBtn

-- == LOGIC SCRIPT ==

-- 1. Fungsi Dragging (Geser Window)
local function makeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

makeDraggable(MainFrame)
makeDraggable(OpenBtn)

-- 2. Fungsi Minimize
MinBtn.MouseButton1Click:Connect(function()
    print("Minimize Clicked")
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

-- 3. Fungsi Buka Kembali
OpenBtn.MouseButton1Click:Connect(function()
    print("Open Clicked")
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- 4. Fungsi Destroy (Hapus)
CloseBtn.MouseButton1Click:Connect(function()
    print("Close Clicked")
    ScreenGui:Destroy()
end)

print("Script Loaded Succesfully")
