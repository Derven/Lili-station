/mob/verb/Say(msg as text)
	for(var/mob/M in range(5, src))
		if(death == 0)
			M << "[src] говорит, \"[fix255(msg)]\""
			M.overlays.Add(overlay_cur)
			sleep(8)
			M.overlays.Remove(overlay_cur)

/mob/verb/Emote(msg as text)
	for(var/mob/M in range(5, src))
		M << "<b>[src] [fix255(msg)]</b>"

/mob/verb/OOC(msg as text)
	world << "\blue OOC [usr.ckey]: [fix255(msg)]"