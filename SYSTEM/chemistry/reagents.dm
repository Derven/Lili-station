#define SOLID 1
#define LIQUID 2
#define GAS 3

//The reaction procs must ALWAYS set src = null, this detaches the proc from the object (the reagent)
//so that it can continue working when the reagent is deleted while the proc is still active.

/atom
	var/datum/reagents/reagents

datum
	reagent
		var/name = "Reagent"
		var/id = "reagent"
		var/description = ""
		var/datum/reagents/holder = null
		var/reagent_state = SOLID
		var/data = null
		var/volume = 0
		var/nutriment_factor = 0
		//var/list/viruses = list()
		var/color = "#000000" // rgb: 0, 0, 0 (does not support alpha channels - yet!)

		proc
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume) //By default we have a chance to transfer some
				if(!istype(M, /mob))	return 0
				var/datum/reagent/self = src
				src = null										  //of the reagent to the mob on TOUCHING it.
					// If the chemicals are in a smoke cloud, do not try to let the chemicals "penetrate" into the mob's system (balance station 13) -- Doohl

				if(method == TOUCH)

					if(M.reagents)
						M.reagents.add_reagent(self.id,self.volume/2)
				return 1

			reaction_obj(var/obj/O, var/volume) //By default we transfer a small part of the reagent to the object
				src = null						//if it can hold reagents. nope!
				//if(O.reagents)
				//	O.reagents.add_reagent(id,volume/3)
				return

			reaction_turf(var/turf/T, var/volume)
				src = null
				return

			on_mob_life(var/mob/M as mob)
				if(!istype(M, /mob))
					return //Noticed runtime errors from pacid trying to damage ghosts, this should fix. --NEO
				holder.remove_reagent(src.id, REAGENTS_METABOLISM) //By default it slowly disappears.
				return

			on_move(var/mob/M)
				return

			on_update(var/atom/A)
				return

		nothing
			name = "nothing"
			id = "nothing"
			reagent_state = GAS

		diesel
			name = "diesel"
			id = "diesel"
			reagent_state = LIQUID

		antibodies
			name = "Antibodies"
			id = "antibodies"
			description = "Little helpers produced by the body to fight off intruders."
			reagent_state = LIQUID
			var
				antibodies = 0

			on_mob_life(mob/M)
				if (istype(M,/mob))
					// the antibodies start killing stuff
					var/mob/C = M
					if(C.microorganism && C.microorganism.antigen & src.antibodies)
						C.microorganism.dead = 1
				return

			proc/copy_from(mob/simulated/living/M)
				if(istype(M,/datum/reagent/antibodies))
					var/datum/reagent/antibodies/other = M
					src.antibodies = other.antibodies
				if(istype(M,/mob))
					src.antibodies = M.antibodies

		poison
			name = "poison"
			id = "poison"
			reagent_state = LIQUID

			reaction_mob(var/mob/M)
				..()
				return

		blood
			name = "blood"
			id = "blood"
			var
				datum/microorganism/disease/microorganism
				antibodies = 0

		ethanol
			name = "ethanol"
			id = "ethanol"

		cola
			name = "cola"
			id = "cola"

		oil
			name = "oil"
			id = "oil"

		nutriment
			name = "nutriments"
			id = "nutriments"

		lightgas
			name = "lightgas"
			id = "lightgas"

		psilocybin
			name = "psilocybin"
			id = "psilocybin"

		palladium
			name = "palladium"
			id = "palladium"

		phosphorus
			name = "phosphorus"
			id = "phosphorus"

		potassium
			name = "potassium"
			id = "potassium"

		carbon
			name = "carbon"
			id = "carbon"

		water
			name = "water"
			id = "water"

		plasma
			name = "plasma"
			id = "plasma"

		nitrogen
			name = "nitrogen"
			id = "nitrogen"

		oxygen
			name = "oxygen"
			id = "oxygen"

		hydrogen
			name = "hydrogen"
			id = "hydrogen"

		iron
			name = "iron"
			id = "iron"

		copper
			name = "copper"
			id = "copper"

		alluminium
			name = "alluminium"
			id = "alluminium"

		gold
			name = "gold"
			id = "gold"

		mercury
			name = "mercury"
			id = "mercury"

		ammonia
			name = "ammonia"
			id = "ammonia"
			description = "A caustic substance commonly used in fertilizer or household cleaners."

		chlorine
			name = "chlorine"
			id = "chlorine"

		fluorine
			name = "fluorine"
			id = "fluorine"

		radium
			name = "radium"
			id = "radium"

		uranium
			name = "uranium"
			id = "uranium"

		silver
			name = "silver"
			id = "silver"

		silicon
			name = "silicon"
			id = "silicon"

		sewage_sample
			name = "sewage_sample"
			id = "sewage_sample"

		salt_water
			name = "salt_water"
			id = "salt_water"

		orange_juice
			name = "orange_juice"
			id = "orange_juice"

		apple_juice
			name = "apple_juice"
			id = "apple_juice"

		caffeine
			name = "caffeine"
			id = "caffeine"
			on_mob_life(var/mob/simulated/living/M)
				M.heart.activate_stimulators(/datum/heart_stimulators/caffeine)
				holder.remove_reagent(src.id, REAGENTS_METABOLISM)
				return

		tea
			name = "tea"
			id = "tea"

		milk
			name = "milk"
			id = "milk"

		mutagen
			name = "mutagen"
			id = "mutagen"

		purifier
			name = "purifier"
			id = "purifier"

		adderal
			name = "adderal"
			id = "adderal"

		sleeping
			name = "sleeping"
			id = "sleeping"

			on_mob_life(var/mob/simulated/living/M)
				M.heart.activate_stimulators(/datum/heart_stimulators/hard_sedative)
				holder.remove_reagent(src.id, REAGENTS_METABOLISM)
				return

		oxycodone
			name = "oxycodone"
			id = "oxycodone"

		tramadol
			name = "tramadol"
			id = "tramadol"

			on_mob_life(var/mob/simulated/living/M)
				if (istype(M,/mob))
					if(M.heart.brute_dam > 1)
						M.heart.brute_dam -= 1
					if(M.heart.burn_dam > 1)
						M.heart.burn_dam -= 1
					if(M.lungs.brute_dam > 1)
						M.lungs.brute_dam -= 1
					if(M.lungs.burn_dam > 1)
						M.lungs.burn_dam -= 1
					holder.remove_reagent(src.id, REAGENTS_METABOLISM)
				return

		xanax
			name = "xanax"
			id = "xanax"

		codeine //от слова code
			name = "codeine"
			id = "codeine"

		antibiotic
			name = "antibiotic"
			id = "antibiotic"

		metamphetamine
			name = "metamphetamine"
			id = "metamphetamine"

