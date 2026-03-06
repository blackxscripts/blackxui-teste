--[[
    Components/Tab.lua
    Represents a tabbed page (section of functions) in the left column.
]]

local Button = require(script.Parent.Button)

local Tab = {}
Tab.__index = Tab

function Tab.new(window, name)
    local self = setmetatable({}, Tab)
    self.Window = window
    self.Name = name or "Tab"

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = window and window.Theme and window.Theme.Colors.Button or Color3.new(0.5, 0.5, 0.5)
    btn.Text = self.Name
    btn.TextColor3 = (window and window.Theme and window.Theme.Colors.Text) or Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = window.TabButtonsFrame

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, 0, 1, 0)
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.Visible = false
    list.BackgroundTransparency = 1
    list.Parent = window.FunctionsContainer
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list
    self.FunctionsFrame = list
    self.Button = btn

    btn.MouseButton1Click:Connect(function()
        self:Show()
    end)

    return self
end

function Tab:Show()
    for _, t in ipairs(self.Window.Tabs) do
        t.FunctionsFrame.Visible = false
    end
    self.FunctionsFrame.Visible = true
end

function Tab:CreateButton(config)
    config = config or {}
    config.Parent = self.FunctionsFrame
    local btnObj = Button.new(config)
    self.FunctionsFrame.CanvasSize = UDim2.new(0, 0, 0, self.FunctionsFrame.UIListLayout.AbsoluteContentSize.Y)
    return btnObj
end

return Tab
