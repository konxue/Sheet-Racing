local json = require("json");
Repository = {}

-- Initializes a new instance of the Game class.
function Repository:new(obj)
    local t = obj or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

-- getting parameters from the file
function Repository:GetParameters()
    local path = system.pathForFile("SheetRacingSave.json", system.DocumentsDirectory);
    local file = io.open(path, "r");
    -- if file is no exist or empty
    if file == nil then
      -- default parameters
        return {StartingHP = 100, StartingArmor = 50, Score = 0}
    end

    local data = file:read("*all");
    io.close(file);
    file = nil;

    return json.decode(data);
end
-- save to the file
function Repository:SetParameters(table)
    local path = system.pathForFile("SheetRacingSave.json", system.DocumentsDirectory);
    local file = io.open(path, "w");
    local data = json.encode(table);
    file:write(data);
    io.close(file);
    file = nil;
end

return Repository;
