display.setStatusBar( display.HiddenStatusBar )
local composer = require('composer')

math.randomseed(os.time());
-- go to title scene
composer.gotoScene( 'title_scene' )
