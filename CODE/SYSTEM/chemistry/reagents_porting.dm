datum
	reagent
		lube
			name = "Space Lube"
			id = "lube"
			description = "Lubricant is a substance introduced between two moving surfaces to reduce the friction and wear between them. giggity."
			reagent_state = LIQUID

			reaction_turf(var/turf/simulated/T, var/volume)
				if (!istype(T)) return
				src = null
				if(T.wet >= 2) return
				T.wet = 2
				spawn(800)
					if (!istype(T)) return
					T.wet = 0
					if(T.wet_overlay)
						T.overlays -= T.wet_overlay
						T.wet_overlay = null
					return

		bilk
			name = "Bilk"
			id = "bilk"
			description = "This appears to be beer mixed with milk. Disgusting."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(M:bruteloss && prob(10)) M:heal_brute(3,5)
				M:nutrition += 2
				if(!data) data = 1
				data++
				M:jitteriness = max(M:jitteriness-3,0)
				if(data >= 25)
					if (!M:stuttering) M:stuttering = 1
					M:stuttering += 3
				if(data >= 40 && prob(33))
					if (!M:confused) M:confused = 1
					M:confused += 2
				..()
				return

		anti_toxin
			name = "Anti-Toxin (Dylovene)"
			id = "anti_toxin"
			description = "Dylovene is a broad-spectrum antitoxin."
			reagent_state = LIQUID

			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:drowsyness = max(M:drowsyness-2, 0)
				if(holder.has_reagent("toxin"))
					holder.remove_reagent("toxin", 2)
				if(holder.has_reagent("stoxin"))
					holder.remove_reagent("stoxin", 2)
				if(holder.has_reagent("plasma"))
					holder.remove_reagent("plasma", 1)
				if(holder.has_reagent("acid"))
					holder.remove_reagent("acid", 1)
				if(holder.has_reagent("cyanide"))
					holder.remove_reagent("cyanide", 1)
				if(holder.has_reagent("amatoxin"))
					holder.remove_reagent("amatoxin", 2)
				if(holder.has_reagent("chloralhydrate"))
					holder.remove_reagent("chloralhydrate", 5)
				if(holder.has_reagent("carpotoxin"))
					holder.remove_reagent("carpotoxin", 1)
				if(holder.has_reagent("zombiepowder"))
					holder.remove_reagent("zombiepowder", 0.5)
				M:toxloss = max(M:toxloss-2,0)
				..()
				return

		toxin
			name = "Toxin"
			id = "toxin"
			description = "A Toxic chemical."
			reagent_state = LIQUID

			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += 1.5
				..()
				return

		cyanide
			name = "Cyanide"
			id = "cyanide"
			description = "A highly toxic chemical."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += 3
				M:oxyloss += 3
				M:sleeping += 1
				..()
				return
		inaprovaline
			name = "Inaprovaline"
			id = "inaprovaline"
			description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
			reagent_state = LIQUID

			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if(M.losebreath >= 10)
					M.losebreath = max(10, M.losebreath-5)
				holder.remove_reagent(src.id, 0.2)
				return

		oxygen
			name = "Oxygen"
			id = "oxygen"
			description = "A colorless, odorless gas."
			reagent_state = GAS

		copper
			name = "Copper"
			id = "copper"
			description = "A highly ductile metal."

		nitrogen
			name = "Nitrogen"
			id = "nitrogen"
			description = "A colorless, odorless, tasteless gas."
			reagent_state = GAS

		hydrogen
			name = "Hydrogen"
			id = "hydrogen"
			description = "A colorless, odorless, nonmetallic, tasteless, highly combustible diatomic gas."
			reagent_state = GAS

		potassium
			name = "Potassium"
			id = "potassium"
			description = "A soft, low-melting solid that can easily be cut with a knife. Reacts violently with water."
			reagent_state = SOLID

		sulfur
			name = "Sulfur"
			id = "sulfur"
			description = "A chemical element."
			reagent_state = SOLID

		chlorine
			name = "Chlorine"
			id = "chlorine"
			description = "A chemical element."
			reagent_state = GAS
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:rand_damage(4, 8)
				..()
				return

		fluorine
			name = "Fluorine"
			id = "fluorine"
			description = "A highly-reactive chemical element."
			reagent_state = GAS
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss++
				..()
				return

		sodium
			name = "Sodium"
			id = "sodium"
			description = "A chemical element."
			reagent_state = SOLID

		phosphorus
			name = "Phosphorus"
			id = "phosphorus"
			description = "A chemical element."
			reagent_state = SOLID

		lithium
			name = "Lithium"
			id = "lithium"
			description = "A chemical element."
			reagent_state = SOLID

			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if(M.canmove) step(M, pick(cardinal))
				..()
				return

		sugar
			name = "Sugar"
			id = "sugar"
			description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
			reagent_state = SOLID
			on_mob_life(var/mob/simulated/M as mob)
				M:nutrition += 1
				..()
				return

		glycerol
			name = "Glycerol"
			id = "glycerol"
			description = "Glycerol is a simple polyol compound. Glycerol is sweet-tasting and of low toxicity."
			reagent_state = LIQUID

		nitroglycerin
			name = "Nitroglycerin"
			id = "nitroglycerin"
			description = "Nitroglycerin is a heavy, colorless, oily, explosive liquid obtained by nitrating glycerol."
			reagent_state = LIQUID

		radium
			name = "Radium"
			id = "radium"
			description = "Radium is an alkaline earth metal. It is extremely radioactive."
			reagent_state = SOLID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M.radiation += 3
				..()
				return

		ryetalyn
			name = "Ryetalyn"
			id = "ryetalyn"
			description = "Ryetalyn can cure all genetic abnomalities."
			reagent_state = SOLID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M.mutations = 0
				M.disabilities = 0
				M.sdisabilities = 0
				..()
				return


		sterilizine
			name = "Sterilizine"
			id = "sterilizine"
			description = "Sterilizes wounds in preparation for surgery."
			reagent_state = LIQUID
	/*		reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if (method==TOUCH)
					if(istype(M, /mob/simulated/living/humanoid))
						if(M.health >= -100 && M.health <= 0)
							M.crit_op_stage = 0.0
				if (method==INGEST)
					usr << "Well, that was stupid."
					M:toxloss += 3
				return
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
					M.radiation += 3
					..()
					return
	*/
		iron
			name = "Iron"
			id = "iron"
			description = "Pure iron is a metal."
			reagent_state = SOLID
