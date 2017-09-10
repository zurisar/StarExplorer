
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Configure image sheet
local sheetOptions =
{
    frames =
    {
        {   -- 1) asteroid 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        {   -- 2) asteroid 2
            x = 0,
            y = 85,
            width = 90,
            height = 83
        },
        {   -- 3) asteroid 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        },
        {   -- 4) ship
            x = 0,
            y = 265,
            width = 98,
            height = 79
        },
        {   -- 5) laser
            x = 98,
            y = 265,
            width = 14,
            height = 40
        },
    },
}
local objectSheet = graphics.newImageSheet( "gameObjects.png", sheetOptions )

-- Load ship sheet file
local shipSheetInfo = require("graphics.shipsheet")
local shipSheet = graphics.newImageSheet( "graphics/shipsheet.png", shipSheetInfo:getSheet() )

-- Create ship animations
local shipSequence = 
{
	{
		name="idle",
		frames = { 6 },
		loopCount = 1,
	},
	{
		name="moveLeft",
		frames = { 1, 2, 3, 4, 5 },
		time = 200,
		loopCount = 1,
	},
	{	
		name="backLeft",
		frames = { 1, 2, 3, 4, 5 },
		time = 100,
		loopCount = 1,
		loopDirection = "bounce",
	},
	{
		name="moveRight",
		frames = { 7, 8, 9, 10, 11 },
		time = 200,
		loopCount=1,
	},
	{
		name="backRight",
		frames = { 7, 8, 9, 10, 11 },
		time = 100,
		loopCount = 1,
		loopDirection = "bounce"
	},
}

-- Load asteroids sheet file
local asteroidsSheetInfo = require("graphics.asteroidssheet")
local asteroidsSheet = graphics.newImageSheet( "graphics/asteroidssheet.png", asteroidsSheetInfo:getSheet() )


-- Create asteroids animations
local asteroidsSequence =
{
	{
		name = "asteroid1",
		start = 1,
		count = 15,
		time=2000
	},
	{
		name = "asteroid2",
		start = 17,
		count = 15,
		time=2000
	},
	{
		name = "asteroid3",
		start = 33,
		count = 15,
		time=2000
	},
	{
		name = "asteroid4",
		start = 49,
		count = 15,
		time=2000
	},
	{
		name = "asteroid5",
		start = 65,
		count = 15,
		time=2000
	},
	{
		name = "asteroid6",
		start = 81,
		count = 15,
		time=2000
	},
}

-- Load explosion sheet
local explosionSheetInfo = require("graphics.explosion")
local explosionSheet = graphics.newImageSheet( "graphics/explosion.png", explosionSheetInfo:getSheet() )

local explosionSequence = 
{
	{
		name = "explosion",
		start = "1",
		count = "16",
		time = 2000,
		loopCount = 1,
	},	
}


-- Debug mod --> set up in main.lua
local isDebug = composer.getVariable("isDebug")
if (isDebug == true) then
	print (" Game stage started; DEBUG mod is ON ")
end

-- Initialize variables
-- Gameplay variables
local lives = 1 			-- Player lives
local score = 0 			-- Player score
local died = false 			-- Is player dead
local laserCount = 0 		-- How much player shoots
local loopCount = 0			-- How much loop game timer works; reset after 50 and increase difficulty level by 0.1
local hitCount = 0 			-- How much player destroy asteroid
local asteroidCount = 0 	-- Asteroid counter; reset after 10 and spawn 'red' asteroid which give x5 score
local newliveCount = 0 		-- Additional loop timer counter; reset after 100 and spawn 'green' asteroid which give +1 live

-- Game mechanic and objects variables
local timeTable 			-- Get system time for count how long player play
local isPaused 				-- Is game paused
local gameRestart 			-- Is player restart game
local asteroidsTable = {} 	-- Asteroid table
local asteroidType 			-- Asteroid type ( 1 - usually; 2 - red; 3 - green )
local ship 					-- Player's ship
local moveDirection			-- Where to ship move
local isMove = false		-- Is ship move
local gameLoopTimer			-- General game loop
local newAsteroid			-- Temp variable for creating new asteroids
local shipExplosion			-- Ship explosion sprite

-- Variables for text objects
local livesText
local scoreText
local asteroidCountText
local popupMessageText = nil -- If not nil it will be error on double messages, sure we can just delete variable from here, but I want to see what I use, so that's why it here.
local looserText
local laserCountText
local loopCountText


