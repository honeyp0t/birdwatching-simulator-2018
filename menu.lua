Menu = {}
Menu.__index = Menu
Menu.new = function()
    local self = {}
    setmetatable(self, Menu)

    local activeSelection = 1
    self.isInGame = false
    
    local timeSinceKeypress = 0

    function self:drawMenu()
	
        love.graphics.setColor(1/255, 76/255, 2/255)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())	

        love.graphics.setColor(1, 1, 1)
        if (activeSelection == 1) then
            love.graphics.setColor(0, 1, 1)
        end

        love.graphics.print("Start game", 340, 165, 0, 2, 2)            

        love.graphics.setColor(1, 1, 1)

        if (activeSelection == 2) then
            love.graphics.setColor(0, 1, 1)
        end
        love.graphics.print("Highscores (not implemented lul)", 340, 265, 0, 2, 2)
        love.graphics.setColor(1/255, 76/255, 2/255)

    end

    function self:update(dt)

        timeSinceKeypress = timeSinceKeypress + dt

        if love.keyboard.isDown("down") and timeSinceKeypress > 0.3 then
            activeSelection = activeSelection + 1
            if (activeSelection > 2) then
                activeSelection = 1
            end
            timeSinceKeypress = 0
        end

        if love.keyboard.isDown("return") then
            self.isInGame = true
        end
    end

    return self
end
