-- create soundTable
local soundTable = {
    explosion = audio.loadSound( "Sounds/explosion.wav" ),
    hurt = audio.loadSound( "Sounds/hurt.wav" ),
    collision = audio.loadSound( "Sounds/collision.wav" ),
    whack = audio.loadSound( "Sounds/whack.wav" ),
    hp = audio.loadSound( "Sounds/hp.wav" )
};

return soundTable;
