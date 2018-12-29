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
