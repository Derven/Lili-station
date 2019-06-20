/obj/item/device/health_analyzer
	name = "health analyzer"
	icon = 'tools.dmi'
	icon_state = "health_analyzer"

	afterattack(atom/target, mob/user , flag)
		if(istype(target, /mob/simulated/living/humanoid) && usr.do_after(15))
			var/mob/simulated/living/humanoid/H = target
			for(var/datum/organ/O in H.organs)
				usr << "\blue [O.name]: brute [O:brute_dam]; burn [O:burn_dam]"

/obj/item/device/defib
	name = "defib"
	icon = 'tools.dmi'
	icon_state = "defib"

	afterattack(atom/target, mob/user , flag)
		if(istype(target, /mob/simulated/living/humanoid) && usr.do_after(5))
			var/mob/simulated/living/humanoid/H = target
			var/i = 0
			while(i < rand(2,5))
				i++
				H.heart.activate_stimulators(/datum/heart_stimulators/adrenalin_ephedrine)
				H.stamina = 100
				new /obj/effect/sparks(H.loc)
				sleep(rand(1,3))
				for(var/mob/B in range(6, H))
					B << ('sparks.ogg')