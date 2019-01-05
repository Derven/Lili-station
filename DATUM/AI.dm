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

proc/addai(var/mob/simulated/M, var/datum/AI/ai)
	new ai(M)

proc/delai(var/mob/M)
	var/datum/AI/ai
	for(ai in M)
		del(ai)