-- Pause variables
local tintPause
local pauseButton
local resumeButton
local restartButton
local exitButton

-- Display groups variables
local backGroup
local mainGroup
local uiGroup

-- Audio variables
local explosionSound
local fireSound
local musicTrack
local startSound
local bonusSound
local bonus2Sound

-- Use controller code by trevornmarshall URL: https://github.com/trevornmarshall/virtual_controller/
local factory = require("controller.virtual_controller_factory")
local controller = factory:newController()

system.activate("multitouch")

local js1 -- Joystick
local jsButton -- Fire button

-- Load settings
local musicVolume = composer.getVariable("musicVolume")
local soundVolume = composer.getVariable("soundVolume")
local difficulty = composer.getVariable("difficulty")

-- Set "global" start difficulty for stats
composer.setVariable("startDifficulty", difficulty)

if ( isDebug == true ) then
	print( "In game ettings set to global; musicVolume: " .. musicVolume ..", soundVolume: " .. soundVolume .. " and difficulty: " .. difficulty )
end

local function donothing()
	-- just nothing to do
	-- I use it for onButtonUp
end

-- Set ship animation to 'idle'
local function shipIdle ( event )
	if(died) then
		return
	else
		ship:setSequence( "idle" )
		ship:play()
	end
end

-- Move ship with animations
local function moveShip( self, x, y )
	if( isPause == false or died == false ) then
		if( x < 0 ) then
			isMove = true
			ship:setLinearVelocity( x, y )
			ship:setSequence( "moveLeft")
			ship:play()
			moveDirection = "Left"
		elseif( x > 0 ) then
			isMove = true
			ship:setLinearVelocity( x, y )
			ship:setSequence( "moveRight" )
			ship:play()
			moveDirection = "Right"
		elseif( x == 0 ) then
			isMove = false
			ship:setLinearVelocity( 0, 0 )
			if( moveDirection ) then
				ship:setSequence( "back" .. moveDirection )
				ship:play()
			end
			timer.performWithDelay( 100, shipIdle, 1 )
		end
	else
		return false
	end
end

-- Really I don't know what is it, we code it at one of first lessons and never used o_O
local function updateText()
	livesText.text = "Lives: " .. lives
	scoreText.text = "Score: " .. score
end

-- Pick random background image
local function randomBackground()
	local backgroundNumber = math.random( 1, 3)
	return backgroundNumber
end

-- Create asteroid
local function createAsteroid()
	
	asteroidCount = asteroidCount + 1
	newliveCount = newliveCount + 1
	
	if ( isDebug == true ) then
		print( "asteroids: " .. asteroidCount )
		asteroidCountText.text = "Asteroids qty: " .. asteroidCount
	end
	
		newAsteroid = display.newSprite( asteroidsSheet, asteroidsSequence )
		mainGroup:insert(newAsteroid)
		newAsteroid:scale( 2, 2 )
		--newAsteroid = display.newImageRect( mainGroup, objectSheet, 1, 102, 85 )
	
	
	if ( asteroidCount == 10 and newliveCount ~= 100) then
		asteroidCount = 0
		newAsteroid:setFillColor( 0.1, 0.9, 0.9, 0.78 )
		table.insert( asteroidsTable, newAsteroid )
		physics.addBody( newAsteroid, "dynamic", { radius=20, bounce=0.8 * difficulty } )
		newAsteroid.myName = "asteroidred"
		if ( isDebug == true ) then
			print( "Spawn red asteroid" )
		end
	
	elseif ( newliveCount == 100 ) then
		newliveCount = 0
		asteroidCount = 0 -- Reset asteroidCount also, because it equal to 10 anyway and we don't need double spawn
		newAsteroid:setFillColor( 0.9, 0.1, 0.9, 0.78 )
		table.insert( asteroidsTable, newAsteroid )
		physics.addBody( newAsteroid, "dynamic", { radius=20, bounce=0.8 * difficulty } )
		newAsteroid.myName = "asteroidgreen"
		
		if( isDebug == true ) then
			print( "Spawn green asteroid" )
		end
	
	else
		table.insert( asteroidsTable, newAsteroid )
		physics.addBody( newAsteroid, "dynamic", { radius=30, bounce=0.8 * difficulty } )
		newAsteroid.myName = "asteroid"
	end

	local whereFrom = math.random( 3 )

	if ( whereFrom == 1 ) then
		-- From the left
		newAsteroid.x = -60
		newAsteroid.y = math.random( 500 )
		newAsteroid:setLinearVelocity( math.random( 40,120 * difficulty ), math.random( 20,60 * difficulty ) )
	elseif ( whereFrom == 2 ) then
		-- From the top
		newAsteroid.x = math.random( display.contentWidth )
		newAsteroid.y = -60
		newAsteroid:setLinearVelocity( math.random( -40,40 * difficulty ), math.random( 40,120 * difficulty ) )
	elseif ( whereFrom == 3 ) then
		-- From the right
		newAsteroid.x = display.contentWidth + 60
		newAsteroid.y = math.random( 500 )
		newAsteroid:setLinearVelocity( math.random( -120 * difficulty,-40 ), math.random( 20,60 * difficulty ) )
	end

	newAsteroid:applyTorque( math.random( -6,6 ) * difficulty )
	
	newAsteroid:setSequence( "asteroid" .. math.random( 1, 6 ) )
	newAsteroid:play()
	
