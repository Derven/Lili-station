/turf/simulated/wall

	asteroid
		icon_state = "asteroid"
		health = 300
		var/obj/item/my_mineral

		attackby(obj/item/weapon/W as obj, mob/user as mob)
			if(istype(W, /obj/item/weapon/pickaxe))
				health -= W.force
				usr << "You attack the asteroid!"
				update_icon()
				if(health < 30)
					clear_for_all()
					if(my_mineral)
						new my_mineral(src)
					src = new /turf/unsimulated/floor/planet(src)
					//relativewall_neighbours()
					usr << "<b>Part of the rock destroyed</b>"
