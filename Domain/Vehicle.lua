Vehicle = {
    Name = "",
    HP = 100,
    Armor = 0,
    DisplayObject = {},
    Speed = 0,
    TopSpeed = 100,
    RRatio = 0.09,
    TurnRatio = 1.2,
    MoveTime = 200,
    DmgRatio = 10,
    SpeedInc = 5
}

-- Moves the vehicle by the given offset in the given time.
function Vehicle:Move(deltaX, deltaY, t)
    transition.to(self.DisplayObject, {x = self.DisplayObject.x + deltaX, y = self.DisplayObject.y + deltaY, time = t})
end

-- Turn the vehicle based on the direction and speed of the car.
function Vehicle:Turn(direction)
    if self.DisplayObject == nil then
        return
    end

    if direction == "left" then
        self.DisplayObject:rotate(-1 * self.RRatio * self.Speed)
        self:Move(-1 * self.TurnRatio * self.Speed, 0, self.MoveTime)
    elseif direction == "right" then
        self.DisplayObject:rotate(self.RRatio * self.Speed)
        self:Move(self.TurnRatio * self.Speed, 0, self.MoveTime)
    end

    -- rotate the vehicle back straight
    timer.performWithDelay(
        self.MoveTime,
        function()
            pcall(
                function()
                    if self.DisplayObject == nil then
                        return
                    end

                    self.DisplayObject:rotate(self.DisplayObject.rotation * -1)
                end
            )
        end,
        1
    )
end

-- Initializes a new Vehicle object
function Vehicle:new(obj)
    local v = obj or {}
    setmetatable(v, self)
    self.__index = self
    return v
end

return Vehicle
--[[ Class definition
hp = The health of the Vehicle (0-100)
armor = Armor that the Vehicle has (0+)
speed = How fast the Vehicle's vehicle moves (0+) {based on rates, 1 = normal}
recovery = How fast the vehicle recovers from damage {question} {based on rates, 1 = normal}
sprite = The sprite associated with this object.
]]
