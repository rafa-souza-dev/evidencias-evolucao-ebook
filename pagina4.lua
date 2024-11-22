local composer = require "composer"
local SoundControl = require "components.SoundControl"

local scene = composer.newScene()
local capaSound = audio.loadSound("pagina4.mp3")
local soundChannel
local isSoundOn = false

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
        pauseSound()
        composer.gotoScene("pagina5", "fade")
    end)

    previousButton:addEventListener("tap", function()
        pauseSound()
        composer.gotoScene("pagina3", "fade")
    end)

    objects:insert(title)
    objects:insert(content)
    objects:insert(pageNumber)
    objects:insert(soundControlGroup)
    objects:insert(nextButton)
    objects:insert(previousButton)
end

function scene:show(event)
    local phase = event.phase
    local sceneGroup = self.view

    if phase == "will" then
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
