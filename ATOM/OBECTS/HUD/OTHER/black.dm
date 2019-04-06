var/const/DE_FILTER_ITL = 'de_filter_t1.dmi'
var/const/DE_FILTER_CLIENT_VIEW = "20x20"
var/DE_FILTER_ICON = DE_FILTER_ITL 				//DE_FILTER_ITL, DE_FILTER_ITM, DE_FILTER_ITH
var/DE_FILTER_ICON_STATE = "Heavy" 				//Light, Moderate, Heavy
var/DE_FILTER_LAYER = 1000 						//The layer for the static filter
var/DE_FILTER_CUSTOM_COLOR = rgb(222,0,170)//custom color for filter, rgb() or "#00FF00" or null for default

/obj/hud
	black
		icon_state = "black"
		screen_loc = "SOUTH, WEST to NORTH, EAST"
		invisibility = 101


proc
	DE_SFL_U(var/obj/hud/glitch/SF)
		var/vcheck = DE_FILTER_CLIENT_VIEW
		if(!istext(vcheck)) vcheck = "[(vcheck * 2) + 1]x[(vcheck * 2) + 1]"
		var/icon/F = new(DE_FILTER_ICON)
		var/CC = rgb(rand(170,255),rand(0,30),rand(180,255))
		if(CC) F.SwapColor("#000000", CC)

		var/image/I = image(icon = F, icon_state = "[rand(1, 8)] - [DE_FILTER_ICON_STATE]", layer = DE_FILTER_LAYER)
		SF.overlays.Add(I)
		del(I)

/obj/hud
	glitch
		icon_state = null
		screen_loc = "SOUTH, WEST to NORTH, EAST"
		mouse_opacity = 0
		alpha = 165

		New()
			..()
			sleep(2)
			DE_SFL_U(src)