require("Guy")
require("Bird")
require("Menu")

cameraSound = love.audio.newSource('assets/photo.ogg', 'static')
math.randomseed(os.time())

guy = Guy.new()
menu = Menu.new()

background = love.graphics.newImage('assets/background2.png')
tower = love.graphics.newImage('assets/tower.png')

GAME_LENGTH_SECONDS = 10

function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

function resetGameState()
    birbs = {Bird.new(love.graphics.getWidth(), 100)}
    timer = 0

    birdsSeen = 0
    timeSinceClick = 1
    
    gameStartTime = 0
    score = 0    
end

resetGameState()

function love.update(dt)

    if (menu.isInGame) then
        if love.keyboard.isDown("escape") then 
            menu.isInGame = false
            resetGameState()
            return
        end

        if gameStartTime == 0 then
            gameStartTime = love.timer.getTime()
        end

        if (gameStartTime + GAME_LENGTH_SECONDS) - love.timer.getTime() <= 0 then
            return
        end

        birdsSeen = 0
        guy:update(dt)

        timer = timer + dt;

        if (timer > math.random(1, 4)) then
            timer = 0
        end

        if timer == 0 then
            generateBirb()
        end

        function generateBirb()
            -- left 1, right 2
            local randomSide = math.random(2);

            if(randomSide == 2) then
                table.insert(birbs, Bird.new(love.graphics.getWidth(), math.random(0, 350)))
            else
                table.insert(birbs, Bird.new(-100, math.random(0, 350)))
            end
        end

        for birb in values(birbs) do
            birb:fly(dt)
            if guy:canSeeBird(birb) then
                birdsSeen = birdsSeen + 1
            end
        end

        timeSinceClick = timeSinceClick + dt
        if love.mouse.isDown(1) and timeSinceClick > 1 then
            cameraSound:play()

            score = score + birdsSeen
            timeSinceClick = 0
        end
    else
        menu:update(dt)
    end
end

function love.draw(dt)

    if (menu.isInGame) then

        if (gameStartTime + GAME_LENGTH_SECONDS) - love.timer.getTime() <= 0 then

            love.graphics.print("End score: " .. score, 330, 165, 0, 2, 2)
            love.graphics.print("Press escape to return to menu", 330, 265, 0, 2, 2)
            return
        end

        love.graphics.clear(100, 200, 255)

        love.graphics.draw(background, 0, 0)

        love.graphics.print("Score: " .. score, 10, 465, 0, 2, 2)

        love.graphics.print("Time left: " .. math.floor((gameStartTime + GAME_LENGTH_SECONDS) - love.timer.getTime() +0.5), 10, 10, 0, 2, 2)

        love.graphics.draw(guy.img, guy.position.x, guy.position.y)

        love.graphics.draw(tower, 300, 170)    

        love.graphics.setColor(1, 0, 0, 100/255)
        if birdsSeen > 0 then
            love.graphics.setColor(0, 1, 0, 100/255)
        end
        love.graphics.polygon('fill', guy.cone.vertex1x, guy.cone.vertex1y,
            guy.cone.vertex2x, guy.cone.vertex2y,
            guy.cone.vertex3x, guy.cone.vertex3y)

        love.graphics.setColor(1, 1, 1, (1 - timeSinceClick))
        love.graphics.polygon('fill', guy.cone.vertex1x, guy.cone.vertex1y,
            guy.cone.vertex2x, guy.cone.vertex2y,
            guy.cone.vertex3x, guy.cone.vertex3y)

        love.graphics.setColor(1, 1, 1, 1)

        for birb in values(birbs) do
            love.graphics.draw(birb.image, birb.frame, birb.posX, birb.posY)
        end
    else
        menu:drawMenu()
    end
end
