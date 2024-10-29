local BaseState = require("states.base_state")

local StartState = BaseState.new()
StartState.__index = StartState

function StartState.new()
	local ss = setmetatable({}, StartState)
	return ss:init()
end

function StartState:init()
	self.menu_options = { "START", "HIGH SCORES" }
	self.highlighted = 1

	return self
end

function StartState:update(dt)
	if love.keyboard.wasPressed("up") or love.keyboard.wasPressed("down") then
		G.SOUNDS.PADDLE_HIT:play()
	end

	if love.keyboard.wasPressed("up") and self.highlighted > 1 then
		self.highlighted = self.highlighted - 1
	end
	if love.keyboard.wasPressed("down") and self.highlighted < #self.menu_options then
		self.highlighted = self.highlighted + 1
	end

	if love.keyboard.wasPressed("return") or love.keyboard.wasPressed("space") then
		G.SOUNDS.CONFIRM:play()

		if self.highlighted == 1 then
			G.StateMachine:change("play")
		end
	end

	if love.keyboard.wasPressed("escape") then
		love.event.quit()
	end
end

function StartState:draw()
	-- Title
	love.graphics.setFont(G.FONTS.LARGE)
	love.graphics.printf("BREAKOUT", 0, G.WINDOW.VIRTUAL.HEIGHT / 3, G.WINDOW.VIRTUAL.WIDTH, "center")

	-- Options
	love.graphics.setFont(G.FONTS.MEDIUM)
	for i, menu in ipairs(self.menu_options) do
		if self.highlighted == i then
			love.graphics.setColor(103 / 255, 1, 1, 1)
		end
		love.graphics.printf(menu, 0, G.WINDOW.VIRTUAL.HEIGHT / 2 + 60 + 20 * (i - 1), G.WINDOW.VIRTUAL.WIDTH, "center")

		-- reset the color
		love.graphics.setColor(1, 1, 1, 1)
	end
end

return StartState
