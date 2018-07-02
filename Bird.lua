math.randomseed(os.time())

Bird = {}
Bird.__index = Bird
Bird.new = function(x, y) 
    local self = {}
    setmetatable(self, Bird)

    local frames = {}

    local birdIndex = math.random(1, 2)

    local loadBird = function(spritesheetRef, numFrames, birdValue, minimumBirdSpeed, maximumBirdSpeed)
        local img = love.graphics.newImage(spritesheetRef)
        local frames = {}
        local spriteWidth, spriteHeight = img:getDimensions()

        for i = 1, numFrames do
            frames[i] = love.graphics.newQuad((i - 1) * (spriteWidth / numFrames), 0, spriteWidth / numFrames, spriteHeight, img:getDimensions())
        end

        self.image = img
        self.frames = frames
        self.frameIndex = 1
        self.totalFrames = numFrames
        self.frame = self.frames[self.frameIndex]
        self.value = birdValue

        self.speedX = math.random(minimumBirdSpeed, maximumBirdSpeed)
        if x < 0 then
            self.speedX = -1 * self.speedX
        end
    
    end

    local birdProbability = math.random(1, 100)

    if birdProbability < 1 then -- 1% chance bird wow
        loadBird('assets/owl.png', 3, 5, 100, 250)
    elseif birdProbability < 10 then -- play freebird
        loadBird('assets/small-blue-bird.png', 3, 3, 250, 350)
    elseif birdProbability < 50 then -- pretty common bird
        loadBird('assets/bird2.png', 3, 2, 80, 300)
    else -- shitbird for commonfolk
        loadBird('assets/bird1.png', 3, 1, 60, 300)
    end
    
    self.posX = x
    self.posY = y
    self.lastPhotographed = 999

    -- Number of points that the bird is worth
    function self:getValue() 
        return self.value
    end

    function self:isPhotographed(dt)
        self.lastPhotographed = 0
    end

    function self:draw(dt) 

        if self.speedX > 0 then
            love.graphics.draw(self.image, self.frame, self.posX, self.posY)
        else
            love.graphics.draw(self.image, self.frame, self.posX, self.posY, 0, -1, 1)
        end
        local r, g, b, a = love.graphics.getColor()

        if self.lastPhotographed < 2 then -- print point indicator
            local imgWidth = self.image:getDimensions()
            local spriteMidPoint = (imgWidth / self.totalFrames) / 2 - 8
            local yellowWithAlpha = {
                1,
                1,
                102/255,
                1.5 - self.lastPhotographed
            }
            love.graphics.setColor(yellowWithAlpha)
            love.graphics.print(self:getValue(), self.posX + spriteMidPoint, self.posY - 20 - (self.lastPhotographed * 20), 0, 2, 2)
        end

        love.graphics.setColor(r, g, b, a)
    end
    
    function self:fly(dt)
        self.frameIndex = self.frameIndex + 1 * dt * 4
        self.frame = self.frames[(math.floor(self.frameIndex) % (self.totalFrames)) + 1]
        self.posX = self.posX - (self.speedX * dt)

        self.lastPhotographed = self.lastPhotographed + dt
    end

    return self
end