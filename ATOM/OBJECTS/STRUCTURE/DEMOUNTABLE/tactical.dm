/obj/structure/tactical_shield
	icon = 'stationobjs.dmi'
	icon_state = "tactical_shield"
	density = 1
	anchored = 0

	bullet_act(var/obj/item/projectile/Proj)
		if(Proj.firer != src && (Proj.dir == dir || Proj.dir == turn(dir, 180)))
			if(istype(Proj, /obj/item/projectile/beam/explosive))
				boom(rand(1,2), src)
			else
				new /obj/effect/sparks(src)
			del(Proj)
		return 0

	verb/rotate_90()
		set src in range(1)
		dir = turn(dir, 90)