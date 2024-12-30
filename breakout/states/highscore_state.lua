local BaseState = require("states.base_state")

local HighscoreState = BaseState.new()
HighscoreState.__index = HighscoreState

function HighscoreState.new(context)
	local hss = setmetatable({}, HighscoreState)
	return hss:init(context)
end

function HighscoreState:init(ctx)
	self.highscores = ctx.highscores

	return self
end

function HighscoreState:update(dt)
	if love.keyboard.wasPressed("escape") then
		G.SOUNDS.WALL_HIT:play()
		G.StateMachine:change("start", {
			highscores = self.highscores,
		})
	end
end

function HighscoreState:draw()
	love.graphics.setFont(G.FONTS.LARGE)
	love.graphics.printf("High Scores", 0, 20, G.WINDOW.VIRTUAL.WIDTH, "center")

	love.graphics.setFont(G.FONTS.MEDIUM)
	for i, score in pairs(self.highscores) do
		-- score number
		love.graphics.printf(tostring(i) .. ".", G.WINDOW.VIRTUAL.WIDTH / 4, 60 + i * 13, 50, "left")

		-- score name
		love.graphics.printf(score.name, G.WINDOW.VIRTUAL.WIDTH / 4 + 38, 60 + i * 13, 50, "right")

		-- score itself
		love.graphics.printf(tostring(score.score), G.WINDOW.VIRTUAL.WIDTH / 2, 60 + i * 13, 100, "right")
	end

	love.graphics.setFont(G.FONTS.SMALL)
	love.graphics.printf(
		"Press Escape to return to the main menu",
		0,
		G.WINDOW.VIRTUAL.HEIGHT - 18,
		G.WINDOW.VIRTUAL.WIDTH,
		"center"
	)
end

return HighscoreState
