.-- BlackX UI Library
-- Load with: local BlackX = require(game:GetService("ReplicatedStorage").BlackX)

local BlackX = {}
BlackX.__index = BlackX

-- Core dependencies (modular)
local Theme = require(script.Theme)
local Assets = require(script.Assets)
local ButtonModule = require(script.Components.Button)
local ToggleModule = require(script.Components.Toggle)
local SliderModule = require(script.Components.Slider)
local LoaderModule = require(script.Components.Loader)

local Players = game:GetService("Players")

local function safeName(value)
    return tostring(value):gsub("%W", "_")
end

-- Creates the main UI window
function BlackX:CreateWindow(config)
    config = config or {}
    local name = config.Name or "BlackX Window"

    local player = Players.LocalPlayer
    if not player then
        warn("BlackX:CreateWindow() requires a LocalPlayer")
        return nil
    end

    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "BlackXMain"
    mainFrame.Parent = screenGui
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0.8, 0, 0.8, 0)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true

    local leftPanel = Instance.new("Frame")
    leftPanel.Name = "BlackXLeft"
    leftPanel.Parent = mainFrame
    leftPanel.Size = UDim2.new(0, 180, 1, 0)
    leftPanel.Position = UDim2.new(0, 0, 0, 0)
    leftPanel.BackgroundColor3 = Theme.Main
    leftPanel.BorderSizePixel = 1
    leftPanel.BorderColor3 = Theme.Stroke

    local leftPadding = Instance.new("UIPadding")
    leftPadding.PaddingTop = UDim.new(0, 12)
    leftPadding.PaddingBottom = UDim.new(0, 12)
    leftPadding.PaddingLeft = UDim.new(0, 12)
    leftPadding.PaddingRight = UDim.new(0, 12)
    leftPadding.Parent = leftPanel

    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Parent = leftPanel
    tabsContainer.BackgroundTransparency = 1
    tabsContainer.Size = UDim2.new(1, 0, 1, 0)

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabsContainer
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 8)

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Parent = mainFrame
    contentArea.Position = UDim2.new(0, 190, 0, 0)
    contentArea.Size = UDim2.new(1, -190, 1, 0)
    contentArea.BackgroundColor3 = Theme.Main
    contentArea.BorderSizePixel = 1
    contentArea.BorderColor3 = Theme.Stroke

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 12)
    contentPadding.PaddingBottom = UDim.new(0, 12)
    contentPadding.PaddingLeft = UDim.new(0, 16)
    contentPadding.PaddingRight = UDim.new(0, 16)
    contentPadding.Parent = contentArea

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = contentArea
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top

    local logoHolder = Instance.new("Frame")
    logoHolder.Name = "LogoHolder"
    logoHolder.Parent = contentArea
    logoHolder.Size = UDim2.new(1, 0, 0, 70)
    logoHolder.BackgroundTransparency = 1

    Assets:CreateLogo(logoHolder)

    local window = setmetatable({
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        Tabs = {},
        _TabsContainer = tabsContainer,
        _ContentArea = contentArea,
        _CurrentTab = nil,
    }, BlackX)

    function window:SelectTab(tabName)
        for name, tab in pairs(self.Tabs) do
            local isSelected = name == tabName
            tab.ContentFrame.Visible = isSelected
            if tab.Button then
                if isSelected then
                    tab.Button.BackgroundColor3 = Theme.NeonWhite
                    tab.Button.TextColor3 = Theme.Main
                else
                    tab.Button.BackgroundColor3 = Theme.Main
                    tab.Button.TextColor3 = Theme.Text
                end
            end
        end
        self._CurrentTab = self.Tabs[tabName]
    end

    function window:CreateTab(tabName)
        local safe = safeName(tabName)

        local tabButton = Instance.new("TextButton")
        tabButton.Name = safe .. "_TabButton"
        tabButton.Parent = self._TabsContainer
        tabButton.Size = UDim2.new(1, 0, 0, 34)
        tabButton.Text = tabName
        tabButton.AutoButtonColor = false
        tabButton.BackgroundColor3 = Theme.Main
        tabButton.BorderSizePixel = 1
        tabButton.BorderColor3 = Theme.Stroke
        tabButton.TextColor3 = Theme.Text
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14

        local tabContent = Instance.new("Frame")
        tabContent.Name = safe .. "_Content"
        tabContent.Parent = self._ContentArea
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundColor3 = Theme.Main
        tabContent.BorderSizePixel = 1
        tabContent.BorderColor3 = Theme.Stroke
        tabContent.Visible = false

        local tabPadding = Instance.new("UIPadding")
        tabPadding.PaddingTop = UDim.new(0, 10)
        tabPadding.PaddingBottom = UDim.new(0, 10)
        tabPadding.PaddingLeft = UDim.new(0, 10)
        tabPadding.PaddingRight = UDim.new(0, 10)
        tabPadding.Parent = tabContent

        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Parent = tabContent
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 8)

        local tab = {
            Name = tabName,
            Button = tabButton,
            ContentFrame = tabContent,
            _Layout = tabLayout,
            _Elements = {},
        }

        function tab:CreateButton(config)
            local btn = ButtonModule.new(self.ContentFrame, config)
            self._Elements[#self._Elements + 1] = btn
            return btn
        end

        function tab:BlackXButton(config)
            return self:CreateButton(config)
        end

        function tab:CreateToggle(config)
            local tog = ToggleModule.new(self.ContentFrame, config)
            self._Elements[#self._Elements + 1] = tog
            return tog
        end

        function tab:CreateSlider(config)
            local slider = SliderModule.new(self.ContentFrame, config)
            self._Elements[#self._Elements + 1] = slider
            return slider
        end

        tabButton.MouseButton1Click:Connect(function()
            window:SelectTab(tabName)
        end)

        self.Tabs[tabName] = tab
        return tab
    end

    function window:CreateLoader(config)
        local loader = LoaderModule.new(self.MainFrame, config)
        self._Loader = loader
        return loader
    end

    return window
end

function BlackX:CreateTab(window, tabName)
    if window and type(window.CreateTab) == "function" then
        return window:CreateTab(tabName)
    end
end

function BlackX:CreateButton(tab, config)
    if tab and type(tab.CreateButton) == "function" then
        return tab:CreateButton(config)
    end
end

function BlackX:CreateToggle(tab, config)
    if tab and type(tab.CreateToggle) == "function" then
        return tab:CreateToggle(config)
    end
end

function BlackX:CreateLoader(window, config)
    if window and type(window.CreateLoader) == "function" then
        return window:CreateLoader(config)
    end
end

-- Compatibility helpers
_G.BlackX = BlackX
_G.Rayfield = BlackX

return BlackX
