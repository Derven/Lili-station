
//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effects besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine). On use
//	effects (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/weapon/reagent_containers/food/snacks/xenoburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//	New()																//Don't mess with this.
//		..()															//Same here.
//		reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent("nutriments", 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.

/obj/item/weapon/reagent_containers/food/snacks
	var/bitesize
	var/slices_num
	var/slice_path
	price = 0.5
	icon = 'chemical.dmi'

/obj/item/weapon/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Nougat love it or hate it."
	icon_state = "candy"
	New()
		..()
		reagents.add_reagent("nutriments", 1)
		reagents.add_reagent("sugar", 3)

/obj/item/weapon/reagent_containers/food/snacks/candy_corn
	name = "candy corm" //Not a typo
	desc = "It's a handful of candy corm. Can be stored in a detective's hat."
	icon_state = "candy_corn"
	New()
		..()
		reagents.add_reagent("nutriments", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	New()
		..()
		reagents.add_reagent("nutriments", 16)

/obj/item/weapon/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut"
	New()
		..()
		reagents.add_reagent("nutriments", 3)
		reagents.add_reagent("sprinkles", 1)
		if(prob(30))
			src.icon_state = "donut"
			src.name = "frosted donut"
			src.bitesize = 2
			reagents.add_reagent("nutriments", 2)
			reagents.add_reagent("sprinkles", 1)

/obj/item/weapon/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	New()
		..()
		reagents.add_reagent("nutriments", 1)

/obj/item/weapon/reagent_containers/food/snacks/flour
	name = "flour"
	desc = "Some flour"
	icon_state = "flour"
	New()
		..()
		reagents.add_reagent("nutriments", 1)

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/egg))
			new /obj/item/weapon/reagent_containers/food/dough(src.loc)
			del(W)
			del(src)

/obj/item/weapon/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
	New()
		..()
		reagents.add_reagent("nutriments", 3)

/obj/item/weapon/reagent_containers/food/snacks/meat/human
	name = "-meat"
	var/subjectname = ""
	var/subjectjob = null

/obj/item/weapon/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/weapon/reagent_containers/food/snacks/tofu
	name = "Tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	New()
		..()
		reagents.add_reagent("nutriments", 3)


/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	name = "carp fillet"
	desc = "A fillet of spess carp meat"
	icon_state = "fishfillet"
	New()
		..()
		reagents.add_reagent("nutriments", 3)
		reagents.add_reagent("carpotoxin", 3)

/obj/item/weapon/reagent_containers/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "xenomeat"
	New()
		..()
		reagents.add_reagent("nutriments", 3)

