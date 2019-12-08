/*
Destructive Analyzer

It is used to destroy hand-held objects and advance technological research. Controls are in the linked R&D console.

Note: Must be placed within 3 tiles of the R&D Console
*/
/obj/machinery/r_n_d/destructive_analyzer
	name = "Destructive Analyzer"
	icon_state = "d_analyzer"
	var
		obj/item/weapon/loaded_item = null
		decon_mod = 1

	proc/ConvertReqString2List(var/list/source_list)
		var/list/temp_list = params2list(source_list)
		for(var/O in temp_list)
			temp_list[O] = text2num(temp_list[O])
		return temp_list

	attackby(obj/item/O as obj, var/mob/simulated/living/humanoid/user as mob)
		if (disabled)
			return
		if (!linked_console)
			usr << "\red The protolathe must be linked to an R&D console first!"
			color = "red"
			return
		if (busy)
			color = "red"
			usr << "\red The protolathe is busy right now."
			return
		if (istype(O, /obj/item) && !loaded_item)
			if(!O.origin_tech)
				usr << "\red This doesn't seem to have a tech origin!"
				color = "red"
				return
			var/list/temp_tech = ConvertReqString2List(O.origin_tech)
			if (temp_tech.len == 0)
				color = "red"
				usr << "\red You cannot deconstruct this item!"
				return
			if(O.reliability < 90 && O.crit_fail == 0)
				color = "red"
				usr << "\red Item is neither reliable enough or broken enough to learn from."
				return
			busy = 1
			loaded_item = O
			usr:drop_item_v()
			O.loc = src
			usr << "\blue You add the [O.name] to the machine!"
			flick("d_analyzer_la", src)
			spawn(10)
				icon_state = "d_analyzer_l"
				busy = 0
		return

//For testing purposes only.
/*/obj/item/weapon/deconstruction_test
	name = "Test Item"
	desc = "WTF?"
	icon = 'weapons.dmi'
	icon_state = "d20"
	g_amt = 5000
	m_amt = 5000
	origin_tech = "materials=5;plasmatech=5;syndicate=5;programming=9"*/