/*
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if((M.virus) && (prob(8) && (M.virus.name=="Magnitis")))
					if(M.virus.spread == "Airborne")
						M.virus.spread = "Remissive"
					M.virus.stage--
					if(M.virus.stage <= 0)
						M.resistances += M.virus.type
						M.virus = null
				holder.remove_reagent(src.id, 0.2)
				return
*/

		aluminum
			name = "aluminum"
			id = "aluminum"
			description = "A silvery white and ductile member of the boron group of chemical elements."
			reagent_state = SOLID

		silicon
			name = "Silicon"
			id = "silicon"
			description = "A tetravalent metalloid, silicon is less reactive than its chemical analog carbon."
			reagent_state = SOLID

		fuel
			name = "Welding fuel"
			id = "fuel"
			description = "Required for welders. Flamable."
			reagent_state = LIQUID
			reaction_obj(var/obj/O, var/volume)
				src = null
				var/turf/the_turf = get_turf(O)
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 15
				napalm.trace_gases += fuel
				the_turf.assume_air(napalm)
			reaction_turf(var/turf/T, var/volume)
				src = null
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 15
				napalm.trace_gases += fuel
				T.assume_air(napalm)
				return
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += 1
				..()
				return


		plantbgone
			name = "Plant-B-Gone"
			id = "plantbgone"
			description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
			reagent_state = LIQUID
			/* Don't know if this is necessary.
			on_mob_life(var/mob/simulated/living/M)
				if(!M) M = holder.my_atom
				M:toxloss += 3.0
				..()
				return
			*/

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(istype(M, /mob/simulated/living))
					M:toxloss += 2 // 4 toxic damage per application, doubled for some reason
					//if(prob(10))
						//M.make_dizzy(1) doesn't seem to do anything


		plasma
			name = "Plasma"
			id = "plasma"
			description = "Plasma in its liquid form."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if(holder.has_reagent("inaprovaline"))
					holder.remove_reagent("inaprovaline", 2)
				M:toxloss++
				..()
				return
			reaction_obj(var/obj/O, var/volume)
				src = null
				var/turf/the_turf = get_turf(O)
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 5
				napalm.trace_gases += fuel
				the_turf.assume_air(napalm)
			reaction_turf(var/turf/T, var/volume)
				src = null
				var/datum/gas_mixture/napalm = new
				var/datum/gas/volatile_fuel/fuel = new
				fuel.moles = 5
				napalm.trace_gases += fuel
				T.assume_air(napalm)
				return

		leporazine
			name = "Leporazine"
			id = "leporazine"
			description = "Leporazine can be use to stabilize an individuals body temperature."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if(M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-20)
				else if(M.bodytemperature < 311)
					M.bodytemperature = min(310, M.bodytemperature+20)
				..()
				return

		cryptobiolin
			name = "Cryptobiolin"
			id = "cryptobiolin"
			description = "Cryptobiolin causes confusion and dizzyness."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if(!M.confused) M.confused = 1
				M.confused = max(M.confused, 20)
				holder.remove_reagent(src.id, 0.2)
				..()
				return

		dexalin
			name = "Dexalin"
			id = "dexalin"
			description = "Dexalin is used in the treatment of oxygen deprivation."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:oxyloss = max(M:oxyloss-2, 0)
				if(holder.has_reagent("lexorin"))
					holder.remove_reagent("lexorin", 2)
				..()
				return

		dexalinp
			name = "Dexalin Plus"
			id = "dexalinp"
			description = "Dexalin Plus is used in the treatment of oxygen deprivation. Its highly effective."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:oxyloss = 0
				if(holder.has_reagent("lexorin"))
					holder.remove_reagent("lexorin", 2)
				..()
				return

		tricordrazine
			name = "Tricordrazine"
			id = "tricordrazine"
			description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if(M:oxyloss && prob(40)) M:oxyloss--
				if(M:bruteloss && prob(40)) M:heal_brute(3,5)
				if(M:fireloss && prob(40)) M:heal_burn(3,5)
				if(M:toxloss && prob(40)) M:toxloss--
				..()
				return

		synaptizine
			name = "Synaptizine"
			id = "synaptizine"
			description = "Synaptizine is used to treat neuroleptic shock. Can be used to help remove disabling symptoms such as paralysis."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:drowsyness = max(M:drowsyness-5, 0)
				if(M:paralysis) M:paralysis--
				if(M:stunned) M:stunned--
				if(M:weakened) M:weakened--
				..()
				return

		impedrezene
			name = "Impedrezene"
			id = "impedrezene"
			description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:jitteriness = max(M:jitteriness-5,0)
				if(prob(80)) M:brainloss++
				if(prob(50)) M:drowsyness = max(M:drowsyness, 3)
				..()
				return

		hyronalin
			name = "Hyronalin"
			id = "hyronalin"
			description = "Hyronalin is a medicinal drug used to counter the effects of radiation poisoning."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:radiation = max(M:radiation-3,0)
				..()
				return

		arithrazine
			name = "Arithrazine"
			id = "arithrazine"
			description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M)
				if(!M) M = holder.my_atom
				M:radiation = 0
				if(M:toxloss) M:toxloss--
				if(prob(15))
					M:rand_damage(5, 10)
				..()
				return

		alkysine
			name = "Alkysine"
			id = "alkysine"
			description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:brainloss = max(M:brainloss-3 , 0)
				..()
				return

		imidazoline
			name = "Imidazoline"
			id = "imidazoline"
			description = "Heals eye damage"
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:eye_blurry = max(M:eye_blurry-5 , 0)
				M:eye_blind = max(M:eye_blind-5 , 0)
				M:disabilities &= ~1
