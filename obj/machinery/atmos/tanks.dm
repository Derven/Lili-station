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


/obj/item/weapon/tank/oxygen

/obj/item/weapon/tank/oxygen/New()
	..()
	air_contents = new()
	src.air_contents.oxygen = (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)
	return

/obj/item/weapon/tank/plasma/New()
	..()
	air_contents = new()
	src.air_contents.toxins = (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C)
	return

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
		src.air_contents.toxins = (3*ONE_ATMOSPHERE)*70/(R_IDEAL_GAS_EQUATION*T20C)
		air_contents.temperature = 900
		return

	attack_self()
		ignite()