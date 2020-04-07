/mob/simulated/living/humanoid/human/zombie
	name = "zombie"
	icon_state = "zombie"
	death = 0

/mob/simulated/living/humanoid/human/zombie/process()
	if(death == 0)
		SLOC = src.loc
		//set invisibility = 0
		//set background = 1
		var/datum/gas_mixture/environment = SLOC.return_air()
		//handle_pain()
		handle_stomach()
		handle_injury()
		handle_chemicals_in_body()
		handle_temperature(environment)
		parstunweak()
		updatehealth()
	else
		if(heart)
			heart.pumppower = 0
	myspaceisperfect()

/mob/simulated/living/humanoid/human/zombie/New()
	select_overlay = image(usr)
	overlay_cur = image('sign.dmi', icon_state = "say", layer = 10)
	overlay_cur.layer = 16
	overlay_cur.pixel_z = 5
	overlay_cur.pixel_x = -14
	usr.select_overlay.override = 1
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src

	chest = new /datum/organ/external/chest(src)
	head = new /datum/organ/external/head(src)
	l_arm = new /datum/organ/external/arm/l_arm(src)
	r_arm = new /datum/organ/external/arm/r_arm(src)
	r_leg = new /datum/organ/external/leg/r_leg(src)
	l_leg = new /datum/organ/external/leg/l_leg(src)
	groin = new /datum/organ/external/groin(src)
	lungs = new /datum/organ/internal/lungs(src)
	heart = new /datum/organ/internal/heart(src)

	chest.owner = src
	head.owner = src
	r_arm.owner = src
	l_arm.owner = src
	r_leg.owner = src
	l_leg.owner = src
	groin.owner = src
	organs += chest
	organs += head
	organs += r_arm
	organs += l_arm
	organs += r_leg
	organs += l_leg
	organs += groin

	reagents.add_reagent("blood",300)
	addai(src, /datum/AI/hunter/zombie)
	..()
