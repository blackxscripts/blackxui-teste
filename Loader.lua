-- Loader da BlackX
-- Este script demonstra como carregar a UI + scripts dinâmicos via require.

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Requer a library principal (deve estar em ReplicatedStorage/BlackX)
local BlackX = require(ReplicatedStorage:WaitForChild("BlackX"))

-- Cria a janela principal
local Window = BlackX:CreateWindow({
    Name = "BLACK X CLICKER HUB"
})

-- Cria aba principal
local MainTab = BlackX:CreateTab(Window, "Main")

-- Função para carregar scripts dinamicamente por meio de require
local function LoadScript(path, tab)
    local ok, module = pcall(function()
        return require(ReplicatedStorage:WaitForChild(path))
    end)

    if not ok or type(module) ~= "table" then
        warn("BlackX Loader: falha ao carregar módulo", path)
        return
    end

    if type(module.Init) == "function" then
        module.Init(tab)
    end
end

-- Exemplo: carregar módulos dentro de ReplicatedStorage/Scripts/
LoadScript("Scripts/AutoFarm", MainTab)
LoadScript("Scripts/Clicker", MainTab)

-- Botão manual de teste
MainTab:CreateButton({
    Name = "Test Button",
    Callback = function()
        print("BLACK X Loader funcionando!")
    end,
})
