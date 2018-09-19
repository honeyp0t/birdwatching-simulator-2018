theme = love.audio.newSource('assets/themesong.mp3', 'static')
backgroundBIRD = love.graphics.newImage('assets/magpie.jpg')
math.randomseed(os.time())

Menu = {}
Menu.__index = Menu
Menu.new = function()
    local self = {}
    setmetatable(self, Menu)

    local activeSelection = 1
    self.isInGame = false
    
    local timeSinceKeypress = 0
    local menuLoopStart
    local backgroundYStartPos
    local xScrollSpeed
    local yScrollSpeed

    function self:drawMenu()
	
        love.graphics.setColor(248/255, 227/255, 174/255)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        self:drawBackground()

        love.graphics.setColor(1, 1, 1)
        if (activeSelection == 1) then
            love.graphics.setColor(0, 1, 1)
        end

        local font = love.graphics.newFont('assets/Games.ttf', 30)
        local startGameText = love.graphics.newText(font, "Start game")
        love.graphics.draw(startGameText, 40, 165, 0, 2, 2)
        --love.graphics.print("Start game", 340, 165, 0, 2, 2)            

        love.graphics.setColor(1, 1, 1)

        if (activeSelection == 2) then
            love.graphics.setColor(0, 1, 1)
        end
        local highScoresText = love.graphics.newText(font, "Highscores (not implemented lul)")
        --highScoresText.setf("Highscores (not implemented lul)", 400)
        love.graphics.draw(highScoresText, 40, 265, 0, 2, 2)
        --love.graphics.print("Highscores (not implemented lul)", 340, 265, 0, 2, 2)
        love.graphics.setColor(1/255, 76/255, 2/255)

    end

    function self:drawBackground()

        local backgroundX = -600+xScrollSpeed*(love.timer.getTime() - menuLoopStart)
        local backgroundY = backgroundYStartPos-yScrollSpeed*(love.timer.getTime() - menuLoopStart)
        
        love.graphics.draw(backgroundBIRD, backgroundX, backgroundY)
    end

    function self:update(dt)

        timeSinceKeypress = timeSinceKeypress + dt

        if not theme:isPlaying() then
            theme:setLooping(true)
            theme:setVolume(0.8)
            local pitches = {
                0.5,
                0.8,
                1,
                1,
                1.2,
                1.5
            }
            local pitch = pitches[math.random(1, #pitches)]
            theme:setPitch(pitch)
            theme:play()
            menuLoopStart = love.timer.getTime()
            backgroundYStartPos = math.random(0, 0)
            xScrollSpeed = math.random(9, 40)
            yScrollSpeed = math.random(9, 40)
        end

        if (love.keyboard.isDown("down") or love.keyboard.isDown("up")) and timeSinceKeypress > 0.3 then
            activeSelection = activeSelection + 1
            if (activeSelection > 2) then
                activeSelection = 1
            end
            timeSinceKeypress = 0
        end

        if love.keyboard.isDown("return") or love.keyboard.isDown("kpenter") then
            self.isInGame = true
            theme:stop()
        end
    end

    return self
end
