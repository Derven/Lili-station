//old style retardo-cart
/obj/structure/stool/chair/janicart
	name = "janicart"
	icon = 'venicles.dmi'
	icon_state = "pussywagon"
	anchored = 1
	density = 0
	//copypaste sorry
	var/amount_per_transfer_from_this = 5 //shit I dunno, adding this so syringes stop runtime erroring. --NeoFite
	var/callme = "pimpin' ride"	//how do people refer to it?
	speed = 3

	manual_unbuckle_all(mob/user as mob)
		var/N = 0;
		for(var/mob/M in buckled_mobs)
			if (M.buckled == src)
				if (M != user)
					M << "\blue You unbuckled from [src] by [user.name]."
				else
					user << "\blue You unbuckle yourself from [src]."
	//			world << "[M] is no longer buckled to [src]"
				usr.playsoundforme('handcuffs.ogg')
				M.anchored = 0
				M:onstructure = 1
				M.buckled = null
				buckled_mobs -= M
				N++
		overlays.Cut()
		usr.pixel_z = initial(usr.pixel_z)
		return N

	buckle_mob(mob/M as mob, mob/user as mob)
		if ((!( istype(M, /mob) ) || get_dist(src, user) > 1 || M.loc != src.loc || usr.stat || M.buckled))
			return
		if (M == usr)
			usr << "\blue You buckle yourself"
			usr << "\red Hint: Driving a car with the middle or right mouse button. Pressing the forward arrow is equal to the gas accelerator."
		else
			usr << "\blue [M] buckled by [usr]"
			usr << "\red Hint: Driving a car with the middle or right mouse button. Pressing the forward arrow is equal to the gas accelerator."
		overlays += image(src.icon,icon_state = "jani_overlay",layer = 18)
		usr.pixel_z = 16
		usr:onstructure = 1
		usr.playsoundforme('handcuffs.ogg')
		M.anchored = 1
		M.buckled = src
		M.loc = src.loc
		M.dir = src.dir
		buckled_mobs += M


/obj/structure/stool/chair/janicart/relaymove(mob/user, direction)
	if(user.stunned || user.weakened || user.paralysis)
		manual_unbuckle_all(user)
	else
		anchored = 0
		step(src,user.dir)
		anchored = 1
		update_mob()

/obj/structure/stool/chair/janicart/Move()
	. = ..()
	for(var/obj/blood/B in view(2, src))
		del(B)
	for(var/obj/dirt/D in view(2, src))
		del(D)
	if(buckled_mobs)
		for(var/mob/M in buckled_mobs)
			M.loc = src.loc
	update_mob()

/obj/structure/stool/chair/janicart/proc/update_mob()
	..()