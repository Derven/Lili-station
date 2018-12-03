//shit rewrite
/obj/machinery/radio
	icon = 'radio.dmi'
	anchored = 1

	intercom
		icon_state = "intercom"

	proc/hi_gays(var/arr_name)
		flick("intercom_flick", src)
		var/sound/S = sound('s.ogg')
		for(var/mob/B in range(7, src))
			B << "\blue ***radio*** station AI: [arr_name] has arrived!"
			B << S



/mob/proc/radio_arrival()
	if(usr)
		usr << "<H2>Wellcome to NanoTrasen corporation! Station Lili 1.0.1.0 is a wonderful place!</H2>"
	for(var/obj/machinery/radio/R in world)
		R.hi_gays(name)

proc/tell_me_more(var/mob_name, var/message)
	for(var/obj/machinery/radio/R in world)
		flick("intercom_flick", R)
		var/sound/S = sound('s.ogg')
		for(var/mob/B in range(7, R))
			B << "\blue ***radio*** [mob_name]: says, [message]!"
			B << S