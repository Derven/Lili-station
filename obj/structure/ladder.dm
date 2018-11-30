/obj/structure/ladder
	icon_state = "ladder"
	icon = 'stationobjs.dmi'

	attack_hand()
		spawn(rand(1,5))
			if(usr.ZLevel == src.ZLevel)
				usr.ZLevel += 1
				usr.Climbing = 1
				if(usr.client)
					usr.client.clear_MYZL()
			else
				usr.ZLevel -= 1
				usr.Climbing -= 1