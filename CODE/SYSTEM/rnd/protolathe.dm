/*
Protolathe

Similar to an autolathe, you load glass and metal sheets (but not other objects) into it to be used as raw materials for the stuff
it creates. All the menus and other manipulation commands are in the R&D console.

Note: Must be placed west/left of and R&D console to function.

*/
/obj/machinery/r_n_d/protolathe
	name = "Protolathe"
	icon_state = "autolathe"
	flags = OPENCONTAINER
	var
		max_material_storage = 100000 //All this could probably be done better with a list but meh.
		m_amount = 0.0
		g_amount = 0.0
		gold_amount = 0.0
		silver_amount = 0.0
		plasma_amount = 0.0
		uranium_amount = 0.0
		diamond_amount = 0.0
		clown_amount = 0.0
		adamantine_amount = 0.0

	proc/TotalMaterials() //returns the total of all the stored materials. Makes code neater.
		return m_amount + g_amount + gold_amount + silver_amount + plasma_amount + uranium_amount + diamond_amount + clown_amount

	RefreshParts()
		var/T = 0
		for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
			T += G.reagents.maximum_volume
		var/datum/reagents/R = new/datum/reagents(T)		//Holder for the reagents used as materials.
		reagents = R
		R.my_atom = src
		T = 0
		max_material_storage = T * 75000

	attackby(var/obj/item/O as obj, var/mob/user as mob)
		if (disabled)
			return
		if (!linked_console)
			user << "\The protolathe must be linked to an R&D console first!"
			return 1
		if (busy)
			user << "\red The protolathe is busy. Please wait for completion of previous operation."
			return 1
		if (!istype(O, /obj/item/stack))
			user << "\red You cannot insert this item into the protolathe!"
			return 1
		if (stat)
			return 1
		if (TotalMaterials() + 3750 > max_material_storage)
			user << "\red The protolathe's material bin is full. Please remove material before adding more."
			return 1

		var/obj/item/stack/stack = O
		var/amount = 1

		if(istype(O, /obj/item/stack))
			flick("protolathe_animation",src)//plays glass insertion animation

		icon_state = "autolathe"
		busy = 1
		spawn(16)
			user << "\blue You add [amount] sheets to the [src.name]."
			icon_state = "autolathe"
			flick("protolathe_animation",src)
			if(istype(stack, /obj/item/stack/metal))
				m_amount += amount * 3750
			else if(istype(stack, /obj/item/stack/glass))
				g_amount += amount * 3750
			else if(istype(stack, /obj/item/stack/gold))
				gold_amount += amount * 3750
			else if(istype(stack, /obj/item/stack/silver))
				silver_amount += amount * 3750
			else if(istype(stack, /obj/item/stack/plasma))
				plasma_amount += amount * 3750
			else if(istype(stack, /obj/item/stack/uranus))
				uranium_amount += amount * 3750
			else if(istype(stack, /obj/item/stack/diamond))
				diamond_amount += amount * 3750
			else if(istype(stack, /obj/item/stack/clown))
				clown_amount += amount * 3750
			else if(istype(stack, /obj/item/stack/adamantine))
				adamantine_amount += amount * 3750
			usr:drop_item_v()
			del(stack)
			busy = 0
		return