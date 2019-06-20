///////////////////////////////////////////////////////////////////////////////////
datum
	chemical_reaction
		var/name = null
		var/id = null
		var/result = null
		var/list/secondary_results = new/list()
		var/list/required_reagents = new/list()
		var/list/required_catalysts = new/list()

		// Both of these variables are mostly going to be used with Metroid cores - but if you want to, you can use them for other things
		var/atom/required_container = null // the container required for the reaction to happen
		var/required_other = 0 // an integer required for the reaction to happen

		var/result_amount = 0
		var/secondary = 0 // set to nonzero if secondary reaction

		var/requires_heating = 0	//to avoid lag and other complications, every recipe is restricted to the same heating time (or none)

		proc
			on_reaction(var/datum/reagents/holder, var/created_volume)
				return

		homunculinus
			name = "homunculinus"
			id = "homunculinus"
			result = "homunculinus"
			required_reagents = list("nutriments" = 1, "milk" = 1)
			result_amount = 5

			on_reaction(var/datum/reagents/holder, var/created_volume)
				world << "PIZDEC"

		flash
			name = "Flash"
			id = "flash"
			required_reagents = list("aluminium" = 1, "potassium" = 1, "sulfur" = 1, "chlorine" = 1 )

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					for(var/mob/simulated/living/humanoid/M in range(2, holder.my_atom.loc))
						M.playsoundforme('flash.ogg')
						M << "\red flasher blinds [M] with the flash!"
						M.rest()
						if(M.client)
							M.client.show_map = 0
							sleep(rand(3,9))
							M.client.show_map = 1
							sleep(rand(2,5))
							M.rest()

				else
					for(var/mob/simulated/living/humanoid/M in range(2, holder.my_atom.loc.loc))
						M.playsoundforme('flash.ogg')
						M << "\red flasher blinds [M] with the flash!"
						M.rest()
						if(M.client)
							M.client.show_map = 0
							sleep(rand(3,9))
							M.client.show_map = 1
							sleep(rand(2,5))
							M.rest()

		explosion
			name = "explosion"
			id = "explosion"
			result = "explosion"
			required_reagents = list("potassium" = 5, "water" = 5)
			result_amount = 1

			on_reaction(var/datum/reagents/holder, var/created_volume)
				boom(rand(1,2), holder.my_atom.loc)

		chemsmoke
			name = "Chemsmoke"
			id = "chemsmoke"
			result = null
			required_reagents = list("potassium" = 1, "sugar" = 1, "phosphorus" = 1)
			result_amount = null
			secondary = 1
			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/location = get_turf(holder.my_atom)
				var/datum/effect/effect/system/chem_smoke_spread/S = new /datum/effect/effect/system/chem_smoke_spread
				S.attach(location)
				S.set_up(holder, 10, 0, location)
				spawn(0)
					S.start()
					sleep(10)
					S.start()
				holder.clear_reagents()
				return

		lexorin
			name = "lexorin"
			id = "lexorin"
			result = "lexorin"
			required_reagents = list("plasma" = 5, "hydrogen" = 5, "nitrogen" = 5)
			result_amount = 1

		cheese
			name = "Cheese"
			id = "cheese"
			result = "cheese"
			required_reagents = list("milk" = 1, "vomit" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					new /obj/item/weapon/reagent_containers/food/snacks/cheesewedge(holder.my_atom.loc)
				else
					new /obj/item/weapon/reagent_containers/food/snacks/cheesewedge(holder.my_atom.loc.loc)

		synthflesh
			name = "Synthetic Flesh"
			id = "synthflesh"
			result = "synthflesh"
			required_reagents = list("blood" = 1, "carbon" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					new /obj/item/weapon/reagent_containers/food/snacks/meat(holder.my_atom.loc)
				else
					new /obj/item/weapon/reagent_containers/food/snacks/meat(holder.my_atom.loc.loc)

		thermite
			name = "Thermite"
			id = "thermite"
			result = "thermite"
			required_reagents = list("aluminium" = 1, "iron" = 1, "oxygen" = 1)
			result_amount = 3

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					for(var/turf/simulated/floor/F in range(3, holder.my_atom.loc))
						if(prob(65))
							F.ReplaceWithPlating()
							if(prob(30))
								F.ReplaceWithSpace()

				else
					for(var/turf/simulated/floor/F in range(3, holder.my_atom.loc.loc))
						if(prob(65))
							F.ReplaceWithPlating()
							if(prob(30))
								F.ReplaceWithSpace()


/datum/effect/effect/system/chem_smoke_spread
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction
	var/obj/chemholder
	var/number
	var/cardinals
	var/turf/location
	var/atom/holder

	New()
		..()
		chemholder = new/obj()
		var/datum/reagents/R = new/datum/reagents(500)
		chemholder.reagents = R
		R.my_atom = chemholder

	proc/set_up(var/datum/reagents/carry = null, n = 5, c = 0, loca, direct)
		if(n > 20)
			n = 20
		number = n
		cardinals = c
		carry.copy_to(chemholder, carry.total_volume)

		/*
		if((src.reagents.has_reagent("pacid")) || (src.reagents.has_reagent("lube"))) 	   				// Messages admins if someone sprays polyacid or space lube from a Cleaner bottle.
		message_admins("[key_name_admin(user)] fired Polyacid/Space lube from a Cleaner bottle.")			// Polymorph
		log_game("[key_name(user)] fired Polyacid/Space lube from a Cleaner bottle.")
*/

		if(istype(loca, /turf/))
			location = loca
		else
			location = get_turf(loca)
		if(direct)
			direction = direct

	proc/attach(atom/atom)
		holder = atom

	proc/start()
		var/i = 0

		for(i=0, i<src.number, i++)
			if(src.total_smoke > 20)
				return
			spawn(0)
				if(holder)
					src.location = get_turf(holder)
				var/obj/effect/smoke/smoke = new /obj/effect/smoke(src.location)
				src.total_smoke++
				var/direction = src.direction
				if(!direction)
					if(src.cardinals)
						direction = pick(cardinal)
					else
						direction = pick(alldirs)

				if(chemholder.reagents.total_volume != 1) // can't split 1 very well
					for(var/mob/simulated/living/humanoid/H in range(3, src.location))
						chemholder.reagents.copy_to(H, chemholder.reagents.total_volume / number) // copy reagents to each smoke, divide evenly
					// if no color_1, just use the old smoke icon
					smoke.icon = 'effects.dmi'
					smoke.icon_state = "smoke"

				for(i=0, i<pick(0,1,1,1,2,2,2,3), i++)
					sleep(10)
					step(smoke,direction)
				spawn(150+rand(10,30))
					del(smoke)
					src.total_smoke--
