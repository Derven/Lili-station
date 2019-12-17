
// Local defines just for this file (undef'd at bottom)
#define _EDGE_SIZE 5
#define _BLOCK_SIZE 4
#define _ZONE_BOUNDARY ("-1")

#define _IDEPTH 3
#define _IOFFSET 4

#define _INDEX2D(x, y, width) (x + (y-1)*width)

proc
	// Process the tiles to identify occluder shapes and surfaces
	ProcessMapBlock(var/turf/min, var/turf/max)
		// Processing the map is done in the following steps:
		//   1) Find the outer edges of occluding tiles
		//   2) Merge collinear edges to get surfaces
		//   3) Connect the vertical edge pairs to get the occluder rectangles they define.
		//      Repeat with horizontal edge pairs and keep whichever results in fewer rectangles.

		// Get list of all turfs in the block
		var
			list/turfs = block(min, max)
			areaWidth = max.x - min.x + 1
			areaHeight = max.y - min.y + 1

		// Create a 2D array to track which tiles block light and which shape zone they're in
		// The array has padding on all sides so we don't have to bounds check, but this requires we +1 both coordinates when accessing it
		// Shape zones group occluding tiles into continous shapes so each shape can be processed individually
		var
			list/occlusionMap = new/list(areaWidth+2,areaHeight+2)
			localX = 0
			localY = 1
			zoneCounter = 1
			zone
			otherZone

		// Loop through all of our tiles, row by row
		for(localY = 1 to areaHeight)
			for(localX = 1 to areaWidth)
				var/turf/T = turfs[_INDEX2D(localX, localY, areaWidth)]
				if(T.light_boundary)
					// If this is a boundary tile, it's placed into a special zone that won't generate occluders
					occlusionMap[localX+1][localY+1] = _ZONE_BOUNDARY
					continue

				// Only tiles that block light are placed into zones
				if(!T.blocks_light) continue

				// Get the adjacent tiles
				var/turf/north = get_step(T, NORTH)
				var/turf/east = get_step(T, EAST)
				var/turf/south = get_step(T, SOUTH)
				var/turf/west = get_step(T, WEST)

				if((south && south.light_boundary) || (west && west.light_boundary) \
				    || (east && east.light_boundary) || (north && north.light_boundary))
					// If we're directly adjacent to a boundary tile, we're also in the boundary zone
					zone = _ZONE_BOUNDARY
				else
					// If we have a tile with a zone to our west or south, use that
					zone = occlusionMap[localX+1][localY+1-1]
					otherZone = occlusionMap[localX+1-1][localY+1]

					// Cannot join with boundary zones unless we're directly adjacent to the source tile
					if(zone == _ZONE_BOUNDARY) zone = null
					if(otherZone == _ZONE_BOUNDARY) otherZone = null

					if(zone && otherZone && zone != otherZone)
						// Two zones meet at this tile, we'll need to merge them since they're a part of one continous shape
						// TODO: move outside of this loop so we only go through the list once to merge them all
						// Starting at the current row, work backwards swapping any otherZones for zone
						var/foundInRow
						for(var/yy = localY, yy > 0, yy--)
							foundInRow = FALSE
							for(var/xx = 1, xx <= areaWidth, xx++)
								if(occlusionMap[xx+1][yy+1] == otherZone)
									foundInRow = TRUE
									occlusionMap[xx+1][yy+1] = zone
							// If we searched an entire row and didn't find any otherZone, there can't be any more (since they have to be continous)
							if(!foundInRow) break
					else if(otherZone)
						zone = otherZone

					// If no zone was found, create a new one
					if(!zone)
						// Zones stored as text so they can be used as indexes in the associative lists for the edges
						zone = "[zoneCounter++]"

				occlusionMap[localX+1][localY+1] = zone

		// Search the array for tiles that block light that have unset adjacent tiles. These are our edges
		// We store the edges in separate lists based on the direction of their normal
		var
			// Associative lists of L[zone] = list(x1, yStart1, yEnd1, depth1, offset1,  x2, yStart2, yEnd2, depth2, offset2, ...)
			list/northEdges = list()
			list/southEdges = list()
			list/eastEdges = list()
			list/westEdges = list()

		// Loop through every tile in the occlusionMap array, row by row
		for(localY = 1 to areaHeight)
			for(localX = 1 to areaWidth)

				zone = occlusionMap[localX+1][localY+1]
				if(zone)
					var/turf/T = turfs[localX + (localY-1)*areaWidth]

					// Check each adjacent zone, if it's not set we found an edge
					// If

					// West
					otherZone = occlusionMap[localX+1-1][localY+1]
					if(!otherZone || (zone != _ZONE_BOUNDARY && otherZone == _ZONE_BOUNDARY))
						westEdges[zone] += list(localX, localY, localY+1, \
						                        (otherZone == _ZONE_BOUNDARY) ? 0 : T.light_depth_west, \
						                        T.light_offset_west)

					// East
					otherZone = occlusionMap[localX+1+1][localY+1]
					if(!otherZone || (zone != _ZONE_BOUNDARY && otherZone == _ZONE_BOUNDARY))
						eastEdges[zone] += list(localX+1, localY, localY+1, \
						                        (otherZone == _ZONE_BOUNDARY) ? 0 : T.light_depth_east, \
						                        T.light_offset_east)

					// South
					otherZone = occlusionMap[localX+1][localY+1-1]
					if(!otherZone || (zone != _ZONE_BOUNDARY && otherZone == _ZONE_BOUNDARY))
						southEdges[zone] += list(localY, localX, localX+1, \
						                        (otherZone == _ZONE_BOUNDARY) ? 0 : T.light_depth_south, \
						                        T.light_offset_south)

					// North
					otherZone = occlusionMap[localX+1][localY+1+1]
					if(!otherZone || (zone != _ZONE_BOUNDARY && otherZone == _ZONE_BOUNDARY))
						northEdges[zone] += list(localY+1, localX, localX+1, \
						                        (otherZone == _ZONE_BOUNDARY) ? 0 : T.light_depth_north, \
						                        T.light_offset_north)

		// Generate blocks and surfaces separately for each zone
		for(zone in northEdges)
			var/list
				north = northEdges[zone]
				south = southEdges[zone]
				east = eastEdges[zone]
				west = westEdges[zone]

			// Merge any collinear edges
			MergeEdges(north)
			MergeEdges(south)
			MergeEdges(east)
			MergeEdges(west)

			// Create the surfaces
			var
				length
				left

			// North
			for(var/i = 1 to north.len step _EDGE_SIZE)
				// Skip surfaces with a depth of 0 (boundary turfs)
				if(north[i+_IDEPTH] != 0)
					left = north[i+1]
					length = north[i+2] - left
					// Split surfaces if they are too long
					while(length > MAX_SURFACE_LENGTH)
						new/Surface/Static(locate(left+min.x-1, north[i]+min.y-2, min.z), \
						            0, 1, \
						            MAX_SURFACE_LENGTH, 1, \
						            north[i+_IDEPTH], north[i+_IOFFSET])
						length -= MAX_SURFACE_LENGTH
						left += MAX_SURFACE_LENGTH
					new/Surface/Static(locate(left+min.x-1, north[i]+min.y-2, min.z), \
					            0, 1, \
					            length, 1, \
					            north[i+_IDEPTH], north[i+_IOFFSET])

			// South
			for(var/i = 1 to south.len step _EDGE_SIZE)
				// Skip surfaces with a depth of 0 (boundary turfs)
				if(south[i+_IDEPTH] != 0)
					left = south[i+2]
					length = left - south[i+1]
					// Split surfaces if they are too long
					while(length > MAX_SURFACE_LENGTH)
						new/Surface/Static(locate(left+min.x-2, south[i]+min.y-1, min.z), \
						            1, 0, \
						            1 - MAX_SURFACE_LENGTH, 0, \
						            south[i+_IDEPTH], south[i+_IOFFSET], LAYER_FRONT_WALL_DYNAMIC_LIGHT)
						length -= MAX_SURFACE_LENGTH
						left -= MAX_SURFACE_LENGTH
					new/Surface/Static(locate(left+min.x-2, south[i]+min.y-1, min.z), \
					            1, 0, \
					            1 - length, 0, \
					            south[i+_IDEPTH], south[i+_IOFFSET], LAYER_FRONT_WALL_DYNAMIC_LIGHT)

			// East
			for(var/i = 1 to east.len step _EDGE_SIZE)
				// Skip surfaces with a depth of 0 (boundary turfs)
				if(east[i+_IDEPTH] != 0)
					left = east[i+2]
					length = left - east[i+1]
					// Split surfaces if they are too long
					while(length > MAX_SURFACE_LENGTH)
						new/Surface/Static(locate(east[i]+min.x-2, left+min.y-2, min.z), \
						            1, 1, \
						            1, 1 - MAX_SURFACE_LENGTH, \
						            east[i+_IDEPTH], east[i+_IOFFSET])
						length -= MAX_SURFACE_LENGTH
						left -= MAX_SURFACE_LENGTH

					new/Surface/Static(locate(east[i]+min.x-2, left+min.y-2, min.z), \
					            1, 1, \
					            1, 1 - length, \
					            east[i+_IDEPTH], east[i+_IOFFSET])

			// West
			for(var/i = 1 to west.len step _EDGE_SIZE)
				// Skip surfaces with a depth of 0 (boundary turfs)
				if(west[i+_IDEPTH] != 0)
					left = west[i+1]
					length = west[i+2] - left
					// Split surfaces if they are too long
					while(length > MAX_SURFACE_LENGTH)
						new/Surface/Static(locate(west[i]+min.x-1, left+min.y-1, min.z), \
						            0, 0, \
						            0, MAX_SURFACE_LENGTH, \
						            west[i+_IDEPTH], west[i+_IOFFSET])
						length -= MAX_SURFACE_LENGTH
						left += MAX_SURFACE_LENGTH
					new/Surface/Static(locate(west[i]+min.x-1, left+min.y-1, min.z), \
					            0, 0, \
					            0, length, \
					            west[i+_IDEPTH], west[i+_IOFFSET])

			// Create the occluders (if this isn't a boundary zone
			if(zone != _ZONE_BOUNDARY)
				// Try connecting the edges to generate occluding rectangles
				var/list/verticalBlocks = ConnectEdges(south, north)
				var/list/horizontalBlocks = ConnectEdges(west, east)

				// Use whichever resulted in fewer blocks
				var/list/occluderBlocks = horizontalBlocks
				if(verticalBlocks.len < horizontalBlocks.len)
					// Use vertical blocks instead, but their coordinates are transposed, so flip them back
					var/temp
					for(var/i = 1 to verticalBlocks.len step _BLOCK_SIZE)
						temp = verticalBlocks[i]
						verticalBlocks[i] = verticalBlocks[i+1]
						verticalBlocks[i+1] = temp
						temp = verticalBlocks[i+2]
						verticalBlocks[i+2] = verticalBlocks[i+3]
						verticalBlocks[i+3] = temp

					occluderBlocks = verticalBlocks

				// Create each occluder
				var
					occluderX
					occluderY
					occluderWidth
					occluderHeight
				for(var/i = 1 to occluderBlocks.len step _BLOCK_SIZE)
					occluderX = occluderBlocks[i]
					occluderWidth = occluderBlocks[i+2]
					while(occluderWidth > 0)
						occluderY = occluderBlocks[i+1]
						occluderHeight = occluderBlocks[i+3]
						while(occluderHeight > 0)
							new/Occluder/Rectangle(locate(occluderX+min.x-1, occluderY+min.y-1, min.z), \
							                       min(occluderWidth, MAX_OCCLUDER_WIDTH), \
							                       min(occluderHeight,MAX_OCCLUDER_HEIGHT))
							occluderHeight -= MAX_OCCLUDER_HEIGHT
							occluderY += MAX_OCCLUDER_HEIGHT
						occluderWidth -= MAX_OCCLUDER_WIDTH
						occluderX += MAX_OCCLUDER_WIDTH


