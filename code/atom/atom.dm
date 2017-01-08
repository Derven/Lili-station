#define brat usr

var/list/cardinal = list(SOUTH, NORTH, WEST, EAST, NORTHEAST, NORTHWEST, SOUTHWEST, SOUTHEAST)

/atom/movable
	layer = 3
	var/flags
	var/last_move = null
	var/anchored = 0
	// var/elevation = 2    - not used anywhere
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/throwowing = 0
	var/throwow_speed = 2
	var/throwow_range = 7
	var/moved_recently = 0

/atom/movable/overlay

/atom/proc/update_icon()

/atom/verb/examine()
	set name = "Examine"
	set category = "IC"
	set src in oview(12)	//make it work from farther away

	if (!( usr ))
		return
	usr << "This is \an [name]."
	usr << desc
	// *****RM
	//usr << "[name]: Dn:[density] dir:[dir] cont:[contents] icon:[icon] is:[icon_state] loc:[loc]"
	return

/atom
	layer = 2
	var/level = 2
	var/fingerprints = null
	var/list/fingerprintshidden = new/list()
	var/fingerprintslast = null
	var/blood_DNA = null
	var/blood_type = null
	var/last_bumped = 0
	var/pass_flags = 0

	///Chemistry.
	//var/chem_is_open_container = 0
	// replaced by OPENCONTAINER flags and atom/proc/is_open_container()
	///Chemistry.

	proc/assume_air(datum/air_group/giver)
		del(giver)
		return null

	proc/remove_air(amount)
		return null

	proc/return_air()
		if(loc)
			return loc.return_air()
		else
			return null

/atom/proc/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/device/detective_scanner))
		for(var/mob/O in viewers(src, null))
			if (O.client)
				O << text("\red [src] has been scanned by [user] with the [W]")
	else
		if (!( istype(W, /obj/item/weapon/grab) ) && !(istype(W, /obj/item/weapon/plastique)) &&!(istype(W, /obj/item/weapon/cleaner)) &&!(istype(W, /obj/item/weapon/chemsprayer)) &&!(istype(W, /obj/item/weapon/pepperspray)) && !(istype(W, /obj/item/weapon/plantbgone)) )
			for(var/mob/O in viewers(src, null))
				if (O.client)
					O << text("\red <B>[] גû בüועו [] ס ןמלמשü‏ []</B>", src, user, W)
	return