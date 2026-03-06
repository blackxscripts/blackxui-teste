--[[
    Core/CommandHandler.lua
    Responsible for processing raw command strings entered by the user.
    Enforces a fixed whitelist and delegates execution to InfiniteAdapter.
    Also logs command usage via LogManager.
]]

local InfiniteAdapter = require(script.Parent.Parent.Services.InfiniteAdapter)
local LogManager = require(script.Parent.Parent.Services.LogManager)

local CommandHandler = {}
CommandHandler.__index = CommandHandler

-- whitelist of allowed command names (lowercase)
CommandHandler.AllowedCommands = {
    speed  = true,
    jump   = true,
    fly    = true,
    noclip = true,
    hop    = true,
}

--- Execute a command string prefixed with ';'.
--@param cmdString string raw command including prefix
--@return boolean whether the command was forwarded
function CommandHandler:Execute(cmdString)
    if type(cmdString) ~= "string" then
        return false
    end

    -- remove leading prefix
    local trimmed = cmdString:gsub("^;", "")
    local name = trimmed:match("^(%S+)")
    if not name then
        return false
    end
    name = name:lower()

    if not self.AllowedCommands[name] then
        -- silently ignore disallowed commands
        return false
    end

    local ok = InfiniteAdapter:Execute(trimmed)
    if ok then
        local playerName = "Unknown"
        pcall(function() playerName = game.Players.LocalPlayer.Name end)
        -- specialized message for speed
        if name == "speed" and trimmed:match("%d+") then
            local amount = trimmed:match("(%d+)")
            LogManager:AddLog("(" .. playerName .. ") ganhou " .. amount .. " de velocidade por BLACK X SCRIPTS",
                "success")
        else
            LogManager:AddLog("(" .. playerName .. ") executou: " .. trimmed, "success")
        end
    end
    return ok
end

return CommandHandler
