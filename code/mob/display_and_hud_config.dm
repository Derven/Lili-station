/var/list/screen_resolution = list("640x480", "800x600", "1024x768", "1280x1024", "1920x1080")

/mob
	var
		screen_res = "1920x1080"

	proc/view_to_res()
		if(usr.client)
			switch(screen_res)
				if("640x480")
					usr.client.view = 4
				if("800x600")
					usr.client.view = 5
				if("1024x768")
					usr.client.view = 6
				if("1280x1024")
					usr.client.view = 7
				if("1920x1080")
					usr.client.view = 8