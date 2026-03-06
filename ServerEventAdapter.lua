--[[
    Services/ServerEventAdapter.lua
    Helper module for wiring up RemoteEvent and RemoteFunction callbacks.
    Provides a simple interface to server-client communication.
]]

local ServerEventAdapter = {}

--- Connect to a RemoteEvent
-- @param remote RemoteEvent
-- @param callback function
function ServerEventAdapter:Connect(remote, callback)
    if typeof(remote) == "Instance" and remote:IsA("RemoteEvent") then
        remote.OnClientEvent:Connect(callback)
    end
end

--- Invoke a RemoteFunction
-- @param remote RemoteFunction
-- @param ... arguments
-- @return result from server
function ServerEventAdapter:Invoke(remote, ...)
    if typeof(remote) == "Instance" and remote:IsA("RemoteFunction") then
        return remote:InvokeServer(...)
    end
end

return ServerEventAdapter
