local BaseState = require("states.base_state")
local Ball = require("entities.ball")
local drawer = require("drawer")

local ServeState = BaseState.new()
ServeState.__index = ServeState

function ServeState.new(context)
	local ss = setmetatable({}, ServeState)
	return ss:init(context)
end

function ServeState:init(ctx)
	self.paddle = ctx.paddle
	self.bricks = ctx.bricks
	self.health = ctx.health
	self.score = ctx.score
	self.level = ctx.level

	self.ball = Ball.new({
		x = G.WINDOW.VIRTUAL.WIDTH / 2 - 4,
		y = G.WINDOW.VIRTUAL.HEIGHT / 2 - 4,
		dx = math.random(-200, 200),
		dy = math.random(-50, -60),
		skin = math.random(7),
	})

	return self
end

function ServeState:update(dt)
	self.paddle:update(dt)
	self.ball:followPaddle(self.paddle)

	if love.keyboard.wasPressed("space") or love.keyboard.wasPressed("return") then
		G.StateMachine:change("play", {
			paddle = self.paddle,
			ball = self.ball,
			bricks = self.bricks,
			health = self.health,
			score = self.score,
			level = self.level,
		})
	end

	if love.keyboard.wasPressed("escape") then
		love.event.quit()
	end
end

function ServeState:draw()
	self.paddle:draw()
	self.ball:draw()

	for _, brick in pairs(self.bricks) do
		brick:draw()
	end

	drawer.draw_score(self.score)
	drawer.draw_health(self.health)
	drawer.draw_level(self.level)

	love.graphics.setFont(G.FONTS.MEDIUM)
	love.graphics.printf("Press Enter to serve", 0, G.WINDOW.VIRTUAL.HEIGHT / 2 - 16, G.WINDOW.VIRTUAL.WIDTH, "center")
end

return ServeState
