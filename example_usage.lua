--[[
    BLACKX Framework - Complete Usage Example
    ===========================================

    This file demonstrates all major features and components of the BLACKX UI framework.
    Copy this structure as a template for your own scripts.

    Requirements:
    - Infinite Yield must be loaded first
    - DEX modules available (optional, for Explorer/Properties)
    - BLACKX src folder in the same directory

    Usage:
    1. Save this file as your main script
    2. Keep BLACKX folder in the same directory
    3. Load this script in an executor
]]

-- Step 1: Load Infinite Yield first
local function loadInfiniteYield()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)

    if not success then
        warn("Failed to load Infinite Yield:", result)
        return false
    end

    wait(0.5)

    if not _G.execCmd then
        warn("Infinite Yield loaded but execCmd not found")
        return false
    end

    return true
end

-- Step 2: Load BLACKX
local function loadBLACKX()
    local success, BLACKX = pcall(function()
        return require(script:WaitForChild("BLACKX"):WaitForChild("src"):WaitForChild("init"))
    end)

    if not success then
        warn("Failed to load BLACKX:", BLACKX)
        return nil
    end

    return BLACKX
end

-- =============================================================================
-- MAIN SCRIPT EXECUTION
-- =============================================================================

print("=== BLACKX Framework Example ===")

-- Load dependencies
if not loadInfiniteYield() then
    print("ERROR: Could not load Infinite Yield. Exiting.")
    return
end

print("✓ Infinite Yield loaded")

local BLACKX = loadBLACKX()
if not BLACKX then
    print("ERROR: Could not load BLACKX. Exiting.")
    return
end

print("✓ BLACKX loaded")

-- =============================================================================
-- Create Main Window
-- =============================================================================

local window = BLACKX:CreateWindow({
    Title = "Combat Scripts v1.0",
    Logo = "rbxassetid://13046281618" -- Optional custom logo
})

BLACKX:AddLog("Script initialized", "system")

-- =============================================================================
-- TAB 1: Combat / Movement
-- =============================================================================

local combatTab = window:CreateTab("Combat")

-- Combat Section
local combatSection = combatTab:CreateSection("Movimento")

combatSection:CreateButton({
    Name = "Speed x2",
    Callback = function()
        BLACKX:ExecuteCommand("Speed 50")
        BLACKX:AddLog("Speed set to 50", "success")
    end
})

combatSection:CreateButton({
    Name = "Speed x3",
    Callback = function()
        BLACKX:ExecuteCommand("Speed 100")
        BLACKX:AddLog("Speed set to 100", "success")
    end
})

combatSection:CreateButton({
    Name = "Jump",
    Callback = function()
        BLACKX:ExecuteCommand("Jump")
        BLACKX:AddLog("Jump command executed", "info")
    end
})

-- Speed Slider
combatSection:CreateSlider({
    Name = "Custom Speed",
    Min = 0,
    Max = 200,
    Default = 16,
    Callback = function(value)
        BLACKX:ExecuteCommand("Speed " .. math.floor(value))
        BLACKX:AddLog("Speed set to " .. math.floor(value), "info")
    end
})

-- Flight Systems
local flightSection = combatTab:CreateSection("Flight")

flightSection:CreateButton({
    Name = "Enable Flight",
    Callback = function()
        BLACKX:ExecuteCommand("Fly")
        BLACKX:AddLog("Flight enabled", "success")
    end
})

local flightSpeedSlider = flightSection:CreateSlider({
    Name = "Flight Speed",
    Min = 10,
    Max = 100,
    Default = 25,
    Callback = function(value)
        BLACKX:AddLog("Flight speed set to " .. value, "info")
        -- You could integrate custom flight logic here
    end
})

-- Toggles
local toggleSection = combatTab:CreateSection("Modes")

toggleSection:CreateToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(enabled)
        if enabled then
            BLACKX:AddLog("God Mode: ENABLED", "success")
        else
            BLACKX:AddLog("God Mode: DISABLED", "warning")
        end
    end
})

toggleSection:CreateToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(enabled)
        if enabled then
            BLACKX:ExecuteCommand("Noclip")
            BLACKX:AddLog("NoClip enabled", "success")
        else
            BLACKX:AddLog("NoClip disabled", "info")
        end
    end
})

-- =============================================================================
-- TAB 2: Server
-- =============================================================================

local serverTab = window:CreateTab("Servidor")

local serverSection = serverTab:CreateSection("Servidor")

serverSection:CreateButton({
    Name = "Hop Server",
    Callback = function()
        BLACKX:AddLog("Hoppping to next server...", "warning")
        wait(1)
        BLACKX:ExecuteCommand("Hop Server")
    end
})

-- Server ID input
serverSection:CreateTextBox({
    Name = "Custom Server ID",
    Placeholder = "Enter server ID...",
    OnSubmit = function(text)
        if text and text ~= "" then
            BLACKX:AddLog("Joining server: " .. text, "info")
            -- Custom server join logic here
        end
    end
})

local infoSection = serverTab:CreateSection("Informações")

