-- Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. Tạo Window Chính
local Window = Rayfield:CreateWindow({
   Name = "ThTuann V1.5-Pro",
   LoadingTitle = "Đang Sục Gần Ra Từ Từ...",
   LoadingSubtitle = "Dev By ThTuann",
   ConfigurationSaving = { Enabled = true, FileName = "ThTuannConfig" },
   Discord = { Enabled = false }
})

-- 2. Tạo "Bong bóng" (Floating Icon)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local FloatingButton = Instance.new("ImageButton", ScreenGui)

FloatingButton.Size = UDim2.new(0, 50, 0, 50)
FloatingButton.Position = UDim2.new(0.1, 0, 0.1, 0)
FloatingButton.Image = "rbxassetid://6031280882" -- Icon hình tròn mặc định
FloatingButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FloatingButton.Active = true
FloatingButton.Draggable = true -- Cho phép kéo thả như bong bóng

local UICorner = Instance.new("UICorner", FloatingButton)
UICorner.CornerRadius = UDim.new(1, 0) -- Bo tròn hoàn hảo

-- Hàm ẩn/hiện Menu khi nhấn vào bong bóng
FloatingButton.MouseButton1Click:Connect(function()
    Rayfield:ToggleScreenGui()
end)

-- 3. Các tính năng chính (Giữ nguyên từ code trước)
local Tab = Window:CreateTab("Tính năng chính", nil)

-- Anti-Cheat Bypass
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.WalkSpeed < 16 then LocalPlayer.Character.Humanoid.WalkSpeed = 16 end
    end
end)

-- Fly
Tab:CreateToggle({
   Name = "Bay (Fly)",
   CurrentValue = false,
   Callback = function(Value)
      local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if Value then
         local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyVelocity"; bv.MaxForce = Vector3.new(100000, 100000, 100000); bv.Velocity = Vector3.new(0,0,0)
      else
         if hrp and hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
      end
   end,
})

-- Noclip
local Noclip = false
RunService.Stepped:Connect(function()
   if Noclip and LocalPlayer.Character then
      for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
         if v:IsA("BasePart") then v.CanCollide = false end
      end
   end
end)
Tab:CreateToggle({
   Name = "Xuyên tường (Noclip)",
   CurrentValue = false,
   Callback = function(Value) Noclip = Value end,
})

-- Speed
Tab:CreateSlider({
   Name = "Tốc độ di chuyển",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- Teleport
local TargetName = ""
Tab:CreateInput({
   Name = "Nhập tên người cần đến",
   PlaceholderText = "Nhập tên...",
   Callback = function(Text) TargetName = Text end,
})

Tab:CreateButton({
   Name = "Dịch chuyển tới người đó",
   Callback = function()
      local target = game.Players:FindFirstChild(TargetName)
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
         LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
      else
         Rayfield:Notify({Title = "Lỗi", Content = "Người chơi không tồn tại!", Duration = 3})
      end
   end,
})

Rayfield:LoadConfiguration()