//				M:sdisabilities &= ~1		Replaced by eye surgery
				..()
				return

		arithrazine
			name = "Arithrazine"
			id = "arithrazine"
			description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:radiation = max(M:radiation-3,0)
				if(M:toxloss) M:toxloss--
				if(prob(15))
					M:rand_damage(5, 10)
				..()
				return

		bicaridine
			name = "Bicaridine"
			id = "bicaridine"
			description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:heal_brute(3)
				..()
				return

		hyperzine
			name = "Hyperzine"
			id = "hyperzine"
			description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				holder.remove_reagent(src.id, 0.2)
				..()
				return

		cryoxadone
			name = "Cryoxadone"
			id = "cryoxadone"
			description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if(M.bodytemperature < 170)
					if(M:oxyloss) M:oxyloss = M:oxyloss-3
						M:heal_brute(5)
					if(M:toxloss) M:toxloss = M:toxloss-3
				..()
				return

		spaceacillin
			name = "Spaceacillin"
			id = "spaceacillin"
			description = "An all-purpose antiviral agent."
			reagent_state = LIQUID

			on_mob_life(var/mob/simulated/M as mob)//no more mr. panacea
				holder.remove_reagent(src.id, 0.2)
				..()
				return

		carpotoxin
			name = "Carpotoxin"
			id = "carpotoxin"
			description = "A deadly neurotoxin produced by the dreaded spess carp."
			reagent_state = LIQUID

			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss += 2
				..()
				return

		zombiepowder
			name = "Zombie Powder"
			id = "zombiepowder"
			description = "A strong neurotoxin that puts the subject into a death-like state."
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:oxyloss += 0.5
				M:toxloss += 0.5
				M:weakened = max(M:weakened, 10)
				..()
				return

		fluorosurfactant
			name = "Fluorosurfactant"
			id = "fluorosurfactant"
			description = "A perfluoronated sulfonic acid that forms a foam when mixed with water."
			reagent_state = LIQUID


