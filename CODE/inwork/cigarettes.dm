/obj/item/cigs/
/obj/item/cigpacket
	icon = 'chemical.dmi'
	name = "cigarettes"
	icon_state = "cigs"
	var/amount = 20

	proc/use()
		if(amount > 0)
			for(var/obj/item/cigs/CIGA in usr) //Not all at once
				return
			amount -= 1
			new /obj/item/cigs(usr)
			if(usr:gender == "male")
				usr:cig_overlay = image('mob.dmi', "cig_overlay")
			else
				usr:cig_overlay = image('mob.dmi', "f_cig_overlay")
			usr.overlays += usr:cig_overlay
		else
			usr << "\red Oh no! Cigpacket is empty..."

	attack_self()
		use()