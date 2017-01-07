/obj/item/weapon/cable_coil
	name = "cable coil"
	icon = 'power.dmi'
	icon_state = "coil_red"
	var/amount = 15
	var/color_hyalor = "red"
	desc = "A coil of power cable."
	flags = TABLEPASS|USEDELAY|FPRINT|CONDUCT

/obj/item/weapon/cable_coil/New(loc, length = 15, var/param_color_hyalor = null)
	..()
	src.amount = length
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)

/obj/item/weapon/cable_coil/cut/New(loc)
	..()
	src.amount = rand(1,2)
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)

/obj/item/weapon/cable_coil/examine()
	set src in view(1)

	if(amount == 1)
		usr << "A short piece of power cable."
	else if(amount == 2)
		usr << "A piece of power cable."
	else
		usr << "A coil of power cable. There are [amount] lengths of cable in the coil."

/obj/item/weapon/cable_coil/attackby(obj/item/weapon/W, mob/usr)
	..()
	if( istype(W, /obj/item/weapon/wirecutters) && src.amount > 1)
		src.amount--
		new/obj/item/weapon/cable_coil(usr.loc, 1)
		usr << "You cut a piece off the cable coil."
		return

	else if( istype(W, /obj/item/weapon/cable_coil) )
		var/obj/item/weapon/cable_coil/C = W
		if(C.amount == 15)
			usr << "The coil is too long, you cannot add any more cable to it."
			return

		if( (C.amount + src.amount <= 15) )
			C.amount += src.amount
			usr << "You join the cable coils together."
			del(src)
			return

		else
			usr << "You transfer [15 - src.amount ] length\s of cable from one coil to the other."
			src.amount -= (15-C.amount)
			C.amount = 15
			return

/obj/item/weapon/cable_coil/proc/use(var/used)
	if(src.amount < used)
		return 0
	else if (src.amount == used)
		del(src)
	else
		amount -= used
		return 1

// called when cable_coil is clicked on a turf/simulated/floor

/obj/item/weapon/cable_coil/proc/turf_place(turf/simulated/floor/F, mob/usr)

	if(!isturf(usr.loc))
		return

	if(get_dist(F,usr) > 1)
		usr << "You can't lay cable at a place that far away."
		return

	if(F.intact)		// if floor is intact, complain
		usr << "You can't lay cable there unless the floor tiles are removed."
		return

	else
		var/dirn

		if(usr.loc == F)
			dirn = usr.dir			// if laying on the tile we're on, lay in the direction we're facing
		else
			dirn = get_dir(F, usr)

		for(var/obj/structure/cable/LC in F)
			if((LC.d1 == dirn && LC.d2 == 0 ) || ( LC.d2 == dirn && LC.d1 == 0))
				usr << "There's already a cable at that position."
				return

		var/obj/structure/cable/C = new(F)

		C.d1 = 0
		C.d2 = dirn

		var/datum/powernet/PN = new()
		PN.number = powernets.len + 1
		powernets += PN
		C.netnum = PN.number
		PN.cables += C

		C.mergeConnectedNetworks(C.d2)
		C.mergeConnectedNetworksOnTurf()


		use(1)
		//src.laying = 1
		//last = C


// called when cable_coil is click on an installed obj/cable

/obj/item/weapon/cable_coil/proc/cable_join(obj/structure/cable/C, mob/usr)

	var/turf/U = usr.loc
	if(!isturf(U))
		return

	var/turf/T = C.loc

	if(!isturf(T) || T.intact)		// sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if(get_dist(C, usr) > 1)		// make sure it's close enough
		usr << "You can't lay cable at a place that far away."
		return


	if(U == T)		// do nothing if we clicked a cable we're standing on
		return		// may change later if can think of something logical to do

	var/dirn = get_dir(C, usr)

	if(C.d1 == dirn || C.d2 == dirn)		// one end of the clicked cable is pointing towards us
		if(U.intact)						// can't place a cable if the floor is complete
			usr << "You can't lay cable there unless the floor tiles are removed."
			return
		else
			// cable is pointing at us, we're standing on an open tile
			// so create a stub pointing at the clicked cable on our tile

			var/fdirn = turn(dirn, 180)		// the opposite direction

			for(var/obj/structure/cable/LC in U)		// check to make sure there's not a cable there already
				if(LC.d1 == fdirn || LC.d2 == fdirn)
					usr << "There's already a cable at that position."
					return

			var/obj/structure/cable/NC = new(U)

			NC.d1 = 0
			NC.d2 = fdirn

			NC.netnum = C.netnum
			var/datum/powernet/PN = powernets[C.netnum]
			PN.cables += NC
			NC.mergeConnectedNetworks(NC.d2)
			NC.mergeConnectedNetworksOnTurf()
			use(1)

			return
	else if(C.d1 == 0)		// exisiting cable doesn't point at our position, so see if it's a stub
							// if so, make it a full cable pointing from it's old direction to our dirn
		var/nd1 = C.d2	// these will be the new directions
		var/nd2 = dirn


		if(nd1 > nd2)		// swap directions to match icons/states
			nd1 = dirn
			nd2 = C.d2


		for(var/obj/structure/cable/LC in T)		// check to make sure there's no matching cable
			if(LC == C)			// skip the cable we're interacting with
				continue
			if((LC.d1 == nd1 && LC.d2 == nd2) || (LC.d1 == nd2 && LC.d2 == nd1) )	// make sure no cable matches either direction
				usr << "There's already a cable at that position."
				return

		C.d1 = nd1
		C.d2 = nd2

		C.mergeConnectedNetworks(C.d1)
		C.mergeConnectedNetworks(C.d2)
		C.mergeConnectedNetworksOnTurf()

		use(1)
		return