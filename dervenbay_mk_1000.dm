/*
	These are simple defaults for your project.
 */

world
	fps = 25		// 25 frames per second
	icon_size = 64	// 32x32 icon size by default

	view = 5		// show up to 6 tiles outward from center (13x13 view)
	turf = /turf/space
	map_format = ISOMETRIC_MAP


// Make objects move 8 pixels per tick when walking

mob
	step_size = 64

obj
	step_size = 64

	lobby
		icon = 'lobby.dmi'
		screen_loc = "0,0"
		layer = 60

/world/New()

	master_controller = new /datum/controller/game_controller()

	radio_controller = new /datum/controller/radio()

	makepowernets()

	hide_objs()

	spawn(-1) master_controller.setup()
	return