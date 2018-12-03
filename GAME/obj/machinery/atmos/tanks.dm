/obj/item/weapon/tank
	name = "tank"
	icon = 'tank.dmi'

	var/datum/gas_mixture/air_contents = null
	var/distribute_pressure = ONE_ATMOSPHERE
	flags = FPRINT | TABLEPASS | CONDUCT | ONBACK

	pressure_resistance = ONE_ATMOSPHERE*5

	force = 5.0
	var/volume = 70


/obj/item/weapon/tank/anesthetic
	name = "Gas Tank (Sleeping Agent)"
	desc = "A N2O/O2 gas mix"

/obj/item/weapon/tank/air
	name = "Gas Tank (Air Mix)"
	desc = "Mixed anyone?"

/obj/item/weapon/igniter
	icon_state = "igniter"
	icon = 'tank.dmi'

/obj/item/weapon/tank/oxygen

/obj/machinery/plasmaheater
	icon = 'atmos.dmi'
	icon_state = "hater_empty"
	var/obj/item/weapon/tank/TANK = null

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/tank))
			if(!TANK)
				TANK = W
				usr.drop_item_v()
				TANK.Move(src)
				icon_state = "hater"

	attack_hand()
		var/body = "<html><body>" + "TANK TEMPERATURE: [TANK ? TANK.air_contents.temperature : 0];<br>" + "<a href='?src=\ref[src];remove=1'>" + usr.select_lang("Вытащить канистру","Remove tank") + "</a><br>" + "<a href='?src=\ref[src];on_off=1'>" + usr.select_lang("Вкл/Выкл","On/Off") + "</a></body></html>"
		usr << browse(body,"window=plasmaheater")

	Topic(href,href_list[])
		if(href_list["remove"])
			if(TANK)
				TANK.Move(src.loc)
				TANK = null
				icon_state = "hater_empty"
			else
				return
		if(href_list["on_off"])
			while(TANK && TANK.air_contents.temperature < 5000)
				sleep(rand(1,6))
				if(TANK)
					TANK.air_contents.temperature += rand(1,5)
					icon_state = "hater_on"
			icon_state = "hater"

/obj/machinery/brigdoor_control
	icon = 'stationobjs.dmi'
	icon_state = "sec_consol"

/obj/machinery/plasmacooler
	icon = 'atmos.dmi'
	icon_state = "cooler_empty"
	var/obj/item/weapon/tank/TANK = null

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/tank))
			if(!TANK)
				TANK = W
				usr.drop_item_v()
				TANK.Move(src)
				icon_state = "cooler"

	attack_hand()
		var/body = "<html><body>" + "TANK TEMPERATURE: [TANK ? TANK.air_contents.temperature : 0];<br>" + "<a href='?src=\ref[src];remove=1'>" + usr.select_lang("Вытащить канистру","Remove tank") + "</a><br>" + "<a href='?src=\ref[src];on_off=1'>" + usr.select_lang("Вкл/Выкл","On/Off") + "</a></body></html>"
		usr << browse(body,"window=plasmacooler")

	Topic(href,href_list[])
		if(href_list["remove"])
			world << "HUI"
			if(TANK)
				TANK.Move(src.loc)
				TANK = null
				icon_state = "cooler_empty"
			else
				return
		if(href_list["on_off"])
			while(TANK && TANK.air_contents.temperature > -300)
				sleep(rand(1,6))
				if(TANK)
					TANK.air_contents.temperature -= rand(1,5)
					icon_state = "cooler_on"
			icon_state = "cooler"


/obj/item/weapon/tank/oxygen/New()
	..()
	air_contents = new()
	src.air_contents.oxygen = (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)
	return

/obj/item/weapon/tank/plasma

	icon_state = "plasma"

	New()
		..()
		air_contents = new()
		src.air_contents.toxins = (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C)
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/igniter))
			var/obj/item/weapon/tank/plasma/bomb/B = new(src.loc)
			B.air_contents.oxygen = src.air_contents.oxygen
			B.air_contents.toxins = src.air_contents.toxins
			B.air_contents.temperature = src.air_contents.temperature
			usr.drop_item_v()
			del(W)
			del(src)

/obj/item/weapon/tank/plasma/proc/ignite()
	var/fuel_moles = air_contents.toxins + air_contents.oxygen/6
	var/strength = 1

	var/turf/ground_zero = get_turf(loc)
	loc = null

	if(air_contents.temperature > (T0C + 400))
		strength = fuel_moles/5
		boom(strength, src.loc)
		//explosion(ground_zero, strength, strength*2, strength*3, strength*4)

	else if(air_contents.temperature > (T0C + 250))
		strength = fuel_moles/10
		boom(strength, src.loc)
		//explosion(ground_zero, 0, strength, strength*2, strength*3)

	else if(air_contents.temperature > (T0C + 100))
		strength = fuel_moles/15
		boom(strength, src.loc)
		//explosion(ground_zero, 0, 0, strength, strength*3)

	else
		ground_zero.assume_air(air_contents)
		//ground_zero.hotspot_expose(1000, 125)

	if(src.master)
		del(src.master)
	del(src)

/obj/item/weapon/tank/plasma/bomb
	icon_state = "bomb"

	New()
		..()
		air_contents = new()
		src.air_contents.oxygen = (2*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)
		src.air_contents.toxins = (6*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C)
		air_contents.temperature = 900
		return

	attack_self()
		ignite()