/atom/MouseDrop(atom/over_object as mob|obj|turf|area)
	spawn( 0 )
		if (istype(over_object, /atom))
			over_object.MouseDrop_T(src, usr)
		return
	..()
	return

/mob
	var/buckled = null

/obj/structure/stool/bed
	icon_state = "bed"


	roller_bed
		icon_state = "roller_bed"
		var/list/buckled_mobs = new/list()

		Move()
			..()
			for(var/mob/M in buckled_mobs)
				M.loc = src.loc

		MouseDrop_T(mob/M as mob, mob/user as mob)
			if (!istype(M)) return
			buckle_mob(M, user)
			return

		proc/buckle_mob(mob/simulated/living/humanoid/M as mob, mob/user as mob)
			if ((!( istype(M, /mob) ) || get_dist(src, user) > 1 || M.loc != src.loc || usr.stat || M.buckled))
				return
			if (M == usr)
				usr << "\blue You buckle yourself"
			else
				usr << "\blue [M] buckled by [usr]"
			usr.playsoundforme('handcuffs.ogg')
			M.anchored = 1
			M.buckled = src
			M.loc = src.loc
			M.dir = src.dir
			if(!M.lying)
				M.rest()
			buckled_mobs += M

		proc/manual_unbuckle_all(mob/user as mob)
			var/N = 0;
			for(var/mob/simulated/living/humanoid/M in buckled_mobs)
				if (M.buckled == src)
					if (M != user)
						M << "\blue You unbuckled from [src] by [user.name]."
					else
						user << "\blue You unbuckle yourself from [src]."
		//			world << "[M] is no longer buckled to [src]"
					usr.playsoundforme('handcuffs.ogg')
					M.anchored = 0
					M.buckled = null
					buckled_mobs -= M
					if(M.lying)
						M.rest()
					N++
			return N

		attack_hand()
			manual_unbuckle_all(usr)

/obj/structure/stool
	icon = 'stationobjs.dmi'
	icon_state = "stool"

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/W = O
			if(W.reagents.has_reagent("diesel", 10))
				W.use()
				flick("active", W)
				new /obj/item/stack/metal(src.loc)
				del(src)
			else
				usr << "\red Oh no! Need more fuel!"
				return
		if(istype(O, /obj/item/weapon/wrench))
			new /obj/item/construct/stool(src.loc)
			del(src)

/obj/structure/stool/chair/attack_hand(mob/user as mob)
	manual_unbuckle_all(user)
	return

/obj/structure/stool/chair
	icon_state = "chair"
	var/list/buckled_mobs = new/list()

	wood
		color = "#633213"

	attackby(obj/item/O as obj, mob/user as mob)
		if(istype(O, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/W = O
			if(W.reagents.has_reagent("diesel", 10))
				W.use()
				flick("active", W)
				new /obj/item/stack/metal(src.loc)
				del(src)
			else
				usr << "\red Oh no! Need more fuel!"
				return
		if(istype(O, /obj/item/weapon/wrench))
			new /obj/item/construct/chair(src.loc)
			del(src)

	MouseDrop_T(mob/M as mob, mob/user as mob)
		if (!istype(M)) return
		buckle_mob(M, user)
		return

	proc/manual_unbuckle_all(mob/user as mob)
		var/N = 0;
		for(var/mob/M in buckled_mobs)
			if (M.buckled == src)
				if (M != user)
					M << "\blue You unbuckled from [src] by [user.name]."
				else
					user << "\blue You unbuckle yourself from [src]."
	//			world << "[M] is no longer buckled to [src]"
				usr.playsoundforme('handcuffs.ogg')
				M.anchored = 0
				M.buckled = null
				buckled_mobs -= M
				N++
		return N


	proc/buckle_mob(mob/M as mob, mob/user as mob)
		if ((!( istype(M, /mob) ) || get_dist(src, user) > 1 || M.loc != src.loc || usr.stat || M.buckled))
			return
		if (M == usr)
			usr << "\blue You buckle yourself"
		else
			usr << "\blue [M] buckled by [usr]"
		usr.playsoundforme('handcuffs.ogg')
		M.anchored = 1
		M.buckled = src
		M.loc = src.loc
		M.dir = src.dir
		buckled_mobs += M

	electro
		anchored = 1
		icon_state = "electro"

		proc/activate()
			var/electroforces
			for(var/obj/machinery/simple_apc/SA in range(8, src))
				electroforces = SA.charge
				SA.charge = 0
			for(var/mob/simulated/living/M in buckled_mobs)
				var/MY_PAIN = M.get_organ("head")
				var/MY_PAIN2 = M.get_organ("chest")
				M.apply_damage(electroforces, "fire" , MY_PAIN, 0)
				M.apply_damage(electroforces, "fire" , MY_PAIN2, 0)
				for(var/mob/B in range(5, src))
					var/i = rand(3,5)
					while(i > 1)
						new /obj/effect/sparks(src.loc)
						sleep(rand(1,3))
						B.playsoundforme('sparks.ogg')
						B.playsoundforme('scream.ogg')
						B.playsoundforme('s.ogg')
						i -= 1
				manual_unbuckle_all(M)
				for(var/obj/machinery/radio/intercom/I in world)
					flick("intercom_flick", src)
					var/sound/S = sound('s.ogg')
					for(var/mob/B in range(7, I))
						B << "\red ***radio*** station AI: [M] executed by electro chair! Glory to the NT!"
						B << S


/obj/structure/stool/comfychair
	icon_state = "comfychair"
	anchored = 1