end

-- Fire!
local function fireLaser()
	if ( isPaused == true or died == true ) then
		return false
	else
		-- Lets clear audio channel
		if ( audio.isChannelPlaying( 2 ) ) then -- If audio already playing we just rewind it from beginning
			audio.rewind( { channel = 2 } )
		else
			-- Play fire sound!
			audio.play( fireSound, { channel=2 } )
		end
		

		local newLaser = display.newImageRect( mainGroup, objectSheet, 5, 14, 40 )
		physics.addBody( newLaser, "dynamic", { isSensor=true } )
		newLaser.isBullet = true
		newLaser.myName = "laser"
		
		laserCount = laserCount + 1
		if ( isDebug == true ) then
			print( "lasers: " .. laserCount )
			laserCountText.text = ( "Lasers: " .. laserCount )
			print( ship.x, ship.y )
		end
		
		newLaser.x = ship.x
		newLaser.y = ship.y
		newLaser:toBack()

		transition.to( newLaser, { y=-40, time=500,
			onComplete = function() display.remove( newLaser ) end
		} )
		
	end
	
end

-- Check ship position every frame, if it too far away reset speed and X.pos to screen edge
local function checkShipPosition( event )
	local x, y = ship.x, ship.y
	-- print (x, y) -- It's also debug feature, but we comment it and not use if, 60 times in second too much 
	if ( isPause == true or died == true ) then
		return false
	else
		if( x < 92 ) then
			ship:setLinearVelocity( 0, 0)
			ship.x = 92
		elseif ( x > 674 ) then
			ship:setLinearVelocity( 0, 0)
			ship.x = 674
		elseif ( y < 100 ) then
			ship:setLinearVelocity( 0, 0)
			ship.y = 100
		elseif ( y > 1035 ) then
			ship:setLinearVelocity( 0, 0)
			ship.y = 1035
		end
	end
end

-- We need to remove popup message from screen
local function removePopupMessage ()
	if( popupMessageText ) then
		popupMessageText:removeSelf()
		popupMessageText = nil
	end
end

-- Function for display popup message while gaming
local function popupMessage ( message )
	if( popupMessageText ) then
		popupMessageText.text = message
	else
		popupMessageText = display.newText( message, display.contentCenterX, display.contentCenterY, native.systemFont, 62 )
		timer.performWithDelay( 1500, removePopupMessage, 1)
	end
end

-- General game loop 
local function gameLoop()

	-- Create new asteroid
	createAsteroid()
	
	loopCount = loopCount + 1
	-- timeCount = timeCount + 1
	if( isDebug == true ) then
		print( "Loops: " .. loopCount )
		loopCountText.text = ( "Loops: " .. loopCount )
		-- print( "Time: " .. timeCount .. " secs" )
	end
	
	if ( loopCount == 50 ) then
		difficulty = difficulty + 0.1
		loopCount = 0
		popupMessage( "Difficulty increse!" )
	end
	


	-- Remove asteroids which have drifted off screen
	for i = #asteroidsTable, 1, -1 do
		local thisAsteroid = asteroidsTable[i]

		if ( thisAsteroid.x < -100 or
			 thisAsteroid.x > display.contentWidth + 100 or
			 thisAsteroid.y < -100 or
			 thisAsteroid.y > display.contentHeight + 100 )
		then
			display.remove( thisAsteroid )
			table.remove( asteroidsTable, i )
		end
	end
