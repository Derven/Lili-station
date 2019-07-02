mob/var/TxtSpd = 1

/HUD/Text
	parent_type = /obj
	screen_loc = "8,7"
	layer = 1000
	icon = 'box.dmi'

proc/Text(mob/M,var/Text="")
	var/Blank = " "
	for(var/HUD/Text/Te in M.client.screen)
		Te.maptext = ""
		del(Te)

	var/HUD/Text/T = new;M.client.screen.Add(T)

	T.maptext_width = length(Text) / length(Text)*300
	T.maptext_height = length(Text) / length(Text)*100
	while(length(Blank)-2<length(Text)+1)
		sleep(M.TxtSpd)
		Blank = addtext(Blank,"[getCharacter(Text,length(Blank))]")
		T.maptext = "<font size=2>[Blank]" // The name of the font is not its file's name.
		if(length(Blank)>=length(Text))
			break


proc
	getCharacter(string, pos=1)
		return ascii2text(text2ascii(string, pos)) //This proc is used to retrieve the next character in text string.