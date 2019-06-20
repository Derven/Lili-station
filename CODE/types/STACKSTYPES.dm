/obj/item/stack/glass
	name="glass"
	icon = 'mineral.dmi'
	icon_state = "glass"

	price = 35

	attack_self()
		var/mob/simulated/living/humanoid/H = usr
		var/turf/simulated/wall/window/F = locate(3, 1, 2)
		H.show(F)
		H.drop_item_v()
		del(src)

/obj/item/stack
	metal
		name="metal"
		icon = 'mineral.dmi'
		icon_state = "metal"
		price = 50

		attack_self()
			var/mob/simulated/living/humanoid/H = usr
			var/turf/simulated/wall/W = locate(1, 1, 2)
			H.show(W)
			H.drop_item_v()
			del(src)

/obj/item/wood
	name = "stack"
	icon = 'mineral.dmi'
	icon_state = "wood"

/obj/item/stack
	metalore
		name="metal ore"
		icon = 'mineral.dmi'
		icon_state = "metal_ore"
		price = 30

		metalscraps
			name="metal scraps"

/obj/item/stack
	diamond
		icon = 'mineral.dmi'
		icon_state = "diamond"

	uranus
		name = "uranus"
		icon = 'mineral.dmi'
		icon_state = "uranus"

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