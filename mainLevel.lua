-----------------------------------------------------------------------------------------
--
-- mainLevel.lua
--
-- Notes: Add more gravity after jump for a moment
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

physics.setDrawMode( "normal" )

local playerDirectionRight = -1 
local playerDirectionLeft = 1

local Doober
local Background1, Background2, Background3
local leftMove, rightMove, jumpMove
local background, ground

local motionx = 0
local dooberSpeed = 5

local DooberForceX = 0.0 --might not need these too
local DooberForceY = 0.0
local MaxSpeedX = 8.0
local MaxSpeedY = 7.0
local SpeedAmount = 1.0

local platform_bound = { -60, -15, 60, -15, -60, 15, 60, 15  }

 -- The platforms should be put in this array
local Array_of_Platforms = {}
local Array_of_Backgrounds = {}

-- This is what is added to change the Y of Everthing for pans.
local OFFSETY = 0; -- This is changed by something else a hit box at the top and the bottom that and to this to keep player on screen


local function New_Platform (x,y)

	-- put code in here that makes a new platfor and shove it into the array with it's x and y;
	local NewPlatform

	NewPlatform = display.newRect(x, y, 120, 30)
	physics.addBody(NewPlatform, "static", {friction=0.5})
  
  NewPlatform.objType = "ground"
  
	table.insert(Array_of_Platforms,NewPlatform)

end




-- global variables
bottomSectionSize = 350 -- This is for the height of left and right touch areas
-------------------------------------

