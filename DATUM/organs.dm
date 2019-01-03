#define NOSLOTS 911

/datum/organ/external/chest
	name = "chest"
	icon_name = "chest"
	max_damage = 150
	body_part = UPPER_TORSO
	blood_flow = 15

/datum/organ/external/groin
	name = "groin"
	icon_name = "groin"
	body_part = LOWER_TORSO
	blood_flow = 10

/datum/organ/external/head
	name = "head"
	icon_name = "head"
	max_damage = 125
	body_part = HEAD
	blood_flow = 15

/datum/organ/external/arm/l_arm
	name = "l_arm"
	icon_name = "l_arm"
	max_damage = 75
	body_part = ARM_LEFT
	blood_flow = 5
	HUD = null
	HUDTYPE = /obj/hud/l_hand

/datum/organ/external/leg/l_leg
	name = "l_leg"
	icon_name = "l_leg"
	max_damage = 75
	body_part = LEG_LEFT
	blood_flow = 5

/datum/organ/external/arm/r_arm
	name = "r_arm"
	icon_name = "r_arm"
	max_damage = 75
	body_part = ARM_RIGHT
	blood_flow = 5
	HUD = null
	HUDTYPE = /obj/hud/r_hand

/datum/organ/external/leg/r_leg
	name = "r_leg"
	icon_name = "r_leg"
	max_damage = 75
	body_part = LEG_RIGHT
	blood_flow = 5

proc/isorgan(A)
	if(istype(A, /datum/organ/external))
		return 1
	return 0

/datum/organ
	var
		name = "organ"
		owner = null


	process()
		return 0

	proc/receive_chem(chemical as obj)
		return 0



/****************************************************
				EXTERNAL ORGANS
****************************************************/
/datum/organ/external
	name = "external"
	var
		icon_name = null
		body_part = null

		damage_state = "00"
		brute_dam = 0
		burn_dam = 0
		bandaged = 0
		max_damage = 0
		wound_size = 0
		max_size = 0
		blood_flow = 10
	var/client/CLIENT
	var/obj/hud/HUD = NOSLOTS
	var/HUDTYPE = /obj/hud

	proc/create_hud(var/client/C)
		..()
		if(C)
			CLIENT = C
			update_hud(C)
		else
			return

	proc/update_hud(var/client/C)
		if(HUD != NOSLOTS)
			if(!HUD)
				HUD = new HUDTYPE(src)
			C.screen.Add(HUD)
		return

	proc/blood_flow(var/mob/simulated/living/L)
		if(brute_dam > 80)
			L.reagents.remove_reagent("blood", blood_flow + L.heart.pumppower / 10)
			L << "You have the blood loss"
			new /obj/blood(L.loc)

	proc/take_damage(brute, burn)
		if((brute <= 0) && (burn <= 0))	return 0
		if((src.brute_dam + src.burn_dam + brute + burn) < src.max_damage)
			src.brute_dam += brute
			src.burn_dam += burn
		else
			var/can_inflict = src.max_damage - (src.brute_dam + src.burn_dam)
			if(can_inflict)
				if (brute > 0 && burn > 0)
					brute = can_inflict/2
					burn = can_inflict/2
					var/ratio = brute / (brute + burn)
					src.brute_dam += ratio * can_inflict
					src.burn_dam += (1 - ratio) * can_inflict
				else
					if (brute > 0)
						brute = can_inflict
						src.brute_dam += brute
					else
						burn = can_inflict
						src.burn_dam += burn
			else
				return 0

		var/result = src.update_icon()
		return result


	proc/heal_damage(brute, burn)
		src.brute_dam = max(0, src.brute_dam - brute)
		src.burn_dam = max(0, src.burn_dam - burn)
		return update_icon()


	proc/get_damage()	//returns total damage
		return src.brute_dam + src.burn_dam	//could use src.health?

	proc/get_brute()	//returns total damage
		return src.brute_dam	//could use src.health?

	proc/get_burn()	//returns total damage
		return src.burn_dam	//could use src.health?


// new damage icon system
// returns just the brute/burn damage code
	proc/damage_state_text()
		var/tburn = 0
		var/tbrute = 0

		if(burn_dam ==0)
			tburn =0
		else if (src.burn_dam < (src.max_damage * 0.25 / 2))
			tburn = 1
		else if (src.burn_dam < (src.max_damage * 0.75 / 2))
			tburn = 2
		else
			tburn = 3

		if (src.brute_dam == 0)
			tbrute = 0
		else if (src.brute_dam < (src.max_damage * 0.25 / 2))
			tbrute = 1
		else if (src.brute_dam < (src.max_damage * 0.75 / 2))
			tbrute = 2
		else
			tbrute = 3
		return "[tbrute][tburn]"


// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
	proc/update_icon()
		var/n_is = src.damage_state_text()
		if (n_is != src.damage_state)
			src.damage_state = n_is
			return 1
		return 0



/****************************************************
				INTERNAL ORGANS
****************************************************/
/datum/organ/internal
	name = "internal"
	var
		icon_name = null
		body_part = null

		damage_state = "00"
		brute_dam = 0
		burn_dam = 0
		max_damage = 0

	proc
		my_func()
		pain_internal()

	lungs
		name = "lungs"
		max_damage = 120

		my_func()
			if(brute_dam + burn_dam < max_damage)
				return brute_dam + burn_dam
			else
				del(src)

	heart
		name = "heart"
		max_damage = 100
		var/pumppower = 100
		var/list/HS = list()
		var/volume

		proc/pumpupgrade()

			for(var/datum/heart_stimulators/hs in HS)
				if(hs.time_in_steps > 0)
					volume += hs.volume
					hs.time_in_steps -= 1
				else
					volume -= hs.volume
					HS.Remove(hs)
					del(hs)

			pumppower += volume

		pain_internal()
			switch(brute_dam + burn_dam)
				if (5 to 25)
					return "<b>You feel sharp pain in your chest.</b>"
				if (25 to 50)
					return "<b><font size=1>Ouch! Your chest hurts in the left side.</b>"
				if (50 to 90)
					return "<b><font size=3>OH GOD! You feel the sharpest pain in your chest.</b>"

		my_func()
			switch(brute_dam + burn_dam)
				if (-10 to 5)
					pumppower = 100 - rand(-5,0)
				if (5 to 25)
					pumppower = 100 - rand(5,15)
				if (25 to 50)
					pumppower = 100 - rand(15,35)
				if (50 to 75)
					pumppower = 100 - rand(15,35)
				if (75 to 90)
					pumppower = 100 - rand(35,65)
				else
					pumppower = 100 - rand(65,100)

			pumpupgrade()
			switch(pumppower)
				if(150 to 175)
					brute_dam += rand(0,1)
				if(175 to 500)
					brute_dam += rand(20, 50)

		proc/activate_stimulators(var/heart_stimulators)
			var/datum/heart_stimulators/hs = new heart_stimulators (src)
			HS.Add(hs)

/datum/heart_stimulators
	//stimulators
	var/time_in_steps = 0
	var/volume = 0

	adrenalin_ephedrine
		time_in_steps = 1
		volume = 65

	caffeine
		time_in_steps = 1
		volume = 30

	light_sedative
		time_in_steps = 1
		volume = -35

	hard_sedative
		time_in_steps = 1
		volume = -60