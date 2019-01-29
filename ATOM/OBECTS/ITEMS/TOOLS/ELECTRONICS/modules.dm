/obj/item/module
	var/moduletype
	icon = 'module.dmi'
	icon_state = "central"

	basic_power_controller
		name = "basic power controller (APC and power systems)"
		moduletype = /datum/emodule/central/basic_power_controller

	flasher
		name = "flasher module"
		moduletype = /datum/emodule/central/flasher

	powerfull_power_controller
		name = "powerfull power controller (for industrial machines)"
		moduletype = /datum/emodule/central/powerfull_power_controller

	small_power_controller
		name = "small power controller (for small machines)"
		moduletype = /datum/emodule/central/small_power_controller

	cubit_mining_module
		name = "cubit mining module"
		var/obj/item/clothing/id/modulecard
		moduletype = /datum/emodule/central/cubit_mining

		attackby(obj/item/O as obj)
			if(istype(O, /obj/item/clothing/id))
				var/obj/item/clothing/id/ID = O
				usr << "//////// connecting to cubitcoin net ////////"
				sleep(rand(2,5))
				usr << "please wait..."
				sleep(rand(1,3))
				usr << "[ID.name] connected"
				usr << 'chime.ogg'

	power_alert_module
		name = "Alert module (rings if detected power)"
		moduletype = /datum/emodule/central/power_alert_module

	nopower_alert_module
		name = "Alert module (rings if not detected power)"
		moduletype = /datum/emodule/central/nopower_alert_module

	afterattack(atom/target, mob/user , flag)
		if(istype(target, /obj/machinery/lamp) && usr.do_after(15))
			var/obj/machinery/lamp/L = target
			var/moduletype2 = L.BPC.type
			name = L.BPC.name
			L.BPC = new moduletype(target)
			moduletype = moduletype2


			//cubit mining system
			if(istype(src, /obj/item/module/cubit_mining_module))
				var/obj/item/module/cubit_mining_module/CMM = src
				var/datum/emodule/central/cubit_mining/CB = L.BPC
				if(CMM.modulecard)
					CB.cardinit(CMM.modulecard)
			//cubit mining system

			usr << "lamp power module is replaced"
			var/mob/simulated/living/humanoid/H = usr
			H.drop_item_v()

		if(istype(target, /obj/machinery/simple_apc) && usr.do_after(25))
			var/obj/machinery/simple_apc/L = target
			var/moduletype2 = L.BPM.type
			name = L.BPM.name
			L.BPM = new moduletype(target)
			moduletype = moduletype2

			//cubit mining system
			if(istype(src, /obj/item/module/cubit_mining_module))
				var/obj/item/module/cubit_mining_module/CMM = src
				var/datum/emodule/central/cubit_mining/CB = L.BPM
				if(CMM.modulecard)
					CB.cardinit(CMM.modulecard)
			//cubit mining system

			usr << "APC power module is replaced"
			var/mob/simulated/living/humanoid/H = usr
			H.drop_item_v()

		if(istype(target, /obj/machinery/portable_machinery) && usr.do_after(25))
			var/obj/machinery/portable_machinery/L = target
			var/moduletype2 = L.socket_1.type
			name = L.socket_1.name
			L.socket_1 = new moduletype(target)
			moduletype = moduletype2

			//cubit mining system
			if(istype(src, /obj/item/module/cubit_mining_module))
				var/obj/item/module/cubit_mining_module/CMM = src
				var/datum/emodule/central/cubit_mining/CB = L.socket_1
				if(CMM.modulecard)
					CB.cardinit(CMM.modulecard)
			//cubit mining system

			usr << "machinery module is replaced"
			var/mob/simulated/living/humanoid/H = usr
			H.drop_item_v()

/obj/item/ai_module
	icon = 'tools.dmi'
	icon_state = "disc"
	var/datum/AI/ai

	monkeyAI
		name = "Monkey AI module"
		ai = /datum/AI/friends_animal/monkey

	patrolbot
		name = "patrolbot AI module"
		ai = /datum/AI/patrol_bots

	afterattack(atom/target, mob/user , flag)
		if(istype(target, /obj/machinery/portable_machinery) && usr.do_after(15))
			usr << "... loading program"
			sleep(rand(3,7))
			addai(target, ai)
