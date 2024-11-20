local SoundControl = {}

local DEFAULT_ICON_X = CONSTANTS.width - 56
local DEFAULT_ICON_Y = 56
local DEFAULT_WIDTH = 87
local DEFAULT_HEIGHT = 24
local DEFAULT_CORNER_RADIUS = 12
local DEFAULT_BUTTON_COLOR = {0.459, 0.4, 0.263}

function SoundControl.new(options)
    options.iconX = options.iconX or DEFAULT_ICON_X
    options.iconY = options.iconY or DEFAULT_ICON_Y
    options.width = options.width or DEFAULT_WIDTH
    options.height = options.height or DEFAULT_HEIGHT
    options.cornerRadius = options.cornerRadius or DEFAULT_CORNER_RADIUS
    options.buttonColor = options.buttonColor or DEFAULT_BUTTON_COLOR
    options.fontSize = options.fontSize or 11
    options.buttonText = options.buttonText or "Tocar do início"

    local group = display.newGroup()

    local function updateSoundIcon(toActive)
        if toActive then
            if options.isSoundOn then
                return nil
            end
    
            options.isSoundOn = true
            local newIcon = "sound.png"
    
            if group.soundIconImage then
                group.soundIconImage:removeSelf()
                group.soundIconImage = nil
            end
    
            group.soundIconImage = display.newImage(newIcon)
            group.soundIconImage.x = options.iconX
            group.soundIconImage.y = options.iconY
            group.soundIconImage:addEventListener("tap", group.soundIconTap)
    
            group:insert(1, group.soundIconImage)

            return nil
        end

        local newIcon = options.isSoundOn and "sound.png" or "sound-muted.png"

        if group.soundIconImage then
            group.soundIconImage:removeSelf()
            group.soundIconImage = nil
        end

        group.soundIconImage = display.newImage(newIcon)
        group.soundIconImage.x = options.iconX
        group.soundIconImage.y = options.iconY
        group.soundIconImage:addEventListener("tap", group.soundIconTap)

        group:insert(1, group.soundIconImage)
    end

    group.soundIconImage = display.newImage(options.isSoundOn and "sound.png" or "sound-muted.png")
    group.soundIconImage.x = options.iconX
    group.soundIconImage.y = options.iconY
    group:insert(group.soundIconImage)

    local customButton = display.newRoundedRect(0, 0, options.width, options.height, options.cornerRadius)
    customButton:setFillColor(unpack(options.buttonColor))
    customButton.x = group.soundIconImage.x
    customButton.y = group.soundIconImage.y + 50
    group:insert(customButton)

    local textoBotao = display.newText({
        text = options.buttonText,
        x = customButton.x,
        y = customButton.y,
        font = native.systemFontBold,
        fontSize = options.fontSize
    })
    group:insert(textoBotao)

    function group.soundIconTap()
        options.isSoundOn = not options.isSoundOn
        updateSoundIcon()
    end

    function customButton:tap()
        updateSoundIcon(true)
        options.onPressButtonCB()
    end

    customButton:addEventListener("tap", customButton)
    group.soundIconImage:addEventListener("tap", group.soundIconTap)

    return group
end

return SoundControl
