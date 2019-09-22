SpriteAnimation = {}
SpriteAnimation.__index = SpriteAnimation
SpriteAnimation.new = function()
    local self = {}
    setmetatable(self, SpriteAnimation)

    self.frames = {}
    self.currentFrame = 1
    self.progress = 0
    self.timeOnFrame = 0

    function self.update(self, dt)
        local duration = self.frames[self.currentFrame].duration
        self.timeOnFrame = self.timeOnFrame + dt
        if self.timeOnFrame > duration then
            self.timeOnFrame = self.timeOnFrame - duration
            self.currentFrame = self.currentFrame + 1
            if self.currentFrame > #self.frames then
                self.currentFrame = self.currentFrame - #self.frames
            end
        end
    end

    function self.addFrame(self, frame)
        self.frames [#self.frames + 1] = frame
        self.currentFrame = 1
    end

    function self.getQuad()
        return self.frames[self.currentFrame].quad
    end

    return self
end