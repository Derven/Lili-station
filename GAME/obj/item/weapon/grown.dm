/obj/item/weapon/reagent_containers/food/snacks/grown/chili

/obj/item/weapon/reagent_containers/food/snacks/grown/grapes

/obj/item/weapon/reagent_containers/food/snacks/grown/greengrapes

/obj/item/weapon/reagent_containers/food/snacks/grown/banana



// ***********************************************************
// Foods that are produced from hydroponics ~~~~~~~~~~
// Data from the seeds carry over to these grown foods
// ***********************************************************

//Grown foods
//Subclass so we can pass on values
/obj/item/weapon/reagent_containers/food
	var/trash

/obj/item/weapon/grown/bananapeel

/obj/item/weapon/grown/corncob

/obj/item/weapon/reagent_containers/food/snacks/grown/
	var/
		seed = ""
		plantname = ""
		product	//a type path
		lifespan = 0
		endurance = 0
		maturation = 0
		production = 0
		yield = 0
		plant_type = 0
		potency = -1
	icon = 'grown.dmi'

/obj/item/weapon/reagent_containers/food/snacks/grown/New(newloc, potency = 50)
	..()
	src.potency = potency
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/item/weapon/reagent_containers/food/snacks/grown/corn
	seed = "/obj/item/seeds/cornseed"
	name = "ear of corn"
	desc = "Needs some butter!"
	icon_state = "corn"
	trash = /obj/item/weapon/grown/corncob
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/corn

	New(var/loc, var/potency = 40)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/cherries
	seed = "/obj/item/seeds/cherryseed"
	name = "cherries"
	desc = "Great for toppings!"
	icon_state = "cherry"
	gender = PLURAL
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/cherries
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 15), 1))
			reagents.add_reagent("sugar", 1+round((potency / 15), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/poppy
	seed = "/obj/item/seeds/poppyseed"
	name = "poppy"
	desc = "Long-used as a symbol of rest, peace, and death."
	icon_state = "poppy"
	//slot_flags = SLOT_HEAD
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/poppy
	New(var/loc, var/potency = 30)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 20), 1))
			reagents.add_reagent("bicaridine", 1+round((potency / 10), 1))
			bitesize = 1+round(reagents.total_volume / 3, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/harebell
	seed = "obj/item/seeds/harebellseed"
	name = "harebell"
	desc = "\"I'll sweeten thy sad grave: thou shalt not lack the flower that's like thy face, pale primrose, nor the azured hare-bell, like thy veins; no, nor the leaf of eglantine, whom not to slander, out-sweeten’d not thy breath.\""
	icon_state = "harebell"
	//slot_flags = SLOT_HEAD
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/harebell
	New(var/loc, var/potency = 1)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 20), 1))
			bitesize = 1+round(reagents.total_volume / 3, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/potato
	seed = "/obj/item/seeds/potatoseed"
	name = "potato"
	desc = "Boil 'em! Mash 'em! Stick 'em in a stew!"
	icon_state = "potato"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/potato
	New(var/loc, var/potency = 25)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			bitesize = reagents.total_volume

/obj/item/weapon/reagent_containers/food/snacks/grown/grapes
	seed = "/obj/item/seeds/grapeseed"
	name = "bunch of grapes"
	desc = "Nutritious!"
	icon_state = "grapes"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/no_raisin
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			reagents.add_reagent("sugar", 1+round((potency / 5), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/greengrapes
	seed = "/obj/item/seeds/greengrapeseed"
	name = "bunch of green grapes"
	desc = "Nutritious!"
	icon_state = "greengrapes"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/no_raisin
	New(var/loc, var/potency = 25)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			reagents.add_reagent("kelotane", 3+round((potency / 5), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/cabbage
	seed = "/obj/item/seeds/cabbageseed"
	name = "cabbage"
	desc = "Ewwwwwwwwww. Cabbage."
	icon_state = "cabbage"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/cabbage
	New(var/loc, var/potency = 25)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			bitesize = reagents.total_volume

/obj/item/weapon/reagent_containers/food/snacks/grown/berries
	seed = "/obj/item/seeds/berryseed"
	name = "bunch of berries"
	desc = "Nutritious!"
	icon_state = "berrypile"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/berries
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/glowberries
	seed = "/obj/item/seeds/glowberryseed"
	name = "bunch of glow-berries"
	desc = "Nutritious!"
	var/on = 1
	var/brightness_on = 2 //luminosity when on
	icon_state = "glowberrypile"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/glowberries
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", round((potency / 10), 1))
			reagents.add_reagent("uranium", 3+round(potency / 5, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/cocoapod
	seed = "/obj/item/seeds/cocoapodseed"
	name = "cocoa pod"
	desc = "Fattening... Mmmmm... chucklate."
	icon_state = "cocoapod"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/cocoapod
	New(var/loc, var/potency = 50)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			reagents.add_reagent("coco", 4+round((potency / 5), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/sugarcane
	seed = "/obj/item/seeds/sugarcaneseed"
	name = "sugarcane"
	desc = "Sickly sweet."
	icon_state = "sugarcane"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/sugarcane
	New(var/loc, var/potency = 50)
		..()
		if(reagents)
			reagents.add_reagent("sugar", 4+round((potency / 5), 1))

/obj/item/weapon/reagent_containers/food/snacks/grown/poisonberries
	seed = "/obj/item/seeds/poisonberryseed"
	name = "bunch of poison-berries"
	desc = "Taste so good, you could die!"
	icon_state = "poisonberrypile"
	gender = PLURAL
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/poisonberries
	New(var/loc, var/potency = 15)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1)
			reagents.add_reagent("toxin", 3+round(potency / 5, 1))
			reagents.add_reagent("maizine", 1+round(potency / 5, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/deathberries
	seed = "/obj/item/seeds/deathberryseed"
	name = "bunch of death-berries"
	desc = "Taste so good, you could die!"
	icon_state = "deathberrypile"
	gender = PLURAL
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/deathberries
	New(var/loc, var/potency = 50)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1)
			reagents.add_reagent("ehuadol", 2+round(potency / 5, 1))
			reagents.add_reagent("lexorin", 1+round(potency / 5, 1))
			reagents.add_reagent("toxin", 3+round(potency / 3, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiavulgaris
	seed = "/obj/item/seeds/ambrosiavulgaris"
	name = "ambrosia vulgaris branch"
	desc = "This is a plant containing various healing chemicals."
	icon_state = "ambrosiavulgaris"
	//slot_flags = SLOT_HEAD
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiavulgaris
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1)
			reagents.add_reagent("space_drugs", 1+round(potency / 8, 1))
			reagents.add_reagent("kelotane", 1+round(potency / 8, 1))
			reagents.add_reagent("bicaridine", 1+round(potency / 10, 1))
			reagents.add_reagent("toxin", 1+round(potency / 10, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus
	seed = "/obj/item/seeds/ambrosiadeus"
	name = "ambrosia deus branch"
	desc = "Eating this makes you feel immortal!"
	icon_state = "ambrosiadeus"
	//slot_flags = SLOT_HEAD
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1)
			reagents.add_reagent("bicaridine", 1+round(potency / 8, 1))
			reagents.add_reagent("synaptizine", 1+round(potency / 8, 1))
			reagents.add_reagent("hyperzine", 1+round(potency / 10, 1))
			reagents.add_reagent("space_drugs", 1+round(potency / 10, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/apple
	seed = "/obj/item/seeds/appleseed"
	name = "apple"
	desc = "It's a little piece of Eden."
	icon_state = "apple"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/apple
	New(var/loc, var/potency = 15)
		..()
		if(reagents)
			reagents.maximum_volume = 20
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			bitesize = reagents.maximum_volume // Always eat the apple in one

/obj/item/weapon/reagent_containers/food/snacks/grown/apple/poisoned
	seed = "/obj/item/seeds/poisonedappleseed"
	name = "apple"
	desc = "It's a little piece of Eden."
	icon_state = "apple"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/apple/poisoned
	New(var/loc, var/potency = 15)
		..()
		if(reagents)
			reagents.maximum_volume = 20
			reagents.add_reagent("cyanide", 1+round((potency / 5), 1))
			bitesize = reagents.maximum_volume // Always eat the apple in one

/obj/item/weapon/reagent_containers/food/snacks/grown/goldapple
	seed = "/obj/item/seeds/goldappleseed"
	name = "golden apple"
	desc = "Emblazoned upon the apple is the word 'Kallisti'."
	icon_state = "goldapple"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/goldapple
	New(var/loc, var/potency = 15)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			reagents.add_reagent("gold", 1+round((potency / 5), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/watermelon
	seed = "/obj/item/seeds/watermelonseed"
	name = "watermelon"
	desc = "It's full of watery goodness."
	icon_state = "watermelon"
	slices_num = 5
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 6), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/pumpkin
	seed = "/obj/item/seeds/pumpkinseed"
	name = "pumpkin"
	desc = "It's large and scary."
	icon_state = "pumpkin"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/pumpkin
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 6), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/lime
	seed = "/obj/item/seeds/limeseed"
	name = "lime"
	desc = "It's so sour, your face will twist."
	icon_state = "lime"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/lime
	New(var/loc, var/potency = 20)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 20), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/lemon
	seed = "/obj/item/seeds/lemonseed"
	name = "lemon"
	desc = "When life gives you lemons, be grateful they aren't limes."
	icon_state = "lemon"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/lemon
	New(var/loc, var/potency = 20)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 20), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/orange
	seed = "/obj/item/seeds/orangeseed"
	name = "orange"
	desc = "It's an tangy fruit."
	icon_state = "orange"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/orange
	New(var/loc, var/potency = 20)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 20), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/whitebeet
	seed = "/obj/item/seeds/whitebeetseed"
	name = "white-beet"
	desc = "You can't beat white-beet."
	icon_state = "whitebeet"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/whitebeet
	New(var/loc, var/potency = 15)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", round((potency / 20), 1))
			reagents.add_reagent("sugar", 1+round((potency / 5), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/banana
	seed = "/obj/item/seeds/bananaseed"
	name = "banana"
	desc = "It's an excellent prop for a clown."
	icon = 'grown.dmi'
	icon_state = "banana"
	trash = /obj/item/weapon/grown/bananapeel
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/banana

	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("banana", 1+round((potency / 10), 1))
			bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/grown/chili
	seed = "/obj/item/seeds/chiliseed"
	name = "chili"
	desc = "It's spicy! Wait... IT'S BURNING ME!!"
	icon_state = "chilipepper"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/chili
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 25), 1))
			reagents.add_reagent("capsaicin", 3+round(potency / 5, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/ghost_chilli
	seed = "/obj/item/seeds/chillighost"
	name = "ghost chili"
	desc = "It seems to be viusring gently."
	icon_state = "ghostchilipepper"
	var/mob/held_mob
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/ghost_chilli
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 25), 1))
			reagents.add_reagent("blazeoil", max(0, potency-80))
			reagents.add_reagent("capsaicin", 8+round(potency / 2, 1))
			reagents.add_reagent("condensedcapsaicin", 4+round(potency / 4, 1))

			bitesize = 1+round(reagents.total_volume / 4, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/eggplant
	seed = "/obj/item/seeds/eggplantseed"
	name = "eggplant"
	desc = "Maybe there's a chicken inside?"
	icon_state = "eggplant"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/eggplant
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans
	seed = "/obj/item/seeds/soyaseed"
	name = "soybeans"
	desc = "It's pretty bland, but oh the possibilities..."
	gender = PLURAL
	icon_state = "soybeans"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/soybeans
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 20), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/koibeans
	seed = "/obj/item/seeds/koiseed"
	name = "koibean"
	desc = "Something about these seems fishy."
	icon_state = "koibeans"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/koibeans
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 30), 1))
			reagents.add_reagent("carpotoxin", 1+round((potency / 20), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/moonflower
	seed = "/obj/item/seeds/moonflowerseed"
	name = "moonflower"
	desc = "Store in a location at least 50 yards away from werewolves."
	icon_state = "moonflower"
	//slot_flags = SLOT_HEAD
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 50), 1))
			reagents.add_reagent("moonshine", 1+round((potency / 10), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/tomato
	seed = "/obj/item/seeds/tomatoseed"
	name = "tomato"
	desc = "I say to-mah-to, you say tom-mae-to."
	icon_state = "tomato"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/tomato
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/killertomato
	seed = "/obj/item/seeds/killertomatoseed"
	name = "killer-tomato"
	desc = "I say to-mah-to, you say tom-mae-to... OH GOD IT'S EATING MY LEGS!!"
	icon_state = "killertomato"
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/bluetomato
	seed = "/obj/item/seeds/bluetomatoseed"
	name = "blue-tomato"
	desc = "I say blue-mah-to, you say blue-mae-to."
	icon_state = "bluetomato"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/bluetomato
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 20), 1))
			reagents.add_reagent("lube", 1+round((potency / 5), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/wheat
	seed = "/obj/item/seeds/wheatseed"
	name = "wheat"
	desc = "Sigh... wheat... a-grain?"
	gender = PLURAL
	icon_state = "wheat"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/wheat
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 25), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/grass
	seed = "/obj/item/seeds/grassseed"
	name = "grass"
	desc = "Green and lush."
	icon_state = "grassclump"
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 50), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/icepepper
	seed = "/obj/item/seeds/icepepperseed"
	name = "ice-pepper"
	desc = "It's a mutant strain of chili"
	icon_state = "icepepper"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/icepepper
	New(var/loc, var/potency = 20)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 50), 1))
			reagents.add_reagent("frostoil", 3+round(potency / 5, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/carrot
	seed = "/obj/item/seeds/carrotseed"
	name = "carrot"
	desc = "It's good for the eyes!"
	icon_state = "carrot"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/carrot
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 20), 1))
			reagents.add_reagent("imidazoline", 3+round(potency / 5, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/reishi
	seed = "/obj/item/seeds/reishimycelium"
	name = "reishi"
	desc = "<I>Ganoderma lucidum</I>: A special fungus known for its medicinal and stress relieving properties."
	icon_state = "reishi"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/reishi
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1)
			reagents.add_reagent("anti_toxin", 3+round(potency / 3, 1))
			reagents.add_reagent("stoxin", 3+round(potency / 3, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/amanita
	seed = "/obj/item/seeds/amanitamycelium"
	name = "fly amanita"
	desc = "<I>Amanita Muscaria</I>: Learn poisonous mushrooms by heart. Only pick mushrooms you know."
	icon_state = "amanita"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/amanita
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1)
			reagents.add_reagent("amatoxin", 3+round(potency / 3, 1))
			reagents.add_reagent("mushroomhallucinogen", 1+round(potency / 25, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/angel
	seed = "/obj/item/seeds/angelmycelium"
	name = "destroying angel"
	desc = "<I>Amanita Virosa</I>: Deadly poisonous basidiomycete fungus filled with alpha amatoxins."
	icon_state = "angel"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/angel
	New(var/loc, var/potency = 35)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 50), 1))
			reagents.add_reagent("amatoxin", 13+round(potency / 3, 1))
			reagents.add_reagent("mushroomhallucinogen", 1+round(potency / 25, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/libertycap
	seed = "/obj/item/seeds/libertymycelium"
	name = "liberty-cap"
	desc = "<I>Psilocybe Semilanceata</I>: Liberate yourself!"
	icon_state = "libertycap"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/libertycap
	New(var/loc, var/potency = 15)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 50), 1))
			reagents.add_reagent("mushroomhallucinogen", 3+round(potency / 5, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/plumphelmet
	seed = "/obj/item/seeds/plumpmycelium"
	name = "plump-helmet"
	desc = "<I>Plumus Hellmus</I>: Plump, soft and s-so inviting~"
	icon_state = "plumphelmet"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/plumphelmet
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 2+round((potency / 10), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/walkingmushroom
	seed = "/obj/item/seeds/walkingmushroom"
	name = "walking mushroom"
	desc = "<I>Plumus Locomotus</I>: The beginning of the great walk."
	icon_state = "walkingmushroom"
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 2+round((potency / 10), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/chanterelle
	seed = "/obj/item/seeds/chantermycelium"
	name = "chanterelle cluster"
	desc = "<I>Cantharellus Cibarius</I>: These jolly yellow little shrooms sure look tasty!"
	icon_state = "chanterelle"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/chanterelle
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 25), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/gatfruit
	seed = "/obj/item/seeds/gatfruit"
	name = "gatfruit"
	desc = "It smells like burning."
	icon_state = "gatfruit"
	trash = /obj/item/weapon/gun
	New(var/loc, var/potency = 60)
		..()
		if(reagents)
			reagents.add_reagent("sulfur", 1+round((potency / 10), 1))
			reagents.add_reagent("carbon", 1+round((potency / 10), 1))
			reagents.add_reagent("nitrogen", 1+round((potency / 15), 1))
			reagents.add_reagent("potassium", 1+round((potency / 20), 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/coffee_arabica
	seed = "/obj/item/seeds/coffee_arabica_seed"
	name = "coffee arabica beans"
	desc = "Dry them out to make coffee."
	icon_state = "coffee_arabica"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/coffee_arabica
	New(var/loc, var/potency = 20)
		..()
		if(reagents)
			reagents.add_reagent("coffeepowder", 1+round((potency / 10), 2))

/obj/item/weapon/reagent_containers/food/snacks/grown/coffee_robusta
	seed = "/obj/item/seeds/coffee_robusta_seed"
	name = "coffee robusta beans"
	desc = "Dry them out to make coffee."
	icon_state = "coffee_robusta"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/coffee_robusta
	New(var/loc, var/potency = 20)
		..()
		if(reagents)
			reagents.add_reagent("coffeepowder", 1+round((potency / 10), 2))
			reagents.add_reagent("hyperzine", 1+round((potency / 20), 1))

/obj/item/weapon/reagent_containers/food/snacks/grown/tobacco
	seed = "/obj/item/seeds/tobacco_seed"
	name = "tobacco leaves"
	desc = "Dry them out to make some smokes."
	icon_state = "tobacco_leaves"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/tobacco
	New(vat/loc, var/potency = 20)
		..()


/obj/item/weapon/reagent_containers/food/snacks/grown/tobacco_space
	seed = "/obj/item/seeds/tobacco_space_seed"
	name = "space tobacco leaves"
	desc = "Dry them out to make some space-smokes."
	icon_state = "stobacco_leaves"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/tobacco_space
	New(var/loc, var/potency = 20)
		..()
		if(reagents)
			reagents.add_reagent("dexalin", 1+round((potency / 20), 1))


/obj/item/weapon/reagent_containers/food/snacks/grown/tea_aspera
	seed = "/obj/item/seeds/tea_aspera_seed"
	name = "Tea Aspera tips"
	desc = "These aromatic tips of the tea plant can be dried to make tea."
	icon_state = "tea_aspera_leaves"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/tea_aspera
	New(var/loc, var/potency = 20)
		..()
		if(reagents)
			reagents.add_reagent("teapowder", 1+round((potency / 10), 2))


/obj/item/weapon/reagent_containers/food/snacks/grown/tea_astra
	seed = "/obj/item/seeds/tea_astra_seed"
	name = "Tea Astra tips"
	desc = "These aromatic tips of the tea plant can be dried to make tea."
	icon_state = "tea_astra_leaves"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/tea_astra
	New(var/loc, var/potency = 20)
		..()
		if(reagents)
			reagents.add_reagent("teapowder", 1+round((potency / 10), 2))
			reagents.add_reagent("kelotane", 1+round((potency / 20), 1))

/obj/item/weapon/reagent_containers/food/snacks/grown/cannabis
	seed = "/obj/item/seeds/cannabis"
	name = "cannabis leaf"
	desc = "420."
	icon_state = "cannabis"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/cannabis
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1)
			reagents.add_reagent("space_drugs", 30+round(potency / 8, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)


/obj/item/weapon/reagent_containers/food/snacks/grown/rainbowcannabis
	seed = "/obj/item/seeds/rainbowcannabis"
	name = "rainbow cannabis leaf"
	desc = "BLAZE IT"
	icon_state = "rainbowcannabis"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/rainbowcannabis
	New(var/loc, var/potency = 10)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1)
			reagents.add_reagent("space_drugs", 20+round(potency / 8, 1))
			reagents.add_reagent("mindbreaker", 20+round(potency / 8, 1))
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/singulopotato
	seed = "/obj/item/seeds/singulopotatoseed"
	name = "singularity potato"
	desc = "This strange potato seems to have its own gravitational pull..."
	icon_state = "singulopotato"
	//dried_type = /obj/item/weapon/reagent_containers/food/snacks/grown/potato
	New(var/loc, var/potency = 25)
		..()
		if(reagents)
			reagents.add_reagent("nutriments", 1+round((potency / 10), 1))
			bitesize = reagents.total_volume
