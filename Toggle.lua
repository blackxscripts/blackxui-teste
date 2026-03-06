--[[
    Components/Toggle.lua
    A simple on/off toggle control.
]]

local Theme = require(script.Parent.Parent.Theme)

local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(config)
    config = config or {}
    local self = setmetatable({}, Toggle)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 24)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Theme.Colors.Text
    label.Text = config.Name or "Toggle"
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0.3, -2, 1, -2)
    button.Position = UDim2.new(0.7, 2, 0, 1)
    button.BackgroundColor3 = Theme.Colors.Button
    button.Text = config.Value and "ON" or "OFF"
    button.TextColor3 = Theme.Colors.Text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 12

    self._frame = frame
    self._button = button
    self.State = config.Value and true or false

    button.MouseButton1Click:Connect(function()
        self.State = not self.State
        button.Text = self.State and "ON" or "OFF"
        if config.Callback then
            config.Callback(self.State)
        end
    end)

    if config.Parent then
        frame.Parent = config.Parent
    end

    return self
end

function Toggle:Set(value)
    self.State = not not value
    self._button.Text = self.State and "ON" or "OFF"
end

function Toggle:Get()
    return self.State
end

function Toggle:Destroy()
    if self._frame then
        self._frame:Destroy()
    end
end

return Toggle
