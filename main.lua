require("Guy")
require("Whitebird")

cameraSound = love.audio.newSource('photo.ogg')
math.randomseed(os.time())

guy = Guy.new()
birbs = {Whitebird.new(1100, 100)}

background = love.graphics.newImage('background2.png')
tower = love.graphics.newImage('tower.png')

timer = 0
score = 0

function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

function love.update(dt)
    if love.mouse.isDown(1) then
        cameraSound:play()
    end

    timer = timer + dt;

    if (timer > math.random(1, 4)) then
        timer = 0
    end

    if timer == 0 then
        local whitebird = Whitebird.new(1100, math.random(0, 350))
        table.insert(birbs, whitebird)
    end

    for birb in values(birbs) do
        birb:fly(dt)
    end

end

function love.draw(dt)
    love.graphics.clear(100, 200, 255)

    love.graphics.draw(background, 0, 0)

    love.graphics.print("Score: " .. score, 10, 465, 0, 2, 2)

    love.graphics.draw(guy.img, guy.position.x, guy.position.y)

    love.graphics.draw(tower, 300, 170)

    for birb in values(birbs) do
        love.graphics.draw(birb.image, birb.frame, birb.posX, birb.posY)
    end
end