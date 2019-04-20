/mob
	var/memory = ""

/datum/game_mode/traitor
	name = "traitor"

	var/const/prob_int_murder_target = 50 // intercept names the assassination target half the time
	var/const/prob_right_murder_target_l = 25 // lower bound on probability of naming right assassination target
	var/const/prob_right_murder_target_h = 50 // upper bound on probability of naimg the right assassination target

	var/const/prob_int_item = 50 // intercept names the theft target half the time
	var/const/prob_right_item_l = 25 // lower bound on probability of naming right theft target
	var/const/prob_right_item_h = 50 // upper bound on probability of naming the right theft target

	var/const/prob_int_sab_target = 50 // intercept names the sabotage target half the time
	var/const/prob_right_sab_target_l = 25 // lower bound on probability of naming right sabotage target
	var/const/prob_right_sab_target_h = 50 // upper bound on probability of naming right sabotage target

	var/const/prob_right_killer_l = 25 //lower bound on probability of naming the right operative
	var/const/prob_right_killer_h = 50 //upper bound on probability of naming the right operative
	var/const/prob_right_objective_l = 25 //lower bound on probability of determining the objective correctly
	var/const/prob_right_objective_h = 50 //upper bound on probability of determining the objective correctly

	//apparently BYOND doesn't have enums, so this seems to be the best approximation
	var/const/obj_murder = 1
	var/const/obj_hijack = 2
	var/const/obj_steal = 3
	var/const/obj_sabotage = 4
	var/const/ai_obj_murder = 5
	var/const/ai_obj_evacuate = 6

	var/const/laser = 1
	var/const/hand_tele = 2
	var/const/plasma_bomb = 3
	var/const/jetpack = 4
	var/const/captain_card = 5
	var/const/captain_suit = 6

	var/const/destroy_plasma = 1
	var/const/destroy_ai = 2
	var/const/kill_monkeys = 3
	var/const/cut_power = 4

	var/const/percentage_plasma_destroy = 70 // what percentage of the plasma tanks you gotta destroy
	var/const/percentage_station_cut_power = 80 // what percentage of the tiles have to have power cut
	var/const/percentage_station_evacuate = 80 // what percentage of people gotta leave

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

/datum/game_mode/traitor/announce()
	world << "<B>The current game mode is - Traitor!</B>"
	world << "<B>There is a traitor on the station. You can't let him achieve his objective!</B>"

/datum/game_mode/traitor/proc/pick_killer()
	var/mob/simulated/living/humanoid/killer = pick(get_synd_list())
	var/objective = pick_objective(killer)

	switch (objective)

		if(obj_hijack)
			killer << "\red<font size=3><B>You are the traitor!</B> Be the lone survivor on the emergency shuttle.</font>"
			killer:memory += "<B>Objective:</B> Be the only person on the emergency shuttle."

		if (obj_murder)
			var/targetdesc = get_target_desc(pick_human_except(killer))
			killer << "\red<font size=3><B>You are the traitor!</B> You must assassinate [targetdesc] and then escape.</font>"
			killer << "<B>You don't have to be the lone survivor. Just don't get caught. Just escape!</B>"
			killer:memory += "<B>Objective:</B> Assassinate [targetdesc] and escape."

		if (obj_steal)
			var/itemdesc = get_item_desc(get_pickable_items(killer))

			killer << "\red<font size=3><B>You are the traitor!</B> You must steal [itemdesc] and then escape.</font>"
			killer << "<B>You don't have to be the lone survivor. Just don't get caught. Just escape!</B>"
			killer:memory += "<B>Objective:</B> Steal [itemdesc] and escape."

		if (obj_sabotage)
			var/targetdesc = get_sab_desc(pick_sab_target())
			killer << "\red<font size=3><B>You are the traitor!</B> [targetdesc] and then escape.</font>"
			killer << "<B>You don't have to be the lone survivor. Just don't get caught. Just escape!</B>"
			killer:memory += "<B>Objective:</B> [targetdesc] and escape."

/datum/game_mode/traitor/proc/post_setup()
	var/list/mobs = get_mob_list()
	while (mobs.len == 0)
		sleep 30
		mobs = get_mob_list()
	pick_killer()
	//spawn (0)
	//	ticker.extend_process()

/datum/game_mode/traitor/proc/get_synd_list()
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.client && (istype(M, /mob/simulated/living/humanoid)))
			//if(M.be_syndicate && M.start)
			mobs += M
	if(mobs.len < 1)
		mobs = get_mob_list()
	return mobs


/datum/game_mode/traitor/proc/pick_objective(mob/killer)
	var/list/mob_list = get_mob_list()
	var/list/human_list = get_human_list()
	if (mob_list.len <= 1)
		return pick(obj_hijack, obj_steal, obj_sabotage)
	else if (human_list.len <= 1)	//silly fix for if there are two players and one of them is the ai, traitor would get murder objective and process would crash
		return pick(obj_hijack, obj_steal, obj_sabotage)
	else
		return pick(obj_hijack, obj_steal, obj_sabotage, obj_murder)

/datum/game_mode/traitor/proc/get_mob_list()
	var/list/mobs = list()
	for(var/mob/M in world)
		if (M.client)
			mobs += M
	return mobs

/datum/game_mode/traitor/proc/get_human_list()
	var/list/humans = list()
	for(var/mob/simulated/living/humanoid/M in world)
		if (M.client)
			humans += M
	return humans

/datum/game_mode/traitor/proc/pick_human_except(mob/human/exception)
	return pick(get_human_list())

/datum/game_mode/traitor/proc/get_target_desc(mob/target) //return a useful string describing the target
	return "[target.name]"

/datum/game_mode/traitor/proc/get_rank(mob/M)
	return null

/datum/game_mode/traitor/proc/get_mobs_with_rank(rank)

	return null

/datum/game_mode/traitor/proc/get_pickable_items(mob/killer)
	var/killerrank = get_rank(killer)
	var/list/items = list(laser, hand_tele, plasma_bomb, captain_card, jetpack, captain_suit)
	if(killerrank == "Captain")
		return items - list(laser, captain_card, captain_suit, hand_tele, jetpack) //too easy to steal
	else if(killerrank == "Head of Personnel" || killerrank == "Head of Research")
		return items - laser //too easy to steal
	else
		return items

/datum/game_mode/traitor/proc/get_item_desc(var/target)
	switch (target)
		if (laser)
			return "a fully loaded laser gun"
		if (hand_tele)
			return "a hand teleporter"
		if (plasma_bomb)
			return "a fully armed and heated plasma bomb"
		if (captain_card)
			return "an ID card with universal access"
		if (captain_suit)
			return "a captain's dark green jumpsuit"
		if (jetpack)
			return "a jet pack"
		else
			return "Error: Invalid theft target: [target]"

/datum/game_mode/traitor/proc/pick_sab_target()
	var/list/targets = list(destroy_plasma, destroy_ai, kill_monkeys, cut_power)
	var/list/ais = get_mobs_with_rank("AI")
	if(!ais.len)
		targets -= destroy_ai
	return pick(targets)

/datum/game_mode/traitor/proc/get_sab_desc(var/target)
	switch(target)
		if(destroy_plasma)
			return "Destroy at least [percentage_plasma_destroy]% of the plasma canisters on the station"

/datum/game_mode/traitor/proc/get_turf_loc(mob/m) //gets the location of the turf that the mob is on, or what the mob is in is on, etc
	//in case they're in a closet or sleeper or something
	var/loc = m:loc
	while(!istype(loc, /turf/))
		loc = loc:loc
	return loc
