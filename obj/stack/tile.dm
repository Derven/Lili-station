/obj/item/stack/tile
	name="tile"
	icon = 'mineral.dmi'
	icon_state = "tile"

	attack_self()
		var/turf/simulated/floor/F = locate(2, 1, 2)
		usr.show(F)
		usr.drop_item_v()
		del(src)