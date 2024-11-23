local composer = require "composer"
local SoundControl = require "components.SoundControl"

local scene = composer.newScene()
local capaSound = audio.loadSound("audios/pagina6.mp3")
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
        text = "Página 6",
        x = 50,
        y = 24,
        fontSize = 14,
        font = native.systemFontBold,
    })

    local title = display.newText({
        text = "Tempo Paleontológico - Explosão Cambriana",
        width = 550,
        x = 300,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32,
        align = "left"
    })

    local content = display.newText({
        text = [[
Um dos eventos mais importantes da paleontologia é a Explosão Cambriana, que ocorreu há cerca de 541 milhões de anos no início do período Cambriano, parte do éon Fanerozoico. Esse evento é considerado um dos marcos mais significativos na história da vida na Terra, pois foi durante esse período que houve uma rápida diversificação de organismos multicelulares. Aqui estão alguns motivos que tornam a Explosão Cambriana tão importante:
Diversificação da Vida Complexa: Antes do Cambriano, a maior parte dos organismos eram simples e predominantemente unicelulares. Durante a Explosão Cambriana, muitos grupos de organismos multicelulares surgiram, incluindo os ancestrais de quase todos os principais filos de animais que conhecemos hoje.
Primeiros Registros Fósseis de Animais com Partes Duras: Foi nesse período que surgiram os primeiros animais com exoesqueletos, conchas e outras partes duras, o que aumentou significativamente a preservação de fósseis e permitiu um registro mais claro da evolução da vida.
Aparição de Estruturas Corporais Complexas: Muitos animais começaram a desenvolver estruturas corporais mais complexas, como olhos, bocas, apêndices e sistemas nervosos, o que levou a uma maior diversidade ecológica e ao surgimento de novos nichos.

Instruções: Toque no botão “Pressione para explodir” para simular a explosão cambriana. Uma explosão irá acontecer dentro do retângulo abaixo, fazendo com que os organismos unicelulares fiquem mais complexos.
        ]],
        x = 370,
        y = title.y + 190,
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
        composer.gotoScene("contracapa", "fade")
    end)

    previousButton:addEventListener("tap", function()
        pauseSound()
        composer.gotoScene("pagina5", "fade")
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
