local composer = require( "composer" )
local scene = composer.newScene()

-- dołączenie bibloteki widzetów
local widget = require "widget"

--tworzenie lokalnych i czesna deklaracja
local gameOver
local gamestate="normal"
local pauseBtn
local timerzx

--rezerwowanie kanału 1 dla muzyki w tle
audio.reserveChannels( 1 )
local backgroundMusic = audio.loadStream( "picker.mp3" ) --zaladowanie dzwięku

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
    local rocksound=audio.loadSound("glass.wav")
    local click=audio.loadSound("click2.wav")
    local jarsound=audio.loadSound("jar.wav")

    local sceneGroup = self.view

    --tworzenie grup do obsługi obiwktów
    local jellyGroup = display.newGroup()
    local lineGroup = display.newGroup()
    
    --stworzenie i wywołanie silniku fizyki
    local physics = require( "physics" )
        physics.start()
        physics.setGravity(0,0) --ustawienie grawitacji na zero by zapobiedz spadaniu obiektów

    --wyliczenie połowy ekarnu
    halfW = display.contentWidth*0.5
    halfH = display.contentHeight*0.5

    --ustawianie tła 
    local bkg = display.newImage( "bgJP.png", halfW, halfH )
        sceneGroup:insert(bkg) --dodanie do grupy

    --wyświetlenie lini
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
    local time2 = 60
    local czas = display.newText("00:00",halfW,10,native.systemFont, 30)
        czas:setFillColor( 20, 10, 0 )
        czas.x= halfW
        czas.y= 5
    lineGroup:insert(czas)

    --tworzenie lokalnych i wczesna deklaracja
    local jarcheck=0
    local PositionACheck=false
    local PositionBCheck=false
    local PositionCCheck=false
    local jellycheck=0
    local JellyPositionA=false
    local JellyPositionB=false
    local JellyPositionC=false
    local JellyPositionD=false
    local jarTimer

    --tworzenie funkcji gameover
    local function gameOver()
        audio.stop( 1 ) --zatrzymacie muzyki gry
        timer.cancel(f) --wyłączenie wszystkich timerów
        timer.cancel(f2)
        timer.cancel(licznik)
        timer.cancel(licznik2)
        if(timerzx~=nil)then --sprawdzenie czy timerzx nie jest zerem
            timer.cancel(timerzx)
        end
        composer.setVariable("fwynikP1", score) --przesłanie wyniku
        jellyGroup:removeSelf() --usunięcie grup obiektów
        lineGroup:removeSelf()
        physics.stop() --zatrzymanie fizyki gry
        composer.removeScene("JellyPickerEasy") --usunięcie sceny by zwolnić pamięć
        composer.gotoScene( "HighScoreJPEasy", "fade", 500 )  --przejście do sceny wyników
    end

    --funkcje odpowiedzialne za funkcjonalność przycisku pauzy
    local function resumeTouched (event)
        audio.resume( 1 )--wznowienie muzyki na kanale 1
        audio.play(click ,{channel=2}) --dzwięk kliknięcia
        gamestate="normal" --zmiana statusu gry na normal
        timer.resume(f) --wznowienie timerów
        timer.resume(f2)
        timer.resume(licznik)
        timer.resume(licznik2)
        if(timerzx~=nil)then--sprawdzenie timerzx
            timer.resume(timerzx)
        end
        physics.start() --włączenie fizyki
        menuGroup:removeSelf() --usunięcie grupy menu
        menuGroup=nil

    end

    local function newgameTouched (event)
        audio.stop( 1 )
        audio.play(click ,{channel=2})
        menuGroup:removeSelf()
        menuGroup=nil
        timer.cancel(f)
        timer.cancel(f2)
        timer.cancel(licznik)
        timer.cancel(licznik2)
        if(timerzx~=nil)then
            timer.cancel(timerzx)
        end
        jellyGroup:removeSelf()
        lineGroup:removeSelf()
        physics.stop()
        composer.setVariable("fwynikP1", 0)
        composer.removeScene("JellyPickerEasy")
        composer.gotoScene( "JellyPickerEasy", "fade", 500 )

    end

    local function menuTouched(event)
        audio.stop( 1 )
        audio.play(click ,{channel=2})
        menuGroup:removeSelf()
        menuGroup=nil
        timer.cancel(f)
        timer.cancel(f2)
        timer.cancel(licznik)
        timer.cancel(licznik2)
        if(timerzx~=nil)then
            timer.cancel(timerzx)
        end
        jellyGroup:removeSelf()
        lineGroup:removeSelf()
        physics.stop()
        composer.setVariable("fwynikP1", 0)
        composer.removeScene("JellyPickerEasy")
        composer.gotoScene( "menuJellyPicker", "fade", 500 )

    end

