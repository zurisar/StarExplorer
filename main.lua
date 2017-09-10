-- Copyright (c) 2017 Corona Labs Inc.
-- Code is MIT licensed and can be re-used; see https://www.coronalabs.com/links/code/license

-- Copyright (c) 2017 Z Apps
-- author: Aleksey zurisar Vorobev 
-- email: zurisar@gmail.com

local composer = require( "composer" )
local json = require( "json" )

-- Set "global" restart variable
composer.setVariable( "gameRestart", false)

-- Debug mod true/false
local isDebug = false

if (isDebug == true) then
	composer.setVariable("isDebug", true)
end

-- Set default settings
local musicVolume = 0.5
local soundVolume = 0.5
local difficulty = 1

-- Try to load settings, work only after player check settings scene, 
-- otheways settings are standart always.
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
	-- Check only one variable, if not exist set local settings to standart variables.
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

-- Set "global" settings
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
-- Set volume for all channels
audio.setVolume( musicVolume, { channel=1 } )
audio.setVolume( soundVolume, { channel=2 } )
audio.setVolume( soundVolume, { channel=3 } )
audio.setVolume( soundVolume, { channel=4 } )

-- Go to the menu screen
composer.gotoScene( "menu" )
