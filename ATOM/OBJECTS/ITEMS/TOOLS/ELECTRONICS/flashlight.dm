/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'tools.dmi'
	icon_state = "flashlight"
	var/on = 0
	var/brightness_on = 5 //luminosity when on

/obj/item/device/flashlight/initialize()
	..()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		sd_SetLuminosity(brightness_on)
	else
		icon_state = initial(icon_state)
		sd_SetLuminosity(0)

/obj/item/device/flashlight/proc/update_brightness(var/mob/user = null)
	if(on)
		icon_state = "[initial(icon_state)]-on"
		if(loc == usr)
			usr.sd_SetLuminosity(brightness_on)
		else if(isturf(loc))
			sd_SetLuminosity(brightness_on)
	else
		icon_state = initial(icon_state)
		if(loc == user)
			usr.sd_SetLuminosity(0)
		else if(isturf(loc))
			sd_SetLuminosity(0)

/obj/item/device/flashlight/attack_self(mob/user)
	if(!isturf(usr.loc))
		user << "You cannot turn the light on while in this [user.loc]." //To prevent some lighting anomalities.
		return 0
	on = !on
	update_brightness(usr)
	return 1