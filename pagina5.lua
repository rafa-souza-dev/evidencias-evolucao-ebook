local composer = require "composer"

local scene = composer.newScene()

function scene:create(event)
    local title = display.newText({
        text = "Página 5",
        x = CONSTANTS.width / 2,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32
    })

    local objects = self.view

    objects:insert(title)
end

function scene:show(event)
    local currentScene = composer.getSceneName("current")

    renderPreviousButton(currentScene)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)

return scene
