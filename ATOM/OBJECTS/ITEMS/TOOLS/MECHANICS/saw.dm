/obj/item/weapon/saw
	name = "saw"
	icon = 'tools.dmi'
	icon_state = "saw"
	pixel_z = 3
	pixel_z = 5
	pixel_y = 5
	ignore_ZLEVEL = 1
	force = 15
	var/list/atom/tometalscraps = list(/turf/simulated/wall, /obj/structure/stool, /obj/structure/stool/chair,
	/obj/structure/stool/bed, /obj/structure/closet, /obj/structure/closet/crate, /obj/structure/closet/oxygen,
	/obj/structure/closet/materials, /obj/structure/closet/hydcrate, /obj/structure/closet/oxycrate, /obj/structure/closet/sec,
	/obj/structure/table, /obj/structure/stool/bed/roller_bed)

	New()
		..()
		pixel_z = 5
		pixel_x = -13
		layer = 15

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
		if(istype(target, /mob/simulated/living/humanoid))
			if(target:opened_chest == 0 && usr:ZN_SEL.selecting == "chest")
				usr << "\red You opened the chest of [target]."
				target:opened_chest = 1
				return
			if(target:opened_chest == 1 && target:cut_parasite == 0 && usr:ZN_SEL.selecting == "chest")
				usr << "\red You slashed through the chest of [target]."
				target:cut_parasite = 1
				target:cut_parasite()
