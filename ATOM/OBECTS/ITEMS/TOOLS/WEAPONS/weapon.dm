/obj/item/weapon/grab
	name = "grab"
	//icon = 'screen1.dmi'
	icon_state = "grabbed"
	var/obj/screen/grab/hud1 = null
	var/mob/affecting = null
	var/mob/assailant = null
	var/state = 1.0
	var/killing = 0.0
	var/allow_upgrade = 1.0
	var/last_suffocate = 1.0
	layer = 21

/obj/item/weapon/soap
	icon = 'tools.dmi'
	icon_state = "soap"

	afterattack(atom/target, mob/user , flag)
		if(istype(target, /turf/simulated/floor))
			for(var/obj/blood/B in target)
				del(B)

	Crossed(var/mob/M)
		if(istype(M, /mob/simulated/living/humanoid))
			M.stunned += rand(3,7)