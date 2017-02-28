/obj/item/stack/glass
	name="glass"
	icon = 'mineral.dmi'
	icon_state = "glass"

	attack_self()
		var/turf/simulated/wall/window/F = locate(3, 1, 2)
		usr.show(F)
		usr.drop_item_v()
		del(src)