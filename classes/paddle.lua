--[[
    The Paddle class
]]
Paddle = Class{}

--[[
    Constructor
]]
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

-- if love.keyboard.isDown('w') then
--     y = y + -PADDLE_SPEED * dt
-- elseif love.keyboard.isDown('s') then
--     y = y + PADDLE_SPEED * dt
-- end

--[[
    This method will update the position of our paddle
    `dt` is the delta time given by Love2D's update method
]]
function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

--[[
    Render method for the Paddle
]]
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
