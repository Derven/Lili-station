/obj/item/weapon/candle
	icon = 'tools.dmi'
	icon_state = "candle"
	luminosity = 3

/mob
	var/image/cig_overlay

/obj/item/cigs
	New()
		..()
		START_PROCESSING(SSobj, src)

	process()
		if(istype(src.loc, /mob/simulated/living/humanoid))
			var/turf/location = src.loc.loc
			if (isturf(location))
				location.hotspot_expose(1000,500,1)
			spawn(rand(300,500))
				src.loc:overlays -= src.loc:cig_overlay
				del(src)

/obj/item/cigpacket
	icon = 'chemical.dmi'
	name = "cigarettes"
	icon_state = "cigs"
	var/amount = 20

	proc/use()
		if(amount > 0)
			for(var/obj/item/cigs/CIGA in usr) //Not all at once
				return
			amount -= 1
			new /obj/item/cigs(usr)
			if(usr:gender == "male")
				usr:cig_overlay = image('mob.dmi', "cig_overlay")
			else
				usr:cig_overlay = image('mob.dmi', "f_cig_overlay")
			usr.overlays += usr:cig_overlay
		else
			usr << "\red Oh no! Cigpacket is empty..."

	attack_self()
		use()