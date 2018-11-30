/obj/structure
	var/health = 20

/obj/structure/grille
	icon='stationobjs.dmi'
	icon_state = "grille"
	density = 1
	anchored = 1

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		health -= W.force
		usr << usr.select_lang("\red Вы бьете решетку с помощью [W]", "\red You punch the grille with [W]")
		update_icon()
		if(health < 5)
			//src = new /turf/simulated/floor/plating(src)
			//relativewall_neighbours()
			usr << usr.select_lang("\red Решетка ломаетс&#255;", "The grille is broken")
			del(src)

	prison
		health = 200000 //May the Force be with you
		icon_state = "prison"
		z_plus
			pixel_z = 32
			ZLevel = 2
			layer = 18