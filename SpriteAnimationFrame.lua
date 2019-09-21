SpriteAnimationFrame = {}
SpriteAnimationFrame.__index = SpriteAnimationFrame
SpriteAnimationFrame.new = function(image, x, y, width, height, duration)
    local self = {}
    setmetatable(self, SpriteAnimationFrame)

    self.duration = duration
    self.image = image
    self.quad = love.graphics.newQuad(x, y, width, height, self.image:getDimensions())
    print(self.quad:getViewport())

    return self
end