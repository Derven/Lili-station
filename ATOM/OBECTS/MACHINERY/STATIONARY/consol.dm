/obj/machinery/consol
	name = "consol"
	anchored = 1
	icon_state = "consol"
	power_channel = ENVIRON
	idle_power_usage = 200
	luminosity = 2

	var
		mystate = "off"

	process()
		sd_SetLuminosity(2)

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
	name = "command"
	anchored = 2
	icon_state = "command"

/obj/machinery/consol/cargo
	name = "cargo"
	anchored = 2
	icon_state = "cargo"

	mining_shuttle
		attack_hand()
			for(var/mob/M in world)
				M << "\red Engines are being prepared..."
			sleep(3)
			send_supply_shuttle()
			for(var/obj/machinery/simple_apc/SA in range(8, src))
				SA.charge = 0
				SA.my_smes.charge = 0
			for(var/turf/T in locate(src.loc.loc.type))
				T.sd_LumReset()

/obj/machinery/consol/shuttle
	name = "cargo"
	anchored = 2
	icon_state = "shuttle"