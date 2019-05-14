/obj/item
	var/stun = 0

/obj/item/weapon/flasher
	name = "portable flash"
	icon = 'tools.dmi'
	icon_state = "flash"

/obj/item/weapon/stunbaton
	name = "stunbaton"
	icon = 'tools.dmi'
	icon_state = "stunbaton"
	force = 5
	stun = 18

/obj/item/weapon/handcuffs
	name = "handcuffs"
	icon = 'tools.dmi'
	icon_state = "handcuffs"
	force = 2

/obj/item/bomb
	var/bombtime = 25
	var/power = 3
	icon = 'tools.dmi'
	icon_state = "bomb"

	attack_self()
		icon_state = "bomb_active"
		sleep(bombtime)
		boom(power, src.loc)
		del(src)

	smokebomb

		attack_self()
			icon_state = "bomb_active"
			sleep(bombtime)
			for(var/turf/simulated/floor/F in range(power, src))
				new /obj/effect/smoke(F)
			del(src)
