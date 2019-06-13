/mob
	var/
		opened_chest = 0
		cut_heart = 0
		change_heart = 0
		cut_parasite = 0

	proc/cut_parasite()
		cut_parasite = 0
		for(var/mob/M in src)
			M.loc = src.loc
			M.death = 1

	proc/cut_heart()
		cut_heart = 0
		var/obj/item/heart/HEARTMY = new /obj/item/heart(src.loc)
		if(src:heart)
			HEARTMY.HEART = src:heart
			src:heart = null

	proc/change_heart(var/obj/item/heart/HeArT)
		change_heart = 0
		if(src:heart)
			var/obj/item/heart/HEARTMY = new /obj/item/heart(src.loc)
			HEARTMY.HEART = src:heart
			src:heart = HeArT.HEART
			del(HeArT)

/obj/item/weapon/scalpel
	name = "scalpel"
	icon = 'surgery.dmi'
	icon_state = "scalpel1"
	force = 10

	afterattack(atom/target, mob/user , flag)
		if(istype(target, /mob/simulated/living/humanoid))
			if(target:opened_chest == 1 && target:cut_heart == 0 && usr:ZN_SEL.selecting == "chest")
				target:cut_heart = 0.5
				usr << "\red You prepared [target] heart for cutting."
				return
			if(target:opened_chest == 1 && target:cut_heart == 0.5 && usr:ZN_SEL.selecting == "chest")
				target:cut_heart = 1
				usr << "\red You cutted [target] heart."
				target:cut_heart()
				return


/obj/item/weapon/bandage
	icon = 'surgery.dmi'
	name = "bandage"
	icon_state = "bandage-item-3"

	afterattack(atom/target, mob/user , flag)
		if(istype(target, /mob/simulated/living/humanoid))
			if(target:opened_chest == 1 || target:cut_heart != 0 && usr:ZN_SEL.selecting == "chest")
				target:opened_chest = 0
				usr << "\blue You closed [target] chest wounds."
				target:cut_heart = 0
/obj/item/heart
	var/datum/organ/internal/heart/HEART
	icon = 'surgery.dmi'
	icon_state = "heart"

	New()
		..()
		HEART = new /datum/organ/internal/heart()

	afterattack(atom/target, mob/user , flag)
		if(istype(target, /mob/simulated/living/humanoid))
			if(target:opened_chest == 1 && target:cut_heart == 0.5 && usr:ZN_SEL.selecting == "chest")
				target:change_heart = 1
				usr << "\blue You changed [target] heart."
				target:change_heart(src)