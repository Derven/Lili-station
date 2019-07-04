/obj/structure/closet
	name = "closet"
	desc = "It's a closet!"
	icon = 'closet.dmi'
	price = 25
	icon_state = "closed"
	rotatable = 1
	pixelzheight = 32
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

	New()
		..()
		contents += new /obj/item/weapon/crowbar()

	materials
		New()
			..()
			new /obj/item/stack/metal(src)
			new /obj/item/stack/metal(src)
			new /obj/item/stack/metal(src)
			new /obj/item/stack/metal(src)
			new /obj/item/stack/metal(src)
			new /obj/item/stack/metal(src)
			new /obj/item/stack/glass(src)
			new /obj/item/stack/glass(src)
			new /obj/item/stack/glass(src)
			new /obj/item/stack/glass(src)
			new /obj/item/stack/glass(src)
			new /obj/item/stack/tile(src)
			new /obj/item/stack/tile(src)
			new /obj/item/stack/tile(src)
			new /obj/item/stack/tile(src)
			new /obj/item/stack/tile(src)
			new /obj/item/stack/table_parts(src)
			new /obj/item/stack/table_parts(src)
			new /obj/item/stack/table_parts(src)
			new /obj/item/stack/table_parts(src)

	mining
		name = "ore crate"
		icon_state = "mining"
		icon_closed = "mining"
		icon_opened = "mining_open"

	attackby(obj/item/weapon/W as obj, mob/simulated/living/humanoid/user as mob)
		if(istype(W, /obj/item/weapon/wrench))
			usr << "Вы разбираете шкаф..."
			if(do_after(usr, 5))
				deconstruct()
			return

		user.drop_item(src)
		return

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
	for(var/mob/M in range(5, src))
		M.playsoundforme('bin_open.ogg')
	if(src.opened)
		return 0

	if(!src.can_open())
		return 0

	src.dump_contents()

	src.icon_state = src.icon_opened
	src.opened = 1
	////playsound(src.loc, 'click.ogg', 15, 1, -3)
	density = 0
	return 1

/obj/structure/closet/proc/close()
	for(var/mob/M in range(5, src))
		M.playsoundforme('bin_open.ogg')
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
	////playsound(src.loc, 'click.ogg', 15, 1, -3)
	density = 1
	return 1

/obj/structure/closet/oldcloset
	name = "wooden cabinet"
	icon_state = "oldcloset"
	density = 1
	icon_closed = "oldcloset"
	icon_opened = "oldcloset_open"

/obj/structure/closet/proc/toggle()
	if(src.opened)
		return src.close()
	return src.open()

/obj/structure/closet/attack_hand(mob/user as mob)
	if(!src.toggle())
		usr << "\blue It won't budge!"

/obj/structure/closet
	wall_closet
		anchored = 1
		density = 0
		name = "wall cabinet"
		desc = "It's a wall-mounted cabinet."
		icon = 'closet.dmi'
		icon_state = "wall_cabinet"
		icon_closed = "wall_cabinet"
		icon_opened = "wall_cabinet_open"

	fire_closet
		anchored = 1
		density = 0
		name = "wall cabinet"
		desc = "It's a wall-mounted cabinet."
		icon = 'closet.dmi'
		icon_state = "fire_cabinet"
		icon_closed = "fire_cabinet"
		icon_opened = "fire_cabinet_open"

		New()
			..()
			new /obj/item/weapon/fire_ext(src)

/obj/structure/closet
	closet_3
		anchored = 1
		name = "shelving"
		desc = "It's a sturdy metal shelf."
		icon = 'closet.dmi'
		icon_state = "polka_0"


		proc/upd_closet()
			if(contents.len == 0)
				icon_state = "polka_0"
			if(contents.len > 0)
				icon_state = "polka_1"

		attack_hand()
			return

		attackby(var/obj/item/I, mob/simulated/living/humanoid/user as mob)
			user.drop_item(src)
			I.Move(src)
			icon_state = "polka_1"

