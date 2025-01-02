local BaseState = require("states.base_state")
local level_maker = require("level_maker")
local drawer = require("drawer")

local VictoryState = BaseState.new()
VictoryState.__index = VictoryState

function VictoryState.new(context)
	local vs = setmetatable({}, VictoryState)
	return vs:init(context)
end

function VictoryState:init(ctx)
	self.score = ctx.score
	self.paddle = ctx.paddle
	self.ball = ctx.ball
	self.health = ctx.health
	self.level = ctx.level
	self.highscores = ctx.highscores

	return self
end

function VictoryState:update(dt)
	self.paddle:update(dt)
	self.ball:followPaddle(self.paddle)

	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		local next_level = self.level + 1
		G.StateMachine:change("serve", {
			level = next_level,
			bricks = level_maker.create_bricks(next_level),
			paddle = self.paddle,
			health = self.health,
			score = self.score,
			highscores = self.highscores,
		})
	end

	if love.keyboard.wasPressed("escape") then
		love.event.quit()
	end
end

function VictoryState:draw()
	self.paddle:draw()
	self.ball:draw()

	drawer.draw_score(self.score)
	drawer.draw_health(self.health)

	love.graphics.setFont(G.FONTS.LARGE)
	love.graphics.printf(
		"Level " .. tostring(self.level) .. " complete!",
		0,
		G.WINDOW.VIRTUAL.HEIGHT / 4,
		G.WINDOW.VIRTUAL.WIDTH,
		"center"
	)

	love.graphics.setFont(G.FONTS.MEDIUM)
	love.graphics.printf("Press Enter to serve!", 0, G.WINDOW.VIRTUAL.HEIGHT / 2, G.WINDOW.VIRTUAL.WIDTH, "center")
end

return VictoryState