//TG REAGENTS

/datum/reagent/medicine/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Increases resistance to stuns as well as reducing drowsiness and hallucinations."

/datum/reagent/medicine/inacusiate
	name = "Inacusiate"
	id = "inacusiate"
	description = "Instantly restores all hearing to the patient, but does not cure deafness."

/datum/reagent/medicine/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the patient's body temperature must be under 170K for it to metabolise correctly."

/datum/reagent/medicine/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder derived from fish toxin, Rezadone can effectively treat genetic damage as well as restoring minor wounds. Overdose will cause intense nausea and minor toxin damage."

/datum/reagent/medicine/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "Spaceacillin will prevent a patient from conventionally spreading any diseases they are currently infected with."

/datum/reagent/medicine/silver_sulfadiazine
	name = "Silver Sulfadiazine"
	id = "silver_sulfadiazine"
	description = "If used in touch-based applications, immediately restores burn wounds as well as restoring more over time. If ingested through other means, deals minor toxin damage."

/datum/reagent/medicine/oxandrolone
	name = "Oxandrolone"
	id = "oxandrolone"
	description = "Stimulates the healing of severe burns. Extremely rapidly heals severe burns and slowly heals minor ones. Overdose will worsen existing burns."

/datum/reagent/medicine/styptic_powder
	name = "Styptic Powder"
	id = "styptic_powder"
	description = "If used in touch-based applications, immediately restores bruising as well as restoring more over time. If ingested through other means, deals minor toxin damage."

