var/tmp/list/SPATIAL_GRIDS = list()

proc
	GetSpatialGrid(z)
		if(SPATIAL_GRIDS.len < z) SPATIAL_GRIDS.len = z
		if(!SPATIAL_GRIDS[z])
			SPATIAL_GRIDS[z] = new/SpatialGrid(locate(1,1,z),locate(world.maxx, world.maxy, z), \
			                                   SPATIAL_GRID_CELL_SIZE, SPATIAL_GRID_CELL_SIZE, \
			                                   LIGHT_RADIUS, LIGHT_RADIUS)
		return SPATIAL_GRIDS[z]

SpatialGrid
	var
		// How many world tiles the grid covers
		gridWidth
		gridHeight
		// How many cell columns/rows to split the area into
		columns
		rows
		// The width/height in tiles of each cell, not including overlap
		cellWidth
		cellHeight
		// How much each cell overlaps into its neighbors (search areas smaller than overlap are optimized)
		overlapTilesX
		overlapTilesY
		// A list containing COL*ROW lists for each cell, index can be null if cell is empty
		list/cells
	New(turf/bottomLeft, turf/topRight, cellWidth, cellHeight, overlapTilesX=0, overlapTilesY=0)
		src.gridWidth = topRight.x - bottomLeft.x + 1
		src.gridHeight = topRight.y - bottomLeft.y + 1
		src.cellWidth = cellWidth
		src.cellHeight = cellHeight
		src.columns = CEIL(gridWidth / cellWidth)
		src.rows = CEIL(gridHeight / cellHeight)
		src.overlapTilesX = overlapTilesX
		src.overlapTilesY = overlapTilesY
		src.cells = new/list(columns*rows)
		//world.log << "Created grid of [columns]x[rows] ([columns*rows]), [gridWidth],[cellWidth]"
	proc
		// Add a new entry 'a' to the grid, positioned at <x,y> with dimensions wxh (in tiles)
		Add(a, x, y, w, h)
			// Bottom-left of 'a' is positioned at <x,y>, with dimensions wxh
			// x = 1 is left edge of map, x = 1.5 is center of left-most tile, x = 2 is right edge of left-most tile
			// Determine how many cells the object intersects, and add it to each
			var
				colStart = max(1, 1 + round((x - 1 - overlapTilesX)/cellWidth))
				colEnd   = min(columns, CEIL((x - 1 + w + overlapTilesX)/cellWidth))
				rowStart = max(1, 1 + round((y - 1 - overlapTilesY)/cellHeight))
				rowEnd   = min(rows, CEIL((y - 1 + h + overlapTilesY)/cellHeight))
				cellIndex
				list/cellList
			// TODO: Unroll loops for 1-cell, 2-cell, and 4-cell cases? Profile and see.
			for(var/row = rowStart to rowEnd step 1)
				cellIndex = (row-1) * columns + colStart
				for(var/col = colStart to colEnd step 1)
					if (!cells[cellIndex]) cells[cellIndex] = list(a)
					else
						cellList = cells[cellIndex]
						cellList[++cellList.len] = a
					++cellIndex

		Remove()
			#warn IMPLEMENT SpatialGrid::Remove

		// Reallocates all internal lists to reduce their capacity to the minimum required
		Trim()

		// Return all objects that may overlap the area <x,y> (wxh)
		// If wxh is within the grid overlap, the search can be optimized
		// NOTE: DO NOT MODIFY THE RETURNED LIST, may return a reference to an internal list
		// NOTE: May return null or list(null) if there are no objects in the area
		Search(x,y, w,h)
			// If the search area is less than the overlap, it's guaranteed to be contained in one cell
			if (w <= overlapTilesX && h <= overlapTilesY)
				//world.log << "[x],[y] [w]x[h] == [1+round((x-1)/cellWidth)],[(1+round((y-1)/cellHeight))] == [(1+round((x-1)/cellWidth))*columns + (1+round((y-1)/cellHeight))]"
				return cells[(round((y-1)/cellHeight))*columns + (1+round((x-1)/cellWidth))]

			var
				colStart = max(1, 1 + round((x - 1)/cellWidth))
				colEnd   = min(columns, CEIL((x - 1 + w)/cellWidth))
				rowStart = max(1, 1 + round((y - 1)/cellHeight))
				rowEnd   = min(rows, CEIL((y - 1 + h)/cellHeight))

			// If the search area is within one cell, return it
			if (colStart == colEnd && rowStart == rowEnd)
				return cells[(rowStart-1)*columns+colStart]

			// Otherwise, combine the overlapped cells to get the result list
			var
				// We leave empty cells as just null instead of a list().
				// When creating list to return, put null as first element, so we know where |= will place the nulls
				// Then can swap it to the end and reduce len by 1 to get rid of it
				list/resultList = list(null)
				cellIndex
			// TODO: Unroll loops for 1-cell, 2-cell, and 4-cell cases? Profile and see.
			for(var/row = rowStart to rowEnd step 1)
				cellIndex = (row-1) * columns + colStart
				for(var/col = colStart to colEnd step 1)
					resultList |= cells[cellIndex]
					++cellIndex
			// Remove null
			resultList.Swap(1, resultList.len)
			--resultList.len
			return resultList