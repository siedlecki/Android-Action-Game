
local composer = require( "composer" )
local scene = composer.newScene()

-- dołączenie bibloteki widzetów
local widget = require "widget"

--tworzenie lokalnych i czesna deklaracja
local gameOver
local menu
local newgame
local multiplier=1
local gamestate="normal"
local pauseBtn
local scrollSpeed=4

--rezerwowanie kanału 1 dla muzyki w tle
audio.reserveChannels( 1 )
local backgroundMusic = audio.loadStream( "unlimited.mp3" ) --zaladowanie dzwięku

--funkcja tworzenia sceny
function scene:create( event )

    --obsługa zdarzenia scenekey
    function scenekey(event)
        if ( event.keyName == "back" ) then
        return false --zwracamy fałsz by "back" nie zamykał aplikacji
          
        end
    end

    --nasłuchiwanie eventu scenekey
    Runtime:addEventListener( "key", scenekey );

    --ładowanie dzwięków gry
    local jellysound=audio.loadSound("jelly.wav")
    local rocksound=audio.loadSound("rock.wav")
    local badjsound=audio.loadSound("badjelly.wav")
    local jarsound=audio.loadSound("jar.wav")
    local superjsound=audio.loadSound("superjelly.wav")
    local click=audio.loadSound("click2.wav")

    local sceneGroup = self.view

    --tworzenie grup do obsługi obiektów
    local jellyGroup = display.newGroup()
    local lineGroup = display.newGroup()

    --stworzenie i wywołanie silniku fizyki
    local physics = require( "physics" )
    physics.start()

    --wyliczenie połowy ekarnu
    halfW = display.contentWidth*0.5
    halfH = display.contentHeight*0.5

    --ustawianie tła 
    local bkg = display.newImage( "backgroundJPJBR.png", halfW, halfH )
        sceneGroup:insert(bkg) --dodanie do grupy

    local bkg2 = display.newImage( "backgroundJPJBR2.png", halfW, halfH ) 
        bkg2.y = bkg.y+480; --ustawianie wartości zmiennych x i y
        sceneGroup:insert(bkg2)

    local bkg3 = display.newImage( "backgroundJPJBR3.png", halfW, halfH ) 
        bkg3.y = bkg2.y+480;
        sceneGroup:insert(bkg3)

--odpowiada za animacje tła
local function move(event)

    --sprawdzenie czy nie wyskcozylismy poza linie
    if(bkg.y==nil and bkg2.y==nil and bkg3.y==nil)then
    else
        bkg.y = bkg.y - scrollSpeed
        bkg2.y = bkg2.y - scrollSpeed
        bkg3.y = bkg3.y - scrollSpeed

         --przesunięcie tła by jedno pojawiało się pod drugim
        if (bkg.y + bkg.contentWidth) < 0 then
            bkg:translate( 0, 480*3 )
        end

        if (bkg2.y + bkg2.contentWidth) < 0 then
            bkg2:translate( 0, 480*3 )
        end

        if (bkg3.y + bkg3.contentWidth) < 0 then
            bkg3:translate( 0, 480*3 )
        end

    end
