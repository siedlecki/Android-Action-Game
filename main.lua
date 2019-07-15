-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--ukrycie paska statusu
display.setStatusBar( display.HiddenStatusBar )

--dodaje moduł "composera" Corony
local composer = require "composer"

--ładuje ekran główny
composer.gotoScene( "menu" )