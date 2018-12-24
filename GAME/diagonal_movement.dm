/client
	North()
		north = 1
		if(west)
			Northwest()
			return
		if(east)
			Northeast()
			return
		..()
		flick("movement_n", mob.M)

	South()
		south = 1
		if(west)
			Southwest()
			return
		if(east)
			Southeast()
			return
		..()
		flick("movement_s", mob.M)

	West()
		west = 1
		if(north)
			Northwest()
			return
		if(south)
			Southwest()
			return
		..()
		flick("movement_w", mob.M)

	East()
		east = 1
		if(north)
			Northeast()
			return
		if(south)
			Southeast()
			return
		..()
		flick("movement_e", mob.M)

	Southwest()
		..()
		flick("movement_sw", mob.M)

	Southeast()
		..()
		flick("movement_se", mob.M)

	Northwest()
		..()
		flick("movement_nw", mob.M)

	Northeast()
		..()
		flick("movement_ne", mob.M)


client
	var
		north
		east
		south
		west
		leftclick
	verb
		NorthReleased()
			set hidden = 1
			north = 0
		EastReleased()
			set hidden = 1
			east = 0
		SouthReleased()
			set hidden = 1
			south = 0
		WestReleased()
			set hidden = 1
			west = 0
		MLCP()
			set hidden = 1
			leftclick = 1
		MLCR()
			set hidden = 1
			leftclick = 0