end

    --nasluchujemy zdarzenie przesunięcia
    Runtime:addEventListener( "enterFrame", move )

    --tworzenie obiektów graficznych
    local linia = display.newImage( "line.png", halfW, 5)
        lineGroup:insert(linia) 

    --ustawianie i wyświetlanie zmiennych wyniku
    local score = 0
    local Wynik = display.newText("Score: ",halfW,10 )
        Wynik.x = 30
        Wynik.y = 5
        lineGroup:insert(Wynik)

    local scoreText = display.newText(score,0,10 )
        scoreText:setFillColor( 20, 10, 0 )
        scoreText.x = 70
        scoreText.y = 5
        lineGroup:insert(scoreText)

    --ustawienie i wyświetlanie zmiennych punktów życia
    local live = 3
    local liveText = display.newText(live,halfW,10 )
        liveText:setFillColor( 20, 10, 0 )
        liveText.x = 300
        liveText.y = 5
        lineGroup:insert(liveText)

    local zycia = display.newText("Lives:",halfW,10 )
        zycia.x = 270
        zycia.y = 5
        lineGroup:insert(zycia)

    --ustawienie i wyświetlanie zmiennych czasu
    local time = 0
    local time2 =300
    local czas = display.newText("00:00",halfW,10,native.systemFont, 30)
        czas:setFillColor( 20, 10, 0 )
        czas.x= halfW
        czas.y= 5
        lineGroup:insert(czas)
 
    --tworzenie funkcji gameover
    local function gameOver()
        audio.stop( 1 ) --zatrzymacie muzyki gry
        timer.cancel(f)  --wyłączenie wszystkich timerów
        timer.cancel(licznik)
        timer.cancel(licznik2)
        jellyGroup:removeSelf() --usunięcie grup obiektów
        lineGroup:removeSelf() 
        physics.stop() --zatrzymanie fizyki gry
        composer.setVariable("fwynik2", score)  --przesłanie wyniku
        composer.removeScene("TimeAttack")  --usunięcie sceny by zwolnić pamięć
        composer.gotoScene( "HighScoreTimeAttack", "fade", 500 )  --przejście do sceny wyników
    end

    --aktualizacja czasu 
    local function updateTime(event)
        --zwiększa czas
        time=time +1
        time2=time2-1

        --konwert na minuty i sekundy
        local minuty = math.floor(time2/60)
        local sekundy = time2 % 60

        --Formatowanie czasu
        local timeDisplay = string.format("%02d:%02d", minuty, sekundy)

        --update czasu
        czas.text = timeDisplay

        --wranuek przegrania
        if(time2==0)then
            gameOver()
        end

    end

--funkcja wciśnięcia żelki
local function jellyTouched(event)
    if(gamestate=="paused")then --sprawdzamy stan gry
        else
        if ( event.phase == "began" ) then
            audio.play(jellysound ,{channel=2}) --dzwięk wciśnięcią
            Runtime:removeEventListener( "enterFrame", event.self )
            event.target:removeSelf() --usuwamy obiekt po wcisnięciu
            if(multiplier==1)then --sprawdzamy czy mamy mnożnik
        	   score = score + 1
            else
        	   score=score+(1*multiplier) --algorytm zwiększania wyniku
            end
                scoreText.text = score
        end
    end
end

--funkcja wciśnięcia kamienia
local function rockTouched(event)
    if(gamestate=="paused")then
        else
        if ( event.phase == "began" ) then
            audio.play(rocksound ,{channel=2})
            Runtime:removeEventListener( "enterFrame", event.self )
            event.target:removeSelf()
            multiplier=1
            if(live==0)then --sprawdzamy stan zdrowia
                gameOver() -- jeżeli zero to wywolujemy funkcję gameOver()
            else    
                live = live-1 -- w innym wypadku odejmujemy zdrowie
                liveText.text = live    
            end
        end
    end
end

--funkcja wciśnięcia Super Jelly
local function superJellyTouched(event)
    if(gamestate=="paused")then
        else
        if ( event.phase == "began" ) then
            audio.play(superjsound ,{channel=2})
            Runtime:removeEventListener( "enterFrame", event.self )
            event.target:removeSelf()
            multiplier=multiplier+1   --zwiększamy mnożnik
        end
    end
end

--funkcja wciśnięcia jar
local function jarTouched(event)
    if(gamestate=="paused")then
        else
        if ( event.phase == "began" ) then
            audio.play(jarsound ,{channel=2})
            Runtime:removeEventListener( "enterFrame", event.self )
            event.target:removeSelf()
            if(live<3)then --sprawdzamy czy nasze zdrowie nie przekracza 3
                live = live+1 --zwiększamy zdrowie
                liveText.text = live 
            end 

            if(live>=3)then --jeżeli przekracza 3 zwiększamy wynik
        	   if(multiplier==1)then
        		  score = score + 2
        	   else
        		  score=score+(2*multiplier) --algorytm wyliczania wyniku
        	   end
        	   scoreText.text = score
            end
        end
    end    
