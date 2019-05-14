/obj/item/stack
	table_parts
		icon = 'mineral.dmi'
		icon_state = "table_parts"
		name = "table frame"

	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/obj/structure/table/T = new()
		H.show(T)
		H.drop_item_v()
		del(src)