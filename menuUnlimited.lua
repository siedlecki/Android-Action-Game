-----------------------------------------------------------------------------------------
--
-- menuUnlimited.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--zawarcie bibloteki "widget" do tworzenia i obsługi przycisków
local widget = require "widget"

--------------------------------------------

--tworzenie lokalnych i wczesna deklaracja
local timeattack
local highscore
local timeattack2
local back
local unlimitedmode

--rezerwacja kanału 1 do muzyki w tle
audio.reserveChannels( 1 )

--tworzenie lokalnych do obsługi dzwięku
local backgroundMusic = audio.loadStream( "menu.mp3" )
local click=audio.loadSound("click.wav")
local backau=audio.loadSound("back.wav")

--tworzenie funkcji do obsługi przycisków
local function onTimeAttackRelease()
	
	audio.play(click ,{channel=2}) --wywołanie dźwięku po kliknięciu na kanale drugim
	audio.stop( 1 )  --zatrzymanie muzyki w tle przed przejściem do następnej sceny
	composer.removeScene("menuUnlimited") --usunięcie sceny by zwolnić pamięć i przejście do następnej
	composer.gotoScene( "TimeAttack", "fade", 500 )
	
	return true	--zwraca udane kliknięcie
end

--obsługa przycisku Time Attack 2
local function onTimeAttack2Release()
	
	audio.play(click ,{channel=2})
	audio.stop( 1 )
	composer.removeScene("menuUnlimited")
	composer.gotoScene( "TimeAttack2", "fade", 500 )
	
	return true	-- indicates successful touch
end

--obsługa przycisku High Score
local function onHighScoreRelease()
	
	audio.play(click ,{channel=2})
	composer.removeScene("menuUnlimited")
	composer.gotoScene( "menuHSUN", "fade", 500 )
	
	return true	-- indicates successful touch
end

--obsługa przycisku Back
local function onBackRelease()
	
	audio.play(backau ,{channel=2})
	composer.removeScene("menuUnlimited")
	composer.gotoScene( "menu", "fade", 500 )
	
	return true	-- indicates successful touch
end

--obsługa przycisku Unlimite Mode
local function onUnlimitedModeRelease()
	
	audio.play(click ,{channel=2})
	audio.stop( 1 )
	composer.removeScene("menuUnlimited")
	composer.gotoScene( "unlimited", "fade", 500 )
	
	return true	-- indicates successful touch
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
		background.x = display.contentCenterX --ustawianie tła
		background.y = display.contentCenterY
	
	-- wyświetlanie logo gry
	local titleLogo = display.newImageRect( "logounlimited.png", 264, 42 )
		titleLogo.x = display.contentWidth * 0.5
		titleLogo.y = 50
		titleLogo:scale(1.3,1.3) --scalowanie obiektu
	
	--tworzenie widzetu "Unlimited Mode"
	unlimitedmode = widget.newButton{
		label="Unlimited Mode", --nadanie etykiety
		labelColor = { default={255}, over={128} }, --zmiana Koloru etykiety
		defaultFile="buttonUN.png", --dodanie plików graficznych do widzetu
		overFile="button-overUN.png",
		width=154, height=40, --skalowanie obiektu
		onRelease = onUnlimitedModeRelease	--nasłuchiwanie zdarzenia 
	}
	unlimitedmode.x = display.contentWidth*0.5 --ustawienie wartości x obiektu
	unlimitedmode.y = display.contentHeight - 250 --ustawienie wartości y obiektu

	--tworzenie widzetu "HighScores"
	highscore = widget.newButton{
		label="Highscore",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonHS2.png",
		overFile="button-overHS2.png",
		width=154, height=40,
		onRelease = onHighScoreRelease	-- event listener function
	}
	highscore.x = display.contentWidth*0.5
	highscore.y = display.contentHeight - 100

	--tworzenie widzetu "Time Attack"
	timeattack = widget.newButton{
		label="Time Attack",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonUN.png",
		overFile="button-overUN.png",
		width=154, height=40,
		onRelease = onTimeAttackRelease	-- event listener function
	}
	timeattack.x = display.contentWidth*0.5
	timeattack.y = display.contentHeight - 200

	--tworzenie widzetu "Time Attack 2"
	timeattack2 = widget.newButton{
		label="Time Attack 2",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonUN.png",
		overFile="button-overUN.png",
		width=154, height=40,
		onRelease = onTimeAttack2Release	-- event listener function
	}
	timeattack2.x = display.contentWidth*0.5
	timeattack2.y = display.contentHeight - 150

	--tworzenie widzetu "Back"
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

	--wysztkie wyświetlane obiekty są dodane do grup
	--Kolejność dodoawania ma znaczenie przy nakładaniu się objektów
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( unlimitedmode )
	sceneGroup:insert( highscore )
	sceneGroup:insert( timeattack )
	sceneGroup:insert( timeattack2 )
	sceneGroup:insert( back )

end

--wywołanie funkcji show sceny
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		audio.play( backgroundMusic, { channel=1, loops=-1 } )  --wlączenie muzyki w tle
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

--funkcja hide sceny
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