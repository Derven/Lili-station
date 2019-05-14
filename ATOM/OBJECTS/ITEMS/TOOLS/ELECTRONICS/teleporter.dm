/obj/item/weapon/teleporter
	name = "teleporter"
	icon = 'tools.dmi'
	icon_state = "teleporter"

	attack_self()
		usr << "\blue Wow. You teleported away!"

		//double penetration
		new /obj/effect/sparks(src.loc)
		sleep(rand(1,3))
		new /obj/effect/sparks(src.loc)
		sleep(rand(1,3))
		for(var/mob/M in range(5, src))
			M << 'sparks.ogg'
			M << 'sparks.ogg'
			M << 'sparks.ogg'

		usr.loc = locate(usr.x + rand(-25,25), usr.y + rand(-25,25), rand(1,4) )