/datum/reagent/medicine/salglu_solution
	name = "Saline-Glucose Solution"
	id = "salglu_solution"
	description = "Has a 33% chance per metabolism cycle to heal brute and burn damage.  Can be used as a blood substitute on an IV drip."

/datum/reagent/medicine/mine_salve
	name = "Miner's Salve"
	id = "mine_salve"
	description = "A powerful painkiller. Restores bruising and burns in addition to making the patient believe they are fully healed."

/datum/reagent/medicine/synthflesh
	name = "Synthflesh"
	id = "synthflesh"
	description = "Has a 100% chance of instantly healing brute and burn damage. One unit of the chemical will heal one point of damage. Touch application only."

/datum/reagent/medicine/charcoal
	name = "Charcoal"
	id = "charcoal"
	description = "Heals toxin damage as well as slowly removing any other chemicals the patient has in their bloodstream."

/datum/reagent/medicine/omnizine
	name = "Omnizine"
	id = "omnizine"
	description = "Slowly heals all damage types. Overdose will cause damage in all types instead."

/datum/reagent/medicine/calomel
	name = "Calomel"
	id = "calomel"
	description = "Quickly purges the body of all chemicals. Toxin damage is dealt if the patient is in good condition."

/datum/reagent/medicine/potass_iodide
	name = "Potassium Iodide"
	id = "potass_iodide"
	description = "Efficiently restores low radiation damage."

/datum/reagent/medicine/pen_acid
	name = "Pentetic Acid"
	id = "pen_acid"
	description = "Reduces massive amounts of radiation and toxin damage while purging other chemicals from the body. Has a chance of dealing brute damage."

/datum/reagent/medicine/sal_acid
	name = "Salicyclic Acid"
	id = "sal_acid"
	description = "Very slowly restores low bruising. Primarily used as an ingredient in other medicines. Overdose causes slight bruising."

/datum/reagent/medicine/salbutamol
	name = "Salbutamol"
	id = "salbutamol"
	description = "Rapidly restores oxygen deprivation as well as preventing more of it to an extent."

/datum/reagent/medicine/perfluorodecalin
	name = "Perfluorodecalin"
	id = "perfluorodecalin"
	description = "Extremely rapidly restores oxygen deprivation, but inhibits speech. May also heal small amounts of bruising and burns."

/datum/reagent/medicine/ephedrine
	name = "Ephedrine"
	id = "ephedrine"
	description = "Increases stun resistance and movement speed. Overdose deals toxin damage and inhibits breathing."


/datum/reagent/medicine/diphenhydramine
	name = "Diphenhydramine"
	id = "diphenhydramine"
	description = "Rapidly purges the body of Histamine and reduces jitteriness. Slight chance of causing drowsiness."

/datum/reagent/medicine/morphine
	name = "Morphine"
	id = "morphine"
	description = "A painkiller that allows the patient to move at full speed even in bulky objects. Causes drowsiness and eventually unconsciousness in high doses. Overdose will cause a variety of effects, ranging from minor to lethal."

/datum/reagent/medicine/oculine
	name = "Oculine"
	id = "oculine"
	description = "Quickly restores eye damage, cures nearsightedness, and has a chance to restore vision to the blind."

/datum/reagent/medicine/atropine
	name = "Atropine"
	id = "atropine"
	description = "If a patient is in critical condition, rapidly heals all damage types as well as regulating oxygen in the body. Excellent for stabilizing wounded patients."

/datum/reagent/medicine/epinephrine
	name = "Epinephrine"
	id = "epinephrine"
	description = "Minor boost to stun resistance. Slowly heals damage if a patient is in critical condition, as well as regulating oxygen loss. Overdose causes weakness and toxin damage."

	on_mob_life(var/mob/simulated/living/M)
		if (istype(M,/mob))
			M.heart.activate_stimulators(/datum/heart_stimulators/adrenalin_ephedrine)
			holder.remove_reagent(src.id, 2)

/datum/reagent/medicine/mannitol
	name = "Mannitol"
	id = "mannitol"
	description = "Efficiently restores brain damage."

/datum/reagent/medicine/mutadone
	name = "Mutadone"
	id = "mutadone"
	description = "Removes jitteriness and restores genetic defects."

