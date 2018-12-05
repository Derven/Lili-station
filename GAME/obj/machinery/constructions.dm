/obj/item/construct/apc
	icon = 'power.dmi'
	icon_state = "apc"
	name = "APC frame"

	attack_self()
		var/obj/machinery/simple_apc/T = new()
		usr.show(T)
		usr.drop_item_v()
		del(src)

/obj/item/construct/chair
	icon = 'stationobjs.dmi'
	icon_state = "chair"
	name = "chair frame"

	attack_self()
		var/obj/structure/stool/chair/T = new()
		usr.show(T)
		usr.drop_item_v()
		del(src)

/obj/item/construct/grille
	icon = 'stationobjs.dmi'
	icon_state = "grille"
	name = "grille frame"

	attack_self()
		var/obj/structure/grille/T = new()
		usr.show(T)
		usr.drop_item_v()
		del(src)

/obj/item/construct/stool
	icon = 'stationobjs.dmi'
	icon_state = "stool"
	name = "stool frame"

	attack_self()
		var/obj/structure/stool/T = new()
		usr.show(T)
		usr.drop_item_v()
		del(src)

/obj/item/construct/closet
	icon = 'closet.dmi'
	icon_state = "closed"
	name = "closet frame"

	attack_self()
		var/obj/structure/closet/T = new()
		usr.show(T)
		usr.drop_item_v()
		del(src)

/obj/item/construct/crate
	icon = 'closet.dmi'
	icon_state = "crate"
	name = "crate frame"

	attack_self()
		var/obj/structure/closet/crate/T = new()
		usr.show(T)
		usr.drop_item_v()
		del(src)