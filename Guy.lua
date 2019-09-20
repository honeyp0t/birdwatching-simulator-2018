guyImages = {
    love.graphics.newImage('assets/guy.png'),
    love.graphics.newImage('assets/guy_right.png'),
    love.graphics.newImage('assets/guy_left.png'),
    love.graphics.newImage('assets/guy_climb.png')
}

Guy = {}
Guy.__index = Guy
Guy.new = function(world)
    local self = {}
    setmetatable(self, Guy)
    
    self.position = {
        x = 350,
        y = 265
    }
    self.velocity = {
        x = 0,
        y = 0
    }
    self.acceleration = 800
    self.maxSpeed = 200
    self.friction = 20
    self.airFriction = 2
    self.gravity = 9.81*16
    self.isJumping = false
    self.isGrounded = false
    self.hasReachedMax = false
    self.jumpAcceleration = 2000
    self.jumpMaxSpeed = 90
    self.touchingLadder = false

    self.body = love.physics.newBody(world, 0, 0, "dynamic")
    self.shape = love.physics.newRectangleShape(9, 10, 18, 20)
    self.fixture = love.physics.newFixture(self.body, self.shape, 100)
    self.fixture:setUserData({type = "guy", object = self})

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
        self.touchingLadder = false
        self.climbingLadder = false
        local contactList = self.body:getContacts()
        for contact in values(contactList) do
            local a,b = contact:getFixtures()
            local aUserData = a:getUserData()
            local bUserData = b:getUserData()
            local guyFixture = nil
            local groundFixture = nil
            local ladderFixture = nil
            if aUserData.type == "ground" then groundFixture = a
            elseif bUserData.type == "ground" then groundFixture = b end
            if aUserData.type == "ladder" then ladderFixture = a
            elseif bUserData.type == "ladder" then ladderFixture = b end

            if groundFixture ~= nil then
                self:collideWorld(groundFixture, contact)
            end
            if ladderFixture ~= nil then
                self:collideLadder(ladderFixture)
            end
        end

        if love.keyboard.isDown("left", "a") and self.velocity.x > -self.maxSpeed then
            if self.velocity.x > 0 then 
                self.velocity.x = self.velocity.x * (1 - math.min(dt * self.friction, 1))
            end
            self.velocity.x = self.velocity.x - self.acceleration * dt
        elseif love.keyboard.isDown("right", "d") and self.velocity.x < self.maxSpeed then
            if self.velocity.x < 0 then 
                self.velocity.x = self.velocity.x * (1 - math.min(dt * self.friction, 1))
            end
            self.velocity.x = self.velocity.x + self.acceleration * dt
        else
            if self.isGrounded then
                self.velocity.x = self.velocity.x * (1 - math.min(dt * self.friction, 1))
            else
                self.velocity.x = self.velocity.x * (1 - math.min(dt * self.airFriction, 1))
            end
        end
        if love.keyboard.isDown("up", "w") then
            if self.touchingLadder then
                self.velocity.y = -50
                self.climbingLadder = true
                self.isGrounded = false
            else
                if -self.velocity.y < self.jumpMaxSpeed and not self.hasReachedMax then
                    self.velocity.y = self.velocity.y - self.jumpAcceleration * dt
                elseif math.abs(self.velocity.y) > self.jumpMaxSpeed then
                    self.hasReachedMax = true
                end

                self.isGrounded = false
            end
        end

        --apply gravity
        if not self.grounded and not self.climbingLadder then
            self.velocity.y = self.velocity.y + self.gravity * dt
        end
        if self.grounded then
            self.velocity.y = 0
        end

        --apply speed
        self.position.x = self.position.x + self.velocity.x * dt
        self.position.y = self.position.y + self.velocity.y * dt

        --apply air friction
        --self.velocity.y = self.velocity.y * (1 - math.min(dt * self.airFriction, 1)) 

        
        --move physics collider (as of now just cosmetic)
        self.body:setPosition(self.position.x, self.position.y)
        self.body:setLinearVelocity(0, 0)
        self.body:setAngle(0)
        self.body:setAngularVelocity(0)

        --update values that are defined by position
        self.midpoint = {
            x = self.position.x + self.img:getWidth()/2,
            y = self.position.y + self.img:getHeight()/2
        }
        self.cone.vertex1x = self.midpoint.x
        self.cone.vertex1y = self.midpoint.y
        
        --update cone
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
        if self.climbingLadder then
            self.img = guyImages[4]
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

    function self:collideWorld(fixture, contact)
        shape = fixture:getShape()
        x1, y1, x2, y2, x3, y3, x4, y4 = shape:getPoints()
        fy = fixture:getBody():getY()
        if self.velocity.y >= 0 then
            self.isGrounded = true
            self.hasReachedMax = false
            self.velocity.y = 0
            self.position.y = fy + y2 - self.img:getHeight() - 2
        end
    end

    function self:collideLadder(fixture)
        self.touchingLadder = true
    end

    function self:draw()
        love.graphics.draw(self.img, self.position.x, self.position.y)
        --love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    end

    return self
end