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
	var/damage_bonus = 0
	var/defense = 5
	var/revenge = 0
	var/nodamage = 0
	var/atom/movable/pulling = null
	var/list/stomach_contents = list()
	var/nutrition = 400.0
	var/mob/my_last_looting
	var/image/overlay_cur


	MouseDrop_T(mob/simulated/living/humanoid/target, mob/user)
		my_last_looting = target
		if(src == user)
			if(istype(target, /mob/simulated/living/humanoid))
				var/text = {"
				<html>
					<head>
					<title>[target] Inventory </title>
					</head>
					<body>
						<div class=inventory style=\"{font-size: 24px;}"> \
							...clothing <a href='?src=\ref[src];clothing=[target]'>[target.cloth]</a><br>
							...right hand <a href='?src=\ref[src];r_hand=[target]'>[target.r_hand]</a><br>
							...left hand <a href='?src=\ref[src];l_hand=[target]'>[target.l_hand]</a><br>
							...id card <a href='?src=\ref[src];idcard=[target]'>[target.id]</a><br>
							...backpack <a href='?src=\ref[src];backpack=[target]'>[target.back]</a>
						</div>
					</body>
				</html>"}
				user << browse(text,"window=inventory;size=450x250;can_resize=0;can_close=1")

	Topic(href,href_list[])
		if(href_list["clothing"])
			var/mob/simulated/living/humanoid/H = my_last_looting
			if(do_after(10))
				//
				var/obj/item/clothing/clthg = H.cloth
				clthg.invisibility = 0
				if(H.client)
					H.client.screen.Remove(clthg)
				clthg.loc = H.loc
				H.u_equip(H.cloth)
				clthg.wear_clothing(H)
			return

		if(href_list["r_hand"])
			var/mob/simulated/living/humanoid/H = my_last_looting
			if(do_after(10))
				var/obj/item/clthg = H.r_hand
				clthg.invisibility = 0
				if(H.client)
					H.client.screen.Remove(H.r_hand)
				clthg.loc = H.loc
				H.u_equip(H.r_hand)
				clthg.wear_clothing(H)
			return

		if(href_list["l_hand"])
			var/mob/simulated/living/humanoid/H = my_last_looting
			if(do_after(10))
				var/obj/item/clthg = H.l_hand
				clthg.invisibility = 0
				if(H.client)
					H.client.screen.Remove(H.l_hand)
				H.l_hand.loc = H.loc
				H.u_equip(H.l_hand)
				clthg.wear_clothing(H)
			return

		if(href_list["idcard"])
			var/mob/simulated/living/humanoid/H = my_last_looting
			if(do_after(10))
				var/obj/item/clthg = H.id
				clthg.invisibility = 0
				clthg.loc = H.loc
				if(H.client)
					H.client.screen.Remove(H.id)
				H.u_equip(H.id)
			return

		if(href_list["backpack"])
			var/mob/simulated/living/humanoid/H = my_last_looting
			if(do_after(10))
				var/obj/item/clthg = H.back
				clthg.invisibility = 0
				if(H.client)
					H.client.screen.Remove(H.back)
				H.u_equip(clthg)
				clthg.loc = H.loc
				clthg.wear_clothing(H)
			return

	verb/Say(msg as text)
		set name = "Say"
		set category = "IC"
		sleep(rand(1,2))
		if(!findtext(msg," ",1,2) && msg)
			overlays.Add(overlay_cur)
			for(var/mob/M in range(5, src))
				if(death == 0)
					M << "[src] says, \"[fix255(msg)]\""
			sleep(8)
			overlays.Remove(overlay_cur)
		for(var/obj/machinery/radio/intercom/I in range(7, src))
			tell_me_more(name, fix255(msg))
		return fix255(msg)

	verb/Emote(msg as text)
		set name = "Emote"
		set category = "IC"
		sleep(rand(1,2))
		for(var/mob/M in range(5, src))
			if(msg)
				if(!findtext(msg," ",1,2))
					M << "<b>[src] [fix255(msg)]</b>"

	New()
		START_PROCESSING(SSmobs, src)
		..()

	var //HUD
		obj/hud/pulling/PULL
		obj/hud/zone_sel/ZN_SEL
		obj/hud/zone_sel_def/DF_ZONE
		obj/hud/act_intent/AC
		obj/hud/run_intent/RI

	proc
		create_hud(var/client/C)
			if(C)
				PULL = new (src)
				ZN_SEL = new (src)
				DF_ZONE = new(src)
				AC = new(src)
				RI = new(src)

				C.screen.Add(PULL)
				C.screen.Add(ZN_SEL)
				C.screen.Add(AC)
				C.screen.Add(RI)
				C.screen.Add(DF_ZONE)

	proc/death()
		death = 1
		src << "\red You are dead"
		if(client)
			client.screen.Cut()
		STOP_PROCESSING(SSmobs, src)
		if(istype(src, /mob/simulated/living/humanoid))
			var/mob/simulated/living/humanoid/H = src
			H.rest()
		var/mob/ghost/zhmur = new()
		zhmur.key = key
		if(client)
			Login()
		zhmur.loc = loc
		return

/mob/simulated/proc/handle_stomach()
	spawn(0)
		for(var/mob/simulated/M in stomach_contents)
			if(M.loc != src)
				stomach_contents.Remove(M)
				continue
			if(istype(M, /mob) && stat != 2)
				if(M.stat == 2)

					M.death(1)
					stomach_contents.Remove(M)
					del(M)
					continue
				if(air_master.current_cycle%3==1)
					nutrition += 10

/mob/simulated
	verb/suicide()
		set name = "Suicide"
		set category = "IC"
		if(density == 1)
			death()
		else
			src << "no"

	proc/stop_pulling()
		if(istype(pulling, /mob))
			var/mob/M = pulling
			M.mypool = 0
		pulling.pullers -= src
		pulling = null
		PULL.icon_state = "pull_1"

	proc/update_pulling()
		if((get_dist(src, pulling) > 2) || !isturf(pulling.loc))
			if(get_dist(src, pulling) == 127)
				return
			stop_pulling()