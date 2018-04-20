require("Guy")
require("Whitebird")

cameraSound = love.audio.newSource('photo.ogg')

guy = Guy.new()
whitebird = Whitebird.new(1100, 100)

background = love.graphics.newImage('background2.png')
tower = love.graphics.newImage('tower.png')

function love.update(dt)
    if love.mouse.isDown(1) then
        cameraSound:play()
    end

    whitebird:fly(dt)
end

function love.draw(dt)
    love.graphics.clear(100, 200, 255)

    love.graphics.draw(background, 0, 0)

    love.graphics.draw(guy.img, guy.position.x, guy.position.y)

    love.graphics.draw(tower, 300, 170)
    love.graphics.draw(whitebird.image, whitebird.frame, whitebird.posX, whitebird.posY)
end