local BaseState = require("states.base_state")
local level_maker = require("level_maker")
local Paddle = require("entities.paddle")

local PaddleSelectState = BaseState.new()
PaddleSelectState.__index = PaddleSelectState

function PaddleSelectState.new(context)
	local pss = setmetatable({}, PaddleSelectState)
	return pss:init(context)
end

function PaddleSelectState:init(ctx)
	self.highscores = ctx.highscores
	self.curr_paddle = 1

	return self
end

function PaddleSelectState:update(dt)
	if love.keyboard.wasPressed("left") then
		if self.curr_paddle == 1 then
			G.SOUNDS.NO_SELECT:play()
		else
			G.SOUNDS.SELECT:play()
			self.curr_paddle = self.curr_paddle - 1
		end
	end

	if love.keyboard.wasPressed("right") then
		if self.curr_paddle == 4 then
			G.SOUNDS.NO_SELECT:play()
		else
			G.SOUNDS.SELECT:play()
			self.curr_paddle = self.curr_paddle + 1
		end
	end

	if love.keyboard.wasPressed("return") or love.keyboard.wasPressed("space") or love.keyboard.wasPressed("enter") then
		G.SOUNDS.CONFIRM:play()
		G.StateMachine:change("serve", {
			paddle = Paddle.new(self.curr_paddle),
			level = 1,
			bricks = level_maker.create_bricks(1),
			health = 3,
			score = 0,
			highscores = self.highscores,
		})
	end

	if love.keyboard.wasPressed("escape") then
		love.event.quit()
	end
end

function PaddleSelectState:draw()
	love.graphics.setFont(G.FONTS.MEDIUM)
	love.graphics.printf("Select your paddle", 0, G.WINDOW.VIRTUAL.HEIGHT / 4, G.WINDOW.VIRTUAL.WIDTH, "center")

	if self.curr_paddle == 1 then
		love.graphics.setColor(40 / 255, 40 / 255, 40 / 255, 128 / 255)
	end

	love.graphics.draw(
		G.TEXTURES.ARROWS,
		G.FRAMES.ARROWS[1],
		G.WINDOW.VIRTUAL.WIDTH / 4 - 24,
		G.WINDOW.VIRTUAL.HEIGHT - G.WINDOW.VIRTUAL.HEIGHT / 3
	)

	love.graphics.setColor(1, 1, 1, 1)

	if self.curr_paddle == 4 then
		love.graphics.setColor(40 / 255, 40 / 255, 40 / 255, 128 / 255)
	end

	love.graphics.draw(
		G.TEXTURES.ARROWS,
		G.FRAMES.ARROWS[2],
		G.WINDOW.VIRTUAL.WIDTH - G.WINDOW.VIRTUAL.WIDTH / 4 - 24,
		G.WINDOW.VIRTUAL.HEIGHT - G.WINDOW.VIRTUAL.HEIGHT / 3
	)

	love.graphics.setColor(1, 1, 1, 1)

	love.graphics.draw(
		G.TEXTURES.BREAKOUT,
		G.FRAMES.PADDLES[2 + 4 * (self.curr_paddle - 1)],
		G.WINDOW.VIRTUAL.WIDTH / 2 - 32,
		G.WINDOW.VIRTUAL.HEIGHT - G.WINDOW.VIRTUAL.HEIGHT / 3
	)
end

return PaddleSelectState
