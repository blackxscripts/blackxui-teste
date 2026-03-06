--[[
    Components/Slider.lua
    A draggable slider component for numeric values in a given range.
]]

local Theme = require(script.Parent.Parent.Theme)

local Slider = {}
Slider.__index = Slider

function Slider.new(config)
    config = config or {}
    local self = setmetatable({}, Slider)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 24)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Theme.Colors.Text
    label.Text = config.Name or "Slider"
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(0.45, 0, 0.4, 0)
    bar.Position = UDim2.new(0.5, 0, 0.3, 0)
    bar.BackgroundColor3 = Theme.Colors.Button

    local handle = Instance.new("Frame", bar)
    handle.Size = UDim2.new(0, 10, 1, 0)
    handle.BackgroundColor3 = Theme.Colors.PremiumText
    handle.Position = UDim2.new(0, 0, 0, 0)

    self._frame = frame
    self._bar = bar
    self._handle = handle
    self.Min = config.Min or 0
    self.Max = config.Max or 100
    self.Value = config.Value or self.Min
    self.Callback = config.Callback

    local dragging = false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relative = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            handle.Position = UDim2.new(relative, 0, 0, 0)
            self.Value = self.Min + (self.Max - self.Min) * relative
            if self.Callback then
                self.Callback(self.Value)
            end
        end
    end)

    if config.Parent then
        frame.Parent = config.Parent
    end

    return self
end

function Slider:Set(val)
    self.Value = math.clamp(val, self.Min, self.Max)
    local ratio = (self.Value - self.Min) / (self.Max - self.Min)
    self._handle.Position = UDim2.new(ratio, 0, 0, 0)
end

function Slider:Get()
    return self.Value
end

function Slider:Destroy()
    if self._frame then
        self._frame:Destroy()
    end
end

return Slider
