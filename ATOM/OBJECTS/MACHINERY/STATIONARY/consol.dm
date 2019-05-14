var/consolid = 0
var/messages = ""

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
		sd_SetLuminosity(2)

	message
		name = "messaging console"
		icon_state = "shuttle"

		attack_hand()
			usr << browse(messages, "window=computermessage")
			var/msg = input("Your message?",
				"Message")
			if(msg != "")
				sleep(rand(5,8))
				messages += fix1103("<h2>[usr]:[msg]</h2><br><br>")
			usr << browse(null, "window=computermessage")
			usr << browse(messages, "window=computermessage")


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

/obj/machinery/blood_rec
	name = "blood-recipient bench"
	icon = 'stationobjs.dmi'
	name = "blood_machine"
	icon_state = "operationbed"
	density = 0
	anchored = 1

/obj/machinery/blood_machine
	name = "blood pump"
	icon = 'stationobjs.dmi'
	name = "blood_machine"
	icon_state = "blood_machine"
	density = 1
	anchored = 1
	var/pump_power = 5

	process()
		for(var/obj/machinery/blood_injector/b1 in range(1,src))
			for(var/mob/simulated/living/humanoid/H in b1.loc)
				if(H.reagents.has_reagent("blood", pump_power))
					for(var/obj/machinery/blood_rec/b2 in range(1,src))
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
			var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
			body += "<body>ID access system control:<hr><table class=\"pure-table\"><thead><tr><th>#Num</th><th>Access</th></tr></thead><tbody>"
			body += "<tr><td>1#</td><td><a href='?src=\ref[src];access=1;'>Basic</a></td></tr>"
			body += "<tr><td>1#</td><td><a href='?src=\ref[src];access=2;'>Assistant</a></td></tr>"
			body += "<tr><td>1#</td><td><a href='?src=\ref[src];access=3;'>Captain</a></td></tr>"
			body += "<tr><td>1#</td><td><a href='?src=\ref[src];access=4;'>Security</a></td></tr>"
			body += "<tr><td>1#</td><td><a href='?src=\ref[src];access=5;'>Doctor</a></td></tr>"
			body += "<br>State: [MYID ? "[MYID.ID.accessname];[MYID.name]" : "no"]"
			body += "</tbody></table><hr><a class=\"pure-button pure-button-primary\" href='?src=\ref[src];eject=1;'>eject</a></html></body>"
			usr << browse(body,"window=idcontrol")

		attack_hand()
			consol_interface()

		Topic(href,href_list[])
			if(usr.check_topic(src))
				if(href_list["access"] == "1")
					if(MYID)
						MYID.ID = null
						MYID.ID = new /datum/id/(MYID)
						MYID.idtype = /datum/id

				if(href_list["access"] == "2")
					if(MYID)
						MYID.ID = null
						MYID.ID = new /datum/id/assistant(MYID)
						MYID.idtype = /datum/id/assistant

				if(href_list["access"] == "3")
					if(MYID)
						MYID.ID = null
						MYID.ID = new /datum/id/captain(MYID)
						MYID.idtype = /datum/id/captain

				if(href_list["access"] == "4")
					if(MYID)
						MYID.ID = null
						MYID.ID = new /datum/id/security(MYID)
						MYID.idtype = /datum/id/security

				if(href_list["access"] == "5")
					if(MYID)
						MYID.ID = null
						MYID.ID = new /datum/id/doctor(MYID)
						MYID.idtype = /datum/id/doctor

				if(href_list["eject"] == "1")
					if(MYID)
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

	attack_hand()
		var/body = "<html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"></head>"
		body += "<body>Superterminal:<hr><table class=\"pure-table\"><thead><tr><th>Consol</th><th>Coordinates</th></tr></thead><tbody>"
		var/i = 0
		for(var/obj/machinery/consol/C in world)
			i += 1
			body += "<tr><td>consol #<a href='?src=\ref[src];cid=[C.conid];'>[i]</a></td><td>[C.x];[C.y]</td></tr>"
		body += "</tbody></table><hr><a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];closemepls=1;'>exit</a></html></body>"
		usr << browse(body,"window=computercon;can_close=0")

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
				for(var/turf/T in locate(src.loc.loc.type))
					T.sd_LumReset()
				world << "\red Restarting in 5 seconds..."
				sleep(50)
				world.Reboot(1)


/obj/machinery/consol/shuttle
	name = "cargo shuttle console"
	anchored = 2
	icon_state = "shuttle"