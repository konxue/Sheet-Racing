-- create soundTable
local soundTable = {
    explosion = audio.loadSound( "explosion.wav" ),
    hurt = audio.loadSound( "hurt.wav" ),
    collision = audio.loadSound( "collision.wav" ),
    whack = audio.loadSound( "whack.wav" )
};

return soundTable;
--audio.play( soundTable["explosion"] )
