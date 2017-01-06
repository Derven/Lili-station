/obj/structure
	var/obj/item/parts = null

/obj/structure/table
	icon = 'table.dmi'
	anchored = 1
	density = 1
	parts = /obj/item/wood

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/wrench))
			brat << "Вы разбираете стол..."
			if(do_after(brat, 5))
				deconstruct()

/obj/structure/stool
	icon = 'stool.dmi'

/obj/structure/ladder
	anchored = 1
	density = 1

/obj/structure/ladder/down
	icon = 'ladder_down.dmi'

	attack_hand(mob/user)
		user.Move(locate(user.x, user.y, user.z - 1))

/obj/structure/ladder/up
	icon = 'ladder_up.dmi'

	attack_hand(mob/user)
		user.Move(locate(user.x, user.y, user.z + 1))

/obj/structure/proc/deconstruct()
	new parts(src.loc)
	del(src)