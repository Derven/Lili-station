/mob/verb/Say(msg as text)
	for(var/mob/M in range(5, src))
		M << "[src] говорит, \"[fix255(msg)]\""

/mob/verb/OOC(msg as text)
	world << "\blue OOC [usr.ckey]: [fix255(msg)]"