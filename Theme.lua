--[[
    Theme.lua
    Holds shared color definitions and styling constants.

    Modules importing Theme should not mutate its values directly.
]]

local Theme = {}
Theme.Colors = {
    TopBar          = Color3.fromRGB(30, 30, 30),
    PremiumText     = Color3.fromRGB(255, 204, 0),
    LeftColumn      = Color3.fromRGB(40, 40, 40),
    CenterColumn    = Color3.fromRGB(35, 35, 35),
    RightColumn     = Color3.fromRGB(40, 40, 40),
    Button          = Color3.fromRGB(60, 60, 60),
    ButtonHover     = Color3.fromRGB(75, 75, 75),
    Text            = Color3.fromRGB(255, 255, 255),
    PlaceholderText = Color3.fromRGB(150, 150, 150),
    Border          = Color3.fromRGB(20, 20, 20),
}

return Theme
