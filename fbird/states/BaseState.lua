BaseState = {}
BaseState.__index = BaseState

function BaseState.new()
	return setmetatable({}, BaseState)
end

function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:draw() end

