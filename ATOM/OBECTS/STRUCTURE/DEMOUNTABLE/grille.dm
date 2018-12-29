/obj/structure
	var/health = 20

/obj/structure/grille
	icon='stationobjs.dmi'
	icon_state = "grille"
	density = 1
	anchored = 1

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		health -= W.force
		usr << "\red You punch the grille with [W]"
		update_icon()
		if(health < 5)
			//ReplaceWithPlating()
			//relativewall_neighbours()
			usr << "The grille is broken"
			del(src)

	prison
		health = 200000 //May the Force be with you
		icon_state = "prison"
		z_plus
			pixel_z = 32
			ZLevel = 2
			layer = 18