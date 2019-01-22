guyImages = {
    love.graphics.newImage('assets/guy.png'),
    love.graphics.newImage('assets/guy_right.png'),
    love.graphics.newImage('assets/guy_left.png')
}

Guy = {}
Guy.__index = Guy
Guy.new = function()
    local self = {}
    setmetatable(self, Guy)
    
    self.position = {
        x = 350,
        y = 265
    }
    self.img = guyImages[1]

    self.midpoint = {
        x = self.position.x + self.img:getWidth()/2,
        y = self.position.y + self.img:getHeight()/2
    }

    self.lookingAngle = 0
    self.lookAtPoint = {
        x = 0,
        y = 0
    }

    self.cone = {
        vertex1x = self.midpoint.x,
        vertex1y = self.midpoint.y,
        vertex2x = 0,
        vertex2y = 0,
        vertex3x = 0,
        vertex3y = 0
    }


    function self:update(dt)
        local mouseX = love.mouse.getX()
        local mouseY = love.mouse.getY()

        self.lookingAngle = math.atan2(self.position.y - mouseY, mouseX - self.position.x)
        if self.lookingAngle > 2 * math.pi then
            self.lookingAngle = self.lookingAngle - 2 * math.pi
        end
        if self.lookingAngle < 0 then
            self.lookingAngle = self.lookingAngle + 2 * math.pi
        end
        if self.lookingAngle > math.pi * 0.66 then
            self.img = guyImages[3]
        elseif self.lookingAngle < math.pi * 0.33 then
            self.img = guyImages[2]
        else
            self.img = guyImages[1]
        end

        self.lookAtPoint = {
            x = self.midpoint.x + math.cos(self.lookingAngle) * 200,
            y = self.midpoint.y + math.sin(self.lookingAngle) * 200
        }

        self.cone.vertex2x = self.midpoint.x + math.cos(-self.lookingAngle + 0.2) * 400
        self.cone.vertex2y = self.midpoint.y + math.sin(-self.lookingAngle + 0.2) * 400

        self.cone.vertex3x = self.midpoint.x + math.cos(-self.lookingAngle - 0.2) * 400
        self.cone.vertex3y = self.midpoint.y + math.sin(-self.lookingAngle - 0.2) * 400
    end
    
    function self:angleToBird(bird)
        return math.atan2(self.position.y - bird.posY, bird.posX - self.position.x)
    end

    function self:canSeeBird(bird)
        local angleToBird = self:angleToBird(bird)
        local distanceX = (bird.posX - self.position.x)
        local distanceY = (bird.posY - self.position.y)
        local distanceToBird = math.sqrt(distanceX*distanceX + distanceY*distanceY)
        local angleDiff = math.fmod(self.lookingAngle - angleToBird + (math.pi*3), math.pi*2) - math.pi
        if math.abs(angleDiff) < 0.2 and distanceToBird < 400 then
            return true
        end
        return false
    end

    return self
end