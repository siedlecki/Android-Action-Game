-----------------------------------------------------------------------------------------
--
-- options.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--zawarcie bibloteki "widget" do tworzenia i obsługi przycisków
local widget = require "widget"

--------------------------------------------

--tworzenie lokalnych i wczesna deklaracja
local playBtn
local m25
local m50
local m75
local m100
local mmute
local s25
local s50
local s75
local s100
local smute

local rembutton
--tworzenie lokalnych do obsługi dzwięku
local click=audio.loadSound("click.wav")
local back=audio.loadSound("back.wav")

--tworzenie funkcji do obsługi przycisków
local function onPlayBtnRelease()
	audio.play(back ,{channel=2}) --wywołanie dźwięku po kliknięciu na kanale drugim
	composer.removeScene("options") --usunięcie sceny by zwolnić pamięć i przejście do następnej
	composer.gotoScene( "menu", "fade", 500 )
	
	return true	--zwraca udane kliknięcie
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
	
	--tworzenie pól tekstowych
	local volumetext = display.newText("Master Volume",display.contentWidth*0.5,10,native.systemFont, 30)
		volumetext:setFillColor(255) --ustawienie koleoru
		volumetext.x= display.contentWidth*0.5 --ustawienie na osi x
		volumetext.y= 5 --ustawienie obiektu na osi y

	--tworzenie lini pod tekst
	local linia = display.newImage( "line.png", display.contentWidth*0.5, 5)

	--tworzenie pola tekstowego dla Dzwięku glównego
	local volumetext2 = display.newText("Sound Volume",display.contentWidth*0.5,10,native.systemFont, 30)
		volumetext2:setFillColor(255)
		volumetext2.x= display.contentWidth*0.5
		volumetext2.y= 125

	--tworzenie drugiej lini
	local linia2 = display.newImage( "line.png", display.contentWidth*0.5, 125)

	--tworzenie przucisku m25
	local function m25Release()
		audio.play(click ,{channel=2}) --wydanie dzwięku przy klinięciu
		audio.setVolume(0.25, {channel=1}) --ustawienie glośności muzyki glównej na 25%
	end

	--tworzenie przucisku m50
	local function m50Release()
		audio.play(click ,{channel=2})
		audio.setVolume(0.5, {channel=1}) --ustawienie glośności muzyki glównej na 50%
	end

	--tworzenie przucisku m75
	local function m75Release()
		audio.play(click ,{channel=2})
		audio.setVolume(0.75, {channel=1}) --ustawienie glośności muzyki glównej na 75%
	end

	--tworzenie przucisku m100
	local function m100Release()
		audio.play(click ,{channel=2})
		audio.setVolume(1.0, {channel=1}) --ustawienie glośności muzyki glównej na 100%
	end

	--tworzenie przucisku mmute
	local function mmuteRelease()
		audio.play(click ,{channel=2})
		audio.setVolume(0.0, {channel=1}) --ustawienie glośności muzyki glównej na 0%
	end

	--tworzenie przucisku s25
	local function s25Release()
		audio.play(click ,{channel=2})
		audio.setVolume(0.25, {channel=2}) --ustawienie glośności dzwięków na 25%
	end

	--tworzenie przucisku s50
	local function s50Release()
		audio.play(click ,{channel=2})
		audio.setVolume(0.5, {channel=2})--ustawienie glośności dzwięków na 50%
	end

	--tworzenie przucisku s75
	local function s75Release()
		audio.play(click ,{channel=2})
		audio.setVolume(0.75, {channel=2})--ustawienie glośności dzwięków na 75%
	end

	--tworzenie przucisku s100
	local function s100Release()
		audio.play(click ,{channel=2})
		audio.setVolume(1.0, {channel=2})--ustawienie glośności dzwięków na 100%
	end

	--tworzenie przucisku smute
	local function smuteRelease()
		audio.setVolume(0.0, {channel=2})--ustawienie glośności dzwięków na 0%
	end

	--tworzenie funkcji remRelease do usowania wyników
	local function remRelease()
		os.remove(system.pathForFile( "ScoreJCEasy.json", system.DocumentsDirectory)) --usuwa dany plik wyników z kategorii
		os.remove(system.pathForFile( "UnlimitedScore.json", system.DocumentsDirectory))
		os.remove(system.pathForFile( "ScoreTimeAttack.json", system.DocumentsDirectory))
		os.remove(system.pathForFile( "ScoreTA2.json", system.DocumentsDirectory))
		os.remove(system.pathForFile( "ScoreJellyPicker.json", system.DocumentsDirectory))
		os.remove(system.pathForFile( "ScoreJP1.json", system.DocumentsDirectory))
		os.remove(system.pathForFile( "ScoreJP2.json", system.DocumentsDirectory))
		os.remove(system.pathForFile( "ScoreJCHard.json", system.DocumentsDirectory))
		os.remove(system.pathForFile( "ScoreJCMedium.json", system.DocumentsDirectory))
	end

	-- tworzenie widzetu playBtn
	playBtn = widget.newButton{
		label="Menu", --nadanie etykiety
		labelColor = { default={0}, over={128} }, --zmiana Koloru etykiety
		defaultFile="buttonB.png", --dodanie plików graficznych do widzetu
		overFile="button-overB.png",
		width=154, height=40, --skalowanie obiektu
		onRelease = onPlayBtnRelease	--nasłuchiwanie zdarzenia 
	}
	playBtn.x = display.contentWidth*0.5 --ustawienie wartości x obiektu
	playBtn.y = display.contentHeight - 35 --ustawienie wartości y obiektu
	
	--tworzenie widzetu m25
	m25 = widget.newButton{
		label="25%",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=50, height=40,
		onRelease = m25Release	-- event listener function
	}
	m25.x = 40
	m25.y = 60

		--tworzenie widzetu m50
	m50 = widget.newButton{
		label="50%",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=50, height=40,
		onRelease = m50Release	-- event listener function
	}
	m50.x = 100
	m50.y = 60

	--tworzenie widzetu m75
	m75 = widget.newButton{
		label="75%",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=50, height=40,
		onRelease = m75Release	-- event listener function
	}
	m75.x = 160
	m75.y = 60

	--tworzenie widzetu m100
	m100 = widget.newButton{
		label="100%",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=50, height=40,
		onRelease = m100Release	-- event listener function
	}
	m100.x = 220
	m100.y = 60

	--tworzenie widzetu mmute
	mmute = widget.newButton{
		label="Mute",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=50, height=40,
		onRelease = mmuteRelease	-- event listener function
	}
	mmute.x = 280
	mmute.y = 60

	--tworzenie widzetu s25
	s25 = widget.newButton{
		label="25%",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=50, height=40,
		onRelease = s25Release	-- event listener function
	}
	s25.x = 40
	s25.y = 180

	--tworzenie widzetu s50
	s50 = widget.newButton{
		label="50%",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=50, height=40,
		onRelease = s50Release	-- event listener function
	}
	s50.x = 100
	s50.y = 180

	--tworzenie widzetu s75
	s75 = widget.newButton{
		label="75%",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=50, height=40,
		onRelease = s75Release	-- event listener function
	}
	s75.x = 160
	s75.y = 180

	--tworzenie widzetu s100
	s100 = widget.newButton{
		label="100%",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=50, height=40,
		onRelease = s100Release	-- event listener function
	}
	s100.x = 220
	s100.y = 180

	--tworzenie widzetu smute
	smute = widget.newButton{
		label="Mute",
		labelColor = { default={0}, over={128} },
		defaultFile="buttonB.png",
		overFile="button-overB.png",
		width=50, height=40,
		onRelease = smuteRelease	-- event listener function
	}
	smute.x = 280
	smute.y = 180

	--tworzenie widzetu rembuttin
	rembutton = widget.newButton{
		label="Remove HighScores",
		labelColor = { default={255}, over={128} },
		defaultFile="buttonOP.png",
		overFile="button-over.png",
		width=200, height=50,
		onRelease = remRelease	-- event listener function
	}
	rembutton.x = display.contentWidth*0.5
	rembutton.y = 300

	--wysztkie wyświetlane obiekty są dodane do grup
	--Kolejność dodoawania ma znaczenie przy nakładaniu się objektów
	sceneGroup:insert( background )
	sceneGroup:insert(linia)
	sceneGroup:insert(volumetext)
	sceneGroup:insert(linia2)
	sceneGroup:insert(volumetext2)
	sceneGroup:insert( mmute )
	sceneGroup:insert( m100 )
	sceneGroup:insert( m75 )
	sceneGroup:insert( m50 )
	sceneGroup:insert( m25 )
	sceneGroup:insert( smute )
	sceneGroup:insert( s100 )
	sceneGroup:insert( s75 )
	sceneGroup:insert( s50 )
	sceneGroup:insert( s25 )
	sceneGroup:insert( playBtn )
	sceneGroup:insert(rembutton)

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
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
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