-----------------------------------------------------------------------------------------
--
-- Credit.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--zawarcie bibloteki "widget" do tworzenia i obsługi przycisków
local widget = require "widget"

--------------------------------------------

--tworzenie lokalnych i wczesna deklaracja
local playBtn

--towrzenie lokalnych do obsługi dzwięku
local click=audio.loadSound("click.wav")

--tworzenie funkcji do obsługi przycisków
local function onPlayBtnRelease()
    audio.play(click ,{channel=2}) --wywołanie dźwięku po kliknięciu na kanale drugim
    composer.removeScene("Credit")--usunięcie sceny by zwolnić pamięć i przejście do następnej
    composer.gotoScene( "menu", "fade", 500 )
    
    return true --zwraca udane kliknięcie
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

    --tworzenie i wyświetlanie lini
    local linia=display.newImage("line2.png",display.contentWidth, display.contentheight )
        linia.x=150 --ustawianie lini
        linia.y=140
        linia:scale(1.5,1.5) --skalowanie lini

    --tworzenie obiektów graficznych linia
    local linia2=display.newImage("line.png",display.contentWidth, display.contentheight )
        linia2.x=150
        linia2.y=80
        linia2:scale(1.5,1.5)

    local linia3=display.newImage("line.png",display.contentWidth, display.contentheight )
        linia3.x=150
        linia3.y=200
        linia3:scale(1.5,1.5)

    local linia4=display.newImage("line2.png",display.contentWidth, display.contentheight )
        linia4.x=150
        linia4.y=260
        linia4:scale(1.5,1.5)

    --tworzenie Tła
    local background = display.newImage( "background.jpg", display.contentWidth, display.contentheight)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

    --tworzenie pól tekstowych 
    local credit = display.newText("Music Credit for music/sounds used \nin this project goes to:",display.contentWidth,10,native.systemFont, 22) --ustawianie parametry i wielkość czciąki
        credit:setFillColor(231, 228, 37) --ustawienie koloru w RGB
        credit.x=150
        credit.y= 80
        credit:scale(0.8,0.8)

    local credit2 = display.newText("http://www.freesfx.co.uk\nhttps://www.freesound.org",display.contentWidth,10,native.systemFont, 22)
        credit2:setFillColor(0, 0, 128)
        credit2.x=120
        credit2.y= 140
        credit2:scale(0.8,0.8)

    local credit3 = display.newText("Pixel Art Credit goes to: ",display.contentWidth,10,native.systemFont, 22)
        credit3:setFillColor(231, 228, 37)
        credit3.x=110
        credit3.y= 200
        credit3:scale(0.8,0.8)

    local credit4 = display.newText("https://clipartpng.com\nhttps://purepng.com",display.contentWidth,10,native.systemFont, 22)
        credit4:setFillColor(0, 0, 128)
        credit4.x=100
        credit4.y= 260
        credit4:scale(0.8,0.8)

    local credit5 = display.newText("Projekt powstal w ramach pracy\ninżynierskiej dla \nPolitechniki Bialostockiej",display.contentWidth,10,native.systemFont, 22)
        credit5:setFillColor(0, 0, 128)
        credit5.x=130
        credit5.y= 340
        credit5:scale(0.8,0.8)

    --tworzenie widzetu "playBtn"
    playBtn = widget.newButton{
        label="Menu", --nadanie etykiety "Menu"
        labelColor = { default={255}, over={128} }, --zmiana Koloru etykiety
        defaultFile="button.png", --dodanie plików graficznych do widzetu
        overFile="button-over.png",
        width=154, height=40, --skalowanie obiektu
        onRelease = onPlayBtnRelease --nasłuchiwanie zdarzenia 
    }
    playBtn.x = display.contentWidth*0.5 --ustawienie wartości x obiektu
    playBtn.y = display.contentHeight - 50 --ustawienie wartości y obiektu
    
    --wysztkie wyświetlane obiekty są dodane do grup
    --Kolejność dodoawania ma znaczenie przy nakładaniu się objektów
    sceneGroup:insert( background )
    sceneGroup:insert( linia )
    sceneGroup:insert( linia2 )
    sceneGroup:insert( linia3 )
    sceneGroup:insert( linia4 )
    sceneGroup:insert( playBtn )
    sceneGroup:insert(credit)
    sceneGroup:insert(credit2)
    sceneGroup:insert(credit3)
    sceneGroup:insert(credit4)
    sceneGroup:insert(credit5)
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
        playBtn:removeSelf() --widzety muszą być usuwane ręczenie
        playBtn = nil --zerowanie referencji do PLayBtn
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