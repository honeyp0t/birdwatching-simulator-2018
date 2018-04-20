guyImages = {
    love.graphics.newImage('guy.png'),
    love.graphics.newImage('guy_right.png'),
    love.graphics.newImage('guy_left.png')
}

Guy = {}
Guy.__index = Guy
Guy.new = function()
    local self = {}
    setmetatable(self, Guy)
    
    self.position = {
        x = 350,
        y = 173
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
        self.lookingAngle = self.lookingAngle + 3.1415 * dt

        self.lookAtPoint = {
            x = self.midpoint.x + math.cos(self.lookingAngle) * 200,
            y = self.midpoint.y + math.sin(self.lookingAngle) * 200
        }

        self.cone.vertex2x = self.midpoint.x + math.cos(self.lookingAngle + 0.1) * 200
        self.cone.vertex2y = self.midpoint.y + math.sin(self.lookingAngle + 0.1) * 200

        self.cone.vertex3x = self.midpoint.x + math.cos(self.lookingAngle - 0.1) * 200
        self.cone.vertex3y = self.midpoint.y + math.sin(self.lookingAngle - 0.1) * 200
    end

    function self:canSeeBird(bird)
        
    end

    return self
end