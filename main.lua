-- Library/class imports
push = require 'lib/push'
Class = require 'lib/class'
require 'assets/Paddle'
require 'assets/Ball'
require 'assets/Game'
require 'lib/StateMachine'
require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/TwoPlayerGameState'

-- Window Dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[
    Constructor
]]
function love.load()
    love.window.setTitle('Pong Game')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    -- initialize fonts
    smallFont = love.graphics.newFont('fonts/retro_gaming.ttf', 8)
    titleFont = love.graphics.newFont('fonts/retro_gaming.ttf', 48)
    menuOptionFont = love.graphics.newFont('fonts/retro_gaming.ttf', 10)
    victoryFont = love.graphics.newFont('fonts/retro_gaming.ttf', 20)
    scoreFont = love.graphics.newFont('fonts/retro_gaming.ttf', 32)


    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['twoPlayerGame'] = function() return TwoPlayerGameState() end
    }
    gStateMachine:change('title')

    -- initializes our virtual resolution within our window no matter what the
    -- dimenstions are and replaces love.window.setMode
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- initialize input table
    love.keyboard.keysPressed = {}
end

--[[
    Allows player to resize the window size of the game
    The push library will maintain the virtual width and height
]]
function love.resize(w, h)
    push:resize(w, h)
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--[[
    Runs every frame, with `dt` passed in as our delta in seconds
]]
function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end


--[[
    Keyboard handling, called each frame
]]
function love.keypressed(key)
    -- terminates the application
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

--[[
    This function is called after every update
]]
function love.draw()
    -- begin rendering at virtual resolution
    push:start()

    gStateMachine:render()

    -- end rendering at virtual resolution
    push:finish()
end


--
-- Useful Generic Helper Methods
--
function getHorizontalCenteredWidth(object_width)
    return VIRTUAL_WIDTH / 2 - object_width / 2
end

function getVerticalCenteredHeight(object_height)
    return VIRTUAL_HEIGHT / 2 - object_height / 2
end
