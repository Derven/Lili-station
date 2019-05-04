/obj/item/other/coin
	icon_state = "coin"

/obj/machinery/vending
	var/amount = 3
	density = 1
	anchored = 1
	icon = 'vendomat.dmi'
	var/list/obj/item/my_items = list()
	var/list/obj/item/my_types= list()
	var/list/items_num = list()
	var/products
	var/myclick = 0
	var/my_text
	var/obj/item/clothing/id/curid
	var/prices

	New()
		..()
		tag = ""
		for(var/i = 1, i <= my_items.len, i++)
			var/type = my_items[i]
			my_items[i] = new type

			//type = my_items[i]


		for(var/g = 1, g <= my_items.len, g++)
			products += "<br><a class=\"pure-button pure-button-primary\" href='?src=\ref[src];my_item=[my_types[g]];my_what=[g];iam=[src.type]'>[my_items[g]]</a></br>"

	attackby(obj/item/W as obj, mob/simulated/living/humanoid/user as mob)
		if(istype(W, /obj/item/clothing/id))
			usr << "\blue ID data is loaded"
			curid = W

	attack_hand()
		my_text = {"
		<html>
		<head>
		<title>Vendomat</title>
		<link rel="stylesheet" href="https://unpkg.com/purecss@1.0.0/build/pure-min.css" integrity="sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w" crossorigin="anonymous">
		</head>
		<body>
		Products:
		[products]
		<br>

		</body>
		</html>
		"}

		usr << browse(my_text,"window=my_text")

	Topic(href,href_list[])
		if(usr.check_topic(src))
			if(href_list["my_item"] && href_list["my_what"])
				var/obj/item/l = href_list["my_item"]
				var/what = text2num(href_list["my_what"])
				if(istype(src, /obj/machinery/vending/trademat))
					if(!curid)
						return
					else
						if(items_num[what] > 0 && curid.credits >= prices[what])
							items_num[what] -= 1
							curid.credits -= prices[what]
							var/myprc = prices[what]
							usr << "You bought [my_items[what]] for [myprc] credits"
							new l(loc)
							curid = null
						else
							usr << "\red <b>No money</b>"
				else
					if(items_num[what] > 0)
						items_num[what] -= 1
						new l(loc)

				if(items_num[what] == 0)
					usr << "\red <b>No [my_items[what]]</b>"
				attack_hand()