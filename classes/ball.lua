--[[
    The Ball class
]]
Ball = Class{}

function getHorizontalCenteredWidth(object_width)
    return VIRTUAL_WIDTH / 2 - object_width / 2
end

function getVerticalCenteredHeight(object_height)
    return VIRTUAL_HEIGHT / 2 - object_height / 2
end

function Ball:init(width, height)
    self.x = getHorizontalCenteredWidth(width)
    self.y = getVerticalCenteredHeight(height)
    self.width = width
    self.height = height

    -- 2D velocity variables
    self.dx = math.random(-75, 75)
    self.dy = math.random(2) == 1 and -100 or 100
end

--[[
    This method will reset the position of the ball to the center of the screen
]]
function Ball:reset(dt)
    self.x = getHorizontalCenteredWidth(self.width)
    self.y = getVerticalCenteredHeight(self.height)
    self.dx = math.random(-50, 50)
    self.dy = math.random(2) == 1 and -100 or 100
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
