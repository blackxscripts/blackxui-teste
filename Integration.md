# BLACKX Integration Guide

How to integrate BLACKX with DEX and Infinite Yield, plus setup instructions for your script.

## Table of Contents

1. [System Requirements](#system-requirements)
2. [DEX Integration](#dex-integration)
3. [Infinite Yield Integration](#infinite-yield-integration)
4. [Setup Steps](#setup-steps)
5. [Troubleshooting](#troubleshooting)

---

## System Requirements

- **Roblox Game**: Any exploitable game (development environment)
- **Executor**: Must support Lua scripting (Synapse X, Krnl, Fluxus, etc.)
- **Dependencies Required**:
  - DEX Explorer (for right panel)
  - Infinite Yield (for command execution)
- **Lua Version**: Lua 5.1+ (standard Roblox)

---

## DEX Integration

### What is DEX?

DEX (Domain Explorer) is a popular Roblox object explorer that allows you to:
- Browse game hierarchy (Workspace, Players, etc.)
- Inspect instance properties
- Modify values in real-time
- Search for objects

BLACKX integrates DEX components into the right panel of its interface.

### DEX Files

BLACKX expects DEX modules in accessible locations:

**Files Required:**
- `Explorer.lua` - Displays game hierarchy tree
- `Properties.lua` - Shows and edits instance properties

**Expected Locations:**
```
Option 1: ReplicatedStorage
  game:GetService("ReplicatedStorage"):FindFirstChild("Explorer")
  game:GetService("ReplicatedStorage"):FindFirstChild("Properties")

Option 2: Script parent directory
  script.Parent:FindFirstChild("Explorer")
  script.Parent:FindFirstChild("Properties")
```

### Setting Up DEX

**Step 1: Obtain DEX modules**

Download DEX from the Roblox community (available on GitHub). The package includes:
```
DEX/
├── Explorer.lua
├── Properties.lua
├── Lib.lua
└── main.lua
```

**Step 2: Place in your project**

Copy DEX modules to ReplicatedStorage or your script directory:

```lua
-- Option A: ReplicatedStorage method (recommended)
-- Place DEX files in ReplicatedStorage
local Explorer = game:GetService("ReplicatedStorage"):WaitForChild("Explorer")

-- Option B: Local directory method
-- Keep in your script folder alongside BLACKX
local Explorer = script:WaitForChild("DEX"):WaitForChild("Explorer")
```

**Step 3: Load via BLACKX**

BLACKX automatically integrates available DEX modules:

```lua
local BLACKX = require(script.Parent.src.init)
local window = BLACKX:CreateWindow({Title = "My Script"})

-- RightPanel module in src/Core/RightPanel.lua handles this:
-- - Searches for DEX modules
-- - Creates 50/50 split layout
-- - Initializes Explorer and Properties
```

### How BLACKX Uses DEX

The `src/Core/RightPanel.lua` module:

1. **Search Pattern**: Looks for DEX modules using `requireModule()` helper
2. **Layout**: Creates 50% Explorer, 50% Properties vertical split
3. **Integration**: Calls `IntegrateExplorer()` and `IntegrateProperties()`
4. **Persistence**: Keeps DEX visible even when switching tabs

**RightPanel Data Flow:**
```
RightPanel.new(rightFrame)
  │
  ├─ Load Explorer.lua from storage
  │   └─ IntegrateExplorer()
  │       └─ Create ExplorerFrame (50% height)
  │           └─ Initialize Explorer tree view
  │
  ├─ Load Properties.lua from storage
  │   └─ IntegrateProperties()
  │       └─ Create PropertiesFrame (50% height)
  │           └─ Initialize Properties editor
  │
  └─ Parent both to right column (persistent, always visible)
```

### Accessing DEX from Script

While using BLACKX, you can reference DEX modules:

```lua
-- From BLACKX window
local window = BLACKX:CreateWindow()
local rightPanel = window.RightPanel
-- rightPanel.ExplorerFrame and rightPanel.PropertiesFrame are now loaded

-- Manual DEX access without BLACKX
local function getExplorer()
    local location = game:GetService("ReplicatedStorage"):FindFirstChild("Explorer")
    if not location then
        location = script.Parent:FindFirstChild("Explorer")
    end
    return location
end
```

---

## Infinite Yield Integration

### What is Infinite Yield?

Infinite Yield is a command executor that provides:
- Command parsing and whitelist system
- Built-in commands (speed, jump, fly, noclip, etc.)
- Chat-based command interface
- Game state modification

BLACKX provides a **whitelisted bridge** to Infinite Yield's command system.

### Setup Requirements

**Step 1: Load Infinite Yield**

Run Infinite Yield in your game first:

```lua
-- Typical Infinite Yield loader
local iy = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
```

This creates the global function `_G.execCmd`.

**Step 2: Verify `execCmd` is available**

Test that Infinite Yield loaded:

```lua
if _G.execCmd then
    print("Infinite Yield loaded successfully")
else
    print("ERROR: execCmd not found. Load Infinite Yield first!")
end
```

**Step 3: Load BLACKX after Infinite Yield**

```lua
-- Load Infinite Yield first
local iy = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

-- Then load BLACKX
local BLACKX = require(script.Parent.src.init)

-- Now commands are available via BLACKX
BLACKX:ExecuteCommand("Speed 50")
```

### How BLACKX Uses Infinite Yield

The `src/Services/InfiniteAdapter.lua` module:

1. **Whitelist Enforcement**: Only allows specific commands
2. **Command Parsing**: Handles "Speed X" with special message formatting
3. **Safe Execution**: Wraps execCmd in pcall for error safety
4. **Execution Flow**:

```
BLACKX:ExecuteCommand("Speed 50")
  │
  ├─ CommandHandler:Execute("Speed 50")
  │   ├─ Parse: command="speed", args={"50"}
  │   ├─ Check whitelist: "speed" in allowlist? YES
  │   │
  │   └─ InfiniteAdapter:Execute("Speed 50")
  │       ├─ pcall to safely call _G.execCmd
  │       ├─ Log special message for speed
  │       │   "(PlayerName) ganhou 50 de velocidade por BLACK X SCRIPTS"
  │       └─ Return success
  │
  └─ Console logs result (green for success)
```

### Whitelisted Commands

Only these commands are allowed through BLACKX:

```
1. speed <number>     - Set player walkspeed
2. jump               - Make player jump
3. fly                - Toggle flight mode
4. noclip             - Toggle noclip mode
5. hop server         - Join a different server
```

### Enabling Additional Commands

To add more whitelisted commands, edit `src/Services/InfiniteAdapter.lua`:

```lua
-- Current whitelist
local AllowedCommands = {
    "speed",
    "jump",
    "fly",
    "noclip",
    "hop server"
}

-- Add "teleport" for example:
table.insert(AllowedCommands, "teleport")
```

Then use:
```lua
BLACKX:ExecuteCommand("teleport 0 10 0")
```

### Handling Command Failures

Commands that fail in Infinite Yield will be silently ignored:

```lua
-- This command doesn't exist in Infinite Yield
BLACKX:ExecuteCommand("invalid_command")
-- No error shown, no log entry (silent rejection)

-- Use logging to debug
BLACKX:AddLog("Attempting speed boost...", "info")
BLACKX:ExecuteCommand("Speed 100")
BLACKX:AddLog("Speed boost applied", "success")
```

---

## Setup Steps

### Complete Setup Process

#### Step 1: Prepare File Structure

```
Your Script Folder/
├── main.lua (your main script)
├── BLACKX/ (copy this entire folder)
│   ├── src/
│   ├── docs/
│   ├── examples/
│   ├── README.md
│   └── ...
└── DEX/ (optional, copy if needed)
    ├── Explorer.lua
    ├── Properties.lua
    └── ...
```

#### Step 2: Load Infinite Yield First

```lua
-- At the very top of your script
local iy = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

-- Wait a moment for initialization
wait(0.5)

-- Verify it loaded
if not _G.execCmd then
    warn("Infinite Yield failed to load!")
    return
end
```

#### Step 3: Load BLACKX

```lua
-- After Infinite Yield is loaded
local BLACKX = require(script:WaitForChild("BLACKX"):WaitForChild("src"):WaitForChild("init"))
```

#### Step 4: Create Window and Tabs

```lua
-- Create main window
local window = BLACKX:CreateWindow({
    Title = "My Awesome Script",
    Logo = "rbxassetid://13046281618"  -- optional
})

-- Create tab
local combatTab = window:CreateTab("Combat")

-- Add components
combatTab:CreateButton({
    Name = "Speed Boost",
    Callback = function()
        BLACKX:ExecuteCommand("Speed 100")
    end
})

BLACKX:AddLog("Script ready!", "success")
```

#### Complete Example Script

```lua
-- Load Infinite Yield
local success, error = pcall(function()
    local iy = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

if not success then
    warn("Failed to load Infinite Yield:", error)
    return
end

wait(0.5)

-- Load BLACKX
local BLACKX = require(script:WaitForChild("BLACKX"):WaitForChild("src"):WaitForChild("init"))

-- Create window
local window = BLACKX:CreateWindow({
    Title = "Combat Scripts v1.0",
    Logo = "rbxassetid://13046281618"
})

-- Combat Tab
local combatTab = window:CreateTab("Combat")
local combatSection = combatTab:CreateSection("Movement")

combatSection:CreateButton({
    Name = "Speed",
    Callback = function()
        BLACKX:ExecuteCommand("Speed 100")
        BLACKX:AddLog("Speed: 100", "success")
    end
})

combatSection:CreateSlider({
    Name = "Damage",
    Min = 1,
    Max = 10,
    Default = 1,
    Callback = function(value)
        BLACKX:AddLog("Damage: " .. value .. "x", "info")
    end
})

-- Settings Tab
local settingsTab = window:CreateTab("Configurações")

settingsTab:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(enabled)
        if enabled then
            BLACKX:AddLog("Auto Farm enabled", "success")
        else
            BLACKX:AddLog("Auto Farm disabled", "info")
        end
    end
})

-- Log startup
BLACKX:AddLog("Combat Scripts loaded!", "success")
BLACKX:AddLog("Ready for action", "system")
```

---

## Troubleshooting

### Issue 1: Command Not Executing

**Problem:** You run a command but nothing happens

**Solution:**
1. Check Infinite Yield loaded: `print(_G.execCmd)`
2. Verify command is whitelisted:
   ```lua
   BLACKX:ExecuteCommand("Speed 50")  -- Should work
   BLACKX:ExecuteCommand("KillAll")   -- Will fail silently
   ```
3. Check console for errors
4. Try manual execution: `_G.execCmd("Speed 50")`

### Issue 2: DEX Not Showing in Right Panel

**Problem:** Right panel is empty or shows error

**Solution:**
1. Verify DEX files exist and are accessible
2. Check file locations (ReplicatedStorage or script.Parent)
3. Load DEX manually first:
   ```lua
   local Explorer = require(game:GetService("ReplicatedStorage"):WaitForChild("Explorer"))
   ```
4. Check for require() errors in console

### Issue 3: Logo Not Displaying

**Problem:** Logo image doesn't appear in top bar

**Solution:**
1. Verify asset ID is correct: `rbxassetid://YOUR_ID`
2. Test image separately:
   ```lua
   local label = Instance.new("ImageLabel")
   label.Image = "rbxassetid://YOUR_ID"
   label.Parent = workspace
   ```
3. Use default: don't pass Logo parameter
4. Check if image is public (asset permissions)

### Issue 4: Script Crashes on Load

**Problem:** Script throws error and stops

**Solution:**
1. **Check load order:**
   - Infinite Yield must load FIRST
   - BLACKX loads SECOND
   ```lua
   -- WRONG:
   local BLACKX = require(...)
   local iy = loadstring(...)  -- Too late!
   
   -- RIGHT:
   local iy = loadstring(...)  -- First
   wait(0.5)
   local BLACKX = require(...)  -- Second
   ```

2. **Check file paths:**
   ```lua
   -- Verify script location
   print(script:GetFullName())
   print(script:FindFirstChild("BLACKX"):GetFullName())
   ```

3. **Enable debugging:**
   ```lua
   local BLACKX = require(script:WaitForChild("BLACKX"))
   print("BLACKX loaded:", BLACKX ~= nil)
   ```

### Issue 5: Commands Execute but Don't Work In-Game

**Problem:** Command runs without error but nothing happens (e.g., Speed doesn't increase)

**Solution:**
1. Infinite Yield command might require setup (e.g., character loaded)
2. Check player is in game and loaded:
   ```lua
   local player = game:GetService("Players").LocalPlayer
   if not player.Character then
       print("Character not loaded!")
       return
   end
   ```
3. Test Infinite Yield command directly:
   ```lua
   _G.execCmd("Speed 50")  -- Does this work standalone?
   ```
4. Check player has humanoid:
   ```lua
   local humanoid = player.Character:FindFirstChild("Humanoid")
   print("Humanoid:", humanoid)
   ```

### Issue 6: Console Shows Error Messages

**Problem:** Console displays red/yellow warnings

**Solution:**
1. Read the error message carefully
2. Common issues:
   - `Infinite Yield not loaded` → Load IY first
   - `Explorer not found` → DEX files missing
   - `nil value` → Missing require() or wrong path
3. Add logging to trace issues:
   ```lua
   BLACKX:AddLog("Debug: Starting command", "system")
   BLACKX:ExecuteCommand("Speed 50")
   BLACKX:AddLog("Debug: Command complete", "system")
   ```

---

## Performance Tips

1. **Lazy Load DEX**: Only integrate if user needs Explorer
2. **Limit Console Logs**: Don't spam AddLog (max 200 stored anyway)
3. **Destroy Unused Tabs**: Clean up memory-heavy tabs
4. **Use Sections**: Organize components to reduce visual clutter

---

## Security Notes

- BLACKX runs in user script context (equivalent to what executor allows)
- No special security measures beyond Infinite Yield's whitelist
- Command whitelist prevents unauthorized access to dangerous functions
- All executions wrapped in pcall for safety

---

See [API.md](./API.md) for function reference and [Architecture.md](./Architecture.md) for system design.
