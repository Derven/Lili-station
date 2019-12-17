client
	var
		list
			keys = list()
			pressed = list()
			released = list()
			pressedClear = list()
			releasedClear = list()
	verb
		SetKey(key as null|text, state as null|num)
			set instant = 1
			key = lowertext(key)
			keys[key] = state
			if(state)
				pressed[key] = world.time
				pressedClear[key] = 0
			else
				released[key] = world.time
				releasedClear[key] = 0

	proc
		IsKeyDown(key)
			return keys[lowertext(key)]
		IsKeyActive(key)
			return IsKeyDown(key) || WasKeyPressed(key)
		WasKeyPressed(key, timeout=5)
			. = FALSE
			key = lowertext(key)

			// Check if key is waiting to be cleared (but wasn't *just* cleared this tick)
			if(pressedClear[key] >= pressed[key] && pressedClear[key] < world.time)
				// Key was previously checked and marked to be cleared, clear it
				pressed[key] = 0
			else
				// Check if key was pressed within timeout
				if(pressed[key] && (world.time - pressed[key] <= timeout))
					. = TRUE // Key was pressed recently, return TRUE

					// Mark key to be cleared at end of tick
					// Key presses are only cleared once read
					pressedClear[key] = world.time
		WasKeyReleased(key, timeout=5)
			. = FALSE
			key = lowertext(key)

			// Check if key is waiting to be cleared (but wasn't *just* cleared this tick)
			if(releasedClear[key] >= released[key] && releasedClear[key] < world.time)
				// Key was previously checked and marked to be cleared, clear it
				released[key] = 0
			else
				// Check if key was pressed within timeout
				if(released[key] && (world.time - released[key] <= timeout))
					. = TRUE // Key was pressed recently, return TRUE

					// Mark key to be cleared at end of tick
					// Key presses are only cleared once read
					releasedClear[key] = world.time