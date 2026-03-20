-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,150)
frame.Position = UDim2.new(0,20,0.6,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(1,0,0,50)
flyBtn.Text = "Fly: OFF"

local noclipBtn = Instance.new("TextButton", frame)
noclipBtn.Size = UDim2.new(1,0,0,50)
noclipBtn.Position = UDim2.new(0,0,0,50)
noclipBtn.Text = "Noclip: OFF"

-- переменные
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local flying = false
local noclip = false

-- fly
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "Fly: " .. (flying and "ON" or "OFF")

    if flying then
        bv.Parent = hrp
        bg.Parent = hrp
    else
        bv.Parent = nil
        bg.Parent = nil
    end
end)

-- noclip
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = "Noclip: " .. (noclip and "ON" or "OFF")
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclip and char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- движение fly
game:GetService("RunService").RenderStepped:Connect(function()
    if flying then
        local cam = workspace.CurrentCamera
        local dir = cam.CFrame.LookVector
        bv.Velocity = dir * 60
        bg.CFrame = cam.CFrame
    end
end)
