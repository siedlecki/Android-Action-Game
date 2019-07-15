-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local jellycatchermenu
local help
local options
local jellypickermenu

local function onJellyCatcherMenu()
	
	-- go to level1.lua scene
	composer.removeScene("menuHS")
	composer.gotoScene( "menuHSJP", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onHelpRelease()
	
	-- go to level1.lua scene
	composer.removeScene("menuHS")
	composer.gotoScene( "menu", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onOptionsRelease()
	
	-- go to level1.lua scene
	composer.removeScene("menuHS")
	composer.gotoScene( "menuHSJC", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onJellyPickerMenuRelease()
	
	-- go to level1.lua scene
	composer.removeScene("menuHS")
	composer.gotoScene( "menuHSUN", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "logo.png", 264, 42 )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100
	
	-- create a widget button (which will loads level1.lua on release)
	
	jellycatchermenu = widget.newButton{
		label="Jelly Picker",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onJellyCatcherMenu	-- event listener function
	}
	jellycatchermenu.x = display.contentWidth*0.5
	jellycatchermenu.y = display.contentHeight - 150

	help = widget.newButton{
		label="Back",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onHelpRelease	-- event listener function
	}
	help.x = display.contentWidth*0.5
	help.y = display.contentHeight - 35

	jellypickermenu = widget.newButton{
		label="Unlimited Mode",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onJellyPickerMenuRelease	-- event listener function
	}
	jellypickermenu.x = display.contentWidth*0.5
	jellypickermenu.y = display.contentHeight - 200

	options = widget.newButton{
		label="Jelly Catcher",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onOptionsRelease	-- event listener function
	}
	options.x = display.contentWidth*0.5
	options.y = display.contentHeight - 100

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( jellycatchermenu )
	sceneGroup:insert( help )
	sceneGroup:insert( options )
	sceneGroup:insert( jellypickermenu )
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
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if newgame then
		newgame:removeSelf()	-- widgets must be manually removed
		newgame = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene