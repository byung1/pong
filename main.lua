--[[
    Downloaded from https://github.com/Ulydev/push

    Push is a library that allows us to render a game with lower resolution (virtual dimensions)
    within an arbitrary screen size (window dimensions)
]]
push = require './lib/push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[
    Constructor
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Setting a more retro-looking font
    smallFont = love.graphics.newFont('fonts/retro_gaming.ttf', 8)
    love.graphics.setFont(smallFont)
    
    -- Initializes our virtual resolution within our window no matter what the
    -- dimenstions are and replaces love.window.setMode
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

--[[
    Keyboard handling
]]
function love.keypressed(key)
    -- terminates the application
    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    This function is called after every update
]]
function love.draw()
    -- begin rendering at virtual resolution
    push:apply('start')

    -- printing the game
    -- love.graphics.clear(40, 45, 52, 255)
    love.graphics.printf(
        'Hello Pong!', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center'
    )

    -- end rendering at virtual resolution
    push:apply('end')
end
