/mob/simulated/living/humanoid
	var/parasite_control = 0
	var/image/zombie_overlay

/mob/simulated/living/parasite
	icon = 'parasite.dmi'
	icon_state = "parasit_basic"
	name = "parasite"
	var/power = 0
	var/stage = 0
	var/atom/movable/TODEL

	death()
		death = 1
		src << "\red You are dead"
		icon_state = "parasit_basic_death"
		if(client)
			client.screen.Cut()
		//STOP_PROCESSING(SSmobs, src)
		if(istype(src, /mob/simulated/living/humanoid))
			var/mob/simulated/living/humanoid/H = src
			H.rest()
		var/mob/ghost/zhmur = new()
		zhmur.key = key
		if(client)
			Login()
		zhmur.loc = loc
		return

	Stat()
		stat("biopower",power)

	attack_hand()
		death()

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		death()

	verb/penetrate()
		set category = "Parasite"
		set src = usr
		if(istype(src.loc, /turf))
			for(var/mob/simulated/living/humanoid/human/H in range(2,src))
				if(H.death == 0)
					src.loc = H
				return
			for(var/mob/simulated/living/monkey/MK in range(2,src))
				src.loc = MK
				return
			for(var/obj/critter/mouse/M in range(2,src))
				src.loc = M
				return

	verb/say()
		set category = "Parasite"
		set src = usr
		switch(src.loc.type)
			if(/mob/simulated/living/humanoid/human)
				if(power >= 5)
					power -= 5
					var/mob/simulated/living/humanoid/human/HUMAN = src.loc
					var/texttosay = ""
					texttosay = input("What do you want to say?",
					"say",texttosay)
					HUMAN.Say(texttosay)
					return
			if(/mob/simulated/living/monkey)
				return
			if(/obj/critter/mouse)
				return

	verb/evolve()
		set category = "Parasite"
		set src = usr
		switch(stage)
			if(0)
				if(power > 50)
					if(!istype(src, /mob/simulated/living/parasite/queen_larva))
						var/evolve = ""
						evolve = input("Choose a way.",
						"humanoid/queen",evolve) in list("humanoid", "queen")
						switch(evolve)
							/*if("hunter")
								var/mob/simulated/living/parasite/hunter_larva/P = new /mob/simulated/living/parasite/hunter_larva()
								P.key = key
								if(client)
									Login()
								P.loc = loc
								del(src)*/
							if("humanoid")
								var/mob/simulated/living/humanoid/parasite/P = new /mob/simulated/living/humanoid/parasite()
								P.key = key
								if(client)
									Login()
								if(istype(src.loc, /mob/simulated/living/humanoid))
									var/mob/simulated/living/humanoid/H = src.loc
									P.loc = H.loc
									P.create_hud(client)
									H.gib()
								else
									P.loc = loc
									del(src)
							if("queen")
								var/mob/simulated/living/parasite/queen_larva/P = new /mob/simulated/living/parasite/queen_larva()
								P.key = key
								if(client)
									Login()
								P.loc = loc
								del(src)

	proc/exit()
		if(!istype(src.loc, /turf))
			loc = src.loc.loc

	verb/eject()
		set category = "Parasite"
		set src = usr
		exit()

	process()
		if(TODEL)
			del(TODEL)
		switch(src.loc.type)
			if(/mob/simulated/living/humanoid/human)
				power += 1
				var/mob/simulated/living/humanoid/human/HUMAN = src.loc
				HUMAN.bodytemperature += rand(1, 2)
				if(prob(40))
					HUMAN.heart.brute_dam += 1
					HUMAN.parasite_control += 1
				if(HUMAN.parasite_control > 100)
					src.loc = HUMAN.loc
					HUMAN.death()
					if(HUMAN.gender == "male")
						HUMAN.zombie_overlay = image(icon = 'parasite.dmi', icon_state = "zombie_mob_overlay", layer = 22)
					else
						HUMAN.zombie_overlay = image(icon = 'parasite.dmi', icon_state = "zombie_fem_overlay", layer = 22)
					HUMAN.overlays += HUMAN.zombie_overlay
					addai(HUMAN, /datum/AI/hunter/zombie)
			if(/mob/simulated/living/monkey)
				return
			if(/obj/critter/mouse)
				power += 0.5
				var/obj/critter/MOICE = src.loc
				MOICE.health -= 0.1
				if(MOICE.health <= 0.3)
					TODEL = MOICE
					exit()
					new /obj/blood(MOICE.loc)

/mob/simulated/living/parasite/hunter_larva
/
mob/simulated/living/humanoid/parasite
	icon = 'parasite.dmi'
	icon_state = "parasite_humanoid"

	New(var/turf/T)
		..()
		sleep(2)
		START_PROCESSING(SSmobs, src)
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

/mob/simulated/living/parasite/queen_larva
	verb/egg_plant()
		set src = usr
		if(istype(src.loc, /turf))
			if(power > 10)
				power -= 10
				new /obj/item/parasite_egg(src.loc)

/obj/item/parasite_egg
	icon = 'parasite.dmi'
	icon_state = "p_egg"

	Crossed(atom/movable/O)
		var/success = ""
		if(istype(O, /mob/ghost))
			success = input("Want to become a parasite?.",
			"Yes/No",success) in list("yes","no")
			if(success && src)
				var/mob/simulated/living/parasite/P = new /mob/simulated/living/parasite()
				P.key = O:key
				if(O:client)
					O:Login()
				P.loc = loc
				del(src)