-- Library imports
push = require './lib/push'
Class = require './lib/class'

-- Class imports
require './classes/Paddle'

-- Window Dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Global Constants
PADDLE_SPEED = 200
PADDLE_WIDTH = 4
PADDLE_HEIGHT = 20

--[[
    Constructor
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Setting a more retro-looking font as Love2D's active font
    smallFont = love.graphics.newFont('fonts/retro_gaming.ttf', 8)
    love.graphics.setFont(smallFont)

    -- Initialize our player's paddles
    verticalCenteredHeight = VIRTUAL_HEIGHT / 2 - PADDLE_HEIGHT / 2
    player1 = Paddle(1, verticalCenteredHeight, PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(VIRTUAL_WIDTH - PADDLE_WIDTH - 1, verticalCenteredHeight, PADDLE_WIDTH, PADDLE_HEIGHT)
    
    -- Initializes our virtual resolution within our window no matter what the
    -- dimenstions are and replaces love.window.setMode
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

--[[
    Runs every frame, with `dt` passed in as our delta in seconds
]]
function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

     -- player 2 movement
     if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    player1:update(dt)
    player2:update(dt)
end


--[[
    Keyboard handling, called each frame
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
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 1, VIRTUAL_HEIGHT / 2 - 1, 4, 4)
    
    love.graphics.printf(
        'Pong!', 0, 20, VIRTUAL_WIDTH, 'center'
    )

    player1:render()
    player2:render()

    -- end rendering at virtual resolution
    push:apply('end')
end