--funkcja pauzy gry
local function pauseBtnTouched(event)
    audio.pause( 1 ) --zatrzymacie muzyki
    if(gamestate=="paused")then --sprawdzenie stanu gry
    else
        gamestate="paused" --ustawienie stanu gry
        menuGroup = display.newGroup()  --tworzenie nowej grupy dla 
        timer.pause(f) --zatrzymacie timerów
        timer.pause(f2)
        timer.pause(licznik)
        timer.pause(licznik2)
        if(timerzx~=nil)then
            timer.pause(timerzx)
        end
        physics.pause() --zatrzymacie fizyki
        backDrop = display.newRect(0, -60, 320, 590 ) --stworzenie overlayu
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
    pauseBtn:scale(0.6,0.6)
    pauseBtn:addEventListener("tap", pauseBtnTouched)
    sceneGroup:insert(pauseBtn)

    --aktualizacja czasu 
    local function updateTime(event)
        --zwiększa czas
        time=time +1

        --konwert na minuty i sekundy
        local minuty = math.floor(time/60)
        local sekundy = time % 60

        --Formatowanie czasu
        local timeDisplay = string.format("%02d:%02d", minuty, sekundy)

        --update czasu
        czas.text = timeDisplay

    end

--funkcja kolizji  
local function onCollision(self,event)
    if ( event.phase == "began" ) then
        if((event.target.type=="jar" or event.target.type=="jar2" or event.target.type=="jar3") and (event.other.type=="jelly" or event.other.type=="jelly2" or event.other.type=="jelly3" or event.other.type=="jelly4"))then
            audio.play(jellysound ,{channel=2})
            if(event.target.type=="jar")then --jeżeli jar to zwalaniamy pozycję 1
                PositionACheck=false

            elseif(event.target.type=="jar2")then
                PositionBCheck=false

            elseif(event.target.type=="jar3")then
                PositionCCheck=false

            end

            if(event.other.type=="jelly")then
                JellyPositionA=false

            elseif(event.other.type=="jelly2")then
                JellyPositionB=false

            elseif(event.other.type=="jelly3")then
                JellyPositionC=false

            elseif(event.other.type=="jelly4")then
                JellyPositionD=false

            end
                    
            if(event.target.type2=="red" and event.other.type2=="red")then  --sprawdzamy kolor jar by moc dodać punkty
                score=score+1
                scoreText.text = score

            elseif(event.target.type2=="blue" and event.other.type2=="blue")then
                score=score+1
                scoreText.text = score

            elseif(event.target.type2=="green" and event.other.type2=="green")then
                score=score+1
                scoreText.text = score

            elseif(event.target.type2=="purple" and event.other.type2=="purple")then
                score=score+1
                scoreText.text = score

            elseif(event.target.type2=="yellow" and event.other.type2=="yellow")then
                score=score+1
                scoreText.text = score

            else
                if(live==0)then --jeżeli zdrowie wynosi zero to wywolujemy gameover()
                    los=timer.performWithDelay(1,gameOver,1)
                else
                    live=live-1
                    liveText.text=live
                end

            end

            jellycheck=jellycheck-1  --zwalniamy miejsce
            jarcheck=jarcheck-1
            event.target:removeSelf() --usuwamy skolidowane obiekty
            event.target=nil
            event.other:removeSelf()

        end


        if(event.other.type=="rock" or event.other.type=="rock2" or event.other.type=="rock3" or event.other.type=="rock4")then
            audio.play(rocksound ,{channel=2})
            if(event.other.type=="rock")then
                JellyPositionA=false

            elseif(event.other.type=="rock2")then
                JellyPositionB=false

            elseif(event.other.type=="rock3")then
                JellyPositionC=false

            elseif(event.other.type=="rock4")then
                JellyPositionD=false

            end

             if(score>0)then --jeżeli wynik jest wyższy niż 0 to odejmujemy punkt
                if(score==0)then
                else
                    score=score-1
                    scoreText.text = score
                    live=live-1
                    liveText.text=live
                end
            end
            
            jellycheck=jellycheck-1
            event.target:removeSelf()
            event.target=nil
            event.other:removeSelf()
            event.other=nil
            if(live==0)then
                los=timer.performWithDelay(1,gameOver,1)
            end
        end

    end

