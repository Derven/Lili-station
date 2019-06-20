/atom

	proc/setmaptext(var/redorblue, var/text)
		if(redorblue)
			maptext = "\red <h1>[text]</h1>"
		else
			maptext = "\blue <h1>[text]</h1>"

	proc/showandhide(var/text, var/redorblue, var/mytime)
		maptext_width = 64
		maptext_height = 64
		maptext_x = rand(15,64)
		maptext_y = rand(15,64)
		setmaptext(redorblue, text)
		sleep(mytime)
		setmaptext(redorblue, "")
		maptext_x = 0
		maptext_y = 0