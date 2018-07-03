require("Guy")
require("Bird")
require("Menu")
require("FrenchFry")

cameraSound = love.audio.newSource('assets/photo.ogg', 'static')
math.randomseed(os.time())

guy = Guy.new()
menu = Menu.new()

background = love.graphics.newImage('assets/background2.png')
tower = love.graphics.newImage('assets/tower.png')

GAME_LENGTH_SECONDS = 10
PIXELS_PER_METER = 16
MAX_FRENCH_FRIES = 100

physicsObjects = {}
world = {}
frenchFryCounter = 1

function values(t)
    local i = 0
    return function() i = i + 1; return t[i] end
end

function resetGameState()
    birbs = {Bird.new(love.graphics.getWidth(), 100)}
    timer = 0

    birdsSeen = {}
    timeSinceClick = 1
    timeSinceThrowFries = 1
    
    gameStartTime = 0
    score = 0    
end

resetGameState()

function love.load()
    love.physics.setMeter(PIXELS_PER_METER)
    world = love.physics.newWorld(0, 9.81*PIXELS_PER_METER, true)

    physicsObjects.ground = {}
    physicsObjects.ground.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()-120/2)
    physicsObjects.ground.shape = love.physics.newRectangleShape(love.graphics.getWidth(), 120)
    physicsObjects.ground.fixture = love.physics.newFixture(physicsObjects.ground.body, physicsObjects.ground.shape)

    physicsObjects.frenchFries = {}
    physicsObjects.activeFrenchFries = {}
    for i=0,MAX_FRENCH_FRIES,1 do
        frenchFry = FrenchFry.new(world)
        table.insert(physicsObjects.frenchFries, frenchFry)
    end
end

function love.update(dt)

    if (menu.isInGame) then
        world:update(dt)

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

        birdsSeen = {}
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
                table.insert(birdsSeen, birb)
            end
        end

        timeSinceClick = timeSinceClick + dt
        if love.mouse.isDown(1) and timeSinceClick > 1 then
            cameraSound:play()

            points = {}

            for birb in values(birdsSeen) do
                birb:isPhotographed(dt)
                score = score + birb:getValue()
            end

            timeSinceClick = 0
        end

        timeSinceThrowFries = timeSinceThrowFries + dt
        if love.keyboard.isDown("space") and timeSinceThrowFries > 1 then
            for i=0, 4, 1 do
                frenchFry = physicsObjects.frenchFries[frenchFryCounter + i]
                shootAngle = guy.lookingAngle + math.random()-0.5
                frenchFry.spawn(guy.position.x, guy.position.y, math.cos(shootAngle) * 10000.0, -math.sin(shootAngle) * 10000.0)
                table.insert(physicsObjects.activeFrenchFries, frenchFry)
            end
            frenchFryCounter = (frenchFryCounter + 5) % MAX_FRENCH_FRIES
            timeSinceThrowFries = 0
        end

        for i=#physicsObjects.activeFrenchFries, 1, -1 do
            if physicsObjects.activeFrenchFries[i].update(dt) == false then
                physicsObjects.activeFrenchFries[i]:kill()
                table.remove(physicsObjects.activeFrenchFries, i)
            end
        end
    else
        menu:update(dt)
    end
end

function love.draw()

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
        if #birdsSeen > 0 then
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
            birb:draw()
        end
        
        love.graphics.setColor(1.0, 1.0, 0.0)
        for frenchFry in values(physicsObjects.activeFrenchFries) do
            frenchFry:draw()
        end
        love.graphics.setColor(1, 1, 1, 1)
            
    else
        menu:drawMenu()
    end
end
