// /mob/simulated vars
//---------------------
/mob/simulated/var/bodytemperature = 310.055
/mob/simulated/var/oxyloss = 0.0
/mob/simulated/var/toxloss = 0.0
/mob/simulated/var/brainloss = 0.0
/mob/simulated/var/ear_deaf = null
/mob/simulated/var/face_dmg = 0
/mob/simulated/var/halloss = 0
/mob/simulated/var/hallucination = 0
/mob/simulated/var/list/atom/hallucinations = list()
/mob/simulated/var/health = 100
/mob/simulated/var/damage_bonus = 0
/mob/simulated/var/defense = 5
/mob/simulated/var/revenge = 0
/mob/simulated/var/nodamage = 0
/mob/simulated/var/atom/movable/pulling = null
/mob/simulated/var/list/stomach_contents = list()
/mob/simulated/var/nutrition = 400.0
/mob/simulated/var/mob/my_last_looting
/mob/simulated/var/image/overlay_cur
/mob/simulated/var/obj/hud/pulling/PULL //HUD
/mob/simulated/var/obj/hud/zone_sel/ZN_SEL //HUD
/mob/simulated/var/obj/hud/zone_sel_def/DF_ZONE //HUD
/mob/simulated/var/obj/hud/act_intent/AC //HUD
/mob/simulated/var/obj/hud/run_intent/RI //HUD

// /mob/simulated procs
//---------------------
/mob/simulated/New()
	START_PROCESSING(SSmobs, src)
	..()

/mob/simulated/MouseDrop_T(mob/simulated/living/humanoid/target, mob/user)
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
						...PDA <a href='?src=\ref[src];pda=[target]'>[target.PDA]</a>
					</div>
				</body>
			</html>"}
			user << browse(text,"window=inventory;size=450x250;can_resize=0;can_close=1")

/mob/simulated/Topic(href,href_list[])
	if(usr.check_topic(src))
		if(href_list["clothing"])
			var/mob/simulated/living/humanoid/H = my_last_looting
			usr << "\blue You trying to take off [H.cloth]"
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
			usr << "\blue You trying to take off [H.r_hand]"
			if(do_after(10))
				var/obj/item/clthg = H.r_hand
				if(clthg)
					clthg:del_inhand(src)
				clthg.invisibility = 0
				if(H.client)
					H.client.screen.Remove(H.r_hand)
				clthg.loc = H.loc
				H.u_equip(H.r_hand)
				clthg.wear_clothing(H)
			return

		if(href_list["pda"])
			var/mob/simulated/living/humanoid/H = my_last_looting
			usr << "\blue You trying to take off [H.PDA]"
			if(do_after(10))
				var/obj/item/clthg = H.PDA
				clthg.invisibility = 0
				if(H.client)
					H.client.screen.Remove(H.r_hand)
				clthg.loc = H.loc
				H.u_equip(H.PDA)
				clthg.wear_clothing(H)
			return

		if(href_list["l_hand"])
			var/mob/simulated/living/humanoid/H = my_last_looting
			usr << "\blue You trying to take off [H.l_hand]"
			if(do_after(10))
				var/obj/item/clthg = H.l_hand
				if(clthg)
					clthg:del_inhand(src)
				clthg.invisibility = 0
				if(H.client)
					H.client.screen.Remove(H.l_hand)
				H.l_hand.loc = H.loc
				H.u_equip(H.l_hand)
				clthg.wear_clothing(H)
			return

		if(href_list["idcard"])
			var/mob/simulated/living/humanoid/H = my_last_looting
			usr << "\blue You trying to take off [H.id]"
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
			usr << "\blue You trying to take off [H.back]"
			if(do_after(10))
				var/obj/item/clthg = H.back
				clthg.invisibility = 0
				if(H.client)
					H.client.screen.Remove(H.back)
				H.u_equip(clthg)
				clthg.loc = H.loc
				clthg.wear_clothing(H)
			return

/mob/simulated/verb/suicide()
	set name = "Suicide"
	set category = "IC"
	if(density == 1)
		death()
	else
		src << "no"

/mob/simulated/verb/Emote(msg as text)
	set name = "Emote"
	set category = "IC"
	sleep(rand(1,2))
	for(var/mob/M in range(5, src))
		if(msg)
			if(!findtext(msg," ",1,2))
				M << "<b>[src] [fix255(msg)]</b>"

/mob/simulated/proc/create_hud(var/client/C)
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

/mob/simulated/proc/death()
	death = 1
	src << "\red You are dead"
	if(client)
		client.screen.Cut()
	//STOP_PROCESSING(SSmobs, src)
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

/mob/simulated/proc/getOxyLoss()
	return oxyloss

/mob/simulated/proc/adjustOxyLoss(var/amount)
	oxyloss = max(oxyloss + amount, 0)

/mob/simulated/proc/getToxLoss()
	return toxloss

/mob/simulated/proc/adjustToxLoss(var/amount)
	toxloss = max(toxloss + amount, 0)

/mob/simulated/proc/stop_pulling()
	if(istype(pulling, /mob))
		var/mob/M = pulling
		M.mypool = 0
	pulling.pullers -= src
	pulling = null
	PULL.icon_state = "pull_1"

/mob/simulated/proc/update_pulling()
	if((get_dist(src, pulling) > 2) || !isturf(pulling.loc))
		if(get_dist(src, pulling) == 127)
			return
		stop_pulling()