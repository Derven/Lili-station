/obj/item/weapon/fire_ext
	name = "fire_ext"
	icon = 'tools.dmi'
	icon_state = "fire_ext"
	force = 35
	var/on = 0

	afterattack(atom/target, mob/user , flag)
		sleep(2)
		if(on == 1)
			if(istype(target, /turf))
				new /obj/effect/extinguish(target)
				for(var/mob/M in range(5, src))
					M << 'spray.ogg'
				for(var/obj/fire/F in range(1, src))
					del(F)
			else
				..()
		else
			..()

	attack_self()
		on = !on
		usr << "\blue You turned [on == 1 ? "on" : "off"] the fire extinguisher."

/obj/effect/extinguish
	icon = 'effects.dmi'
	icon_state = "extinguish"

	New()
		..()
		sleep(rand(1,2))
		alpha = rand(0, 121)
		sleep(rand(1,2))
		del(src)