/*
		for (var/type in (typesof(/datum/recipe)-/datum/recipe))
			available_recipes+= new type
*/
var/global/list/datum/recipe/available_recipes = list() // List of the recipes you can use

/proc/init_craft()
	for (var/xtype in (typesof(/datum/crecipe)-/datum/crecipe))
		available_recipes += new xtype

/datum/crecipe
	var/desc = "recipe - ; tools -; stacks -"
	var/list/tools // example: =list(/obj/item/weapon/crowbar, /obj/item/weapon/welder) // place /foo/bar before /foo
	var/list/materials // example: =list(/obj/item/weapon/crowbar, /obj/item/weapon/welder) // place /foo/bar before /foo
	var/result //example: = /obj/item/weapon/reagent_containers/food/snacks/donut/normal
	var/time = 100 // 1/10 part of second

/datum/crecipe/proc/check_things(var/list/things, var/list/turf/turfs) //1=precisely, 0=insufficiently, -1=superfluous
	if (!things)
		//if (locate(/obj/) in turfs)
		//	return -1
		//else
		return 0
	. = 1
	var/list/checklist = things.Copy()
	for (var/turf/T in turfs)
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
	if(check_things(tools, turfs) == 1)
		if(check_things(materials, turfs) == 1)
			if(do_after(user,time))
				for(var/mob/M in range(5, src))
					M << 'ding.ogg'
					M << "<font size='3' color='#696969'>[user] create something!</font>"
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