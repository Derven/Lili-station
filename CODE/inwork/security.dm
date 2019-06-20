
/obj/item
	var/stun = 0
	var/image/inhand
	var/inhandstate

	proc/del_inhand(var/mob/simulated/living/humanoid/H)
		if(inhandstate != "" && inhand)
			if(istype(H, /mob/simulated/living/humanoid))
				if(src == H.r_hand)
					if(!H.l_hand || (!istype(H.l_hand, src) && !istype(src, H.l_hand)))
						H.overlays -= inhand
						inhand = null
				if(src == H.l_hand)
					if(!H.r_hand || (!istype(H.r_hand, src) && !istype(src, H.r_hand)))
						H.overlays -= inhand
						inhand = null



	proc/add_inhand(var/mob/simulated/living/humanoid/H)
		if(inhandstate != "")
			if(!inhand)
				if(H.gender == "male")
					inhand = image(icon = 'inhand.dmi', icon_state = inhandstate)
				else
					inhand = image(icon = 'inhand.dmi', icon_state = "[inhandstate]_fem")
			if(istype(H, /mob/simulated/living/humanoid))
				if(!H.l_hand || (!istype(H.l_hand, src) && !istype(src, H.l_hand)))
					H.overlays += inhand
					return
				if(!H.r_hand || (!istype(H.r_hand, src) && !istype(src, H.r_hand)))
					H.overlays += inhand
					return


/obj/item/weapon/flasher
	name = "portable flash"
	icon = 'tools.dmi'
	icon_state = "flash"

/obj/item/weapon/stunbaton
	name = "stunbaton"
	icon = 'tools.dmi'
	icon_state = "stunbaton"
	force = 5
	stun = 18

/obj/item/weapon/handcuffs
	name = "handcuffs"
	icon = 'tools.dmi'
	icon_state = "handcuffs"
	force = 2
	layer = 15
	pixel_z = 10

/obj/item/bomb
	var/bombtime = 25
	var/power = 3
	name = "bomb"
	icon = 'tools.dmi'
	icon_state = "bomb"

	attack_self()
		icon_state = "bomb_active"
		sleep(bombtime)
		boom(power, src.loc)
		del(src)

	smokebomb

		attack_self()
			icon_state = "bomb_active"
			sleep(bombtime)
			for(var/turf/simulated/floor/F in range(power, src))
				new /obj/effect/smoke(F)
			del(src)

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