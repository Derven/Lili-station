// /obj/blood vars
//---------------------
/obj/blood/name = "blood"
/obj/blood/desc = "red luqid mess"
/obj/blood/icon = 'blood.dmi'
/obj/blood/anchored = 1

// /obj/blood procs
//---------------------
/obj/blood/New()
	..()
	if(istype(src.loc, /turf/simulated/wall))
		var/turf/simulated/wall/newicon/NI = src.loc
		if(findtext(NI.icon_state,"ns")==0)
			icon_state = pick("blood2_ns","blood1_ns","blood3_ns")
			pixel_z = rand(-3,3)
		if(findtext(NI.icon_state,"we")==0)
			icon_state = pick("blood1_we","blood2_we","blood3_we")
			pixel_z = rand(-3,3)
	else
		if(!istype(src, /obj/blood/trail))
			icon_state = pick("1","2","3")

// other shit
//---------------------
/obj/blood/trail
	icon_state = "blood_trails_small"
	New()
		..()
		return 0

/obj/wet
	icon = 'blood.dmi'
	icon_state = "wet"

	New()
		..()
		sleep(300)
		del(src)

	Crossed(atom/movable/O)
		if(istype(O, /mob))
			var/mob/M = O
			M.stunned += rand(3,7)

/obj/dirt
	icon = 'blood.dmi'
	icon_state = "dirt"
	layer = 2

