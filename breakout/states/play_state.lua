local BaseState = require("states.base_state")
local drawer = require("drawer")

local PlayState = BaseState.new()
PlayState.__index = PlayState

function PlayState.new(context)
	local ps = setmetatable({}, PlayState)
	return ps:init(context)
end

function PlayState:init(ctx)
	self.paused = false

	self.paddle = ctx.paddle
	self.ball = ctx.ball
	self.bricks = ctx.bricks
	self.health = ctx.health
	self.score = ctx.score

	self.ball.dx = math.random(-200, 200)
	self.ball.dy = math.random(-50, -60)

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
			self.score = self.score + 10

			-- Determine collision side by calculating overlap
			local ball_left, ball_right = self.ball.x, self.ball.x + self.ball.width
			local ball_top, ball_bottom = self.ball.y, self.ball.y + self.ball.height
			local brick_left, brick_right = brick.x, brick.x + brick.width
			local brick_top, brick_bottom = brick.y, brick.y + brick.height

			local overlap_left = ball_right - brick_left
			local overlap_right = brick_right - ball_left
			local overlap_top = ball_bottom - brick_top
			local overlap_bottom = brick_bottom - ball_top

			local min_overlap = math.min(overlap_left, overlap_right, overlap_top, overlap_bottom)

			if min_overlap == overlap_left then
				self.ball.dx = -math.abs(self.ball.dx)
				self.ball.x = brick_left - self.ball.width
			elseif min_overlap == overlap_right then
				self.ball.dx = math.abs(self.ball.dx)
				self.ball.x = brick_right
			elseif min_overlap == overlap_top then
				self.ball.dy = -math.abs(self.ball.dy)
				self.ball.y = brick_top - self.ball.height
			elseif min_overlap == overlap_bottom then
				self.ball.dy = math.abs(self.ball.dy)
				self.ball.y = brick_bottom
			end

			-- Slowly increase game speed
			self.ball.dy = self.ball.dy * 1.02

			-- Prevent colliding with more than one brick
			break
		end
	end

	if self.ball.y >= G.WINDOW.VIRTUAL.HEIGHT then
		self.health = self.health - 1
		G.SOUNDS.HURT:play()

		if self.health == 0 then
			G.StateMachine:change("gameover", { score = self.score })
		else
			G.StateMachine:change("serve", {
				paddle = self.paddle,
				bricks = self.bricks,
				health = self.health,
				score = self.score,
			})
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

	drawer.draw_score(self.score)
	drawer.draw_health(self.health)

	if self.paused then
		love.graphics.setFont(G.FONTS.LARGE)
		love.graphics.printf("PAUSED", 0, G.WINDOW.VIRTUAL.HEIGHT / 2 - 16, G.WINDOW.VIRTUAL.WIDTH, "center")
	end
end

return PlayState
