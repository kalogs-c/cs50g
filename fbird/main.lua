require 'conf'
require 'entities.Bird'
require 'entities.Pipe'
require 'entities.PipePair'
require 'entities.StateMachine'
require 'states.BaseState'
require 'states.TitleScreenState'
require 'states.CountdownState'
require 'states.PlayState'
require 'states.ScoreState'

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

  fonts = {
    small = love.graphics.newFont('assets/fonts/font.ttf', 8),
    medium = love.graphics.newFont('assets/fonts/flappy.ttf', 14),
    huge = love.graphics.newFont('assets/fonts/flappy.ttf', 56),
    flappy = love.graphics.newFont('assets/fonts/flappy.ttf', 28),
  }
  love.graphics.setFont(fonts.flappy)

  sounds = {
    jump = love.audio.newSource('assets/sounds/jump.wav', 'static'),
    explosion = love.audio.newSource('assets/sounds/explosion.wav', 'static'),
    hurt = love.audio.newSource('assets/sounds/hurt.wav', 'static'),
    score = love.audio.newSource('assets/sounds/score.wav', 'static'),
    music = love.audio.newSource('assets/sounds/music.mp3', 'static'),
  }
  sounds.music:setLooping(true)
  sounds.music:play()

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

  gstatemachine = StateMachine.new {
    ['title'] = TitleScreenState.new,
    ['countdown'] = CountdownState.new,
    ['play'] = PlayState.new,
    ['score'] = ScoreState.new,
  }
  gstatemachine:change('title')

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
  gstatemachine:update(dt)

  love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background.image, -background.scroll, 0)
    gstatemachine:draw()
    love.graphics.draw(ground.image, -ground.scroll, WINDOW.VIRTUAL.HEIGHT - 16)

    push:finish()
end
