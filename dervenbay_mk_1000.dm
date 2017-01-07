/*
	These are simple defaults for your project.
 */

world
	fps = 25		// 25 frames per second
	icon_size = 32	// 32x32 icon size by default

	view = 6		// show up to 6 tiles outward from center (13x13 view)
	turf = /turf/space
	name = "AURORA"


// Make objects move 8 pixels per tick when walking

mob
	step_size = 32

obj
	step_size = 32


/world/New()

	master_controller = new /datum/controller/game_controller()

	radio_controller = new /datum/controller/radio()

	makepowernets()

	spawn(-1) master_controller.setup()
	return