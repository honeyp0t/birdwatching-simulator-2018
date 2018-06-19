math.randomseed(os.time())

Bird = {}
Bird.__index = Bird
Bird.new = function(x, y) 
    local self = {}
    setmetatable(self, Bird)

    local frames = {}

    local birdIndex = math.random(1, 2)

    local birbs = {
        love.graphics.newImage('assets/bird1.png'),
        love.graphics.newImage('assets/bird2.png')
    }

    frames[1] = love.graphics.newQuad(0,0,33,35,birbs[birdIndex]:getDimensions())
    frames[2] = love.graphics.newQuad(33,0,33,35,birbs[birdIndex]:getDimensions())
    frames[3] = love.graphics.newQuad(66,0,33,35,birbs[birdIndex]:getDimensions())

    
    self.frameIndex = 1
    self.posX = x
    self.speedX = math.random(60, 300)
    self.posY = y
    self.image = birbs[birdIndex]
    self.frame = frames[1]

    if (x > 0) then
        self.speedX = math.random(60, 300)
    else
        self.speedX = math.random(-60, -300)
    end
    
    function self:fly(dt)
        self.frameIndex = self.frameIndex + 1 * dt * 4
        self.frame = frames[(math.floor(self.frameIndex) % 2) + 1]
        self.posX = self.posX - (self.speedX * dt)
    end

    return self
end