/mob/verb/Say(msg as text)
	overlays.Add(overlay_cur)
	for(var/mob/M in range(5, src))
		if(death == 0)
			M << M.select_lang("[src] говорит, \"[fix255(msg)]\"", "[src] says, \"[fix255(msg)]\"")
	sleep(8)
	overlays.Remove(overlay_cur)

/mob/verb/Emote(msg as text)
	for(var/mob/M in range(5, src))
		M << "<b>[src] [fix255(msg)]</b>"

/mob/verb/OOC(msg as text)
	world << "\blue OOC [usr.ckey]: [fix255(msg)]"