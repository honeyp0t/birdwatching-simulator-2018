DayNightCycle = {}
DayNightCycle.__index = DayNightCycle
DayNightCycle.new = function()
    local self = {}

    self.getRealisticCycleOpacity = function()
        -- %H = hour 00-23, %M minute 0-59, %S second 00-61
        local x = tonumber(os.date('%H'))

        if x < 5 then return 0.7 end
        if x < 7 then return 0.5 end
        if x < 18 then return 0 end
        if x < 22 then return 0.5 end
        return 0.7
    end

    self.getArcadeyOverlayOpacity = function()
        -- %H = hour 00-23, %M minute 0-59, %S second 00-61
        local x = tonumber(os.date('%S'))

        return 0 + 0.5 * math.sin(0.05*x)
        
    end

    self.draw = function()
        love.graphics.setColor(0, 0, 0, self.getRealisticCycleOpacity())
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end

    return self
end