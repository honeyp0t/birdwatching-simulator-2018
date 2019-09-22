require("SpriteAnimation")

Sprite = {}
Sprite.__index = Sprite
Sprite.new = function(image)
    local self = {}
    setmetatable(self, Sprite)

    self.animations = {}
    self.currentAnimation = nil
    self.image = image
    self.speed = 1

    function self.update(self, dt)
        self.currentAnimation:update(dt * self.speed)
    end

    function self.getQuad()
        return self.currentAnimation:getQuad()
    end

    return self
end