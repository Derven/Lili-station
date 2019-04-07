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

		smoke
			name = "smoke"
			id = "smoke"
			result = "smoke"
			required_reagents = list("potassium" = 5, "sugar" = 5, "phosphorus" = 5)
			result_amount = 1

			on_reaction(var/datum/reagents/holder, var/created_volume)
				for(var/turf/simulated/floor/F in range(3, holder.my_atom.loc))
					new /obj/effect/smoke(F)

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