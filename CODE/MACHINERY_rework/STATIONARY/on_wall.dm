/obj/machinery/minicontrolleronwall
	name = "machinery"
	icon = 'stationobjs.dmi'
	icon_state = "air_alarm"
	anchored = 1
	var/datum/emodule/central/CNT

	process()
		CNT.myprocess()

	air_alarm
		name = "atmospherics alarm"
		New()
			CNT = new /datum/emodule/central/temperature_alert_module(src)
			..()

	fire_alarm
		name = "fire alarm"
		icon_state = "firealarm"
		New()
			CNT = new /datum/emodule/central/temperature_alert_module(src)
			..()

	consol
		name = "atmospherics alarm console"
		icon_state = "electronicmachinery"

		New()
			CNT = new /datum/emodule/central/temperature_alert_module(src)
			..()

/obj/machinery/simpleonwall
	recharger
		icon = 'stationobjs.dmi'
		name = "recharger"
		icon_state = "recharger1"
		anchored = 1

		attackby(obj/item/O as obj)
			if(istype(O, /obj/item/weapon/gun/energy) && !istype(O, /obj/item/weapon/gun/energy/superoldrifle))
				if(length(contents) == 0)
					var/mob/simulated/living/humanoid/H = usr
					H.drop_item_v()
					O.Move(src)

		attack_hand()
			for(var/obj/item/O in contents)
				O.loc = src.loc

		process()
			if(charge > 0)
				for(var/obj/item/weapon/gun/energy/O in contents)
					if(O.mycharge < 1000)
						O.mycharge += 10
						icon_state = "recharger2"
						sleep(3)
						icon_state = "recharger1"

		cyborg_recharger
			icon = 'stationobjs.dmi'
			name = "cyborg_recharger"
			icon_state = "cy_charge1"
			anchored = 1
			var/charger_mode = 0

			attack_hand()
				if(istype(usr, /mob/simulated/living/humanoid/cyborg))
					if(src.loc == usr.loc)
						if(charger_mode == 0)
							charger_mode = 1
							icon_state = "cy_charge2"
							layer = 17
							return
						else
							charger_mode = 0
							icon_state = "cy_charge1"
							layer = initial(layer)
							return

			process()
				if(charge > 0)
					if(charger_mode == 1)
						var/cy_counter = 0
						for(var/mob/simulated/living/humanoid/cyborg/O in loc)
							cy_counter = 1
							if(O.charge < initial(O.charge))
								O.charge += 5
								if(O.charge > initial(O.charge))
									O.charge = initial(O.charge)
							O.dir = NORTH
						if(cy_counter == 0)
							charger_mode = 0
							icon_state = "cy_charge1"
							layer = initial(layer)
				else
					charger_mode = 0
					icon_state = "cy_charge1"
					layer = initial(layer)