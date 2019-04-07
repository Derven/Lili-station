/obj/item/device/health_analyzer
	name = "health analyzer"
	icon = 'tools.dmi'
	icon_state = "health_analyzer"

	afterattack(atom/target, mob/user , flag)
		if(istype(target, /mob/simulated/living/humanoid) && usr.do_after(15))
			var/mob/simulated/living/humanoid/H = target
			for(var/datum/organ/O in H.organs)
				usr << "\blue [O.name]: brute [O:brute_dam]; burn [O:burn_dam]"