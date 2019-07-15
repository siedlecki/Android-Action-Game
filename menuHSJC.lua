-----------------------------------------------------------------------------------------
--
-- menuHSJC.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--zawarcie bibloteki "widget" do tworzenia i obsługi przycisków
local widget = require "widget"

--------------------------------------------

--tworzenie lokalnych i wczesna deklaracja
local JCmedium
local back
local JChar
local JCbutton

--tworzenie lokalnych do obsługi dzwięku
local click=audio.loadSound("click.wav")
local backau=audio.loadSound("back.wav")

--tworzenie funkcji do obsługi przycisków
local function onJCmedium()
	audio.play(click ,{channel=2}) --dzwięk kliknięcia
	composer.removeScene("menuHSJC") --usuwa scenę
	composer.setVariable("fwynikC2", 0) --upewnienie się że wynik jest równy zero
	composer.gotoScene( "HighScoreJCMedium", "fade", 500 ) --przejście do menu
	
	return true --zwraca udane kliknięcie
end

--obsluga przycisku cofania
local function onBackRelease()

	audio.play(backau ,{channel=2})
	composer.removeScene("menuHSJC")
	composer.gotoScene( "menuJellyCatcher", "fade", 500 )
	
	return true	
end

--obsluga przycisku do trybu hard
local function onJChardRelease()

	audio.play(click ,{channel=2})
	composer.removeScene("menuHSJC")
	composer.setVariable("fwynikC3", 0)
	composer.gotoScene( "HighScoreJellyCatcher", "fade", 500 )
	
	return true
end

--obsluga przycisku do trybu unlimited
local function onJCbuttonRelease()

	audio.play(click ,{channel=2})
	composer.removeScene("menu")
	composer.setVariable("fwynikC1", 0)
	composer.gotoScene( "HighScoreJCEasy", "fade", 500 )
	
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


	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	--tworzenie i wyświetlania tła
	local background = display.newImage( "background.jpg", display.contentWidth, display.contentHeight )
		background.x = display.contentCenterX  --ustawianie tła
		background.y = display.contentCenterY

	-- wyświetlanie logo gry
	local titleLogo = display.newImageRect( "logoJC.png", 264, 42 )
		titleLogo.x = display.contentWidth * 0.5
		titleLogo.y = 50
		titleLogo:scale(1.3,1.3) --scalowanie obiektu

	--tworzenie widzetu "JCmedium"
	JCmedium = widget.newButton{
		label="Medium", --nadanie etykiety 
		labelColor = { default={255}, over={128} },  --zmiana Koloru etykiety
		defaultFile="buttonHS2.png",  --dodanie plików graficznych do widzetu
		overFile="button-overHS2.png",
		width=154, height=40, --skalowanie obiektu
		onRelease = onJCmedium	--nasłuchiwanie zdarzenia 
	}
	JCmedium.x = display.contentWidth*0.5  --ustawienie wartości x obiektu
	JCmedium.y = display.contentHeight - 150 --ustawienie wartości y obiektu

	--tworzenie widzetu "back"
	back = widget.newButton{
		label="Back",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=154, height=40,
		onRelease = onBackRelease
	}
	back.x = display.contentWidth*0.5
	back.y = display.contentHeight - 35

	--tworzenie widzetu "JCbutton"
	JCbutton = widget.newButton{
		label="Jelly Catcher",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonHS2.png",
		overFile="button-overHS2.png",
		width=154, height=40,
		onRelease = onJCbuttonRelease	
	}
	JCbutton.x = display.contentWidth*0.5
	JCbutton.y = display.contentHeight - 200

	--tworzenie widzetu "JChard"
	JChard = widget.newButton{
		label="Hard",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonHS2.png",
		overFile="button-overHS2.png",
		width=154, height=40,
		onRelease = onJChardRelease	
	}
	JChard.x = display.contentWidth*0.5
	JChard.y = display.contentHeight - 100

	--wysztkie wyświetlane obiekty są dodane do grup
	--Kolejność dodoawania ma znaczenie przy nakładaniu się objektów
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( JCmedium )
	sceneGroup:insert( back )
	sceneGroup:insert( JChard )
	sceneGroup:insert( JCbutton )
end

--wywołanie funkcji show sceny
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

--wywołanie funkcji destroy scene
function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

--Ustawienie zdarzeń nasłuchu
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene