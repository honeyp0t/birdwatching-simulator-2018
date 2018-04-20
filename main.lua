require("Guy")

cameraSound = love.audio.newSource('photo.ogg')

guy = Guy.new()

background = love.graphics.newImage('background2.png')
tower = love.graphics.newImage('tower.png')
bird1 = love.graphics.newImage('bird1.png');

Whitebird = {}
Whitebird.__index = Whitebird
Whitebird.new = function(x, y) 
    local self = {}
    setmetatable(self, Whitebird)

    self.posX = x
    self.posY = y
    self.image = bird1
    local frames = {}

    frames[1] = love.graphics.newQuad(0,0,33,35,bird1:getDimensions())
    frames[2] = love.graphics.newQuad(33,0,33,35,bird1:getDimensions())
    frames[3] = love.graphics.newQuad(66,0,33,35,bird1:getDimensions())

    return self
end

function love.update(dt)
    if love.mouse.isDown(1) then
        cameraSound:play()
    end
end

bird = Whitebird.new(100, 100)

function love.draw(dt)
    love.graphics.clear(100, 200, 255)

    love.graphics.draw(background, 0, 0)

    love.graphics.draw(guy.img, guy.position.x, guy.position.y)

    love.graphics.draw(tower, 300, 170)
    love.graphics.draw(bird.image, bird.posX, bird.posY)
end