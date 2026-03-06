# BLACKX Architecture

High-level overview of BLACKX's system design, module relationships, and data flow.

## System Overview

BLACKX is built on a **three-layer architecture**:

```
┌─────────────────────────────────────────────────────┐
│           PUBLIC API (init.lua)                      │
│    CreateWindow, ExecuteCommand, AddLog             │
└──────────────────┬──────────────────────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
        ▼                     ▼
   ┌─────────────┐     ┌──────────────┐
   │ CORE LAYER  │     │ SERVICES     │
   │ (System)    │◄────┤ (Logic)      │
   └─────┬───────┘     └──────────────┘
         │
         ▼
   ┌─────────────────────┐
   │ COMPONENTS LAYER    │
   │ (UI Elements)       │
   └─────────────────────┘
```

---

## Layer 1: Core Modules

Core modules handle system operations, UI structure, and event orchestration.

### Window.lua

**Purpose:** Main UI window manager and entry point for UI building.

**Key Responsibilities:**
1. Create ScreenGui and top bar (logo, title, minimize, close buttons)
2. Build three-column layout via Layout helper
3. Initialize tabs container and functions container
4. Set up command bar input field
5. Create console display frame
6. Initialize RightPanel for DEX integration
7. Start EventListener for game state tracking

**Class Structure:**
```lua
Window = {
    Config = {Title, Logo},
    Tabs = {},
    ScreenGui = ScreenGui instance,
    FunctionsContainer = ScrollingFrame,
    CommandBar = TextBox,
    ConsoleFrame = Frame
}

Window:CreateTab(name) → Tab
Window:BuildUI() → nil
```

**Data Flow:**
```
Window.new(config)
  ├─ Create ScreenGui
  ├─ BuildUI()
  │   ├─ Create TopBar (logo, title, buttons)
  │   ├─ Call Layout:CreateColumns(ScreenGui)
  │   │   └─ Returns: left, center, right frames (20/60/20 split)
  │   ├─ Setup left column with TabButtonsFrame, FunctionsContainer
  │   ├─ Setup center with console frame, command bar
  │   └─ Setup right column with RightPanel
  ├─ Create Console on ConsoleFrame
  ├─ Start EventListener
  └─ Return self (Window instance)
```

### Layout.lua

**Purpose:** Helper function creating three-column layout structure.

**Key Responsibilities:**
1. Position and size three frames (left: 20%, center: 60%, right: 20%)
2. Set transparent backgrounds for layout
3. Return frame references for further configuration

**Function:**
```lua
Layout:CreateColumns(parent) → (FrameLeft, FrameCenter, FrameRight)
```

**Layout Proportions:**
```
┌────────────┬──────────────────────┬────────────┐
│   LEFT     │       CENTER         │   RIGHT    │
│   (20%)    │        (60%)         │   (20%)    │
│            │                      │            │
│  Tabs      │  Console + Command   │  Explorer  │
│  Buttons   │  Bar                 │ Properties │
│            │                      │            │
└────────────┴──────────────────────┴────────────┘
     Size: (0.2, 1)    Size: (0.6, 1)    Size: (0.2, 1)
     Pos: (0, 0)       Pos: (0.2, 0)     Pos: (0.8, 0)
```

### Navigation.lua

**Purpose:** Helper creating tab buttons with visual feedback.

**Key Responsibilities:**
1. Create TextButton for each tab
2. Set up appearance (color, text, size)
3. Return configured button instance

**Function:**
```lua
Navigation:CreateTabButton(name, parent, callback) → TextButton
```

### Console.lua

**Purpose:** Display scrollable log output with color coding.

**Key Responsibilities:**
1. Create ScrollingFrame with UIListLayout
2. Subscribe to LogManager.LogAdded event
3. Create TextLabel for each log message with color mapping
4. Auto-scroll to latest messages
5. Maintain optional message history limit

