ScoreState = BaseState.new()
ScoreState.__index = ScoreState 

function ScoreState.new()
    return setmetatable({}, ScoreState)
end

function ScoreState:enter(context)
    self.score = context.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gstatemachine:change('countdown')
    end
end

function ScoreState:draw()
    love.graphics.setFont(fonts.flappy)
    love.graphics.printf('Oops! You lost!', 0, 64, WINDOW.VIRTUAL.WIDTH, 'center')

    love.graphics.setFont(fonts.medium)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, WINDOW.VIRTUAL.WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, WINDOW.VIRTUAL.WIDTH, 'center')
end