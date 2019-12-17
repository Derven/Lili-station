

turf
	icon = 'Turfs.dmi'
	name = ""

	var
		// Whether this tile should generate an occluder
		blocks_light = FALSE
		// Whether this tile should be lit by static floor lighting
		accepts_light = FALSE
		// Whether this tile marks a boundary on the map and doesn't need an occluder
		light_boundary = FALSE

		// How far into the wall the light should go (set to 0 for unlit walls)
		light_depth_north = 5
		light_depth_south = WORLD_ICON_HEIGHT
		light_depth_east = 5
		light_depth_west = 5

		// Vertical offset for wall surfaces
		light_offset_north = WORLD_ICON_HEIGHT
		light_offset_south = 0
		light_offset_east = WORLD_ICON_HEIGHT
		light_offset_west = WORLD_ICON_HEIGHT

	grid
		icon_state = "grid"
		//density = 1

	floors
		layer = LAYER_FLOOR
		#ifndef DISABLE_BLENDING
		blend_mode = BLEND_MULTIPLY
		#endif
		accepts_light = TRUE

		_randomized
			var/random_states = 0
			New()
				if(random_states)
					var/state = rand(1,random_states)
					if(state > 1)
						icon_state += "[state]"

		dirt
			parent_type = ._randomized
			icon_state = "dirt"
			random_states = 5

	walls
		icon = 'Wall.dmi'
		density = 1
		layer = LAYER_BACK_WALL
		#ifndef DISABLE_BLENDING
		blend_mode = BLEND_MULTIPLY
		#endif
		blocks_light = TRUE
		icon_state = "wall"
		var/join_type = /turf/walls

		New()
			if(join_type)
				AutoJoin()
			..()

		proc/AutoJoin()
			var/vbits = (istype(get_step(src,NORTH), join_type) && NORTH) \
			          | (istype(get_step(src,SOUTH), join_type) && SOUTH)
			var/hbits = 0

			if(!(vbits&NORTH))
				hbits = (istype(get_step(src,EAST), join_type) && EAST) \
				      | (istype(get_step(src,WEST), join_type) && WEST)
				var/image/I = image(icon=src.icon, icon_state="[src.icon_state][vbits|hbits|SOUTH]", layer=LAYER_BACK_WALL, pixel_y=WORLD_ICON_HEIGHT)
				I.blend_mode=src.blend_mode
				overlays += I
				overlays += image(icon=src.icon, icon_state="backing", layer=LAYER_BACK_WALL_BLACK, pixel_y=WORLD_ICON_HEIGHT)

			if(vbits&SOUTH)
				// If we have a wall below us, we're an "upper" tile and should be offset
				hbits = (istype(get_step(src,SOUTHEAST), join_type) && EAST) \
				      | (istype(get_step(src,SOUTHWEST), join_type) && WEST)
			else
				hbits = (istype(get_step(src,EAST), join_type) && EAST) \
				      | (istype(get_step(src,WEST), join_type) && WEST)

				layer = LAYER_FRONT_WALL

			icon_state = "[src.icon_state][vbits|hbits|NORTH]"
			overlays += image(icon=src.icon, icon_state="backing", layer=(layer==LAYER_BACK_WALL) ? LAYER_BACK_WALL_BLACK : LAYER_FRONT_WALL_BLACK)

		void
			name = ""
			icon = 'Void.dmi'
			icon_state = "opaque"
			//invisibility = 101
			density = 1
			opacity = 1
			layer = LAYER_UTILITY
			blocks_light = TRUE
			light_boundary = TRUE

			light_depth_north = 0
			light_depth_south = 0
			light_depth_east = 0
			light_depth_west = 0

			join_type = null

			New()
				icon_state = "black"
/*
		interior
			layer = LAYER_BACK_WALL_BLACK
			icon_state = "backing"
			blocks_light = TRUE
			light_depth_north = 0
			light_depth_south = 0
			light_depth_east = 0
			light_depth_west = 0

		frontA
			layer = LAYER_FRONT_WALL
			icon_state = "wall"
		frontB
			layer = LAYER_FRONT_WALL
			icon_state = "wall2"
		frontRight
			layer = LAYER_FRONT_WALL
			icon_state = "wallr"
		frontLeft
			layer = LAYER_FRONT_WALL
			icon_state = "walll"
		frontPillar
			layer = LAYER_FRONT_WALL
			icon_state = "wallb"

		back01
			icon_state = "wall1"
			density = 0
		back09
			icon_state = "wall9"
			density = 0
		back05
			icon_state = "wall5"
			density = 0
		back13
			icon_state = "wall13"
			density = 0

		back04/icon_state = "wall4"
		back08/icon_state = "wall8"

		triangle/icon_state = "triangle"
*/