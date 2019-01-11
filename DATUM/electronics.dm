var/list/electronics = list()

/datum/emodule
	var/name = "module"
	var/obj/owner

	New(var/obj/machinery/M)
		..()
		owner = M

	proc/act()

	central
		var/datum/emodule/logic/logic_socket
		var/datum/emodule/sensor/sensor_socket
		var/datum/emodule/other/other_socket

		proc/myprocess()
			if(logic_socket.process_signal(sensor_socket.get_signal()))
				return other_socket.act()
			else
				return 0

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
				owner = M
				FL = new(owner)

			act()
				spawn(65)
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