TitleScreenState = BaseState.new()
TitleScreenState.__index = TitleScreenState

function TitleScreenState.new()
	return setmetatable({}, TitleScreenState)
end

function TitleScreenState:update(dt)
	if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
		gstatemachine:change("countdown")
	end
end

function TitleScreenState:draw()
	love.graphics.setFont(fonts.flappy)
	love.graphics.printf("F Bird", 0, 64, WINDOW.VIRTUAL.WIDTH, "center")

	love.graphics.setFont(fonts.flappy)
	love.graphics.printf("Press Enter", 0, 100, WINDOW.VIRTUAL.WIDTH, "center")
end

