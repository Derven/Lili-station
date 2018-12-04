/obj/item/stack/tile
	name="tile"
	icon = 'mineral.dmi'
	icon_state = "tile"

	attack_self()
		var/turf/simulated/floor/F = locate(5, 5, 2)
		usr.show(F)
		usr.drop_item_v()
		del(src)
