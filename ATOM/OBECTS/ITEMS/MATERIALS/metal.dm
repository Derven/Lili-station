/obj/item/stack
	metal
		name="metal"
		icon = 'mineral.dmi'
		icon_state = "metal"

		attack_self()
			var/mob/simulated/living/humanoid/H = usr
			var/turf/simulated/wall/W = locate(1, 1, 2)
			H.show(W)
			H.drop_item_v()
			del(src)