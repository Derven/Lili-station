/atom/movable
	proc/check_max()
		if(x == 100)
			world << "debug"
			x = 1
			if(z == 1 || z == 6)
				z = 3
			else
				z += 1