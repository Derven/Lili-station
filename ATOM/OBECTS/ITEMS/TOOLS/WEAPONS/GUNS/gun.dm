/mob
	proc/eyeShake()
		if(src.client)
			src.client.pixel_x+=rand(-3,3)
			src.client.pixel_y+=rand(-3,3)
			spawn(2)
				if(src.client)
					src.client.pixel_x=0
					src.client.pixel_y=0

/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'gun.dmi'
	icon_state = "detective"
	var/automatic = 0
	flags =  FPRINT | TABLEPASS | CONDUCT | ONBELT | USEDELAY

	var
		obj/item/projectile/in_chamber = null
		caliber = ""
		silenced = 0
		recoil = 0

	proc
		load_into_chamber()
		special_check(var/mob/M)


	load_into_chamber()
		return 0


	special_check(var/mob/M) //Placeholder for any special checks, like detective's revolver.
		return 1

	afterattack(atom/target as mob|obj|turf|area, flag, params)//TODO: go over this
		if(flag)	return //we're placing gun on a table or in backpack

		var/mob/simulated/living/humanoid/H = usr
		var/turf/curloc = usr.loc
		var/turf/targloc = get_turf(target)
		if (!istype(targloc) || !istype(curloc))
			return

		if(!special_check(usr))	return

		if(istype(src, /obj/item/weapon/gun/energy/lasercannon))
			var/obj/item/weapon/gun/energy/lasercannon/LC = src
			if(LC.mypower < 0)
				usr << "\red Oh no! Battery need recharge!"
				return
			else
				LC.mypower -= 1

		if(!load_into_chamber())
			usr << "\red *click*";
			return

		if(!in_chamber)	return

		in_chamber.dest = targloc
		in_chamber.firer = H
		in_chamber.def_zone = H.ZN_SEL.selecting

		usr.eyeShake()

		if(targloc == curloc)
			usr.bullet_act(in_chamber)
			del(in_chamber)
			update_icon()
			return

		//if(silenced)
			////playsound(usr, fire_sound, 10, 1)
		//else
			////playsound(usr, fire_sound, 50, 1)
			//usr.visible_message("\red [usr.name] fires the [src.name]!", "\red You fire the [src.name]!", "\blue You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

		in_chamber.original = targloc
		in_chamber.loc = get_turf(usr)
		usr.next_move = world.time + 4
		in_chamber.silenced = silenced
		in_chamber.current = curloc
		in_chamber.yo = targloc.y - curloc.y
		in_chamber.xo = targloc.x - curloc.x
		for(var/mob/B in range(usr, 6))
			B.playsoundforme('Laser22.ogg')
		flick("laser_pew", src)


		if(params)
			var/list/mouse_control = params2list(params)
			if(mouse_control["icon-x"])
				in_chamber.p_x = text2num(mouse_control["icon-x"])
			if(mouse_control["icon-y"])
				in_chamber.p_y = text2num(mouse_control["icon-y"])

		spawn()
			if(in_chamber)	in_chamber.process()
		sleep(1)
		in_chamber = null
		update_icon()
		return
