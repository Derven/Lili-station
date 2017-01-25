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

	proc/set_up()

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

/obj/structure/decor
	icon ='stationobjs.dmi'