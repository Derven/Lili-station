/obj/machinery/emitter
	name = "Emitter"
	desc = "A heavy duty industrial laser"
	icon = 'stationobjs.dmi'
	icon_state = "emitter"
	anchored = 0
	density = 1

	use_power = 1
	idle_power_usage = 10
	active_power_usage = 300

	var
		active = 0
		fire_delay = 100
		last_shot = 0
		shot_number = 0
		state = 0
		locked = 0


	verb/rotate()
		set name = "Rotate"
		set category = "Object"
		set src in oview(1)

		if (src.anchored || usr:stat)
			usr << "It is fastened to the floor!"
			return 0
		src.dir = turn(src.dir, 90)
		return 1


	New()
		..()
		return


	update_icon()
		if (active && !(stat & (NOPOWER|BROKEN)))
			icon_state = "emitter_+a"
		else
			icon_state = "emitter"


	attack_hand(mob/user as mob)
		if(!src.locked || istype(user, /mob))
			if(src.active==1)
				src.active = 0
				user << "You turn off the [src]."
				src.use_power = 1
			else
				src.active = 1
				user << "You turn on the [src]."
				src.shot_number = 0
				src.fire_delay = 100
				src.use_power = 2
		else
			user << "The controls are locked!"
			return 1

	process()
		if(stat & (NOPOWER|BROKEN))
			return
		if(((src.last_shot + src.fire_delay) <= world.time) && (src.active == 1))
			src.last_shot = world.time
			if(src.shot_number < 3)
				src.fire_delay = 2
				src.shot_number ++
			else
				src.fire_delay = rand(20,100)
				src.shot_number = 0
			var/obj/item/projectile/beam/A = new /obj/item/projectile/beam( src.loc )
			A.icon_state = "emitter"
			A.dir = src.dir
			if(src.dir == 1)//Up
				A.yo = 20
				A.xo = 0
			else if(src.dir == 2)//Down
				A.yo = -20
				A.xo = 0
			else if(src.dir == 4)//Right
				A.yo = 0
				A.xo = 20
			else if(src.dir == 8)//Left
				A.yo = 0
				A.xo = -20
			else // Any other
				A.yo = -20
				A.xo = 0
			A.process()