--[[
    BLACKX UI Framework - Entry module
    Provides top-level API and organizes internal modules.
]]

local blackx = {}

-- versioning
blackx.Version = "1.0.0"

-- load core configuration modules
blackx.Theme = require(script.Theme)
blackx.Assets = require(script.Assets)

blackx.Core = {}
blackx.Components = {}
blackx.Services = {}

-- core modules
blackx.Core.Window = require(script.Core.Window)
blackx.Core.Layout = require(script.Core.Layout)
blackx.Core.Navigation = require(script.Core.Navigation)
blackx.Core.RightPanel = require(script.Core.RightPanel)
blackx.Core.Console = require(script.Core.Console)
blackx.Core.CommandHandler = require(script.Core.CommandHandler)
blackx.Core.EventListener = require(script.Core.EventListener)

-- components
blackx.Components.Button = require(script.Components.Button)
blackx.Components.Toggle = require(script.Components.Toggle)
blackx.Components.Slider = require(script.Components.Slider)
blackx.Components.Tab = require(script.Components.Tab)
blackx.Components.Section = require(script.Components.Section)
blackx.Components.TextBox = require(script.Components.TextBox)

-- services
blackx.Services.LogManager = require(script.Services.LogManager)
blackx.Services.InfiniteAdapter = require(script.Services.InfiniteAdapter)
blackx.Services.ServerEventAdapter = require(script.Services.ServerEventAdapter)

--[[
    Public API

    Methods:
        blackx:CreateWindow(config) -> Window object
        blackx:ExecuteCommand(cmd) -> bool
        blackx:AddLog(message, type)
]]

function blackx:CreateWindow(config)
    return blackx.Core.Window.new(config)
end

function blackx:ExecuteCommand(cmd)
    return blackx.Core.CommandHandler:Execute(cmd)
end

function blackx:AddLog(msg, tp)
    blackx.Services.LogManager:AddLog(msg, tp)
end

return blackx
