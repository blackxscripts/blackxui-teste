--[[
    Components/Button.lua
    A lightweight button object that wraps a TextButton instance.

    Usage:
        local Button = require(path.to.Components.Button)
        local btnObj = Button.new({Name="Click me", Parent=frame, Callback=function() ... end})
        btnObj:Set("New text")
        btnObj:Destroy()
]]

local Theme = require(script.Parent.Parent.Theme)

local Button = {}
Button.__index = Button

function Button.new(config)
    config = config or {}
    local self = setmetatable({}, Button)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 24)
    btn.BackgroundColor3 = Theme.Colors.Button
    btn.TextColor3 = Theme.Colors.Text
    btn.Text = config.Name or "Button"
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14

    if config.Parent then
        btn.Parent = config.Parent
    end

    if config.Callback and type(config.Callback) == "function" then
        btn.MouseButton1Click:Connect(function()
            config.Callback()
        end)
    end

    self._button = btn
    return self
end

function Button:Set(text)
    if typeof(text) == "string" then
        self._button.Text = text
    end
end

function Button:Get()
    return self._button
end

function Button:Destroy()
    if self._button then
        self._button:Destroy()
    end
end

return Button
