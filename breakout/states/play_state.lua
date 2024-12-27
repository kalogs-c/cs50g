local BaseState = require("states.base_state")
local Paddle = require("entities.paddle")
local Ball = require("entities.ball")
local level_maker = require("level_maker")

local PlayState = BaseState.new()
PlayState.__index = PlayState

function PlayState.new()
	local ps = setmetatable({}, PlayState)
	return ps:init()
end

function PlayState:init()
	self.paused = false

	self.paddle = Paddle.new()
	self.ball = Ball.new({
		x = G.WINDOW.VIRTUAL.WIDTH / 2 - 4,
		y = G.WINDOW.VIRTUAL.HEIGHT / 2 - 4,
		dx = math.random(-200, 200),
		dy = math.random(-50, -60),
		skin = 1,
	})

	self.bricks = level_maker.create_bricks()

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
	self.ball:update(dt)

	if self.ball:collides(self.paddle) then
		self.ball.y = self.paddle.y - self.ball.height
		self.ball.dy = -self.ball.dy

		if self.ball.x < self.paddle.x + self.paddle.width / 2 and self.paddle.dx < 0 then
			self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
		elseif self.ball.x > self.paddle.x + self.paddle.width / 2 and self.paddle.dx > 0 then
			self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
		end

		G.SOUNDS.PADDLE_HIT:play()
	end

	for _, brick in pairs(self.bricks) do
		if brick.in_scene and self.ball:collides(brick) then
			brick:hit()

			-- Left corner collision
			if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
				self.ball.dx = -self.ball.dx
				self.ball.x = brick.x - self.ball.height

			-- Right corner collision
			elseif self.ball.x + 5 < brick.x + brick.width and self.ball.dx < 0 then
				self.ball.dx = -self.ball.dx
				self.ball.x = brick.x + brick.width

			-- Top collision
			elseif self.ball.y < brick.y then
				self.ball.dy = -self.ball.dy
				self.ball.y = brick.y - self.ball.height

			-- Bottom collision
			else
				self.ball.dy = -self.ball.dy
				self.ball.y = brick.y + brick.height
			end

			-- Slowly increase game speed
			self.ball.dy = self.ball.dy * 1.02

			-- Prevent colliding with more than one brick
			break
		end
	end

	if love.keyboard.wasPressed("escape") then
		love.event.quit()
	end
end

function PlayState:draw()
	for _, brick in pairs(self.bricks) do
		brick:draw()
	end

	self.paddle:draw()
	self.ball:draw()

	if self.paused then
		love.graphics.setFont(G.FONTS.LARGE)
		love.graphics.printf("PAUSED", 0, G.WINDOW.VIRTUAL.HEIGHT / 2 - 16, G.WINDOW.VIRTUAL.WIDTH, "center")
	end
end

return PlayState