**Class Structure:**
```lua
Console = {
    Frame = Frame instance,
    LogManager = LogManager service reference,
    MaxLogs = 200
}

Console.new(parentFrame) → Console instance
Console:Subscribe() → nil
```

**Color Mapping:**
```lua
Colors = {
    info = Theme.Colors.InfoLog,
    success = Theme.Colors.SuccessLog,
    warning = Theme.Colors.WarningLog,
    system = Theme.Colors.SystemLog
}
```

### CommandHandler.lua

**Purpose:** Parse user input, validate against whitelist, execute commands.

**Key Responsibilities:**
1. Strip ";" prefix from input
2. Parse command and arguments
3. Check against AllowedCommands whitelist
4. Delegate execution to InfiniteAdapter
5. Handle special formatting (e.g., "speed X" message)
6. Silently reject unknown commands

**Whitelist:**
```lua
AllowedCommands = {
    "speed",
    "jump",
    "fly",
    "noclip",
    "hop server"
}
```

**Execution Flow:**
```
User Input ";Speed 50"
  │
  ├─ CommandHandler:Execute(";Speed 50")
  │   ├─ Strip ";" → "Speed 50"
  │   ├─ Parse → {cmd="speed", args={"50"}}
  │   ├─ Check whitelist → ALLOW
  │   ├─ Call InfiniteAdapter:Execute("Speed 50")
  │   │   ├─ pcall(_G.execCmd, ...)
  │   │   └─ Return success
  │   └─ Log message (special format for speed)
  └─ Console displays result
```

### RightPanel.lua

**Purpose:** Manage persistent DEX Explorer and Properties viewer.

**Key Responsibilities:**
1. Load Explorer.lua and Properties.lua from DEX
2. Create 50/50 vertical split layout
3. Initialize both components once on startup
4. Keep visible regardless of tab changes
5. Provide requireModule helper for file location discovery

**Class Structure:**
```lua
RightPanel = {
    Frame = Frame instance,
    ExplorerFrame = Frame (50% height),
    PropertiesFrame = Frame (50% height)
}

RightPanel.new(parentFrame) → RightPanel instance
RightPanel:IntegrateExplorer() → nil
RightPanel:IntegrateProperties() → nil
RightPanel:requireModule(name) → module or nil
```

**Module Search Pattern:**
```
Searches in order:
1. game:GetService("ReplicatedStorage"):FindFirstChild(name)
2. script.Parent.Parent:FindFirstChild(name)
```

### EventListener.lua

**Purpose:** Monitor game state changes and log relevant events.

**Key Responsibilities:**
1. Watch Backpack.ChildAdded for item pickups
2. Watch leaderstats.Changed for stat updates
3. Listen for RemoteEvent invocations
4. Log events without modifying game state
5. Provide troubleshooting information via console

**Events Monitored:**
```lua
1. Backpack:ChildAdded → Log item name
2. leaderstats:DescendantAdded → Log stat changes
3. RemoteEvent invocations → Log with arguments (safe filtering)
```

---

## Layer 2: Component Modules

Components are UI elements with consistent interface.

### Component Pattern (All Components)

Every component follows this OOP structure:

```lua
local Component = {}
Component.__index = Component

function Component.new(config)
    local self = setmetatable({}, Component)
    self.Config = config or {}
    self.Instance = Instance.new("TextButton") -- varies by type
    -- Configure Instance...
    return self
end

function Component:Set(value) -- Set display/value
    -- Implementation varies
end

function Component:Get() -- Get current value
    -- Implementation varies
end

function Component:Destroy() -- Cleanup
    self.Instance:Destroy()
end

return Component
```

### Button.lua

Simple clickable button with callback.

```lua
Button.new({
    Name = "Click Me",
    Callback = function() end
})

-- Methods: Set(name), Get(), Destroy()
```

### Toggle.lua

Checkbox-style boolean toggle.