end

--funkcja dotyku jar
local function jarTouched(event)
    audio.play(jarsound ,{channel=2}) --dzwięk kliknięcia 
    if(gamestate=="paused")then
        else
        if(event.phase=="began")then
            event.target:removeSelf() --usuwa obiekt
            if (live<3) then 
                live=live+1
                liveText.text=live
            else  
                score=score+1
                scoreText.text = score
            end

            if(event.target.type=="jared")then --zwolnienie miejsca
                JellyPositionA=false
            elseif(event.target.type=="jared2")then
                JellyPositionB=false
            elseif(event.target.type=="jared3")then
                JellyPositionC=false
            elseif(event.target.type=="jared4")then
                JellyPositionD=false
            end

            jellycheck=jellycheck-1
            event.target=nil
        end
    end
end

--timer do pojawienia się nowego jar
local timeForJar2=8000

--funkcja przesuwająca żelkę
local function jellyTouched(event)
if(gamestate=="paused")then
else
    local touchedObject = event.target
    if ( event.phase == "began" ) then
        display.getCurrentStage():setFocus(event.target)
        touchedObject.startMoveX=touchedObject.x
        touchedObject.startMoveY=touchedObject.y
    elseif(event.phase=="moved")then
        if(touchedObject.startMoveX~=nil)then
        local x = (event.x-event.xStart)+touchedObject.startMoveX 
        local y = (event.y-event.yStart)+touchedObject.startMoveY
            if(x>=26 and x<=301)then 
                touchedObject.x=x
            end

            if(y<=500 and y>=-17)then 
                touchedObject.y = y
            end
        physics.addBody(touchedObject,"dynamic")  -- dodanie body do kolizji
        end
    elseif(event.phase=="ended" or event.phase =="cancelled")then
        display.getCurrentStage():setFocus(nil)
        event.target:removeSelf()

        if(touchedObject.type=="rock")then --jezeli kamien to zwalniamy pozycję kamieni
            JellyPositionA=false

        elseif(touchedObject.type=="rock2")then
            JellyPositionB=false

        elseif(touchedObject.type=="rock3")then
            JellyPositionC=false

        elseif(touchedObject.type=="rock4")then
            JellyPositionD=false

        end
 
        if(touchedObject.type=="jelly")then --jeżeli żelka to zwalniamy pozycję żelek
            JellyPositionA=false

        elseif(touchedObject.type=="jelly2")then
            JellyPositionB=false

         elseif(touchedObject.type=="jelly3")then
            JellyPositionC=false

        elseif(touchedObject.type=="jelly4")then
            JellyPositionD=false

        end

        jellycheck=jellycheck-1
    end

    return true
end
end

