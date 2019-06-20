/turf/unsimulated/floor
	name = "floor"
	icon_state = "floor"

/turf/unsimulated/floor/roof
	icon_state = "visibleroof"

	var/image/roof
	Height = 2

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/wrench))
			usr << "\red You deconstruct the roof with [W]"
			src = new /turf/unsimulated/floor(src)