end

-- Restore ship after death
local function restoreShip()

	ship.isBodyActive = false
	ship.x = display.contentCenterX
	ship.y = display.contentHeight - 100

	-- Fade in the ship
	transition.to( ship, { alpha=1, time=4000,
		onComplete = function()
			ship.isBodyActive = true
			died = false
		end
	} )
end

-- Game is over
local function endGame()
	-- Try to remove popup
	removePopupMessage()
	-- Remove explosion sprite
	shipExplosion:removeSelf()
	shipExplosion = nil
	-- Let's get some statisctis
	local totalShots 		= laserCount
	local totalHits 		= hitCount
	local totalAccuracy 	= 0
	local totalDifficulty 	= difficulty
	
	if( totalShots > 0 ) then
		totalAccuracy = math.floor( totalHits / ( totalShots / 100 ) )
	end
	
	-- Stop game loop; asteroids will fly and collision, but will not spawn anymore
	timer.cancel( gameLoopTimer )
	-- Also stop detect ship position, we don't need it anymore
	Runtime:removeEventListener( "enterFrame", checkShipPosition )
	
	-- Calculate time
	local currentTime = os.time()
	totalTime = os.difftime( currentTime, timeTable )
	
	-- Set "global" variables
	composer.setVariable( "totalShots", totalShots )
	composer.setVariable( "totalHits", totalHits )
	composer.setVariable( "totalAccuracy", totalAccuracy )
	composer.setVariable( "finalScore", score )
	composer.setVariable( "totalTime", totalTime )
	composer.setVariable( "totalDifficulty", totalDifficulty )
	
	display.remove( looserText )
	looserText = nil
	-- Show stats
	composer.showOverlay ( "stats", { isModal=true, time=400, effect="fade" } )
end

-- Choose sound for different asteroid types and additional 'bonus'
local function playExplodeSound( asteroidType )
	-- Ok let's make few asteroid types
	-- Type 1 is just usually asteroid
	-- Type 2 is red asteroid
	-- Type 3 is green steroid
	-- Ok, let's rock!
	
	-- Also we need include channel check function
	
	local function isChannelPlaying( channel )
		if( audio.isChannelPlaying ( channel ) ) then
			audio.rewind( channel )
			return false
		end
	end
	
	if( asteroidType == 1 ) then
		if( isChannelPlaying( 3 ) ) then
		else
			audio.play( explosionSound, { channel=3 } )
		end
	elseif ( asteroidType == 2 ) then
		if( isChannelPlaying( 3 ) ) then
		else
			audio.play( explosionSound, { channel=3 } )
		end
		audio.play( bonus2Sound, { channel=4 } )
	else
		if( isChannelPlaying( 3 ) ) then
		else
			audio.play( explosionSound, { channel=3 } )
		end
		-- We don't check channel 4, because I hope player can't get two green steroids on screen at one moment
		audio.play( bonusSound, { channel=4 } )
	end
end

