
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require( "json" )

local isDebug = composer.getVariable("isDebug")

local filePath = system.pathForFile( "settings.json", system.DocumentsDirectory )

local musicTrack
local clickSound

local musicVolumeText
local musicVolumeSlider
local soundVolumeText
local soundVolumeSlider
local difficultyText
local difficultySlider

local settings = {}

local difficulty = composer.getVariable("difficulty")
local soundVolume = composer.getVariable("soundVolume")
local musicVolume = composer.getVariable("musicVolume")

local function saveSettings()

	settings.difficulty = difficulty
	settings.soundVolume = soundVolume
	settings.musicVolume = musicVolume
	
	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( settings ) )
		io.close( file )
		print( "Settings saved!" )
	end
end

local function gotoMenu()
	audio.play( clickSound, { channel = 4 } )
	saveSettings()
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function onSwitchPress( event )
	local switch = event.target
	
	switch:setState()
end

local function musicVolumeListener ( event )
	musicVolume = event.value / 100
	audio.setVolume( musicVolume, { channel=1 } )
	composer.setVariable( "musicVolume", musicVolume )
end

local function soundVolumeListener ( event )
	soundVolume = event.value / 100
	audio.setVolume( soundVolume, { channel=2 } )
	composer.setVariable( "soundVolume", soundVolume )
end

local function difficultySliderListener ( event )
	if( event.value < 10 ) then
		event.value = 10
		difficultyText.text = "Difficulty " .. event.value / 10
	else
		difficulty = event.value / 10
		difficultyText.text = "Difficulty " .. difficulty
		composer.setVariable( "difficulty", difficulty )
	end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	-- Load settings
	loadSettings()
	
	local background = display.newImageRect( sceneGroup, "graphics/background3.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	local tintback = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentCenterY, 550, 950, 25 )
	tintback:setFillColor( 0, 0, 0, 0.85 )

	local settingsHeader = display.newText( sceneGroup, "Settings", display.contentCenterX, 100, native.systemFont, 44 )
	
	musicVolumeText = display.newText( sceneGroup, "Music volume", display.contentCenterX - 100, 300, native.systemFont, 32 )
	musicVolumeSlider = widget.newSlider( { x = display.contentCenterX + 150, y = 300, width = 200, value = musicVolume * 100, listener = musicVolumeListener } )
	sceneGroup:insert(musicVolumeSlider)
	
	soundVolumeText = display.newText( sceneGroup, "Sound volume", display.contentCenterX - 100, 350, native.systemFont, 32 )
	soundVolumeSlider = widget.newSlider( { x = display.contentCenterX + 150, y = 350, width = 200, value = soundVolume * 100, listener = soundVolumeListener } )
	sceneGroup:insert(soundVolumeSlider)
	
	difficultyText = display.newText( sceneGroup, "Difficulty " .. difficulty, display.contentCenterX - 100, 400, native.systemFont, 32 )
	difficultySlider = widget.newSlider( { x = display.contentCenterX + 150, y = 400, width = 200, value = difficulty * 10, listener = difficultySliderListener } )
	sceneGroup:insert(difficultySlider)

	local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 920, native.systemFont, 44 )
	menuButton:setFillColor( 0.75, 0.78, 1 )
	menuButton:addEventListener( "tap", gotoMenu )
	
	clickSound = audio.loadSound( "audio/button-click.wav" )
	musicTrack = audio.loadStream( "audio/189578__zagi2__falling-birds-perc-loop.mp3" )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		audio.play( musicTrack, { channel=1, loops=-1 } )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		audio.stop( 1 )
		composer.removeScene( "settings" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	audio.dispose( musicTrack )
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
