local composer = require( "composer" )
local widget = require( "widget" )
local repo = require("Infrastructure.Repository")
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

local bg -- The background display object
local btnStart -- The start button
local btnSettings -- The settings button
local parameters -- Scene parameters

-- Handles when the settings button is pressed
-- goes to the options scene
function onSettingsPress( event )
  local options = { effect = "fromRight", time = 500, params = parameters }
  composer.gotoScene( 'unlockables_scene', options )
end

-- Handles when the start button is pressed
-- Goes to the level1 scene
function onStartPress( event )
  local options = { effect = "fade", time = 500, params = parameters }
  composer.gotoScene( 'gameplay_scene', options )
end

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view

  --composerOptions = event.params;
  --composerOptions["setting"] = 3000;

    -- Creates the background image
    bg = display.newImage ('titlebg.png'); -- found at http://www.smspower.org/uploads/Hacks/AlexKiddInMiracleWorld-SMS-AlexKiddInBroNo-Mod-Title.png
    bg.x = display.contentWidth / 2;
    bg.y= display.contentHeight / 2;

    -- options for the start button widget
    local startOptions = {
      x = display.contentWidth / 2, -- just left of middle of screen
      y = display.contentCenterY + 350, -- just below center of screen
      label = "Start", -- start is the text
      labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
      fontSize = 60,
      textOnly = true,
      onRelease = onStartPress -- wiring up handler
    }

    -- options for the setting button widget
    local settingsOptions = {
      x = display.contentWidth / 2, -- right right of center
      y = display.contentCenterY + 410, -- just below center
      label = "Unlockables", -- settings is the text
      labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
      fontSize = 60,
      textOnly = true,
      onRelease = onSettingsPress -- wiring up handler
    }
    -- options for the member names
    local nameOptions =
 {
     text = "By: Donal, Haocong, and Joe",
     x = display.contentCenterX,
     y = 650,
     fontSize = 35,
 }
    local membertext = display.newText( nameOptions ); -- Display to title screen
    -- create the buttons with the options
    btnStart = widget.newButton( startOptions )
    btnSettings = widget.newButton( settingsOptions )

    -- Add stuff to scene group
    sceneGroup:insert(bg);
    sceneGroup:insert(membertext);
    sceneGroup:insert(btnStart);
    sceneGroup:insert(btnSettings);
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase
   parameters = event.params or repo:GetParameters();
   --composerOptions.setting = event.params.setting

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end

-- "scene:hide()"
function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- "scene:destroy()"
function scene:destroy( event )

   local sceneGroup = self.view

   bg:removeSelf();
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
