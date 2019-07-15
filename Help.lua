-----------------------------------------------------------------------------------------
--
-- Help.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--zawarcie bibloteki "widget" do tworzenia i obsługi przycisków
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn

--tworzenie lokalnych do obsługi dzwięku
local click=audio.loadSound("click.wav")
local back=audio.loadSound("back.wav")

--tworzenie funkcji do obsługi przycisków
local function onPlayBtnRelease()
    audio.play(click ,{channel=2}) --wywołanie dźwięku po kliknięciu na kanale drugim
    composer.removeScene("Help") --usunięcie sceny by zwolnić pamięć i przejście do następnej
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
        linia.y=32
        linia:scale(1.5,1.5) --skalowanie lini

    --tworzenie obiektów graficznych linia
    local linia2=display.newImage("line2.png",display.contentWidth, display.contentheight )
        linia2.x=150
        linia2.y=93
        linia2:scale(1.4,1.4)

    local linia3=display.newImage("line2.png",display.contentWidth, display.contentheight )
        linia3.x=150
        linia3.y=157
        linia3:scale(1.7,1.7)

    local linia4=display.newImage("line2.png",display.contentWidth, display.contentheight )
        linia4.x=150
        linia4.y=226
        linia4:scale(1.6,1.6)

    local linia5=display.newImage("line2.png",display.contentWidth, display.contentheight )
        linia5.x=150
        linia5.y=300
        linia5:scale(2,2)

    --tworzenie tłą
    local background = display.newImage( "background.jpg", display.contentWidth, display.contentheight)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

    --tworzenie obiektów graficznych oraz ich opisów
    local jelly =display.newImageRect("jelly-red.png",80,80)
        jelly.x=40
        jelly.y=30

    local opisjelly = display.newText("Rise Score by +1\nIf you miss it, Live -1",display.contentWidth,10,native.systemFont, 22) --ustawianie parametry i wielkość czciąki
        opisjelly:setFillColor(black) --ustawienie koloru w RGB
        opisjelly.x=190
        opisjelly.y= 35
    
    local badjelly =display.newImageRect("bad-red.png",80,80)
        badjelly.x=40
        badjelly.y=90

    local opisbadjelly = display.newText("Sets Score to 0\nLive -1",display.contentWidth,10,native.systemFont, 20)
        opisbadjelly:setFillColor(black)
        opisbadjelly.x=190
        opisbadjelly.y= 90

    local superjelly =display.newImageRect("Power Jelly.png",80,80)
        superjelly.x=40
        superjelly.y=155

    local opissuperjelly = display.newText("Multiplies points\nfrom Jelly",display.contentWidth,10,native.systemFont, 20)
        opissuperjelly:setFillColor(black)
        opissuperjelly.x=190
        opissuperjelly.y= 160

    local rock =display.newImageRect("rock.png",80,80)
        rock.x=40
        rock.y=225

    local opisrock = display.newText("Live -1",display.contentWidth,10,native.systemFont, 20)
        opisrock:setFillColor(black)
        opisrock.x=155
        opisrock.y= 228

    local jar =display.newImageRect("jar.png",80,80)
        jar.x=40
        jar.y=300
    
    local opisjar = display.newText("           Live +1\nIf Live equal 3 then Score +1",display.contentWidth,10,native.systemFont, 20)
        opisjar:setFillColor(black)
        opisjar.x=190
        opisjar.y= 295

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
    sceneGroup:insert( linia5 )
    sceneGroup:insert( playBtn )
    sceneGroup:insert(badjelly)
    sceneGroup:insert(jelly)
    sceneGroup:insert(superjelly)
    sceneGroup:insert(rock)
    sceneGroup:insert( opisjelly )
    sceneGroup:insert(jar)
    sceneGroup:insert(opisjar)
    sceneGroup:insert(opisrock)
    sceneGroup:insert(opisbadjelly)
    sceneGroup:insert(opissuperjelly)
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

--wywołanie funkcji hide sceny
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