local composer = require "composer"

local scene = composer.newScene()

local function criarBotaoLarge()
    local largura = 388
    local altura = 62
    local botao = display.newRoundedRect(0, 0, largura, altura, 12)

    botao:setFillColor(0.459, 0.4, 0.263)

    local textoBotao = display.newText({
        text = "Voltar ao início",
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
    local objects = self.view

    local title = display.newText({
        text = "CONTRACAPA",
        x = CONSTANTS.width / 2,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32
    })

    local largeButton = criarBotaoLarge()
    largeButton.y = CONSTANTS.height - 100
    largeButton.x = CONSTANTS.width / 2

    local previousButton = display.newImage(
        "previous.png",
        60,
        CONSTANTS.height - 75
    )

    previousButton:addEventListener("tap", function()
        composer.gotoScene("pagina5", "fade")
    end)

    local function onLargeButtonTap(event)
        composer.gotoScene("capa", "fade")
    end

    largeButton:addEventListener("tap", onLargeButtonTap)

    objects:insert(title)
    objects:insert(previousButton)
    objects:insert(largeButton)
end

scene:addEventListener("create", scene)

return scene
