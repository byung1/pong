--[[
    The Game Logic Class
]]

GameLogic = Class{}

function GameLogic:init(player1, player2, ball)
    self.player1 = player1
    self.player2 = player2
    self.ball = ball

    self.player1Score = 0
    self.player2Score = 0
end

--[[
    Processes the user input during game runtime
]]
function GameLogic:processPlayerInput()
    -- player 1 movement
    if love.keyboard.isDown('w') then
        self.player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        self.player1.dy = PADDLE_SPEED
    else
        self.player1.dy = 0
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        self.player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        self.player2.dy = PADDLE_SPEED
    else
        self.player2.dy = 0
    end

    -- TODO: add logic here for CPU movement
end

--[[
    Detects collisions for the ball
]]
function GameLogic:detectBallCollisions()
    local ball = self.ball
    local player1 = self.player1
    local player2 = self.player2

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

    -- detect upper screen boundary collision
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
    end

    -- detect lower screen boundary collision
    if ball.y >= VIRTUAL_HEIGHT - ball.height then
        ball.y = VIRTUAL_HEIGHT - ball.height
        ball.dy = -ball.dy
    end
end

--[[
    Detect whether a ball has cross the sides of the screen
    If so, a player has scored a point!
]]
function GameLogic:scoredPoint()
    local ball = self.ball
    local player1 = self.player1
    local player2 = self.player2

    if ball.x <= 0 or ball.x >= VIRTUAL_WIDTH then
        return true
    end

    -- TODO: Add scoring logic here and maybe some gamestate changes
    return false
end
