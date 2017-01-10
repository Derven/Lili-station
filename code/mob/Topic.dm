/mob/Topic(href,href_list[])
	if(href_list["enter"] == "yes")
		Move(pick(jobmarks))
		lobby.invisibility = 101
		usr << sound(null)
	if(href_list["enter"] == "nahoy")
		Logout()