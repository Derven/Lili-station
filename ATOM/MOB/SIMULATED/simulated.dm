/mob/simulated
	var/bodytemperature = 310.055
	var/oxyloss = 0.0
	var/toxloss = 0.0
	var/brainloss = 0.0
	var/ear_deaf = null
	var/face_dmg = 0
	var/halloss = 0
	var/hallucination = 0
	var/list/atom/hallucinations = list()
	var/health = 100

/mob/simulated

	verb/suicide()
		set name = "Suicide"
		set category = "IC"
		if(density == 1)
			death()
		else
			src << "no"

	proc/stop_pulling()
		pulling.pullers -= src
		pulling = null
		PULL.icon_state = "pull_1"

	proc/update_pulling()
		if((get_dist(src, pulling) > 1) || !isturf(pulling.loc))
			stop_pulling()

	proc/handle_temperature_damage(body_part, exposed_temperature, exposed_intensity)
		if(nodamage) return

		if(exposed_temperature > bodytemperature)
			var/discomfort = min( abs(exposed_temperature - 310)/2000, 1.0)
			//adjustFireLoss(2.5*discomfort)
			//adjustFireLoss(5.0*discomfort)
			rand_burn_damage(20.0*discomfort, 20.0*discomfort)

		else
			var/discomfort = min( abs(exposed_temperature - 310)/2000, 1.0)
			//adjustFireLoss(2.5*discomfort)
			rand_burn_damage(20.0*discomfort, 20.0*discomfort)

	proc/handle_temperature(var/datum/gas_mixture/environment)
		if(cloth == null || cloth.space_suit == 0)
			if(H)
				H.clear_overlay()
				H.temppixels(round(bodytemperature))
				H.oxypixels(round(100 - oxyloss))
				H.healthpixels(round(health))
			if(environment)
				var/environment_heat_capacity = environment.heat_capacity()
				var/transfer_coefficient = 1
				var/areatemp = environment.temperature
				if(abs(areatemp - bodytemperature) > 50)
					var/diff = areatemp - bodytemperature
					diff = diff / 5
					//world << "changed from [bodytemperature] by [diff] to [bodytemperature + diff]"
					bodytemperature += diff
				if(bodytemperature < 310)
					bodytemperature += rand(1, 2)
					if(bodytemperature < 170)
						heart.activate_stimulators(/datum/heart_stimulators/hard_sedative)

				handle_temperature_damage(chest, environment.temperature, environment_heat_capacity*transfer_coefficient)