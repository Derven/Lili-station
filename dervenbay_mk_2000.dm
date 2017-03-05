/*
	These are simple defaults for your project.
 */
#define DEBUG 1

world
	fps = 45		// 25 frames per second
	icon_size = 64	// 64x64 icon size by default

	view = 8		// show up to 8 tiles outward from center (13x13 view)
	turf = /turf/space
	map_format = ISOMETRIC_MAP
	hub = "SSting.SpaceCruiserAurora"

/mob
	step_size = 1

/world/New()

	master_controller = new /datum/controller/game_controller()

	radio_controller = new /datum/controller/radio()

	hide_objs()

	init_z_pixel()

	spawn(-1) master_controller.setup()
	return