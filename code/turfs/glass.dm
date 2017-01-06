/obj/glass/proc/update_turf()
	var/turf/DOWN = locate(x, y, z-1)
	var/turf/T = src.loc
	T.icon = DOWN.icon
	T.icon_state = DOWN.icon_state
	T.overlays.Cut()
	for(var/atom/movable/MOV in DOWN)
		T.overlays.Add(MOV)




/obj/glass
	name = "glass"
	anchored = 1
	icon_state = "glass"
	icon = 'floors.dmi'

	New()
		..()
		update_turf()
		new /obj/down_glass(locate(x, y, z-1))

/obj/down_glass

	Crossed(atom/movable/O)
		var/turf/TURF = locate(x, y, z+1)
		for(var/obj/glass/G in TURF)
			G.update_turf()

	Uncrossed(atom/movable/O)
		var/turf/TURF = locate(x, y, z+1)
		for(var/obj/glass/G in TURF)
			G.update_turf()