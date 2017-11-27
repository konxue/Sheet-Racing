local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here
function onHomePress( event )
  local options = { effect = "fromRight", time = 500 }
  composer.gotoScene( 'title_scene.lua', options )
end

local bg -- The background display object
local btnHome -- The Home button

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   local sceneGroup = self.view

   bg = display.newImage('gameover.png', display.contentWidth / 2, display.contentHeight / 2);

   local homeOptions = {
     x = display.contentWidth / 2, -- just left of middle of screen
     y = display.contentCenterY + 300, -- just below center of screen
     label = "Home", -- start is the text
     labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
     fontSize = 70,
     textOnly = true,
     onRelease = onHomePress -- wiring up handler
   }
   btnHome = widget.newButton( homeOptions )
   sceneGroup:insert(bg);
   sceneGroup:insert(btnHome);
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

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

   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