```lua
Toggle.new({
    Name = "Enable Feature",
    Default = false,
    Callback = function(value) end
})

-- Methods: Set(boolean), Get(), Destroy()
```

### Slider.lua

Numeric range slider with min/max bounds.

```lua
Slider.new({
    Name = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value) end
})

-- Methods: Set(number), Get(), Destroy()
```

### TextBox.lua

Text input field with submit callback.

```lua
TextBox.new({
    Name = "Username",
    Placeholder = "Enter name...",
    OnSubmit = function(text) end
})

-- Methods: Set(text), Get(), Destroy()
```

### Tab.lua

Container for components with visibility toggle.

```lua
Tab.new(parentWindow, name)

-- Methods:
--   Tab:CreateButton(config) → Button
--   Tab:CreateToggle(config) → Toggle
--   Tab:CreateSlider(config) → Slider
--   Tab:CreateTextBox(config) → TextBox
--   Tab:CreateSection(name) → Section
--   Tab:Show() Tab:Hide()
```

Each Tab has a FunctionsFrame (ScrollingFrame) that contains all its components.

### Section.lua

Labeled container for organizing components within a tab.

```lua
Section.new({Name = "Gameplay"})

-- Methods: Same as Tab for component creation
```

---

## Layer 3: Service Modules

Services provide business logic and system integration.

### LogManager.lua

**Centralized logging with history and event dispatch.**

**Key Responsibilities:**
1. Store log entries in array (max 200)
2. Fire BindableEvent on new log
3. Provide log history retrieval
4. Color mapping based on type

**Class Structure:**
```lua
LogManager = {
    Logs = {},
    MaxLogs = 200,
    LogAdded = BindableEvent instance
}

LogManager:AddLog(message, type) → nil
LogManager:GetRecent(count) → table
LogManager.LogAdded:Connect(callback)
```

**Data Structure:**
```lua
log = {
    message = "String content",
    type = "info|success|warning|system",
    timestamp = time()
}
```

**Event Flow:**
```
User action or BLACKX:AddLog()
  │
  ├─ LogManager:AddLog(msg, type)
  │   ├─ Create log table
  │   ├─ Store in Logs array
  │   ├─ Fire LogAdded event
  │   └─ Trim old logs if > 200
  │
  └─ Console subscribes to LogAdded
      └─ Create TextLabel for message
```

### InfiniteAdapter.lua

**Bridge to Infinite Yield command system.**

**Key Responsibilities:**
1. Maintain whitelist of safe commands
2. Validate command before execution
3. Call _G.execCmd safely via pcall
4. Return execution status
5. Provide command formatting (e.g., speed message)

**Whitelist Enforcement:**
```lua
AllowedCommands = {
    "speed",
    "jump",
    "fly",
    "noclip",
    "hop server"
}
```

**Execution Pattern:**
```lua
InfiniteAdapter:Execute("Speed 50")
  ├─ Check if "speed" in AllowedCommands → YES
  ├─ Format message for speed: "(PlayerName) ganhou X de velocidade..."
  ├─ pcall(_G.execCmd, ...) for safety
  ├─ Log formatted message
  └─ Return success boolean
```

### ServerEventAdapter.lua

**Wrapper for RemoteEvent/RemoteFunction communications.**

**Key Responsibilities:**
1. Connect callbacks to RemoteEvents
2. Invoke RemoteFunction methods
3. Wrap operations in pcall for safety
4. Provide transparent interface to client communication

**Methods:**
```lua
ServerEventAdapter:Connect(remote, callback)
ServerEventAdapter:Invoke(remote, ...) → any
```

---

## Data Flow Examples

### Example 1: User Clicks Button

