-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Seed for RNG
math.randomseed( os.time() )

-- Configure image sheet
local sheetOptions =
{
	frames =
	{
		{	-- 1) asteroid 1
			x = 0,
			y = 0,
			width = 102,
			height = 85
		},
		{	-- 2) asteroid 2
			x = 0,
			y = 85,
			width = 90,
			heght = 83
		},
		{	-- 3) asteroid 3
			x = 0,
			y = 168,
			width = 100,
			height = 97
		},
		{	-- 4) ship
			x = 0,
			y = 265,
			width = 98,
			height = 79
		},
		{	-- 5) laser
			x = 98,
			y = 265,
			width = 14,
			height = 40
		},
	},
}
local objectSheet = graphics.newImageSheet( "gameObjects.png", sheetOptions )

-- Initialize variables
local lives = 3
local score = 0
local died = false

local asteroidTable = {}

local ship
local gameLoopTimer
local livesText
local scoreText

-- Set up display groups
local backGroup = display.newGroup() -- Background image
local mainGroup = display.newGroup() -- Ship, asteroid, lasers, etc.
local uiGroup = display.newGroup() -- Ui objects: score, lives, etc.

-- Load the background
local background = display.newImageRect( backGroup, "background.png", 800, 1400 )
background.x = display.contentCenterX
background.y = display.contentCenterY

-- Load the ship
ship = display.newImageRect( mainGroup, objectSheet, 4, 98, 79)
ship.x = display.contentCenterX
ship.y = display.contentHeight - 100
physics.addBody( ship, { radius=30, isSensor=true } )
ship.myName = "ship"

-- Display lives and score
livesText = display.newText ( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
scoreText = display.newText ( uiGroup, "Score: " .. score, 400, 80, native,systemFont, 36 )

-- Hide status bar
display.setStatusBar ( display.HiddenStatusBar )

local function updateText()
	livesText.text = "Lives: " .. lives
	scoreText.text = "Score: " .. score
end

local function createAsteroid()
	local newAsteroid = display.newImageRect( mainGroup, objectSheet, 1, 102, 85)
	table.insert( asteroidTable, newAsteroid )
	physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.8 } )
	newAsteroid.myName = "asteroid"
	
	local whereFrom = math.random( 3 )
	
	if ( whereFrom == 1) then
		-- From the left
		newAsteroid.x = -60
		newAsteroid.y = math.random( 500 )
		newAsteroid:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
	elseif ( whereFrom == 2 ) then
		-- From the top
		newAsteroid.x = math.random ( display.contentWidth )
		newAsteroid.y = -60
		newAsteroid:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
	elseif ( whereFrom == 3 ) then
		-- From the right
		newAsteroid.x = display.contentWidth + 60
		newAsteroid.y = math.random( 500 )
		newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60) )
	end
	
	newAsteroid:applyTorque( math.random( -6,6 ) )
end

local function fireLaser()
	local newLaser = display.newImageRect( mainGroup, objectSheet, 5, 14, 40 )
	physics.addBody( newLaser, "dynamic", { isSensor=true } )
	newLaser.isBullet = true
	newLaser.myName = "laser"
	
	newLaser.x = ship.x
	newLaser.y = ship.y
	newLaser:toBack()
	
	transition.to( newLaser, { y=-40, time=500, onComplete = function() display.remove( newLaser ) end 
	} )
end

ship:addEventListener ( "tap", fireLaser )

local function dragShip ( event )
	local ship = event.target
	local phase = event.phase
	
	if ( "began" == phase ) then
		-- Set touch focus on ship
		display.currentStage:setFocus( ship )
		-- Store initial offset position
		ship.touchOffsetX = event.x - ship.x
		
	elseif ( "moved" == phase ) then
		-- Move the ship to new touch position
		ship.x = event.x - ship.touchOffsetX
		
	elseif ( "ended" == phase or "cancelled" == phase ) then
		-- Release touch focus on the ship
		display.currentStage:setFocus( nil )
	end
	
	return true -- Prevent touch propagation to underlying objects
end

ship:addEventListener( "touch", dragShip )

local function gameLoop()

	-- Create new asteroid
	createAsteroid()
	
	-- Remove asteroids which have drifted off screen
	for i = #asteroidTable, 1, -1 do
		local thisAsteroid = asteroidTable[i]
		
		if ( 
			thisAsteroid.x < -100 or
			thisAsteroid.x > display.contentWidth + 100 or
			thisAsteroid.y < -100 or
			thisAsteroid.y > display.contentHeight + 100 )
		then
			display.remove ( thisAsteroid )
			table.remove( asteroidTable, i )
		end
	end
end

gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )

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

local function onCollision( event )

	if ( event.phase == "began" ) then
		local obj1 = event.object1
		local obj2 = event.object2
		
		if ( ( obj1.myName == "laser" and obj2.myName == "asteroid" ) or
			 ( obj1.myName == "asteroid" and obj2.myName == "laser" ) )
		then
			display.remove( obj1 )
			display.remove( obj2 )
			
			for i = #asteroidTable, 1, -1 do
				if ( asteroidTable[i] == obj1 or asteroidTable[i] == obj2 ) then
					table.remove( asteroidTable, i )
					break
				end
			end
			
		score = score + 100
		scoreText.text = "Score: " .. score
		
		elseif ( ( obj1.myName == "ship" and obj2.myName == "asteroid" ) or 
				 ( obj1.myName == "asteroid" and obj2.myName == "ship" ) )
		then
			if ( died == false ) then
				died = true
				
				-- Update lives
				lives = lives - 1
				livesText.text = "Lives: " .. lives
				
				if ( lives == 0 ) then
					display.remove( ship )
				else
					ship.alpha = 0
					timer.performWithDelay( 1000, restoreShip )
				end
			end
		end
	end
end

Runtime:addEventListener( "collision", onCollision )