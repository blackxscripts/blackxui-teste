--[[
    Core/EventListener.lua
    Hooks a few local and remote events to generate console logs.
    Does not modify game state, only observes and reports.
]]

local LogManager = require(script.Parent.Parent.Services.LogManager)
local ServerEventAdapter = require(script.Parent.Parent.Services.ServerEventAdapter)

local EventListener = {}
EventListener.__index = EventListener

function EventListener:Start()
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer

    if plr then
        -- backpack additions (e.g. items and pets)
        plr:WaitForChild("Backpack").ChildAdded:Connect(function(child)
            if child.Name:lower():find("pet") then
                LogManager:AddLog("Você recebeu um Pet " .. child.Name, "success")
            else
                LogManager:AddLog("Item `" .. child.Name .. "` adicionado à mochila", "info")
            end
        end)

        -- leaderstats value changes
        local stats = plr:FindFirstChild("leaderstats")
        if stats then
            local function attachStat(stat)
                stat.Changed:Connect(function(val)
                    LogManager:AddLog("leaderstats " .. stat.Name .. " mudou para " .. tostring(val), "info")
                end)
            end
            for _, s in pairs(stats:GetChildren()) do
                attachStat(s)
            end
            stats.ChildAdded:Connect(attachStat)
        end
    end

    -- listen to any RemoteEvent under ReplicatedStorage
    local rs = game:GetService("ReplicatedStorage")
    for _, obj in pairs(rs:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            ServerEventAdapter:Connect(obj, function(...)
                LogManager:AddLog("Evento servidor disparado: " .. obj.Name, "system")
            end)
        end
    end
end

return EventListener
