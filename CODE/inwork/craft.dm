

/proc/init_craft()
	var/list/datum/recipe/available_recipes2 = list() // List of the recipes you can use
	var/list/superlist = subtypesof(/datum/crecipe)
	for (var/xtype in superlist)
		available_recipes2 += new xtype
	return available_recipes2

/datum/crecipe
	var/desc = "recipe - ; tools -; stacks -"
	var/list/tools // example: =list(/obj/item/weapon/crowbar, /obj/item/weapon/welder) // place /foo/bar before /foo
	var/list/materials // example: =list(/obj/item/weapon/crowbar, /obj/item/weapon/welder) // place /foo/bar before /foo
	var/result //example: = /obj/item/weapon/reagent_containers/food/snacks/donut/normal
	var/time = 100 // 1/10 part of second

/datum/crecipe/spare
	desc = "recipe - spare; tools - wirecutters; stacks - metal, glass"
	tools = list(/obj/item/weapon/wirecutters) // example: =list(/obj/item/weapon/crowbar, /obj/item/weapon/welder) // place /foo/bar before /foo
	materials = list(/obj/item/stack/glass, /obj/item/stack/metal)// example: =list(/obj/item/weapon/crowbar, /obj/item/weapon/welder) // place /foo/bar before /foo
	result = /obj/item/weapon/spare //example: = /obj/item/weapon/reagent_containers/food/snacks/donut/normal
	time = 100 // 1/10 part of second

/datum/crecipe/flamethrower
	desc = "recipe - flamethrower; tools - wrench; stacks - weldingtool, tank"
	tools = list(/obj/item/weapon/wrench) // example: =list(/obj/item/weapon/crowbar, /obj/item/weapon/welder) // place /foo/bar before /foo
	materials = list(/obj/item/weapon/weldingtool, /obj/item/weapon/tank)// example: =list(/obj/item/weapon/crowbar, /obj/item/weapon/welder) // place /foo/bar before /foo
	result = /obj/item/weapon/weldingtool/flamethrower //example: = /obj/item/weapon/reagent_containers/food/snacks/donut/normal
	time = 50 // 1/10 part of second

/datum/crecipe/proc/check_things(var/list/things, var/list/atom/turfs) //1=precisely, 0=insufficiently, -1=superfluous
	if (!things)
		//if (locate(/obj/) in turfs)
		//	return -1
		//else
		return 0
	. = 1
	var/list/checklist = things.Copy()
	for (var/atom/T in turfs)
		for (var/obj/O in T)
			var/found = 0
			for (var/type in checklist)
				if (istype(O,type))
					checklist-=type
					found = 1
					break
			if (!found)
				. = -1
	if (checklist.len)
		return 0
	return 1

/datum/crecipe/proc/check_recipe(var/mob/user)
	var/list/turf/turfs = list()
	for(var/turf/T in range(1, user.loc))
		turfs.Add(T)
	turfs.Add(user)
	if(check_things(tools, turfs) == 1)
		turfs.Remove(user)
		if(check_things(materials, turfs) == 1)
			for(var/mob/M in range(5, user.loc))
				M << "\red [user] trying to create something...</font>"
			user << "\red nedeed time: [time] sec"
			user << "\red please await..."
			if(do_after(user,time))
				for(var/mob/M in range(5, user.loc))
					M << 'ding.ogg'
					M << "\blue [user] create something!</font>"
				make(user.loc, turfs)

//general version
/datum/crecipe/proc/make(var/turf/iturf as turf, var/list/turf/turfs)
	for(var/turf/T in turfs)
		for (var/obj/O in T)
			for (var/itype in materials)
				if(istype(O, itype))
					materials.Remove(itype)
					del(O)
	materials = initial(materials)
	var/obj/result_obj = new result(iturf)
	return result_obj