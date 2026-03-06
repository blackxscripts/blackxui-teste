# BLACKX API Reference

Complete function and method documentation for the BLACKX UI Framework.

## Table of Contents

1. [Main Module](#main-module)
2. [Window](#window)
3. [Tab](#tab)
4. [Components](#components)
5. [Services](#services)

---

## Main Module

### Entry Point: `init.lua`

#### `BLACKX:CreateWindow(config) → Window`

Creates and returns a new Window instance.

**Parameters:**
```lua
config = {
    Title = "Script Name",      -- string (optional, default: "BLACKX")
    Logo = "rbxassetid://..."   -- string (optional, image asset ID)
}
```

**Returns:**
- `Window` instance

**Example:**
```lua
local BLACKX = require(script.Parent.src.init)
local window = BLACKX:CreateWindow({
    Title = "My Script",
    Logo = "rbxassetid://13046281618"
})
```

#### `BLACKX:ExecuteCommand(command) → boolean`

Executes a whitelisted command via Infinite Yield bridge.

**Parameters:**
- `command` (string) - Command string, optionally prefixed with ";"

**Returns:**
- `boolean` - true if command executed, false if rejected by whitelist

**Whitelisted Commands:**
- `speed <number>` - Set player walkspeed
- `jump` - Make player jump
- `fly` - Toggle flight mode
- `noclip` - Toggle noclip mode
- `hop server` - Join a different server

**Example:**
```lua
BLACKX:ExecuteCommand("Speed 50")
BLACKX:ExecuteCommand(";jump")  -- Semicolon optional
```

#### `BLACKX:AddLog(message, type) → nil`

Adds a colored log message to the console.

**Parameters:**
- `message` (string) - Log message text
- `type` (string, optional) - Log type: "info" | "success" | "warning" | "system"
  - Default: "info"
  - Colors: info (white), success (green), warning (yellow), system (gray)

**Returns:** nil

**Example:**
```lua
BLACKX:AddLog("Script started", "success")
BLACKX:AddLog("Waiting for input...", "info")
BLACKX:AddLog("Command failed!", "warning")
```

---

## Window

### Window Methods

#### `window:CreateTab(name) → Tab`

Creates a new tab in the window with the given name.

**Parameters:**
- `name` (string) - Tab display name

**Returns:**
- `Tab` instance

**Example:**
```lua
local homeTab = window:CreateTab("Início")
local settingsTab = window:CreateTab("Configurações")
```

#### `window:Destroy() → nil`

Closes the window and removes it from the screen.

**Returns:** nil

**Example:**
```lua
window:Destroy()
```

### Window Properties

- `window.ScreenGui` - The main ScreenGui instance
- `window.Tabs` - Array of Tab objects
- `window.Console` - Console instance
- `window.CommandBar` - TextBox for command input
- `window.FunctionsContainer` - ScrollingFrame for components
- `window.LeftColumn` - Left navigation panel Frame
- `window.CenterColumn` - Center console Frame
- `window.RightColumn` - Right explorer/properties Frame

---

## Tab

### Tab Methods

#### `tab:CreateButton(config) → Button`

Creates a button in the tab.

**Parameters:**
```lua
config = {
    Name = "Button Name",           -- string
    Callback = function() end       -- function (optional)
}
```

**Returns:** Button instance

#### `tab:CreateToggle(config) → Toggle`

Creates a toggle switch in the tab.

**Parameters:**
```lua
config = {
    Name = "Toggle Name",
    Default = false,                -- boolean (optional, default: false)
    Callback = function(value) end  -- function (optional)
}
```

**Returns:** Toggle instance

#### `tab:CreateSlider(config) → Slider`

Creates a numeric slider in the tab.

**Parameters:**
```lua
config = {
    Name = "Slider Name",
    Min = 0,                        -- number
    Max = 100,                      -- number
    Default = 50,                   -- number (optional)
    Callback = function(value) end  -- function (optional)
}
```

**Returns:** Slider instance

#### `tab:CreateTextBox(config) → TextBox`

Creates a text input box in the tab.

**Parameters:**
```lua
config = {
    Name = "Input Name",
    Placeholder = "Enter text...",  -- string (optional)
    OnSubmit = function(text) end   -- function (optional)
}
```

**Returns:** TextBox instance

#### `tab:CreateSection(name) → Section`

Creates a labeled container for organizing components.

**Parameters:**
- `name` (string) - Section title

**Returns:** Section instance

#### `tab:Show() → nil`

Shows this tab and hides others.

#### `tab:Hide() → nil`

Hides this tab.

### Tab Properties

- `tab.Window` - Parent Window instance
- `tab.Name` - Tab name string
- `tab.FunctionsFrame` - Frame containing components

---

## Components

All components follow the same pattern:

```lua
local component = tab:CreateButton({Name = "Test"})

-- Set value (type-specific)
component:Set(newValue)

-- Get current value
local value = component:Get()

-- Remove from UI
component:Destroy()
```

### Button

#### Properties
- `config.Name` (string) - Display name
- `config.Callback` (function) - Called on click

#### Methods
```lua
button:Set(name)              -- Update display name
button:Get() → string         -- Get display name
button:Destroy()              -- Remove button
```

#### Example
```lua
local btn = tab:CreateButton({
    Name = "Teleport",
    Callback = function()
        BLACKX:AddLog("Teleporting...", "info")
    end
})
```

### Toggle

#### Properties
- `config.Name` (string) - Display name
- `config.Default` (boolean) - Initial state
- `config.Callback` (function) - Called with boolean on change

#### Methods
```lua
toggle:Set(value)             -- Set to true/false
toggle:Get() → boolean        -- Get current state
toggle:Destroy()              -- Remove toggle
```

#### Example
```lua
local godmode = tab:CreateToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(enabled)
        if enabled then
            BLACKX:AddLog("God Mode: ON", "success")
        else
            BLACKX:AddLog("God Mode: OFF", "info")
        end
    end
})
```

### Slider

#### Properties
- `config.Name` (string) - Display name
- `config.Min` (number) - Minimum value
- `config.Max` (number) - Maximum value
- `config.Default` (number) - Starting value
- `config.Callback` (function) - Called with number on change

#### Methods
```lua
slider:Set(value)             -- Set numeric value
slider:Get() → number         -- Get current value
slider:Destroy()              -- Remove slider
```

#### Example
```lua
local speedSlider = tab:CreateSlider({
    Name = "Movement Speed",
    Min = 0,
    Max = 200,
    Default = 16,
    Callback = function(value)
        BLACKX:ExecuteCommand("Speed " .. value)
    end
})
```

### TextBox

#### Properties
- `config.Name` (string) - Display name
- `config.Placeholder` (string) - Hint text
- `config.OnSubmit` (function) - Called with text on Enter key

#### Methods
```lua
textbox:Set(text)             -- Set text content
textbox:Get() → string        -- Get text content
textbox:Destroy()             -- Remove textbox
```

#### Example
```lua
local serverInput = tab:CreateTextBox({
    Name = "Server ID",
    Placeholder = "Enter server ID...",
    OnSubmit = function(text)
        BLACKX:AddLog("Joining server: " .. text, "info")
    end
})
```

### Section

#### Properties
- `name` (string) - Section title

#### Methods
```lua
section:CreateButton(config)  -- Create button in this section
section:CreateToggle(config)  -- Create toggle in this section
section:Destroy()             -- Remove section and contents
```

#### Example
```lua
local movementSection = tab:CreateSection("Combat")
local jumpBtn = movementSection:CreateButton({
    Name = "Jump",
    Callback = function()
        BLACKX:ExecuteCommand("jump")
    end
})
```

---

## Services

### LogManager

**Singleton service managing logs and notifications.**

#### Methods

```lua
LogManager:AddLog(message, type)
-- Parameters:
--   message: string
--   type: "info" | "success" | "warning" | "system"

LogManager:GetRecent(count) → table
-- Returns array of most recent logs
-- Parameters: count (number, optional, default: 10)

LogManager.LogAdded:Connect(function(log)
    -- log = {message = "...", type = "...", timestamp = time()}
end)
```

### CommandHandler

**Singleton parsing and validating commands.**

#### Methods

```lua
CommandHandler:Execute(command) → boolean
-- Parses command, checks whitelist, delegates to InfiniteAdapter
-- Returns: true if executed, false if rejected
```

#### Whitelist

Commands must match (case-insensitive):
- `speed <number>`
- `jump`
- `fly`
- `noclip`
- `hop server`

Unrecognized commands are silently rejected.

### InfiniteAdapter

**Bridge to Infinite Yield's `execCmd` global function.**

#### Methods

```lua
InfiniteAdapter:Execute(command) → boolean
-- Safely executes whitelisted command via pcall
-- Parameters: command (string, without ";")
```

#### Integration

Requires `_G.execCmd` function to be available (from Infinite Yield).

### ServerEventAdapter

**Wrapper for RemoteEvent/RemoteFunction communications.**

#### Methods

```lua
ServerEventAdapter:Connect(remote, callback)
-- Connect to RemoteEvent signal
-- Parameters:
--   remote: RemoteEvent instance
--   callback: function(args...)

ServerEventAdapter:Invoke(remote, ...) → any
-- Invoke RemoteFunction
-- Parameters:
--   remote: RemoteFunction instance
--   ...: arguments to pass
```

---

## Color Palette (Theme)

Customize colors in [Theme.lua](../src/Theme.lua):

```lua
Theme.Colors = {
    TopBar = Color3.fromRGB(25, 25, 25),
    Button = Color3.fromRGB(50, 50, 50),
    ButtonHover = Color3.fromRGB(60, 60, 60),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    PremiumText = Color3.fromRGB(255, 200, 100),
    InfoLog = Color3.fromRGB(255, 255, 255),
    SuccessLog = Color3.fromRGB(100, 255, 100),
    WarningLog = Color3.fromRGB(255, 255, 100),
    SystemLog = Color3.fromRGB(150, 150, 150)
}
```

---

## Error Handling

All functions use `pcall` internally for safety. Script execution errors are logged:

```lua
BLACKX:AddLog("Error: Command failed", "warning")
```

---

## Complete Example

```lua
local BLACKX = require(game.ServerScriptService:WaitForChild("BLACKX").src.init)

local window = BLACKX:CreateWindow({
    Title = "Combat Scripts",
    Logo = "rbxassetid://13046281618"
})

local combatTab = window:CreateTab("Combat")
local combatSection = combatTab:CreateSection("Abilities")

combatSection:CreateButton({
    Name = "Speed Boost",
    Callback = function()
        BLACKX:ExecuteCommand("Speed 100")
        BLACKX:AddLog("Speed boosted!", "success")
    end
})

combatSection:CreateSlider({
    Name = "Damage Multiplier",
    Min = 1,
    Max = 10,
    Default = 1,
    Callback = function(value)
        BLACKX:AddLog("Damage set to " .. value .. "x", "info")
    end
})

BLACKX:AddLog("Combat scripts loaded!", "success")
```

---

See [Architecture.md](../docs/Architecture.md) for system design and module relationships.
