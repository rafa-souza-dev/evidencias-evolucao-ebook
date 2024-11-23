local composer = require "composer"
local SoundControl = require "components.SoundControl"

local scene = composer.newScene()
local capaSound = audio.loadSound("contracapa.mp3")
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

local function criarBotaoLarge()
    local largura = 388
    local altura = 62
    local botao = display.newRoundedRect(0, 0, largura, altura, 12)

    botao:setFillColor(0.459, 0.4, 0.263)

    local textoBotao = display.newText({
        text = "Voltar ao início",
        x = botao.x,
        y = botao.y,
        font = native.systemFontBold,
        fontSize = 24
    })

    local grupoBotao = display.newGroup()
    grupoBotao:insert(botao)
    grupoBotao:insert(textoBotao)

    return grupoBotao
end

function scene:create(event)
    local objects = self.view

    local contracapa = display.newImage( "contracapa.png" )
    contracapa.y = CONSTANTS.height / 1.8
    contracapa.x = CONSTANTS.width / 2

    local title = display.newText({
        text = "Evidências da evolução, especiação, tempo geológico e paleontológico.",
        x = CONSTANTS.width / 2 - 110,
        y = 110,
        width = 504,
        font = native.systemFontBold,
        fontSize = 32,
        align = "left"
    })

    local description = display.newText({
        text = "Autor: Rafael José Gomes de Souza\nAno e Semestre: 2024.2",
        x = CONSTANTS.width / 2 - 110,
        y = 200,
        width = 504,
        font = native.systemFontRegular,
        fontSize = 24,
        align = "left"
    })

    local extraTexts = display.newText({
        text = "Orientador: Prof. Ewerton Mendonça\nDisciplina: Computação Gráfica e Sistemas Multimídia",
        x = 312,
        y = 275,
        font = native.systemFontRegular,
        fontSize = 24,
        align = "left"
    })

    local largeButton = criarBotaoLarge()
    largeButton.y = CONSTANTS.height - 100
    largeButton.x = CONSTANTS.width / 2

    local previousButton = display.newImage(
        "previous.png",
        60,
        CONSTANTS.height - 75
    )

    previousButton:addEventListener("tap", function()
        composer.gotoScene("pagina6", "fade")
    end)

    local function onLargeButtonTap(event)
        composer.gotoScene("capa", "fade")
    end

    largeButton:addEventListener("tap", onLargeButtonTap)

    objects:insert(title)
    objects:insert(contracapa)
    objects:insert(description)
    objects:insert(extraTexts)
    objects:insert(previousButton)
    objects:insert(largeButton)
    objects:insert(soundControlGroup)
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
