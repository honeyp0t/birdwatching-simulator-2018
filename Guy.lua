require("Sprite")
require("SpriteAnimation")
require("SpriteAnimationFrame")

guyimg = love.graphics.newImage('assets/Alex Jospeh Sheet.png')

guy_idleAnimation = SpriteAnimation.new()
guy_idleAnimation:addFrame(SpriteAnimationFrame.new(guyimg, 0, 2, 17, 20, 1))

guy_walkLeftAnimation = SpriteAnimation.new()
guy_walkLeftAnimation:addFrame(SpriteAnimationFrame.new(guyimg, 54, 25, 15, 20, 0.1))
guy_walkLeftAnimation:addFrame(SpriteAnimationFrame.new(guyimg, 71, 25, 15, 20, 0.1))

guy_walkRightAnimation = SpriteAnimation.new()
guy_walkRightAnimation:addFrame(SpriteAnimationFrame.new(guyimg, 71, 2, 15, 20, 0.1))
guy_walkRightAnimation:addFrame(SpriteAnimationFrame.new(guyimg, 54, 2, 15, 20, 0.1))

guy_climbAnimation = SpriteAnimation.new()
guy_climbAnimation:addFrame(SpriteAnimationFrame.new(guyimg, 1, 48, 15, 20, 0.1))
guy_climbAnimation:addFrame(SpriteAnimationFrame.new(guyimg, 20, 48, 15, 20, 0.1))

guySprite = Sprite.new(guyimg)
guySprite.animations.idle = guy_idleAnimation
guySprite.animations.walkLeft = guy_walkLeftAnimation
guySprite.animations.walkRight = guy_walkRightAnimation
guySprite.animations.climb = guy_climbAnimation
guySprite.currentAnimation = guySprite.animations.walkLeft

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
    self.size = {
        x = 18,
        y = 20
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
    self.shape = love.physics.newRectangleShape(9, 10, self.size.x, self.size.y)
    self.fixture = love.physics.newFixture(self.body, self.shape, 100)
    self.fixture:setUserData({type = "guy", object = self})

    self.sprite = guySprite

    self.midpoint = {
        x = self.position.x + self.size.x/2,
        y = self.position.y + self.size.y/2
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
        self.sprite.currentAnimation = self.sprite.animations.idle
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
            self.sprite.currentAnimation = self.sprite.animations.walkLeft
        elseif love.keyboard.isDown("right", "d") and self.velocity.x < self.maxSpeed then
            if self.velocity.x < 0 then 
                self.velocity.x = self.velocity.x * (1 - math.min(dt * self.friction, 1))
            end
            self.velocity.x = self.velocity.x + self.acceleration * dt
            self.sprite.currentAnimation = self.sprite.animations.walkRight
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
        
        --move physics collider (as of now just cosmetic)
        self.body:setPosition(self.position.x, self.position.y)
        self.body:setLinearVelocity(0, 0)
        self.body:setAngle(0)
        self.body:setAngularVelocity(0)

        --update values that are defined by position
        self.midpoint = {
            x = self.position.x + self.size.x/2,
            y = self.position.y + self.size.y/2
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

        if self.climbingLadder then
            self.sprite.currentAnimation = self.sprite.animations.climb
        end

        self.lookAtPoint = {
            x = self.midpoint.x + math.cos(self.lookingAngle) * 200,
            y = self.midpoint.y + math.sin(self.lookingAngle) * 200
        }

        self.cone.vertex2x = self.midpoint.x + math.cos(-self.lookingAngle + 0.2) * 400
        self.cone.vertex2y = self.midpoint.y + math.sin(-self.lookingAngle + 0.2) * 400

        self.cone.vertex3x = self.midpoint.x + math.cos(-self.lookingAngle - 0.2) * 400
        self.cone.vertex3y = self.midpoint.y + math.sin(-self.lookingAngle - 0.2) * 400

        self.sprite:update(dt)
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
        print(y1)
        if self.velocity.y >= 0 and self.midpoint.y + 5 <= fy + y2 then
            self.isGrounded = true
            self.hasReachedMax = false
            self.velocity.y = 0
            self.position.y = fy + y2 - self.size.y - 2
        end
    end

    function self:collideLadder(fixture)
        self.touchingLadder = true
    end

    function self:draw()
        --love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
        love.graphics.draw(self.sprite.image, self.sprite:getQuad(), self.position.x, self.position.y)
    end

    return self
end