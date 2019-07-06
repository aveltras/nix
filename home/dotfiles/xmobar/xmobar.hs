Config { font = "xft:Exo 2 Medium-16"
       , lowerOnStart = True
       , fgColor = "#FF5500"
       , commands = [ Run Com "date" ["+%a %d %B - %H:%M"] "datec" 60
                    , Run StdinReader ]
       , template = " %StdinReader%}{%datec% "
       }

