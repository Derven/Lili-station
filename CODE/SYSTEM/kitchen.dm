/obj/item/weapon/reagent_containers/food/dough
	var/dtype = "dough"
	icon_state = "burger"
	name = "dough"

	update_icon()
		switch(dtype)
			if("burger")
				name = "burger"
				icon_state = "burger"
			if("soup")
				name = "soup"
				icon_state = "soup"
			if("donut")
				name = "donut"
				icon_state = "donut"
			if("cake")
				name = "cake"
				icon_state = "plaincake"
			if("bread")
				name = "bread"
				icon_state = "meatbread"

	attack_self()
		dtype = input("Select a dough type.","Your Dough",
		dtype) in list("burger","soup", "donut", "cake", "bread")
		update_icon()

/obj/machinery/microwave/proc/cook()
	start()
	if(locate(/obj/item/weapon/reagent_containers/food/dough) in contents)
		var/with = " with "
		var/obj/item/weapon/reagent_containers/food/dough/DOUGH
		for(var/obj/item/weapon/reagent_containers/food/dough/D in contents)
			DOUGH = D
		for(var/obj/item/weapon/reagent_containers/food/F in contents)
			if(!istype(F, /obj/item/weapon/reagent_containers/food/dough))
				F.reagents.trans_to(DOUGH, F.reagents.total_volume, 1, 1)
				if(with == " with ")
					with += F.name + " "
				else
					with += "and " + F.name + " "
				del(F)
		if(with != " with ")
			DOUGH.name += with
		wzhzhzh(5)
		stop()
	else
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