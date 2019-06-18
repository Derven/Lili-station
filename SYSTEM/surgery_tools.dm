// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/simulated/living/humanoid/proc/take_organ_damage(var/brute, var/burn)
	bruteloss += brute
	fireloss += burn
	src.updatehealth()

/obj/item/proc/eyestab(var/mob/simulated/living/humanoid/M, var/mob/simulated/living/humanoid/user as mob)

	//if((user.mutations & 16) && prob(50))
	//	M = user
		/*
		M << "\red You stab yourself in the eye."
		M.sdisabilities |= 1
		M.weakened += 4
		M.bruteloss += 10
		*/

	if(M != usr)
		for(var/mob/O in (viewers(M) - usr - M))
			O.show_message("\red [M] has been stabbed in the eye with [src] by [usr].", 1)
		M << "\red [usr] stabs you in the eye with [src]!"
		usr << "\red You stab [M] in the eye with [src]!"
	else
		user.visible_message( \
			"\red [usr] has stabbed themself with [src]!", \
			"\red You stab yourself in the eyes with [src]!" \
		)
	if(istype(M, /mob/simulated/living/humanoid))
		var/datum/organ/external/affecting = M:organs["head"]
		affecting.take_damage(7)
	else
		M.take_organ_damage(7)
	M.eye_blurry += rand(3,4)
	M.eye_stat += rand(2,4)
	if (M.eye_stat >= 10)
		M.eye_blurry += 15+(0.1*M.eye_blurry)
		M.disabilities |= 1
		if(M.stat != 2)
			M << "\red Your eyes start to bleed profusely!"
		if(prob(50))
			if(M.stat != 2)
				M << "\red You drop what you're holding and clutch at your eyes!"
				M.drop_item()
			M.eye_blurry += 10
			M.paralysis += 1
			M.weakened += 4
		if (prob(M.eye_stat - 10 + 1))
			if(M.stat != 2)
				M << "\red You go blind!"
			M.sdisabilities |= 1
	return

/obj/item/brain
	icon = 'surgery.dmi'
	icon_state = "brain"

/obj/item/weapon/scalpel
	name = "scalpel"
	icon = 'surgery.dmi'
	icon_state = "scalpel"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 10.0
	w_class = 1.0
	m_amt = 10000
	g_amt = 5000
	origin_tech = "materials=1;biotech=1"

/obj/item/weapon/retractor
	name = "retractor"
	icon = 'surgery.dmi'
	icon_state = "retractor"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1;biotech=1"
	pixel_z = 24
	layer = 3

/obj/item/weapon/hemostat
	name = "hemostat"
	icon = 'surgery.dmi'
	icon_state = "hemostat"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1;biotech=1"
	pixel_z = 25
	layer = 3

/obj/item/weapon/cautery
	name = "cautery"
	icon = 'surgery.dmi'
	icon_state = "cautery"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1;biotech=1"
	pixel_z = 30
	layer = 3

/obj/item/weapon/surgicaldrill
	name = "surgical drill"
	icon = 'surgery.dmi'
	icon_state = "drill"
	flags = FPRINT | TABLEPASS | CONDUCT
	w_class = 1.0
	origin_tech = "materials=1;biotech=1"
	pixel_z = 30
	layer = 3


/*
CONTAINS:
RETRACTOR
HEMOSTAT
CAUTERY
SURGICAL DRILL
SCALPEL
CIRCULAR SAW

*/

/////////////
//RETRACTOR//
/////////////
/obj/item/weapon/retractor/afterattack(var/mob/simulated/living/humanoid/M, var/mob/simulated/living/humanoid/user)
	if(!istype(M))
		return

	if(!(locate(/obj/structure/table/, M.loc) && (M.lying || M.weakened || M.stunned || M.paralysis || M.sleeping || M.stat) && prob(50)))
		return ..()

	if (user.ZN_SEL.selecting == "eyes")
		switch(M.eye_op_stage)
			if(1.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is having his eyes retracted by [user].", 1)
					M << "\red [user] begins to seperate your eyes with [src]!"
					user << "\red You seperate [M]'s eyes with [src]!"
				else
					user.visible_message( \
						"\red [user] begins to have his eyes retracted.", \
						"\red You begin to pry open your eyes with [src]!" \
					)
				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/simulated/living/humanoid))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(15)
						M.updatehealth()
					else
						M.take_organ_damage(15)

				M:eye_op_stage = 2.0

	else if((!(user.ZN_SEL.selecting == "head")) || (!(user.ZN_SEL.selecting == "groin")) || (!(istype(M, /mob/simulated/living/humanoid))))
		return ..()

	return

////////////
//Hemostat//
////////////

/obj/item/weapon/hemostat/afterattack(var/mob/simulated/living/humanoid/M, var/mob/simulated/living/humanoid/user)
	if(!istype(M))
		return

	if((locate(/obj/structure/table/, M.loc) && M.lying && prob(50)))
		return ..()

	if (user.ZN_SEL.selecting == "eyes")
		switch(M.eye_op_stage)
			if(2.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is having his eyes mended by [user].", 1)
					M << "\red [user] begins to mend your eyes with [src]!"
					user << "\red You mend [M]'s eyes with [src]!"
				else
					user.visible_message( \
						"\red [user] begins to have his eyes mended.", \
						"\red You begin to mend your eyes with [src]!" \
					)
				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/simulated/living/humanoid))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(15)
						M.updatehealth()
					else
						M.take_organ_damage(15)
				M:eye_op_stage = 3.0

	else if((!(user.ZN_SEL.selecting == "head")) || (!(user.ZN_SEL.selecting == "groin")) || (!(istype(M, /mob/simulated/living/humanoid))))
		return ..()

	return

///////////
//Cautery//
///////////

/obj/item/weapon/cautery/afterattack(var/mob/simulated/living/humanoid/M, var/mob/simulated/living/humanoid/user as mob)
	if(!istype(M))
		return

	if((locate(/obj/structure/table/, M.loc) && M.lying && prob(50)))
		return ..()

	if (user.ZN_SEL.selecting == "eyes")
		switch(M.eye_op_stage)
			if(3.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is having his eyes cauterized by [user].", 1)
					M << "\red [user] begins to cauterize your eyes!"
					user << "\red You cauterize [M]'s eyes with [src]!"
				else
					user.visible_message( \
						"\red [user] begins to have his eyes cauterized.", \
						"\red You begin to cauterize your eyes!" \
					)
				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/simulated/living/humanoid))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(15)
						M.updatehealth()
					else
						M.take_organ_damage(15)
				M.sdisabilities &= ~1
				M:eye_op_stage = 0.0

	else if((!(user.ZN_SEL.selecting == "head")) || (!(user.ZN_SEL.selecting == "groin")) || (!(istype(M, /mob/simulated/living/humanoid))))
		return ..()

	return


//obj/item/weapon/surgicaldrill


