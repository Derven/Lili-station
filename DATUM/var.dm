obj/effect/overlay/pl
	icon = 'effects.dmi'
	icon_state = "pl"
obj/effect/overlay/sl
	icon_state = "sl"
var/global
	obj/datacore/data_core = null
	obj/effect/overlay/pl/plmaster = null
	obj/effect/overlay/sl/slmaster = null
	list/obj/machinery/simple_smes/smes_powernet = list()

	//obj/hud/main_hud1 = null
	list/machines = list()
	list/processing_objects = list()
	list/active_diseases = list()
		//items that ask to be called every cycle

	defer_powernet_rebuild = 0		// true if net rebuild will be called manually after an event

	list/global_map = null
	//list/global_map = list(list(1,5),list(4,3))//an array of map Z levels.
	//Resulting sector map looks like
	//|_1_|_4_|
	//|_5_|_3_|
	//
	//1 - SS13
	//4 - Derelict
	//3 - AI satellite
	//5 - empty space
var
	Pixel_Height = 32

var/global/list/turf/landmarks = list()
var/global/list/turf/jobmarks = list()
var/list/screen_resolution = list("640x480", "800x600", "1024x768", "1280x1024", "1920x1080")
var

	datum/engine_eject/engine_eject_control = null
	list/alldirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

var/list/cardinal = list(SOUTH, NORTH, WEST, EAST, NORTHEAST, NORTHWEST, SOUTHWEST, SOUTHEAST)
var/list/visible_containers = list(/obj/structure/closet/closet_3, /obj/item/weapon/storage/box/toolbox, /obj/item/weapon/storage/box/medbox, /obj/item/weapon/storage/box)