end

--funkcje odpowiedzialne za funkcjonalność przycisku pauzy
local function resumeTouched (event)
    audio.resume( 1 )  --wznowienie muzyki na kanale 1
    audio.play(click ,{channel=2})  --dzwięk kliknięcia
    gamestate="normal"   --zmiana statusu gry na normal
    timer.resume(f)  --wznowienie timerów
    timer.resume(licznik)
    timer.resume(licznik2)
    physics.start()  --włączenie fizyki
    menuGroup:removeSelf() --usunięcie grupy menu
    menuGroup=nil

end

local function newgameTouched (event)
    audio.stop( 1 )
    audio.play(click ,{channel=2})
    menuGroup:removeSelf()
    menuGroup=nil
    timer.cancel(f)
    timer.cancel(licznik)
    timer.cancel(licznik2)
    jellyGroup:removeSelf()
    lineGroup:removeSelf()
    physics.stop()
    composer.setVariable("fwynik2", 0)
    composer.removeScene("TimeAttack")
    composer.gotoScene( "TimeAttack", "fade", 500 )

end

local function menuTouched(event)
    audio.stop( 1 )
    audio.play(click ,{channel=2})
    menuGroup:removeSelf()
    menuGroup=nil
    timer.cancel(f)
    timer.cancel(licznik)
    timer.cancel(licznik2)
    jellyGroup:removeSelf()
    lineGroup:removeSelf()
    physics.stop()
    composer.setVariable("fwynik2", 0)
    composer.removeScene("TimeAttack")
    composer.gotoScene( "menuUnlimited", "fade", 500 )

end

--funkcja pauzy gry
local function pauseBtnTouched(event)
    audio.pause( 1 ) --zatrzymacie muzyki
    if(gamestate=="paused")then  --sprawdzenie stanu gry
    else
        gamestate="paused" --ustawienie stanu gry
        menuGroup = display.newGroup()  --tworzenie nowej grupy dla obiektów
        timer.pause(f) --zatrzymacie timerów
        timer.pause(licznik)
        timer.pause(licznik2)
        physics.pause() --zatrzymacie fizyki
        backDrop = display.newRect(0, -60, 320, 590 )  --stworzenie overlayu
        backDrop.anchorX = 0
        backDrop.anchorY = 0
        backDrop:setFillColor(0, 0, 0,100/255)
        menuGroup:insert(backDrop)

        --tworzenie przycisków menu pauzy
        resume = widget.newButton{
        label="Resume",
        labelColor = { default={0}, over={128} },
        defaultFile="buttonB.png",
        overFile="button-overB.png",
        width=154, height=40,
        onRelease = resumeTouched
        }
        resume.x = display.contentWidth*0.5
        resume.y = display.contentHeight - 125
        menuGroup:insert(resume)

        newgame = widget.newButton{
        label="New Game",
        labelColor = { default={0}, over={128} },
        defaultFile="buttonB.png",
        overFile="button-overB.png",
        width=154, height=40,
        onRelease = newgameTouched
        }
        newgame.x = display.contentWidth*0.5
        newgame.y = display.contentHeight - 75
        menuGroup:insert(newgame)

        menu = widget.newButton{
        label="Menu",
        labelColor = { default={0}, over={128} },
        defaultFile="buttonB.png",
        overFile="button-overB.png",
        width=154, height=40,
        onRelease = menuTouched
        }
        menu.x = display.contentWidth*0.5
        menu.y = display.contentHeight - 25
        menuGroup:insert(menu)
    end
end

    --tworzenie przycisku pauzy
    pauseBtn = display.newImage("pause.png",display.contentWidth-20,-25 )
    pauseBtn:scale(0.6,0.6) --skalowanie obiektu
    pauseBtn:addEventListener("tap", pauseBtnTouched)  --dodanie nasłuchu przyciśnięcia
    sceneGroup:insert(pauseBtn)

