/obj/item/construct/apc
	icon = 'power.dmi'
	icon_state = "apc"
	name = "APC frame"

	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/obj/machinery/simple_apc/T = new()
		H.show(T)
		H.drop_item_v()
		del(src)

/obj/item/construct/chair
	icon = 'stationobjs.dmi'
	icon_state = "chair"
	name = "chair frame"

	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/obj/structure/stool/chair/T = new()
		H.show(T)
		H.drop_item_v()
		del(src)

/obj/item/construct/grille
	icon = 'stationobjs.dmi'
	icon_state = "grille"
	name = "grille frame"

	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/obj/structure/grille/T = new()
		H.show(T)
		H.drop_item_v()
		del(src)

/obj/item/construct/stool
	icon = 'stationobjs.dmi'
	icon_state = "stool"
	name = "stool frame"

	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/obj/structure/stool/T = new()
		H.show(T)
		H.drop_item_v()
		del(src)

/obj/item/construct/closet
	icon = 'closet.dmi'
	icon_state = "closed"
	name = "closet frame"

	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/obj/structure/closet/T = new()
		H.show(T)
		H.drop_item_v()
		del(src)

/obj/item/construct/crate
	icon = 'closet.dmi'
	icon_state = "crate"
	name = "crate frame"

	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/obj/structure/closet/crate/T = new()
		H.show(T)
		H.drop_item_v()
		del(src)