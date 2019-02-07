/atom/movable
	proc/check_max()
		if(x == 255)
			x = 2
			if(z == 1 || z == 4)
				if(z == 4)
					if(prob(25))
						z = 1
					else
						z = 3
				else
					z = 3
			else
				z += 1
			for(var/mob/M in range(3, src))
				M << "\blue Hyperdrive activated"
		if(y == 255)
			y = 2
			if(z == 1 || z == 4)
				if(z == 4)
					if(prob(25))
						z = 1
					else
						z = 3
				else
					z = 3
			else
				z += 1
			for(var/mob/M in range(3, src))
				M << "\blue Hyperdrive activated"
		if(y == 1)
			y = 254
			if(z == 1 || z == 4)
				if(z == 4)
					if(prob(25))
						z = 1
					else
						z = 3
				else
					z = 3
			else
				z += 1
			for(var/mob/M in range(3, src))
				M << "\blue Hyperdrive activated"
		if(x == 1)
			x = 254
			if(z == 1 || z == 4)
				if(z == 4)
					if(prob(25))
						z = 1
					else
						z = 3
				else
					z = 3
			else
				z += 1
			for(var/mob/M in range(3, src))
				M << "\blue Hyperdrive activated"