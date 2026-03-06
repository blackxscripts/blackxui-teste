--[[
    Services/LogManager.lua
    Central logging service with history and event dispatch.
    Stores messages up to a maximum, providing colored console output.
]]

local LogManager = {}
LogManager.Logs = {}
LogManager.MaxLogs = 200
LogManager.LogAdded = Instance.new("BindableEvent")

--- Add a message to the log
-- @param message string content
-- @param _type string (optional) "info", "success", "warning", "system"
function LogManager:AddLog(message, _type)
    _type = _type or "info"
    table.insert(self.Logs, { msg = message, type = _type })
    if #self.Logs > self.MaxLogs then
        table.remove(self.Logs, 1)
    end
    self.LogAdded:Fire(message, _type)
end

--- Get all stored logs
-- @return table
function LogManager:GetRecent()
    return self.Logs
end

return LogManager