proc
	// Alters the provided list to merge any collinear edges
	MergeEdges(list/edges)
		var/index = 1
		while(index < edges.len)
			// Search forward for any edges we can merge with this one
			var/compare = index+_EDGE_SIZE
			while(compare < edges.len)
				// If we've reached edges with a starting-y greater than our ending-y, there aren't any more we can merge
				if(edges[index+2] < edges[compare+1]) break
				// Check if we can merge these edges (on the same axis, adjacent, and depth/offset settings match)
				if(edges[index] == edges[compare] && edges[index+2] == edges[compare+1] \
				   && edges[index+_IDEPTH] == edges[compare+_IDEPTH] && edges[index+_IOFFSET] == edges[compare+_IOFFSET])
					// Extend our edge to the other's end
					edges[index+2] = edges[compare+2]
					// Remove the other edge
					edges.Cut(compare, compare+_EDGE_SIZE)
				else
					// Move to the next comparison edge if we didn't remove the current one
					compare += _EDGE_SIZE

			// Move to the next source edge
			index += _EDGE_SIZE

	// Given a list of edges, attempt to connect them to generate blocks
	ConnectEdges(list/openingEdgesSource, list/closingEdges)
		var
			// List of generated blocks in form of (x, y, width, height)
			// Will be transposed for horizontal edges (vertical blocks)
			list/blocks = list()
			list/openingEdges = openingEdgesSource.Copy()
			openX
			openYStart
			openYEnd
			closeX
			closeYStart
			closeYEnd
			minCloseX
			minCloseYStart
			minCloseYEnd

		// For each opening edge
		var/open = 1
		while(open < openingEdges.len)
			openX = openingEdges[open]
			openYStart = openingEdges[open+1]
			openYEnd = openingEdges[open+2]
			minCloseX = 0
			// Try to find the nearest matching closing edge
			for(var/close = 1 to closingEdges.len step _EDGE_SIZE)
				closeX = closingEdges[close]
				if(closeX <= openX) continue
				closeYStart = closingEdges[close+1]
				closeYEnd = closingEdges[close+2]

				// If it overlaps and is closer than the current min
				if(closeYStart < openYEnd && closeYEnd > openYStart && (!minCloseX || closeX < minCloseX))
					// Store it as our current best candidate
					minCloseX = closeX
					minCloseYStart = closeYStart
					minCloseYEnd = closeYEnd

				// Once past opening edge, don't need to search any further
				if(closeYStart > openYEnd)
					if(!minCloseX) CRASH("Did not find closing edge for [openX],[openYStart] to [openX],[openYEnd] (output coords transposed for horz edges)")
					break

			// If the closing edge doesn't cover the whole opening edge, reduce its size and process it again
			if(minCloseYStart > openYStart)
				// Add the block that is closed
				blocks.Add(openX, closeYStart, minCloseX-openX, minCloseYEnd - closeYStart)
				// Shorten the edge and we'll process it again for the lower block it defines
				openingEdges[open+2] = minCloseYStart
				if(minCloseYEnd < openYEnd)
					// Closing edge splits the opening edge into 3+ blocks, so insert a new opening edge for the upper block
					openingEdges.Insert(open+_EDGE_SIZE, openX, minCloseYEnd, openYEnd, 0, 0)
					ASSERT(_EDGE_SIZE == 5) // Make sure to keep insert above in sync with edge structure
			else if(minCloseYEnd < openYEnd)
				// Add the lower block that is closed
				blocks.Add(openX, openYStart, minCloseX-openX, minCloseYEnd - openYStart)
				// Shorten the edge and we'll process it again for the upper block it defines
				openingEdges[open+1] = minCloseYEnd
			else
				blocks.Add(openX, openYStart, minCloseX-openX, openYEnd - openYStart)
				// Edge completely closed, move on
				open += _EDGE_SIZE

		return blocks

#undef _BLOCK_SIZE
#undef _EDGE_SIZE
#undef _ZONE_BOUNDARY
#undef _IDEPTH
#undef _IOFFSET
#undef _INDEX2D
