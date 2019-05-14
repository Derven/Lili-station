/obj/item/device/radio
	var/obj/machinery/radio/RADIOCURCUIT
	icon = 'radio.dmi'
	icon_state = "hand_radio"

	New()
		..()
		RADIOCURCUIT = new(src)

	attack_self()
		RADIOCURCUIT.attack_hand()