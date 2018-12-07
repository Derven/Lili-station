/obj/item/other/coin
	icon_state = "coin"

/obj/machinery/vending
	var/amount = 3
	density = 1
	icon = 'vendomat.dmi'
	var/list/obj/item/my_items = list()
	var/list/obj/item/my_types= list()
	var/list/items_num = list()
	var/products
	var/myclick = 0
	var/my_text

	New()
		..()
		tag = ""
		for(var/i = 1, i <= my_items.len, i++)
			var/type = my_items[i]
			my_items[i] = new type

			//type = my_items[i]


		for(var/g = 1, g <= my_items.len, g++)
			products += "<br><a href='?src=\ref[src];my_item=[my_types[g]];my_what=[g];iam=[src.type]'>[my_items[g]]</a>"

	attack_hand()
		my_text = {"
		<html>
		<head><title>Vendomat</title></head>
		<body>
		Products:
		[products]
		<br>

		</body>
		</html>
		"}

		usr << browse(my_text,"window=my_text")

	Topic(href,href_list[])
		if(href_list["my_item"] && href_list["my_what"])
			var/obj/item/l = href_list["my_item"]
			var/what = text2num(href_list["my_what"])
			if(items_num[what] > 0)
				items_num[what] -= 1
				new l(loc)

			if(items_num[what] == 0)
				usr << "\red <b>No [my_items[what]]</b>"
			attack_hand()