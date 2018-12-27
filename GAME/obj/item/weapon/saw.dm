/obj/item/weapon/saw
	name = "saw"
	icon = 'tools.dmi'
	icon_state = "saw"
	force = 15
	var/list/atom/tometalscraps = list(/turf/simulated/wall, /obj/structure/stool, /obj/structure/stool/chair,
	/obj/structure/stool/bed, /obj/structure/closet, /obj/structure/closet/crate, /obj/structure/closet/oxygen,
	/obj/structure/closet/materials, /obj/structure/closet/hydcrate, /obj/structure/closet/oxycrate, /obj/structure/closet/sec,
	/obj/structure/table, /obj/structure/stool/bed/roller_bed)

	afterattack(atom/target, mob/user , flag)
		if(target.type in tometalscraps)
			if(usr.do_after(95))
				for(var/mob/M in range(5, target))
					M.playsoundforme('circsawhit.ogg')
				if(istype(target, /turf/simulated/wall))
					new /obj/item/stack/metalore/metalscraps(target)
					var/turf/simulated/wall/W = target
					W.clear_for_all()
					target = new /turf/simulated/floor/plating(target)
					new /obj/effect/sparks(target)
				else
					new /obj/item/stack/metalore/metalscraps(target.loc)
					new /obj/effect/sparks(target.loc)
					del(target)

