local composer = require "composer"

local scene = composer.newScene()

function scene:create(event)
    local title = display.newText({
        text = "Título da Página 2", -- Adicione um título aqui
        x = CONSTANTS.width / 2,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32
    })

    local description = display.newText({
        text = "Autor: Rafael José Gomes de Souza\nAno e Semestre: 2024.2",
        x = CONSTANTS.width / 2 - 110,
        y = title.y + 90,
        width = 504,
        font = native.systemFontRegular,
        fontSize = 24,
        align = "left"
    })

    local objects = self.view

    objects:insert(title)
    objects:insert(description)
end

scene:addEventListener("create", scene)

return scene
