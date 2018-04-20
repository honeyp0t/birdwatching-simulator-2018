require("Guy")
require("Whitebird")

cameraSound = love.audio.newSource('photo.ogg')
math.randomseed(os.time())

guy = Guy.new()
birbs = {Whitebird.new(1100, 100)}

background = love.graphics.newImage('background2.png')
tower = love.graphics.newImage('tower.png')

timer = 0

birdsSeen = 0

score = 0

function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

function love.update(dt)
    birdsSeen = 0
    guy:update(dt)

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
        if guy:canSeeBird(birb) then
            birdsSeen = birdsSeen + 1
        end
    end

end

function love.draw(dt)
    love.graphics.clear(100, 200, 255)

    love.graphics.draw(background, 0, 0)

    love.graphics.print("Score: " .. score, 10, 465, 0, 2, 2)

    love.graphics.draw(guy.img, guy.position.x, guy.position.y)

    love.graphics.draw(tower, 300, 170)    

    love.graphics.setColor(255, 0, 0, 100)
    if birdsSeen > 0 then
        love.graphics.setColor(0, 255, 0, 100)
    end
    love.graphics.polygon('fill', guy.cone.vertex1x, guy.cone.vertex1y,
        guy.cone.vertex2x, guy.cone.vertex2y,
        guy.cone.vertex3x, guy.cone.vertex3y)
    love.graphics.setColor(255, 255, 255, 255)

    for birb in values(birbs) do
        love.graphics.draw(birb.image, birb.frame, birb.posX, birb.posY)
    end

    love.graphics.print(guy:angleToBird(birbs[1]), 20, 20)
    love.graphics.print(guy.lookingAngle, 20, 40)
    love.graphics.print(math.abs(guy.lookingAngle - guy:angleToBird(birbs[1])), 20, 60)
end