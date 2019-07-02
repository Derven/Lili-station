/obj/item/weapon/fire_ext
	name = "fire_ext"
	icon = 'tools.dmi'
	icon_state = "fire_ext"
	inhandstate = "extinguisher"
	force = 35
	var/on = 0

	afterattack(atom/target, mob/user , flag)
		sleep(2)
		if(on == 1)
			if(istype(target, /turf))
				new /obj/effect/extinguish(target)
				for(var/mob/M in range(5, src))
					M << 'spray.ogg'
				var/datum/gas_mixture/environment = target:return_air()
				environment.temperature = environment.temperature-rand(10, 30)
				for(var/obj/fire/F in range(1, src))
					del(F)
			if(istype(target, /mob/simulated/living/slime))
				target:health -= rand(10, 15)

			else
				..()
		else
			..()

	attack_self()
		on = !on
		usr << "\blue You turned [on == 1 ? "on" : "off"] the [src]."

	capsaicin_shit
		var/amount_per_transfer_from_this = 5
		var/possible_transfer_amounts = list(5,10,15,25,30)
		var/volume = 30

		verb/set_APTFT() //set amount_per_transfer_from_this
			set name = "Set transfer amount"
			set category = "Object"
			set src in range(0)
			var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
			if (N)
				amount_per_transfer_from_this = N

		New()
			..()
			if (!possible_transfer_amounts)
				src.verbs -= /obj/item/weapon/reagent_containers/verb/set_APTFT
			var/datum/reagents/R = new/datum/reagents(volume)
			reagents = R
			R.my_atom = src

		afterattack(atom/target, mob/user , flag)
			if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

				if(!target.reagents.total_volume && target.reagents)
					user << "\red [target] is empty."
					return

				if(reagents.total_volume >= reagents.maximum_volume)
					user << "\red [src] is full."
					return

				var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
				user << "\blue You fill [src] with [trans] units of the contents of [target]."
			if(!reagents.total_volume && reagents)
				user << "\red [src] is empty."
				return
			sleep(2)
			if(on == 1)
				if(istype(target, /turf))
					new /obj/effect/extinguish(target)
				else
					new /obj/effect/extinguish(target.loc)
				src.reagents.reaction(target, TOUCH)
				for(var/mob/M2 in range(5, src))
					M2 << 'spray.ogg'
				spawn(5) src.reagents.clear_reagents()
				return
			else
				..()

/obj/effect/extinguish
	icon = 'effects.dmi'
	icon_state = "extinguish"

	New()
		..()
		sleep(rand(1,2))
		alpha = rand(0, 121)
		sleep(rand(1,2))
		del(src)