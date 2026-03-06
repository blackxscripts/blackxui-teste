--[[
    Components/TextBox.lua
    A text input component with optional submit callbacks.
]]

local Theme = require(script.Parent.Parent.Theme)

local TextBox = {}
TextBox.__index = TextBox

function TextBox.new(config)
    config = config or {}
    local self = setmetatable({}, TextBox)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 24)
    box.BackgroundColor3 = Theme.Colors.Button
    box.TextColor3 = Theme.Colors.Text
    box.ClearTextOnFocus = false
    box.PlaceholderText = config.Placeholder or ""
    box.Font = Enum.Font.SourceSans
    box.TextSize = 14

    if config.Text then
        box.Text = config.Text
    end

    if config.Parent then
        box.Parent = config.Parent
    end

    if config.OnSubmit then
        box.FocusLost:Connect(function(enter)
            if enter then
                config.OnSubmit(box.Text)
            end
        end)
    end

    self._box = box
    return self
end

function TextBox:Set(value)
    self._box.Text = value
end

function TextBox:Get()
    return self._box.Text
end

function TextBox:Destroy()
    if self._box then
        self._box:Destroy()
    end
end

return TextBox
