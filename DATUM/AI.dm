/datum/AI
	var/mysay = "squeal"
	var/mob/simulated/brain
	var/aggressive

	proc/mobmovement()
	proc/seek_target()
	proc/life()
	proc/talking()

	friends_animal
		mobmovement()
			var/moveto = locate(brain.x + rand(-1,1),brain.y + rand(-1, 1),brain.z)
			if (istype(moveto, /turf/simulated/floor) || istype(moveto, /turf/unsimulated/floor)) step_towards(brain, moveto)
			if(aggressive) seek_target()

		talking()
			for(var/mob/M in range(5, brain))
				M << "[brain] * [mysay] *"

		life()
			var/deathfactor = 0
			while(deathfactor == 0)
				if(istype(brain, /mob/simulated/living))
					deathfactor = brain.death
				sleep(rand(7,25))
				if(prob(75))
					mobmovement()
				if(prob(3))
					talking()

		New(var/mob/simulated/SM)
			if(!brain)
				brain = SM
			life()
			..()

		monkey
			mysay = "whimpers"

	patrol_bots

		clean_bot
			mobmovement()
				var/mindist = min(distances)
				dist_calculate()
				for(var/obj/botsignaler/BS in signalers)
					for(var/obj/blood/BL in view(5,src))
						walk_to(brain, BL, 0, 3, 64)
						if(prob(45))
							talking()
					if(get_dist(BS,brain) == mindist && !myway.Find(BS))
						if(prob(10))
							talking()
						walk_to(brain, BS, 0, 3, 64)
						myway.Add(BS)
						dist_calculate()
						if(length(myway) == length(signalers) - 1 || length(myway) == length(signalers))
							for(var/mob/M in range(5, brain))
								M << 'buzz-two.ogg'
							myway.Cut()
							dist_calculate()


		var/list/distances = list()
		var/list/obj/botsignaler/myway = list()

		proc/dist_calculate()
			..()
			distances.Cut()
			for(var/obj/botsignaler/BS in signalers)
				if(!myway.Find(BS))
					distances.Add(get_dist(BS,brain))

		mobmovement()
			var/mindist = min(distances)
			dist_calculate()
			for(var/obj/botsignaler/BS in signalers)
				if(get_dist(BS,brain) == mindist && !myway.Find(BS))
					if(prob(10))
						talking()
					walk_to(brain, BS, 0, 3, 64)
					myway.Add(BS)
					dist_calculate()
					if(length(myway) == length(signalers) - 1 || length(myway) == length(signalers))
						for(var/mob/M in range(5, brain))
							M << 'buzz-two.ogg'
						myway.Cut()
						dist_calculate()

		talking()
			for(var/mob/M in range(5, brain))
				M << pick('buzz-sigh.ogg', 'chime.ogg')

		life()
			var/deathfactor = 0
			while(deathfactor == 0)
				if(istype(brain, /mob/simulated/living))
					deathfactor = brain.death
				sleep(rand(7,25))
				if(prob(75))
					mobmovement()

		New(var/mob/simulated/SM)
			if(!brain)
				brain = SM
			dist_calculate()
			life()
			..()
	hunter
		var/list/distances = list()

		mobmovement()
			for(var/mob/M in range(5, brain))
				if(prob(10))
					talking()
				walk_to(brain, M, 0, 3, 64)

		talking()
			for(var/mob/M in range(5, brain))
				M << pick('buzz-sigh.ogg', 'chime.ogg')

		life()
			var/deathfactor = 0
			while(deathfactor == 0)
				if(istype(brain, /mob/simulated/living))
					deathfactor = brain.death
				sleep(rand(7,25))
				if(prob(75))
					mobmovement()

		New(var/mob/simulated/SM)
			if(!brain)
				brain = SM
			life()
			..()

proc/addai(var/mob/simulated/M, var/datum/AI/ai)
	new ai(M)

proc/delai(var/mob/M)
	var/datum/AI/ai
	for(ai in M)
		del(ai)
