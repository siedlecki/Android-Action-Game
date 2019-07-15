-----------------------------------------------------------------------------------------
--
-- menuHSUN.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--zawarcie bibloteki "widget" do tworzenia i obsługi przycisków
local widget = require "widget"

--------------------------------------------

--tworzenie lokalnych i wczesna deklaracja
local TAButton
local back
local TA2Button
local UNButton

--tworzenie lokalnych do obsługi dzwięku
local click=audio.loadSound("click.wav")
local backau=audio.loadSound("back.wav")

--tworzenie funkcji do obsługi przycisków
local function onTAButton()
	audio.play(click ,{channel=2}) --dzwięk kliknięcia
	composer.removeScene("menuHSUN") --usuwa scenę
	composer.setVariable("fwynik2", 0)  --upewnienie się że wynik jest równy zero
	composer.gotoScene( "HighScoreTimeAttack", "fade", 500 ) --przejście do menu
	
	return true	 --zwraca udane kliknięcie
end

--obsluga przycisku cofania
local function onbackRelease()
	audio.play(backau ,{channel=2})
	composer.removeScene("menuHSUN")
	composer.gotoScene( "menuUnlimited", "fade", 500 )
	
	return true	-- indicates successful touch
end

--obsluga przycisku do trybu hard
local function onTA2ButtonRelease()
	audio.play(click ,{channel=2})
	composer.removeScene("menuHSUN")
	composer.setVariable("fwynikTA2", 0)
	composer.gotoScene( "HighScoreTA2", "fade", 500 )
	
	return true	
end

--obsluga przycisku do trybu unlimited
local function onUNButtonRelease()
	audio.play(click ,{channel=2})
	composer.removeScene("menuHSUN")
	composer.setVariable("fwynik", 0)
	composer.gotoScene( "HighScoreUnlimited", "fade", 500 )
	
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
		background.x = display.contentCenterX   --ustawianie tła
		background.y = display.contentCenterY

	-- wyświetlanie logo gry
	local titleLogo = display.newImageRect( "logounlimited.png", 264, 42 )
		titleLogo.x = display.contentWidth * 0.5
		titleLogo.y = 50
		titleLogo:scale(1.3,1.3) --scalowanie obiektu
	
	--tworzenie widzetu "TAButton"
	TAButton = widget.newButton{
		label="Time Attack",  --nadanie etykiety 
		labelColor = { default={255}, over={128} },   --zmiana Koloru etykiety
		defaultFile="buttonHS2.png", --dodanie plików graficznych do widzetu
		overFile="button-overHS2.png",
		width=154, height=40,  --skalowanie obiektu
		onRelease = onTAButton --nasłuchiwanie zdarzenia 
	}
	TAButton.x = display.contentWidth*0.5 --ustawienie wartości x obiektu
	TAButton.y = display.contentHeight - 150 --ustawienie wartości y obiektu

	--tworzenie widzetu "back"
	back = widget.newButton{
		label="Back",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=154, height=40,
		onRelease = onbackRelease	-- event listener function
	}
	back.x = display.contentWidth*0.5
	back.y = display.contentHeight - 35

	--tworzenie widzetu "UNButton"
	UNButton = widget.newButton{
		label="Unlimited Mode",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonHS2.png",
		overFile="button-overHS2.png",
		width=154, height=40,
		onRelease = onUNButtonRelease	-- event listener function
	}
	UNButton.x = display.contentWidth*0.5
	UNButton.y = display.contentHeight - 200

	--tworzenie widzetu "TA2Button"
	TA2Button = widget.newButton{
		label="Time Attack2",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonHS2.png",
		overFile="button-overHS2.png",
		width=154, height=40,
		onRelease = onTA2ButtonRelease	-- event listener function
	}
	TA2Button.x = display.contentWidth*0.5
	TA2Button.y = display.contentHeight - 100

	--wysztkie wyświetlane obiekty są dodane do grup
	--Kolejność dodoawania ma znaczenie przy nakładaniu się objektów
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( TAButton )
	sceneGroup:insert( back )
	sceneGroup:insert( TA2Button )
	sceneGroup:insert( UNButton )
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