///////////
//SCALPEL//
///////////
/obj/item/weapon/scalpel/afterattack(var/mob/simulated/living/humanoid/M, var/mob/simulated/living/humanoid/user)
	if(!istype(M))
		return ..()

	if(prob(50))
		M = user
		return eyestab(M,user)

	if((locate(/obj/structure/table/, M.loc) && M.lying && prob(50)))
		return ..()

	if(user.ZN_SEL.selecting == "head")
		switch(M:brain_op_stage)
			if(0.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is beginning to have his head cut open with [src] by [user].", 1)
					M << "\red [user] begins to cut open your head with [src]!"
					user << "\red You cut [M]'s head open with [src]!"
				else
					user.visible_message( \
						"\red [user] begins to cut open his skull with [src]!", \
						"\red You begin to cut open your head with [src]!" \
					)

				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/simulated/living/humanoid))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(15)
					else
						M.take_organ_damage(15)

				if(istype(M, /mob/simulated/living/humanoid))
					var/datum/organ/external/affecting = M:organs["head"]
					affecting.take_damage(7)
				else
					M.take_organ_damage(7)

				M.updatehealth()
				M:brain_op_stage = 1.0
			if(2.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is having his connections to the brain delicately severed with [src] by [user].", 1)
					M << "\red [user] begins to cut open your head with [src]!"
					user << "\red You cut [M]'s head open with [src]!"
				else
					user.visible_message( \
						"\red [user] begin to delicately remove the connections to his brain with [src]!", \
						"\red You begin to cut open your head with [src]!" \
					)
				if(M == user && prob(25))
					user << "\red You nick an artery!"
					if(istype(M, /mob/simulated/living/humanoid))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(75)
					else
						M.take_organ_damage(75)

				if(istype(M, /mob/simulated/living/humanoid))
					var/datum/organ/external/affecting = M:organs["head"]
					affecting.take_damage(7)
				else
					M.take_organ_damage(7)

				M.updatehealth()
				M:brain_op_stage = 3.0
			else
				..()
		return

	else if(user.ZN_SEL.selecting == "eyes")
		user << "\blue So far so good."
		switch(M:eye_op_stage)
			if(0.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] is beginning to have his eyes incised with [src] by [user].", 1)
					M << "\red [user] begins to cut open your eyes with [src]!"
					user << "\red You make an incision around [M]'s eyes with [src]!"
				else
					user.visible_message( \
						"\red [user] begins to cut around his eyes with [src]!", \
						"\red You begin to cut open your eyes with [src]!" \
					)
				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/simulated/living/humanoid))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(15)
					else
						M.take_organ_damage(15)

				user << "\blue So far so good before."
				M.updatehealth()
				M:eye_op_stage = 1.0
				user << "\blue So far so good after."
	else
		return ..()
/* wat
	else if((!(user.ZN_SEL.selecting == "head")) || (!(user.ZN_SEL.selecting == "groin")) || (!(istype(M, /mob/simulated/living/humanoid))))
		return ..()
*/
	return


////////////////
//CIRCULAR SAW//
////////////////
/obj/item/weapon/circular_saw/afterattack(var/mob/simulated/living/humanoid/M, var/mob/simulated/living/humanoid/user)
	if(!istype(M))
		return ..()

	if(prob(50))
		M = user
		return eyestab(M,user)

	if((locate(/obj/structure/table/, M.loc) && M.lying && prob(50)))
		return ..()

	if(user.ZN_SEL.selecting == "head")
		switch(M:brain_op_stage)
			if(1.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] has his skull sawed open with [src] by [user].", 1)
					M << "\red [user] begins to saw open your head with [src]!"
					user << "\red You saw [M]'s head open with [src]!"
				else
					user.visible_message( \
						"\red [user] saws open his skull with [src]!", \
						"\red You begin to saw open your head with [src]!" \
					)
				if(M == user && prob(25))
					user << "\red You mess up!"
					if(istype(M, /mob/simulated/living/humanoid))
						var/datum/organ/external/affecting = M:organs["head"]
						affecting.take_damage(40)
						M.updatehealth()
					else
						M.take_organ_damage(40)

				if(istype(M, /mob/simulated/living/humanoid))
					var/datum/organ/external/affecting = M:organs["head"]
					affecting.take_damage(7)
				else
					M.take_organ_damage(7)

				M.updatehealth()
				M:brain_op_stage = 2.0

			if(3.0)
				if(M != user)
					for(var/mob/O in (viewers(M) - user - M))
						O.show_message("\red [M] has his spine's connection to the brain severed with [src] by [user].", 1)
					M << "\red [user] severs your brain's connection to the spine with [src]!"
					user << "\red You sever [M]'s brain's connection to the spine with [src]!"
				else
					user.visible_message( \
						"\red [user] severs his brain's connection to the spine with [src]!", \
						"\red You sever your brain's connection to the spine with [src]!" \
					)

				M:brain_op_stage = 4.0
				M.death()

				new /obj/item/brain(M.loc)
			else
				..()
		return

	else
		return ..()
/*
	else if((!(user.ZN_SEL.selecting == "head")) || (!(user.ZN_SEL.selecting == "groin")) || (!(istype(M, /mob/simulated/living/humanoid))))
		return ..()
*/
	return
