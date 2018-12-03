var/list/admins

/proc/load_admins()
	if(fexists("admins.txt"))
		admins = list()
		for(var/t in splittext(file2text("admins.txt"),"\n"))
			if(length(t) == 0 || copytext(t, 1, 2) == "#")
				continue
			admins += ckey(t)
	else
		admins = list("ssting", "plin", "honkertron")
	for(var/client/c in world)
		if(c.ckey in admins)
			c.verbs += admin_verbs