/obj/structure/table
	name = "table"
	icon = 'table.dmi'
	icon_state = "0"
	anchored = 1
	density = 1
	parts = /obj/item/stack/table_parts
	var/auto_type = /obj/structure/table

	zlevel_2
		ZLevel = 2
		pixel_z = 32
		layer = 20
		color = "red"

	New()
		..()
		set_up()
		if(!(istype(src, /obj/structure/table/wood)))
			color = null

	Del()
		..()
		set_up()

	proc/set_up()
		spawn(10)
			var/turf/south = get_step(src, SOUTH)
			var/turf/north = get_step(src, NORTH)
			var/turf/west = get_step(src, WEST)
			var/turf/east = get_step(src, EAST)

			if(locate(/obj/structure/table, south))
				icon_state = "s"

			if(locate(/obj/structure/table, north))
				icon_state = "n"

			if(locate(/obj/structure/table, west))
				icon_state = "w"

			if(locate(/obj/structure/table, east))
				icon_state = "e"

			if(locate(/obj/structure/table, south) && locate(/obj/structure/table, north))
				icon_state = "ns"

			if(locate(/obj/structure/table, north) && locate(/obj/structure/table, west))
				icon_state = "nw"

			if(locate(/obj/structure/table, north) && locate(/obj/structure/table, east))
				icon_state = "ne"

			if(locate(/obj/structure/table, south) && locate(/obj/structure/table, east))
				icon_state = "se"

			if(locate(/obj/structure/table, south) && locate(/obj/structure/table, west))
				icon_state = "sw"

			if(locate(/obj/structure/table, east) && locate(/obj/structure/table, west))
				icon_state = "we"

			if(locate(/obj/structure/table, east) && locate(/obj/structure/table, west) && locate(/obj/structure/table, north))
				icon_state = "we1"

			if(locate(/obj/structure/table, east) && locate(/obj/structure/table, west) && locate(/obj/structure/table, south))
				icon_state = "we2"

//			if(locate(/obj/structure/table,get_step(src,direction)))
//				var/obj/structure/table/T = locate(/obj/structure/table,get_step(src,direction))

	attackby(obj/item/weapon/W as obj, var/mob/simulated/living/humanoid/user as mob)
		user = usr
		if(istype(W, /obj/item/weapon/wrench))
			usr << "You deconstruct the table..."
			if(do_after(usr, 5))
				for(var/obj/O in src.loc)
					O.pixel_z = -16
				deconstruct()
			return

		W.pixel_z = 6
		user.drop_item(src)
		return