/obj/structure/closet
	books
		anchored = 1
		name = "bookshelf"
		desc = "It's a wooden bookshelf."
		icon = 'closet.dmi'
		icon_state = "books1"


		proc/upd_closet()
			if(contents.len == 0)
				icon_state = "books2"
			if(contents.len > 0)
				icon_state = "books1"

		attack_hand()
			return

		attackby(var/obj/item/I, mob/simulated/living/humanoid/user as mob)
			user.drop_item(src)
			I.Move(src)
			icon_state = "books1"

/obj/structure/closet

	fridge
		icon = 'fridge.dmi'
		name = "refridgerator"

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

		morgue
			icon = 'closet.dmi'
			name = "morgue"
			icon_state = "morgue"
			icon_opened = "morgue_open"
			icon_closed = "morgue"
			pixel_z = 2
			anchored = 1

			New()
				..()

			close()
				src.icon_closed = "morgue"
				for(var/mob/M in range(5, src))
					M.playsoundforme('bin_open.ogg')
				if(!src.opened)
					return 0
				if(!src.can_close())
					return 0

				for(var/obj/item/I in src.loc)
					if(!I.anchored)
						I.loc = src

				for(var/mob/M in src.loc)
					src.icon_closed = "morgue_full"
					if(M.client)
						M.client.perspective = EYE_PERSPECTIVE
						M.client.eye = src


					M.loc = src

				src.icon_state = src.icon_closed
				src.opened = 0
				////playsound(src.loc, 'click.ogg', 15, 1, -3)
				density = 1
				return 1

/obj/structure/closet
	medcloset
		name = "medical closet"
		desc = "It's a closet for medical supplies."
		icon = 'closet.dmi'
		icon_state = "med_closed"
		icon_closed = "med_closed"
		icon_opened = "med_open"

	sec
		name = "security closet"
		desc = "It's a closet for the storage of security equipment."
		icon = 'closet.dmi'
		icon_state = "sec_closed"
		icon_closed = "sec_closed"
		icon_opened = "sec_open"

		New()
			..()
			new /obj/item/clothing/helmet/sec_cap(src)
			new /obj/item/weapon/gun/energy/laser/taser(src)
			new /obj/item/weapon/stunbaton(src)
			new /obj/item/weapon/flasher(src)
			new /obj/item/weapon/handcuffs(src)
			new /obj/item/weapon/handcuffs(src)

	eng
		name = "engineering closet"
		desc = "It's a closet for the storage of engenireeng equipment."
		icon = 'closet.dmi'
		icon_state = "eng_closed"
		icon_closed = "eng_closed"
		icon_opened = "eng_open"

	oxygen
		name = "closet"
		desc = "It's a closet!"
		icon_state = "oxygen"
		icon_closed = "oxygen"
		icon_opened = "oxygen_open"

		New()
			..()
			new /obj/item/clothing/suit/NTspace(src)

	crate
		climbcan = 1
		name = "crate"
		desc = "It's a crate!"
		icon_state = "crate"
		icon_closed = "crate"
		icon_opened = "crate_open"

		shaft
			New()
				..()
				new /obj/item/clothing/suit/soviet(src)
				new /obj/item/clothing/suit/soviet(src)
				new /obj/item/clothing/suit/soviet(src)

		coffin
			name = "coffin"
			desc = "It's a coffin!"
			icon_state = "coffin"
			icon_closed = "coffin"
			icon_opened = "coffin_open"

	oxycrate
		name = "blue crate"
		icon_state = "crate_oxygen"
		icon_closed = "crate_oxygen"
		icon_opened = "crate_open"

		New()
			..()
			new /obj/item/clothing/suit/NTspace(src)

	hydcrate
		name = "green crate"
		icon_state = "crate_hydro"
		icon_closed = "crate_hydro"
		icon_opened = "crate_open"
