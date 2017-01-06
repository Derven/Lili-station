var/global/list/turf/landmarks = list()

/obj/landmark
	icon = 'landmarks.dmi'

	New()
		..()
		invisibility = 101
		landmarks += src.loc