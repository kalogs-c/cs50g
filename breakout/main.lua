require("globals")
local setup = require("setup")
local push = require("vendor.push")
local save_manager = require("save_manager")

function love.load()
	math.randomseed(os.time())
	love.keyboard.keysPressed = {}
	G.StateMachine:change("start", {
		highscores = save_manager.load_highscores(),
	})
	G.SOUNDS.MUSIC:play()
	G.SOUNDS.MUSIC:setLooping(true)
	love.graphics.setFont(G.FONTS.SMALL)
	setup.screen()
end

function love.update(dt)
	G.StateMachine:update(dt)
	love.keyboard.keysPressed = {}
end

function love.draw()
	push:apply("start")

	local background = {
		width = G.TEXTURES.BACKGROUND:getWidth(),
		height = G.TEXTURES.BACKGROUND:getHeight(),
		texture = G.TEXTURES.BACKGROUND,
	}
	love.graphics.draw(
		background.texture,
		0,
		0,
		0,
		G.WINDOW.VIRTUAL.WIDTH / (background.width - 1),
		G.WINDOW.VIRTUAL.HEIGHT / (background.height - 1)
	)

	G.StateMachine:draw()

	setup.show_fps()
	push:apply("end")
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end
