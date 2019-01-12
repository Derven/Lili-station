/obj/item/weapon/gun/energy
	icon_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun with two settings: Stun and kill."

	var
		obj/item/weapon/cell/power_supply //What type of power cell this uses
		charge_cost = 100 //How much energy is needed to fire.
		cell_type = "/obj/item/weapon/cell"
		projectile_type = "/obj/item/projectile/energy"

	New()
		..()
		return


	load_into_chamber()
		in_chamber = new projectile_type(src)
		return 1

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
	damage = 20
	damage_type = BURN
	flag = "laser"
	eyeblur = 2
	stun = 0

/obj/item/projectile/beam/explosive

/obj/item/projectile/beam/stun
	damage = 0
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




