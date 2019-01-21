var/list/admin_verbs = list(\
	/client/proc/pm,\
	/client/proc/kick,\
	/client/proc/ban,\
	/client/proc/player_panel,\
	/client/proc/Spawn,\
	/client/proc/small_boom,\
	/client/proc/nuclear,\
	/client/proc/world_reboot,\
	/client/proc/savemymap)

/client/proc/pm(mob/m as mob in world, msg as text)
	set name = "PM"
	set category = null
	if(!m.client)
		src << "Client not found"
		return
	msg = fix255(msg)
	src << "PM: [src.key]><a href='?src=\ref[src];admin=pm;target=\ref[m]'>[m.key]</a>: [msg]"
	m << "PM: <a href='?src=\ref[m.client];admin=pm;target=\ref[src.mob]'>[src.key]</a>>[m.key]: [msg]"
	for(var/mob/p in world)
		if(p.ckey in admins && p != src)
			p << "PM: <a href='?src=\ref[p.client];admin=pm;target=\ref[src.mob]'>[src.key]</a>><a href='?src=\ref[p];admin=pm;target=\ref[m]'>[m.key]</a>: [msg]"

/client/proc/kick(mob/m as mob in world)
	set name = "Kick"
	set category = null
	if(!m.client)
		src << "Client not found"
		return
	m << "You have been kicked"
	src << "[m.key] has been kicked"
	for(var/mob/p in world)
		if(p.ckey in admins && p != src)
			p << "[m.key] has been kicked by [src]"
	del m.client

/client/proc/ban(mob/m as mob in world)
	set name = "Ban"
	set category = null
	if(!m.client)
		src << "Client not found"
		return
	m << "You have been banned"
	src << "[m.key] has been banned"
	for(var/mob/p in world)
		if(p.ckey in admins && p != src)
			p << "[m.key] has been banned by [src]"
	bans += m.ckey
	del m.client

/client/proc/player_panel()
	set name = "Player Panel"
	set category = "Admin"
	var/content = ""
	for(var/mob/m in world)
		if(!m.client)
			continue
		content += "<div>[m.key] ([m]) <a href='?src=\ref[src];admin=pm;target=\ref[m]'>PM</a> <a href='?src=\ref[src];admin=kick;target=\ref[m]'>Kick</a> <a href='?src=\ref[src];admin=ban;target=\ref[m]'>Ban</a></div>"
	usr << browse({"
	<html>
		<head>
			<title>Player Panel</title>
		</head>
		<body>
			[content]
		</body>
	</html>"}, "window=player_panel")

/client/proc/world_reboot()
	set name = "Restart"
	set category = "Admin"
	world.Reboot(1)

/client/proc/small_boom()
	set name = "boom"
	set category = "Admin"
	boom(6, mob.loc)

/client/proc/nuclear()
	set name = "nuclear"
	set category = "Admin"
	for(var/obj/nucmark/N in world)
		new /obj/machinery/nuka(N.loc)

/client/proc/savemymap()
	set name = "savemymap"
	set category = "Admin"
	savemap()

/client/proc/Spawn()
	set name = "spawn"
	set category = "Admin"
	var/mytype = input(src, "Enter type", "spawn window", "/obj") as text
	mytype = text2path(mytype)
	if(mytype != null)
		var/atom/A = new mytype(mob.loc)
		START_PROCESSING(SSobj, A)