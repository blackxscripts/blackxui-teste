--[[
    Components/Section.lua
    A container frame that holds multiple UI elements with automatic layout.
]]

local Section = {}
Section.__index = Section

function Section.new(config)
    config = config or {}
    local self = setmetatable({}, Section)

    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, 0, 0, 0)
    self.Frame.BackgroundTransparency = 1
    self.Layout = Instance.new("UIListLayout")
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.Parent = self.Frame

    if config.Parent then
        self.Frame.Parent = config.Parent
    end

    return self
end

function Section:Add(child)
    if typeof(child) == "table" and child._button then
        child._button.Parent = self.Frame
    elseif typeof(child) == "Instance" then
        child.Parent = self.Frame
    end
    self.Frame.Size = UDim2.new(1, 0, 0, self.Frame.UIListLayout.AbsoluteContentSize.Y)
end

function Section:Set(value) end

function Section:Get() end

function Section:Destroy()
    if self.Frame then
        self.Frame:Destroy()
    end
end

return Section
