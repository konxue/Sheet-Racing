display.setStatusBar( display.HiddenStatusBar )

local widget = require('widget')




  -----------------------------background--------------------------------

  local optionsMap =
  {
    frames = {
        { x = 45, y = 46, width = 200, height = 200}, -- Vertical tile 1
        { x = 294, y = 46, width = 200, height = 200}, -- Horizontal tile 2
        { x = 45, y = 290, width = 200, height = 200}, -- Start tile 3
        { x = 294, y = 290, width = 200, height = 200}, -- Finish tile 4
        { x = 862, y = 46, width = 199, height = 200}, -- Left tile 5
        { x = 617, y = 46, width = 200, height = 200}, -- Right tile 6
        { x = 617, y = 290, width = 200, height = 200}, -- left up tile 7
        { x = 862, y = 290, width = 200, height = 200}, -- Right up tile 8
    }
  };
  local sheetMap = graphics.newImageSheet( "map2.png", optionsMap );


  local function mapMaker ()
  local map1 = display.newImage (sheetMap, 1, display.contentWidth/2, display.contentWidth-60);
  local map2 = display.newImage (sheetMap, 6, display.contentWidth/2, 0);
  end
  mapMaker();
