application = 
{
	--ustawienie rozdzielczości gry
    content = 
    { 
        width = 320,
        height = 480,
        scale = "letterbox",
        xAlign = "center",
        yAlign = "center",

    --automatyczne skalowanie aplikacji
        imageSuffix =
        {	
        	["0.3x"]=0.3,
        	["0.5x"]=0.5,
        	["@1x"] = 1,
            ["@2x"] = 1.5,
            ["@4x"] = 3.0
        },
    }
}