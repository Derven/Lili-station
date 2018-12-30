/obj/machinery/gibber
	name = "Gibber"
	desc = "The name isn't descriptive enough?"
	icon = 'kitchen.dmi'
	icon_state = "grinder"
	density = 1
	anchored = 1
	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/gibtime = 40 // Time from starting until meat appears
	var/mob/occupant // Mob who has been put inside

/obj/machinery/gibber/New()
	..()
	src.overlays += image('kitchen.dmi', "grindnotinuse")

/obj/machinery/gibber/relaymove(mob/user as mob)
	src.go_out()
	return

/obj/machinery/gibber/attack_hand(mob/user as mob)
	if(operating)
		user << "\red It's locked and running"
		return
	else
		src.startgibbing(user)

/obj/machinery/gibber/MouseDrop_T(mob/target, mob/user)
	if(src.occupant)
		user << "\red The gibber is full, empty it first!"
		return

	sleep(30)
	target.client.perspective = EYE_PERSPECTIVE
	target.client.eye = src
	target.loc = src
	src.occupant = target

/obj/machinery/gibber/verb/eject()
	set src in oview(1)

	if (usr.stat != 0)
		return
	src.go_out()
	return

/obj/machinery/gibber/proc/go_out()
	if (!src.occupant)
		return
	for(var/obj/O in src)
		O.loc = src.loc
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	return


/obj/machinery/gibber/proc/startgibbing(mob/simulated/living/user as mob)
	if(src.operating)
		return
	if(!src.occupant)
		return
	else
		src.operating = 1
		src.dirty += 1
		var/obj/item/weapon/reagent_containers/food/snacks/meat/newmeat1 = new /obj/item/weapon/reagent_containers/food/snacks/meat
		var/obj/item/weapon/reagent_containers/food/snacks/meat/newmeat2 = new /obj/item/weapon/reagent_containers/food/snacks/meat
		var/obj/item/weapon/reagent_containers/food/snacks/meat/newmeat3 = new /obj/item/weapon/reagent_containers/food/snacks/meat
		if (src.occupant.client)
			var/mob/simulated/living/L = src.occupant
			if(istype(L, /mob/simulated/living))
				L.loc = loc
				L.client.perspective = EDGE_PERSPECTIVE
				L.client.eye = src.occupant.client.mob
				L.death()
				del(L)

		spawn(src.gibtime)
			operating = 0
			var/turf/Tx1 = locate(src.x + 1, src.y, src.z)
			var/turf/Tx2 = locate(src.x + 2, src.y, src.z)
			var/turf/Tx3 = locate(src.x + 3, src.y, src.z)
			if(istype(Tx1, /turf/simulated/floor/)) // Make it so the blood that flies out only appears on the freezer floor
				new /obj/blood(Tx1)
				newmeat1.loc = get_turf(Tx1)
			if(istype(Tx2, /turf/simulated/floor/))
				new /obj/blood(Tx2)
				newmeat2.loc = get_turf(Tx2)
			if(istype(Tx3, /turf/simulated/floor/))
				new /obj/blood(Tx3)
				newmeat3.loc = get_turf(Tx3)
			if(src.dirty == 1)
				src.overlays += image('kitchen.dmi', "grindbloody")
		src.operating = 0


