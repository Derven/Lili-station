
var/list/obj/smart_cable/cables_plus = list()

/obj/smart_cable
	var/obj/item/weapon/cable_web/parent
	icon = 'power.dmi'
	icon_state = "smart_coil"
	layer = 2.5
	anchored = 1

	New(loc, var/obj/item/weapon/cable_web/Parent)
		parent = Parent
		cables_plus += src
		for(var/obj/smart_cable/SC in orange(1,src))
			SC.upd()
		upd()
		for(var/obj/power_socket/PW in src.loc)
			PW.connect(src)
		..()

	attackby(var/obj/item/weapon/W as obj)
		if(istype(W, /obj/item/weapon/cable_web))
			var/obj/item/weapon/cable_web/AW = W
			for(var/obj/smart_cable/SM in cables_plus)
				if(SM.parent == parent && SM != src)
					AW.amount += 1
					del(SM)

			AW.amount += 1
			del(src)

	proc/check_parent(var/obj/smart_cable/SC)
		if(SC.parent == parent)
			return 1
		else
			return 0


	proc/upd()

		var/mydir = ""
		var/turf/south = get_step(src, SOUTH)
		var/turf/north = get_step(src, NORTH)
		var/turf/west = get_step(src, WEST)
		var/turf/east = get_step(src, EAST)

		for(var/obj/smart_cable/SC in south)
			if(check_parent(SC))
				mydir += "south"

		for(var/obj/smart_cable/SC in north)
			if(check_parent(SC))
				mydir += "north"

		for(var/obj/smart_cable/SC in west)
			if(check_parent(SC))
				mydir += "west"

		for(var/obj/smart_cable/SC in east)
			if(check_parent(SC))
				mydir += "east"

		if(mydir == "southnorth")
			icon_state = "sn"

		if(mydir == "westeast")
			icon_state = "we"

		if(mydir == "southnorthwest")
			icon_state = "wsn"

		if(mydir == "southnortheast")
			icon_state = "esn"

		if(mydir == "southwesteast")
			icon_state = "swe"

		if(mydir == "northwesteast")
			icon_state = "nwe"

		if(mydir == "northeast")
			icon_state = "ne"

		if(mydir == "southeast")
			icon_state = "se"

		if(mydir == "southwest")
			icon_state = "sw"

		if(mydir == "northwest")
			icon_state = "nw"

		if(mydir == "north")
			icon_state = "sn"

		if(mydir == "south")
			icon_state = "sn"

		if(mydir == "west")
			icon_state = "we"

		if(mydir == "east")
			icon_state = "we"

/obj/item/weapon/cable_web
	var/amount = 10
	var/turf/simulated/floor/point_of_charge
	var/turf/simulated/floor/last_loc
	var/obj/machinery/machine
	var/obj/smart_cable/SM

	anchored = 1
	icon = 'power.dmi'
	icon_state = "coil_red"

	proc/check_socket()
		for(var/obj/machinery/M in point_of_charge)
			machine = M

	New()
		point_of_charge = src.loc
		last_loc = point_of_charge
		..()

	pickup()
		if(!machine)
			check_socket()

		if(amount > 0)
			SM = new(last_loc, src)
			amount -= 1
			brat << "\blue Вы т&#255;нете кабель! Турум-пум-пам!"
			usr.drop_item_v()
		else
			for(var/obj/smart_cable/SM in cables_plus)
				if(SM.parent == src)
					amount += 1
					del(SM)
			brat << "\red Кабель раст&#255;нулс&#255; на максимум и отскочил назад"
			usr.drop_item_v()
			last_loc = point_of_charge
			Move(point_of_charge)

	dropped()
		last_loc = src.loc

/obj/power_socket
	icon = 'power.dmi'
	icon_state = "socket"
	anchored = 1
	var/obj/machinery/slot
	var/obj/item/weapon/cable_web/CB

	attack_hand()
		if(slot && CB)
			disconnect()

	proc/connect(var/obj/smart_cable/SM)
		if(!slot)
			SM.parent.machine.switcher = 1
			for(var/mob/M in range(3, src))
				M << "[SM.parent.machine] подключен к сети!"
			slot = SM.parent.machine
			CB = SM.parent
			CB.invisibility = 101
		else
			for(var/mob/M in range(3, src))
				M << "\red Попытка подключить [SM.parent.machine] к сети сорвалась! Розетка не имеет свободных портов!"

	proc/disconnect()
		CB.machine.switcher = 0
		for(var/mob/M in range(3, src))
			M << "[CB.machine] отключен от сети!"
		slot = null
		CB.invisibility = 0
		CB = null