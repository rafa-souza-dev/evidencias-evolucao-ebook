local composer = require "composer"

local scene = composer.newScene()

function scene:create(event)
    local objects = self.view

    local title = display.newText({
        text = "Página 4",
        x = CONSTANTS.width / 2,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32
    })

    local nextButton = display.newImage(
        "next.png",
        CONSTANTS.width - 60,
        CONSTANTS.height - 75
    )

    local previousButton = display.newImage(
        "previous.png",
        60,
        CONSTANTS.height - 75
    )

    nextButton:addEventListener("tap", function()
        composer.gotoScene("pagina5")
    end)

    previousButton:addEventListener("tap", function()
        composer.gotoScene("pagina3")
    end)

    objects:insert(title)
    objects:insert(nextButton)
    objects:insert(previousButton)
end

scene:addEventListener("create", scene)

return scene
