--[[
    Processes the user input during game runtime
]]
function processPlayerInput(player1, player2)
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
end

--[[
    Detects collisions for the ball
]]
function detectBallCollisions(player1, player2, ball)
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
function scoredPoint(player1, player2, ball)
    if ball.x <= 0 or ball.x >= VIRTUAL_WIDTH then
        return true
    end

    -- TODO: Add scoring logic here and maybe some gamestate changes
    return false
end
