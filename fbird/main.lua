require 'conf'
require 'entities.Bird'
require 'entities.Pipe'
require 'entities.PipePair'

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
  timer = 0,
  previousY = -Pipe.getHeight() + math.random(20, Pipe.getHeight() / 2),
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
  if PipePair.canSpawn(pipe_manager) then
    local tooHighBaseCase = -Pipe.getHeight() + 40
    local tooLowBaseCase = WINDOW.VIRTUAL.HEIGHT - PipePair.getGap() - Pipe.getHeight() - 50
    local targetY = math.min(
      pipe_manager.previousY + math.random(-50, 50),
      tooLowBaseCase
    )
    local y = math.max(tooHighBaseCase, targetY)
    pipe_manager.previousY = y

    table.insert(pipe_manager.pipes, PipePair.new(y))
    pipe_manager.timer = 0
  end

  bird:update(dt)
  for _, pair in pairs(pipe_manager.pipes) do
    pair:update(dt)
  end

  for k, pair in pairs(pipe_manager.pipes) do
    if pair:canDestroy() then
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
