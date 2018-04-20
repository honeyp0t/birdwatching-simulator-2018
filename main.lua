require("Guy")

background = love.graphics.newImage('background.jpg')

cameraSound = love.audio.newSource('photo.ogg')

guy = Guy.new()

function love.conf(t)
    t.window.width = 1024
    t.window.height = 500
end

function love.update(dt)
    if love.mouse.isDown(1) then
        cameraSound:play()
    end
end

function love.draw(dt)
    love.graphics.clear(100, 200, 255)

    love.graphics.draw(background, 0, 0)

    love.graphics.draw(guy.img, guy.position.x, guy.position.y)
end