-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"

-- physics.setGravity( 10, 1 );

physics.start(); physics.pause()


-- physics.setGravity( 0, 9.8 );

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newRect( 0, 0, screenW, screenH )
	background:setFillColor( 128 )
	
	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "grass.png", screenW, 82 )
	grass:setReferencePoint( display.BottomLeftReferencePoint )
	grass.x, grass.y = 0, display.contentHeight
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( grass, "static", { friction=0.5, shape=grassShape } )
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( grass)

	local wall1=display.newRect(0, 0, 0, display.contentHeight)
	wall1.strokeWidth = 0
	wall1:setFillColor(140, 140, 140)
	wall1:setStrokeColor(180, 180, 180)
	group:insert(wall1)

	physics.addBody( wall1, "static", { friction=0.5 } )

	local wall2=display.newRect(display.contentWidth, 0, 0, display.contentHeight)
	wall2.strokeWidth = 0
	wall2:setFillColor(140, 140, 140)
	wall2:setStrokeColor(180, 180, 180)
	group:insert(wall2)

	physics.addBody( wall2, "static", { friction=0.5 } )

	local create_crate=function()
		-- make a crate (off-screen), position it, and rotate slightly
		local crate = display.newImageRect( "crate.png", 90, 90 )
		crate.x, crate.y = math.random(display.contentWidth), -100
		crate.rotation = math.random(50)-1

		-- add physics to the crate
		physics.addBody( crate, { friction=0.5, bounce=0.2 } )
		group:insert( crate )
	end

	for i=1,3,1 do
		create_crate()
	end
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
local runtime=0
function printTimeSinceStart( event )
    -- print (event.time/1000 .. " seconds since app started." )

	local temp = system.getTimer()  --Get current game time in ms
	local dt = (temp-runtime) / (1000/60)  --60fps or 30fps as base

    -- scene.view[3].rotation=( (math.random(361)-1)*temp) / 1000*math.pow(1000,10)
end 
Runtime:addEventListener("enterFrame", printTimeSinceStart)

-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene