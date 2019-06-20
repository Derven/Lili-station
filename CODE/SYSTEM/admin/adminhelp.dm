/client/verb/adminhelp(msg as text)
	set name = "Adminhelp"
	set category = "OOC"
	msg = fix255(msg)
	src << "HELP: [src.key]: [msg]"
	for(var/mob/m in world)
		if(m.ckey in admins)
			m << "HELP: <a href='?src=\ref[m.client];admin=pm;target=\ref[src.mob]'>[src.key]</a>: [msg]"

/client/verb/adminwho()
	set name = "Adminwho"
	set category = "OOC"
	usr << "Admins in game:"
	for(var/mob/m in world)
		if(m.ckey in admins)
			usr << m.key