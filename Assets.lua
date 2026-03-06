-- BlackX Assets (logos, icons, images)

-- Extra icon IDs can be defined in a separate module named "assests" (typo kept for compatibility).
-- Place a module named assests in the same folder with a table of icon IDs.

local ExtraIcons = {}
local ok, result = pcall(function()
    return require(script:FindFirstChild("assests") or script:FindFirstChild("assets"))
end)
if ok and type(result) == "table" then
    ExtraIcons = result
end

local Assets = {
    LogoID = "rbxassetid://102312081475888",
    Icons = ExtraIcons,
}

return Assets
