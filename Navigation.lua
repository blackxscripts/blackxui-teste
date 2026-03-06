--[[
    Core/Navigation.lua
    Utility functions for creating and managing tab navigation buttons.
]]

local Navigation = {}
Navigation.__index = Navigation

--- Create a simple tab button
-- @param name string label for the button
-- @param parent Instance GuiObject where the button will be parented
-- @param callback function called when clicked
-- @return TextButton
function Navigation:CreateTabButton(name, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.TextColor3 = parent and parent.TextColor3 or Color3.new(1, 1, 1)
    btn.Parent = parent
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    return btn
end

return Navigation
