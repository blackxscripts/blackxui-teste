--[[
    Services/InfiniteAdapter.lua
    Adapter layer that bridges BLACKX to Infinite Yield's command system.
    Enforces whitelist and prevents unauthorized command execution.
]]

local InfiniteAdapter = {}

-- fixed whitelist of allowed commands
InfiniteAdapter.AllowedCommands = {
    speed  = true,
    jump   = true,
    fly    = true,
    noclip = true,
    hop    = true,
}

--- Execute a command through Infinite Yield if permitted
-- @param cmdString string trimmed command (no semicolon)
-- @return boolean success
function InfiniteAdapter:Execute(cmdString)
    if type(cmdString) ~= "string" then
        return false
    end

    local trimmed = cmdString:gsub("^;", "")
    local name = trimmed:match("^(%S+)")
    if not name then
        return false
    end
    name = name:lower()

    if not self.AllowedCommands[name] then
        return false
    end

    if execCmd then
        local ok = pcall(function()
            execCmd(trimmed, game.Players.LocalPlayer, true)
        end)
        return ok
    else
        warn("InfiniteAdapter: execCmd unavailable")
        return false
    end
end

return InfiniteAdapter
