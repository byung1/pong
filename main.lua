-- Library/class imports
push = require './lib/push'
Class = require './lib/class'
require './classes/Paddle'
require './classes/Ball'
require './classes/Game'

-- Window Dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Global Constants
PADDLE_SPEED = 200
PADDLE_WIDTH = 4
PADDLE_HEIGHT = 20
BALL_WIDTH = 4
BALL_HEIGHT = 4

--[[
    Constructor
]]
function love.load()
    love.window.setTitle('Pong Game')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    -- setting game state
    gameState = 'ready'

    -- initialize the ball
    ball = Ball(BALL_WIDTH, BALL_HEIGHT)    

    -- initialize our player's paddles
    player1 = Paddle(1, getVerticalCenteredHeight(PADDLE_HEIGHT), PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(VIRTUAL_WIDTH - PADDLE_WIDTH - 1, getVerticalCenteredHeight(PADDLE_HEIGHT), PADDLE_WIDTH, PADDLE_HEIGHT)
    
    game = Game(player1, player2, ball)

    -- initializes our virtual resolution within our window no matter what the
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
    game:processPlayerInput()
    game:detectBallCollisions()

    if game:scoredPoint() then
        gameState = 'ready'
        ball:reset()
    end

    -- Only update the position of the ball when we are in the `play` state
    if gameState == 'play' then
        ball:update(dt)
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
    elseif key == 'enter' or key == 'return' then
        if gameState == 'ready' then
            gameState = 'play'
        else
            gameState = 'ready'
            ball:reset()
        end
    end
end

--[[
    This function is called after every update
]]
function love.draw()
    -- begin rendering at virtual resolution
    push:start()

    game:draw()

    -- end rendering at virtual resolution
    push:finish()
end


--
-- Useful Generic Helper Methods
--
function getHorizontalCenteredWidth(object_width)
    return VIRTUAL_WIDTH / 2 - object_width / 2
end

function getVerticalCenteredHeight(object_height)
    return VIRTUAL_HEIGHT / 2 - object_height / 2
end