// metal foaming agent
// this is lithium hydride. Add other recipies (e.g. LiH + H2O -> LiOH + H2) eventually

		foaming_agent
			name = "Foaming agent"
			id = "foaming_agent"
			description = "A agent that yields metallic foam when mixed with light metal and a strong acid."
			reagent_state = SOLID

		nicotine
			name = "Nicotine"
			id = "nicotine"
			description = "A highly addictive stimulant extracted from the tobacco plant."
			reagent_state = LIQUID

		ammonia
			name = "Ammonia"
			id = "ammonia"
			description = "A caustic substance commonly used in fertilizer or household cleaners."
			reagent_state = GAS

		diethylamine
			name = "Diethylamine"
			id = "diethylamine"
			description = "A secondary amine, mildly corrosive."
			reagent_state = LIQUID

		ethylredoxrazine						// FUCK YOU, ALCOHOL
			name = "Ethylredoxrazine"
			id = "ethylredoxrazine"
			description = "A powerfuld oxidizer that reacts with ethanol."
			reagent_state = SOLID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:drowsyness = 0
				M:stuttering = 0
				M:confused = 0
				..()
				return

		chloralhydrate							//Otherwise known as a "Mickey Finn"
			name = "Chloral Hydrate"
			id = "chloralhydrate"
			description = "A powerful sedative."
			reagent_state = SOLID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1)
						M:confused += 2
						M:drowsyness += 2
					if(2 to 50)
						M:sleeping += 1
					if(51 to 99999999)
						M:sleeping += 1
						M:toxloss += (data - 50)
				data++
				..()
				return

		beer2							//copypasta of chloral hydrate, disguised as normal beer for use by emagged brobots
			name = "Beer"
			id = "beer2"
			description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if(!data) data = 1
				switch(data)
					if(1)
						M:confused += 2
						M:drowsyness += 2
					if(2 to 50)
						M:sleeping += 1
					if(51 to 99999999)
						M:sleeping += 1
						M:toxloss += (data - 50)
				data++
				..()
				return

		soysauce
			name = "Soysauce"
			id = "soysauce"
			description = "A salty sauce made from the soy plant."
			reagent_state = LIQUID
			nutriment_factor = 2 * REAGENTS_METABOLISM

		ketchup
			name = "Ketchup"
			id = "ketchup"
			description = "Ketchup, catsup, whatever. It's tomato paste."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM

		capsaicin
			name = "Capsaicin Oil"
			id = "capsaicin"
			description = "This is what makes chilis hot."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:bodytemperature += 5
				if(prob(40))
					M:rand_damage(5, 10)
				..()
				return

		frostoil
			name = "Frost Oil"
			id = "frostoil"
			description = "A special oil that noticably chills the body. Extraced from Icepeppers."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:bodytemperature -= 5
				if(prob(40))
					M:rand_damage(5, 10)
				..()
				return

		sodiumchloride
			name = "Table Salt"
			id = "sodiumchloride"
			description = "A salt made of sodium chloride. Commonly used to season food."
			reagent_state = SOLID
			nutriment_factor = 1 * REAGENTS_METABOLISM

		blackpepper
			name = "Black Pepper"
			id = "blackpepper"
			description = "A power ground from peppercorns. *AAAACHOOO*"
			reagent_state = SOLID
			nutriment_factor = 1 * REAGENTS_METABOLISM

		amatoxin
			name = "Amatoxin"
			id = "amatoxin"
			description = "A powerful poison derived from certain species of mushroom."
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:toxloss++
				..()
				return

		sprinkles
			name = "Sprinkles"
			id = "sprinkles"
			description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/simulated/M as mob)
				M:nutrition += nutriment_factor
				if(istype(M, /mob/simulated/living/humanoid) && M.job in list("Security Officer", "Head of Security", "Detective", "Warden"))
					if(!M) M = holder.my_atom
					M:heal_brute(3)
					M:nutrition += nutriment_factor
					..()
					return
				..()

		cornoil
			name = "Corn Oil"
			id = "cornoil"
			description = "An oil derived from various types of corn."
			reagent_state = LIQUID
			nutriment_factor = 20 * REAGENTS_METABOLISM
			on_mob_life(var/mob/simulated/M as mob)
				M:nutrition += nutriment_factor
				..()
				return
			reaction_turf(var/turf/simulated/T, var/volume)
				if (!istype(T)) return
				src = null
				if(volume >= 3)
					if(T.wet >= 1) return
					T.wet = 1
					if(T.wet_overlay)
						T.overlays -= T.wet_overlay
						T.wet_overlay = null
					T.overlays += T.wet_overlay

					spawn(800)
						if (!istype(T)) return
						if(T.wet >= 2) return
						T.wet = 0
						if(T.wet_overlay)
							T.overlays -= T.wet_overlay
							T.wet_overlay = null

		enzyme
			name = "Universal Enzyme"
			id = "enzyme"
			description = "A universal enzyme used in the preperation of certain chemicals and foods."
			reagent_state = LIQUID

		berryjuice
			name = "Berry Juice"
			id = "berryjuice"
			description = "A delicious blend of several different kinds of berries."
			reagent_state = LIQUID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:nutrition += nutriment_factor
				..()
				return

		banana
			name = "Banana Juice"
			id = "banana"
			description = "The raw essence of a banana. HONK"
			nutriment_factor = 1 * REAGENTS_METABOLISM

		dry_ramen
			name = "Dry Ramen"
			id = "dry_ramen"
			description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
			reagent_state = SOLID
			on_mob_life(var/mob/simulated/M as mob)
				..()
				M:nutrition += 1
				return

		hot_ramen
			name = "Hot Ramen"
			id = "hot_ramen"
			description = "The noodles are boiled, the flavors are artificial, just like being back in school."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			on_mob_life(var/mob/simulated/M as mob)
				..()
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+10)
				return

		hell_ramen
			name = "Hell Ramen"
			id = "hell_ramen"
			description = "The noodles are boiled, the flavors are artificial, just like being back in school."
			reagent_state = LIQUID
			nutriment_factor = 5 * REAGENTS_METABOLISM
			on_mob_life(var/mob/simulated/M as mob)
				..()
				M:bodytemperature += 10
				return

		potato_juice
			name = "Potato Juice"
			id = "potato"
			description = "Juice of the potato. Bleh."
			reagent_state = LIQUID
			nutriment_factor = 2 * REAGENTS_METABOLISM


