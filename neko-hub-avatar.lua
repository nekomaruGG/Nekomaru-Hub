--[[
    NEKOMARU HUB - ULTIMATE EDITION
    Library: Fluent UI (Windows 11 Style)
    Support: Delta, Fluxus, Hydrogen, PC Executors
    Author: nekomarugg1
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- == WINDOW SETUP ==
local Window = Fluent:CreateWindow({
    Title = "Nekomaru Hub Ultimate",
    SubTitle = "by nekomarugg1",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- == SERVICES & VARIABLES ==
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- State Variables
local Options = Fluent.Options
local EspEnabled = false
local EspBoxes = false
local EspNames = false
local EspTracers = false
local AimbotEnabled = false
local HitboxEnabled = false
local Noclip = false
local InfJump = false
local Spinbot = false

-- == TABS ==
local Tabs = {
    Main = Window:AddTab({ Title = "Main / Player", Icon = "home" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Visuals = Window:AddTab({ Title = "Visuals (ESP)", Icon = "eye" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map" }),
    Fun = Window:AddTab({ Title = "Fun & Misc", Icon = "smile" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- ==========================================
-- TAB 1: MAIN / PLAYER
-- ==========================================

Tabs.Main:AddParagraph({
    Title = "Character Status",
    Content = "Modifikasi kemampuan fisik karaktermu."
})

Tabs.Main:AddSlider("WalkSpeed", {
    Title = "Walk Speed",
    Description = "Kecepatan Lari",
    Default = 16,
    Min = 16,
    Max = 300,
    Rounding = 1,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

Tabs.Main:AddSlider("JumpPower", {
    Title = "Jump Power",
    Description = "Kekuatan Lompat",
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 1,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end
})

Tabs.Main:AddToggle("InfiniteJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(Value) InfJump = Value end
})

Tabs.Main:AddToggle("Noclip", {
    Title = "Noclip (Tembus Tembok)",
    Default = false,
    Callback = function(Value) Noclip = Value end
})

Tabs.Main:AddToggle("GodMode", {
    Title = "Semi-God Mode (Remove Hitbox)",
    Description = "Menghapus bagian tubuh agar susah ditembak.",
    Default = false,
    Callback = function(Value)
        if LocalPlayer.Character then
            if Value then
                for _,v in pairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then v.CanTouch = false end
                end
            else
                for _,v in pairs(LocalPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then v.CanTouch = true end
                end
            end
        end
    end
})

-- Logic Loop Player
RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide == true then v.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- ==========================================
-- TAB 2: COMBAT
-- ==========================================

Tabs.Combat:AddSection("Hitbox Expander")

Tabs.Combat:AddToggle("HitboxToggle", {
    Title = "Expand Hitbox (Kepala Besar)",
    Description = "Memperbesar hitbox musuh agar mudah ditembak.",
    Default = false,
    Callback = function(Value)
        HitboxEnabled = Value
        if not Value then
            -- Reset Size
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                    v.Character.Head.Size = Vector3.new(2,1,1) -- Ukuran normal (approx)
                    v.Character.Head.Transparency = 0
                    v.Character.Head.CanCollide = true
                end
            end
        end
    end
})

Tabs.Combat:AddSlider("HitboxSize", {
    Title = "Hitbox Size",
    Default = 10,
    Min = 2,
    Max = 50,
    Rounding = 1,
    Callback = function(Value) Options.HitboxSize.Value = Value end
})

-- Logic Hitbox Loop
RunService.RenderStepped:Connect(function()
    if HitboxEnabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                -- Team Check Simple
                if v.Team ~= LocalPlayer.Team or v.Team == nil then
                    v.Character.Head.Size = Vector3.new(Options.HitboxSize.Value, Options.HitboxSize.Value, Options.HitboxSize.Value)
                    v.Character.Head.Transparency = 0.5
                    v.Character.Head.CanCollide = false
                end
            end
        end
    end
end)

-- ==========================================
-- TAB 3: VISUALS (ESP)
-- ==========================================

Tabs.Visuals:AddToggle("ESPMaster", {
    Title = "Enable Master ESP",
    Default = false,
    Callback = function(Value) EspEnabled = Value end
})

Tabs.Visuals:AddToggle("ESPBox", { Title = "Box ESP", Default = false, Callback = function(V) EspBoxes = V end })
Tabs.Visuals:AddToggle("ESPName", { Title = "Name ESP", Default = false, Callback = function(V) EspNames = V end })
Tabs.Visuals:AddToggle("ESPChams", { Title = "Chams (Highlight)", Default = false, Callback = function(V) EspTracers = V end })

-- ESP Functions
local function CreateESP(plr)
    if plr == LocalPlayer then return end
    
    local BoxLine = Drawing.new("Square")
    BoxLine.Visible = false
    BoxLine.Color = Color3.new(1,1,1)
    BoxLine.Thickness = 1
    BoxLine.Transparency = 1
    BoxLine.Filled = false

    local NameText = Drawing.new("Text")
    NameText.Visible = false
    NameText.Center = true
    NameText.Outline = true
    NameText.Color = Color3.new(1,1,1)
    NameText.Size = 16

    local Highlight = Instance.new("Highlight")
    Highlight.Name = "NekoCham"
    Highlight.FillColor = Color3.fromRGB(255, 0, 0)
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 0.5
    Highlight.OutlineTransparency = 0

    local function Updater()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and EspEnabled then
                local HRP = plr.Character.HumanoidRootPart
                local Pos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)

               if EspBoxes then
                        BoxLine.Size = BoxSize
                        BoxLine.Position = BoxPos
                        BoxLine.Visible = true
                    else
                        BoxLine.Visible = false
                    end

                    if EspNames then
                        NameText.Position = Vector2.new(Pos.X, BoxPos.Y - 20)
                        NameText.Text = plr.Name
                        NameText.Visible = true
                    else
                        NameText.Visible = false
                    end
                else
                    BoxLine.Visible = false
                    NameText.Visible = false
                end

                -- Chams Logic
                if EspTracers then
                    if not plr.Character:FindFirstChild("NekoCham") then
                        Highlight.Parent = plr.Character
                    end
                else
                    Highlight.Parent = nil
                end
            else
                BoxLine.Visible = false
                NameText.Visible = false
                Highlight.Parent = nil
                if not Players:FindFirstChild(plr.Name) then
                    Connection:Disconnect()
                    BoxLine:Remove()
                    NameText:Remove()
                    Highlight:Destroy()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

for _, v in pairs(Players:GetPlayers()) do CreateESP(v) end
Players.PlayerAdded:Connect(function(v) CreateESP(v) end)

-- ==========================================
-- TAB 4: TELEPORT
-- ==========================================

local PlayerList = {}
local SelectedTPPlayer = nil

local function RefreshPlrs()
    PlayerList = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then table.insert(PlayerList, v.Name) end
    end
end
RefreshPlrs()

local TPDropdown = Tabs.Teleport:AddDropdown("TPDropdown", {
    Title = "Select Player",
    Values = PlayerList,
    Multi = false,
    Default = nil,
    Callback = function(Value) SelectedTPPlayer = Value end
})

Tabs.Teleport:AddButton({
    Title = "Refresh Players",
    Callback = function()
        RefreshPlrs()
        TPDropdown:SetValues(PlayerList)
        TPDropdown:SetValue(nil)
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Player",
    Callback = function()
        if SelectedTPPlayer then
            local target = Players:FindFirstChild(SelectedTPPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            end
        end
    end
})

Tabs.Teleport:AddButton({
    Title = "Give Click TP Tool",
    Description = "Memberikan item untuk teleport via klik mouse.",
    Callback = function()
        local Tool = Instance.new("Tool")
        Tool.RequiresHandle = false
        Tool.Name = "Click Teleport"
        Tool.Parent = LocalPlayer.Backpack
        Tool.Activated:Connect(function()
            local Pos = Mouse.Hit.Position + Vector3.new(0, 3, 0)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Pos)
            end
        end)
    end
})

-- ==========================================
-- TAB 5: FUN & MISC
-- ==========================================

Tabs.Fun:AddSection("Avatar Changer (Morph)")
local MorphTarget = ""

Tabs.Fun:AddInput("MorphInput", {
    Title = "Target Username / ID",
    Default = "",
    Placeholder = "Nekomaru...",
    Callback = function(Value) MorphTarget = Value end
})

Tabs.Fun:AddButton({
    Title = "Apply Morph",
    Callback = function()
        task.spawn(function()
            local uid = tonumber(MorphTarget)
            if not uid then pcall(function() uid = Players:GetUserIdFromNameAsync(MorphTarget) end) end
            if uid then
                local desc = Players:GetHumanoidDescriptionFromUserId(uid)
                if LocalPlayer.Character then LocalPlayer.Character.Humanoid:ApplyDescription(desc) end
                Fluent:Notify({Title="Success", Content="Avatar Changed!"})
            else
                Fluent:Notify({Title="Error", Content="User not found."})
            end
        end)
    end
})

Tabs.Fun:AddSection("Troll Features")

Tabs.Fun:AddToggle("Spinbot", {
    Title = "Spinbot (BeyBlade)",
    Default = false,
    Callback = function(Value)
        Spinbot = Value
        if Spinbot then
            local BodyAngularVelocity = Instance.new("BodyAngularVelocity")
            BodyAngularVelocity.Name = "SpinbotForce"
            BodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
            BodyAngularVelocity.AngularVelocity = Vector3.new(0, 50, 0)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                BodyAngularVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
            end
        else
            if LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart:FindFirstChild("SpinbotForce") then
                LocalPlayer.Character.HumanoidRootPart.SpinbotForce:Destroy()
            end
        end
    end
})

Tabs.Fun:AddSection("Server Tools")

Tabs.Fun:AddButton({
    Title = "FPS Boost (Anti-Lag)",
    Description = "Membuat grafik jadi plastik (jelek) tapi lancar.",
    Callback = function()
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        Workspace.Terrain.WaterWaveSize = 0
        Workspace.Terrain.WaterWaveSpeed = 0
        Workspace.Terrain.WaterReflectance = 0
        Workspace.Terrain.WaterTransparency = 0
        game.Lighting.GlobalShadows = false
        Fluent:Notify({Title="Boosted", Content="FPS Boost Activated!"})
    end
})

Tabs.Fun:AddButton({
    Title = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- ==========================================
-- TAB 6: SETTINGS
-- ==========================================

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Nekomaru Hub",
    Content = "Ultimate Script Loaded Successfully!",
    Duration = 5
})
