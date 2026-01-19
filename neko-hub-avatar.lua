--[[ 
    SIMPLE MODERN GUI - FINAL VERSION
    Fitur: Info & Avatar Morph
    Ringan & Kompatibel Semua Executor
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- == 1. BERSIHKAN GUI LAMA ==
local guiName = "NekoFinalGUI"
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild(guiName) then
        LocalPlayer.PlayerGui[guiName]:Destroy()
    end
    if game.CoreGui:FindFirstChild(guiName) then
        game.CoreGui[guiName]:Destroy()
    end
end)

-- == 2. BUAT SCREEN GUI UTAMA ==
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
-- Coba pasang di CoreGui (lebih aman), kalau gagal ke PlayerGui
if pcall(function() ScreenGui.Parent = game.CoreGui end) then
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- == 3. MAIN FRAME (WINDOW) ==
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30) -- Dark Grey
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Header/Title Bar (Untuk Drag)
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

-- Fix sudut bawah header biar kotak
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)
HeaderFix.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- Title Text
local Title = Instance.new("TextLabel")
Title.Text = "NEKO TOOLS"
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 255) -- Cyan
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- == TOMBOL KONTROL (MIN & CLOSE) ==
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.TextColor3 = Color3.White
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
MinBtn.TextColor3 = Color3.White
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

-- == SIDEBAR (KIRI) ==
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

-- Tombol Tab INFO
local InfoTabBtn = Instance.new("TextButton")
InfoTabBtn.Text = "INFO"
InfoTabBtn.Size = UDim2.new(1, -20, 0, 35)
InfoTabBtn.Position = UDim2.new(0, 10, 0, 15)
InfoTabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255) -- Aktif (Cyan)
InfoTabBtn.TextColor3 = Color3.fromRGB(25, 25, 30)
InfoTabBtn.Font = Enum.Font.GothamBold
InfoTabBtn.Parent = Sidebar
Instance.new("UICorner", InfoTabBtn).CornerRadius = UDim.new(0, 6)

-- Tombol Tab MENU
local MenuTabBtn = Instance.new("TextButton")
MenuTabBtn.Text = "MENU"
MenuTabBtn.Size = UDim2.new(1, -20, 0, 35)
MenuTabBtn.Position = UDim2.new(0, 10, 0, 60)
MenuTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55) -- Tidak Aktif (Grey)
MenuTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MenuTabBtn.Font = Enum.Font.GothamBold
MenuTabBtn.Parent = Sidebar
Instance.new("UICorner", MenuTabBtn).CornerRadius = UDim.new(0, 6)

-- == CONTAINER (ISI KONTEN) ==
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -120, 1, -50)
Container.Position = UDim2.new(0, 115, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- >> HALAMAN 1: INFO <<
local PageInfo = Instance.new("Frame")
PageInfo.Size = UDim2.new(1, 0, 1, 0)
PageInfo.BackgroundTransparency = 1
PageInfo.Visible = true -- Default Muncul
PageInfo.Parent = Container

local function createLabel(parent, text, yPos)
    local l = Instance.new("TextLabel")
    l.Text = text
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Position = UDim2.new(0, 0, 0, yPos)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.White
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

createLabel(PageInfo, "Author: Nekomaru", 0)
createLabel(PageInfo, "Username: nekomarugg1", 30)
createLabel(PageInfo, "Discord Link (Copy bawah):", 70)

local DiscordBox = Instance.new("TextBox")
DiscordBox.Text = "https://discord.gg/nekomaru"
DiscordBox.Size = UDim2.new(1, 0, 0, 35)
DiscordBox.Position = UDim2.new(0, 0, 0, 100)
DiscordBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
DiscordBox.TextColor3 = Color3.fromRGB(0, 255, 255)
DiscordBox.Font = Enum.Font.GothamBold
DiscordBox.TextSize = 14
DiscordBox.ClearTextOnFocus = false
DiscordBox.TextEditable = false
DiscordBox.Parent = PageInfo
Instance.new("UICorner", DiscordBox).CornerRadius = UDim.new(0, 6)

-- >> HALAMAN 2: MENU (AVATAR) <<
local PageMenu = Instance.new("Frame")
PageMenu.Size = UDim2.new(1, 0, 1, 0)
PageMenu.BackgroundTransparency = 1
PageMenu.Visible = false -- Default Sembunyi
PageMenu.Parent = Container

local InputBox = Instance.new("TextBox")
InputBox.PlaceholderText = "Masukkan Username / ID..."
InputBox.Text = ""
InputBox.Size = UDim2.new(1, 0, 0, 40)
InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
InputBox.TextColor3 = Color3.White
InputBox.Font = Enum.Font.Gotham
InputBox.TextSize = 14
InputBox.Parent = PageMenu
Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 6)

