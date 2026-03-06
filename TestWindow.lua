-- Example usage of BlackX UI Library
-- Place this script in StarterPlayerScripts (LocalScript) for testing.

local BlackX = require(game:GetService("ReplicatedStorage").BlackX)

local Window = BlackX:CreateWindow({ Name = "BLACK X CLICKER HUB" })
local Tab = BlackX:CreateTab(Window, "Main")

Tab:CreateButton({
    Name = "Test Button",
    Text = "Clique aqui",
    Callback = function()
        print("BLACK X funcionando no GitHub!")
    end,
})

Tab:CreateToggle({
    Name = "Test Toggle",
    Text = "Ativar",
    Default = false,
    Callback = function(value)
        print("Toggle está", value and "ativado" or "desativado")
    end,
})
