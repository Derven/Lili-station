/obj/item/stack/glass
	name="glass"
	icon = 'mineral.dmi'
	icon_state = "glass"

	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/turf/simulated/wall/window/F = locate(3, 1, 2)
		H.show(F)
		H.drop_item_v()
		del(src)