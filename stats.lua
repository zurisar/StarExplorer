
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local isDebug = composer.getVariable("isDebug")

local finalScore = composer.getVariable("finalScore")
local totalShots = composer.getVariable("totalShots")
local totalHits = composer.getVariable("totalHits")
local totalAccuracy = composer.getVariable("totalAccuracy")
local totalTime = composer.getVariable("totalTime")
local startDifficulty = composer.getVariable("startDifficulty")
local totalDifficulty = composer.getVariable("totalDifficulty")
local rank

-- We need some variables for time
local totalMins
local totalSecs

-- Lets calc time
if ( totalTime > 60 ) then
	totalMins, totalSecs = math.modf ( totalTime / 60 )
	if( isDebug == true ) then
		print( "Case 1 time > 60 totalTime: " .. totalTime .. ", totalMins: " .. totalMins .. ", precalculated secs: " .. totalSecs )
	end
	totalSecs = totalSecs * 6
	if ( isDebug == true ) then
		print ("totalSecs: " .. totalSecs )
	end
else 
	totalMins = 0
	totalSecs = totalTime
	if( isDebug == true ) then
		print( "Case 2 time < 60 totalTime: " .. totalTime .. ", totalMins: " .. totalMins .. ", total secs: " .. totalSecs )
	end
end

-- Calculate rank
rank = ( ( totalDifficulty - startDifficulty ) * totalAccuracy )  / 10



function finishGame()

	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )

end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight):setFillColor(37/255, 39/255, 46/255, 0.9);
	local okButton = display.newText( sceneGroup, "OK", display.contentCenterX, display.contentCenterY + 400, native.systemFont, 42 )
	local statsHeader = display.newText( sceneGroup, "Statistics", display.contentCenterX, display.contentCenterY - 380, native.systemFont, 42 )
	
	-- Output our stats
	local yourRankText = display.newText( sceneGroup, "Your rank: " .. rank, display.contentCenterX, display.contentCenterY - 300, native.systemFont, 36 )
	local yourScoreText = display.newText( sceneGroup, "Your score: " .. finalScore, display.contentCenterX, display.contentCenterY - 250, native.systemFont, 32 )
	local totalShotsText = display.newText( sceneGroup, "Shots: " .. totalShots, display.contentCenterX, display.contentCenterY - 200, native.systemFont, 32 )
	local totalHitsText = display.newText( sceneGroup, "Hits: " .. totalHits, display.contentCenterX, display.contentCenterY - 150, native.systemFont, 32 )
	local totalAccuracyText = display.newText( sceneGroup, "Accuracy: " .. totalAccuracy .. "%", display.contentCenterX, display.contentCenterY - 100, native.systemFont, 32 )
	local totalDifficultyText = display.newText( sceneGroup, "Reached difficulty: " .. totalDifficulty, display.contentCenterX, display.contentCenterY - 50, native.systemFont, 32 )
	local totalTimeText = display.newText( sceneGroup, "Time: " .. totalMins .. " mins " .. totalSecs .. " secs", display.contentCenterX, display.contentCenterY, native.systemFont, 32 )
	
	okButton:addEventListener( "tap", finishGame )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

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

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