```
User clicks "Speed Boost" button
  │
  ├─ Button.MouseButton1Click fires
  │   └─ Button.Callback() executes
  │       └─ BLACKX:ExecuteCommand("Speed 50")
  │           └─ CommandHandler:Execute("Speed 50")
  │               ├─ Check whitelist → ALLOW
  │               ├─ InfiniteAdapter:Execute("Speed 50")
  │               │   ├─ Format message
  │               │   ├─ pcall execCmd
  │               │   └─ Return true
  │               └─ Log success message
  │
  └─ Console displays: "[SUCCESS] (Player) ganhou 50 de velocidade..."
```

### Example 2: Game Event Occurs

```
Player picks up item
  │
  ├─ Backpack.ChildAdded fires
  │   └─ EventListener catches event
  │       └─ BLACKX:AddLog("Picked up: Item", "info")
  │           └─ LogManager:AddLog("Picked up: Item", "info")
  │               ├─ Store in Logs array
  │               ├─ Fire LogAdded event
  │               └─ Console:Subscribe listens
  │                   └─ Create TextLabel "Picked up: Item"
  │
  └─ Console displays colored log entry
```

### Example 3: Tab Creation and Switching

```
window:CreateTab("Combat")
  │
  ├─ Create Tab instance
  ├─ Create FunctionsFrame (ScrollingFrame)
  ├─ Create TabButton via Navigation helper
  ├─ Wire button click to Tab:Show/Hide
  ├─ Insert tab button into TabButtonsFrame
  └─ Insert tab into window.Tabs array

User clicks "Combat" tab button
  │
  ├─ TabButton.MouseButton1Click fires
  │   └─ Show Combat tab, hide all others
  │       └─ Tab:Show() makes FunctionsFrame visible
  │           └─ All components in tab become visible
  │
  └─ RIGHT PANEL UNCHANGED (independent of tabs)
      └─ Explorer/Properties always visible
```

---

## Module Dependencies

```
init.lua (Entry)
  ├─ Theme.lua
  ├─ Assets.lua
  ├─ Window.lua
  │   ├─ Layout.lua
  │   ├─ Navigation.lua
  │   ├─ RightPanel.lua
  │   │   ├─ Console.lua
  │   │   │   └─ LogManager.lua (Service)
  │   │   └─ DEX modules (Explorer.lua, Properties.lua)
  │   ├─ Console.lua → LogManager.lua
  │   ├─ CommandHandler.lua
  │   │   └─ InfiniteAdapter.lua (Service)
  │   ├─ EventListener.lua
  │   │   └─ LogManager.lua
  │   └─ Tab.lua
  │       ├─ Button.lua
  │       ├─ Toggle.lua
  │       ├─ Slider.lua
  │       ├─ TextBox.lua
  │       └─ Section.lua
  │           └─ (All components)
  └─ Services/
      ├─ LogManager.lua
      ├─ InfiniteAdapter.lua
      └─ ServerEventAdapter.lua
```

---

## Thread Safety

BLACKX uses **synchronous Lua execution** (no coroutines for UI):

- All events handled in main thread
- BindableEvent used for inter-module communication
- Game service events can fire asynchronously, but callbacks are queued safely
- No race conditions expected in typical usage

---

## Extension Points

### Adding a New Component

1. Create `src/Components/MyComponent.lua`
2. Follow Component pattern (new, Set, Get, Destroy)
3. Export module reference
4. Wire Tab to support `Tab:CreateMyComponent(config)`

### Adding a New Service

1. Create `src/Services/MyService.lua`
2. Implement singleton or module functions
3. Include in init.lua exports if public
4. Wire to Core modules that need it

### Custom Theme Colors

Edit `src/Theme.lua` and add colors to `Colors` table.

---

## Performance Considerations

- **Console Logs**: Trimmed to last 200 entries to prevent memory bloat
- **Components**: Destroyed properly to release UI instances
- **Events**: Use `:Connect()` correctly to avoid memory leaks
- **Scrolling Frames**: Use AutomaticCanvasSize for efficient layout

---

See [API.md](./API.md) for function documentation and [Integration.md](./Integration.md) for DEX/Infinite Yield setup.
