# BLACKX

Professional modular Roblox Lua UI framework with integrated command execution, logging, and DEX integration.

## Features

- **Modular Components**: Button, Toggle, Slider, TextBox, Tab, Section
- **Three-Column Layout**: Navigation, console, explorer/properties panel
- **Whitelist Command System**: Secure Infinite Yield bridge
- **Event-Driven Logging**: Color-coded console output
- **DEX Integration**: Built-in Explorer and Properties
- **Clean Architecture**: Core → Components → Services separation

## Quick Start

```lua
-- Load Infinite Yield first
local iy = loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
wait(0.5)

-- Load BLACKX
local BLACKX = require(script.BLACKX.src.init)

-- Create window
local window = BLACKX:CreateWindow({Title = "My Script"})

-- Create tab and add components
local tab = window:CreateTab("Home")
tab:CreateButton({
    Name = "Speed",
    Callback = function()
        BLACKX:ExecuteCommand("Speed 50")
    end
})

BLACKX:AddLog("Ready!", "success")
```

## Installation

1. Copy folder to your script directory
2. Require: `local BLACKX = require(script.BLACKX.src.init)`
3. Use: See [examples/example_usage.lua](examples/example_usage.lua)

## API

### Main Module

```lua
window = BLACKX:CreateWindow(config)        -- Create window
tab = window:CreateTab(name)                -- Create tab
BLACKX:ExecuteCommand(command)              -- Execute whitelisted command
BLACKX:AddLog(message, type)                -- Log message
```

### Components

```lua
component = tab:CreateButton(config)
component = tab:CreateToggle(config)
component = tab:CreateSlider(config)
component = tab:CreateTextBox(config)
component = tab:CreateSection(name)

-- All components
component:Set(value)    -- Update
value = component:Get() -- Read
component:Destroy()     -- Cleanup
```

### Whitelisted Commands

- `Speed <number>` - Set walkspeed
- `Jump` - Jump
- `Fly` - Toggle flight
- `Noclip` - Toggle noclip
- `Hop Server` - Change server

## Project Structure

```
src/
├── init.lua           # Entry point
├── Theme.lua          # Colors
├── Assets.lua         # Icons
├── Core/              # System (7 modules)
├── Components/        # UI (6 modules)
└── Services/          # Logic (3 modules)
```

## Documentation

- **[API.md](docs/API.md)** - Function reference
- **[Architecture.md](docs/Architecture.md)** - System design
- **[Integration.md](docs/Integration.md)** - DEX/IY setup

## Requirements

- Infinite Yield (for command execution)
- DEX (optional, for explorer/properties)

## License

MIT License - See [LICENSE](LICENSE)

## Changelog

See [CHANGELOG.md](CHANGELOG.md)

---

Built for Roblox developers. Version 1.1.0 - Refactored for production quality.