--funkcja dodająca nowy jar
local function addNewObject()
    --utworzenie pozycji i wczesna delklaracja zmiennych
    local positionA=display.contentWidth-265
    local positionB=display.contentWidth*0.5
    local positionC=display.contentWidth-45
    local jar
    local ColorTypeJar
    local c=0

    if (jarcheck<3)then --sprawdzamy czy mamy miejsce na nowy jar
        jarcheck=jarcheck+1
        local b=math.random(1,5) --losujemy kolor jar
            if (b==1) then
                g="jar-red.png"
                ColorTypeJar="red"
            elseif(b==2)then
                g="jar-blue.png"
                ColorTypeJar="blue"
            elseif(b==3)then
                g="jar-green.png"
                ColorTypeJar="green"
            elseif(b==4)then
                g="jar-yellow.png"
                ColorTypeJar="yellow"
            else
                g="jar-purple.png"
                ColorTypeJar="purple"
            end

            if(PositionACheck==false and PositionBCheck==false and PositionCCheck==false)then --sprawdzamy ktora pozycja dla jar jest wolna
                c=math.random(1,3)

            elseif(PositionACheck==false and PositionBCheck==false and PositionCCheck==true)then
                c=math.random(1,2)

            elseif(PositionACheck==false and PositionBCheck==true and PositionCCheck==false)then
                c=math.random(1,2)
                if(c==1)then
                    c=1
                else
                    c=3
                end

            elseif(PositionACheck==true and PositionBCheck==false and PositionCCheck==false)then
                c=math.random(2,3)

            elseif(PositionACheck==true and PositionBCheck==true and PositionCCheck==false)then
                c=3
            elseif(PositionACheck==false and PositionBCheck==true and PositionCCheck==true)then
                c=1
            elseif(PositionACheck==true and PositionBCheck==false and PositionCCheck==true)then
                c=2

            end

            if(c==1)then
                if(PositionACheck==false)then --tworzymy obiekt na danej pozycji
                    PositionACheck=true
                    jar=display.newImage(g,positionA, display.contentHeight - 50)
                    jar.type="jar"
                    jar.type2=ColorTypeJar
                    else jarcheck=jarcheck-1
                end

            elseif(c==2)then
                if(PositionBCheck==false)then
                    PositionBCheck=true
                    jar=display.newImage(g,positionB, display.contentHeight - 50)
                    jar.type="jar2"
                    jar.type2=ColorTypeJar
                    else jarcheck=jarcheck-1
                end
            elseif(c==3)then
                if(PositionCCheck==false)then
                    PositionCCheck=true
                    jar=display.newImage(g,positionC, display.contentHeight - 50)
                    jar.type="jar3"
                    jar.type2=ColorTypeJar
                else jarcheck=jarcheck-1
                end
            end

                    jar:scale(0.8,0.8)
                    jar.collision=onCollision
                    jar:addEventListener("collision",jar)
                    physics.addBody(jar, "kinematic")
                    jellyGroup:insert(jar)

                    if(time%30==0)then --zmieniamy prędkość pojawiania się jar zależnie od czasu
                        timeForJar2=timeForJar2-500
                        if(timeForJar2==500)then
                            timeForJar2=250
                        end
                    end

                    --funkcja usuwająca jar po czasie
                    timerzx=timer.performWithDelay( timeForJar2,   function() if(jar.removeSelf~=nil)then
                    if(gamestate~="paused")then
                        if(jar.type=="jar")then
                            PositionACheck=false
                            jarcheck=jarcheck-1

                        elseif(jar.type=="jar2")then
                            PositionBCheck=false
                            jarcheck=jarcheck-1

                        elseif(jar.type=="jar3")then
                            PositionCCheck=false
                            jarcheck=jarcheck-1
                        end

                        if(live>0)then
                            live=live-1
                            liveText.text=live
                        end
                        
                        if(live==0)then
                            gameOver()
                        end
                        jar:removeSelf()
                    end
                        end end)
                    

    end
end

