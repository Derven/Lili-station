var/global/list/turf/landmarks = list()
var/global/list/turf/jobmarks = list()

/obj/landmark
	icon = 'landmarks.dmi'

	New()
		..()
		invisibility = 101
		landmarks += src.loc

/obj/jobmark
	icon = 'landmarks.dmi'

	New()
		..()
		invisibility = 101
		jobmarks += src.loc