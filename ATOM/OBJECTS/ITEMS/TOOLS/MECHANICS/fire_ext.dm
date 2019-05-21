/obj/item/weapon/fire_ext
	name = "fire_ext"
	icon = 'tools.dmi'
	icon_state = "fire_ext"
	force = 35

	afterattack(atom/target, mob/user , flag)
		sleep(2)
		if(istype(target, /turf))
			for(var/mob/M in range(5, src))
				M << 'spray.ogg'
			for(var/obj/fire/F in range(1, src))
				del(F)