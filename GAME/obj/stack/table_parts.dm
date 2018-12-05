/obj/item/stack
	table_parts
		icon = 'mineral.dmi'
		icon_state = "table_parts"
		name = "table frame"

	attack_self()
		var/obj/structure/table/T = new()
		usr.show(T)
		usr.drop_item_v()
		del(src)