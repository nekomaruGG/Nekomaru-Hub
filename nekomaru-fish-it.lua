-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- NEKOMARU HUB V2 - INTEGRATED AUTO FISH V4
-- Created by Gemini AI | Logic by User
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- [1] INITIAL CHECK & CLEANUP
if getgenv().NekomaruLoaded then
    game:GetService("CoreGui").NekomaruUI:Destroy()
end
getgenv().NekomaruLoaded = true

-- [2] SERVICES & DEPENDENCIES (Dari Script Kamu)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Validasi Modul Game (Anti-Error)
local success, net = pcall(function()
    return ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
end)

if not success then
    warn("❌ Modul Net tidak ditemukan! Mungkin game sudah update.")
    -- Fallback mechanism could be added here
end

-- [3] CONFIG & VARIABLES
getgenv().Config = {
    AutoFish = false,
    AutoSell = false,
    AutoCatch = true,
    GPUSaver = false,
    BlatantMode = false,
    FishDelay = 0.9,
    CatchDelay = 0.2,
    AutoFavorite = true,
    FavoriteRarity = "Mythic"
}

local LOCATIONS = {
    ["Spawn"] = CFrame.new(45.2788, 252.5629, 2987.1091),
    ["Sisyphus Statue"] = CFrame.new(-3728.216, -135.074, -1012.127),
    ["Coral Reefs"] = CFrame.new(-3114.781, 1.320, 2237.522),
    ["Esoteric Depths"] = CFrame.new(3248.371, -1301.530, 1403.827),
    ["Crater Island"] = CFrame.new(1016.490, 20.091, 5069.272),
    ["Lost Isle"] = CFrame.new(-3618.156, 240.836, -1317.458),
    ["Weather Machine"] = CFrame.new(-1488.511, 83.173, 1876.302),
    ["Tropical Grove"] = CFrame.new(-2095.341, 197.199, 3718.080),
    ["Mount Hallow"] = CFrame.new(2136.623, 78.916, 3272.504),
    ["Treasure Room"] = CFrame.new(-3606.349, -266.573, -1580.973),
    ["Kohana"] = CFrame.new(-663.904, 3.045, 718.796),
    ["Underground Cellar"] = CFrame.new(2109.521, -94.187, -708.609),
    ["Ancient Jungle"] = CFrame.new(1831.713, 6.624, -299.279),
    ["Sacred Temple"] = CFrame.new(1466.921, -21.875, -622.835)
}

local RarityList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Secret"}

-- [4] GUI CONSTRUCTION (NEKOMARU THEME)
local Theme = {
    Bg = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(130, 80, 250), -- Nekomaru Purple
    Text = Color3.fromRGB(240, 240, 240),
    Item = Color3.fromRGB(40, 40, 45),
    Green = Color3.fromRGB(50, 200, 100),
    Red = Color3.fromRGB(200, 60, 60)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NekomaruUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.Size = UDim2.new(0, 140, 1, 0)

local SidebarTitle = Instance.new("TextLabel")
SidebarTitle.Parent = Sidebar
SidebarTitle.Text = "NEKOMARU\nHUB"
SidebarTitle.Size = UDim2.new(1, 0, 0, 60)
SidebarTitle.BackgroundTransparency = 1
SidebarTitle.TextColor3 = Theme.Accent
SidebarTitle.Font = Enum.Font.FredokaOne
SidebarTitle.TextSize = 22

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local SidebarPad = Instance.new("UIPadding")
SidebarPad.Parent = Sidebar
SidebarPad.PaddingTop = UDim.new(0, 70)

-- Content Area
local Content = Instance.new("Frame")
Content.Parent = MainFrame
Content.Size = UDim2.new(1, -140, 1, 0)
Content.Position = UDim2.new(0, 140, 0, 0)
Content.BackgroundTransparency = 1

-- Window Controls
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Content
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.Red
CloseBtn.BackgroundColor3 = Theme.Item
CloseBtn.Font = Enum.Font.GothamBold
UICorner:Clone().Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() getgenv().NekomaruLoaded = false end)

-- -- HELPER FUNCTIONS UI --
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = Sidebar
    TabBtn.Size = UDim2.new(0.85, 0, 0, 35)
    TabBtn.BackgroundColor3 = Theme.Bg
    TabBtn.Text = name
    TabBtn.TextColor3 = Theme.Text
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 13
    UICorner:Clone().Parent = TabBtn
    
    local Page = Instance.new("ScrollingFrame")
    Page.Parent = Content
    Page.Size = UDim2.new(1, -20, 1, -50)
    Page.Position = UDim2.new(0, 10, 0, 50)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    TabBtn.MouseButton1Click:Connect(function()
        if CurrentTab then CurrentTab.Visible = false end
        for _, btn in pairs(Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then btn.BackgroundColor3 = Theme.Bg btn.TextColor3 = Theme.Text end
        end
        CurrentTab = Page
        Page.Visible = true
        TabBtn.BackgroundColor3 = Theme.Accent
        TabBtn.TextColor3 = Color3.new(1,1,1)
    end)
    
    -- Select First Tab
    if CurrentTab == nil then
        CurrentTab = Page
        Page.Visible = true
        TabBtn.BackgroundColor3 = Theme.Accent
    end
    
    return Page
end

local function CreateToggle(page, text, flag, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = page
    ToggleFrame.Size = UDim2.new(0.95, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Theme.Item
    UICorner:Clone().Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.Text = text
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Btn = Instance.new("TextButton")
    Btn.Parent = ToggleFrame
    Btn.Size = UDim2.new(0, 50, 0, 24)
    Btn.Position = UDim2.new(1, -60, 0.5, -12)
    Btn.Text = ""
    Btn.BackgroundColor3 = Theme.Bg
    UICorner:Clone().Parent = Btn
    
    local Status = Instance.new("Frame")
    Status.Parent = Btn
    Status.Size = UDim2.new(0, 20, 0, 20)
    Status.Position = UDim2.new(0, 2, 0.5, -10)
    Status.BackgroundColor3 = Theme.Red
    UICorner:Clone().Parent = Status
    
    local toggled = getgenv().Config[flag] or false
    
    local function update()
        if toggled then
            Status:TweenPosition(UDim2.new(1, -22, 0.5, -10), "Out", "Quad", 0.2)
            Status.BackgroundColor3 = Theme.Green
        else
            Status:TweenPosition(UDim2.new(0, 2, 0.5, -10), "Out", "Quad", 0.2)
            Status.BackgroundColor3 = Theme.Red
        end
        getgenv().Config[flag] = toggled
        if callback then callback(toggled) end
    end
    
    -- Init state
    if toggled then 
        Status.Position = UDim2.new(1, -22, 0.5, -10) 
        Status.BackgroundColor3 = Theme.Green 
    end

    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        update()
    end)
end

local function CreateButton(page, text, color, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = page
    Btn.Size = UDim2.new(0.95, 0, 0, 35)
    Btn.Text = text
    Btn.BackgroundColor3 = color or Theme.Item
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.GothamBold
    UICorner:Clone().Parent = Btn
    Btn.MouseButton1Click:Connect(callback)
end

local function CreateDropdown(page, placeholder, items, callback)
    local DropFrame = Instance.new("Frame")
    DropFrame.Parent = page
    DropFrame.Size = UDim2.new(0.95, 0, 0, 35)
    DropFrame.BackgroundColor3 = Theme.Item
    UICorner:Clone().Parent = DropFrame
    
    local DropBtn = Instance.new("TextButton")
    DropBtn.Parent = DropFrame
    DropBtn.Size = UDim2.new(1, 0, 1, 0)
    DropBtn.BackgroundTransparency = 1
    DropBtn.Text = placeholder .. " ▼"
    DropBtn.TextColor3 = Theme.Text
    DropBtn.Font = Enum.Font.Gotham
    
    local DropList = Instance.new("ScrollingFrame")
    DropList.Parent = DropFrame
    DropList.Size = UDim2.new(1, 0, 0, 120)
    DropList.Position = UDim2.new(0, 0, 1, 5)
    DropList.BackgroundColor3 = Theme.Sidebar
    DropList.Visible = false
    DropList.ZIndex = 5
    UICorner:Clone().Parent = DropList
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = DropList
    Layout.Padding = UDim.new(0, 2)
    
    for _, item in pairs(items) do
        local ItemBtn = Instance.new("TextButton")
        ItemBtn.Parent = DropList
        ItemBtn.Size = UDim2.new(1, 0, 0, 30)
        ItemBtn.BackgroundColor3 = Theme.Bg
        ItemBtn.Text = item
        ItemBtn.TextColor3 = Theme.Text
        ItemBtn.ZIndex = 6
        ItemBtn.MouseButton1Click:Connect(function()
            DropBtn.Text = item .. " ▼"
            DropList.Visible = false
            callback(item)
        end)
    end
    
    DropBtn.MouseButton1Click:Connect(function()
        DropList.Visible = not DropList.Visible
    end)
end

-- [5] TAB SETUP

-- > MAIN TAB
local TabMain = CreateTab("Dashboard")
CreateToggle(TabMain, "Active Auto Fish", "AutoFish", function(val)
    if val then
        -- Trigger Fishing Loop
        task.spawn(function()
            -- Logic Re-injection
        end)
    end
end)
CreateToggle(TabMain, "Blatant Mode (RISKY)", "BlatantMode")
CreateToggle(TabMain, "Auto Catch (Fast Reel)", "AutoCatch")

-- > TELEPORT TAB
local TabTP = CreateTab("Teleports")
for name, cf in pairs(LOCATIONS) do
    CreateButton(TabTP, "Teleport to: " .. name, Theme.Item, function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = cf
        end
    end)
end

-- > SETTINGS TAB
local TabSet = CreateTab("Settings")
CreateToggle(TabSet, "Auto Sell All", "AutoSell")
CreateToggle(TabSet, "Auto Favorite Items", "AutoFavorite")
CreateDropdown(TabSet, "Favorite Rarity", RarityList, function(val)
    getgenv().Config.FavoriteRarity = val
end)
CreateToggle(TabSet, "GPU Saver (Black Screen)", "GPUSaver", function(val)
    if val then
        if not game.CoreGui:FindFirstChild("GPUSaverUI") then
            local g = Instance.new("ScreenGui")
            g.Name = "GPUSaverUI"
            g.Parent = game.CoreGui
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1,0,1,0)
            f.BackgroundColor3 = Color3.new(0,0,0)
            f.Parent = g
            local t = Instance.new("TextLabel")
            t.Text = "GPU SAVER ACTIVE - CLICK UI TO DISABLE"
            t.TextColor3 = Color3.new(0,1,0)
            t.Size = UDim2.new(1,0,0,50)
            t.Parent = f
        end
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    else
        if game.CoreGui:FindFirstChild("GPUSaverUI") then
            game.CoreGui.GPUSaverUI:Destroy()
        end
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
end)


-- [6] LOGIKA SCRIPT (INTEGRATED)
-- Bagian ini berjalan di background sesuai config UI

local Events = {
    fishing = net:WaitForChild("RE/FishingCompleted"),
    sell = net:WaitForChild("RF/SellAllItems"),
    charge = net:WaitForChild("RF/ChargeFishingRod"),
    minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
    equip = net:WaitForChild("RE/EquipToolFromHotbar")
}

-- Logic Loop
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Config.AutoFish and getgenv().NekomaruLoaded then
            pcall(function()
                if not LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    Events.equip:FireServer(1)
                    task.wait(0.5)
                end
                
                -- Cast
                Events.charge:InvokeServer(100)
                task.wait(0.1)
                Events.minigame:InvokeServer(1.3, 1)
                
                -- Wait & Catch
                task.wait(getgenv().Config.FishDelay)
                Events.fishing:FireServer()
                task.wait(getgenv().Config.CatchDelay)
                
                -- Blatant Mode Logic (Spam)
                if getgenv().Config.BlatantMode then
                     Events.fishing:FireServer()
                     task.wait(0.05)
                     Events.fishing:FireServer()
                end
            end)
        end
    end
end)

-- Auto Sell Logic
task.spawn(function()
    while task.wait(5) do
        if getgenv().Config.AutoSell and getgenv().NekomaruLoaded then
            pcall(function() Events.sell:InvokeServer() end)
        end
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

print("✅ NEKOMARU HUB V2 Loaded Successfully!")
