/obj/machinery/microwave
	name = "Microwave"
	icon = 'kitchen.dmi'
	icon_state = "microwave"
	layer = 7
	density = 1
	anchored = 1
	use_power = 1
	var/operating = 0 // Is it on?
	var/dirty = 0 // = {0..100} Does it need cleaning?
	var/broken = 0 // ={0,1,2} How broken is it???
	var/global/list/datum/recipe/available_recipes // List of the recipes you can use
	var/global/list/acceptable_items // List of the items you can put in
	var/global/list/acceptable_reagents // List of the reagents you can put in
	var/global/max_n_of_items = 0

/obj/machinery/microwave/New()
	//..() //do not need this
	reagents = new/datum/reagents(100)
	reagents.my_atom = src
	if (!available_recipes)
		available_recipes = new
		for (var/type in (typesof(/datum/recipe)-/datum/recipe))
			available_recipes+= new type
		acceptable_items = new
		acceptable_reagents = new
		for (var/datum/recipe/recipe in available_recipes)
			for (var/item in recipe.items)
				acceptable_items |= item
			for (var/reagent in recipe.reagents)
				acceptable_reagents |= reagent
			if (recipe.items)
				max_n_of_items = max(max_n_of_items,recipe.items.len)

/obj/machinery/microwave/attackby(var/obj/item/O)
	var/mob/simulated/living/humanoid/H = usr
	H.drop_item(src)
	O.loc = src
	//usr << "\blue <b>Вы положили [O]  в [src].<b>"
	usr << "\blue <b>You insert [O] into [src].<b>"

/obj/machinery/microwave/attack_hand() // The microwave Menu
	var/dat = ""
	if(src.broken > 0)
		dat = {"<TT>Bzzzzttttt</TT>"}
	else if(src.operating)
		dat = {"<TT>Microwaving in progress!<BR>Please wait...!</TT>"}
	else if(src.dirty==100)
		dat = {"<TT>This microwave is dirty!<BR>Please clean it before use!</TT>"}
	else
		var/list/items_counts = new
		var/list/items_measures = new
		var/list/items_measures_p = new
		for (var/obj/O in contents)
			var/display_name = O.name
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/egg))
				items_measures[display_name] = "egg"
				items_measures_p[display_name] = "eggs"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/tofu))
				items_measures[display_name] = "tofu chunk"
				items_measures_p[display_name] = "tofu chunks"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/meat)) //any meat
				items_measures[display_name] = "slab of meat"
				items_measures_p[display_name] = "slabs of meat"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/donkpocket))
				display_name = "Turnovers"
				items_measures[display_name] = "turnover"
				items_measures_p[display_name] = "turnovers"
			if (istype(O,/obj/item/weapon/reagent_containers/food/snacks/carpmeat))
				items_measures[display_name] = "fillet of meat"
				items_measures_p[display_name] = "fillets of meat"
			items_counts[display_name]++
		for (var/O in items_counts)
			var/N = items_counts[O]
			if (N==1)
				dat += {"<B>[O]:</B> [N] [items_measures[O]]<BR>"}
			else
				dat += {"<B>[O]:</B> [N] [items_measures_p[O]]<BR>"}

		for (var/datum/reagent/R in reagents.reagent_list)
			var/display_name = R.name
			if (R.id == "capsaicin")
				display_name = "Hotsauce"
			if (R.id == "frostoil")
				display_name = "Coldsauce"
			dat += {"<B>[display_name]:</B> [R.volume] unit\s<BR>"}

		if (items_counts.len==0 && reagents.reagent_list.len==0)
			dat = {"<B>The microwave is empty</B><BR>"}
		else
			dat = {"<b>Ingredients:</b><br>[dat]"}
		dat += {"<HR><BR>\
<A href='?src=\ref[src];action=cook'>Turn on!<BR>\
<A href='?src=\ref[src];action=dispose'>Eject ingredients!<BR>\
"}

	usr << browse("<HEAD><TITLE>Microwave Controls</TITLE></HEAD><TT>[dat]</TT>", "window=microwave")
	return

/obj/machinery/microwave/Topic(href, href_list)
	switch(href_list["action"])
		if ("cook")
			cook()

		if ("dispose")
			dispose()
	return

/obj/machinery/microwave/proc/cook()
	start()
	if (reagents.total_volume==0 && !(locate(/obj) in contents)) //dry run
		if (!wzhzhzh(10))
			abort()
			return
		stop()
		return

	var/datum/recipe/recipe = select_recipe(available_recipes,src)
	if (!recipe)
		dirty += 1
		if (prob(max(10,dirty*5)))
			if (!wzhzhzh(4))
				abort()
				return
			muck_start()
			wzhzhzh(4)
			muck_finish()
			fail()
			return
		else if (has_extra_item())
			if (!wzhzhzh(4))
				abort()
				return
			broke()
			fail()
			return
		else
			if (!wzhzhzh(10))
				abort()
				return
			stop()
			fail()
			return
	else
		var/halftime = round(recipe.time/10/2)
		if (!wzhzhzh(halftime))
			abort()
			return
		if (!wzhzhzh(halftime))
			abort()
			fail()
			return
		recipe.make_food(src, src)
		stop()
		return

/obj/machinery/microwave/proc/wzhzhzh(var/seconds as num)
	for (var/i=1 to seconds)
		sleep(10)
	return 1

/obj/machinery/microwave/proc/has_extra_item()
	for (var/obj/O in contents)
		if (!istype(O,/obj/item/weapon/reagent_containers/food))
			return 1
	return 0

/obj/machinery/microwave/proc/start()
	src.operating = 1
	src.icon_state = "microwave1"

/obj/machinery/microwave/proc/abort()
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "microwave"

/obj/machinery/microwave/proc/stop()
	src.operating = 0 // Turn it off again aferwards
	src.icon_state = "microwave"

/obj/machinery/microwave/proc/dispose()
	for (var/obj/O in contents)
		O.loc = src.loc
	if (src.reagents.total_volume)
		src.dirty++
	src.reagents.clear_reagents()
	usr << "\blue You dispose of the microwave contents."

/obj/machinery/microwave/proc/muck_start()
	src.icon_state = "mwbloody1" // Make it look dirty!!

/obj/machinery/microwave/proc/muck_finish()
	src.dirty = 100 // Make it dirty so it can't be use util cleaned
	src.flags = null //So you can't add condiments
	src.icon_state = "mwbloody" // Make it look dirty too
	src.operating = 0 // Turn it off again aferwards

/obj/machinery/microwave/proc/broke()
	src.icon_state = "mwb" // Make it look all busted up and shit
	src.broken = 2 // Make it broken so it can't be use util fixed
	src.flags = null //So you can't add condiments
	src.operating = 0 // Turn it off again aferwards

/obj/machinery/microwave/proc/fail()
	var/amount = 0
	for (var/obj/O in contents)
		amount++
		del(O)
	src.reagents.clear_reagents()
	var/obj/item/weapon/reagent_containers/food/snacks/badrecipe/ffuu = new(src)
	ffuu.reagents.add_reagent("carbon", amount)
	ffuu.reagents.add_reagent("toxin", amount/10)

/obj/item/weapon/reagent_containers/food/snacks/badrecipe/ffuu
	name = "GOVNO"