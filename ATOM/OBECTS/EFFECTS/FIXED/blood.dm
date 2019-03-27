//ok
/obj/blood
	icon = 'blood.dmi'
	anchored = 1

	trail
		icon_state = "blood_trails_small"

		New()
			..()
			return 0

	New()
		..()
		if(!istype(src, /obj/blood/trail))
			icon_state = pick("1","2","3")

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