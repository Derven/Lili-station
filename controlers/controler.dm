var/global/datum/controller/game_controller/master_controller //Set in world.New()
var/global/controllernum = "no"

datum/controller/game_controller
	var/processing = 1

	proc
		setup()
		setup_objects()
		process()

	setup()
		if(master_controller && (master_controller != src))
			del(src)
			return
			//There can be only one master.

		if(!air_master)
			air_master = new /datum/controller/air_system()
			air_master.setup()

		world.tick_lag = 0.9

		setup_objects()

		if(!ticker)
			ticker = new /datum/controller/gameticker()

	setup_objects()
		world << "\red \b Initializing objects"
		sleep(-1)

		for(var/obj/object in world)
			object.initialize()

		world << "\red \b Initializing pipe networks"
		sleep(-1)

		for(var/obj/machinery/atmospherics/machine in world)
			machine.build_network()

		world << "\red \b Initializing atmos machinery."
		sleep(-1)
		for(var/obj/machinery/atmospherics/unary/vent_pump/T in world)
			T.broadcast_status()
		for(var/obj/machinery/atmospherics/unary/vent_scrubber/T in world)
			T.broadcast_status()

		world << "\red \b Initializations complete."

	process()

		if(!processing)
			return 0
		controllernum = "yes"
		spawn (100) controllernum = "no"

		var/start_time = world.timeofday

		air_master.process()

		sleep(-1)

		for(var/mob/M in world)
			M.Life()
		//for(var/datum/disease/D in active_diseases)
		//	D.process()

		for(var/obj/machinery/machine in machines)
			if(machine)
				if(machine.switcher == 1 || !machine.use_power)
					machine.process()
				if(machine && machine.use_power)
					machine.auto_use_power()

		sleep(1)

		for(var/obj/object in processing_objects)
			object.process()

		for(var/datum/pipe_network/network in pipe_networks)
			network.process()

		for(var/datum/powernet/P in powernets)
			P.reset()

		//ticker.process()

		sleep(world.timeofday+10-start_time)

		spawn process()


		return 1

	New()
		..()
		spawn master_controller.process()