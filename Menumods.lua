--// SERVICES
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

--// CHARACTER
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(c)
    char = c
    hrp = c:WaitForChild("HumanoidRootPart")
    humanoid = c:WaitForChild("Humanoid")
end)

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "UltraMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,270,0,350)
frame.Position = UDim2.new(0.5,-135,0.5,-175)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.Active = true
frame.Draggable = true

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "ULTRA MENU 🔥"
title.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- CLOSE
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-30,0,0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(120,0,0)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- BUTTON
local function makeBtn(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-10,0,35)
    b.Position = UDim2.new(0,5,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    return b
end

-- MAIN BUTTONS
local flyBtn = makeBtn("Fly: OFF", 40)
local noclipBtn = makeBtn("Noclip: OFF", 80)
local jumpBtn = makeBtn("Jump Boost", 120)
local tpBtn = makeBtn("Tap TP: OFF", 160)

-- STATES
local flying = false
local noclip = false
local tapTP = false

-- FLY
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "Fly: "..(flying and "ON" or "OFF")
end)

-- NOCLIP
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = "Noclip: "..(noclip and "ON" or "OFF")
end)

-- JUMP FIX
jumpBtn.MouseButton1Click:Connect(function()
    humanoid.UseJumpPower = true
    humanoid.JumpPower = 120
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)

-- TAP TP
tpBtn.MouseButton1Click:Connect(function()
    tapTP = not tapTP
    tpBtn.Text = "Tap TP: "..(tapTP and "ON" or "OFF")
end)

UIS.InputBegan:Connect(function(input)
    if tapTP and input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        local ray = workspace.CurrentCamera:ViewportPointToRay(pos.X, pos.Y)
        local result = workspace:Raycast(ray.Origin, ray.Direction * 500)

        if result then
            hrp.CFrame = CFrame.new(result.Position + Vector3.new(0,3,0))
        end
    end
end)

--// AUTO ZONES 🔥
local y = 210
local added = {}

for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") then
        local name = v.Name:lower()

        if (name:find("zone") or name:find("area") or name:find("spawn") or name:find("celestial") or name:find("finish")) and not added[v.Name] then
            
            added[v.Name] = true

            local btn = makeBtn("TP: "..v.Name, y)

            btn.MouseButton1Click:Connect(function()
                hrp.CFrame = CFrame.new(v.Position + Vector3.new(0,3,0))
            end)

            y = y + 40
        end
    end
end

--// LOOPS
RS.RenderStepped:Connect(function()
    if flying then
        local cam = workspace.CurrentCamera
        bv.Parent = hrp
        bg.Parent = hrp
        bv.Velocity = cam.CFrame.LookVector * 60
        bg.CFrame = cam.CFrame
    else
        bv.Parent = nil
        bg.Parent = nil
    end
end)

RS.Stepped:Connect(function()
    if noclip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end) 
