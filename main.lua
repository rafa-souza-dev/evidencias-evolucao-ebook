local composer = require "composer"

function corDecimal(cor)
    return cor / 255
end

local scenePreviousNavigation = {
    ["capa"] = nil,
    ["pagina2"] = "capa",
    ["pagina3"] = "pagina2",
    ["pagina4"] = "pagina3",
    ["pagina5"] = "pagina4",
    ["contracapa"] = "pagina5"
}

function renderPreviousButton(currentScene)
    local previousScene = scenePreviousNavigation[currentScene]

    if previousScene == nil then
        if PREVIOUS_BUTTON then
            PREVIOUS_BUTTON.isVisible = false
        end
        return
    end

    if not PREVIOUS_BUTTON then
        PREVIOUS_BUTTON = display.newImage(
            "previous.png",
            50,
            CONSTANTS.height - 75
        )
    end

    PREVIOUS_BUTTON.isVisible = true

    local function goToScene(event)
        if event.phase == "ended" or event.phase == "cancelled" then
            composer.gotoScene(previousScene)
            return true
        end
    end

    PREVIOUS_BUTTON:removeEventListener("touch", goToScene)
    PREVIOUS_BUTTON:addEventListener("touch", goToScene)
end

display.setDefault("background", corDecimal(145), corDecimal(135), corDecimal(111))
display.setStatusBar(display.HiddenStatusBar)

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
