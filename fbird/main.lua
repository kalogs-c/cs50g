require 'conf'
require 'entities.Bird'
require 'entities.Pipe'

local push = require 'vendor.push'

local background = {
  image = love.graphics.newImage('assets/images/background.png'),
  scroll = 0,
  scroll_speed = 30,
  loopingPoint = 413
}

local ground = {
  image = love.graphics.newImage('assets/images/ground.png'),
  scroll = 0,
  scroll_speed = 60,
}

local bird = Bird.new()
local pipe_manager = {
  pipes = {},
  timer = 0
}

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.window.setTitle(WINDOW.TITLE)

  push:setupScreen(
    WINDOW.VIRTUAL.WIDTH,
    WINDOW.VIRTUAL.HEIGHT,
    WINDOW.WIDTH,
    WINDOW.HEIGHT,
    {
      vsync = true,
      fullscreen = false,
      resizable = true
    }
  )

  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
  if love.keyboard.keysPressed[key] then
    return true
  else
    return false
  end
end

function love.update(dt)
  background.scroll = (background.scroll + background.scroll_speed * dt) % background.loopingPoint
  ground.scroll = (ground.scroll + ground.scroll_speed * dt) % WINDOW.VIRTUAL.HEIGHT

  pipe_manager.timer = pipe_manager.timer + dt
  if pipe_manager.timer > 2.5 then
    table.insert(pipe_manager.pipes, Pipe.new())
    pipe_manager.timer = 0
  end

  bird:update(dt)
  for k, pipe in pairs(pipe_manager.pipes) do
    pipe:update(dt)

    if pipe:canDestroy() then
      table.remove(pipe_manager.pipes, k)
    end
  end

  love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background.image, -background.scroll, 0)
    bird:draw()
    for _, pipe in pairs(pipe_manager.pipes) do
      pipe:draw()
    end
    love.graphics.draw(ground.image, -ground.scroll, WINDOW.VIRTUAL.HEIGHT - 16)

    push:finish()
end
