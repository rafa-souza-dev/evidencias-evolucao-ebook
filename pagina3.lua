local composer = require "composer"
local SoundControl = require "components.SoundControl"

local scene = composer.newScene()
local capaSound = audio.loadSound("pagina3.mp3")
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
        composer.gotoScene("pagina4", "fade")
    end)

    previousButton:addEventListener("tap", function()
        pauseSound()
        composer.gotoScene("pagina2", "fade")
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
