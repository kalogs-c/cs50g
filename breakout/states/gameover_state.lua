local BaseState = require("states.base_state")

local GameOverState = BaseState.new()
GameOverState.__index = GameOverState

function GameOverState.new(context)
	local gos = setmetatable({}, GameOverState)
	return gos:init(context)
end

function GameOverState:init(ctx)
	self.score = ctx.score
	self.highscores = ctx.highscores

	return self
end

function GameOverState:update(dt)
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		local highscore = false
		local score_index = 11

		for i = 10, 1, -1 do
			local score = self.highscores[i].score or 0
			if self.score > score then
				score_index = i
				highscore = true
			end
		end

		if highscore then
			G.SOUNDS.HIGH_SCORE:play()
			G.StateMachine:change("enter_highscore", {
				highscores = self.highscores,
				score = self.score,
				score_index = score_index,
			})
		else
			G.StateMachine:change("start", {
				highscores = self.highscores,
			})
		end
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
