/obj/structure/closet
	wall_closet
		anchored = 1
		density = 0
		name = "wall cabinet"
		desc = "It's a wall-mounted cabinet."
		icon = 'closet.dmi'
		icon_state = "wall_cabinet"
		icon_closed = "wall_cabinet"
		icon_opened = "wall_cabinet_open"

	fire_closet
		anchored = 1
		density = 0
		name = "wall cabinet"
		desc = "It's a wall-mounted cabinet."
		icon = 'closet.dmi'
		icon_state = "fire_cabinet"
		icon_closed = "fire_cabinet"
		icon_opened = "fire_cabinet_open"

		New()
			..()
			new /obj/item/weapon/fire_ext(src)