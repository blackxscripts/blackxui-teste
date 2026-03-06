-- Loader component for BlackX
-- Usage:
-- local loader = Loader.new(parentFrame, { Text = "Carregando..." })
-- loader:Start()
-- loader:Stop()

local Theme = require(game:GetService("ReplicatedStorage").BlackX.Theme)

local Loader = {}
Loader.__index = Loader

function Loader.new(parent, config)
    config = config or {}

    local self = setmetatable({}, Loader)
    self.Text = config.Text or "Loading..."
    self.Duration = config.Duration or 0 -- seconds; 0 = indefinite

    local overlay = Instance.new("Frame")
    overlay.Name = "BlackXLoader"
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.BorderSizePixel = 0
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.Visible = false
    overlay.Parent = parent

    local center = Instance.new("Frame")
    center.Name = "LoaderCenter"
    center.Size = UDim2.new(0, 240, 0, 96)
    center.Position = UDim2.new(0.5, 0, 0.5, 0)
    center.AnchorPoint = Vector2.new(0.5, 0.5)
    center.BackgroundColor3 = Theme.Main
    center.BorderSizePixel = 1
    center.BorderColor3 = Theme.Stroke
    center.Parent = overlay

    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.Parent = center
    text.AnchorPoint = Vector2.new(0.5, 0.5)
    text.Position = UDim2.new(0.5, 0, 0.5, 0)
    text.Size = UDim2.new(0.9, 0, 0.6, 0)
    text.BackgroundTransparency = 1
    text.Text = self.Text
    text.TextColor3 = Theme.NeonWhite
    text.Font = Enum.Font.Gotham
    text.TextSize = 16
    text.TextWrapped = true
    text.TextScaled = false
    text.TextYAlignment = Enum.TextYAlignment.Center

    local spinner = Instance.new("ImageLabel")
    spinner.Name = "Spinner"
    spinner.Parent = center
    spinner.AnchorPoint = Vector2.new(0.5, 0)
    spinner.Position = UDim2.new(0.5, 0, 0.1, 0)
    spinner.Size = UDim2.new(0, 32, 0, 32)
    spinner.BackgroundTransparency = 1
    spinner.Image = "rbxassetid://102312081475888" -- Use same logo as visual spinner
    spinner.Rotation = 0

    local running = false
    local connection

    local function startSpinner()
        if connection then
            connection:Disconnect()
            connection = nil
        end
        connection = game:GetService("RunService").RenderStepped:Connect(function(delta)
            spinner.Rotation = spinner.Rotation + (delta * 360)
        end)
    end

    function self:Start()
        overlay.Visible = true
        running = true
        startSpinner()

        if self.Duration > 0 then
            delay(self.Duration, function()
                if running then
                    self:Stop()
                end
            end)
        end
    end

    function self:Stop()
        running = false
        overlay.Visible = false
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end

    self.Instance = overlay
    return self
end

return Loader
