

obj/Lamp
	icon = 'Lamp.dmi'
	animate_movement = SYNC_STEPS
	layer = LAYER_LAMP
	mouse_opacity = 2
	name = ""
	step_size = 1

	var
		Light/light
		mob/owner
		moving = FALSE
		velocity = 0

	New()
		if(!light)
			light = new/Light()
		light.SetPosition(src)

	Click(location,control,params)
		params = params2list(params)
		if(params["right"])
			var/c = input(usr, "Select light color") as null|color
			color = c
			light.SetColor(c)
		else
			if(owner == usr)
				owner.lamp = null
				owner = null
			else
				if (usr.lamp)
					usr.lamp.owner = null
				owner = usr
				owner.lamp = src
				SetPosition(usr)

	proc/SetPosition(atom/movable/A)
		loc = A.loc
		step_x = A.step_x
		step_y = A.step_y
		light.SetPosition(src)
		velocity = 0

	MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
		var/turf/target
		if(isturf(over_object)) target = over_object
		else if(istype(over_object, /atom/movable) && isturf(over_object:loc)) target = over_object:loc
		if(target && isturf(src_location))
			var/turf/start = src_location
			velocity = get_dist(start, target)
			dir = get_dir(start, target)
			if(!moving) MovementLoop()

	proc/MovementLoop()
		if(moving) return
		moving = TRUE
		spawn()
			var/success = TRUE
			while(loc && success && velocity)
				density = 1
				success = step(src, dir, velocity)
				density = 0
				light.SetPosition(src)
				sleep(world.tick_lag)
			moving = FALSE

	Directional
		New()
			light = new/Light/DirectionalLight()
			..()