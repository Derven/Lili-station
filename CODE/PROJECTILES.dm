/*
#define BRUTE "brute"
#define BURN "burn"
#define TOX "tox"
#define OXY "oxy"
#define CLONE "clone"

#define ADD "add"
#define SET "set"
*/

/obj/item/projectile
	name = "projectile"
	icon = 'projectiles.dmi'
	icon_state = "bullet"
	density = 1
	anchored = 1 //There's a reason this is here, Mport. God fucking damn it -Agouri. Find&Fix by Pete. The reason this is here is to stop the curving of emitter shots.
	flags = FPRINT | TABLEPASS
	pass_flags = PASSTABLE
	mouse_opacity = 0
	var
		processing = 0
		bumped = 0		//Prevents it from hitting more than one guy at once
		def_zone = ""	//Aiming at
		mob/firer = null//Who shot it
		silenced = 0	//Attack message
		yo = null
		xo = null
		current = null
		turf/original = null
		turf/dest//Destination

		p_x = 16
		p_y = 16 // the pixel location of the tile that the player clicked. Default is the center

		damage = 10
		damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE are the only things that should be in here
		nodamage = 0 //Determines if the projectile will skip any damage inflictions
		flag = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb
		projectile_type = "/obj/item/projectile"
		//Effects
		weaken = 0
		paralyze = 0
		irradiate = 0
		stutter = 0
		eyeblur = 0
		drowsy = 0


	proc/on_hit(var/atom/target, var/blocked = 0)
		if(blocked >= 2)	return 0//Full block
		//var/mob/L = target
		//L.apply_effects(stun, weaken, paralyze, irradiate, stutter, eyeblur, drowsy, blocked)
		return 1

	Bump(atom/A as mob|obj|turf|area)
		if(A == firer)
			loc = A.loc
			return //cannot shoot yourself

		if(bumped)
			return

		bumped = 1
		if(firer && istype(A, /mob))
			var/mob/M = A
			if(!istype(A, /mob))
				loc = A.loc
				return // nope.avi

			M << "\red You've been shot!"
			//if(istype(firer, /mob))
				//M.attack_log += text("\[[]\] <b>[]/[]</b> shot <b>[]/[]</b> with a <b>[]</b>", time_stamp(), firer, firer.ckey, M, M.ckey, src)
				//firer.attack_log += text("\[[]\] <b>[]/[]</b> shot <b>[]/[]</b> with a <b>[]</b>", time_stamp(), firer, firer.ckey, M, M.ckey, src)
				//log_attack("<font color_hyalor='red'>[firer] ([firer.ckey]) shot [M] ([M.ckey]) with a [src]</font>")

			//else
			//	M.attack_log += text("\[[]\] <b>UNKNOWN SUBJECT (No longer exists)</b> shot <b>[]/[]</b> with a <b>[]</b>", time_stamp(), M, M.ckey, src)
			//	log_attack("<font color_hyalor='red'>UNKNOWN shot [M] ([M.ckey]) with a [src]</font>")



		spawn(0)
			if(A)
				var/permutation = A.bullet_act(src, def_zone) // searches for return value
				if(permutation == -1) // the bullet passes through a dense object!
					bumped = 0 // reset bumped variable!
					if(istype(A, /turf))
						if(A.density == 0 || A.opacity == 0)
							loc = A
						else
							A.bullet_act(src)
							return
					else
						loc = A.loc
					return

				if(istype(A,/turf))
					if(A.density == 0 || A.opacity == 0)
						for(var/obj/O in A)
							O.bullet_act(src)
						for(var/mob/M in A)
							M.bullet_act(src, def_zone)
					else
						A.bullet_act(src)

				density = 0
				invisibility = 101
				del(src)
		return


	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(air_group || (height==0)) return 1


	process()
		var/go_away = 0
		var/turf/oldloc = null
		for(var/obj/item/projectile/P in orange(4, src))
			if(P.processing == 0)
				del(P)
		spawn while(src)
			processing = 1
			if((!( current ) || loc == current))
				current = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z)
			for(var/atom/A in loc)
				if(density == 1)
					if(!istype(A, /mob))
						A.bullet_act(src)
					else
						A.bullet_act(src, def_zone)
			var/turf/T = loc
			if(T.density == 1 && T.opacity == 1)
				T.bullet_act(src)
			if((x == 1 || x == world.maxx || y == 1 || y == world.maxy))
				del(src)
				return
			invisibility = 0
			if(go_away == 0)
				if(prob(75))
					invisibility = 101
				dir = get_dir(src,dest)
				if(dest.x > x)
					x += 1
				if(dest.y > y)
					y += 1
				if(dest.x < x)
					x -= 1
				if(dest.y < y)
					y -= 1
				if(oldloc == src.loc)
					del(src)
					return
			if((dest.y == y && dest.x == x) || go_away == 1)
				go_away = 1
				if(prob(75))
					invisibility = 101
				if(dir == 2)
					y -= 1

				if(dir == 4)
					x += 1

				if(dir == 8)
					x -= 1

				if(dir == 1)
					y += 1
				if(oldloc == src.loc)
					del(src)
					return
				else
					oldloc = locate(x, y, z)
			sleep(1)
			if(!bumped)
				if(loc == original)
					for(var/mob/M in original)
						Bump(M)
						sleep(1)
		return
