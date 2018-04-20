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
        x = 400,
        y = 200
    }

    self.img = guyImages[1]

    return self
end