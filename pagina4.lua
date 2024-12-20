local composer = require "composer"
local SoundControl = require "components.SoundControl"

local scene = composer.newScene()
local capaSound = audio.loadSound("audios/pagina4.mp3")
local soundChannel
local isSoundOn = false

local flor1 = display.newImageRect("assets/flor1.png", 225, 225)
flor1.x = display.contentWidth * 0.2
flor1.y = display.contentCenterY + 200

local flor2 = display.newImageRect("assets/flor2.png", 208, 242)
flor2.x = display.contentWidth * 0.8
flor2.y = display.contentCenterY + 200

local finalFlor = display.newImageRect("assets/final-flor.png", 386, 276)
finalFlor.x = display.contentCenterX
finalFlor.y = display.contentCenterY + 200
finalFlor.alpha = 0

local polen = display.newImageRect("assets/polen.png", 374, 123)
polen.x = flor1.x
polen.y = flor1.y
polen.alpha = 0

local function revealFinalFlor()
    transition.to(flor1, {
        time = 500,
        alpha = 0,
        onComplete = function()
            flor1:removeSelf()
            flor1 = nil
        end
    })

    transition.to(flor2, {
        time = 500,
        alpha = 0,
        onComplete = function()
            flor2:removeSelf()
            flor2 = nil
        end
    })

    transition.to(polen, {
        time = 500,
        alpha = 0,
        onComplete = function()
            polen:removeSelf()
            polen = nil
        end
    })

    transition.to(finalFlor, {
        time = 1500,
        alpha = 1
    })
end

local function playPolen()
    transition.to(polen, {
        time = 1700,
        x = flor2.x,
        alpha = 1,
        onComplete = function()
            revealFinalFlor()
        end
    })
end

local function onShake(event)
    if event.isShake and flor1 and flor2 then
        playPolen()
    end
end

local function resetState()
    if flor1 then
        flor1:removeSelf()
        flor1 = nil
    end

    if flor2 then
        flor2:removeSelf()
        flor2 = nil
    end

    if finalFlor then
        finalFlor:removeSelf()
        finalFlor = nil
    end

    if polen then
        polen:removeSelf()
        polen = nil
    end
end

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

Runtime:addEventListener("accelerometer", onShake)

function scene:create(event)
    local objects = self.view

    local pageNumber = display.newText({
        text = "Página 4",
        x = 50,
        y = 24,
        fontSize = 14,
        font = native.systemFontBold,
    })

    local title = display.newText({
        text = "Evidências da Evolução - Genética e Biogeografia",
        width = 550,
        x = 300,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32,
        align = "left"
    })

    local content = display.newText({
        text = [[
Com o avanço da genética, foi possível encontrar fortes evidências da evolução no DNA. Comparando genomas de diferentes espécies, os cientistas observaram semelhanças impressionantes entre organismos que compartilham ancestrais comuns. Por exemplo, humanos compartilham cerca de 98% de seu DNA com chimpanzés, mostrando uma relação evolutiva estreita. Mutuações genéticas ao longo de gerações também demonstram como as espécies mudam e se adaptam. A biogeografia, o estudo da distribuição das espécies ao redor do planeta, também oferece suporte à teoria da evolução. Espécies que vivem em áreas geográficas separadas, como ilhas, frequentemente desenvolvem adaptações únicas, como os tentilhões de Darwin nas Ilhas Galápagos, que evoluíram para se especializarem em diferentes tipos de alimentação, dependendo das condições ambientais locais.
A distribuição das espécies não é aleatória. Muitos organismos que vivem em regiões próximas compartilham características devido a uma história evolutiva comum. Quando observamos diferentes continentes, ilhas ou habitats isolados, encontramos evidências de que as espécies evoluíram a partir de um ancestral comum, mas que se diversificaram ao longo do tempo.
Um exemplo clássico de biogeografia é o estudo das espécies encontradas nas ilhas Galápagos, que inspiraram Charles Darwin. Ele notou que os tentilhões (pequenos pássaros) em diferentes ilhas do arquipélago possuíam bicos de formas e tamanhos diferentes, cada um adaptado ao tipo de alimento disponível em sua ilha específica. Isso o levou a concluir que todas as espécies de tentilhões haviam derivado de um ancestral comum, mas que as populações se diversificaram devido às pressões ambientais únicas de cada ilha. Esse é um exemplo claro de especiação, onde o isolamento geográfico levou à formação de novas espécies.

Instruções: Chacoalhe o seu dispositivo para enviar o pólen de uma flor até a outra, fazendo com que elas cruzem. Isso deve gerar uma flor filha, contendo características dos pais.
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
        resetState()
        pauseSound()
        composer.gotoScene("pagina5", "fade")
    end)

    previousButton:addEventListener("tap", function()
        resetState()
        pauseSound()
        composer.gotoScene("pagina3", "fade")
    end)

    objects:insert(title)
    objects:insert(content)
    objects:insert(pageNumber)
    objects:insert(soundControlGroup)
    objects:insert(nextButton)
    objects:insert(previousButton)
    objects:insert(flor1)
    objects:insert(flor2)
    objects:insert(finalFlor)
    objects:insert(polen)
end

function scene:show(event)
    local phase = event.phase
    local sceneGroup = self.view

    if phase == "will" then
        if not flor1 then
            flor1 = display.newImageRect("assets/flor1.png", 225, 225)
            flor1.x = display.contentWidth * 0.2
            flor1.y = display.contentCenterY + 200
        end

        if not flor2 then
            flor2 = display.newImageRect("assets/flor2.png", 208, 242)
            flor2.x = display.contentWidth * 0.8
            flor2.y = display.contentCenterY + 200
        end

        if not finalFlor then
            finalFlor = display.newImageRect("assets/final-flor.png", 386, 276)
            finalFlor.x = display.contentCenterX
            finalFlor.y = display.contentCenterY + 200
            finalFlor.alpha = 0
        end

        if not polen then
            polen = display.newImageRect("assets/polen.png", 374, 123)
            polen.x = flor1.x
            polen.y = flor1.y
            polen.alpha = 0
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
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("destroy", scene)

return scene
