bird1 = love.graphics.newImage('bird1.png');

Whitebird = {}
Whitebird.__index = Whitebird
Whitebird.new = function(x, y) 
    local self = {}
    setmetatable(self, Whitebird)

    local frames = {}

    frames[1] = love.graphics.newQuad(0,0,33,35,bird1:getDimensions())
    frames[2] = love.graphics.newQuad(33,0,33,35,bird1:getDimensions())
    frames[3] = love.graphics.newQuad(66,0,33,35,bird1:getDimensions())

    self.frameIndex = 1
    self.posX = x
    self.speedX = 100
    self.posY = y
    self.image = bird1
    self.frame = frames[1]
    
    function self:fly(dt)
        self.frameIndex = self.frameIndex + 1 * dt * 4
        self.frame = frames[(math.floor(self.frameIndex) % 2) + 1]
        self.posX = self.posX - (self.speedX * dt)
    end

    return self
end