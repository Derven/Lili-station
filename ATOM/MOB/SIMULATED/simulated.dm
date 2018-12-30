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
	var/image/overlay_cur

	verb/Say(msg as text)
		set name = "Say"
		set category = "IC"
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
		pulling.pullers -= src
		pulling = null
		PULL.icon_state = "pull_1"

	proc/update_pulling()
		if((get_dist(src, pulling) > 1) || !isturf(pulling.loc))
			stop_pulling()