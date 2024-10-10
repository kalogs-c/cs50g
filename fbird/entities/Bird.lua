Bird = {}
Bird.__index = Bird

local GRAVITY = 10
local HITBOX_SHRINK_SCALE = 4

function Bird.new()
  local bird = setmetatable({}, Bird)
  return bird:init()
end

function Bird:init()
  self.image = love.graphics.newImage('assets/images/bird.png')
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.x = WINDOW.VIRTUAL.WIDTH / 2 - (self.width / 2)
  self.y = WINDOW.VIRTUAL.HEIGHT / 2 - (self.height / 2)
  self.dy = 0 

  return self
end

function Bird:update(dt)
  self.dy = self.dy + GRAVITY * dt

  if love.keyboard.wasPressed('up') then
    self.dy = -1.25
    sounds.jump:play()
  end

  self.y = self.y + self.dy
end

function Bird:draw()
  love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pipe)
  local hitbox = self:getHitbox(HITBOX_SHRINK_SCALE)

  if hitbox.x + hitbox.width > pipe.x and hitbox.x < pipe.x + pipe.width then
    if pipe.orientation == "top" then
      return hitbox.y < pipe.y + pipe.height
    else
      return hitbox.y + hitbox.height > pipe.y
    end
  end

  return false
end

function Bird:getHitbox(shrink_scale)
  local hitbox = {
    x = self.x + shrink_scale,
    y = self.y + shrink_scale,
    width = self.width - shrink_scale * 2,
    height = self.height - shrink_scale * 2,
  }

  return hitbox
end