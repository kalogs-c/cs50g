local BaseState = {}
BaseState.__index = BaseState

function BaseState.new()
    return setmetatable({}, BaseState)
end

function BaseState:update(dt) end
function BaseState:draw() end
function BaseState:exit() end

return BaseState