local composer = require "composer"
local SoundControl = require "components.SoundControl"

local scene = composer.newScene()
local capaSound = audio.loadSound("audios/pagina3.mp3")
local soundChannel
local isSoundOn = false

local physics = require("physics")
physics.start()

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local man = display.newImageRect("assets/man_with_shovel.png", 199, 269)
man.x = centerX + 220
man.y = centerY + 200
physics.addBody(man, "dynamic", {isSensor = true})
man.gravityScale = 0

local dirt = display.newImageRect("assets/dirt_pile.png", 275, 239)
dirt.x = centerX - 150
dirt.y = centerY + 200
physics.addBody(dirt, "static", {isSensor = true})

local currentAnimation = 0

local function dragMan(event)
    local phase = event.phase

    if phase == "began" then
        display.currentStage:setFocus(man)
        man.touchOffsetX = event.x - man.x
        man.touchOffsetY = event.y - man.y
    elseif phase == "moved" then
        if man.touchOffsetX then
            man.x = event.x - man.touchOffsetX
        end

        if man.touchOffsetY then
            man.y = event.y - man.touchOffsetY
        end
    elseif phase == "ended" or phase == "cancelled" then
        display.currentStage:setFocus(nil)
    end
    return true
end

man:addEventListener("touch", dragMan)

local function onCollision(event)
    if currentAnimation == 0 then
        if event.object1 == man and event.object2 == dirt or
        event.object2 == man and event.object1 == dirt then
            dirt:removeSelf()
            dirt = nil

            timer.performWithDelay(1, function()
                dirt = display.newImageRect("assets/dirt_replaced.png", 291, 96)
                dirt.x = centerX - 150
                dirt.y = centerY + 215
                physics.addBody(dirt, "static", {isSensor = true})

                man:removeSelf()
                man = display.newImageRect("assets/man_with_shovel.png", 199, 269)
                man.x = centerX + 220
                man.y = centerY + 200
                physics.addBody(man, "dynamic", {isSensor = true})
                man.gravityScale = 0

                man:addEventListener("touch", dragMan)

                currentAnimation = currentAnimation + 1
            end)

        end
    end

    if currentAnimation == 1 then
        if event.object1 == man and event.object2 == dirt or
        event.object2 == man and event.object1 == dirt then
            dirt:removeSelf()
            dirt = nil

            timer.performWithDelay(1, function()
                dirt = display.newImageRect("assets/lab.png", 285, 183)
                dirt.x = centerX + 220
                dirt.y = centerY + 200
                physics.addBody(dirt, "static", {isSensor = true})

                man:removeSelf()
                man = display.newImageRect("assets/fossil.png", 212, 237)
                man.x = centerX - 210
                man.y = centerY + 215
                physics.addBody(man, "dynamic", {isSensor = true})
                man.gravityScale = 0

                man:addEventListener("touch", dragMan)

                currentAnimation = currentAnimation + 1
            end)
        end
    end

    if currentAnimation == 2 then
        if event.object1 == man and event.object2 == dirt or
        event.object2 == man and event.object1 == dirt then
            dirt:removeSelf()
            dirt = nil

            timer.performWithDelay(1, function()
                man:removeSelf()
                man = display.newImageRect("assets/final-fossil.png", 673, 237)
                man.x = centerX
                man.y = centerY + 220
            end)
        end
    end
end

Runtime:addEventListener("collision", onCollision)

local function playOrRestartSound()
    if soundChannel and audio.isChannelActive(soundChannel) then
        audio.stop(soundChannel)
    end
    soundChannel = audio.play(capaSound)
end

local function pauseSound()
    if soundChannel and audio.isChannelActive(soundChannel) then
        audio.pause(soundChannel)
    end
end

local function resumeSound()
    if soundChannel and audio.isChannelPaused(soundChannel) then
        audio.resume(soundChannel)
    else
        playOrRestartSound()
    end
end

local soundControlGroup = SoundControl.new({
    isSoundOn = isSoundOn,
    onPressButtonCB = playOrRestartSound,
    pauseSound = pauseSound,
    resumeSound = resumeSound
})

local function resetImages()
    if man then
        pcall(function()
            man:removeSelf()
            man = nil
        end)
    end

    if dirt then
        pcall(function()
            dirt:removeSelf()
            dirt = nil
        end)
    end
end

