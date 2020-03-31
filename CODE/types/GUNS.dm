/obj/item/weapon/gun/energy
	icon_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun with two settings: Stun and kill."

	var
		obj/item/weapon/cell/power_supply //What type of power cell this uses
		charge_cost = 100 //How much energy is needed to fire.
		mycharge = 1000
		cell_type = "/obj/item/weapon/cell"
		projectile_type = "/obj/item/projectile/energy"

	New()
		..()
		return

	load_into_chamber()
		if(charge_cost <= mycharge)
			mycharge -= charge_cost
			in_chamber = new projectile_type(src)
			return 1
		else
			return 0

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
	var/blocked = 0
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
		if(blocked == 1)	return //we're placing gun on a table or in backpack

		if(istype(target, /obj/structure/table) && get_dist(usr, target) < 2)
			return
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


/obj/item/weapon/gun/energy/laser
	automatic = 1
	name = "laser gun"
	desc = "a basic weapon designed kill with concentrated energy bolts"
	icon_state = "laser"
	projectile_type = "/obj/item/projectile/beam"

	explosive
		projectile_type = "/obj/item/projectile/beam/explosive"

	taser
		name = "taser gun"
		projectile_type = "/obj/item/projectile/beam/stun"

/obj/item/riflebullets
	name = "holobullets"
	icon = 'gun.dmi'
	icon_state = "bullets"

	holobullet
		icon_state = "hbullet"

	energyrevolver
		icon_state = "energybullets"
		var/base_state = "energybullets"
		var/bullets = 6
		var/beamtype = "/obj/item/projectile/beam/stun/detective"

		attackby(obj/item/weapon/W as obj, mob/user as mob)
			if(istype(W, /obj/item/riflebullets/holobullet) && bullets < 6)
				usr:drop_item_v()
				del(W)
				bullets += 1
				update_icon()

		update_icon()
			icon_state = "[base_state][bullets]"

/obj/item/weapon/gun/energy/superoldrifle
	automatic = 1
	name = "rifle"
	desc = "a basic weapon designed kill with concentrated salt bullets"
	icon_state = "rifle"
	projectile_type = "/obj/item/projectile/beam"
	charge_cost = 1
	mycharge = 1
	automatic = 0
	pixel_z = 4
	var/obj/item/riflebullets/energyrevolver/speedloader

	revolver
		icon_state = "detective"
		desc = "a super noir weapon designed kill and stun with concentrated energy .38"

		New()
			..()
			random_name()

		attackby(obj/item/weapon/W as obj, mob/user as mob)
			if(speedloader == null)
				if(istype(W, /obj/item/riflebullets/energyrevolver))
					usr:drop_item_v()
					speedloader = W
					W.Move(src)

		verb/unload_speed_loader()
			set src = usr.contents
			if(speedloader)
				for(var/obj/item/riflebullets/hololoader in src)
					hololoader.loc = usr.loc
					speedloader = null

		verb/gun_rename()
			set src = usr.contents
			name = input("Choose a name for your gun.",
			"Gun Name",name)

		proc/random_name()
			name = pick("Sex Pistol", "AR-15", "Hol Horse") //hoho haha

		load_into_chamber()
			if(speedloader && speedloader.bullets > 0)
				speedloader.bullets -= charge_cost
				speedloader.update_icon()
				in_chamber = new speedloader.beamtype(src)
				return 1
			else
				return 0

	load_into_chamber()
		if(charge_cost <= mycharge)
			mycharge -= charge_cost
			in_chamber = new projectile_type(src)
			return 1
		else
			return 0

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/riflebullets) && mycharge < 1)
			usr:drop_item_v()
			del(W)
			mycharge = 1


/obj/item/weapon/gun/energy/laser/practice
	name = "practice laser gun"
	desc = "A modified version of the basic laser gun, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = "/obj/item/projectile/beam/practice"


obj/item/weapon/gun/energy/laser/retro
	automatic = 0
	name ="retro laser"
	icon_state = "retro"
	desc = "An older model of the basic lasergun, no longer used by Nanotrasen's security or military forces. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."


/obj/item/weapon/gun/energy/laser/captain
	icon_state = "caplaser"
	desc = "This is an antique laser gun. All craftsmanship is of the highest quality. It is decorated with assistant leather and chrome. The object menaces with spikes of energy. On the item is an image of Space Station 13. The station is exploding."
	force = 10
	var/charge_tick = 0

	New()
		..()
		processing_objects.Add(src)

	Del()
		processing_objects.Remove(src)
		..()

	process()
		charge_tick++
		if(charge_tick < 4) return 0
		charge_tick = 0
		return 1

/obj/item/weapon/gun/energy/laser/cyborg/load_into_chamber()
	if(in_chamber)	return 1

/obj/item/weapon/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the L.A.S.E.R. cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	projectile_type = "/obj/item/projectile/beam/explosive"
	var/mypower = 5

/obj/item/projectile/beam
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 70
	damage_type = BURN
	flag = "laser"
	eyeblur = 2
	stun = 0

/obj/item/projectile/beam/explosive

/obj/item/projectile/beam/stun
	damage = 0
	stun = 5

	detective
		damage = 35
		stun = 5

/obj/item/projectile/beam/practice
	damage = 0

/obj/item/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	damage = 40


/obj/item/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	damage = 50


/obj/item/projectile/beam/deathlaser
	name = "death laser"
	icon_state = "heavylaser"
	damage = 60




