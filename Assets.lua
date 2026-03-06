--[[
    Assets.lua
    Visual asset references used throughout the UI (icons, logos, etc.).

    Developers may replace the placeholder values with real asset IDs.
]]

local Assets = {}

Assets.Icons = {
    logo        = "rbxassetid://0", -- main logo icon
    minimize    = "rbxassetid://0", -- minimize button
    close       = "rbxassetid://0", -- close button
    premiumStar = "rbxassetid://0", -- premium indicator
}

-- default logo when no custom logo is supplied
Assets.DefaultLogo = "rbxassetid://0" -- update with actual default asset

function Assets:GetIcon(name)
    return Assets.Icons[name]
end

return Assets
