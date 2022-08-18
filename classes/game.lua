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

    self.servingPlayer = math.random(2)

    self.sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static')
    }
end

--[[
    Processes the user input during game runtime
]]
function Game:processPlayerInput()
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
        self.sounds['score']:play()
        return true
    elseif self.ball.x >= VIRTUAL_WIDTH then
        self.player1Score = self.player1Score + 1
        self.servingPlayer = 1
        self.sounds['score']:play()
        return true
    end

    return false
end

--[[
    Checks if any player has won
]]
function Game:hasWinner()
    if self.player1Score == 10 or self.player2Score == 10 then
        return true
    end

    return false
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

--[[
    Draws the game and renders the different components
]]
function Game:draw()
    -- Printing player names at the top of the screen
    smallFont = love.graphics.newFont('fonts/retro_gaming.ttf', 8)
    love.graphics.setFont(smallFont)
    love.graphics.printf('Player 1', 0, 5, VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf('Player 2', VIRTUAL_WIDTH / 2, 5, VIRTUAL_WIDTH / 2, 'center')

    -- Printing which player serves the ball
    if gameState == 'serve' then
        if self.servingPlayer == 1 then
            love.graphics.printf('Player 1\'s Serve', 0, 24, VIRTUAL_WIDTH, 'center')
        else
            love.graphics.printf('Player 2\'s Serve', 0, 24, VIRTUAL_WIDTH, 'center')
        end
        love.graphics.printf('Press \'Enter\' to serve the ball!', 0, 32, VIRTUAL_WIDTH, 'center')
    end

    -- Printing victory when a winner is declared
    if gameState == 'done' then
        victoryFont = love.graphics.newFont('fonts/retro_gaming.ttf', 20)
        love.graphics.setFont(victoryFont)
        if self.player1Score > self.player2Score then
            love.graphics.printf('Player 1 Wins!', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
        else
            love.graphics.printf('Player 2 Wins!', 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
        end
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press \'Enter\' to play again!', 0, VIRTUAL_HEIGHT / 4 + 20, VIRTUAL_WIDTH, 'center')
    end

    -- Printing Score
    scoreFont = love.graphics.newFont('fonts/retro_gaming.ttf', 32)
    love.graphics.setFont(scoreFont)
    love.graphics.printf(tostring(self.player1Score), 0, 20, VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf(tostring(self.player2Score), VIRTUAL_WIDTH / 2, 20, VIRTUAL_WIDTH / 2, 'center')

    -- Render Ball and Player Paddles
    self.ball:render()
    self.player1:render()
    self.player2:render()
end