--funkcja dodawania żelek
local function addNewObject2()
    --ustawianie pozycji i deklaracja zmiennych
    local positionA=display.contentWidth-260
    local positionB=display.contentWidth-185
    local positionC=display.contentWidth-110
    local positionD=display.contentWidth-35
    local jared
    local jelly
    local ColorTypeJelly
    local c=0

    --szukanie wolnego miejsca
    if (jellycheck<4)then
        jellycheck=jellycheck+1

            if(JellyPositionA==false and JellyPositionB==false and JellyPositionC==false and JellyPositionD==false)then
                c=math.random(1,4)

            elseif(JellyPositionA==false and JellyPositionB==false and JellyPositionC==false and JellyPositionD==true)then
                c=math.random(1,3)

            elseif(JellyPositionA==false and JellyPositionB==false and JellyPositionC==true and JellyPositionD==true)then
                c=math.random(1,2)

            elseif(JellyPositionA==false and JellyPositionB==true and JellyPositionC==true and JellyPositionD==true)then
                c=1

            elseif(JellyPositionA==true and JellyPositionB==false and JellyPositionC==true and JellyPositionD==true)then
                c=2

            elseif(JellyPositionA==true and JellyPositionB==false and JellyPositionC==false and JellyPositionD==true)then
                c=math.random(2,3)

            elseif(JellyPositionA==true and JellyPositionB==false and JellyPositionC==false and JellyPositionD==false)then
                c=math.random(2,4)

            elseif(JellyPositionA==true and JellyPositionB==true and JellyPositionC==false and JellyPositionD==true)then
                c=3

            elseif(JellyPositionA==true and JellyPositionB==true and JellyPositionC==false and JellyPositionD==false)then
                c=math.random(3,4)

            elseif(JellyPositionA==true and JellyPositionB==true and JellyPositionC==true and JellyPositionD==false)then
                c=4

            elseif(JellyPositionA==false and JellyPositionB==true and JellyPositionC==true and JellyPositionD==false)then
                c=math.random(1,2)
                if(c==1)then
                    c=1
                else
                    c=4
                end

            elseif(JellyPositionA==false and JellyPositionB==true and JellyPositionC==false and JellyPositionD==true)then
                c=math.random(1,2)
                if(c==1)then
                    c=1
                else
                    c=3
                end

            elseif(JellyPositionA==true and JellyPositionB==false and JellyPositionC==true and JellyPositionD==false)then
                c=math.random(1,2)
                if(c==1)then
                    c=2
                else
                    c=4
                end

            elseif(JellyPositionA==false and JellyPositionB==true and JellyPositionC==false and JellyPositionD==false)then
                c=math.random(1,3)
                if(c==1)then
                    c=1
                elseif(c==2)then
                    c=3
                else
                    c=4
                end

            elseif(JellyPositionA==false and JellyPositionB==false and JellyPositionC==true and JellyPositionD==false)then
                c=math.random(1,3)
                if(c==1)then
                    c=1
                elseif(c==2)then
                    c=2
                else
                    c=4
                end
            end
        
        local d=math.random(1,100) --losowanie między kamieniem a żelką
            if(d==100)then
                if(c==1)then
                    if(JellyPositionA==false)then
                        JellyPositionA=true
                        jared = display.newImage("jar.png",positionA, display.contentHeight - 420)
                        jared.type="jared"
                    else jellycheck=jellycheck-1
                    end

                elseif(c==2)then
                    if(JellyPositionB==false)then
                        JellyPositionB=true
                        jared = display.newImage("jar.png",positionB, display.contentHeight - 420)
                        jared.type="jared2"
                    else jellycheck=jellycheck-1
                    end

                elseif(c==3)then
                    if(JellyPositionC==false)then
                        JellyPositionC=true
                        jared = display.newImage("jar.png",positionC, display.contentHeight - 420)
                        jared.type="jared3"
                    else jellycheck=jellycheck-1
                    end

                elseif(c==4)then
                     if(JellyPositionD==false)then
                        JellyPositionD=true
                        jared = display.newImage("jar.png",positionD, display.contentHeight - 420)
                        jared.type="jared4"
                    else jellycheck=jellycheck-1
                    end
                end

                    jared:scale(0.7,0.7)
                    jared:addEventListener( "touch", jarTouched )
                    jellyGroup:insert(jared)

            elseif(d<=30)then
                if(c==1)then
                    if(JellyPositionA==false)then
                        JellyPositionA=true
                        rock = display.newImage("rock.png",positionA, display.contentHeight - 420)
                        rock.type="rock"
                    else jellycheck=jellycheck-1
                    end

                elseif(c==2)then
                    if(JellyPositionB==false)then
                        JellyPositionB=true
                        rock = display.newImage("rock.png",positionB, display.contentHeight - 420)
                        rock.type="rock2"
                    else jellycheck=jellycheck-1
                    end

                elseif(c==3)then
                    if(JellyPositionC==false)then
                        JellyPositionC=true
                        rock = display.newImage("rock.png",positionC, display.contentHeight - 420)
                        rock.type="rock3"
                    else jellycheck=jellycheck-1
                    end

                elseif(c==4)then
                     if(JellyPositionD==false)then
                        JellyPositionD=true
                        rock = display.newImage("rock.png",positionD, display.contentHeight - 420)
                        rock.type="rock4"
                    else jellycheck=jellycheck-1
                    end
                end

                    rock:scale(0.7,0.7)
                    rock.collision=onCollision
                    rock:addEventListener("collision",rock)
                    rock:addEventListener( "touch", jellyTouched )
                    jellyGroup:insert(rock)

            else

                local b=math.random(1,5) --losowanie koloru żelki
                if (b==1) then
                    g="jelly-red.png"
                    ColorTypeJelly="red"
                elseif(b==2)then
                    g="jelly-blue.png"
                    ColorTypeJelly="blue"
                elseif(b==3)then
                    g="jelly-yellow.png"
                    ColorTypeJelly="yellow"
                elseif(b==4)then
                    g="jelly-green.png"
                    ColorTypeJelly="green"
                else
                    g="jelly-purple.png"
                    ColorTypeJelly="purple"
                end

                if(c==1)then
                    if(JellyPositionA==false)then
                        JellyPositionA=true
                        jelly = display.newImage(g,positionA, display.contentHeight - 420)
                        jelly.type="jelly"
                        jelly.type2=ColorTypeJelly
                    else jellycheck=jellycheck-1
                    end
           
                elseif(c==2)then
                    if(JellyPositionB==false)then
                        JellyPositionB=true
                        jelly = display.newImage(g,positionB, display.contentHeight - 420)
                        jelly.type="jelly2"
                        jelly.type2=ColorTypeJelly
                    else jellycheck=jellycheck-1
                    end

                elseif(c==3)then
                    if(JellyPositionC==false)then
                        JellyPositionC=true
                        jelly = display.newImage(g,positionC, display.contentHeight - 420)
                        jelly.type="jelly3"
                        jelly.type2=ColorTypeJelly
                    else jellycheck=jellycheck-1
                    end
                   
                elseif(c==4)then
                    if(JellyPositionD==false)then
                        JellyPositionD=true
                        jelly = display.newImage(g,positionD, display.contentHeight - 420)
                        jelly.type="jelly4"
                        jelly.type2=ColorTypeJelly
                    else jellycheck=jellycheck-1
                    end
                end

                    jelly:scale(0.7,0.7)
                    jelly.collision=onCollision
                    jelly:addEventListener("collision",jelly)
                    jelly:addEventListener( "touch", jellyTouched )
                    jellyGroup:insert(jelly)

            end
    end
