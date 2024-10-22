function corDecimal(cor)
    return cor / 255
end

display.setDefault("background", corDecimal(145), corDecimal(135), corDecimal(111))
display.setStatusBar(display.HiddenStatusBar)

local composer = require "composer"

CONSTANTS = {
    width=768,
    height=1024
}

composer.gotoScene( "capa", "fade" )
