CountdownState = BaseState.new()
CountdownState.__index = CountdownState

local COUNTDOWN_TIME = 0.75

function CountdownState.new()
    local cs = setmetatable({}, CountdownState)
    return cs:init()
end

function CountdownState:init()
    self.count = 3
    self.timer = 0

    return self
end

function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > COUNTDOWN_TIME then
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then
            gstatemachine:change('play')
        end
    end
end

function CountdownState:draw()
    love.graphics.setFont(fonts.huge)
    love.graphics.printf(tostring(self.count), 0, 120, WINDOW.VIRTUAL.WIDTH, 'center')
end