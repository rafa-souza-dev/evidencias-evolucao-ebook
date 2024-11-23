local composer = require "composer"
local SoundControl = require "components.SoundControl"

local scene = composer.newScene()
local capaSound = audio.loadSound("audios/pagina5.mp3")
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
        text = "Página 5",
        x = 50,
        y = 24,
        fontSize = 14,
        font = native.systemFontBold,
    })

    local title = display.newText({
        text = "Tempo Geológico e Paleontológico",
        x = 285,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32,
        align = "left"
    })

    local content = display.newText({
        text = [[
O Tempo Geológico é um conceito fundamental na geologia e nas ciências da Terra que se refere à escala temporal usada para descrever a história do planeta, desde sua formação até os dias atuais. Essa escala é imensa, abrangendo bilhões de anos, e permite aos cientistas entender a evolução da Terra, incluindo mudanças climáticas, tectônicas, biológicas e geológicas.
O Tempo Geológico é dividido em várias unidades, que, da maior para a menor, são:
Éons: São as divisões mais amplas da história da Terra. O nosso planeta é geralmente dividido em quatro éons principais:
Hadeano (4,6 a 4,0 bilhões de anos atrás): A era da formação da Terra, quando o planeta era extremamente quente e em grande parte fundido.
Arqueano (4,0 a 2,5 bilhões de anos atrás): Caracteriza-se pelo resfriamento da Terra e a formação das primeiras crostas continentais, bem como o surgimento das primeiras formas de vida, como as bactérias.
Proterozoico (2,5 bilhões a 541 milhões de anos atrás): Uma era de mudanças significativas, incluindo o aumento do oxigênio na atmosfera e o desenvolvimento de organismos multicelulares.
Fanerozoico (541 milhões de anos atrás até o presente): A era em que se desenvolveu a vida complexa, incluindo a explosão Cambriana, que trouxe uma diversidade enorme de formas de vida.
Eras: Cada éon é subdividido em eras. Por exemplo, o Fanerozoico é dividido em três eras: Paleozoica, Mesozoica e Cenozoica.
Períodos: As eras são subdivididas em períodos. Por exemplo, a era Mesozoica inclui os períodos Triássico, Jurássico e Cretáceo.
Épocas: Os períodos podem ser divididos em épocas, como a Época Paleolítica ou a Época Neolítica no contexto humano.
Idades: A subdivisão mais fina, que representa intervalos de tempo específicos dentro de uma época.
        ]],
        x = 370,
        y = title.y + 210,
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
        composer.gotoScene("pagina6", "fade")
    end)

    previousButton:addEventListener("tap", function()
        pauseSound()
        composer.gotoScene("pagina4", "fade")
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
