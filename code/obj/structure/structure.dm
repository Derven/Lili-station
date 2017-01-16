/obj
	var/obj/item/parts = null

/obj/structure/table
	icon = 'table.dmi'
	icon_state = "0"
	anchored = 1
	density = 1
	parts = /obj/item/wood
	var/auto_type = /obj/structure/table
	var/auto = 1

	New()
		..()
		spawn(10)
			if (src.auto)
				if (ispath(src.auto_type) && src.icon_state == "0") // if someone's set up a special icon state don't mess with it
					src.set_up()
					spawn(1)
						for (var/obj/structure/table/T in orange(1))
							if (T.auto)
								T.set_up()

		var/bonus = 0
		for (var/obj/O in loc)
			if (istype(O, /obj/item))
				bonus += 4
			if (istype(O, /obj/structure/table) && O != src)
				return

	proc/set_up()
		if (!ispath(src.auto_type))
			return
		var/dirs = 0
		for (var/direction in cardinal)
			var/turf/T = get_step(src, direction)
			if (locate(src.auto_type) in T)
				dirs |= direction
		icon_state = num2text(dirs)

		//christ this is ugly
		var/obj/structure/table/SWT = locate(src.auto_type) in get_step(src, SOUTHWEST)
		if (SWT)
			var/obj/structure/table/ST = locate(src.auto_type) in get_step(src, SOUTH)
			var/obj/structure/table/WT = locate(src.auto_type) in get_step(src, WEST)
			if (ST && WT)
				src.overlays += "SW"

		var/obj/structure/table/SET = locate(src.auto_type) in get_step(src, SOUTHEAST)
		if (SET)
			var/obj/structure/table/ST = locate(src.auto_type) in get_step(src, SOUTH)
			var/obj/structure/table/ET = locate(src.auto_type) in get_step(src, EAST)
			if (ST && ET)
				src.overlays += "SE"

		var/obj/structure/table/NWT = locate(src.auto_type) in get_step(src, NORTHWEST)
		if (NWT)
			var/obj/structure/table/NT = locate(src.auto_type) in get_step(src, NORTH)
			var/obj/structure/table/WT = locate(src.auto_type) in get_step(src, WEST)
			if (NT && WT)
				src.overlays += "NW"

		var/obj/structure/table/NET = locate(src.auto_type) in get_step(src, NORTHEAST)
		if (NET)
			var/obj/structure/table/NT = locate(src.auto_type) in get_step(src, NORTH)
			var/obj/structure/table/ET = locate(src.auto_type) in get_step(src, EAST)
			if (NT && ET)
				src.overlays += "NE"

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/wrench))
			brat << "Вы разбираете стол..."
			if(do_after(brat, 5))
				deconstruct()
			return

		usr.drop_item(src)
		return

/obj/structure/stool
	icon = 'stool.dmi'

/obj/structure/ladder
	anchored = 1

/obj/structure/ladder/down
	icon = 'ladder_down.dmi'

	attack_hand(mob/user)
		user.Move(locate(user.x, user.y, user.z - 1))

/obj/structure/ladder/up
	icon = 'ladder_up.dmi'

	attack_hand(mob/user)
		user.Move(locate(user.x, user.y, user.z + 1))

/obj/proc/deconstruct()
	new parts(src.loc)
	del(src)

/obj/structure/sign
	icon ='sign.dmi'