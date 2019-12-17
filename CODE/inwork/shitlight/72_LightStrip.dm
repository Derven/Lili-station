
// Global instance for managing breaking a surface into "lit" and "shadowed" segments
var/global/LightStrip/LightStrip = new()

LightStrip
	var
		// Array of lengths, each length alternating lit/unlit
		// First segment is lit
		// Lengths should always add up to the size of the surface
		// A 0-length unlit segment can be used to split a lit segment
		list/segments = list()

	proc
		SetToFullyLit(size)
			// Create a single lit segment that covers the whole surface
			segments.len = 1
			segments[1] = size

		SetToFullyUnlit(size)
			// Create an empty lit segment followed by unlit segment that covers the whole surface
			segments.len = 2
			segments[1] = 0.0
			segments[2] = size

		IsFullyUnlit()
			// If there are only two segments and the first (which is lit) has zero-length, it's fully unlit
			return (segments.len == 2 && segments[1] <= FLOAT_TOLERANCE)

		ApplyShadow(start, end, compress=TRUE)
			var
				length = end - start
				index
				segLit = TRUE    // Whether the current segment is lit or unlit (first seg is lit)
				segStart = 0     // Distance from the "left" side of the strip
				segLength        // Length of the current segment
				segEnd           // Where the current segment ends

			// Search for where in the list this new segment falls
			for(index = 1 to segments.len)
				segLength = segments[index]
				segEnd = segStart + segLength

				if(segEnd >= start)
					// The new unlit segment starts at or during this segment
					break

				segStart = segEnd
				segLit = !segLit

			if(segEnd >= end && !segLit)
				// This one segment fully contains our new slice and it's already unlit
				return

			if(segLit)
				// Split the lit segment up
				// Shorten the old lit segment
				segments[index] = start - segStart
				// Insert our unlit segment and a new shortened lit segment after the old lit segment
				segments.Insert(index+1, length, segEnd - end)
				// Set the index to our inserted unlit segment
				index = index+1
			else if(index < segments.len)
				// Extend the unlit segment (if it isn't the last one)
				var/delta = end - segEnd
				segments[index] += delta
				// Shorten the following lit segment
				segments[index + 1] -= delta

			if(end > segEnd)
				// Carry through any reductions in size (the following lit segment now has a negative length)
				while(index < segments.len)
					var/carry = segments[index+1]
					if(carry >= -FLOAT_TOLERANCE) break
					// Remove the overlapped lit segment and merge the following unlit segment
					carry += segments[index+2]
					segments.Cut(index+1, index+3)

					if(carry >= -FLOAT_TOLERANCE)
						// If second unlit segment was larger than the carry-over, add it
						segments[index] += carry
						break
					else
						// Apply any remaining carry-over to the next lit segment and go again
						segments[index+1] += carry

			if(compress)
				// Merge any segments separated by a zero segment
				while(TRUE)
					// Find any zero segments, excluding the first and last
					var/emptyIndex = segments.Find(0, 2, segments.len)
					if(!emptyIndex) break
					// Add the second segment's length to the first
					segments[emptyIndex-1] += segments[emptyIndex+1]
					// Remove the empty segment and merged second segment
					segments.Cut(emptyIndex, emptyIndex+2)

				// Remove the last segment if it's zero or less (could be slightly negative from FPE)
				if(segments[segments.len] <= FLOAT_TOLERANCE) segments.len--

		SplitLitSegmentAtPoint(point)
			// Because the light gradient will reverse where it crosses the light source we
			// need to split any lit segments at that point so it creates two separate icons
			// Do this by creating a zero-length unlit segment (third param tells it not to remove zero-length segments)
			ApplyShadow(point, point, FALSE)