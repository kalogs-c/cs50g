local push = require("vendor.push")

function love.conf(t)
	t.console = true
end

local setup = {}

function setup.screen()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setTitle(G.WINDOW.TITLE)

	local push_config = {
		vsync = true,
		fullscreen = false,
		resizable = true,
	}
	push:setupScreen(G.WINDOW.VIRTUAL.WIDTH, G.WINDOW.VIRTUAL.HEIGHT, G.WINDOW.WIDTH, G.WINDOW.HEIGHT, push_config)
end

function setup.show_fps()
	love.graphics.setFont(G.FONTS.SMALL)
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 5, 5)
end

return setup