-- usuwa wszystkie obiekty poza ekranem
local function offscreen(self, event)
    if(self.y == nil) then
        return
    end
    if(self.y > display.contentHeight + 50) then    
        Runtime:removeEventListener( "enterFrame", self )
        self:removeSelf()
    end
end

--usuwa jelly poza ekranem i odejmu nam zdrowie
local function jellyoffscreen(self, event)
    if(self.y == nil) then
        return
    end
    if(self.y > display.contentHeight + 50) then
    	multiplier=1
        if(live==0)then
            gameOver()
        else    
            live = live-1
            liveText.text = live
        end
        Runtime:removeEventListener( "enterFrame", self )
        self:removeSelf()
    end
end

local grav = 1.0 --ustawienie grawitacji

--dodajemy nowy obiekt
local function addNewObject()
    local startX = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
    local a = math.random(1,100)

        if(time>0)then --zwiększa grawitacje zależnie od czasu
            if(time%30==0)then
                grav = grav + 0.1
            end
        end

    if(a<=25)then --tworzenie obiektu rock

        local rock = display.newImage( "rock.png", startX, -300)
            physics.addBody( rock )
            rock.gravityScale=grav
            rock.enterFrame = offscreen
            Runtime:addEventListener( "enterFrame", rock )
            rock:addEventListener( "touch", rockTouched )
            jellyGroup:insert(rock)

    elseif(a>45 and a<=48)then --tworzenie obiektu jar
        local jar = display.newImage( "jar.png", startX, -300)
            physics.addBody( jar )
            jar.gravityScale=grav
            jar.enterFrame = offscreen
            Runtime:addEventListener( "enterFrame", jar )
            jar:addEventListener( "touch", jarTouched )
            jellyGroup:insert(jar)

    elseif(a>48 and a<=51)then --tworzenie obiektu powerJelly
        local powerJelly = display.newImage( "Power Jelly.png", startX, -300)
            physics.addBody( powerJelly )
            powerJelly.gravityScale=grav
            powerJelly.enterFrame = offscreen
            Runtime:addEventListener( "enterFrame", powerJelly )
            powerJelly:addEventListener( "touch", superJellyTouched )
            jellyGroup:insert(powerJelly)

    else
            local b=math.random(1,5) --losuje kolor żelki
            if (b==1) then
                g="jelly-blue.png"
            elseif(b==2)then
                g="jelly-green.png"
            elseif(b==3)then
                g="jelly-purple.png"
            elseif(b==4)then
                g="jelly-red.png"
            else
                g="jelly-yellow.png"
            end

        local jelly = display.newImage(g, startX, -300) --tworzenie obiektu jelly
            physics.addBody( jelly )
            jelly.gravityScale=grav
            jelly.enterFrame = jellyoffscreen
            Runtime:addEventListener( "enterFrame", jelly )
            jelly:addEventListener( "touch", jellyTouched )
            jellyGroup:insert(jelly)
    end
end

--lokalna czasu dla nowej żelki
local timeForJelly=600

--odlicza czas
licznik = timer.performWithDelay(1000, updateTime, time)

--timer odpowiedzialny za obnizanie czasu nowej żelki
licznik2=timer.performWithDelay(1000,   function() 
    scrollSpeed=scrollSpeed+0.1
    timeForJelly=timeForJelly-100
    if(timeForJelly==100)then
    timeForJelly=10
    end end,0)

--dodaje nowy obiekt co timeFor Jelly
f = timer.performWithDelay( timeForJelly, addNewObject, 0 )
end

--funkcja show sceny
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
    elseif phase == "did" then
        audio.play( backgroundMusic, { channel=1, loops=-1 } ) --muzyka w tle na kanale 1
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
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.

    elseif phase == "did" then
        -- Called when the scene is now off screen
    end 
    
end

--funkcja destroy sceny
function scene:destroy( event )
    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc.
    local sceneGroup = self.view
    
end

---------------------------------------------------------------------------------

-- Nasluchujemy zdarzeń
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene