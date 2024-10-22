local composer = require "composer"

local scene = composer.newScene()

function scene:create(event)
    local title = display.newText({
        text = "Contracapa",
        x = CONSTANTS.width / 2,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32
    })

    local objects = self.view

    objects:insert(title)
end

scene:addEventListener("create", scene)

return scene
