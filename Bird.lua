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
    self.lastPhotographed = 999
    self.value = birdIndex

    if (x > 0) then
        self.speedX = math.random(60, 300)
    else
        self.speedX = math.random(-60, -300)
    end

    function self:getValue() 
        return self.value
    end

    function self:isPhotographed(dt)
        self.lastPhotographed = 0
    end

    function self:draw(dt) 
        love.graphics.draw(self.image, self.frame, self.posX, self.posY)
        local r, g, b, a = love.graphics.getColor()

        if self.lastPhotographed < 2 then
            local spriteMidPointExceptImLazy = 8
            local yellowWithAlpha = {
                1,
                1,
                102/255,
                1.5 - self.lastPhotographed
            }
            love.graphics.setColor(yellowWithAlpha)
            love.graphics.print(self:getValue(), self.posX + spriteMidPointExceptImLazy, self.posY - 20 - (self.lastPhotographed * 20), 0, 2, 2)
        end

        love.graphics.setColor(r, g, b, a)
    end
    
    function self:fly(dt)
        self.frameIndex = self.frameIndex + 1 * dt * 4
        self.frame = frames[(math.floor(self.frameIndex) % 2) + 1]
        self.posX = self.posX - (self.speedX * dt)

        self.lastPhotographed = self.lastPhotographed + dt
    end

    return self
end