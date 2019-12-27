/obj/item/weapon/weldingtool
	name = "weldingtool"
	icon = 'tools.dmi'
	icon_state = "welder"
	var/volume = 60

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(volume)
		reagents = R
		R.my_atom = src
		R.add_reagent("diesel", 40)

	afterattack(obj/target, mob/user , flag)
		if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume && target.reagents)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "\blue You fill [src] with [trans] units of the contents of [target]."

	proc/use()
		if(reagents.has_reagent("diesel", 10))
			for(var/mob/M in range(5, src.loc))
				M.playsoundforme('Welder.ogg')
			reagents.remove_reagent("diesel", 10, 0)
			return 1
		else
			return 0

/obj/item/weapon/weldingtool/flamethrower
	icon_state = "flamethrower"
	name = "handmade flamethrower"
	inhandstate = "flamethrower"

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(volume)
		reagents = R
		R.my_atom = src
		R.add_reagent("diesel", 100)


	afterattack(obj/target, mob/user , flag)
		if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume && target.reagents)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "\blue You fill [src] with [trans] units of the contents of [target]."
			return
		if(istype(target.loc, /turf) || istype(target, /turf))
			if(reagents.has_reagent("diesel", 10))
				for(var/mob/M in range(5, user.loc))
					M.playsoundforme('Welder.ogg')
				var/i = 0
				var/turf/LOCAL = user.loc
				while(i < 5)
					i++
					LOCAL = get_step(LOCAL, user.dir)
					if(istype(LOCAL, /turf/simulated/floor))
						new /obj/effect/flame(LOCAL)

				reagents.remove_reagent("diesel", 10, 0)

	use()
		return