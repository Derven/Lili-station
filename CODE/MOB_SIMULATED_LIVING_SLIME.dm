// /mob/simulated/living/slime vars
//---------------------
/mob/simulated/living/slime/icon = 'slimes.dmi'
/mob/simulated/living/slime/icon_state = "baby_slime"
/mob/simulated/living/slime/var/stage = 0
/mob/simulated/living/slime/var/colortype = "gray"
/mob/simulated/living/slime/name = "slime"
/mob/simulated/living/slime/bodytemperature = 270.149963
//---------------------

// /mob/simulated/living/slime procs
//---------------------
/mob/simulated/living/slime/New()
	select_overlay = image(usr)
	overlay_cur = image('sign.dmi', icon_state = "say", layer = 10)
	overlay_cur.layer = 16
	overlay_cur.pixel_z = 5
	overlay_cur.pixel_x = -14
	usr.select_overlay.override = 1
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	reagents.add_reagent("blood",300)
	colortype = mutate()
	recolor()
	START_PROCESSING(SSmobs, src)
	addai(src, /datum/AI/hunter/slime)
	..()

/mob/simulated/living/slime/death()
	..()
	new /obj/item/weapon/reagent_containers/food/snacks/slimecore(src)
	death = 1
	src << "\red You are dead"
	if(client)
		client.screen.Cut()
	//STOP_PROCESSING(SSmobs, src)
	icon_state = "death_[icon_state]"
	var/mob/ghost/zhmur = new()
	zhmur.key = key
	if(client)
		Login()
	zhmur.loc = loc
	return

/mob/simulated/living/slime/proc/mutate()
	var/newcolortype = colortype
	switch(colortype)
		if("gray")
			if(prob(10))
				newcolortype = "blue"
				return newcolortype
			if(prob(10))
				newcolortype = "red"
				return newcolortype
			if(prob(10))
				newcolortype = "green"
				return newcolortype
		if("blue")
			if(prob(15))
				newcolortype = "black"
				return newcolortype
			if(prob(5))
				newcolortype = "violet"
				return newcolortype
		if("green")
			if(prob(20))
				newcolortype = "yellow"
				return newcolortype
			if(prob(3))
				newcolortype = "violet"
				return newcolortype
		if("red")
			if(prob(30))
				newcolortype = "yellow"
				return newcolortype
			if(prob(7))
				newcolortype = "orange"
				return newcolortype
		if("yellow")
			if(prob(10))
				newcolortype = "orange"
				return newcolortype
			if(prob(3))
				newcolortype = "brown"
				return newcolortype
			if(prob(45))
				newcolortype = "gray"
				return newcolortype
		if("violet")
			if(prob(20))
				newcolortype = "gray"
				return newcolortype
			if(prob(2))
				newcolortype = "aqua"
				return newcolortype

/mob/simulated/living/slime/proc/recolor()
	switch(colortype)
		if("gray")
			return
		if("blue")
			src.icon += rgb(0,0,170)
		if("green")
			src.icon += rgb(0,170,0)
		if("red")
			src.icon += rgb(170,0,0)
		if("yellow")
			src.icon += rgb(50,50,0)
		if("violet")
			src.icon += rgb(50,0,50)
		if("black")
			src.icon -= rgb(150,150,150)
		if("brown")
			src.icon += rgb(80,50,0)
		if("aqua")
			src.icon += rgb(10,0,70)
		if("orange")
			src.icon += rgb(50,80,0)

/mob/simulated/living/slime/proc/birth()
	if(istype(loc, /turf))
		new src.type(src.loc)
	else
		new src.type(src.loc.loc)

/mob/simulated/living/slime/proc/grow()
	switch(nutrition / (400 / 100))
		if(0 to 120)
			return
		if(120 to 150)
			if(stage == 0)
				stage = 1
				icon_state = "adult_slime"
				nutrition -= 50
		else
			nutrition -= 100
			birth()

/mob/simulated/living/slime/handle_temperature_damage(exposed_temperature, exposed_intensity)
	if(exposed_temperature > bodytemperature)
		var/discomfort = min(abs(exposed_temperature - bodytemperature)/2000, 1.0)

		//adjustFireLoss(2.5*discomfort)
		//adjustFireLoss(5.0*discomfort)
		//rand_burn_damage(20.0*discomfort, 20.0*discomfort)
		health -= 20.0*discomfort
	else
		var/discomfort = min(abs(exposed_temperature - bodytemperature)/2000, 1.0)
		//adjustFireLoss(2.5*discomfort)
		health -= 20.0*discomfort

/mob/simulated/living/slime/proc/handle_temperature(var/datum/gas_mixture/environment)
	if(environment)
		var/environment_heat_capacity = environment.heat_capacity()
		var/transfer_coefficient = 1
		var/areatemp = environment.temperature
		if(abs(areatemp - bodytemperature) > 50)
			var/diff = areatemp - bodytemperature
			diff = diff / 5
			//world << "changed from [bodytemperature] by [diff] to [bodytemperature + diff]"
			bodytemperature += diff
		if(bodytemperature < initial(bodytemperature))
			bodytemperature += rand(1, 2)
		handle_temperature_damage(environment.temperature, environment_heat_capacity*transfer_coefficient)

/mob/simulated/living/slime/proc/check_health()
	if(health <= 0)
		death()

/mob/simulated/living/slime/proc/eat(var/mob/simulated/living/M)
	if(M == loc)
		M.rand_burn_damage(5, 8)
		nutrition += rand(5,20)
		if(M.health <= 0 || M.death == 1 || M.bodytemperature < 310 - rand(5,15) || M.bodytemperature > 310 + rand(5,15))
			M.overlays -= M.slimeoverlay
			M.slimeoverlay = null
			loc = M.loc
	else
		Move(M)
		M.slimeoverlay = icon(src.icon, src.icon_state)
		M.overlays += M.slimeoverlay

/mob/simulated/living/slime/verb/debugnutrition()
	set src in range(1,usr)
	eat(usr)

/mob/simulated/living/slime/process()
	if(death == 0)
		grow()
		check_health()
		var/datum/gas_mixture/environment
		if(istype(loc, /turf))
			environment = loc:return_air()
		else
			if(istype(loc, /mob/simulated/living))
				eat(src.loc)
			environment = loc.loc:return_air()
		handle_temperature(environment)