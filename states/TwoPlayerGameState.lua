PADDLE_SPEED = 200
PADDLE_WIDTH = 4
PADDLE_HEIGHT = 20
BALL_WIDTH = 4
BALL_HEIGHT = 4

TwoPlayerGameState = Class{__includes = BaseState}

function TwoPlayerGameState:init()
    -- initialize the ball
    self.ball = Ball(BALL_WIDTH, BALL_HEIGHT)

    -- initialize our player's paddles
    self.player1 = Paddle(1, getVerticalCenteredHeight(PADDLE_HEIGHT), PADDLE_WIDTH, PADDLE_HEIGHT)
    self.player2 = Paddle(VIRTUAL_WIDTH - PADDLE_WIDTH - 1, getVerticalCenteredHeight(PADDLE_HEIGHT), PADDLE_WIDTH, PADDLE_HEIGHT)

    -- initialize game class that contains core logic
    self.game = Game(self.player1, self.player2, self.ball)

    self.roundState = 'serve'

    self.sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static')
    }
end

function TwoPlayerGameState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.game.roundState == 'serve' then
            self.game.roundState ='play'
            self.game:serveBall()
        elseif self.game.roundState == 'done' then
            self.game.roundState = 'serve'
            self.game:restartGame()
        end
    end

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

    -- Only update the position of the ball when we are in the `play` state
    if self.game.roundState == 'play' then
        self.game:detectBallCollisions()
    end

    if self.game:scoredPoint() then
        if self.game:hasWinner() then
            self.game.roundState = 'done'
        end
    end

    self.game:update(dt)
end

function TwoPlayerGameState:render()
    -- Printing player names at the top of the screen
    love.graphics.setFont(smallFont)
    love.graphics.printf('Player 1', 0, 5, VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf('Player 2', VIRTUAL_WIDTH / 2, 5, VIRTUAL_WIDTH / 2, 'center')

    -- Printing which player serves the ball
    if self.game.roundState == 'serve' then
        if self.game.servingPlayer == 1 then
            love.graphics.printf('Player 1\'s Serve', 0, 24, VIRTUAL_WIDTH, 'center')
        else
            love.graphics.printf('Player 2\'s Serve', 0, 24, VIRTUAL_WIDTH, 'center')
        end
        love.graphics.printf('Press \'Enter\' to serve the ball!', 0, 32, VIRTUAL_WIDTH, 'center')
    end

    -- Printing victory when a winner is declared
    if self.game.roundState == 'done' then
        
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
    love.graphics.setFont(scoreFont)
    love.graphics.printf(tostring(self.game.player1Score), 0, 20, VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf(tostring(self.game.player2Score), VIRTUAL_WIDTH / 2, 20, VIRTUAL_WIDTH / 2, 'center')

    -- Render Ball and Player Paddles
    self.ball:render()
    self.player1:render()
    self.player2:render()
end
