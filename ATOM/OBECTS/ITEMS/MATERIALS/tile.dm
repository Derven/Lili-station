/obj/item/stack/tile
	name="tile"
	icon = 'mineral.dmi'
	icon_state = "tile"

	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/turf/simulated/floor/F = locate(5, 5, 2)
		H.show(F)
		H.drop_item_v()
		del(src)

/obj/item/stack/tile/catwalk
	name = "catwalk tile"
	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/turf/simulated/floor/F = locate(8, 5, 2)
		H.show(F)
		H.drop_item_v()
		del(src)

/obj/item/stack/tile/red
	name = "red tile"
	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/turf/simulated/floor/F = locate(11, 5, 2)
		H.show(F)
		H.drop_item_v()
		del(src)

/obj/item/stack/tile/orange
	name = "orange tile"
	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/turf/simulated/floor/F = locate(9, 5, 2)
		H.show(F)
		H.drop_item_v()
		del(src)

/obj/item/stack/tile/blue
	name = "blue tile"
	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/turf/simulated/floor/F = locate(7, 5, 2)
		H.show(F)
		H.drop_item_v()
		del(src)

/obj/item/stack/tile/wood

/obj/item/stack/tile/bar
	name = "bar tile"
	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/turf/simulated/floor/F = locate(6, 5, 2)
		H.show(F)
		H.drop_item_v()
		del(src)

/obj/item/stack/tile/kitchen
	name = "kitchen tile"
	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/turf/simulated/floor/F = locate(10, 5, 2)
		H.show(F)
		H.drop_item_v()
		del(src)