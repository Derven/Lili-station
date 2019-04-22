/obj/machinery/minicontrolleronwall
	name = "machinery"
	icon = 'stationobjs.dmi'
	icon_state = "air_alarm"
	anchored = 1
	var/datum/emodule/central/CNT

	process()
		CNT.myprocess()

	air_alarm
		New()
			CNT = new /datum/emodule/central/temperature_alert_module(src)
			..()

	fire_alarm
		icon_state = "firealarm"
		New()
			CNT = new /datum/emodule/central/temperature_alert_module(src)
			..()

	consol
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
			if(istype(O, /obj/item/weapon/gun/energy))
				if(length(contents) == 0)
					var/mob/simulated/living/humanoid/H = usr
					H.drop_item_v()
					O.Move(src)

		attack_hand()
			for(var/obj/item/O in contents)
				O.loc = src.loc

		process()
			for(var/obj/item/weapon/gun/energy/O in contents)
				if(O.mycharge < 1000)
					O.mycharge += 10
					icon_state = "recharger2"
					sleep(3)
					icon_state = "recharger1"