local composer = require "composer"

local scene = composer.newScene(  )

local function criarBotaoLarge()
    local largura = 388
    local altura = 62
    local botao = display.newRoundedRect(0, 0, largura, altura, 12)

    botao:setFillColor(0.459, 0.4, 0.263)

    local textoBotao = display.newText({
        text = "Próxima página",
        x = botao.x,
        y = botao.y,
        font = native.systemFontBold,
        fontSize = 24
    })

    local grupoBotao = display.newGroup()
    grupoBotao:insert(botao)
    grupoBotao:insert(textoBotao)

    return grupoBotao
end

function scene:create(event)
    local capa = display.newImage( "capa.png" )
    capa.y = CONSTANTS.height / 3
    capa.x = CONSTANTS.width / 2

    local largeButton = criarBotaoLarge()
    largeButton.y = CONSTANTS.height - 100
    largeButton.x = CONSTANTS.width / 2

    local title = display.newText({
        text = "Evidências da evolução, especiação, tempo geológico e paleontológico.",
        x = CONSTANTS.width / 2 - 110,
        y = capa.y + capa.height / 2 + 60,
        width = 504,
        font = native.systemFontBold,
        fontSize = 32,
        align = "left"
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

    local function onLargeButtonTap(event)
        print("Botão clicado!")
        composer.gotoScene("pagina2", "fade")
    end

    largeButton:addEventListener("tap", onLargeButtonTap)

    local objects = self.view

    objects:insert(capa)
    objects:insert(title)
    objects:insert(description)
    objects:insert(largeButton)
end

scene:addEventListener("create", scene)

return scene
