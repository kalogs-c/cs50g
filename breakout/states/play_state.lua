local BaseState = require("states.base_state")
local Paddle = require("entities.paddle")

local PlayState = BaseState.new()
PlayState.__index = PlayState

function PlayState.new()
	local ps = setmetatable({}, PlayState)
	return ps:init()
end

function PlayState:init()
	self.paddle = Paddle.new()
	self.paused = false

	return self
end

function PlayState:update(dt)
	if self.paused then
		if love.keyboard.wasPressed("backspace") then
			self.paused = false
			G.SOUNDS.PAUSE:play()
		else
			return
		end
	elseif love.keyboard.wasPressed("backspace") then
		self.paused = true
		G.SOUNDS.PAUSE:play()
		return
	end

	self.paddle:update(dt)

	if love.keyboard.wasPressed("escape") then
		love.event.quit()
	end
end

function PlayState:draw()
	self.paddle:draw()

	if self.paused then
		love.graphics.setFont(G.FONTS.LARGE)
		love.graphics.printf("PAUSED", 0, G.WINDOW.VIRTUAL.HEIGHT / 2 - 16, G.WINDOW.VIRTUAL.WIDTH, "center")
	end
end

return PlayState
