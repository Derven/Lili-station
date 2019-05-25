mob/proc/camera_refresh()
	if(dir == NORTH)
		client.eye = locate(x, y + 3, z)
	if(dir == SOUTH)
		client.eye = locate(x, y - 3, z)
	if(dir == WEST)
		client.eye = locate(x - 3, y, z)
	if(dir == EAST)
		client.eye = locate(x + 3, y, z)

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
	var/other_effects = 0
	var/gravity = 0

	proc/switch_rintent()
		if(run_intent == 4)
			run_intent = 2
			return
		if(run_intent == 2)
			run_intent = 4
			return

	Move()
		if(istype(mob.loc, /turf))
			if(speeding <= 0)
				speeding = 1
				var/jp = 0
				..()
				var/area/A = mob.loc.loc
				gravity = A.gravitypower
				if((istype(mob.loc, /turf/space)) || (A.has_gravity == 0))
					mob.Process_Spacemove(0)
				var/mob/simulated/living/humanoid/M = mob
				for(var/obj/item/weapon/storage/box/backpack/jetpack/J in M)
					J.jpixel()
					jp = 2
				if(istype(M, /mob/simulated/living/humanoid))
					if(M && M.stamina < 30)
						if(prob(rand(1,3)))
							M << "\red You need to catch your breath!"
						if(prob(2))
							if(M.heart)
								M.heart.activate_stimulators(/datum/heart_stimulators/light_sedative)
					var/hungryeffect = 0
					if(M && M.nutrition < 150)
						hungryeffect = 1
					if(M.heart)
						sleep(run_intent - round(M.heart.pumppower/100) - jp + hungryeffect + other_effects + gravity)
						if(run_intent < 4 && jp == 0)
							if(M && M.stamina > 1)
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