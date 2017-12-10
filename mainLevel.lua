-----------------------------------------------------------------------------------------
--
-- mainLevel.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

local playerDirectionRight = -1 
local playerDirectionLeft = 1

local Doober
local leftMove, rightMove, jumpMove
local background, GroundTemp

local motionx = 0
local motiony = 0
local dooberSpeed = 5
local dooberJumpSpeed = 5

local DooberForceX = 0.0 --might not need these too
local DooberForceY = 0.0
local MaxSpeedX = 8.0
local MaxSpeedY = 7.0
local SpeedAmount = 1.0
local JumpGravity = 1


 -- The platforms should be put in this array
local Array_of_Platforms = {}

-- This is what is added to change the Y of Everthing for pans.
local OFFSETY = 0; -- This is changed by something else a hit box at the top and the bottom that and to this to keep player on screen


local function New_Platform (x,y)

-- put code in here that makes a new platfor and shove it into the array with it's x and y;
local NewPlatform

	NewPlatform = display.newRect(x, y, 120, 30)
	physics.addBody(NewPlatform, "static", {friction=0.5})


table.insert(Array_of_Platforms,NewPlatform)

end


-- global variables
bottomSectionSize = 350 -- This is for the height of left and right touch areas
-------------------------------------

-- Gradient color
local backgroundGrad = {
	type = "gradient",
	color2 = {0.1, 0.6, 1, 0.9},
	color1 = {0.3, 0.4, 1, 1},
	direction = "up"
}

-------------------------------------


--Sprite Sheet
local dooberSpriteSheet = 
{
	frames = 
	{
		{  -- idle frame 1
			x = 0,
			y = 0,
			width = 80,
			height = 80
		},
		{  -- idle frame 2
			x = 80,
			y = 0,
			width = 80,
			height = 80
		},
		{  -- idle frame 3
			x = 160,
			y = 0,
			width = 80,
			height = 80
		},
		{  -- idle frame 4
			x = 240,
			y = 0,
			width = 80,
			height = 80
		},
		{  -- running frame 1
			x = 0,
			y = 80,
			width = 80,
			height = 80
		},
		{  -- running frame 2
			x = 80,
			y = 80,
			width = 80,
			height = 80
		},
		{  -- running frame 3
			x = 160,
			y = 80,
			width = 80,
			height = 80
		},
		{  -- running frame 4
			x = 240,
			y = 80,
			width = 80,
			height = 80
		},
		{  -- running frame 5
			x = 320,
			y = 80,
			width = 80,
			height = 80
		},
		{  -- running frame 6
			x = 400,
			y = 80,
			width = 80,
			height = 80
		},
		{  -- running frame 7
			x = 480,
			y = 80,
			width = 80,
			height = 80
		},
		{  -- running frame 8
			x = 560,
			y = 80,
			width = 80,
			height = 80
		},
		{  -- running frame 9
			x = 640,
			y = 80,
			width = 80,
			height = 80
		},
		{  -- running frame 10
			x = 720,
			y = 80,
			width = 80,
			height = 80
		}
	}
}

local dooberSheet = graphics.newImageSheet("Spritesheet.png", dooberSpriteSheet)



local seq_doober = {

	{
		name = "idleStance",
		frames = {1,2,3,4,1,1,1,1,1,1},
		time = 1000,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "runningStance",
		start = 5,
		count = 10,
		time = 550,
		loopCount = 0,
		loopDirection = "forward"
	},
}

local idleDooberCharacter, runningDooberCharacter
-------------------------------------

--Create Doober
local function makeDoober()
	doober = display.newSprite(dooberSheet, seq_doober)
	doober.x = display.actualContentWidth/2
	doober.y = 350
	doober.rightMove = 0
	doober.leftMove = 0
	physics.addBody(doober, "dynamic", {friction=0.3})
end	

-------------------------------------




--Movement
local function leftMoveBegin()
	print("leftMove!")
	doober.xScale = playerDirectionLeft
	doober:setSequence("runningStance")
	--doober.right = 0
	--doober:applyForce( -1, 0, 80, 80 )
	doober.leftMove = 1
	motionx = -dooberSpeed
	doober:play()
end	

local function rightMoveBegin()
	print("rightMove!")
	doober.xScale = playerDirectionRight
	doober:setSequence("runningStance")
	--doober:applyForce( 1, 0, 80, 80 )
	--doober.leftMove = 0
	doober.rightMove = 1
	motionx = dooberSpeed
	doober:play()
end

local function moveEnd()
	doober:setSequence("idleStance")
	doober:play()
end

local function movePlayer(event)
	doober.x = doober.x + motionx
end
-------------------------------------



