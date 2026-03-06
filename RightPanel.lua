--[[
    Core/RightPanel.lua
    Responsible for constructing and maintaining the right-hand column of a BLACKX window.
    This panel is independent of the tab system and remains fixed.

    It loads the DEX Explorer and Properties modules (if available) only once.
]]

local RightPanel = {}
RightPanel.__index = RightPanel

local function requireModule(name)
    -- attempts to locate a module by name in ReplicatedStorage or next to this script
    local moduleObj
    local rs = game:GetService("ReplicatedStorage")
    if rs and rs:FindFirstChild(name) then
        moduleObj = rs:FindFirstChild(name)
    elseif script and script.Parent and script.Parent:FindFirstChild(name) then
        moduleObj = script.Parent:FindFirstChild(name)
    end
    if moduleObj then
        local ok, mod = pcall(require, moduleObj)
        if ok then
            return mod
        end
    end
    return nil
end

function RightPanel.new(parent)
    local self = setmetatable({}, RightPanel)
    self.Parent = parent

    -- two stacked frames, each 50% height
    local explorerFrame = Instance.new("Frame")
    explorerFrame.Name = "ExplorerContainer"
    explorerFrame.Size = UDim2.new(1, 0, 0.5, -1)
    explorerFrame.Position = UDim2.new(0, 0, 0, 0)
    explorerFrame.BackgroundTransparency = 1
    explorerFrame.Parent = parent

    local propsFrame = Instance.new("Frame")
    propsFrame.Name = "PropertiesContainer"
    propsFrame.Size = UDim2.new(1, 0, 0.5, -1)
    propsFrame.Position = UDim2.new(0, 0, 0.5, 1)
    propsFrame.BackgroundTransparency = 1
    propsFrame.Parent = parent

    self.ExplorerFrame = explorerFrame
    self.PropertiesFrame = propsFrame

    self:IntegrateExplorer()
    self:IntegrateProperties()

    return self
end

function RightPanel:IntegrateExplorer()
    local explorer = requireModule("Explorer")
    if explorer and explorer.InitDeps then
        explorer.InitDeps({})
        if explorer.InitAfterMain then explorer.InitAfterMain() end
        local app = explorer.Main()
        if app.Init then app.Init() end
        if app.Window and app.Window.Gui then
            app.Window.Gui.Parent = self.ExplorerFrame
            if app.Window.Gui.TopBar then
                app.Window.Gui.TopBar.Visible = false
            end
            if app.Window.Gui.Main then
                app.Window.Gui.Main.Size = UDim2.new(1, 1, 0, 1)
                app.Window.Gui.Main.Position = UDim2.new(0, 0, 0, 0)
            end
        end
    end
end

function RightPanel:IntegrateProperties()
    local props = requireModule("Properties")
    if props and props.InitDeps then
        props.InitDeps({})
        if props.InitAfterMain then props.InitAfterMain() end
        local app = props.Main()
        if app.Init then app.Init() end
        if app.Window and app.Window.Gui then
            app.Window.Gui.Parent = self.PropertiesFrame
            if app.Window.Gui.TopBar then
                app.Window.Gui.TopBar.Visible = false
            end
            if app.Window.Gui.Main then
                app.Window.Gui.Main.Size = UDim2.new(1, 1, 0, 1)
                app.Window.Gui.Main.Position = UDim2.new(0, 0, 0, 0)
            end
        end
    end
end

return RightPanel
