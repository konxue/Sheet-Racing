display.setStatusBar( display.HiddenStatusBar )

local widget = require('widget')




  -----------------------------background--------------------------------

  local optionsMap =
  {
    frames = {
        { x = 59, y = 61, width = 268, height = 267}, -- Vertical tile
        { x = 391, y = 61, width = 268, height = 267}, -- Horizontal tile
        { x = 59, y = 385, width = 268, height = 267}, -- Start tile
        { x = 391, y = 385, width = 268, height = 267}, -- Finish tile
        { x = 1148, y = 61, width = 267, height = 267}, -- Left tile
        { x = 821, y = 61, width = 268, height = 267}, -- Right tile
        { x = 821, y = 385, width = 268, height = 267}, -- left up tile
        { x = 1148, y = 385, width = 267, height = 267}, -- Right up tile
    }
  };
  local sheetMap = graphics.newImageSheet( "map.png", optionsMap );


  local function mapMaker ()
  local map1 = display.newImage (sheetMap, 1, display.contentWidth/2, display.contentWidth/2);
  local map2 = display.newImage (sheetMap, 1, display.contentWidth/2, 0);
  end
  mapMaker();
