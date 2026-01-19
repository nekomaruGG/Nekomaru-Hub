local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- == 1. MEMBUAT WINDOW UTAMA ==
local Window = Rayfield:CreateWindow({
   Name = "Nekomaru Tools | Avatar Changer",
   LoadingTitle = "Nekomaru Interface",
   LoadingSubtitle = "by nekomarugg1",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NekomaruConfig", 
      FileName = "AvatarChanger"
   },
   Discord = {
      Enabled = true,
      Invite = "nekomaru", -- Hanya visual, karena link asli kamu ada di tab Info
      RememberJoins = true 
   },
   KeySystem = false, -- Tidak pakai key biar langsung masuk
})

-- == 2. TAB INFO ==
local InfoTab = Window:CreateTab("Info", 4483362458) -- Icon Info

InfoTab:CreateSection("Creator Information")

InfoTab:CreateParagraph({Title = "Author", Content = "Script ini dibuat oleh kamu sendiri."})
InfoTab:CreateParagraph({Title = "Username", Content = "nekomarugg1"})

InfoTab:CreateButton({
   Name = "Copy Link Discord",
   Callback = function()
      setclipboard("https://discord.gg/nekomaru")
      Rayfield:Notify({
         Title = "Success!",
         Content = "Link Discord berhasil disalin ke clipboard.",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

-- == 3. TAB MENU (VISUAL/AVATAR) ==
local MenuTab = Window:CreateTab("Menu", 4483362458) -- Icon Menu

MenuTab:CreateSection("Avatar Tools")

-- Variabel untuk menyimpan target yang diketik
local targetUser = ""

-- Input Box
local Input = MenuTab:CreateInput({
   Name = "Cari Player (ID / Username)",
   PlaceholderText = "Contoh: roblox",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      targetUser = Text
   end,
})

-- Tombol Search & Apply (Menggunakan Toggle sesuai request)
-- ON = Berubah Wujud
-- OFF = Reset Kembali (Respawn)

local Toggle = MenuTab:CreateToggle({
   Name = "Aktifkan Avatar (Morph)",
   CurrentValue = false,
   Flag = "MorphToggle", 
   Callback = function(Value)
      local Players = game:GetService("Players")
      local LocalPlayer = Players.LocalPlayer

      if Value then
         -- == KONDISI ON: UBAH AVATAR ==
         if targetUser == "" then
             Rayfield:Notify({Title = "Error", Content = "Masukkan Username/ID dulu!", Duration = 3})
             return
         end

         Rayfield:Notify({Title = "Processing...", Content = "Sedang mengambil data avatar...", Duration = 2})

         task.spawn(function()
             local userId = tonumber(targetUser)
             
             -- Kalau input bukan angka, cari ID dari Username
             if not userId then
                 pcall(function()
                     userId = Players:GetUserIdFromNameAsync(targetUser)
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
                     Rayfield:Notify({Title = "Berhasil!", Content = "Avatar telah diubah.", Duration = 3})
                 else
                     Rayfield:Notify({Title = "Gagal", Content = "Tidak bisa memuat avatar target.", Duration = 3})
                 end
             else
                 Rayfield:Notify({Title = "Error", Content = "Player tidak ditemukan.", Duration = 3})
             end
         end)

      else
         -- == KONDISI OFF: RESET AVATAR ==
         if LocalPlayer.Character then
             LocalPlayer.Character:BreakJoints() -- Reset karakter (Mati sebentar)
             Rayfield:Notify({Title = "Reset", Content = "Avatar dikembalikan ke awal.", Duration = 3})
         end
      end
   end,
})

-- Tombol Destroy UI (Hapus Script)
MenuTab:CreateSection("System")

MenuTab:CreateButton({
   Name = "Destroy UI (Tutup Script)",
   Callback = function()
      Rayfield:Destroy()
   end,
})