end

--sprawdzenie czy pozycje są wolne dla jar
local function checkObjects()

    if(jarcheck<3)then
        if(PositionACheck==true and PositionBCheck==true and PositionCCheck==true)then
        else
           addNewObject()
        end
    else
    end
end

--sprawdzenie czy pozycje są wolne dla jelly
local function checkJelly()
    if(jellycheck<4)then
        if(JellyPositionA==true and JellyPositionB==true and JellyPositionC==true and JellyPositionD==true)then
        else
            addNewObject2()
        end
    else
    end
end

--lokalna czasu dla nowego jar
local timeForJar=1500

--odlicza czas
licznik = timer.performWithDelay(1000, updateTime, time)

--odlicza czas dla nowego jar
licznik2=timer.performWithDelay(300,   function() 

    timeForJar=timeForJar-100
    if(timeForJar==100)then
    timeForJar=10
    end end,0)

-- dodaje nowy obiekt
f = timer.performWithDelay( timeForJar, checkObjects, 0 )
f2 =timer.performWithDelay(20, checkJelly, 0)

end

--funkcja show sceny
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
    
    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
    elseif phase == "did" then
        audio.play( backgroundMusic, { channel=1, loops=-1 } ) --wlączenie muzyki w tle
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
        -- e.g. stop timers, stop animation, unload sounds, etc.)

        --sceneGroup:removeSelf()
        --sceneGroup=nil

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