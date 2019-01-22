FrenchFry = {}
FrenchFry.__index = FrenchFry
FrenchFry.new = function(world)
    local self = {}
    setmetatable(self, FrenchFry)

    self.body = love.physics.newBody(world, 0, 0, "dynamic")
    self.body:setActive(false)
    self.shape = love.physics.newRectangleShape(0, 0, 5, 20)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.fixture:setUserData("frenchfry")
    self.lifetime = 5.0

    self.spawn = function(x, y, x_vel, y_vel)
        self.body:setActive(true)
        self.body:setPosition(x, y)
        self.body:setAngle(math.random()*2*math.pi)
        frenchFry.body:applyForce(x_vel, y_vel)
    end
	
	self.resetLifetime = function()
		self.lifetime = 5.0
	end

    self.kill = function()
        self.body:setActive(false)
    end

    self.update = function(dt)
        self.lifetime = self.lifetime - dt
        return self.lifetime > 0
    end

    self.draw = function()
        love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    end

    return self
end