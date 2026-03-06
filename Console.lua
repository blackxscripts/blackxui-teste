--[[
    Core/Console.lua
    Simple log console UI component. Subscribes to LogManager and
    appends messages with color coding.

    Usage:
        local Console = require(path.to.Core.Console)
        local console = Console.new(parentFrame)
]]

local LogManager = require(script.Parent.Parent.Services.LogManager)

local Console = {}
Console.__index = Console

function Console.new(parentFrame)
    local self = setmetatable({}, Console)
    self.Parent = parentFrame

    -- container frame
    self.Frame = Instance.new("Frame")
    self.Frame.Size = UDim2.new(1, 0, 1, 0)
    self.Frame.BackgroundTransparency = 1
    self.Frame.Parent = parentFrame

    self.Scroll = Instance.new("ScrollingFrame")
    self.Scroll.Size = UDim2.new(1, 0, 1, 0)
    self.Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.Scroll.ScrollBarThickness = 4
    self.Scroll.BackgroundTransparency = 1
    self.Scroll.Parent = self.Frame

    self.Layout = Instance.new("UIListLayout")
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.Parent = self.Scroll

    -- react to new logs
    LogManager.LogAdded.Event:Connect(function(msg, typ)
        self:DisplayLog(msg, typ)
    end)

    return self
end

function Console:DisplayLog(message, typ)
    typ = typ or "info"
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = message
    lbl.TextColor3 = self:GetColor(typ)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = self.Scroll

    -- auto scroll to bottom
    self.Scroll.CanvasPosition = Vector2.new(0, self.Scroll.CanvasSize.Y.Offset)
end

function Console:GetColor(typ)
    local colors = {
        info    = Color3.new(1, 1, 1),
        success = Color3.new(0, 1, 0),
        warning = Color3.new(1, 1, 0),
        system  = Color3.new(0.5, 0.5, 0.5),
    }
    return colors[typ] or colors.info
end

return Console
