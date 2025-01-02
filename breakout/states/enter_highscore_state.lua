local BaseState = require("states.base_state")

local EnterHighscoreState = BaseState.new()
EnterHighscoreState.__index = EnterHighscoreState

function EnterHighscoreState.new(context)
	local ehss = setmetatable({}, EnterHighscoreState)
	return ehss:init(context)
end

function EnterHighscoreState:init(ctx)
	self.highscores = ctx.highscores
	self.score = ctx.score
	self.score_index = ctx.score_index
	self.chars = { 65, 65, 65 }
	self.highlighted = 1

	return self
end

function EnterHighscoreState:update(dt)
	local char_selected = self.chars[self.highlighted]

	if love.keyboard.wasPressed("up") then
		G.SOUNDS.PADDLE_HIT:play()
		self.chars[self.highlighted] = char_selected + 1
	end

	if love.keyboard.wasPressed("down") then
		G.SOUNDS.PADDLE_HIT:play()
		self.chars[self.highlighted] = char_selected - 1
	end

	if self.chars[self.highlighted] > 90 then
		self.chars[self.highlighted] = 65
	elseif self.chars[self.highlighted] < 65 then
		self.chars[self.highlighted] = 90
	end

	if love.keyboard.wasPressed("left") and self.highlighted > 1 then
		self.highlighted = self.highlighted - 1
	end
	if love.keyboard.wasPressed("right") and self.highlighted < #self.chars then
		self.highlighted = self.highlighted + 1
	end

	if love.keyboard.wasPressed("return") or love.keyboard.wasPressed("space") then
		G.SOUNDS.CONFIRM:play()

		local name = ""
		for _, c in pairs(self.chars) do
			name = name .. string.char(c)
		end

		for i = 10, self.score_index, -1 do
			self.highscores[i + 1] = {
				name = self.highscores[i].name,
				score = self.highscores[i].score,
			}
		end

		self.highscores[self.score_index] = {
			name = name,
			score = self.score,
		}

		local scores = ""
		for i = 1, 10 do
			scores = scores .. self.highscores[i].name .. "\t" .. self.highscores[i].score .. "\n"
		end

		love.filesystem.write("breakout.lst", scores)
		G.StateMachine:change("highscores", {
			highscores = self.highscores,
		})
	end

	if love.keyboard.wasPressed("escape") then
		love.event.quit()
	end
end

function EnterHighscoreState:draw()
	love.graphics.setFont(G.FONTS.MEDIUM)
	love.graphics.printf("Your score was " .. tostring(self.score), 0, 30, G.WINDOW.VIRTUAL.WIDTH, "center")

	love.graphics.setFont(G.FONTS.LARGE)
	for i, c in pairs(self.chars) do
		if i == self.highlighted then
			love.graphics.setColor(103 / 255, 1, 1, 1)
		end

		love.graphics.print(
			string.char(c),
			G.WINDOW.VIRTUAL.WIDTH / 2 - 28 + (18 * (i - 1)),
			G.WINDOW.VIRTUAL.HEIGHT / 2
		)

		-- Reset color
		love.graphics.setColor(1, 1, 1, 1)
	end

	love.graphics.setFont(G.FONTS.SMALL)
	love.graphics.printf("Press Enter to confirm!", 0, G.WINDOW.VIRTUAL.HEIGHT - 1, G.WINDOW.VIRTUAL.WIDTH, "center")
end

return EnterHighscoreState
