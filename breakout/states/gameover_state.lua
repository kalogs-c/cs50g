local BaseState = require("states.base_state")

local GameOverState = BaseState.new()
GameOverState.__index = GameOverState

function GameOverState.new(context)
	local ss = setmetatable({}, GameOverState)
	return ss:init(context)
end

function GameOverState:init(ctx)
	self.score = ctx.score

	return self
end

function GameOverState:update(dt)
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		G.StateMachine:change("start")
	end

	if love.keyboard.wasPressed("escape") then
		love.event.quit()
	end
end

function GameOverState:draw()
	love.graphics.setFont(G.FONTS.LARGE)
	love.graphics.printf("GAME OVER", 0, G.WINDOW.VIRTUAL.HEIGHT / 2 - 16, G.WINDOW.VIRTUAL.WIDTH, "center")
	love.graphics.setFont(G.FONTS.MEDIUM)
	love.graphics.printf("SCORE: " .. self.score, 0, G.WINDOW.VIRTUAL.HEIGHT / 2 + 16, G.WINDOW.VIRTUAL.WIDTH, "center")
	love.graphics.printf(
		"PRESS ENTER TO PLAY AGAIN",
		0,
		G.WINDOW.VIRTUAL.HEIGHT / 2 + 60,
		G.WINDOW.VIRTUAL.WIDTH,
		"center"
	)
end

return GameOverState