/datum/reagent/medicine/antihol
	name = "Antihol"
	id = "antihol"
	description = "Purges alcoholic substance from the patient's body and eliminates its side effects."

/datum/reagent/medicine/stimulants
	name = "Stimulants"
	id = "stimulants"
	description = "Increases stun resistance and movement speed in addition to restoring minor damage and weakness. Overdose causes weakness and toxin damage."

/datum/reagent/medicine/insulin
	name = "Insulin"
	id = "insulin"
	description = "Increases sugar depletion rates."

datum/reagent/medicine/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Restores bruising. Overdose causes it instead."

datum/reagent/medicine/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Restores oxygen loss. Overdose causes it instead."

datum/reagent/medicine/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Restores fire damage. Overdose causes it instead."

	on_mob_life(mob/simulated/living/M as mob)
		M.heal_burn(volume)
		holder.remove_reagent(src.id, REAGENTS_METABOLISM)
		..()
		return


datum/reagent/medicine/antitoxin
	name = "Anti-Toxin"
	id = "antitoxin"
	description = "Heals toxin damage and removes toxins in the bloodstream. Overdose causes toxin damage."

datum/reagent/medicine/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Stabilizes the breathing of patients. Good for those in critical condition."

	on_mob_life(var/mob/simulated/living/M as mob)
		M.heal_brute(volume)
		holder.remove_reagent(src.id, REAGENTS_METABOLISM)
		..()
		return

datum/reagent/medicine/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Has a high chance to heal all types of damage. Overdose instead causes it."

	on_mob_life(var/mob/simulated/living/M as mob)
		M.heal_brute(volume)
		..()
		return

/datum/reagent/consumable/vitamin
	name = "Vitamin"
	id = "vitamin"
	description = "All the best vitamins, minerals, and carbohydrates the body needs in pure form."

/datum/reagent/consumable/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."

/datum/reagent/consumable/virus_food
	name = "Virus Food"
	id = "virusfood"
	description = "A mixture of water and milk. Virus cells can use this mixture to reproduce."

/datum/reagent/consumable/soysauce
	name = "Soysauce"
	id = "soysauce"
	description = "A salty sauce made from the soy plant."

/datum/reagent/consumable/ketchup
	name = "Ketchup"
	id = "ketchup"
	description = "Ketchup, catsup, whatever. It's tomato paste."

/datum/reagent/consumable/capsaicin
	name = "Capsaicin Oil"
	id = "capsaicin"
	description = "This is what makes chilis hot."

/datum/reagent/consumable/frostoil
	name = "Frost Oil"
	id = "frostoil"
	description = "A special oil that noticably chills the body. Extraced from Icepeppers."

/datum/reagent/consumable/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	description = "A chemical agent used for self-defense and in police work."

/datum/reagent/consumable/sodiumchloride
	name = "Table Salt"
	id = "sodiumchloride"
	description = "A salt made of sodium chloride. Commonly used to season food."

/datum/reagent/consumable/blackpepper
	name = "Black Pepper"
	id = "blackpepper"
	description = "A powder ground from peppercorns. *AAAACHOOO*"

/datum/reagent/consumable/coco
	name = "Coco Powder"
	id = "cocoa"
	description = "A fatty, bitter paste made from coco beans."

/datum/reagent/mushroomhallucinogen
	name = "Mushroom Hallucinogen"
	id = "mushroomhallucinogen"
	description = "A strong hallucinogenic drug derived from certain species of mushroom."

/datum/reagent/consumable/sprinkles
	name = "Sprinkles"
	id = "sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."

/datum/reagent/consumable/cornoil
	name = "Corn Oil"
	id = "cornoil"
	description = "An oil derived from various types of corn."

/datum/reagent/consumable/enzyme
	name = "Universal Enzyme"
	id = "enzyme"
	description = "A universal enzyme used in the preperation of certain chemicals and foods."

/datum/reagent/consumable/dry_ramen
	name = "Dry Ramen"
	id = "dry_ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."

/datum/reagent/consumable/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"

/datum/reagent/consumable/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."

/datum/reagent/consumable/flour
	name = "Flour"
	id = "flour"
	description = "This is what you rub all over yourself to pretend to be a ghost."