local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Text = "SEARCH & APPLY (ON)"
ApplyBtn.Size = UDim2.new(1, 0, 0, 40)
ApplyBtn.Position = UDim2.new(0, 0, 0, 50)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255) -- Cyan
ApplyBtn.TextColor3 = Color3.fromRGB(25, 25, 30)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextSize = 14
ApplyBtn.Parent = PageMenu
Instance.new("UICorner", ApplyBtn).CornerRadius = UDim.new(0, 6)

local ResetBtn = Instance.new("TextButton")
ResetBtn.Text = "RESET DEFAULT (OFF)"
ResetBtn.Size = UDim2.new(1, 0, 0, 40)
ResetBtn.Position = UDim2.new(0, 0, 0, 100)
ResetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
ResetBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.TextSize = 14
ResetBtn.Parent = PageMenu
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)

-- == 4. FLOATING ICON (MINIMIZE) ==
local FloatBtn = Instance.new("TextButton")
FloatBtn.Text = "+"
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
FloatBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 30
FloatBtn.Visible = false
FloatBtn.Parent = ScreenGui
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 255, 255)
Stroke.Thickness = 2
Stroke.Parent = FloatBtn

-- == 5. LOGIKA SCRIPT (CODE) ==

-- A. Fungsi Dragging (Bisa Geser)
local function enableDrag(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end
enableDrag(MainFrame)
enableDrag(FloatBtn)

-- B. Fungsi Ganti Tab
InfoTabBtn.MouseButton1Click:Connect(function()
    PageInfo.Visible = true
    PageMenu.Visible = false
    -- Update Warna Tombol
    InfoTabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    InfoTabBtn.TextColor3 = Color3.fromRGB(25, 25, 30)
    MenuTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    MenuTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

MenuTabBtn.MouseButton1Click:Connect(function()
    PageInfo.Visible = false
    PageMenu.Visible = true
    -- Update Warna Tombol
    MenuTabBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    MenuTabBtn.TextColor3 = Color3.fromRGB(25, 25, 30)
    InfoTabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    InfoTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- C. Fungsi Minimize & Destroy
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatBtn.Visible = true
end)

FloatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatBtn.Visible = false
end)

-- D. Fungsi AVATAR MORPH (Inti Fitur)
ApplyBtn.MouseButton1Click:Connect(function()
    local text = InputBox.Text
    if text == "" then return end
    
    ApplyBtn.Text = "Loading..."
    
    -- Gunakan task.spawn supaya UI tidak nge-freeze saat loading
    task.spawn(function()
        local userId = tonumber(text) -- Cek apakah user input angka (ID)
        
        -- Jika bukan angka, berarti username -> cari ID nya
        if not userId then
            pcall(function()
                userId = Players:GetUserIdFromNameAsync(text)
            end)
        end
        
        if userId then
            -- Ambil data penampilan (baju, aksesoris, dll)
            local success, err = pcall(function()
                local desc = Players:GetHumanoidDescriptionFromUserId(userId)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid:ApplyDescription(desc)
                end
            end)
            
            if success then
                ApplyBtn.Text = "SUCCESS!"
                task.wait(1)
                ApplyBtn.Text = "SEARCH & APPLY (ON)"
            else
                ApplyBtn.Text = "ERROR!"
                task.wait(1)
                ApplyBtn.Text = "SEARCH & APPLY (ON)"
            end
        else
            ApplyBtn.Text = "NOT FOUND"
            task.wait(1)
            ApplyBtn.Text = "SEARCH & APPLY (ON)"
        end
    end)
end)

ResetBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints() -- Reset dengan cara respawn
    end
end)
