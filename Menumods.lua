--// SERVICES
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ModMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,240)
frame.Position = UDim2.new(0,20,0.5,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

-- CLOSE
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-30,0,0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(150,0,0)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- BUTTON CREATOR
local function makeBtn(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,0,0,40)
    b.Position = UDim2.new(0,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    return b
end

local flyBtn = makeBtn("Fly: OFF", 30)
local noclipBtn = makeBtn("Noclip: OFF", 70)
local jumpBtn = makeBtn("Jump x2", 110)
local tpBtn = makeBtn("Tap TP: OFF", 150)

--// STATES
local flying = false
local noclip = false
local tapTP = false

local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

--// FLY
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "Fly: "..(flying and "ON" or "OFF")
end)

--// NOCLIP
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = "Noclip: "..(noclip and "ON" or "OFF")
end)

--// JUMP POWER
jumpBtn.MouseButton1Click:Connect(function()
    humanoid.JumpPower = humanoid.JumpPower + 50
end)

--// TAP TELEPORT
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

--// RESPAWN FIX
player.CharacterAdded:Connect(function(c)
    char = c
    hrp = c:WaitForChild("HumanoidRootPart")
    humanoid = c:WaitForChild("Humanoid")
end)
