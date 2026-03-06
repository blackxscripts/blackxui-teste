--[[
    Window.lua
    -----------
    Manages the main BLACKX UI window, including the top bar, three-column layout (navigation, console, explorer),
    command input bar, and tab system integration.

    Usage:
        local Window = require(script.Parent.Window)
        local window = Window.new({
            Title = "BLACKX",
            Logo = "rbxassetid://..."  -- optional, defaults to Assets.DefaultLogo
        })
        local tab = window:CreateTab("Início")

    Key Methods:
        Window.new(config) - Create a new window instance
        window:CreateTab(name) - Create a new tab with the given name
        window:BuildUI() - Build all UI elements (called internally by new())

    Properties:
        window.ScreenGui - The main ScreenGui instance
        window.Tabs - Array of Tab objects
        window.Console - Console instance for logging
        window.CommandBar - TextBox for command input
        window.FunctionsContainer - ScrollingFrame holding components

    Integration:
        - Connects to Theme colors
        - Initializes RightPanel (DEX Explorer/Properties)
        - Starts EventListener for game state tracking
        - Wires CommandHandler to command bar FocusLost event
--]]

local Theme = require(script.Parent.Parent.Theme)
local Assets = require(script.Parent.Parent.Assets)
local Layout = require(script.Parent.Layout)
local Navigation = require(script.Parent.Navigation)
local RightPanel = require(script.Parent.RightPanel)
local Console = require(script.Parent.Console)
local CommandHandler = require(script.Parent.CommandHandler)
local EventListener = require(script.Parent.EventListener)

local Window = {}
Window.__index = Window

-- Creates a new Window instance
-- @param config table with Title, Logo properties
function Window.new(config)
    config = config or {}
    local self = setmetatable({}, Window)
    self.Config = config
    self.Tabs = {}
    self.Theme = Theme

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = config.Title or "BLACKX"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = game:GetService("CoreGui")

    self:BuildUI()
    -- Console is created on center panel
    self.Console = Console.new(self.ConsoleFrame)

    -- Wire up event listener for game state tracking
    EventListener:Start()

    return self
end

-- Builds all UI elements for the window
function Window:BuildUI()
    -- ===== TOP BAR =====
    local top = Instance.new("Frame")
    top.Name = "TopBar"
    top.Size = UDim2.new(1, 0, 0, 30)
    top.BackgroundColor3 = Theme.Colors.TopBar
    top.BorderSizePixel = 0
    top.Parent = self.ScreenGui

    -- Logo: Uses config.Logo or defaults to Assets.DefaultLogo
    local logoSize = 40
    local logoImg = Instance.new("ImageLabel")
    logoImg.Name = "Logo"
    logoImg.Size = UDim2.new(0, logoSize, 0, logoSize)
    logoImg.AnchorPoint = Vector2.new(0, 0.5)
    logoImg.Position = UDim2.new(0, 5, 0.5, 0)
    logoImg.BackgroundTransparency = 1
    local logoId = self.Config.Logo or Assets.DefaultLogo
    logoImg.Image = logoId
    logoImg.Parent = top

    -- Title label
    local title = Instance.new("TextLabel")
    title.Text = self.Config.Title or ""
    title.Size = UDim2.new(1, -(logoSize + 10) - 180, 1, 0)
    title.Position = UDim2.new(0, logoSize + 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Theme.Colors.Text
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = top

    -- Premium badge
    local premium = Instance.new("TextLabel")
    premium.Text = "PREMIUM"
    premium.Size = UDim2.new(0, 80, 1, 0)
    premium.AnchorPoint = Vector2.new(1, 0)
    premium.Position = UDim2.new(1, -60, 0, 0)
    premium.BackgroundTransparency = 1
    premium.TextColor3 = Theme.Colors.PremiumText
    premium.Font = Enum.Font.SourceSansBold
    premium.TextSize = 14
    premium.Parent = top

    -- Minimize button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Text = "_"
    minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
    minimizeBtn.AnchorPoint = Vector2.new(1, 0)
    minimizeBtn.Position = UDim2.new(1, -30, 0, 0)
    minimizeBtn.BackgroundColor3 = Theme.Colors.Button
    minimizeBtn.TextColor3 = Theme.Colors.Text
    minimizeBtn.Font = Enum.Font.SourceSansBold
    minimizeBtn.TextSize = 18
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = top
    minimizeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui.Enabled = not self.ScreenGui.Enabled
    end)

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.AnchorPoint = Vector2.new(1, 0)
    closeBtn.Position = UDim2.new(1, 0, 0, 0)
    closeBtn.BackgroundColor3 = Theme.Colors.Button
    closeBtn.TextColor3 = Theme.Colors.Text
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 18
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = top
    closeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)

    -- ===== THREE-COLUMN LAYOUT =====
    local left, center, right = Layout:CreateColumns(self.ScreenGui)
    self.LeftColumn = left
    self.CenterColumn = center
    self.RightColumn = right

    -- ===== LEFT COLUMN: TABS & FUNCTIONS =====
    local header = Instance.new("Frame")
    header.Name = "TabHeader"
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundTransparency = 1
    header.Parent = left

    self.TabButtonsFrame = Instance.new("Frame")
    self.TabButtonsFrame.Name = "TabButtons"
    self.TabButtonsFrame.Size = UDim2.new(1, 0, 1, 0)
    self.TabButtonsFrame.BackgroundTransparency = 1
    self.TabButtonsFrame.Parent = header

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = self.TabButtonsFrame

    -- Info text
    local infoText = Instance.new("TextLabel")
    infoText.Name = "InfoText"
    infoText.Text = "Até 125 funções por Aba"
    infoText.Size = UDim2.new(1, 0, 0, 20)
    infoText.Position = UDim2.new(0, 0, 0, 30)
    infoText.BackgroundTransparency = 1
    infoText.TextColor3 = Theme.Colors.Text
    infoText.Font = Enum.Font.SourceSans
    infoText.TextSize = 12
    infoText.Parent = left

    -- Functions container (scrollable)
    local functionsContainer = Instance.new("ScrollingFrame")
    functionsContainer.Name = "FunctionsContainer"
    functionsContainer.Size = UDim2.new(1, 0, 1, -50)
    functionsContainer.Position = UDim2.new(0, 0, 0, 50)
    functionsContainer.BackgroundTransparency = 1
    functionsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    functionsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    functionsContainer.Parent = left
    local flayout = Instance.new("UIListLayout")
    flayout.SortOrder = Enum.SortOrder.LayoutOrder
    flayout.Parent = functionsContainer
    self.FunctionsContainer = functionsContainer

    -- ===== CENTER COLUMN: CONSOLE & COMMAND BAR =====
    -- Command list (informational)
    local cmdList = Instance.new("TextLabel")
    cmdList.Text = "Lista de comandos disponíveis:\nSPEED <valor>\nJUMP\nFLY\nNOCLIP\nHOP SERVER"
    cmdList.Size = UDim2.new(1, 0, 0, 100)
    cmdList.Position = UDim2.new(0, 0, 1, -130)
    cmdList.BackgroundTransparency = 1
    cmdList.TextColor3 = Theme.Colors.Text
    cmdList.Font = Enum.Font.SourceSans
    cmdList.TextSize = 14
    cmdList.TextXAlignment = Enum.TextXAlignment.Left
    cmdList.Parent = center

    -- Command input bar
    self.CommandBar = Instance.new("TextBox")
    self.CommandBar.PlaceholderText = "DIGITE UM COMANDO COM \";\" EXEMPLO: \";Speed 50\""
    self.CommandBar.Size = UDim2.new(1, 0, 0, 30)
    self.CommandBar.Position = UDim2.new(0, 0, 1, -30)
    self.CommandBar.BackgroundColor3 = Theme.Colors.Button
    self.CommandBar.TextColor3 = Theme.Colors.Text
    self.CommandBar.Font = Enum.Font.SourceSans
    self.CommandBar.TextSize = 14
    self.CommandBar.BorderSizePixel = 0
    self.CommandBar.Parent = center

    -- Wire command bar to CommandHandler
    self.CommandBar.FocusLost:Connect(function(enterPressed)
        if enterPressed and self.CommandBar.Text ~= "" then
            CommandHandler:Execute(self.CommandBar.Text)
            self.CommandBar.Text = ""
        end
    end)

    -- Console frame (scrollable log display)
    self.ConsoleFrame = Instance.new("Frame")
    self.ConsoleFrame.Size = UDim2.new(1, 0, 1, -130)
    self.ConsoleFrame.BackgroundTransparency = 1
    self.ConsoleFrame.Parent = center

    -- ===== RIGHT COLUMN: DEX EXPLORER/PROPERTIES =====
    -- Managed by RightPanel module (fixed, independent of tabs)
    self.RightPanel = RightPanel.new(right)
end

-- Creates a new tab with the given name
-- @param name string - Tab name
-- @returns Tab instance
function Window:CreateTab(name)
    local Tab = require(script.Parent.Parent.Components.Tab)
    local tab = Tab.new(self, name)
    table.insert(self.Tabs, tab)

    -- Create and show tab button
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "Button"
    tabBtn.Text = name
    tabBtn.Size = UDim2.new(0, 100, 1, 0)
    tabBtn.BackgroundColor3 = Theme.Colors.Button
    tabBtn.TextColor3 = Theme.Colors.Text
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 14
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = self.TabButtonsFrame

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            t:Hide()
        end
        tab:Show()
    end)

    -- Show first tab by default
    if #self.Tabs == 1 then
        tab:Show()
    else
        tab:Hide()
    end

    return tab
end

return Window
