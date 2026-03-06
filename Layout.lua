--[[
    Core/Layout.lua
    Helper module that builds the three-column layout used by windows.
    Non-UI logic should not reside here; this file is purely structural.

    Usage:
        local Layout = require(path.to.Core.Layout)
        local left, center, right = Layout:CreateColumns(parentFrame)
]]

local Layout = {}
Layout.__index = Layout

function Layout:CreateColumns(parent)
    -- left column (navigation/functions)
    local left = Instance.new("Frame")
    left.Name = "LeftColumn"
    left.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    left.Size = UDim2.new(0.2, 0, 1, 0)
    left.Position = UDim2.new(0, 0, 0, 0)
    left.Parent = parent

    -- center column (console/content)
    local center = Instance.new("Frame")
    center.Name = "CenterColumn"
    center.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    center.Size = UDim2.new(0.6, 0, 1, 0)
    center.Position = UDim2.new(0.2, 0, 0, 0)
    center.Parent = parent

    -- right column (persistent explorer/properties)
    local right = Instance.new("Frame")
    right.Name = "RightColumn"
    right.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    right.Size = UDim2.new(0.2, 0, 1, 0)
    right.Position = UDim2.new(0.8, 0, 0, 0)
    right.Parent = parent

    return left, center, right
end

return Layout
