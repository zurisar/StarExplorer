
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables
local musicTrack
local clickSound

-- GOTO functions
local function gotoGame()
	audio.play( clickSound, { channel = 4 } )
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoHighScores()
	audio.play( clickSound, { channel = 4 } )
	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

local function gotoSettings()
	audio.play( clickSound, { channel = 4 } )
	composer.gotoScene( "settings", { time=800, effect="crossFade" } )
end

local function gotoCredits()
	audio.play( clickSound, { channel = 4 } )
	composer.gotoScene( "credits", { time=800, effect="crossFade" } )
end

local function showHelp()
	audio.play( clickSound, { channel = 4 } )
	composer.showOverlay ( "help", { isModal=true, time=400, effect="fade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "graphics/background1.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	local tintback = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentCenterY, 550, 950, 25 )
	tintback:setFillColor( 0, 0, 0, 0.85 )

	local title = display.newImageRect( sceneGroup, "graphics/title.png", 600, 500 )
	title.x = display.contentCenterX + 15
	title.y = display.contentCenterY - 250

	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 600, native.systemFont, 44 )
	playButton:setFillColor( 0.82, 0.86, 1 )

	local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 710, native.systemFont, 44 )
	highScoresButton:setFillColor( 0.75, 0.78, 1 )
	
	local settingsButton = display.newText( sceneGroup, "Settings", display.contentCenterX, 820, native.systemFont, 44 )
	settingsButton:setFillColor( 0.75, 0.78, 1 )
	
	local helpButton = display.newText( sceneGroup, "Help", display.contentCenterX, 930, native.systemFont, 44 )
	helpButton:setFillColor( 0.75, 0.78, 1 )

	playButton:addEventListener( "tap", gotoGame )
	highScoresButton:addEventListener( "tap", gotoHighScores )
	settingsButton:addEventListener( "tap", gotoSettings )
	helpButton:addEventListener( "tap", showHelp )

	clickSound = audio.loadSound( "audio/button-click.wav" )
	musicTrack = audio.loadStream( "audio/368770__furbyguy__8-bit-bass-lead.mp3" )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		if ( composer.getVariable( "gameRestart" ) == true ) then
			composer.gotoScene( "game" )
		end
		-- Start the music!
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
		-- Stop the music!
		audio.stop( 1 )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	-- Dispose audio!
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
