/obj/hud
	play
		icon_state = "play"
		screen_loc = "SOUTH-1, WEST+4"

		Click()
			var/mob/simulated/living/humanoid/H = iam
			H.FREQ.icon_state = "freq"
			H.SPLAYER.stop = 0
			H.SPLAYER.soundprocess()
			//H.swap_hand()

	freq
		icon_state = "nofreq"
		screen_loc = "SOUTH-1, WEST+5"

		Click()
			//var/mob/simulated/living/humanoid/H = iam
			//H.swap_hand()

	stop
		icon_state = "stop"
		screen_loc = "SOUTH-1, WEST+6"

		Click()
			var/mob/simulated/living/humanoid/H = iam
			H.SPLAYER.stop = 1
			H.FREQ.icon_state = "nofreq"
			H << sound(null, 0, 0, H.SPLAYER.ichannel)
			//var/mob/simulated/living/humanoid/H = iam
			//H.swap_hand()