-- Gradient color
local backgroundGrad = {
	type = "gradient",
	color2 = {0/255, 178/255, 237/255, 1},
	color1 = {0/255, 99/255, 237/255, 0.7},
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


local backgroundSpriteSheet = 
{
  frames = 
  {
    { -- Tower1
      x = 0,
      y = 1100,
      width = 720,
      height = 1080
    },
     { -- Tower1
      x = 0,
      y = 1100,
      width = 720,
      height = 760
    },
     { -- Tower2
      x = 0,
      y = 0,
      width = 720,
      height = 1079
    }
  }
}

local backgroundSheet = graphics.newImageSheet("TowerSprite20px_Split.png", backgroundSpriteSheet)
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

function dooberCollide(self, event)
  if ( event.selfElement == 2 and event.other.objType == "ground" ) then
      if ( event.phase == "began" and self.goThrough == false ) then
         self.goThrough = true
      elseif ( event.phase == "ended" and self.goThrough == true ) then
         self.goThrough = false
      end
   end
end

--Create Doober
local function makeDoober()
	doober = display.newSprite(dooberSheet, seq_doober)
	doober.x = display.actualContentWidth/2
	doober.y = 1000
	doober.rightMove = 0
	doober.leftMove = 0
	local boundery = { -17, -35, 17, -35, -15, 35, 13, 35  }
	physics.addBody(doober, "dynamic", {shape = boundery, density=4,  friction=0.3}, {box= {halfWidth = 25, halfHeight=10, x=0, y=-30}, isSensor = true} )
	
	doober.isFixedRotation = true
  doober.objType = "player"
  doober.goThrough = false
  
  doober.collision = dooberCollide
  doober:addEventListener( "collision", doober )
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

local function dooberGoThrough()
  if doober.goThrough == true then
    
  end
end

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
  if(event.phase == "began") then
    print("jumpMove!")
    doober:applyLinearImpulse( 0, -270, doober.x, doober.y )
    OFFSETY = 1
  end
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
	jumpMove:addEventListener("touch", jumpListener)
end
-------------------------------------

--- Temp Assets (This will be deleted once we have proper assets)
local function createTempBackground()
	background = display.newRect(display.screenOriginX, display.screenOriginY, display.actualContentWidth, display.actualContentHeight)
	background.fill = backgroundGrad
	background.anchorX = 0
	background.anchorY = 0	
end

local function createGround() -- use as ground
	ground = display.newImageRect(backgroundSheet, 1, 720, 1080) 
  ground.anchorX = 0
	ground.anchorY = 0	
  ground.x = 0
  ground.y = display.actualContentHeight - 1080
  print(ground.y)
  local boundery = {-460, 385, 720, 385, -460, 540, 720, 540  }
	physics.addBody(ground, "static", {shape = boundery, friction=0.5})
end

local function createBackground()
  
  Background1= display.newImageRect(backgroundSheet, 3, 720, 1079)
  Background2= display.newImageRect(backgroundSheet, 3, 720, 1079)
  Background3= display.newImageRect(backgroundSheet, 3, 720, 1079)
  Background1.anchorX = 0
	Background1.anchorY = 0
  Background2.anchorX = 0
	Background2.anchorY = 0
  Background3.anchorX = 0
	Background3.anchorY = 0
  
  Background1.x = 0
  Background1.y = ground.y - Background1.contentHeight

  
  Background2.x = 0
  Background2.y = Background1.y - Background2.contentHeight

  Background3.x = 0
  Background3.y = Background2.y - Background3.contentHeight 
  
end
-------------------------------------

local function moveBackground()
  Background1.y = Background1.y + OFFSETY
  Background2.y = Background2.y + OFFSETY
  Background3.y = Background3.y + OFFSETY
  
  if (Background1.y) > 1400 then
  Background1:translate(0,-3237)
  end
  if (Background2.y) > 1400 then
   Background2:translate(0,-3237)
  end
  if (Background3.y) > 1400 then
   Background3:translate(0,-3237)
  end
end 


-- Game LOOP

local function gameLoop()

	for i = 1 , table.getn(Array_of_Platforms) do
	
	--Array_of_Platforms[i].x = Array_of_Platforms[i].x + 20
	
	--print(Array_of_Platforms[i].y)
	
	end

	UpdateMap()
	
	
	
	
end

gameLoopTimer = timer.performWithDelay(10, gameLoop, 0)





-- This updates the map and puts new platforms down;
function UpdateMap()

-- This is how many across
local Amount_of_Platforms = 3; 

-- Change these number to fit better just putting rouf numbers
local MinX = 100; 
local MaxX = 600; 
local Spawn_DIFF = 180;

moveBackground()
-- update Offset (for panning)
-- Needs to be size of loop. idk if arrays start at y
for i = 1, table.getn(Array_of_Platforms) do
  -- This will push its Y for cam track
  Array_of_Platforms[i].y = Array_of_Platforms[i].y + OFFSETY
  -- Also do player cam update as well.
	if i == 1 then
    doober.y = doober.y + OFFSETY
    ground.y = ground.y + OFFSETY
	end

end


-- Need to get the value of Y for the last platfor in the array
if Array_of_Platforms[#Array_of_Platforms].y>Spawn_DIFF then

  -- use this for finding points to spawn
  local Offset_off = 100;
  local Array_OF_Points = {MinX, (MinX+100)*1, (MinX+100)*2, (MinX+100)*3, (MinX+100)*4}

  local HowManyToSpawn = math.random(3)

  for i = 1, HowManyToSpawn do
    if 2 == math.random(2) then

    local TargetSpawn = math.random (5)
    --makes a platforms this should work but that funtion will need setup see above
    New_Platform(Array_OF_Points[TargetSpawn],-30)
  end

end


print(table.getn(Array_of_Platforms))

    -- check if the platfor is off the screen.
	for i = 1, table.getn(Array_of_Platforms) do

        -- This will push its Y for cam track
        if Array_of_Platforms[i].y > display.actualContentHeight then
        
        --Array_of_Platforms[i].delete -- not sure what command to use for this.
		table.remove(Array_of_Platforms,i)
		break
        --but this is the one in the array that needs to be deleted the i.
        
        end
        
    

    end

end


end 




function scene:create( event )
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	local sceneGroup = self.view
	
	-- Start Physics, Physics needs to start and stop to create physics bodys
	physics.start()
	physics.pause()
  physics.setGravity(0, 9.8*3)
	
	createTempBackground()
	createGround()
	
	createLeftMoveArea()
	createRightMoveArea()
	createJumpMoveArea()
	
	
	New_Platform (100,100)
	New_Platform (200,300)
	New_Platform (100,800)
	New_Platform (350,800)
	New_Platform (650,800)
	
	
	makeDoober()
  createBackground()
  
	sceneGroup:insert( background )
  sceneGroup:insert( Background1 )
  sceneGroup:insert( Background2 )
  sceneGroup:insert( Background3 )
	sceneGroup:insert( doober )
	sceneGroup:insert( ground )
	
	
	doober:toFront()
	
	
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