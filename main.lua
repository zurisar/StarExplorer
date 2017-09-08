-- Copyright (c) 2017 Corona Labs Inc.
-- Code is MIT licensed and can be re-used; see https://www.coronalabs.com/links/code/license
-- Other assets are licensed by their creators:
--    Art assets by Kenney: http://kenney.nl/assets
--    Music and sound effect assets by Eric Matyas: http://www.soundimage.org

local composer = require( "composer" )
local json = require( "json" )

composer.setVariable( "gameRestart", false)

-- Debug mod true/false
local isDebug = false

if (isDebug == true) then
	composer.setVariable("isDebug", true)
end

-- local settings = {}

local musicVolume = 0.5
local soundVolume = 0.5
local difficulty = 1

local filePath = system.pathForFile( "settings.json", system.DocumentsDirectory )

function loadSettings()

	local file = io.open( filePath, "r" )
	local settings = {}
	
	if file then 
		local contents = file:read( "*a" )
		io.close( file )
		settings = json.decode( contents )
	end
	if (isDebug == true) then
		print ( settings.difficulty )
	end
	if( settings.difficulty == nil ) then
		musicVolume = 0.5
		soundVolume = 0.5
		difficulty = 1
		if (isDebug == true) then
			print("Setting not loaded!")
		end
	else
		musicVolume = settings.musicVolume
		soundVolume = settings.soundVolume
		difficulty = settings.difficulty
		if (isDebug == true) then
			print("Setting loaded!")
		end
	end
end

loadSettings()

composer.setVariable("musicVolume", musicVolume)
composer.setVariable("soundVolume", soundVolume)
composer.setVariable("difficulty", difficulty)

if ( isDebug == true ) then
	print( "Settings set to: musicVolume: " .. musicVolume ..", soundVolume: " .. soundVolume .. " and difficulty: " .. difficulty )
end

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

-- Reserve channel 1 for background music and 2 for sounds
audio.reserveChannels( 4 )
-- Reduce the overall volume of the channel
audio.setVolume( musicVolume, { channel=1 } )
audio.setVolume( soundVolume, { channel=2 } )
audio.setVolume( soundVolume, { channel=3 } )
audio.setVolume( soundVolume, { channel=4 } )

-- Go to the menu screen
composer.gotoScene( "menu" )
