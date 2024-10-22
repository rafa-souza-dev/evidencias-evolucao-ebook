local composer = require "composer"

local scene = composer.newScene()

function scene:create(event)
    local objects = self.view

    local title = display.newText({
        text = "CONTRACAPA",
        x = CONSTANTS.width / 2,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32
    })

    local previousButton = display.newImage(
        "previous.png",
        60,
        CONSTANTS.height - 75
    )

    previousButton:addEventListener("tap", function()
        composer.gotoScene("pagina5")
    end)

    objects:insert(title)
    objects:insert(previousButton)
end

scene:addEventListener("create", scene)

return scene
