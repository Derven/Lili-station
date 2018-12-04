/obj/bot
	icon = 'bots.dmi'

	beepsky
		icon_state = "beepsky"

	medbot
		icon_state = "medbot"

// AI (i.e. game AI, not the AI player) controlled bots

/obj/machinery/bot
	icon = 'bots.dmi'
	layer = MOB_LAYER
	var/on = 1
	var/health = 0 //do not forget to set health for your bot!
	var/maxhealth = 0
	var/fire_dam_coeff = 1.0
	var/brute_dam_coeff = 1.0
	//var/emagged = 0 //Urist: Moving that var to the general /bot tree as it's used by most bots


/obj/machinery/bot/proc/turn_on()
	if (stat)
		return 0
	src.on = 1
	return 1

/obj/machinery/bot/proc/turn_off()
	src.on = 0

/obj/machinery/bot/proc/explode()
	del(src)

/obj/machinery/bot/proc/healthcheck()
	if (src.health <= 0)
		src.explode()

/obj/machinery/bot/proc/Emag(mob/user as mob)
	if(!emagged) emagged = 1

/obj/machinery/bot/examine()
	set src in view()
	..()
	if (src.health < maxhealth)
		if (src.health > maxhealth/3)
			usr << text("\red [src]'s parts look loose.")
		else
			usr << text("\red <B>[src]'s parts look very loose!</B>")
	return

/obj/machinery/bot/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/screwdriver))
		if (src.health < maxhealth)
			src.health = min(maxhealth, src.health+25)
	else
		switch(W.damtype)
			if("fire")
				src.health -= W.force * fire_dam_coeff
			if("brute")
				src.health -= W.force * brute_dam_coeff
		..()
		healthcheck()

/obj/machinery/bot/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()

/obj/machinery/bot/ex_act(severity)
	switch(severity)
		if(1.0)
			src.explode()
			return
		if(2.0)
			src.health -= rand(5,10)*fire_dam_coeff
			src.health -= rand(10,20)*brute_dam_coeff
			healthcheck()
			return
		if(3.0)
			if (prob(50))
				src.health -= rand(1,5)*fire_dam_coeff
				src.health -= rand(1,5)*brute_dam_coeff
				healthcheck()
				return
	return

/******************************************************************/
// Navigation procs
// Used for A-star pathfinding


// Returns the surrounding cardinal turfs with open links
// Including through doors openable with the ID
/turf/proc/CardinalTurfsWithAccess(var/obj/item/weapon/card/id/ID)
	var/L[] = new()

	//	for(var/turf/simulated/t in oview(src,1))

	for(var/d in cardinal)
		var/turf/simulated/T = get_step(src, d)
		if(istype(T) && !T.density)
			L.Add(T)
	return L


// Returns true if a link between A and B is blocked
// Movement through doors allowed if ID has access
/proc/LinkBlockedWithAccess(turf/A, turf/B, obj/item/weapon/card/id/ID)

	if(A == null || B == null) return 1

	for(var/obj/O in B)
		if(O.density && !istype(O, /obj/machinery/airlock) && !(O.flags & ON_BORDER))
			return 1

	return 0
