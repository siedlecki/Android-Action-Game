
local composer = require( "composer" )
 
local scene = composer.newScene()
 
local widget = require "widget"
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
--używam bibloteki Json do zapisywania wyników do plików
 local json = require("json")
 
 --tworzenie lokalnych
 local tabelaWynikow = {}

 --ścieżka do pliku z wynikami
 local sciezka = system.pathForFile("ScoreJP1.json", system.DocumentsDirectory)
 
 --funkcja wczytująca wynik z istniejącego pliku 
local function wczytajWyniki()
    local file =io.open(sciezka, "r") --zapisanie ścieżki do lokalnej

    if file then  --jeżeli plik istnieje to wyczytujemy jego dane
        local contents = file:read("*a")
        io.close(file)
        tabelaWynikow = json.decode(contents)
    end

    if(tabelaWynikow == nil or #tabelaWynikow == 0) then
        tabelaWynikow = {0,0,0,0,0,0,0,0,0,0} --jeżeli tabela wyników jest pusta to zerujemy komórki tabeli
    end
end

--funkcja zapisująca wyniki
local function zapiszWyniki()

    for i = #tabelaWynikow, 11, -1 do --przechodzimy przez tabele i usuwamy z niej wiersze
        table.remove(tabelaWynikow, i)
    end

    local file = io.open(sciezka, "w") --otwieramy plik do zapisu
    local temp = json.encode(tabelaWynikow)
    file:write(temp) --zapisujemy wartość do pliky
    io.close(file) --zamykamy strumień

end

--tworzenie lokalnych do obsługi dzwięku
local click=audio.loadSound("click2.wav")

--tworzenie funkcji do obsługi przycisków
local function gotoMenu()
    audio.play(click ,{channel=2}) --wywołanie dźwięku po kliknięciu na kanale drugim
    composer.removeScene("HighScoreJPEasy")  --usunięcie sceny by zwolnić pamięć i przejście do następnej
    composer.setVariable("fwynikP1", 0) --wyzerowanie zmiennej wyniku by wpisywać tej samej wartości przy wielokrotnym wejściu do HighScore
    composer.gotoScene( "menuJellyPicker", "fade", 500 )
    
    return true --zwraca udane kliknięcie
end

--tworzenie funkcji do obsługi przycisku restart
local function restart()
    audio.play(click ,{channel=2})
    composer.removeScene("HighScoreJPEasy")
    composer.setVariable("fwynikP1", 0)
    composer.gotoScene( "JellyPickerEasy", "fade", 500 )

    return true
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
--wywołanie funkcji tworzącej scenę. 
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
    --obsługa zdarzenia scenekey
    function scenekey(event)
        if ( event.keyName == "back" ) then
        return false --zwracamy fałsz by "back" nie zamykał aplikacji
          
        end
    end

    --nasłuchiwanie eventu scenekey
    Runtime:addEventListener( "key", scenekey );

    --wywołanie funkcji wczytaj wynik
    wczytajWyniki()
    table.insert(tabelaWynikow, composer.getVariable("fwynikP1"))

    --algorytm do sorotowania tabeli wyników
    local function porownaj(a,b)    
        return a>b
    end

    --sortujemy tabele
    table.sort(tabelaWynikow, porownaj)
    zapiszWyniki() --wywołanie funkcji zapisu wyników

    --tworzenie tła
    local bkg = display.newImage( "night_sky.png", display.contentWidth*0.5, display.contentHeight*0.5)
    
    --tworzenie objektów graficznych
    local linia = display.newImage( "line.png", display.contentWidth*0.5, 9)

    local HighScoreHeader = display.newText(sceneGroup, "High Scores Jelly Picker", display.contentCenterX, 10, nil, 25)
        HighScoreHeader:scale(0.8,0.8) --skalowanie objektu

    --tworzenie widzetu mButton
    local mButto = widget.newButton{
        label="Menu", --nadanie etykiety "Menu"
        labelColor = { default={255}, over={128} }, --zmiana Koloru etykiety
        defaultFile="buttonHS.png", --dodanie plików graficznych do widzetu
        overFile="button-overHS.png", --skalowanie obiektu
        width=154, height=40,
        onRelease = gotoMenu   --nasłuchiwanie zdarzenia
    }
    mButto.x = display.contentCenterX+80 --ustawienie wartości x obiektu
    mButto.y = 470 --ustawienie wartości y obiektu

    --tworzenie widzetu "New Game"
    local newGame = widget.newButton{
        label="New Game",
            labelColor = { default={255}, over={128} },
            defaultFile="buttonHS.png",
            overFile="button-overHS.png",
            width=154, height=40,
            onRelease = restart    -- event listener function
                                    }
        newGame.x = display.contentCenterX-80
        newGame.y = 470

    --wysztkie wyświetlane obiekty są dodane do grup
    --Kolejność dodoawania ma znaczenie przy nakładaniu się objektów
    sceneGroup:insert(bkg)
    sceneGroup:insert(linia)
    sceneGroup:insert(HighScoreHeader)
    sceneGroup:insert(mButto)
    sceneGroup:insert(newGame)

    --algorytm drukujący tabele wyników    
    for i =1, 10 do
        if(tabelaWynikow[i]) then
            local yPos = 20 + (i * 40)

            local rankNum = display.newText(sceneGroup, i.. ")", display.contentCenterX-50, yPos, nil, 25) --indeksowanie i wyswietlanie numeracji
                rankNum:setFillColor(0.8)
                rankNum.anchorX=1

            local thisScore = display.newText(sceneGroup, tabelaWynikow[i], display.contentCenterX-30, yPos, nil, 25) --indeksowanie i wyswietlanie wynikow
                thisScore.anchorX=0
        end

    end 

end
 
 
--wywołanie funkcji show sceny
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
--wywołanie funkcji hide sceny
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
--wywołanie funkcji destroy sceny
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Ustawienie zdarzeń nasłuchu
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene