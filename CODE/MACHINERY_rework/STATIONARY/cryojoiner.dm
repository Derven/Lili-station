/obj/machinery/cryostasis
	name = "cryostasis machinery"
	icon_state = "cryojoiner"
	var/obj/jobmark/J = null
	var/jobmarktype = /obj/jobmark
	density = 1
	var/obj/hud/glass/G

	assistant
		jobmarktype = /obj/jobmark/assistant

	security
		jobmarktype = /obj/jobmark/security

	doctor
		jobmarktype = /obj/jobmark/doctor

	bartender
		jobmarktype = /obj/jobmark/bartender

	botanist
		jobmarktype = /obj/jobmark/botanist

	captain
		jobmarktype = /obj/jobmark/captain

	detective
		jobmarktype = /obj/jobmark/detective

	engineer
		jobmarktype = /obj/jobmark/engineer

	clown
		jobmarktype = /obj/jobmark/clown

	chef
		jobmarktype = /obj/jobmark/chef

	chaplain
		jobmarktype = /obj/jobmark/chaplain


	New()
		..()
		J = new jobmarktype(src)

	verb/eject_from_cryo()
		set src in world
		set name = "Eject from cryo"
		set category = "Cryo"

		if(src == usr.loc)
			usr << 'pneumo.wav'
			usr.loc = src.loc
			new /obj/effect/smoke(src.loc)
			spawn(15)
				usr << "\red Welcome to the space station 13!"
				usr << 'welcome.ogg'

/obj/jobmark/assistant
	job = "assistant"

/obj/jobmark/security
	job = "security"

/obj/jobmark/doctor
	job = "doctor"

/obj/jobmark/bartender
	job = "bartender"

/obj/jobmark/botanist
	job = "botanist"

/obj/jobmark/captain
	job = "captain"

/obj/jobmark/detective
	job = "detective"

/obj/jobmark/clown
	job = "clown"

/obj/jobmark/chef
	job = "chef"

/obj/jobmark/chaplain
	job = "chaplain"

/obj/jobmark/engineer
	job = "engineer"