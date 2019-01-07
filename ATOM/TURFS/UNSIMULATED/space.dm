/turf/space
	icon = 'space.dmi'
	name = "space"
	icon_state = "placeholder"
	luminosity = 1
	layer = 0.5
	color = "#2a4347"

	oxygen = 0
	nitrogen = 0
	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 700000

/turf/space/New()
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"

/turf/space/moving_space
	icon = 'space.dmi'
	name = "space"
	icon_state = "moving_space"
	luminosity = 1
	layer = 0.5

/turf/space/moving_space/New()
	icon_state = "moving_space"