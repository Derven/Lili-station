/obj/item/device/flashlight
	name = "flashlight"
	icon = 'tools.dmi'
	icon_state = "flashlight_off"
	var/on = 0
	var/power = 3

	Move()
		..()
		if(on == 1)
			sd_SetLuminosity(power)

	attack_self()
		if(on == 1)
			on = 0
			icon_state = "flashlight_off"
		else
			on = 1
			icon_state = "flashlight_on"

	process()
		if(istype(src.loc, /mob))
			if(on == 1)
				src.loc:FLASHLIGHT = src
				src.loc:glowing_level = power
				src.loc:glow_mob()
			else
				src.loc:glowing_level = 0
				src.loc:FLASHLIGHT = null


