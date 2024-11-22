local composer = require "composer"
local SoundControl = require "components.SoundControl"

local scene = composer.newScene()
local capaSound = audio.loadSound("pagina2.mp3")
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
        text = "Página 2",
        x = 50,
        y = 24,
        fontSize = 14,
        font = native.systemFontBold
    })

    local title = display.newText({
        text = "Evidências da Evolução - Introdução",
        x = 300,
        y = 100,
        font = native.systemFontBold,
        fontSize = 32,
        align = "left"
    })

    local content = display.newText({
        text = [[
A teoria da evolução, proposta inicialmente por Charles Darwin no século XIX, sugere que todas as espécies de organismos vivos descendem de um ancestral comum. A evolução ocorre através de processos como seleção natural, onde as características que favorecem a sobrevivência são mais prováveis de serem passadas para as gerações seguintes. Ao longo do tempo, isso resulta em mudanças graduais e no desenvolvimento de novas espécies. A evolução é um pilar da biologia moderna, ajudando a explicar a diversidade da vida na Terra. 
Darwin observou que, dentro de uma espécie, há uma variação natural — ou seja, os indivíduos não são idênticos entre si. Algumas dessas variações são mais vantajosas para a sobrevivência e a reprodução, dependendo do ambiente em que os indivíduos vivem. Aqueles com características vantajosas têm mais chances de sobreviver e passar essas características para os descendentes. Este processo, conhecido como seleção natural, é o principal mecanismo da evolução.
A seleção natural é o processo pelo qual organismos com características mais adequadas ao ambiente têm maior probabilidade de sobreviver e se reproduzir, enquanto aqueles menos adaptados tendem a desaparecer com o tempo. Essas características vantajosas são chamadas de adaptações, e podem ser físicas (como pelagem espessa em animais que vivem em regiões frias) ou comportamentais (como padrões de migração de aves).
A seleção natural não é um processo planejado ou direcionado. Ela ocorre de maneira gradual e não-intencional, com pequenas mudanças acumulando-se ao longo de gerações. Essa acumulação pode eventualmente levar ao surgimento de novas espécies, um processo conhecido como especiação.
Abaixo vemos uma ilustração das principais espécies que foram responsáveis pela transição de animais aquáticos até os terrestres:

Instruções: Você pode tocar no botão “Pressione para avançar” e verá a imagem atual do animal evoluindo para outro animal, exibindo a cada vez uma espécie mais recente da transição de aquáticos para terrestres. Você verá que o conteúdo abaixo do animal também irá mudar. Ao chegar no último animal, é possível tocar em “Pressione para reiniciar”, para que volte ao primeiro animal.
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
        composer.gotoScene("pagina3", "fade")
    end)

    previousButton:addEventListener("tap", function()
        pauseSound()
        composer.gotoScene("capa", "fade")
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
