local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
-- constants
local COST = 100
-- parameters from title scene
local params
-- PLUS Signs
local addStartingArmor
local addStartingHP
-- Text Display Objects
local startingHP
local startingArmor
local score
-- Format Strings
local startingHPFormat = "Starting Health: %d"
local startingArmorFormat = "Starting Armor: %d"
local scoreFormat = "Currency: %d"
-- Return button
local returnHome
---------------------------------------------------------------------------------

local function onBackPressed()
    params.Score = 100
    local options = {effect = "fromRight", time = 400, params = params}
    composer.gotoScene("title_scene", options)
end

local function onAddArmorPressed()
    if params.Score < COST then
        return
    end

    local armor = params.StartingArmor + 5
    local scor = params.Score - COST
    params.StartingArmor = armor
    params.Score = scor
    startingArmor.text = string.format(startingArmorFormat, armor)
    score.text = string.format(scoreFormat, scor)

    if scor < COST then
        addStartingArmor:setEnabled(false)
        addStartingHP:setEnabled(false)
        timer.performWithDelay(
            100,
            function()
                addStartingArmor:setFillColor(0, 0, 0)
                addStartingHP:setFillColor(0, 0, 0)
            end,
            1
        )
    end
end

local function onAddHPPressed()
    if params.Score < COST then
        return
    end

    local hp = params.StartingHP + 5
    local scor = params.Score - COST
    params.StartingHP = hp
    params.Score = scor
    startingHP.text = string.format(startingHPFormat, hp)
    score.text = string.format(scoreFormat, scor)

    if scor < COST then
        addStartingArmor:setEnabled(false)
        addStartingHP:setEnabled(false)
        timer.performWithDelay(
            100,
            function()
                addStartingArmor:setFillColor(0, 0, 0)
                addStartingHP:setFillColor(0, 0, 0)
            end,
            1
        )
    end
end

-- "scene:create()"
function scene:create(event)
    local sceneGroup = self.view

    params = event.params

    -- Create new buttons and backgrounds
    bg = display.newImage("unlockables.png")
    bg.x = display.contentWidth / 2
    bg.y = display.contentHeight / 2
    startingHP = display.newText({text = "", x = 175, y = 250, width = 300})
    startingArmor = display.newText({text = "", x = 175, y = 350, width = 300})
    score = display.newText({text = "", x = display.contentCenterX, y = 485})
    addStartingArmor =
        widget.newButton(
        {
            label = "+",
            fontSize = 101,
            left = 400,
            top = 295,
            textOnly = true,
            labelColor = {default = {1, 1, 1}, over = {0, 0, 0, 0.5}},
            onRelease = onAddArmorPressed
        }
    )
    addStartingHP =
        widget.newButton(
        {
            label = "+",
            fontSize = 101,
            left = 400,
            top = 195,
            textOnly = true,
            labelColor = {default = {1, 1, 1}, over = {0, 0, 0, 0.5}},
            onRelease = onAddHPPressed
        }
    )
    returnHome =
        widget.newButton(
        {
            label = "Back",
            fontSize = 60,
            left = 20,
            top = 600 - 50,
            labelColor = {default = {1, 1, 1}, over = {0, 0, 0, 0.5}},
            onRelease = onBackPressed
        }
    )

    sceneGroup:insert(bg)
    sceneGroup:insert(addStartingArmor)
    sceneGroup:insert(addStartingHP)
    sceneGroup:insert(startingArmor)
    sceneGroup:insert(startingHP)
    sceneGroup:insert(returnHome)
    sceneGroup:insert(score)
end

-- "scene:show()"
function scene:show(event)
    params = event.params;

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is still off screen (but is about to come on screen)
        local startHPNum = params.StartingHP
        local startARNum = params.StartingArmor
        local scoreNum = params.Score

        if scoreNum <= 0 then
            addStartingArmor:setEnabled(false)
            addStartingHP:setEnabled(false)

            addStartingArmor:setFillColor(0, 0, 0)
            addStartingHP:setFillColor(0, 0, 0)
        else
            addStartingArmor:setEnabled(true)
            addStartingHP:setEnabled(true)

            addStartingArmor:setFillColor(1, 1, 1)
            addStartingHP:setFillColor(1, 1, 1)
        end

        startingHP.text = string.format(startingHPFormat, startHPNum)
        startingArmor.text = string.format(startingArmorFormat, startARNum)
        score.text = string.format(scoreFormat, scoreNum)
    elseif (phase == "did") then
    -- Called when the scene is now on screen.
    -- Insert code here to make the scene come alive.
    -- Example: start timers, begin animation, play audio, etc.
    end
end

-- "scene:hide()"
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
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
