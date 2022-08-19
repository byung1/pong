--[[
    The Game Logic Class
]]

Game = Class{}

function Game:init(player1, player2, ball)
    self.player1 = player1
    self.player2 = player2
    self.ball = ball

    self.player1Score = 0
    self.player2Score = 0
    self.winningPlayer = 0

    self.servingPlayer = math.random(2)

    self.roundState = 'serve'

    self.sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static')
    }
end

--[[
    Logic to serve the ball in the proper direction
]]
function Game:serveBall()
    if self.servingPlayer == 1 then
        self.ball:setVelocity(150, math.random(-50, 50))
    else
        self.ball:setVelocity(-150, math.random(-50, 50))
    end
end

--[[
    Detects collisions for the ball
]]
function Game:detectBallCollisions()
    local ball = self.ball
    local player1 = self.player1
    local player2 = self.player2

    -- detect collision for player1
    if ball:collides(player1) then
        ball.x = player1.x + player1.width + 1
        self.sounds['paddle_hit']:play()
        ball:bounce()
    end

    -- detect collision for player2
    if ball:collides(player2) then
        ball.x = player2.x - player2.width - 1
        self.sounds['paddle_hit']:play()
        ball:bounce()
    end

    -- detect upper screen boundary collision
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
        self.sounds['wall_hit']:play()
    end

    -- detect lower screen boundary collision
    if ball.y >= VIRTUAL_HEIGHT - ball.height then
        ball.y = VIRTUAL_HEIGHT - ball.height
        ball.dy = -ball.dy
        self.sounds['wall_hit']:play()
    end
end

--[[
    Detect whether a ball has cross the sides of the screen
    If so, a player has scored a point!
]]
function Game:scoredPoint()
    if self.ball.x <= 0 then
        self.player2Score = self.player2Score + 1
        self.servingPlayer = 2
        self.roundState = 'serve'
        self.sounds['score']:play()
        self.ball:reset()
        return true
    elseif self.ball.x >= VIRTUAL_WIDTH then
        self.player1Score = self.player1Score + 1
        self.servingPlayer = 1
        self.roundState = 'serve'
        self.sounds['score']:play()
        self.ball:reset()
        return true
    end

    return false
end

--[[
    Checks if any player has won
]]
function Game:hasWinner()
    return self.player1Score == 10 or self.player2Score == 10
end

--[[

]]
function Game:getWinner()
    if self.player1Score == 10 then
        return 1
    else
        return 2
    end
end

--[[
    Restarts the game by resetting initial value
]]
function Game:restartGame()
    self.player1Score = 0
    self.player2Score = 0
    self.servingPlayer = math.random(2)
    self.ball:reset()
end

function Game:update(dt)
    self.ball:update(dt)
    self.player1:update(dt)
    self.player2:update(dt)
end
