-----------------------------------------------------------------------------------------
--
-- menuHSJP.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--zawarcie bibloteki "widget" do tworzenia i obsługi przycisków
local widget = require "widget"

--------------------------------------------

--tworzenie lokalnych i wczesna deklaracja
local JPMedium
local back
local JPHard
local JPunlimited

--tworzenie lokalnych do obsługi dzwięku
local click=audio.loadSound("click.wav")
local backau=audio.loadSound("back.wav")

--tworzenie funkcji do obsługi przycisków
local function onJPMedium()
	audio.play(click ,{channel=2})  --dzwięk kliknięcia
	composer.removeScene("menuHSJP")  --usuwa scenę
	composer.setVariable("fwynikP2", 0)  --upewnienie się że wynik jest równy zero
	composer.gotoScene( "HighScoreJPMedium", "fade", 500 ) --przejście do menu
	
	return true --zwraca udane kliknięcie
end

--obsluga przycisku cofania
local function onBackRelease()
	audio.play(backau ,{channel=2})
	composer.removeScene("menuHSJP")
	composer.gotoScene( "menuJellyPicker", "fade", 500 )
	
	return true	
end

--obsluga przycisku do trybu hard
local function onJPHardRelease()
	audio.play(click ,{channel=2})
	composer.removeScene("menuHSJP")
	composer.setVariable("fwynik3", 0)
	composer.gotoScene( "HighScoreJellyPicker", "fade", 500 )
	
	return true	
end

--obsluga przycisku do trybu unlimited
local function onJPunlimitedRelease()
	audio.play(click ,{channel=2})
	composer.removeScene("menu")
	composer.setVariable("fwynikP1", 0)
	composer.gotoScene( "HighScoreJPEasy", "fade", 500 )
	
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
	local background = display.newImage( "background.jpg", display.contentWidth, display.contentheight)
		background.x = display.contentCenterX   --ustawianie tła
		background.y = display.contentCenterY

	-- wyświetlanie logo gry
	local titleLogo = display.newImageRect( "logoJP.png", 264, 42 )
		titleLogo.x = display.contentWidth * 0.5
		titleLogo.y = 50
		titleLogo:scale(1.3,1.3) --scalowanie obiektu
	
	--tworzenie widzetu "JCmedium"
	JPMedium = widget.newButton{
		label="Medium",  --nadanie etykiety 
		labelColor = { default={255}, over={128} },   --zmiana Koloru etykiety
		defaultFile="buttonHS2.png", --dodanie plików graficznych do widzetu
		overFile="button-overHS2.png",
		width=154, height=40,  --skalowanie obiektu
		onRelease = onJPMedium --nasłuchiwanie zdarzenia 
	}
	JPMedium.x = display.contentWidth*0.5 --ustawienie wartości x obiektu
	JPMedium.y = display.contentHeight - 150 --ustawienie wartości y obiektu

	--tworzenie widzetu "back"
	back = widget.newButton{
		label="Back",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=154, height=40,
		onRelease = onBackRelease	-- event listener function
	}
	back.x = display.contentWidth*0.5
	back.y = display.contentHeight - 35

	--tworzenie widzetu "JCbutton"
	JPunlimited = widget.newButton{
		label="Jelly Picker",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonHS2.png",
		overFile="button-overHS2.png",
		width=154, height=40,
		onRelease = onJPunlimitedRelease	-- event listener function
	}
	JPunlimited.x = display.contentWidth*0.5
	JPunlimited.y = display.contentHeight - 200

	--tworzenie widzetu "JChard"
	JPHard = widget.newButton{
		label="Hard",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonHS2.png",
		overFile="button-overHS2.png",
		width=154, height=40,
		onRelease = onJPHardRelease	-- event listener function
	}
	JPHard.x = display.contentWidth*0.5
	JPHard.y = display.contentHeight - 100

	--wysztkie wyświetlane obiekty są dodane do grup
	--Kolejność dodoawania ma znaczenie przy nakładaniu się objektów
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( JPMedium )
	sceneGroup:insert( back )
	sceneGroup:insert( JPHard )
	sceneGroup:insert( JPunlimited )
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

--wywołanie funkcji destroy sceny
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