infoSection:CreateButton({
    Name = "Player Stats",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        BLACKX:AddLog("Player: " .. player.Name, "info")
        BLACKX:AddLog("Health: Good", "success")
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                BLACKX:AddLog("Humanoid Health: " .. humanoid.Health, "info")
            end
        end
    end
})

-- =============================================================================
-- TAB 3: Settings
-- =============================================================================

local settingsTab = window:CreateTab("Configurações")

local uiSection = settingsTab:CreateSection("Interface")

uiSection:CreateToggle({
    Name = "Debug Mode",
    Default = false,
    Callback = function(enabled)
        if enabled then
            BLACKX:AddLog("Debug mode enabled", "system")
        else
            BLACKX:AddLog("Debug mode disabled", "system")
        end
    end
})

uiSection:CreateSlider({
    Name = "UI Opacity",
    Min = 0.1,
    Max = 1,
    Default = 1,
    Callback = function(value)
        BLACKX:AddLog("UI opacity set to " .. math.floor(value * 100) .. "%", "info")
        -- Apply UI transparency here
    end
})

local gameSection = settingsTab:CreateSection("Gameplay")

gameSection:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(enabled)
        if enabled then
            BLACKX:AddLog("Auto Farm: ENABLED", "success")
        else
            BLACKX:AddLog("Auto Farm: DISABLED", "info")
        end
    end
})

gameSection:CreateToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(enabled)
        if enabled then
            BLACKX:AddLog("Godmode enabled", "success")
            -- Godmode implementation here
        else
            BLACKX:AddLog("Godmode disabled", "warning")
        end
    end
})

local miscSection = settingsTab:CreateSection("Miscelânea")

miscSection:CreateButton({
    Name = "Clear Console",
    Callback = function()
        BLACKX:AddLog("Console cleared", "system")
        -- Clear console history here
    end
})

miscSection:CreateButton({
    Name = "Reset to Defaults",
    Callback = function()
        BLACKX:AddLog("Settings reset to defaults", "warning")
        -- Reset all settings
    end
})

-- =============================================================================
-- TAB 4: About
-- =============================================================================

local aboutTab = window:CreateTab("Sobre")

local infoSection = aboutTab:CreateSection("Informações")

infoSection:CreateButton({
    Name = "Version: 1.0.0",
    Callback = function()
        BLACKX:AddLog("BLACKX v1.0.0", "system")
    end
})

aboutTab:CreateSection("Funcionalidades"):CreateButton({
    Name = "Movimentação 🚀",
    Callback = function()
        BLACKX:AddLog("Speed, Jump, Flight, NoClip", "info")
    end
})

aboutTab:CreateSection("Controles"):CreateButton({
    Name = ";Speed 50 - Aumenta velocidade",
    Callback = function()
        BLACKX:AddLog("Command reference printed", "system")
    end
})

-- =============================================================================
-- Advanced Example: Custom Logic
-- =============================================================================

-- Example: Monitor player stats
local function monitorPlayerStats()
    local player = game:GetService("Players").LocalPlayer

    while true do
        wait(3)

        if player and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                -- Log health changes
                if humanoid.Health < 30 then
                    BLACKX:AddLog("⚠️ Low HP Warning!", "warning")
                end
            end
        end
    end
end

-- Uncomment to enable player monitoring
-- task.spawn(monitorPlayerStats)

-- =============================================================================
-- Example: Command Integration
-- =============================================================================

local function executeCommandSafely(command)
    local success = BLACKX:ExecuteCommand(command)
    if success then
        BLACKX:AddLog("Command executed: " .. command, "success")
    else
        BLACKX:AddLog("Command failed: " .. command, "warning")
    end
    return success
end

-- Example usage:
-- executeCommandSafely("Speed 75")
-- executeCommandSafely("Jump")

-- =============================================================================
-- Script Ready
-- =============================================================================

print("✓ BLACKX framework initialized")
print("✓ All tabs and components loaded")
print("✓ Script ready for use")

BLACKX:AddLog("Script fully loaded!", "success")
BLACKX:AddLog("Ready to execute commands", "info")
BLACKX:AddLog("Use the Combat tab to get started", "system")

-- =============================================================================
-- Optional: Add More Dynamic Features
-- =============================================================================

-- Example: Create buttons dynamically
local function addDynamicButton(tab, buttonName, command)
    tab:CreateButton({
        Name = buttonName,
        Callback = function()
            BLACKX:ExecuteCommand(command)
            BLACKX:AddLog(buttonName .. " executed", "success")
        end
    })
end

-- Example usage:
-- local miscTab = window:CreateTab("Misc")
-- addDynamicButton(miscTab, "Speed 50", "Speed 50")
-- addDynamicButton(miscTab, "Jump", "Jump")

-- =============================================================================
-- Cleanup (optional on script exit)
-- =============================================================================

-- When you want to close the script:
-- window:Destroy()
-- BLACKX:AddLog("Script ended", "system")

print("=== BLACKX Example Script Complete ===")
