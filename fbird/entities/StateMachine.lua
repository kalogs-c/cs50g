StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new(states)
    local sm = setmetatable({}, StateMachine)
    return sm:init(states)
end

function StateMachine:init(states)
    local empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }

    self.states = states or {}
    self.current = empty

    return self
end

function StateMachine:change(state, context)
    assert(self.states[state])
    self.current:exit()
    self.current = self.states[state]()
    self.current:enter(context)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:draw()
    self.current:draw()
end