/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
		milk
			name = "Milk"
			id = "milk"
			description = "An opaque white liquid produced by the mammary glands of mammals."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if(M:bruteloss && prob(10)) M:heal_brute(3,5)
				M:nutrition++
				..()
				return

		soymilk
			name = "Soy Milk"
			id = "soymilk"
			description = "An opaque white liquid made from soybeans."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				if(M:bruteloss && prob(10)) M:heal_brute(3)
				M:nutrition++
				..()
				return

		coffee
			name = "Coffee"
			id = "coffee"
			description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				..()
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+5)
				..()
				return

		tea
			name = "Tea"
			id = "tea"
			description = "Tasty black tea, it has antioxidants, it's good for you!"
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				..()
				M:drowsyness = max(0,M:drowsyness-1)
				M:jitteriness = max(0,M:jitteriness-3)
				M:sleeping = 0
				if(M:toxloss && prob(50))
					M:toxloss--
				if (M.bodytemperature < 310)  //310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+5)
				..()
				return

		icecoffee
			name = "Iced Coffee"
			id = "icecoffee"
			description = "Coffee and ice, refreshing and cool."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				..()
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature-5)
				..()
				return

		icetea
			name = "Iced Tea"
			id = "icetea"
			description = "No relation to a certain rap artist/ actor."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				..()
				M:drowsyness = max(0,M:drowsyness-1)
				M:sleeping = 0
				if(M:toxloss && prob(50)) M:toxloss--
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature-5)
				return

		h_chocolate
			name = "Hot Chocolate"
			id = "h_chocolate"
			description = "Made with love! And coco beans."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				..()
				if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = min(310, M.bodytemperature+5)
				M:nutrition += 1
				return

		space_cola
			name = "Cola"
			id = "cola"
			description = "A refreshing beverage."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				M:drowsyness = max(0,M:drowsyness-5)
				if (M.bodytemperature > 310)//310 is the normal bodytemp. 310.055
					M.bodytemperature = max(310, M.bodytemperature-5)
				M:nutrition += 1
				..()
				return

		spacemountainwind
			name = "Space Mountain Wind"
			id = "spacemountainwind"
			description = "Blows right through you like a space wind."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				M:drowsyness = max(0,M:drowsyness-7)
				M:sleeping = 0
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-5)
				M:nutrition += 1
				..()
				return

		dr_gibb
			name = "Dr. Gibb"
			id = "dr_gibb"
			description = "A delicious blend of 42 different flavours"
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				M:drowsyness = max(0,M:drowsyness-6)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-5) //310 is the normal bodytemp. 310.055
				M:nutrition += 1
				..()
				return

		space_up
			name = "Space-Up"
			id = "space_up"
			description = "Tastes like a hull breach in your mouth."
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-8) //310 is the normal bodytemp. 310.055
				M:nutrition += 1
				..()
				return

		sodawater
			name = "Soda Water"
			id = "sodawater"
			description = "A can of club soda. Why not make a scotch and soda?"
			reagent_state = LIQUID
			on_mob_life(var/mob/simulated/M as mob)
				M:drowsyness = max(0,M:drowsyness-3)
				M:sleeping = 0
				if (M.bodytemperature > 310)
					M.bodytemperature = max(310, M.bodytemperature-5)
				..()
				return

		ice
			name = "Ice"
			id = "ice"
			description = "Frozen water, your dentist wouldn't like you chewing this."
			reagent_state = SOLID
			on_mob_life(var/mob/simulated/M as mob)
				if(!M) M = holder.my_atom
				M:bodytemperature -= 5
				..()
				return