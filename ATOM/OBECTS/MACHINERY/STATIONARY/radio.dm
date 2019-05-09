//shit rewrite
/obj/machinery/radio
	icon = 'radio.dmi'
	anchored = 1
	var/channel = 1

	intercom
		icon_state = "intercom"

	attack_hand()
		channel = input("Choose a channel for your device(between 0 and 100).",
		"Your channel",channel)
		if(!(isnum(channel)) || !(channel > 0) || !(channel < 100))
			channel = 1
			usr << "\red num 0-100 for channel!"

/obj/machinery/radio/mainmachine
	icon = 'radio.dmi'
	icon_state = "main_machine"
	anchored = 1
	var/on = 1
	var/cur_signal = ""
	var/cur_channel = 0
	var/cur_mob = ""
	name = "radiocontroller machine"
	density = 1

	var/list/channels = list()

	proc/get_signal(var/obj/machinery/radio/R, var/tellsignal, var/mob_name, var/channel)
		if (get_dist(R,src) < 25)
			cur_signal = tellsignal
			cur_channel = channel
			cur_mob = mob_name
			if(!(channel in channels))
				channels += channel
			return
		if (get_dist(R,src) < 50)
			cur_signal = tellsignal
			if(prob(35))
				cur_signal = replacetext(cur_signal, "à", "*")
			if(prob(15))
				cur_signal = replacetext(cur_signal, "î", "*")
			cur_channel = channel
			if(!(channel in channels))
				channels += channel
			cur_mob = mob_name
			return
		else
			cur_signal = tellsignal
			if(prob(50))
				cur_signal = replacetext(cur_signal, "à", "*")
			if(prob(45))
				cur_signal = replacetext(cur_signal, "î", "*")
			if(prob(45))
				cur_signal = replacetext(cur_signal, "ñ", "*")
			if(prob(65))
				cur_signal = replacetext(cur_signal, "ë", "*")
			if(prob(45))
				cur_signal = replacetext(cur_signal, "ò", "*")
			cur_channel = channel
			if(!(channel in channels))
				channels += channel
			cur_mob = mob_name
			return

	proc/send_signal()
		for(var/obj/machinery/radio/R in world)
			if(istype(R.loc, /turf))
				if(R.channel == cur_channel)
					flick("intercom_flick", R)
					var/sound/S = sound('s.ogg')
					for(var/mob/B in range(7, R))
						B << "\blue ***radio*** [cur_mob]: says, [cur_signal]!"
						B << S
			else
				if(R.channel == cur_channel)
					if(istype(R.loc.loc, /turf))
						for(var/mob/B in range(3, R.loc))
							B << "\blue ***radio*** [cur_mob]: says, [cur_signal]!"
					if(istype(R.loc.loc.loc, /turf))
						for(var/mob/B in range(3, R.loc.loc.loc))
							B << "\blue ***radio*** [cur_mob]: says, [cur_signal]!"

		cur_signal = ""
		cur_channel = 0
		cur_mob = ""

	process()
		if (cur_signal != "" && cur_channel != 0 && on == 1)
			icon_state = "main_machine"
			send_signal()
		if(on == 0)
			icon_state = "main_machine_off"

	attack_hand()
		var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
		body += "<body>Radio system control:<hr><table class=\"pure-table\"><thead><tr><th>#Num</th><th>Channel</th></tr></thead><tbody>"
		var/i = 0
		for(var/channel_check in channels)
			i += 1
			body += "<tr><td>[i]#</td><td>[channel_check]</td></tr>"
		body += "</tbody></table><hr><a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];on_off=1;'>On/Off</a></html></body>"
		body += "<br>State: [on == 1 ? "on" : "off"]"
		usr << browse(body,"window=radiocontrol")

/obj/machinery/radio/mainmachine/Topic(href,href_list[])
	if(usr.check_topic(src))
		if(href_list["on_off"] == "1")
			if(on == 1)
				on = 0
				icon_state = "main_machine_off"
				return
			if(on == 0)
				on = 1
				icon_state = "main_machine"
				return

/mob/proc/radio_arrival()
	if(usr)
		usr << "<H2>Wellcome to NanoTrasen corporation! Station Lili 1.0.1.0 is a wonderful place!</H2>"

proc/tell_me_more(var/mob_name, var/obj/machinery/radio/R, var/message)
	for(var/obj/machinery/radio/mainmachine/MM in world)
		MM.get_signal(R, message, mob_name, R.channel)