local composer = require("composer")
local PlayerVehicle = require("Domain.PlayerVehicle")
local soundTable = require("sounds.soundTable")
local Car = require("vehicle.Car")
local NPC = require("npc.npc")
local SQUIRREL = require("npc.squirrel")
local scene = composer.newScene()
local widget = require("widget")
local physics = require("physics")
local Game = require("Domain.Game")

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- start and setup physics
physics:start()
physics.setGravity(0, 0) -- no gravity

-- game class
local game

-- "scene:create()"
function scene:create(event)
    local sceneGroup = self.view

    -- create game class.
    game = Game:new()

    -- create game board
    game:create(sceneGroup)
end

-- "scene:show()"
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif (phase == "did") then
        -- start game
        game:start(sceneGroup)
    end
end

-- "scene:hide()"
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- stop game
        game:stop()
    elseif (phase == "did") then
    -- Called immediately after scene goes off screen.
    end
end

-- "scene:destroy()"
function scene:destroy(event)
    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

---------------------------------------------------------------------------------

return scene
