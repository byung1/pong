--[[
    The Ball class
]]
Ball = Class{}

function Ball:init(width, height)
    self.x = getHorizontalCenteredWidth(width)
    self.y = getVerticalCenteredHeight(height)
    self.width = width
    self.height = height
    self:setVelocity()
end

function Ball:setVelocity()
    -- 2D velocity variables
    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)
end

--[[
    Bounces the ball to the opposite direction
]]
function Ball:bounce()
    self.dx = -self.dx * 1.03
    if self.dy < 0 then
        self.dy = -math.random(25, 150)
    else
        self.dy = math.random(25, 150)
    end
end

--[[
    Method that checks if the ball has collided with a paddle
]]
function Ball:collides(paddle)
    -- first, check to see if the left edge of either
    -- is farther to the right than the right edge of the other
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either 
    -- is higher than the top edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    This method will reset the position of the ball to the center of the screen
]]
function Ball:reset()
    self.x = getHorizontalCenteredWidth(self.width)
    self.y = getVerticalCenteredHeight(self.height)
    self:setVelocity()
end

--[[
    This method will update the position of the ball
    `dt` is the delta time given by Love2D's update method
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

--[[
    Render method for the Ball
]]
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
