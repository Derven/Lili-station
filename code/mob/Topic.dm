/mob/Topic(href,href_list[])
	if(href_list["enter"] == "yes")
		Move(pick(jobmarks))
		lobby.invisibility = 101
		usr << sound(null)
		usr << browse(null, "window=setup")
	if(href_list["enter"] == "nahoy")
		Logout()
	if(href_list["display"] == "show")
		usr.screen_res = input("Выберите разрешение вашего экрана или близкое к нему (это нужно дл&#1103; корректного отображени&#1103; интерфейса).","Ваше разрешение", usr.screen_res) in screen_resolution
		view_to_res()