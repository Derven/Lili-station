/mob/Topic(href,href_list[])
	if(href_list["enter"] == "yes")
		Move(pick(jobmarks))
		lobby.invisibility = 101
		usr << sound(null)
		usr << browse(null, "window=setup")
	if(href_list["enter"] == "nahoy")
		Logout()
	if(href_list["display"] == "show")
		usr.screen_res = input("Select the resolution.","Ваше разрешение", usr.screen_res) in screen_resolution
		view_to_res()
	if(href_list["lang"] == "rus")
		language = RUS
	if(href_list["lang"] == "eng")
		language = ENG