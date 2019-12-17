#define LIGHTING  15

/turf
	var/darkness = 0
	var/list/atom/lighters = list()
	var/refreshing = 0

/atom
	var/obj/light/lum = null
	var/lumpower = 0

	proc/SetLuminosity(var/power)
		for(var/turf/T in view(lumpower, src))
			if(T.lighters.Find(src) == 0 && power > 0)
				if(T.darkness >= 0)
					T.darkness += lumpower - get_dist(src, T)
				if(T.darkness < 0)
					T.darkness = 0
				T.lighters.Add(src)
			else
				if(power == 0)
					if(src in T.lighters)
						T.darkness -= lumpower - get_dist(src, T)
					if(T.darkness < 0)
						T.darkness = 0
					T.photon()
					T.lighters.Remove(src)

		if(istype(src.loc, /turf))
			if(src.loc:lighters.Find(src) == 0 && power > 0)
				if(src.loc:darkness >= 0)
					src.loc:darkness += lumpower
				if(src.loc:darkness < 0)
					src.loc:darkness = 0
				src.loc:lighters.Add(src)
			else
				if(power == 0)
					if(src in src.loc:lighters)
						src.loc:darkness -= lumpower
					if(src.loc:darkness < 0)
						src.loc:darkness = 0
					src.loc:lighters.Remove(src)

		if(istype(src, /turf))
			if(src:lighters.Find(src) == 0 && power > 0)
				if(src:darkness >= 0)
					src:darkness += lumpower
				if(src:darkness < 0)
					src:darkness = 0
				src:lighters.Add(src)
			else
				if(power == 0)
					if(src in src:lighters)
						src:darkness -= lumpower
					if(src:darkness < 0)
						src:darkness = 0
					src:lighters.Remove(src)

/turf/proc/photon()
	if(istype(src, /turf/space))
		lumpower = 3
		SetLuminosity(3)
	else
		if(refreshing == 0)
			drawlight()
			for(var/atom/A in src)
				if(!istype(A, /area))
					A.drawlight()

/turf/proc/check_in_your_pocket()
	for(var/turf/T in orange(8))
		T.refreshing = 1
		T.darkness = 0
		T.lighters.Cut()
		spawn(12)
			T.refreshing = 0

/turf/simulated/process()
	photon()

/atom/proc/drawlight()
	if(istype(src, /turf))
		color = rgb(src:darkness * (src:darkness * 2), src:darkness * (src:darkness * 2), src:darkness * (src:darkness * 2))
	if(istype(loc, /turf))
		color = loc:color
