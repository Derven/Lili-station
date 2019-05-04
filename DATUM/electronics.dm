var/list/electronics = list()

/obj/machinery/electronic_creator
	icon = 'stationobjs.dmi'
	icon_state = "electronic_machine"
	density = 1
	anchored = 1

	var/logic
	var/sensor
	var/other

	proc/initme()
		var/body = {"
		<html>
		<head><link rel=\"stylesheet\" href=\"https://unpkg.com/purecss@1.0.0/build/pure-min.css\" integrity=\"sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w\" crossorigin=\"anonymous\"><title>Electronic builder</title></head>
		<body>
		<h1>Logic sockets</h1>
		<hr>
		<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];logsoc=basic'>Basic(1 = 1, 1 != 0, 0 = 0)</a><br><br>
		<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];logsoc=reverse'>Invert(1 = 0, 1 != 1, 0 = 1)</a><br><br>
		<br>
		<h1>Sensor sockets</h1>
		<hr>
		<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];sensoc=power'>Power</a><br><br>
		<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];sensoc=temperature'>Temperature(< 180, > 360)</a><br><br>
		<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];sensoc=human'>Human(2 tiles)</a><br><br>
		<br>
		<h1>Other sockets</h1>
		<hr>
		<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];othsoc=powercontrol'>Power controller(1000v)</a><br><br>
		<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];othsoc=alert'>Alert module</a><br><br>
		<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];othsoc=flash'>Flash module</a><br><br>
		<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];othsoc=battery'>Backup battery</a><br><br>
		<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];othsoc=shocker'>Shocker</a><br><br>
		<br>
		<h1>Control panel</h1>
		<hr>
		<a class=\"pure-button pure-button-primary\"  href='?src=\ref[src];exit=yes'>exit</a><br><br>
		<br>
		<br>
		logic socket: [logic ? "Full" : "Empty"]
		<br>
		sensor socket: [sensor ? "Full" : "Empty"]
		<br>
		other socket: [other ? "Full" : "Empty"]
		</body></html>
		"}
		return body

	attack_hand()
		usr << browse(initme(), "window=electronic")

	Topic(href, href_list)
		if(usr.check_topic(src))
			if(href_list["logsoc"] == "basic")
				logic = /datum/emodule/logic/basic
			if(href_list["logsoc"] == "reverse")
				logic = /datum/emodule/logic/negative


			if(href_list["sensoc"] == "power")
				sensor = /datum/emodule/sensor/power_sensor
			if(href_list["sensoc"] == "temperature")
				sensor = /datum/emodule/sensor/temperature_sensor
			if(href_list["sensoc"] == "human")
				sensor = /datum/emodule/sensor/human_sensor


			if(href_list["othsoc"] == "powercontrol")
				other = /datum/emodule/other/basic_power_controller
			if(href_list["othsoc"] == "alert")
				other = /datum/emodule/other/alertmodule
			if(href_list["othsoc"] == "flash")
				other = /datum/emodule/other/flash_module
			if(href_list["othsoc"] == "battery")
				other = /datum/emodule/other/backup_battery
			if(href_list["othsoc"] == "shocker")
				other = /datum/emodule/other/shockwave

			if(logic != null && sensor != null && other != null)
				var/datum/emodule/LOGIC = new logic()
				var/datum/emodule/SENSOR = new sensor()
				var/datum/emodule/OTHER = new other()
				var/datum/emodule/central/CRAFTCURCUIT = new /datum/emodule/central()
				CRAFTCURCUIT.logic_socket = LOGIC
				CRAFTCURCUIT.sensor_socket = SENSOR
				CRAFTCURCUIT.other_socket = OTHER
				var/obj/item/module/MDLE = new /obj/item/module(src.loc)
				MDLE.craftmodule = CRAFTCURCUIT
				MDLE.craftmodule.name = "craftmodule"
				attack_hand(usr)
				logic = null
				sensor = null
				other = null
			else
				attack_hand(usr)



