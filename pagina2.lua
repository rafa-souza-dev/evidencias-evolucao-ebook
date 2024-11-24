local composer = require "composer"
local SoundControl = require "components.SoundControl"

local scene = composer.newScene()
local capaSound = audio.loadSound("audios/pagina2.mp3")
local soundChannel
local isSoundOn = false

local function criarBotaoLarge()
    local largura = 388
    local altura = 62
    local botao = display.newRoundedRect(0, 0, largura, altura, 12)

    botao:setFillColor(0.459, 0.4, 0.263)

    local textoBotao = display.newText({
        text = "Pressione para avançar",
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

local fishes = {
    {
         title = 'Eusthenopteron (cerca de 385 milhões de anos)', description = [[Descrição: Um peixe sarcopterígio (peixe de nadadeiras lobadas) que viveu durante o Devoniano. Embora ainda totalmente aquático, tinha ossos em suas nadadeiras que lembram a estrutura dos ossos dos braços e pernas dos tetrápodes.
Importância: Representa um estágio inicial de peixes que já apresentavam algumas adaptações estruturais que mais tarde permitiriam o desenvolvimento de membros.]], image = 'assets/animal1.png' 
    },
    {
        title = 'Panderichthys (cerca de 380 milhões de anos)', description = [[Descrição: Um peixe de corpo achatado com nadadeiras lobadas e olhos no topo da cabeça, indicando que vivia em águas rasas e possivelmente se movia em ambientes lamosos.
Importância: Panderichthys tinha nadadeiras que eram intermediárias entre as de peixes e membros de tetrápodes, com estruturas ósseas que lembram os ossos do braço e da perna dos vertebrados terrestres.]], image = 'assets/animal2.png'
    },
    {
        title = 'Tiktaalik (cerca de 375 milhões de anos)', description = [[Descrição: Um dos fósseis mais famosos da transição, Tiktaalik é um exemplo claro de uma espécie intermediária. Ele tinha características de peixe, como brânquias e nadadeiras, mas também apresentava traços de tetrápode, como um pescoço móvel, pulmões, e membros que permitiam que se movesse em terra firme.
Importância: Tiktaalik possuía nadadeiras com ossos semelhantes aos de um braço, sugerindo que era capaz de se arrastar em terra ou em águas rasas. Ele é frequentemente visto como um "elo perdido" entre peixes e os primeiros tetrápodes.]], image = 'assets/animal3.png'
    },
    {
        title = 'Acanthostega (cerca de 365 milhões de anos)', description = [[Descrição: Um dos primeiros tetrápodes conhecidos, Acanthostega tinha membros com dedos, mas ainda vivia predominantemente na água. Seus membros eram adaptados principalmente para nadar, e provavelmente não suportava o peso do corpo fora da água por muito tempo.
Importância: Este animal possuía oito dedos em cada pata, uma característica única entre os tetrápodes, e ilustra como os membros começaram a se diferenciar das nadadeiras.]], image = 'assets/animal4.png'
    },
    {
        title = 'Ichthyostega (cerca de 365 milhões de anos)', description = [[Descrição: Outro tetrápode primitivo, Ichthyostega já possuía membros mais fortes do que Acanthostega e era capaz de se mover tanto na água quanto em terra, embora seus movimentos terrestres fossem provavelmente limitados.
Importância: É considerado um dos primeiros animais a ter desenvolvido membros capazes de suportar seu peso em terra, mas suas adaptações mostram que ainda dependia bastante de ambientes aquáticos.]], image = 'assets/animal5.png'
    },
    {
        title = 'Tulerpeton (cerca de 365 milhões de anos)', description = [[Descrição: Um tetrápode mais avançado, com membros fortes e seis dedos em cada pata. Tulerpeton é um dos primeiros tetrápodes que provavelmente passou mais tempo em terra do que na água.
Importância: Indica o desenvolvimento contínuo de membros e articulações mais adequados para a vida terrestre e é um exemplo de como os tetrápodes estavam começando a se diversificar.]], image = 'assets/animal6.png'
    },
}

local currentIndex = 1

local function createFishDisplay(fish)
    local group = display.newGroup()

    local image = display.newImageRect(fish.image, 476, 200)
    image.x = display.contentCenterX
    image.y = 650

    local title = display.newText({
        text = fish.title,
        x = display.contentCenterX,
        y = display.contentCenterY + 265,
        fontSize = 24
    })

    local description = display.newText({
        text = fish.description,
        x = display.contentCenterX,
        y = display.contentCenterY + 335,
        fontSize = 16,
        width = display.contentWidth - 40,
        align = "center"
    })

    group:insert(image)
    group:insert(title)
    group:insert(description)

    return group
end

local currentFishDisplay = createFishDisplay(fishes[currentIndex])

local function showNextFish(largeButton)
    if currentIndex < #fishes then
        transition.to(currentFishDisplay, { alpha = 0, time = 500, onComplete = function()
            currentFishDisplay:removeSelf()
            currentFishDisplay = nil

            currentIndex = currentIndex + 1

            currentFishDisplay = createFishDisplay(fishes[currentIndex])
            currentFishDisplay.alpha = 0
            transition.to(currentFishDisplay, { alpha = 1, time = 500 })

            if currentIndex == #fishes then
                local textoBotao = largeButton[2]
                textoBotao.text = "Pressione para reiniciar"
            end
        end })
    else
        transition.to(currentFishDisplay, { alpha = 0, time = 500, onComplete = function()
            currentFishDisplay:removeSelf()
            currentFishDisplay = nil

            currentIndex = 1

            currentFishDisplay = createFishDisplay(fishes[currentIndex])
            currentFishDisplay.alpha = 0
            transition.to(currentFishDisplay, { alpha = 1, time = 500 })

            local textoBotao = largeButton[2]
            textoBotao.text = "Pressione para avançar"
        end })
    end
end

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
        "assets/next.png",
        CONSTANTS.width - 60,
        CONSTANTS.height - 75
    )

    local previousButton = display.newImage(
        "assets/previous.png",
        60,
        CONSTANTS.height - 75
    )

    local largeButton = criarBotaoLarge()
    largeButton.y = CONSTANTS.height - 70
    largeButton.x = CONSTANTS.width / 2

    local function resetState()
        currentFishDisplay:removeSelf()
        currentFishDisplay = nil
        currentIndex = 1
    end

    nextButton:addEventListener("tap", function()
        resetState()
        pauseSound()
        composer.gotoScene("pagina3", "fade")
    end)

    previousButton:addEventListener("tap", function()
        resetState()
        pauseSound()
        composer.gotoScene("capa", "fade")
    end)

    largeButton:addEventListener("tap", function() showNextFish(largeButton) end)

    objects:insert(title)
    objects:insert(content)
    objects:insert(pageNumber)
    objects:insert(soundControlGroup)
    objects:insert(nextButton)
    objects:insert(previousButton)
    objects:insert(currentFishDisplay)
    objects:insert(largeButton)
end

function scene:show(event)
    local phase = event.phase
    local sceneGroup = self.view

    if phase == "will" then
        if not currentFishDisplay then
            currentFishDisplay = createFishDisplay(fishes[currentIndex])
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