function scene:create(event)
    local objects = self.view

    local pageNumber = display.newText({
        text = "Página 3",
        x = 50,
        y = 24,
        fontSize = 14,
        font = native.systemFontBold,
    })

    local title = display.newText({
        text = "Evidências da Evolução - Fósseis e Estruturas Homólogas",
        width = 550,
        x = 300,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32,
        align = "left"
    })

    local content = display.newText({
        text = [[
A teoria da evolução não é apenas uma ideia abstrata; ela é suportada por uma enorme quantidade de evidências físicas. Entre as mais poderosas estão os fósseis e as estruturas homólogas. Essas evidências oferecem pistas concretas sobre como as espécies se modificaram ao longo de milhões de anos e como elas compartilham um ancestral comum. Os fósseis são restos ou impressões de organismos que viveram no passado. Eles são geralmente encontrados em camadas de rochas sedimentares, o que permite que os cientistas possam estudar diferentes períodos da história da Terra. A paleontologia é o ramo da ciência que se dedica ao estudo dos fósseis, e seu trabalho é essencial para entender a evolução.
Os fósseis de transição são um dos tipos mais importantes de evidências fósseis. Eles mostram características intermediárias entre espécies antigas e modernas, revelando como um grupo de organismos se modificou ao longo do tempo. Esses fósseis conectam diferentes espécies através de uma linha contínua de transformação.
Um exemplo clássico de fóssil de transição é o Archaeopteryx, uma criatura que viveu há cerca de 150 milhões de anos e exibe características tanto de répteis (como dentes e uma longa cauda óssea) quanto de aves (como penas e estrutura óssea semelhante à de aves modernas). O Archaeopteryx é considerado uma ponte evolutiva entre os dinossauros e as aves modernas.
Outro exemplo bem conhecido é o dos peixes que deram origem aos vertebrados terrestres. Fósseis de criaturas como o Tiktaalik mostram uma transição clara de animais aquáticos para terrestres, com características como barbatanas que gradualmente se transformaram em membros com articulações, permitindo a locomoção em terra. Veremos a seguir como é feita a coleta de fósseis.

Instruções: Você pode arrastar o homem que está segurando a pá até o monte de terra. A cada vez que você arrasta o personagem, ele cava a terra um pouco. É preciso repetir esse movimento até encontrar o fóssil de um Archaeopteryx que está enterrado. Depois, arraste o fóssil encontrado para o laboratório e verá um conteúdo sobre sua análise.
        ]],
        x = 370,
        y = title.y + 240,
        width = 695,
        font = native.systemFontRegular,
        fontSize = 14,
        align = "justify"
    })

    local nextButton = display.newImage(
        "assets/next.png",
        CONSTANTS.width - 60,
        CONSTANTS.height - 75
    )

    local previousButton = display.newImage(
        "assets/previous.png",
        60,
        CONSTANTS.height - 75
    )

    nextButton:addEventListener("tap", function()
        resetImages()
        pauseSound()
        composer.gotoScene("pagina4", "fade")
    end)

    previousButton:addEventListener("tap", function()
        resetImages()
        pauseSound()
        composer.gotoScene("pagina2", "fade")
    end)

    objects:insert(title)
    objects:insert(content)
    objects:insert(pageNumber)
    objects:insert(soundControlGroup)
    objects:insert(nextButton)
    objects:insert(previousButton)
    objects:insert(man)
    objects:insert(dirt)
end

function scene:show(event)
    local phase = event.phase
    local sceneGroup = self.view

    if phase == "will" then
        currentAnimation = 0

        if not man then
            man = display.newImageRect("assets/man_with_shovel.png", 199, 269)
            man.x = centerX + 220
            man.y = centerY + 200
            physics.addBody(man, "dynamic", {isSensor = true})
            man.gravityScale = 0

            man:addEventListener("touch", dragMan)
        end

        if not dirt then
            dirt = display.newImageRect("assets/dirt_pile.png", 275, 239)
            dirt.x = centerX - 150
            dirt.y = centerY + 200
            physics.addBody(dirt, "static", {isSensor = true})
        end

        if soundControlGroup then
            soundControlGroup:removeSelf()
            soundControlGroup = nil
        end

        soundControlGroup = SoundControl.new({
            isSoundOn = isSoundOn,
            onPressButtonCB = playOrRestartSound,
            pauseSound = pauseSound,
            resumeSound = resumeSound
        })

        sceneGroup:insert(soundControlGroup)
    end
end

function scene:destroy(event)
    if soundControlGroup then
        soundControlGroup:removeSelf()
        soundControlGroup = nil
    end

    if soundChannel then
        audio.stop(soundChannel)
        soundChannel = nil
    end

    if capaSound then
        audio.dispose(capaSound)
        capaSound = nil
    end

    currentAnimation = 0
end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("destroy", scene)

return scene