-- Detect collisions, reward player, count lives
local function onCollision( event )

	if ( event.phase == "began" ) then

		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "laser" and obj2.myName == "asteroid" ) or
			 ( obj1.myName == "asteroid" and obj2.myName == "laser" ) )
		then
			-- Remove both the laser and asteroid
			display.remove( obj1 )
			display.remove( obj2 )

			-- Play explosion sound!
			playExplodeSound( 1 )

			for i = #asteroidsTable, 1, -1 do
				if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
					table.remove( asteroidsTable, i )
					break
				end
			end

			-- Increase score
			score = score + 100 * difficulty
			scoreText.text = "Score: " .. score
			hitCount = hitCount + 1
			
		-- Red asteroids
		elseif ( ( obj1.myName == "laser" and obj2.myName == "asteroidred" ) or
				 ( obj1.myName == "asteroidred" and obj2.myName == "laser" ) )
		then
			-- Remove both the laser and asteroid
			display.remove( obj1 )
			display.remove( obj2 )

			-- Play explosion sound!
			playExplodeSound( 2 )

			for i = #asteroidsTable, 1, -1 do
				if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
					table.remove( asteroidsTable, i )
					break
				end
			end

			-- Increase score
			score = score + 500 * difficulty
			scoreText.text = "Score: " .. score
			hitCount = hitCount + 1
			
			popupMessage( "Score x5!!!" )
		
		-- Green asteroids
		elseif ( ( obj1.myName == "laser" and obj2.myName == "asteroidgreen" ) or
				 ( obj1.myName == "asteroidgreen" and obj2.myName == "laser" ) )
		then
			-- Remove both the laser and asteroid
			display.remove( obj1 )
			display.remove( obj2 )

			-- Play explosion and bonus sound!
			playExplodeSound( 3 )

			for i = #asteroidsTable, 1, -1 do
				if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
					table.remove( asteroidsTable, i )
					break
				end
			end

			-- Increase score
			score = score + 1000 * difficulty
			scoreText.text = "Score: " .. score
			hitCount = hitCount + 1
			
			lives = lives + 1
			livesText.text = "Lives: " .. lives
			
			popupMessage( "Live +1!!!" )
			
		elseif ( ( obj1.myName == "ship" and obj2.myName == "asteroid" ) or
				 ( obj1.myName == "asteroid" and obj2.myName == "ship" ) or
				 ( obj1.myName == "asteroidred" and obj2.myName == "ship" ) or
				 ( obj1.myName == "ship" and obj2.myName == "asteroidred" ) or
				 ( obj1.myName == "asteroidgreen" and obj2.myName == "ship" ) or
				 ( obj1.myName == "ship" and obj2.myName == "asteroidgreen" ) )
		then
			if ( died == false ) then
				died = true

				-- Play explosion sound!
				audio.play( explosionSound, { channel=3 } )

				-- Update lives
				lives = lives - 1
				livesText.text = "Lives: " .. lives

				if ( lives == 0 ) then
					removePopupMessage()
					looserText = display.newText( uiGroup, "Looser!", display.contentCenterX, display.contentCenterY, native.systemFont, 62 )
					shipExplosion = display.newSprite( explosionSheet, explosionSequence )
					mainGroup:insert(shipExplosion)
					shipExplosion.x = ship.x
					shipExplosion.y = ship.y
					shipExplosion:setSequence( "explosion" )
					shipExplosion:play()
					display.remove( ship )
					timer.performWithDelay( 2000, endGame )
				else
					ship.alpha = 0
					timer.performWithDelay( 1000, restoreShip )
				end
			end
		end
	end
end

-- Just exit
local function exitGame()
	composer.gotoScene ( "menu" )
end

-- Restart game function
local function restartGame()
	local game = composer.getSceneName( "current" )
	
	restartButton:removeEventListener( "tap", restartGame )
	restartButton:removeSelf()
	restartButton = nil
	
	-- We enable gameRestart variable and go to menu scene, I tried use usually go to game scene, but it isn't work :(
	gameRestart = true
	composer.setVariable( "gameRestart", true )
	composer.gotoScene( "menu" )
end

-- Resume game after pause
local function resumeGame()
	timer.resume( gameLoopTimer )
	physics.start()
	Runtime:addEventListener( "enterFrame", checkShipPosition )
	isPaused = false
	
	resumeButton:removeEventListener( "tap", resumeGame )
	resumeButton:removeSelf()
	resumeButton = nil
	restartButton:removeEventListener( "tap", restartButton )
	restartButton:removeSelf()
	restartButton = nil
	exitButton:removeEventListener( "tap", exitGame )
	exitButton:removeSelf()
	exitButton = nil
	tintPause:removeSelf()
	tintPause = nil
	
	changePauseButtonState("onResume")

end

-- Pause game
local function pauseGame()
	
	timer.pause( gameLoopTimer )
	physics.pause()
	Runtime:removeEventListener( "enterFrame", checkShipPosition )
	isPaused = true
	
	tintPause = display.newRoundedRect ( uiGroup, display.contentCenterX, display.contentCenterY, 400, 300, 25 )
	tintPause:setFillColor( 0, 0, 0, 0.85 )
	resumeButton = display.newText ( uiGroup, "Resume", display.contentCenterX, display.contentCenterY - 100, native.systemFont, 36 )
	restartButton = display.newText ( uiGroup, "Restart", display.contentCenterX, display.contentCenterY , native.systemFont, 36 )
	exitButton = display.newText ( uiGroup, "Exit to menu", display.contentCenterX, display.contentCenterY + 100, native.systemFont, 36 )
	
	resumeButton:addEventListener( "tap", resumeGame )
	restartButton:addEventListener( "tap", restartGame )
	exitButton:addEventListener( "tap", exitGame )
	
	changePauseButtonState("onPause")

end

