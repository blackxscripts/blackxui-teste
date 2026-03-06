# BlackX UI Library

BlackX é uma UI library para Roblox inspirada na Rayfield, com tema preto + neon branco, branding próprio e API modular para fácil expansão.

## Estrutura

```
BlackX/
│
├─ README.md
├─ LICENSE
├─ .gitignore
│
├─ BlackX.lua          -- módulo principal
├─ Theme.lua           -- cores e estilos fixos
├─ Assets.lua          -- logo e imagens
├─ Components/         -- componentes reutilizáveis
│   ├─ Button.lua
│   ├─ Toggle.lua
│   ├─ Slider.lua
│
└─ Examples/
    └─ TestWindow.lua  -- exemplo funcional de uso
```

## Uso (Roblox)

1. Coloque a pasta `BlackX` em `ReplicatedStorage`.
2. Crie um `LocalScript` em `StarterPlayerScripts`.
3. Exemplo mínimo:

```lua
local BlackX = require(game:GetService("ReplicatedStorage").BlackX)

local window = BlackX:CreateWindow({ Name = "Minha UI BlackX" })
local tab = BlackX:CreateTab(window, "Main")

tab:CreateButton({
    Text = "Clique aqui",
    Callback = function()
        print("Botão BlackX clicado!")
    end,
})
```

## API principal

- `BlackX:CreateWindow(config)`
- `BlackX:CreateTab(window, tabName)`
- `BlackX:CreateButton(tab, config)`
- `BlackX:CreateToggle(tab, config)`

## Licença

Veja `LICENSE`.
