function corDecimal(cor)
    return cor / 255
end

display.setDefault("background", corDecimal(145), corDecimal(135), corDecimal(111))
display.setStatusBar(display.HiddenStatusBar)

local composer = require "composer"

CONSTANTS = {
    width=768,
    height=1024
}

local soundMuted = display.newImage("sound-muted.png")
soundMuted.y = 56
soundMuted.x = CONSTANTS.width - 56

local meuBotao = display.newRoundedRect(0, 0, 87, 24, 12)
meuBotao:setFillColor(0.459, 0.4, 0.263)
meuBotao.x = soundMuted.x
meuBotao.y = soundMuted.y + 50

local textoBotao = display.newText({
    text = "Tocar do início",
    x = meuBotao.x,
    y = meuBotao.y,
    font = native.systemFontBold,
    fontSize = 11
})

local grupoBotao = display.newGroup()
grupoBotao:insert(meuBotao)
grupoBotao:insert(textoBotao)

grupoBotao:toFront()
soundMuted:toFront()

composer.gotoScene("capa", "fade")
