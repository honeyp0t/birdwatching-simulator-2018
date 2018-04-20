background = love.graphics.newImage('background.jpg')

function love.conf(t)
    t.window.width = 1024
    t.window.height = 500
end

function love.update(dt)
end

function love.draw(dt)
    love.graphics.clear(100, 200, 255)

    love.graphics.draw(background, 0, 0)
end