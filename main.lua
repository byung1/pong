-- Library/class imports
push = require './lib/push'
Class = require './lib/class'
require './lib/helpers'
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

    -- detect collision for player1
    if ball:collides(player1) then
        ball.x = player1.x + player1.width + 1
        ball:bounce()
    end

    -- detect collision for player2
    if ball:collides(player2) then
        ball.x = player2.x - player2.width - 1
        ball:bounce()
    end

    -- detect upper and lower screen boundary collision
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    end

    if ball.y >= VIRTUAL_HEIGHT - ball.height then
        ball.y = VIRTUAL_HEIGHT - ball.height
        ball.dy = -ball.dy
    end

    -- detect whether a ball has cross the sides of the screen
    if ball.x <= 0 or ball.x >= VIRTUAL_WIDTH then
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