/datum/emodule
	var/name = "module"
	var/obj/owner

	New(var/obj/machinery/M)
		..()
		if(istype(M, /obj/machinery))
			owner = M
		else
			return

	proc/act()

	central
		var/datum/emodule/logic/logic_socket
		var/datum/emodule/sensor/sensor_socket
		var/datum/emodule/other/other_socket

		proc/myprocess()
			if(src in electronics)
				if(logic_socket.process_signal(sensor_socket.get_signal()))
					return other_socket.act()
				else
					return 0

		proc/owneractivate(var/obj/machinery/M)
			owner = M
			electronics += src
			logic_socket.owner = M
			sensor_socket.owner = M
			other_socket.owner = M

		basic_power_module
			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/basic(M)
				sensor_socket = new /datum/emodule/sensor/power_sensor(M)
				other_socket = new /datum/emodule/other/basic_processing_controller(M)
				..()

		emergency_power_module
			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/negative(M)
				sensor_socket = new /datum/emodule/sensor/power_sensor(M)
				other_socket = new /datum/emodule/other/basic_processing_controller(M)
				..()

		basic_power_controller
			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/basic(M)
				sensor_socket = new /datum/emodule/sensor/power_sensor(M)
				other_socket = new /datum/emodule/other/basic_power_controller(M)
				..()

		powerfull_power_controller
			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/basic(M)
				sensor_socket = new /datum/emodule/sensor/power_sensor(M)
				other_socket = new /datum/emodule/other/basic_power_controller/powerful_power_controller(M)
				..()

		small_power_controller
			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/basic(M)
				sensor_socket = new /datum/emodule/sensor/power_sensor(M)
				other_socket = new /datum/emodule/other/basic_power_controller/small_power_controller(M)
				..()

		power_alert_module
			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/basic(M)
				sensor_socket = new /datum/emodule/sensor/power_sensor(M)
				other_socket = new /datum/emodule/other/alertmodule(M)
				..()

		nopower_alert_module
			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/negative(M)
				sensor_socket = new /datum/emodule/sensor/power_sensor(M)
				other_socket = new /datum/emodule/other/alertmodule(M)
				..()

		temperature_alert_module
			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/basic(M)
				sensor_socket = new /datum/emodule/sensor/temperature_sensor(M)
				other_socket = new /datum/emodule/other/alertmodule(M)
				..()

		nopower_backup_battery
			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/negative(M)
				sensor_socket = new /datum/emodule/sensor/power_sensor(M)
				other_socket = new /datum/emodule/other/backup_battery(M)
				..()

		flasher
			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/basic(M)
				sensor_socket = new /datum/emodule/sensor/human_sensor(M)
				other_socket = new /datum/emodule/other/flash_module(M)
				..()

		fuel_module
			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/negative(M)
				sensor_socket = new /datum/emodule/sensor/fuel_analyzer(M)
				other_socket = new /datum/emodule/other/fuelalert(M)
				..()

		cubit_mining

			proc/cardinit(var/obj/item/clothing/id/mycard1)
				var/datum/emodule/other/cubit_mining_module/CBM = other_socket
				CBM.mycard = mycard1
				other_socket = CBM

			New(var/obj/machinery/M)
				owner = M
				electronics += src
				logic_socket = new /datum/emodule/logic/basic(M)
				sensor_socket = new /datum/emodule/sensor/power_sensor(M)
				other_socket = new /datum/emodule/other/cubit_mining_module(M)
				..()


	logic
		proc/process_signal(var/signal)
			return signal

		basic
			name = "conductor"

		negative
			name = "negative"
			process_signal(var/signal)
				return !signal

	sensor
		proc/get_signal()
			var/condition = 1
			if(condition)
				return 1
			else
				return 0

		power_sensor
			name = "power sensor"

			get_signal()
				var/obj/machinery/power = owner
				if(power.charge > 0)
					return 1
				else
					if(power.charge < 0)
						power.charge = 0
					return 0

		signal_generator
			get_signal()
				return 1

		temperature_sensor
			name = "temperature sensor"
			var/min = 180
			var/max = 360

			get_signal()
				var/obj/power = owner
				var/turf/simulated/floor/PLOC = power.loc
				var/datum/gas_mixture/environment = PLOC.return_air()
				if(environment.temperature > max || environment.temperature < min)
					return 1
				else
					return 0

		human_sensor
			name = "flash sensor"

			get_signal()
				for(var/mob/simulated/living/humanoid/H in range(owner,2))
					return 1
				return 0

		fuel_analyzer
			name = "fuel sensor"
			get_signal()
				var/obj/machinery/fuelstorage/power = owner
				if(power.fuel > 20)
					return 1
				else
					if(power.fuel < 0)
						power.fuel = 0
					return 0


	other
		basic_processing_controller
			name = "basic processing controller"
			act()
				return 1

		cubit_mining_module
			name = "cubit mining module"
			var/obj/item/clothing/id/mycard
			act()
				var/obj/machinery/power = owner
				power.use_power = 1
				if(power.charge && mycard)
					power.load = rand(3000, 5000)
					mycard.cubits += rand(2,3)
				return 1

		basic_power_controller
			name = "basic processing controller"
			var/max_charge = 1000
			act()
				var/obj/machinery/power = owner
				if(power.charge > max_charge)
					power.charge = max_charge
				return 1

			powerful_power_controller
				max_charge = 10000

			small_power_controller
				max_charge = 500

		alertmodule
			name = "radiocontroller"
			var/soundpower = 5
			act()
				var/obj/power = owner
				spawn(125)
					for(var/mob/M in range(soundpower, power))
						M << 'airraid.ogg'
					return 1

		shockwave
			name = "shockersuper"
			act()
				for(var/mob/simulated/living/humanoid/M in range(2, owner))
					M.rand_damage(8, 12)
					M << 'sparks.ogg'
				new /obj/effect/sparks(owner.loc)

				return 1

		fuelalert
			name = "for ship fuel"
			var/soundpower = 8
			act()
				var/obj/machinery/fuelstorage/power = owner
				for(var/mob/M in range(soundpower, power))
					M << "\red ship computer: Warning! Fuel level [power.fuel]"
				return 1

		flash_module
			name = "flashmodule"
			var/obj/machinery/flasher/FL

			New(var/obj/machinery/M)
				..()
				if(M)
					owner = M
					FL = new(owner)

			act()
				if(owner && FL == null)
					FL = new(owner)
				FL.flash_me_please()
				return 1

		movement_module
			act()
				if(owner.anchored == 0)
					spawn(35)
					owner.Move(get_step(owner,pick(NORTH, SOUTH, WEST, EAST, NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST)))
				return 1

		backup_battery
			name = "backup_battery"
			var/inner_power = 35000
			act()
				var/obj/machinery/power = owner
				power.charge += 800
				inner_power -= 800
				return 1

/datum/idchecker
	var/obj/machine = null
	var/list/iddata = list()
	var/stat = 1

	proc/check_id(var/obj/item/clothing/id/id)
		if(stat)
			for(var/idtype in iddata)
				for(var/idtype2 in id.myids)
					if(idtype == idtype2)
						return 1
			return 0

proc/add_idchecker(var/obj/myloc, var/ids)
	var/datum/idchecker/IDCHECK = new(myloc)
	IDCHECK.machine = myloc
	for(var/id in ids)
		IDCHECK.iddata.Add(id)
	return IDCHECK

/datum/id
	assistant
	security
	captain
	doctor