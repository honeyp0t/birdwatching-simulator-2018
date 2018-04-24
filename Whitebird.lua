math.randomseed(os.time())

Whitebird = {}
Whitebird.__index = Whitebird
Whitebird.new = function(x, y) 
    local self = {}
    setmetatable(self, Whitebird)

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
    
    function self:fly(dt)
        self.frameIndex = self.frameIndex + 1 * dt * 4
        self.frame = frames[(math.floor(self.frameIndex) % 2) + 1]
        self.posX = self.posX - (self.speedX * dt)
    end

    return self
end