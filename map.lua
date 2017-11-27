-- option for map
local optionsMap =
{
  frames = {
      { x = 120, y = 123, width = 530, height = 530}, -- Vertical tile
      { x = 783, y = 123, width = 530, height = 530}, -- Horizontal tile
      { x = 120, y = 770, width = 530, height = 530}, -- Start tile
      { x = 783, y = 770, width = 530, height = 530}, -- Finish tile
      { x = 2298, y = 123, width = 530, height = 530}, -- Left tile
      { x = 1645, y = 123, width = 530, height = 530}, -- Right tile
      { x = 1645, y = 770, width = 530, height = 530}, -- left up tile
      { x = 2298, y = 770, width = 530, height = 530}, -- Right up tile
  }
};
local sheetMap = graphics.newImageSheet( "map.png", optionsMap );
local map1 = display.newImage (sheetMap, 1, display.contentWidth/2, display.contentWidth/2);
