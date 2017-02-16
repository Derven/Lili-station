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
	if(href_list["hair"] == "new")
		var/hair_state = input("Select the hairs.","Your hairs", hair) in hairs
		if(hair)
			overlays.Remove(hair)
		hair = image('mob.dmi', hair_state)
		hair.layer = layer + 1
		overlays.Add(hair)

	if(href_list["gender"] == "male")
		icon_state = "mob"
	if(href_list["gender"] == "female")
		icon_state = "mob_f"
	if(href_list["lang"] == "rus")
		language = RUS
	if(href_list["lang"] == "eng")
		language = ENG