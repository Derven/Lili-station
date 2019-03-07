client
	script="<style>\
	body { \
		font-family: 'Courier'; \
	} \
	IMG.icon {width: 64px; height: 64px; float: left;};\
	\
	.gray{color: darkgray;}\
	}</style>"
	var/run_intent = 4
	var/speeding = 0

	proc/switch_rintent()
		if(run_intent == 4)
			run_intent = 2
			return
		if(run_intent == 2)
			run_intent = 4
			return

	Move()
		if(speeding <= 0)
			speeding = 1
			var/jp = 0
			..()
			var/mob/simulated/living/humanoid/M = mob
			for(var/obj/item/weapon/storage/box/backpack/jetpack/J in M)
				J.jpixel()
				jp = 2
			if(istype(M, /mob/simulated/living/humanoid))
				if(M.stamina < 30)
					if(prob(rand(1,5)))
						M << "\red You need to catch your breath!"
					if(prob(3))
						M.heart.activate_stimulators(/datum/heart_stimulators/light_sedative)
				var/hungryeffect = 0
				if(M.nutrition < 150)
					hungryeffect = 1
				sleep(run_intent - round(M.heart.pumppower/100) - jp + hungryeffect)
				if(run_intent < 4 && jp == 0)
					if(M.stamina > 1)
						M.stamina -= 1
						M.STAMINABAR.staminapixels()
						if(prob(5))
							M.nutrition -= 1

			else
				sleep(1) //placeholder
			speeding = 0
		else
			return

	New()
		if(src.ckey in admins)
			src.verbs += admin_verbs
		return ..()

	Topic(href,list/href_list,hsrc)
		if(hsrc == src)
			if(href_list["admin"])
				if(usr.client != src)
					return
				var/mob/target
				if(href_list["target"])
					target = locate(href_list["target"])
				switch(href_list["admin"])
					if("pm")
						if(!(src.ckey in admins) && !(target.ckey in admins))
							return
						src.pm(target, input("Enter message:", "Private Message") as text)
					if("kick")
						if(!(src.ckey in admins))
							return
						src.kick(target)
					if("ban")
						if(!(src.ckey in admins))
							return
						src.ban(target)
		else ..()