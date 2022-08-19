--[[
    The Title Screen State

    Contains methods to render the title screen at the start of the game
]]

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
    self.optionSelect = 0
end

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if self.optionSelect == 0 then
        elseif self.optionSelect == 1 then
        end
    end

    if love.keyboard.wasPressed('up') then
        self.optionSelect = math.max(0, self.optionSelect - 1)
    elseif love.keyboard.wasPressed('down') then
        self.optionSelect = math.min(1, self.optionSelect + 1)
    end
end

function TitleScreenState:render()
    love.graphics.setFont(titleFont)
    love.graphics.printf('Pong!', 0, 30, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(smallFont)
    love.graphics.printf('>', 180, VIRTUAL_HEIGHT / 2 + self.optionSelect * 10, VIRTUAL_WIDTH)
    love.graphics.printf('Single Player', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Two Player', 0, VIRTUAL_HEIGHT / 2 + 10, VIRTUAL_WIDTH, 'center')
end
