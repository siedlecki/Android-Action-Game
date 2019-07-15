-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--zawarcie bibloteki "widget" do tworzenia i obsługi przycisków
local widget = require "widget"

--------------------------------------------

--tworzenie lokalnych i wczesna deklaracja
local newgame
local jellycatchermenu
local help
local options
local unlimitedmenu
local jellypickermenu
local credit

--rezerwacja kanału 1 do muzyki w tle
audio.reserveChannels( 1 )

--tworzenie lokalnych do obsługi dzwięku
local backgroundMusic = audio.loadStream( "menu.mp3" )
local click=audio.loadSound("click.wav")

--tworzenie funkcji do obsługi przycisków
local function onNewGameRelease()

	audio.play( click ,{channel=2} ) --wywołanie dźwięku po kliknięciu na kanale drugim
	audio.stop( 1 ) --zatrzymanie muzyki w tle przed przejściem do następnej sceny
	composer.removeScene("menu") --usunięcie sceny by zwolnić pamięć i przejście do następnej
	composer.gotoScene( "unlimited", "fade", 500 )
	
	return true	--zwraca udane kliknięcie
end

--obsługa przycisku Unlimited Menu
local function onUnlimitedMenu()
	
	audio.play( click ,{channel=2} )
	composer.removeScene("menu")
	composer.gotoScene( "menuUnlimited", "fade", 500 )
	
	return true
end

--obsługa przycisku Jelly Catcher Menu
local function onJellyCatcherMenu()
	
	audio.play( click,{channel=2} )
	composer.removeScene("menu")
	composer.gotoScene( "menuJellyCatcher", "fade", 500 )
	
	return true	
end

--obsługa przycisku HighScore
local function onHighScoreRelease()
	
	audio.play( click,{channel=2} )
	composer.removeScene("menu")
	composer.gotoScene( "menuHS", "fade", 500 )
	
	return true	
end

--obsługa przycisku Help
local function onHelpRelease()
	
	audio.play( click,{channel=2} )
	composer.removeScene("menu")
	composer.gotoScene( "Help", "fade", 500 )
	
	return true	
end

--obsługa przycisku Options
local function onOptionsRelease()

	audio.play( click,{channel=2} )
	composer.removeScene("menu")
	composer.gotoScene( "options", "fade", 500 )
	
	return true
end

--obsługa przycisku Credit
local function onCreditRelease()
	
	-- go to level1.lua scene
	audio.play( click,{channel=2} )
	composer.removeScene("menu")
	composer.gotoScene( "Credit", "fade", 500 )
	
	return true
end

--obsługa przycisku Jelly Picker Menu
local function onJellyPickerMenuRelease()
	
	audio.play( click,{channel=2} )
	composer.removeScene("menu")
	composer.gotoScene( "menuJellyPicker", "fade", 500 )
	
	return true
end

--wywołanie funkcji tworzącej scenę. 
function scene:create( event )
	local sceneGroup = self.view

	--obsługa zdarzenia scenekey
    function scenekey(event)
        if ( event.keyName == "back" ) then
        return false --zwracamy fałsz by "back" nie zamykał aplikacji
          
        end
	end

	--nasłuchiwanie eventu scenekey
	Runtime:addEventListener( "key", scenekey );

	--tworzenie i wyświetlania tła
	local background = display.newImage( "background.png", display.contentWidth, display.contentheight)
		background.x = display.contentCenterX --ustawianie tła
		background.y = display.contentCenterY

	-- wyświetlanie logo gry
	local titleLogo = display.newImageRect( "logomenu.png", 264, 42 )
		titleLogo.x = display.contentWidth * 0.5
		titleLogo.y = 50
		titleLogo:scale(1.3,1.3) --scalowanie obiektu
	
	--tworzenie widzetu "nowagra"
	newgame = widget.newButton{
		label="Play Now", --nadanie etykiety "Play Now"
		labelColor = { default={255}, over={128} }, --zmiana Koloru etykiety
		defaultFile="PlayNow.png", --dodanie plików graficznych do widzetu
		overFile="PlayNowOver.png",
		width=154, height=40, --skalowanie obiektu
		onRelease = onNewGameRelease --nasłuchiwanie zdarzenia 
	}
	newgame.x = display.contentWidth*0.5 --ustawienie wartości x obiektu
	newgame.y = display.contentHeight - 350 --ustawienie wartości y obiektu
	
	--tworzenie widzetu "Jelly Catcher Menu"
	jellycatchermenu = widget.newButton{
		label="Jelly Catcher Menu",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=154, height=40,
		onRelease = onJellyCatcherMenu
	}
	jellycatchermenu.x = display.contentWidth*0.5
	jellycatchermenu.y = display.contentHeight - 200

	--tworzenie widzetu "Help"
	help = widget.newButton{
		label="Help",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonOP.png",
		overFile="button-overOP.png",
		width=154, height=40,
		onRelease = onHelpRelease
	}
	help.x = display.contentWidth*0.5
	help.y = display.contentHeight - 100

	--tworzenie widzetu "Credit"
	credit = widget.newButton{
		label="Credit",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonOP.png",
		overFile="button-overOP.png",
		width=154, height=40,
		onRelease = onCreditRelease	
	}
	credit.x = display.contentWidth*0.5
	credit.y = display.contentHeight -30

	--tworzenie widzetu "Unlimited Menu"
	unlimitedmenu= widget.newButton{
		label="Unlimited Menu",
		labelColor = { default={255}, over={128} },
		defaultFile=("button.png"),
		overFile="button-over.png",
		width=154, height=40,
		onRelease = onUnlimitedMenu	
	}
	unlimitedmenu.x = display.contentWidth*0.5
	unlimitedmenu.y = display.contentHeight - 300

	--tworzenie widzetu "Jelly Picker Menu"
	jellypickermenu = widget.newButton{
		label="Jelly Picker Menu",
		labelColor = { default={255}, over={128} },
		defaultFile="button.png",
		overFile="button-over.png",
		width=154, height=40,
		onRelease = onJellyPickerMenuRelease
	}
	jellypickermenu.x = display.contentWidth*0.5
	jellypickermenu.y = display.contentHeight - 250

	--tworzenie widzetu "Options"
	options = widget.newButton{
		label="Options",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonOP.png",
		overFile="button-overOP.png",
		width=154, height=40,
		onRelease = onOptionsRelease
	}
	options.x = display.contentWidth*0.5
	options.y = display.contentHeight - 150

	--wysztkie wyświetlane obiekty są dodane do grup
	--Kolejność dodoawania ma znaczenie przy nakładaniu się objektów
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( newgame )
	sceneGroup:insert( unlimitedmenu )
	sceneGroup:insert( jellycatchermenu )
	sceneGroup:insert( help )
	sceneGroup:insert( options )
	sceneGroup:insert(credit)
	sceneGroup:insert( jellypickermenu )
end

--wywołanie funkcji show sceny
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		--wywołanie muzyki w tle
		audio.play( backgroundMusic, { channel=1, loops=-1 } )
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

--funkcja hide sceney
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

--wywołanie funkcji destroy sceny
function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	--usunięcie widzetu newgame
	if newgame then
		newgame:removeSelf() --widzety muszą być usuwane ręczenie
		newgame = nil --zerowanie referencji do newgame
	end
end

---------------------------------------------------------------------------------

--Ustawienie zdarzeń nasłuchu
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene