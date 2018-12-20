/obj/item/stack
	metal
		name="metal"
		icon = 'mineral.dmi'
		icon_state = "metal"

		attack_self()
			var/turf/simulated/wall/W = locate(1, 1, 2)
			usr.show(W)
			usr.drop_item_v()
			del(src)