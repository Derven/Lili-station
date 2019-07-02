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
		//SLIME

		monkey
			name = "Monkeys acid"
			id = "monkey"
			result = "monkey"
			required_reagents = list("blood" = 1, "gslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					new /mob/simulated/living/monkey(holder.my_atom.loc)
				else
					new /mob/simulated/living/monkey(holder.my_atom.loc.loc)

		grayslime
			name = "grayslime acid"
			id = "grayslime"
			result = "grayslime"
			required_reagents = list("plasma" = 1, "gslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					new /mob/simulated/living/slime(holder.my_atom.loc)
				else
					new /mob/simulated/living/slime(holder.my_atom.loc.loc)

		greenmush
			name = "greenslime acid"
			id = "mushslime"
			result = "mushslime"
			required_reagents = list("plasma" = 1, "grslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					new /obj/plant/mushroom(holder.my_atom.loc)
				else
					new /obj/plant/mushroom(holder.my_atom.loc.loc)

		yellowsmoke
			name = "yellowslime acid"
			id = "smokeslime"
			result = "smokeslime"
			required_reagents = list("blood" = 1, "yslime" = 1)

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

		yellowflash
			name = "yellowslime acid"
			id = "yellowflash"
			result = "yellowflash"
			required_reagents = list("plasma" = 1, "yslime" = 1)

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

		strongbrown
			name = "strong brown"
			id = "strongbrown"
			result = "strongbrown"
			required_reagents = list("plasma" = 1, "brslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					var/mob/simulated/living/slime/SL = new /mob/simulated/living/slime(holder.my_atom.loc)
					SL.colortype = pick("black", "violet", "red", "orange")
					SL.recolor()
				else
					var/mob/simulated/living/slime/SL = new /mob/simulated/living/slime(holder.my_atom.loc.loc)
					SL.colortype = pick("black", "violet", "red", "orange")
					SL.recolor()

		aquafood
			name = "Aquafood"
			id = "aquafood"
			result = "aquafood"
			required_reagents = list("blood" = 1, "aslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc)
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc)
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc)
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc)
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc)
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc)
				else
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc.loc)
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc.loc)
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc.loc)
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc.loc)
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc.loc)
					new /obj/item/weapon/reagent_containers/food/snacks/clownburger(holder.my_atom.loc.loc)

		orangefire
			name = "orangefire"
			id = "orangefire"
			result = "orangefire"
			required_reagents = list("blood" = 1, "oslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					holder.my_atom.loc:hotspot_expose(1000,1000)
				else
					holder.my_atom.loc.loc:hotspot_expose(1000,1000)

		orangeplasma
			name = "orange plasma"
			id = "orangeplasma"
			result = "orangeplasma"
			required_reagents = list("plasma" = 1, "oslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/datum/gas_mixture/air_contents = new
				var/filled = 0.5
				var/maximum_pressure = 90*ONE_ATMOSPHERE
				air_contents.volume = 1000
				air_contents.temperature = T20C
				air_contents.update_values()
				air_contents.toxins = (maximum_pressure*filled)*air_contents.volume/(R_IDEAL_GAS_EQUATION*air_contents.temperature)
				air_contents.update_values()
				var/datum/gas_mixture/environment

				if(istype(holder.my_atom.loc, /turf))
					environment = holder.my_atom.loc:return_air()
					var/transfer_moles = 100*environment.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
					holder.my_atom.loc.assume_air(removed)
				else
					environment = holder.my_atom.loc.loc:return_air()
					var/transfer_moles = 100*environment.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
					holder.my_atom.loc.loc.assume_air(removed)

		violetcreatures
			name = "Violet Slime Extract"
			id = "vcreature"
			result = "vcreature"
			required_reagents = list("blood" = 1, "vslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					new /obj/critter/killertomato/metroid(holder.my_atom.loc)
				else
					new /obj/critter/killertomato/metroid(holder.my_atom.loc.loc)

		violetteleport
			name = "Violet Slime Extract"
			id = "vteleport"
			result = "vteleport"
			required_reagents = list("plasma" = 1, "vslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					for(var/atom/movable/M in range(rand(1,3), holder.my_atom.loc))
						M.x = rand(1,255)
						M.y = rand(1, 255)
				else
					for(var/atom/movable/M in range(rand(1,3), holder.my_atom.loc.loc))
						M.x = rand(1,255)
						M.y = rand(1, 255)

		greenplant
			name = "greenslime acid"
			id = "mushslime"
			result = "mushslime"
			required_reagents = list("blood" = 1, "grslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					new /obj/plant(holder.my_atom.loc)
				else
					new /obj/plant(holder.my_atom.loc.loc)

		redalert
			name = "redslime acid"
			id = "redslimegbs"
			result = "redslimegbs"
			required_reagents = list("blood" = 1, "rslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					for(var/mob/simulated/living/humanoid/H in range(1, holder.my_atom))
						H.gib()
				else
					for(var/mob/simulated/living/humanoid/H in range(1, holder.my_atom.loc))
						H.gib()

		redbingbang
			name = "redslime polyacid"
			id = "redboom"
			result = "redboom"
			required_reagents = list("plasma" = 1, "rslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				if(istype(holder.my_atom.loc, /turf))
					boom(rand(3, 6), holder.my_atom.loc)
				else
					for(var/mob/simulated/living/humanoid/H in range(1, holder.my_atom.loc))
						boom(rand(3, 6), holder.my_atom.loc.loc)


		oxygenerate
			name = "blue air"
			id = "bair"
			result = "bair"
			required_reagents = list("blood" = 1, "bslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/datum/gas_mixture/air_contents = new
				var/filled = 0.5
				var/maximum_pressure = 90*ONE_ATMOSPHERE
				air_contents.volume = 1000
				air_contents.temperature = T20C
				air_contents.update_values()
				air_contents.oxygen = (maximum_pressure*filled)*air_contents.volume/(R_IDEAL_GAS_EQUATION*air_contents.temperature)
				air_contents.update_values()
				var/datum/gas_mixture/environment

				if(istype(holder.my_atom.loc, /turf))
					environment = holder.my_atom.loc:return_air()
					var/transfer_moles = 100*environment.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
					holder.my_atom.loc.assume_air(removed)
				else
					environment = holder.my_atom.loc.loc:return_air()
					var/transfer_moles = 100*environment.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
					holder.my_atom.loc.loc.assume_air(removed)

		strongblack
			name = "strong black"
			id = "sblack"
			result = "sblack"
			required_reagents = list("blood" = 1, "blslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/datum/gas_mixture/air_contents = new
				var/filled = 0.5
				var/maximum_pressure = 90*ONE_ATMOSPHERE
				air_contents.volume = 1000
				air_contents.temperature = T20C
				air_contents.update_values()
				air_contents.oxygen = (maximum_pressure*filled)*air_contents.volume/(R_IDEAL_GAS_EQUATION*air_contents.temperature)
				air_contents.update_values()
				var/datum/gas_mixture/environment

				if(istype(holder.my_atom.loc, /turf))
					environment = holder.my_atom.loc:return_air()
					environment.temperature = environment.temperature+rand(200, 300)
				else
					environment = holder.my_atom.loc.loc:return_air()
					environment.temperature = environment.temperature+rand(200, 300)

		coolblue
			name = "cool blue"
			id = "cblue"
			result = "cblue"
			required_reagents = list("plasma" = 1, "bslime" = 1)

			on_reaction(var/datum/reagents/holder, var/created_volume)
				var/datum/gas_mixture/air_contents = new
				var/filled = 0.5
				var/maximum_pressure = 90*ONE_ATMOSPHERE
				air_contents.volume = 1000
				air_contents.temperature = T20C
				air_contents.update_values()
				air_contents.oxygen = (maximum_pressure*filled)*air_contents.volume/(R_IDEAL_GAS_EQUATION*air_contents.temperature)
				air_contents.update_values()
				var/datum/gas_mixture/environment

				if(istype(holder.my_atom.loc, /turf))
					environment = holder.my_atom.loc:return_air()
					environment.temperature = environment.temperature-rand(200, 300)
				else
					environment = holder.my_atom.loc.loc:return_air()
					environment.temperature = environment.temperature-rand(200, 300)
		//SLIME

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
