/obj/structure/closet
	name = "Closet"
	desc = "It's a closet!"
	icon = 'closet.dmi'
	icon_state = "closed"
	density = 1
	var/icon_closed = "closed"
	var/icon_opened = "open"
	var/opened = 0
	var/welded = 0
	var/wall_mounted = 0 //never solid (You can always pass over it)
	flags = FPRINT
	var/health = 100
	var/lastbang
	parts = /obj/item/wood

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/wrench))
			brat << "Вы разбираете шкаф..."
			if(do_after(brat, 5))
				deconstruct()
			return

		usr.drop_item(src)
		return

	closet_2
		anchored = 1
		name = "Closet"
		desc = "It's a closet!"
		icon = 'closet.dmi'
		icon_state = "closed1"

	fridge
		icon = 'fridge.dmi'

		New()
			..()
			new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
			new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
			new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
			new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
			new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
			new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
			new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
			new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
			new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
			new /obj/item/weapon/reagent_containers/food/snacks/flour(src)

	closet_3
		anchored = 1
		name = "Closet"
		desc = "It's a closet!"
		icon = 'closet.dmi'
		icon_state = "polka_0"

		proc/upd_closet()
			if(contents.len == 0)
				icon_state = "polka_0"
			if(contents.len > 0)
				icon_state = "polka_1"

		attack_hand()
			return

		attackby(var/obj/item/I)
			usr.drop_item(src)
			I.Move(src)
			icon_state = "polka_1"

		food_closet
			icon_state = "polka_1"

			New()
				..()
				new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
				new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
				new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
				new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
				new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
				new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
				new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
				new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
				new /obj/item/weapon/reagent_containers/food/snacks/flour(src)
				new /obj/item/weapon/reagent_containers/food/snacks/flour(src)

/obj/structure/closet/proc/can_open()
	if(src.welded)
		return 0
	return 1

/obj/structure/closet/proc/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src)
			return 0
	return 1

/obj/structure/closet/proc/dump_contents()
	for(var/obj/item/I in src)
		I.loc = src.loc

	for(var/mob/M in src)
		M.loc = src.loc
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/proc/open()
	if(src.opened)
		return 0

	if(!src.can_open())
		return 0

	src.dump_contents()

	src.icon_state = src.icon_opened
	src.opened = 1
	//playsound(src.loc, 'click.ogg', 15, 1, -3)
	density = 0
	return 1

/obj/structure/closet/proc/close()
	if(!src.opened)
		return 0
	if(!src.can_close())
		return 0

	for(var/obj/item/I in src.loc)
		if(!I.anchored)
			I.loc = src

	for(var/mob/M in src.loc)
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src

		M.loc = src
	src.icon_state = src.icon_closed
	src.opened = 0
	//playsound(src.loc, 'click.ogg', 15, 1, -3)
	density = 1
	return 1

/obj/structure/closet/proc/toggle()
	if(src.opened)
		return src.close()
	return src.open()

/obj/structure/closet/attack_hand(mob/user as mob)
	if(!src.toggle())
		usr << "\blue It won't budge!"
