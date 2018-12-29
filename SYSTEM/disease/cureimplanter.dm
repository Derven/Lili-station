/obj/item/weapon/cureimplanter
	name = "Hypospray injector"
	icon = 'tools.dmi'
	icon_state = "implanter1"
	var/datum/microorganism/resistance/resistance = null
	var/works = 0
	var/datum/microorganism/disease/microorganism = null
	item_state = "syringe_0"
	w_class = 2.0


/obj/item/weapon/cureimplanter/proc/attack_me(mob/target as mob, mob/user as mob)
	if(ismob(target))
		for(var/mob/O in viewers(world.view, user))
			if (target != user)
				O.show_message(text("\red <B>[] is trying to inject [] with [src.name]!</B>", user, target), 1)
			else
				O.show_message("\red <B>[user] is trying to inject themselves with [src.name]!</B>", 1)


		for(var/mob/O in viewers(world.view, user))
			if (target != user)
				O.show_message(text("\red [] injects [] with [src.name]!", user, target), 1)
			else
				O.show_message("\red [user] injects themself with [src.name]!", 1)


		var/mob/simulated/living/M = target

		if(works == 0)
			M.resistances += resistance
			M.immunemicroorganism += M.microorganism.getcopy()
			if(M.microorganism)
				M.microorganism.cure_added(resistance)
		else if(works == 1)
			M.toxloss += 60
		else if(works == 3)
			infect_microorganism(M,microorganism,1)