/obj/item/weapon/reagent_containers/food/snacks/faggot
	name = "Faggot"
	desc = "A great meal all round. Not a cord of wood."
	icon_state = "faggot"
	New()
		..()
		reagents.add_reagent("nutriments", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/donkpocket
	name = "Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	New()
		..()
		reagents.add_reagent("nutriments", 2)
	var/warm = 0
	proc/cooltime() //Not working, derp?
		if (src.warm)
			spawn( 4200 )
				src.warm = 0
				src.reagents.del_reagent("tricordrazine")
				src.name = "donk-pocket"
		return

/obj/item/weapon/reagent_containers/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	New()
		..()
		reagents.add_reagent("nutriments", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/human
	var/hname = ""
	var/job = null

/obj/item/weapon/reagent_containers/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"
	New()
		..()
		reagents.add_reagent("nutriments", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/monkeyburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	New()
		..()
		reagents.add_reagent("nutriments", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/fishburger
	name = "Fillet -o- Carp Sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	New()
		..()
		reagents.add_reagent("nutriments", 8)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofuburger
	name = "Tofu Burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	New()
		..()
		reagents.add_reagent("nutriments", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	New()
		..()
		reagents.add_reagent("nutriments", 2)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	New()
		..()
		reagents.add_reagent("xenomicrobes", 10)
		reagents.add_reagent("nutriments", 2)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/clownburger
	name = "Clown Burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	New()
		..()
/*
		var/datum/disease/F = new /datum/disease/pierrot_throat(0)
		var/list/data = list("virus"= F)
		reagents.add_reagent("blood", 4, data)
*/
		reagents.add_reagent("nutriments", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/mimeburger
	name = "Mime Burger"
	desc = "It's taste defies language."
	icon_state = "mimeburger"
	New()
		..()
		reagents.add_reagent("nutriments", 8)
		bitesize = 2
/*
 * Unsuse.
/obj/item/weapon/reagent_containers/food/snacks/omeletteforkload
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	New()
		..()
		reagents.add_reagent("nutriments", 1)
*/

/obj/item/weapon/reagent_containers/food/snacks/muffin
	name = "Muffin"
	desc = "A delicious and spongy little cake"
	icon_state = "muffin"
	New()
		..()
		reagents.add_reagent("nutriments", 6)

/obj/item/weapon/reagent_containers/food/snacks/pie
	name = "Banana Cream Pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	New()
		..()
		reagents.add_reagent("nutriments", 4)
		reagents.add_reagent("banana",5)
/*
/obj/item/weapon/reagent_containers/food/snacks/berrypie
	name = "Very Berry Pie"
	desc = "No black birds, this is a good sign."
	icon_state = "pie"
	New()
		..()
		reagents.add_reagent("nutriments", 4)
		reagents.add_reagent("berryjuice", 5)
*/

/obj/item/weapon/reagent_containers/food/snacks/berryclafoutis
	name = "Berry Clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	New()
		..()
		reagents.add_reagent("nutriments", 4)
		reagents.add_reagent("berryjuice", 5)

/obj/item/weapon/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles"
	New()
		..()
		reagents.add_reagent("nutriments", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/eggplantparm
	name = "Eggplant Parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	New()
		..()
		reagents.add_reagent("nutriments", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soylentgreen
	name = "Soylent Green"
	desc = "Not made of people. Honest." //Totally people.
	icon_state = "soylent"
	New()
		..()
		reagents.add_reagent("nutriments", 14)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soylenviridians
	name = "Soylen Virdians"
	desc = "Not made of people. Honest." //Actually honest for once.
	icon_state = "soylent"
	New()
		..()
		reagents.add_reagent("nutriments", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/humeatpie
	name = "Meat-pie"
//	var/hname = "" //TODO: need some way to find out that facts for the characters.
//	var/job = null
	icon_state = "meatpie"
	desc = "The best meatpies on station."
	New()
		..()
		reagents.add_reagent("nutriments", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/momeatpie

/obj/item/weapon/reagent_containers/food/snacks/momeatpie
	name = "Meat-pie"
	icon_state = "meatpie"
	desc = "A delicious meatpie."
	New()
		..()
		reagents.add_reagent("nutriments", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofupie
	name = "Tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	New()
		..()
		reagents.add_reagent("nutriments", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/xemeatpie
	name = "Xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	New()
		..()
		reagents.add_reagent("nutriments", 2)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/wingfangchu
	name = "Wing Fang Chu"
	desc = "A savory dish of alien wing wang in soy."
	icon_state = "wingfangchu"
	New()
		..()
		reagents.add_reagent("nutriments", 1)
		reagents.add_reagent("xenomicrobes", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chaosdonut
	name = "Chaos Donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
	New()
		..()
		reagents.add_reagent("nutriments", 3)
		bitesize = 2
		if(prob(30))
			src.icon_state = "donut2"
			src.name = "Frosted Chaos Donut"
			reagents.add_reagent("sprinkles", 3)
		reagents.add_reagent(pick("capsaicin", "frostoil", "nutriments"), 3)

/obj/item/weapon/reagent_containers/food/snacks/cubancarp
	name = "Cuban Carp"
	desc = "A grifftastic sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	New()
		..()
		reagents.add_reagent("nutriments", 6)
		reagents.add_reagent("carpotoxin", 3)
		reagents.add_reagent("capsaicin", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	New()
		..()
		reagents.add_reagent("nutriments", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/no_raisin
	name = "4no Raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	New()
		..()
		reagents.add_reagent("nutriments", 6)

/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie
	name = "Space Twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer then you will."
	New()
		..()
		reagents.add_reagent("sugar", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers
	name = "Cheesie Honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth"
	New()
		..()
		reagents.add_reagent("nutriments", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/syndicake
	name = "Syndi-Cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	New()
		..()
		reagents.add_reagent("nutriments", 4)
		reagents.add_reagent("syndicream", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato
	name = "Loaded Baked Potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	New()
		..()
		reagents.add_reagent("nutriments", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/fries
	name = "Space Fries"
	desc = "AKA: French Fries, Freedom Fries, etc"
	icon_state = "fries"
	New()
		..()
		reagents.add_reagent("nutriments", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/popcorn
	name = "popcorn"
	desc = "popcorn"
	icon_state = "popcorn"
	New()
		..()
		reagents.add_reagent("nutriments", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesyfries
	name = "Cheesy Fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	New()
		..()
		reagents.add_reagent("nutriments", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesyfries
	name = "Cheesy Fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	New()
		..()
		reagents.add_reagent("nutriments", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/badrecipe
	name = "GOVNO"
	desc = "Someone should be demoted from chef for this."
	icon_state = "burned"
	New()
		..()
		reagents.add_reagent("toxin", 1)
		reagents.add_reagent("carbon", 1)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/meatstake
	name = "Meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	New()
		..()
		reagents.add_reagent("nutriments", 6)
		bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/spacylibertyduff
	name = "Spacy Liberty Duff"
	desc = "" //TODO
	icon_state = "spacylibertyduff"
	New()
		..()
		reagents.add_reagent("nutriments", 6)
		reagents.add_reagent("water", 6)
		reagents.add_reagent("psilocybin", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/amanitajelly
	name = "Amanita Jelly"
	desc = "Looks curiously"
	icon_state = "amanitajelly"
	New()
		..()
		reagents.add_reagent("nutriments", 6)
		reagents.add_reagent("water", 6)
		reagents.add_reagent("psilocybin", 6)
		bitesize = 3
/*
/obj/item/weapon/reagent_containers/food/snacks/poppypretzel
	name = "Poppy pretzel"
	desc = "" //TODO
	icon_state = "poppypretzel"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriments", 5)
		bitesize = 2
*/

/obj/item/weapon/reagent_containers/food/snacks/meatballsoup
	name = "Meatball soup"
	desc = "" //TODO
	icon_state = "meatballsoup"
	New()
		..()
		reagents.add_reagent("nutriments", 10)
		reagents.add_reagent("water", 10)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/vegetablesoup
	name = "Vegetable soup"
	desc = "" //TODO
	icon_state = "soup"
	New()
		..()
		reagents.add_reagent("nutriments", 10)
		reagents.add_reagent("water", 10)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/nettlesoup
	name = "Nettle soup"
	desc = "" //TODO
	icon_state = "nettlesoup"
	New()
		..()
		reagents.add_reagent("nutriments", 10)
		reagents.add_reagent("water", 10)
		reagents.add_reagent("tricordrazine", 3)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/hotchili
	name = "Hot Chili"
	desc = "" //TODO
	icon_state = "hotchili"
	New()
		..()
		reagents.add_reagent("nutriments", 6)
		reagents.add_reagent("capsaicin", 3)
		reagents.add_reagent("tomatojuice", 2)
		bitesize = 5


/obj/item/weapon/reagent_containers/food/snacks/coldchili
	name = "Cold Chili"
	desc = "" //TODO
	icon_state = "coldchili"
	New()
		..()
		reagents.add_reagent("nutriments", 6)
		reagents.add_reagent("frostoil", 3)
		reagents.add_reagent("tomatojuice", 2)
		bitesize = 5

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

/obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman."
	icon_state = "meatbread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meatbreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriments", 40)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meatbreadslice
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman. Extra Heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriments", 5)
		reagents.add_reagent("xenomicrobes", 35)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread
	name = "Banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "tofubread" //TODO: filler sprite till there is a banana bread sprite
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/bananabreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("banana", 20)
		reagents.add_reagent("nutriments", 20)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bananabreadslice
	name = "Banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "tofubreadslice" //TODO: Filler sprite
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread
	name = "Tofubread"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/tofubreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriments", 40)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofubreadslice
	name = "Tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake
	name = "Carrot Cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriments", 30)
		reagents.add_reagent("imidazoline", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice
	name = "Carrot Cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake
	name = "Cheese Cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriments", 30)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice
	name = "Cheese Cake slice"
	desc = "Slice of pure cheestisfaction"
	icon_state = "cheesecake_slice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake
	name = "Vanilla Cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/plaincakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriments", 25)


/obj/item/weapon/reagent_containers/food/snacks/plaincakeslice
	name = "Vanilla Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel
	name = "Cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon_state = "cheesewheel"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriments", 20)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	name = "Cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheese"
	bitesize = 2


/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza
	slices_num = 6

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "Margherita"
	desc = "The most cheezy pizza in galaxy"
	icon_state = "pizzamargherita"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/margheritaslice
	New()
		..()
		reagents.add_reagent("nutriments", 40)
		reagents.add_reagent("tomatojuice", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/margheritaslice
	name = "Margherita slice"
	desc = "A slice of the most cheezy pizza in galaxy"
	icon_state = "pizzamargheritaslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	name = "Meatpizza"
	desc = "" //TODO:
	icon_state = "meatpizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice
	New()
		..()
		reagents.add_reagent("nutriments", 50)
		reagents.add_reagent("tomatojuice", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice
	name = "Meatpizza slice"
	desc = "A slice of " //TODO:
	icon_state = "meatpizzaslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	name = "Mushroompizza"
	desc = "Very special pizza"
	icon_state = "mushroompizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice
	New()
		..()
		reagents.add_reagent("nutriments", 35)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice
	name = "Mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	name = "Vegetable pizza"
	desc = "No one of Tomatos Sapiens were harmed during making this pizza"
	icon_state = "vegetablepizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice
	New()
		..()
		reagents.add_reagent("nutriments", 30)
		reagents.add_reagent("tomatojuice", 6)
		reagents.add_reagent("imidazoline", 12)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice
	name = "Vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients "
	icon_state = "vegetablepizzaslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/pill/potassium
	name = "potassium pill"

	New()
		..()
		reagents.add_reagent("potassium", 30)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/pill
	icon = 'chemical.dmi'
	icon_state = "pills"

	tric_pill
		name = "tricordrazine pill"

		New()
			..()
			reagents.add_reagent("tricordrazine", 30)
			bitesize = 2

	anti_toxin
		name = "anti-toxin pill"

		New()
			..()
			reagents.add_reagent("anti_toxin", 30)
			bitesize = 2

	leporazine
		name = "leporazine pill"
		desc = "Leporazine can be use to stabilize an individuals body temperature."

		New()
			..()
			reagents.add_reagent("leporazine", 30)
			bitesize = 2

	dexalin
		name = "dexalin pill"
		desc = "Dexalin is used in the treatment of oxygen deprivation."

		New()
			..()
			reagents.add_reagent("dexalin", 30)
			bitesize = 2

	sleeping
		name = "sleeping pill"
		icon_state = "pills"
		pixel_z = 5
		pixel_x = -13
		ignore_ZLEVEL = 1

		New()
			..()
			reagents.add_reagent("sleeping", 30)
			bitesize = 2
			pixel_z = 5
			pixel_x = -13
			layer = 15

	epinephrine
		name = "epinephrine pill"
		icon_state = "pills"

		New()
			..()
			reagents.add_reagent("epinephrine", 30)
			bitesize = 2

	caffeine
		name = "caffeine pill"
		icon_state = "pills"

		New()
			..()
			reagents.add_reagent("caffeine", 30)
			bitesize = 2

	tramadol
		name = "tramadol pill"
		icon_state = "pills_orange"

		New()
			..()
			reagents.add_reagent("tramadol", 30)
			bitesize = 2

	kelotane
		name = "kelotane pill"
		icon_state = "pills_orange"

		New()
			..()
			reagents.add_reagent("kelotane", 30)
			bitesize = 2

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
