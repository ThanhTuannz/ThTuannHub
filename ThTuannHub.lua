--[=[
    NGỌC NGHĨA X THANH TUẤN - FINAL VERSION
    Tính năng: Key System (1606), Drag UI, Nearest Aimbot, ESP, Toggle Menu (RightControl)
--]=]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local CORRECT_KEY = "1606"

-- 1. UI Setup
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "NgocNghiaXThanhTuanHub"

-- [KHUNG ĐĂNG NHẬP]
local LoginFrame = Instance.new("Frame", ScreenGui)
LoginFrame.Size = UDim2.new(0, 200, 0, 100)
LoginFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
LoginFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UIStroke", LoginFrame).Color = Color3.fromRGB(0, 255, 0)

local KeyInput = Instance.new("TextBox", LoginFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0.3, 0)
KeyInput.Position = UDim2.new(0.1, 0, 0.1, 0)
KeyInput.PlaceholderText = "Nhập Key..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInput.TextColor3 = Color3.new(1, 1, 1)

local SubmitBtn = Instance.new("TextButton", LoginFrame)
SubmitBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
SubmitBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
SubmitBtn.Text = "XÁC NHẬN"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)

-- [KHUNG CHÍNH]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 320)
Main.Position = UDim2.new(0.5, -160, 0.4, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Visible = false 
Main.Active = true
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 0)

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "NGỌC NGHĨA X THANH TUẤN"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold

-- 2. Logic Kéo thả
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function() dragging = false end)

-- 3. Chức năng ESP & Aimbot
local states = {aimbot = false, esp = false}

RunService.RenderStepped:Connect(function()
    if not Main.Visible then return end
    
    -- ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            hl.Enabled = states.esp
        end
    end
    
    -- Nearest Aimbot
    if states.aimbot then
        local closest, dist = nil, 500
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local d = (p.Character.Head.Position - Camera.CFrame.Position).Magnitude
                if d < dist then closest = p.Character.Head dist = d end
            end
        end
        if closest then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, closest.Position) end
    end
end)

-- 4. Tạo Nút bấm
local function createButton(text, stateKey, posY)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0, 280, 0, 50)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function()
        states[stateKey] = not states[stateKey]
        btn.Text = text:split(":")[1] .. ": " .. (states[stateKey] and "ON" or "OFF")
    end)
end

createButton("Aimbot: OFF", "aimbot", 60)
createButton("ESP: OFF", "esp", 120)

-- Kiểm tra Key
SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        LoginFrame:Destroy()
        Main.Visible = true
    else
        KeyInput.Text = "SAI KEY ROI CON DI ME MAY!"
        task.wait(1)
        KeyInput.Text = ""
    end
end)

-- Nút Ẩn/Hiện
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightControl and Main.Parent then
        Main.Visible = not Main.Visible
    end
end)
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
