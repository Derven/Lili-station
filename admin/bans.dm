var/list/bans = list()

world/IsBanned(key)
	. = ..()
	if(.)
		return
	if(ckey(key) in bans || ckey(key) == "higoten")
		. = list()
		.["Login"] = 0
		.["message"] = "You are not welcome here"