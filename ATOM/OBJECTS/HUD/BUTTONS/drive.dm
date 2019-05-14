/obj/hud
	drive
		icon_state = "drive"
		invisibility = 101
		screen_loc = "SOUTH-1, WEST+6"


		MouseDown()
			while(iam.client.mdown == 1)
				sleep(2)
				for(var/dz/DERVENZONE in iam.loc)
					if(DERVENZONE.center == 1)
						DERVENZONE.drive_my_car()

/obj/hud
	rotate
		icon_state = "rotate"
		invisibility = 101
		screen_loc = "SOUTH-1, WEST+6"

		Click()
			for(var/dz/DERVENZONE in iam.loc)
				if(DERVENZONE.center == 1)
					if(DERVENZONE.rotate_my_car() == 25)
						iam << "maneuver is impossible"