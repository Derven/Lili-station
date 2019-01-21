/obj/machinery/autholate
	icon='stationobjs.dmi'
	icon_state = "autolathe"
	density = 1
	anchored = 0
	var/metal = 100

	var/list/one_metal_unit = list(/obj/item/weapon/wrench, /obj/item/construct/solars, /obj/item/construct/lamp, /obj/item/weapon/wirecutters, /obj/item/weapon/weldingtool)
	var/list/two_metal_unit = list(/obj/item/weapon/fire_ext, /obj/item/construct/apc, /obj/item/construct/chair, /obj/item/construct/grille, /obj/item/construct/stool, /obj/item/stack/tile)
	var/list/three_metal_unit = list(/obj/item/stack/table_parts, /obj/item/construct/airlock, /obj/item/construct/airlock_glass, /obj/item/construct/closet, /obj/item/construct/crate)
	var/list/one_metal_product = list()
	var/list/two_metal_product = list()
	var/list/three_metal_product = list()

	proc
		ainitialization()
			for(var/I in one_metal_unit)
				var/obj/O = new I(src)
				one_metal_product.Add(O)
			for(var/I in two_metal_unit)
				var/obj/O = new I(src)
				two_metal_product.Add(O)
			for(var/I in three_metal_unit)
				var/obj/O = new I(src)
				three_metal_product.Add(O)
			metal = 100

	New()
		..()
		ainitialization()

	attack_hand()

		var/dat = "<html><head><title>Autholate</title></head> \
		<body> \
		<h2>Metal amount: [metal]</h2></br>\
		<h1>Small metal products</h1></br>"

		for (var/obj/item/I in one_metal_product)
			dat += "<a href='?src=\ref[src];product1=[I.type];'>[I]</a></br>"

		dat += "<h1>Medium metal products</h1>"
		for (var/obj/item/I in two_metal_product)
			dat += "<a href='?src=\ref[src];product2=[I.type];'>[I]</a></br>"

		dat += "<h1>Large metal products</h1>"
		for (var/obj/item/I in three_metal_product)
			dat += "<a href='?src=\ref[src];product3=[I.type];'>[I]</a></br>"

		dat += "</body></html>"
		usr << browse(dat,"window=autholate")

	attackby(obj/item/weapon/W as obj, mob/simulated/living/humanoid/user as mob)
		if(istype(W, /obj/item/stack/metal))
			metal += 1
			user.drop_item(src)
			W.Move(src)


	floortolathe
		icon='stationobjs.dmi'
		icon_state = "floortolathe"
		one_metal_unit = list()
		two_metal_unit = list(/obj/item/stack/tile/catwalk, /obj/item/stack/tile/blue, /obj/item/stack/tile/red,
		/obj/item/stack/tile/bar, /obj/item/stack/tile/kitchen, /obj/item/stack/tile/orange)
		three_metal_unit = list()
		one_metal_product = list()
		two_metal_product = list()
		three_metal_product = list()


/obj/machinery/autholate/Topic(href,href_list[])
	if(href_list["product1"])
		if(metal > 0)
			var/obj/item/I = href_list["product1"]
			new I(src.loc)
			metal -= 1
			attack_hand()

	if(href_list["product2"])
		if(metal > 1)
			var/obj/item/I = href_list["product2"]
			new I(src.loc)
			metal -= 2
			attack_hand()

	if(href_list["product3"])
		if(metal > 2)
			var/obj/item/I = href_list["product3"]
			new I(src.loc)
			metal -= 3
			attack_hand()