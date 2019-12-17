var/consolid = 0
var/messages = ""

/obj/machinery
	var/datum/UI/COMPUTER

	proc/initUI(var/list/bnames, var/list/bhrefs)
		COMPUTER = new /datum/UI()
		COMPUTER.initUI(bnames, bhrefs, src, "computer")

/obj/machinery/consol
	name = "consol"
	anchored = 1
	icon_state = "consol"
	power_channel = ENVIRON
	idle_power_usage = 200
	luminosity = 2
	var/conid = 0

	New()
		..()
		consolid += 1
		conid = consolid

	var
		mystate = "off"

	process()
		//SetLuminosity(2)

	message
		name = "messaging console"
		icon_state = "shuttle"

		attack_hand()
			usr << browse(messages, "window=computermessage")
			var/msg = input("Your message?",
				"Message")
			if(msg != "")
				sleep(rand(5,8))
				messages += fix1103("[usr]:[msg]<br><br>")
			usr << browse(null, "window=computermessage")
			usr << browse(messages, "window=computermessage")

	newUI


		New()
			..()
			initUI(list("hello", "world"), list("hello=1", "world=2"))

		attack_hand()
			COMPUTER.updateUI("helloworld")
			COMPUTER.browseme(usr, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\
			Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit,\
			sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur?\
			Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur,\
			vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?")

/obj/machinery/serverbox
	icon = 'stationobjs.dmi'
	name = "communication server"
	icon_state = "serverbox"
	density = 1
	anchored = 1

	process()
		sleep(150)
		for(var/mob/M in range(2, src))
			M.playsoundforme('signal.ogg')

/obj/machinery/blood_injector
	name = "blood-donor bench"
	icon = 'stationobjs.dmi'
	name = "blood_machine"
	icon_state = "inoperationbed"
	density = 0
	anchored = 1
	var/list/buckled_mobs = new/list()

	proc/buckle_mob(mob/simulated/living/humanoid/M as mob, mob/user as mob)
		if ((!( istype(M, /mob) ) || get_dist(src, user) > 1 || M.loc != src.loc || usr.stat || M.buckled))
			return
		if (M == usr)
			usr << "\blue You buckle yourself"
		else
			usr << "\blue [M] buckled by [usr]"
		usr.playsoundforme('handcuffs.ogg')
		M.anchored = 1
		M.buckled = src
		M.loc = src.loc
		M.dir = src.dir
		if(!M.lying)
			M.rest()
		buckled_mobs += M


	proc/manual_unbuckle_all(mob/user as mob)
		var/N = 0;
		for(var/mob/simulated/living/humanoid/M in buckled_mobs)
			if (M.buckled == src)
				if (M != user)
					M << "\blue You unbuckled from [src] by [user.name]."
				else
					user << "\blue You unbuckle yourself from [src]."
	//			world << "[M] is no longer buckled to [src]"
				usr.playsoundforme('handcuffs.ogg')
				M.anchored = 0
				M.buckled = null
				buckled_mobs -= M
				if(M.lying)
					M.rest()
				N++
		return N

	MouseDrop_T(mob/M as mob, mob/user as mob)
		if (!istype(M)) return
		buckle_mob(M, user)
		return

	attack_hand()
		manual_unbuckle_all(usr)

/obj/machinery/blood_rec
	name = "blood-recipient bench"
	icon = 'stationobjs.dmi'
	name = "blood_machine"
	icon_state = "operationbed"
	density = 0
	anchored = 1
	var/list/buckled_mobs = new/list()

	proc/manual_unbuckle_all(mob/user as mob)
		var/N = 0;
		for(var/mob/simulated/living/humanoid/M in buckled_mobs)
			if (M.buckled == src)
				if (M != user)
					M << "\blue You unbuckled from [src] by [user.name]."
				else
					user << "\blue You unbuckle yourself from [src]."
	//			world << "[M] is no longer buckled to [src]"
				usr.playsoundforme('handcuffs.ogg')
				M.anchored = 0
				M.buckled = null
				buckled_mobs -= M
				if(M.lying)
					M.rest()
				N++
		return N

	MouseDrop_T(mob/M as mob, mob/user as mob)
		if (!istype(M)) return
		buckle_mob(M, user)
		return

	attack_hand()
		manual_unbuckle_all(usr)

	proc/buckle_mob(mob/simulated/living/humanoid/M as mob, mob/user as mob)
		if ((!( istype(M, /mob) ) || get_dist(src, user) > 1 || M.loc != src.loc || usr.stat || M.buckled))
			return
		if (M == usr)
			usr << "\blue You buckle yourself"
		else
			usr << "\blue [M] buckled by [usr]"
		usr.playsoundforme('handcuffs.ogg')
		M.anchored = 1
		M.buckled = src
		M.loc = src.loc
		M.dir = src.dir
		if(!M.lying)
			M.rest()
		buckled_mobs += M


/obj/machinery/blood_machine
	name = "blood pump"
	icon = 'stationobjs.dmi'
	name = "blood_machine"
	icon_state = "blood_machine"
	density = 1
	anchored = 1
	var/pump_power = 5

	operation
		pump_power = 10
		icon_state = "bloodmachine_off"

		update_icon()
			for(var/obj/machinery/blood_rec/b2 in range(1,src))
				for(var/mob/simulated/living/humanoid/H1 in b2.loc)
					if(H1.heart && H1.lying == 1 )
						if((H1.heart.pumppower / 100) * 60 < 50)
							icon_state = "bloodmachine_sleepy"
							return
						if((H1.heart.pumppower / 100) * 60 > 50 && (H1.heart.pumppower / 100) * 60 < 80)
							icon_state = "bloodmachine_normal"
							return
						if((H1.heart.pumppower / 100) * 60 > 80)
							icon_state = "bloodmachine_hard"
							return
			icon_state = "bloodmachine_off"

		process()
			update_icon()
			for(var/obj/machinery/blood_rec/b2 in range(1,src))
				for(var/mob/simulated/living/humanoid/H1 in b2.loc)
					if(H1.lying == 1 && !H1.reagents.has_reagent("blood", 100))
						H1.reagents.add_reagent("blood", pump_power)

	process()
		for(var/obj/machinery/blood_rec/b1 in range(1,src))
			for(var/mob/simulated/living/humanoid/H in b1.loc)
				if(H.reagents.has_reagent("blood", pump_power))
					for(var/obj/machinery/blood_injector/b2 in range(1,src))
						for(var/mob/simulated/living/humanoid/H1 in b2.loc)
							if(H.lying == 1 && H1.lying == 1)
								H.reagents.remove_reagent("blood", pump_power)
								H1.reagents.add_reagent("blood", pump_power)


/obj/machinery/consol/arcade
	name = "arcade machine"
	desc = "Does not support Pin ball."
	icon_state = "arcade"
	var/enemy_name = "Space Villian"
	var/temp = "Winners Don't Use Spacedrugs" //Temporary message, for attack messages, etc
	var/player_hp = 30 //Player health/attack points
	var/player_mp = 10
	var/enemy_hp = 45 //Enemy health/attack points
	var/enemy_mp = 20
	var/gameover = 0
	var/blocked = 0 //Player cannot attack/heal while set

	New()
		..()
		new /datum/computer/file/computer_program/arcade(src)

/obj/machinery/consol/command
	name = "command console"
	anchored = 2
	icon_state = "command"

	id_replace
		name = "ID-access console"
		var/obj/item/clothing/id/MYID

		New()
			..()
			initUI(list("eject"), list("eject=1"))

		proc/replace_id(var/mob/M, var/datum/id/IDC)
			if(MYID)
				MYID.ID = IDC
				M << "[MYID] access level is [IDC.accessname]"

		attackby(var/obj/item/clothing/id/O as obj, var/mob/user as mob)
			if (istype(O, /obj/item/clothing/id))
				if(!MYID)
					var/mob/simulated/living/humanoid/H = usr
					H.drop_item_v()
					O.Move(src)
					MYID = O

		proc/consol_interface()
			var/body = ""
			body += "ID access system control<br>"
			body += "<a href='?src=\ref[src];access=1;'>Basic</a><br>"
			body += "<a href='?src=\ref[src];access=2;'>Assistant</a><br>"
			body += "<a href='?src=\ref[src];access=3;'>Captain</a><br>"
			body += "<a href='?src=\ref[src];access=4;'>Security</a><br>"
			body += "<a href='?src=\ref[src];access=5;'>Doctor</a><br>"
			body += "<br>State: [MYID ? "[MYID.ID.accessname];[MYID.name]" : "no"]"
			COMPUTER.browseme(usr, body)

		attack_hand()
			consol_interface()

		Topic(href,href_list[])
			if(usr.check_topic(src))
				if(href_list["access"] == "1")
					if(MYID)
						MYID.ID = null
						MYID.ID = new /datum/id/(MYID)
						MYID.idtype = /datum/id
						usr << "You change [MYID] access"

				if(href_list["access"] == "2")
					if(MYID)
						MYID.ID = null
						MYID.ID = new /datum/id/assistant(MYID)
						MYID.idtype = /datum/id/assistant
						usr << "You change [MYID] access"

				if(href_list["access"] == "3")
					if(MYID)
						MYID.ID = null
						MYID.ID = new /datum/id/captain(MYID)
						MYID.idtype = /datum/id/captain
						usr << "You change [MYID] access"

				if(href_list["access"] == "4")
					if(MYID)
						MYID.ID = null
						MYID.ID = new /datum/id/security(MYID)
						MYID.idtype = /datum/id/security
						usr << "You change [MYID] access"

				if(href_list["access"] == "5")
					if(MYID)
						MYID.ID = null
						MYID.ID = new /datum/id/doctor(MYID)
						MYID.idtype = /datum/id/doctor
						usr << "You change [MYID] access"

				if(href_list["eject"] == "1")
					if(MYID)
						usr << "You eject [MYID]"
						var/obj/item/clothing/id/jid //job id
						jid = new /obj/item/clothing/id(src.loc)
						jid.name = MYID.name
						jid.idtype = MYID.idtype
						jid.ID = MYID.ID
						jid.myids += MYID.idtype
						MYID = null
						//MYID = null

/obj/machinery/consol/announcement
	name = "announcement console"
	anchored = 2
	icon_state = "shuttle"

	attack_hand()
		var/msg = input("Your announce?",
			"Announce")
		if(msg != "")
			sleep(rand(5,8))
			world << "\red <h1>Station announce: [fix255(msg)]</h1>"
			world << 'commandreport.ogg'

/obj/machinery/consol/superterminal
	name = "superterminal"
	anchored = 2
	icon_state = "command"
	desc = "What do you see? Power..."

	New()
		..()
		initUI(list("off"), list("closemepls=1"))


	attack_hand()
		//var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
		var/body = "Consol|Coordinates <br>"
		var/i = 0
		for(var/obj/machinery/consol/C in world)
			i += 1
			body += "consol #<a href='?src=\ref[src];cid=[C.conid];'>[i]</a>|[C.x];[C.y]<br>"
		usr << browse(body,"window=computercon;can_close=0")
		COMPUTER.browseme(usr, body)

/obj/machinery/consol/superterminal/Topic(href,href_list[])
	if(usr.check_topic(src))
		if(href_list["cid"])
			var/con_id = text2num(href_list["cid"])
			for(var/obj/machinery/consol/C in world)
				if(C.conid == con_id)
					C.attack_hand(usr)
		if(href_list["closemepls"] == "1")
			usr << browse(null, "window=computercon")

/obj/machinery/consol/cargo
	name = "cargo console"
	anchored = 2
	icon_state = "cargo"

	mining_shuttle
		name = "mining shuttle console"
		attack_hand()
			for(var/obj/item/clothing/id/captain/CPID in usr)
				for(var/mob/M in world)
					M << "\red Engines are being prepared..."
				sleep(3)
				send_supply_shuttle()
				for(var/obj/machinery/simple_apc/SA in range(8, src))
					SA.charge = 0
					SA.my_smes.charge = 0
				world << "\red Restarting in 5 seconds..."
				sleep(50)
				world.Reboot(1)


/obj/machinery/consol/shuttle
	name = "cargo shuttle console"
	anchored = 2
	icon_state = "shuttle"