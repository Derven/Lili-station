/obj/item/weapon/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'chemical.dmi'
	icon_state = null
	var/amount_per_transfer_from_this = 5
	var/possible_transfer_amounts = list(5,10,15,25,30)
	var/volume = 30
	massweight = 100

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

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		//wrap(W, user)
		return
	attack_self(mob/user as mob)
		return
	//attack(mob/M as mob, mob/user as mob, def_zone)
	//	return
	attackby(obj/item/I as obj, mob/user as mob)
		//wrap(I, user)
		return
	afterattack(obj/target, mob/user , flag)
		return

/obj/item/weapon/reagent_containers/food

	afterattack(mob/target, mob/simulated/living/humanoid/user , flag)
		if(istype(target, /mob))
			if(!target.reagents) return


			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				//user << "\red [target] is full."
				user << "\red [target] is full."
				return

			if(ismob(target))
				for(var/mob/O in viewers(world.view, user))
					//O.show_message(text("\red <B>[] drips something onto []!</B>", user, target), 1)
				src.reagents.reaction(target, TOUCH)

			//user << "\blue [target] ест [src]."
			user << "\blue [target] eat [src]."
			src.reagents.trans_to(target, amount_per_transfer_from_this)
			if (src.reagents.total_volume<=0)

				user.drop_item_v()
				del(src)

			else
				if(!target.reagents.total_volume)
					user.drop_item_v()
					del(src)

			return


/obj/structure/reagent_dispensers

/obj/item/weapon/reagent_containers/glass
	name = "glass"
	layer = 8
	icon = 'chemical.dmi'
	icon_state = "bottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50)
	volume = 50
	flags = FPRINT | TABLEPASS | OPENCONTAINER

	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		usr << "\blue It contains:"
		if(reagents && reagents.reagent_list.len)
			for(var/datum/reagent/R in reagents.reagent_list)
				usr << "\blue [R.volume] units of [R.name]"
				usr << "\blue [R.volume] units of [R.name]"
		else
			usr << "\blue Nothing"
			// "\blue Nothing."

	afterattack(obj/target, mob/user , flag)
		if(ismob(target) && target.reagents && reagents.total_volume)
			user << "\blue You splash the solution onto [target]."
			//for(var/mob/O in viewers(world.view, user))
				//O.show_message(text("\red [] has been splashed with something by []!", target, user), 1)
			src.reagents.reaction(target, TOUCH)
			spawn(5) src.reagents.clear_reagents()
			return
		else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.

			if(!target.reagents.total_volume && target.reagents)
				user << "\red [target] is empty."
				return

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "\red [src] is full."
				return

			var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
			user << "\blue You fill [src] with [trans] units of the contents of [target]."

		else if(target.reagents) //Something like a glass. Player probably wants to transfer TO it.
			if(!reagents.total_volume)
				user << "\red [src] is empty."
				return

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue You transfer [trans] units of the solution to [target]."

		//Safety for dumping stuff into a ninja suit. It handles everything through attackby() and this is unnecessary.

		else if(reagents.total_volume)
			user << "\blue You splash the solution onto [target]."
			src.reagents.reaction(target, TOUCH)
			spawn(5) src.reagents.clear_reagents()
			return


/obj/item/weapon/reagent_containers/dropper
	name = "Dropper"
	desc = "A dropper. Transfers 5 units."
	icon = 'chemical.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(1,2,3,4,5)
	volume = 5
	var/filled = 0

	afterattack(obj/target, mob/user , flag)
		if(!target.reagents) return

		if(filled)

			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "\red [target] is full."
				return

			if(ismob(target))
				for(var/mob/O in viewers(world.view, user))
					//O.show_message(text("\red <B>[] drips something onto []!</B>", user, target), 1)
				src.reagents.reaction(target, TOUCH)

			var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
			user << "\blue ¬ы выливаете [trans] единиц вещества."
			if (src.reagents.total_volume<=0)
				filled = 0
				icon_state = "dropper[filled]"

		else
			if(!target.reagents.total_volume)
				user << "\red [target] is empty."
				return

			var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)

			user << "\blue ¬ы наполн&#255;ете пипетку [trans] единицами вещества."

			filled = 1
			icon_state = "dropper[filled]"

		return

/obj/structure/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'stationobjs.dmi'
	icon_state = "watertank"
	density = 1
	anchored = 0
	flags = FPRINT
	pressure_resistance = 2*ONE_ATMOSPHERE

	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(10,25,50,100)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return

	New()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src
		if (!possible_transfer_amounts)
			src.verbs -= /obj/structure/reagent_dispensers/verb/set_APTFT
		..()

	examine()
		set src in view()
		..()
		if (!(usr in view(2)) && usr!=src.loc) return
		usr << "\blue It contains:"
		if(reagents && reagents.reagent_list.len)
			for(var/datum/reagent/R in reagents.reagent_list)
				usr << "\blue [R.volume] units of [R.name]"
		else
			usr << "\blue Nothing"

	verb/set_APTFT() //set amount_per_transfer_from_this
		set name = "Set transfer amount"
		set category = "Object"
		set src in view(1)
		var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
		if (N)
			amount_per_transfer_from_this = N

/obj/structure/reagent_dispensers/watertank
	name = "watertank"
	desc = "A watertank"
	icon = 'stationobjs.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 10
	New()
		..()
		reagents.add_reagent("water",1000)

/obj/structure/reagent_dispensers/dieseltank
	name = "dieseltank"
	desc = "A dieseltank"
	icon = 'stationobjs.dmi'
	icon_state = "dieseltank"
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("diesel",1000)

	bullet_act(var/obj/item/projectile/Proj)
		del(Proj)
		message_to(5, "\red Poof")
		var/turf/simulated/floor/F = src.loc
		F.air.toxins += 100
		F.update_air_properties()
		del(src)

/obj/structure/reagent_dispensers/beertank
	name = "beertank"
	desc = "A beertank"
	icon = 'stationobjs.dmi'
	icon_state = "beertank"
	amount_per_transfer_from_this = 10

	New()
		..()
		reagents.add_reagent("beer",1000)