-- Touch Listeners (Where stuff happens when clicking the left, right, and jump area)
local function touchListener (event) 
	if(event.phase == "began") then
		display.getCurrentStage():setFocus( event.target, event.id )
		if event.target.name == "leftMove" then
			leftMoveBegin()
			if doober.leftMove == 1 then
				
			end
			-- Add more code when left button is clicked
		elseif event.target.name == "rightMove" then
			rightMoveBegin()
			if doober.rightMove == 1 then
				
			end
			-- Add more code when right button is clicked
		end
	elseif( event.phase == "ended") then
		display.getCurrentStage():setFocus( event.target, nil )
		if event.target.name == "leftMove" then
			doober.leftMove = 0
		elseif event.target.name == "rightMove" then
			doober.rightMove = 0
		end
		if doober.leftMove == 0 and doober.rightMove == 0 then
			moveEnd()
			motionx = 0;
		end
		
	end
	return true
end

local function jumpListener (event) -- Haven't finished this, can be modeled after touchListener
	
	print("jumpMove!")
	
	--DooberForceY = 25;
	
	return true
end
-------------------------------------

-- Touch Areas
local function createLeftMoveArea()
	leftMove = display.newRect(display.screenOriginX, display.actualContentHeight - bottomSectionSize, display.actualContentWidth/2, bottomSectionSize)
	leftMove.anchorX = 0
	leftMove.anchorY = 0
	leftMove.name = "leftMove"
	leftMove.isVisible = false
	leftMove.isHitTestable = true
	leftMove:addEventListener("touch", touchListener)
end

local function createRightMoveArea()
	rightMove = display.newRect(display.screenOriginX + display.actualContentWidth/2, display.actualContentHeight - bottomSectionSize, display.actualContentWidth/2 , bottomSectionSize)
	rightMove.anchorX = 0
	rightMove.anchorY = 0
	rightMove.name = "rightMove"
	rightMove.isVisible = false
	rightMove.isHitTestable = true
	rightMove:addEventListener("touch", touchListener)
end

local function createJumpMoveArea()
	jumpMove = display.newRect(display.screenOriginX, display.screenOriginY, display.actualContentWidth, display.actualContentHeight - bottomSectionSize)
	jumpMove.anchorX = 0
	jumpMove.anchorY = 0
	jumpMove.name = "jumpMove"
	jumpMove.isVisible = false
	jumpMove.isHitTestable = true
	jumpMove:addEventListener("tap", jumpListener)
end
-------------------------------------

--- Temp Assets (This will be deleted once we have proper assets)
local function createTempBackground()
	background = display.newRect(display.screenOriginX, display.screenOriginY, display.actualContentWidth, display.actualContentHeight)
	background.fill = backgroundGrad
	background.anchorX = 0
	background.anchorY = 0	
end

local function createTempPlatform() -- use as ground
	GroundTemp = display.newRect(365, 1000, 6000, 30)
	physics.addBody(GroundTemp, "static", {friction=0.5})
end
-------------------------------------


-- Game LOOP

local function gameLoop()


	--for 



	if DooberForceX < MaxSpeedX and doober.leftMove == 1 and doober.rightMove == 0 then
		DooberForceX = DooberForceX - SpeedAmount
	elseif DooberForceX > -MaxSpeedX and doober.leftMove == 0 and doober.rightMove == 1 then
		DooberForceX = DooberForceX + SpeedAmount
	end




	if doober.leftMove == 0 and doober.rightMove == 0 then
		if DooberForceX ~= 0 and DooberForceX > 0 then
			DooberForceX = DooberForceX - (SpeedAmount*2)
		elseif DooberForceX ~= 0 and DooberForceX < 0 then
			DooberForceX = DooberForceX + (SpeedAmount*2)
		end
		
	end
	
	if DooberForceX > MaxSpeedX then
	
	DooberForceX = MaxSpeedX;
	
	elseif DooberForceX < -MaxSpeedX then
	
	DooberForceX = -MaxSpeedX;
	
	end
	
	
	
	--check for falling scree boarders
	if doober.x > display.actualContentWidth then
		DooberForceX = -1;
	elseif doober.x < 0 then
		DooberForceX = 1;
	end
	
	
	
	--Gravity
	if DooberForceY > -30 then
	
	DooberForceY = DooberForceY - JumpGravity;
	
	end

	
	
	
	--doober.x = doober.x + DooberForceX
	
	--Doober:setLinearVelocity( DooberForceX, 0 )
	
	--doober.y = doober.y - DooberForceY
	
	
	--Ground Check
	if doober.y+60 > GroundTemp.y then
	
	DooberForceY = 0;
	
	--doober.y = doober.y - 1;
	
	end
	
	
	
	
end

--gameLoopTimer = timer.performWithDelay(10, gameLoop, 0)


function scene:create( event )
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	local sceneGroup = self.view
	
	-- Start Physics, Physics needs to start and stop to create physics bodys
	physics.start()
	physics.pause()
	
	createTempBackground()
	createTempPlatform()
	
	createLeftMoveArea()
	createRightMoveArea()
	createJumpMoveArea()
	
	
	makeDoober()
	
	sceneGroup:insert( background )
	sceneGroup:insert( doober )
	sceneGroup:insert( GroundTemp )
	
	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		doober:play()
		Runtime:addEventListener("enterFrame", movePlayer)
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		runningDooberCharacter:stop()
		idleDooberCharacter:stop()
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end		
end

function scene:destroy( event )
	local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene