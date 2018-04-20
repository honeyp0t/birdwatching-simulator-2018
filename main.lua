background = love.graphics.newImage('background.jpg')
tower = love.graphics.newImage('tower.png')

function love.update(dt)
end

function love.draw(dt)
    love.graphics.clear(100, 200, 255)

    love.graphics.draw(background, 0, 0)
    love.graphics.draw(tower, 500, 200)
end