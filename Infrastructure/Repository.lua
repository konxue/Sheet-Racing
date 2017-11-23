local data = "My app state data";
local path = system.pathForFile( "infrastructure/data.dat",
system.DocumentsDirectory );
local file = io.open( path, "w" );
file:write( data );
io.close( file );
file = nil;