-- We change pause button state, player can also tap on pause button again and game will be resumed
function changePauseButtonState ( state )
	if ( state == "onPause" ) then
		pauseButton:removeEventListener( "tap", pauseGame )
		pauseButton:addEventListener( "tap", resumeGame )
	elseif ( state == "onResume" ) then
		pauseButton:removeEventListener( "tap", resumeGame )
		pauseButton:addEventListener( "tap", pauseGame )
	end
end

-- Controllers setup
local function setupController(displayGroup)
	local js1Properties = {
		nToCRatio = 0.5,	
		radius = 60, 
		x = 200, 
		y = display.contentHeight - 100, 
		restingXValue = 0, 
		restingYValue = 0, 
		rangeX = 200, 
		rangeY = 200,
		touchHandler = {
			onTouch = moveShip
		}
	}

	local js1Name = "js1"
	js1 = controller:addJoystick(js1Name, js1Properties)

	local jsButtonProperties = {
		text = "F",	
		radius = 50, 
		x = display.contentWidth - 200, 
		y = display.contentHeight - 100, 
		eventHandler = {
			onButtonDown = fireLaser,
			onButtonUp = donothing,
				
		}
	}
	
	local jsButtonName = "jsButton"
	jsButton = controller:addButton(jsButtonName, jsButtonProperties)

	controller:displayController(displayGroup)
	
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause()  -- Temporarily pause the physics engine

	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group
	
	controlGroup = display.newGroup()
	sceneGroup:insert( controlGroup )

	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
	
	setupController(uiGroup)
	
	-- Load the background
	local background = display.newImageRect( backGroup, "graphics/background" .. randomBackground() .. ".png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background.path.x1 = 20
	background.path.x4 = -20
	
	local tintback = display.newRoundedRect( uiGroup, display.contentCenterX, display.contentCenterY - 500, 600, 200, 0 )
	tintback:setFillColor( 0, 0, 0, 0.65 )
	
	ship = display.newSprite( shipSheet , shipSequence )
	ship:setFillColor( 1, 1, 1, 0.92 )
	ship.x = display.contentCenterX
	ship.y = display.contentHeight - 100
	physics.addBody( ship, { radius=30, isSensor=true } )
	ship.myName = "ship"
	
	
	
	pauseButton = display.newText ( uiGroup, "Pause", display.contentCenterX + 200, 80, native.systemFont, 36 )
	
	-- Display lives and score
	livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
	scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )
	
	if ( isDebug == true ) then
		asteroidCountText = display.newText( uiGroup, "Asteroids qty: " .. asteroidCount, 400, 120, native.systemFont, 32 )
		laserCountText = display.newText( uiGroup, "Lasers: " .. laserCount, 400, 150, native.systemFont, 32 )
		loopCountText = display.newText( uiGroup, "Loops: " .. loopCount, 400, 180, native.systemFont, 32 )
	end
	
	pauseButton:addEventListener( "tap", pauseGame )	

	-- Load audio
	explosionSound = audio.loadSound( "audio/explosion.wav" )
	fireSound = audio.loadSound( "audio/fire.wav" )
	musicTrack = audio.loadStream( "audio/80s-Space-Game_Looping.wav" )
	startSound = audio.loadSound( "audio/start-engine.wav" )
	bonusSound = audio.loadSound( "audio/power-up.wav" )
	bonus2Sound = audio.loadSound( "audio/bonus-pickup.wav" )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		if ( composer.getVariable( "gameRestart") == true ) then
			composer.setVariable( "gameRestart", false )
		end
		audio.setVolume( musicVolume, { channel=1 } )
		audio.setVolume( soundVolume, { channel=2 } )
		audio.setVolume( soundVolume, { channel=3 } )
		audio.setVolume( soundVolume, { channel=4 } )

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener( "collision", onCollision )
		Runtime:addEventListener( "enterFrame", checkShipPosition )
		gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
		-- Get system time
		timeTable = os.time()
		-- Start the music!
		-- audio.play( startSound, { channel=4 } )
		audio.play( musicTrack, { channel=1, loops=-1 } )
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onCollision )
		Runtime:removeEventListener( "enterFrame", checkShipPosition )
		physics.pause()
		-- Stop the music!
		audio.stop( 1 )
		composer.removeScene( "game" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	-- Dispose audio!
	audio.dispose( explosionSound )
	audio.dispose( fireSound )
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
