-----------------------------------------------------------------------------------------
--
-- main.lua
-- Uber Climber Doober V 0.0.1
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

system.activate( "multitouch" )

local composer = require "composer"

composer.gotoScene( "mainLevel" )

