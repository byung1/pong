-- Library/class imports
push = require './lib/push'
Class = require './lib/class'
require './methods/helpers'
require './methods/paddle'
require './classes/Paddle'
require './classes/Ball'

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
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    -- setting a more retro-looking font as Love2D's active font
    smallFont = love.graphics.newFont('fonts/retro_gaming.ttf', 8)
    love.graphics.setFont(smallFont)
    love.window.setTitle('Pong Game')

    -- setting game state
    gameState = 'ready'

    -- initialize the ball
    ball = Ball(BALL_WIDTH, BALL_HEIGHT)    

    -- initialize our player's paddles
    player1 = Paddle(1, getVerticalCenteredHeight(PADDLE_HEIGHT), PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(VIRTUAL_WIDTH - PADDLE_WIDTH - 1, getVerticalCenteredHeight(PADDLE_HEIGHT), PADDLE_WIDTH, PADDLE_HEIGHT)
    
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
    processPlayerInput(player1, player2)
    detectBallCollisions(player1, player2, ball)

    print(scoredPoint(player1, player2, ball))

    if scoredPoint(player1, player2, ball) == true then
        gameState = 'ready'
        ball:reset()
    end

    -- Only update the position of the ball when we are in the play state
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
    push:apply('start')
    
    love.graphics.printf(
        'Pong!', 0, 20, VIRTUAL_WIDTH, 'center'
    )

    -- Render Ball
    ball:render()

    -- Render paddles
    player1:render()
    player2:render()

    -- end rendering at virtual resolution
    push:apply('end')
end
