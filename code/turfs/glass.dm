/obj/glass/proc/update_turf()
	var/turf/simulated/DOWN = locate(x, y, z-1)
	var/turf/simulated/T = src.loc
	T.icon = DOWN.icon
	T.icon_state = DOWN.icon_state
	T.overlays.Cut()
	for(var/atom/movable/MOV in DOWN)
		T.overlays.Add(MOV)
	if(istype(src, /obj/glass/whore))
		if(istype(T, /turf/simulated/floor) && istype(DOWN, /turf/simulated/floor))
			var/buffer_oxy = T.air.oxygen
			var/buffer_carb = T.air.carbon_dioxide
			var/buffer_nit = T.air.nitrogen
			var/buffer_tox = T.air.toxins

			T.air.oxygen = DOWN.air.oxygen
			T.air.carbon_dioxide = DOWN.air.carbon_dioxide
			T.air.nitrogen = DOWN.air.nitrogen
			T.air.toxins = DOWN.air.toxins

			DOWN.air.oxygen = buffer_oxy
			DOWN.air.carbon_dioxide = buffer_carb
			DOWN.air.nitrogen = buffer_nit
			DOWN.air.toxins = buffer_tox

/obj/glass
	name = "glass"
	anchored = 1
	icon_state = "glass"
	icon = 'floors.dmi'

	whore
		icon = 'floors.dmi'
		icon_state = "whore"

		Crossed(atom/movable/O)
			var/turf/T = locate(x, y, z-1)
			if(T.density != 1)
				O.Move(T)
				O << "\red Вы проваливаетесь в дыру в полу!"
				update_turf()

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