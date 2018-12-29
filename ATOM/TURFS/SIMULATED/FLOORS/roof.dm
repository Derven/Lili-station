/turf/simulated/floor/roof
	icon_state = "null"

	var/image/roof
	Height = 2

	New()
		..()
		roof = image(icon='floors.dmi',icon_state="roof")
		roof.override = 1
		roof.alpha = 128
		roof.loc = src

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/wrench))
			usr << "\red You deconstruct the roof with [W]"
			hide(usr)
			src = new /turf/simulated/floor(src)

	proc/show(var/mob/M)
		roof.layer = 16
		M.layer = 17
		M.client.images += roof

	proc/hide(var/mob/M)
		if(M.client)
			M.client.images -= roof
			M.layer = initial(M.layer)