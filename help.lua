
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local isDebug = composer.getVariable("isDebug")

local clickSound

local helpText = [[
Fly around the space and explode asteroids 
with your ship's laser.
Difficulty level can be set from 1 to 10, 
with step 0.1.
Difficulty level automatic up each 50 asteroid, 
also it can be more than 10.
You will see 3 types of asteroids:
- usually asteroid (100 score x difficulty)
- cyan tinted asteroids (500 score x difficulty)
- magenta tinted asteroid 
(1000 score and +1 live)

After each game you will see your statistic,
most important thing is a Rank.
For best rank you should 
reach as much difficulty 
as you can (starting difficulty 
level will not affect)
and be very accuracy. 
Rank is based on reached difficulty, 
accuracy and scores.

]]

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight):setFillColor(37/255, 39/255, 46/255, 0.9);
	local okButton = display.newText( sceneGroup, "OK", display.contentCenterX, display.contentCenterY + 400, native.systemFont, 42 )
	local statsHeader = display.newText( sceneGroup, "Help", display.contentCenterX, display.contentCenterY - 380, native.systemFont, 42 )
	
	local helpText = display.newText( sceneGroup, helpText, display.contentCenterX + 50, display.contentCenterY, native.systemFont, 24 )
	
	okButton:addEventListener( "tap", function() composer.hideOverlay( "fade", 400) audio.play( clickSound, { channel = 4 } ) end )
	
	clickSound = audio.loadSound( "audio/button-click.wav" )
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
