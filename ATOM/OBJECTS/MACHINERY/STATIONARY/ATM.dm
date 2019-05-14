/obj/item/credits
	var/nominal = 100
	icon = 'tools.dmi'
	icon_state = "100credit"

	c50
		icon_state = "50credit"
		nominal = 50

	c10
		icon_state = "10credit"
		nominal = 10

/obj/machinery/ATM
	icon = 'stationobjs.dmi'
	icon_state = "ATM"
	density = 1
	anchored = 1
	var/obj/item/clothing/id/swipeid

	attackby(obj/item/O as obj)
		if(istype(O, /obj/item/clothing/id))
			var/obj/item/clothing/id/ID = O
			usr << "Your id data loading..."
			sleep(rand(1,3))
			usr << "Please wait..."
			swipeid = ID
			usr << "id data loaded"
		else
			if(swipeid)
				if(istype(O, /obj/item/credits))
					var/obj/item/credits/CR = O
					swipeid.credits += CR.nominal
					var/mob/simulated/living/humanoid/H = usr
					H.drop_item_v()
					del(O)

	proc/check_password(var/passw1)
		if(swipeid)
			if(text2num(passw1) == swipeid.password)
				return 1
			else
				return 0
		else
			return 0


	attack_hand()
		if(swipeid && charge > 0)
			var/body = {"<html><body>Moneybag ATM ID:[swipeid.name] credits:[swipeid.credits] cubits:[swipeid.cubits]<hr>
			<a href='?src=\ref[src];action=refresh'>refresh</a></br>
			<a href='?src=\ref[src];action=ctoc'>cubits to credits</a></br>
			<a href='?src=\ref[src];action=g100'>give 100 credit</a></br>
			<a href='?src=\ref[src];action=g50'>give 50 credit</a></br>
			<a href='?src=\ref[src];action=g10'>give 10 credit</a></br>
			"}
			usr << browse(body,"window=ATM")


	Topic(href,href_list[])
		if(usr.check_topic(src))
			if(href_list["action"] == "refresh")
				usr << browse(null,"window=ATM")
				attack_hand()
			if(href_list["action"] == "ctoc")
				var/passw1 = input("Type your password.","Your password","1111")
				if(check_password(passw1))
					usr << "please wait..."
					swipeid.credits += swipeid.cubits * 0.01
					swipeid.cubits = 0
					usr << "transaction completed"
			if(href_list["action"] == "g100")
				var/passw1 = input("Type your password.","Your password","1111")
				if(check_password(passw1))
					usr << "please wait..."
					if(swipeid.credits >= 100)
						swipeid.credits -= 100
						usr << "transaction completed"
						var/obj/item/credits/CR = new /obj/item/credits(src.loc)
						CR.nominal = 100
					else
						usr << "erorr x[rand(1000,9999)]"
			if(href_list["action"] == "g50")
				var/passw1 = input("Type your password.","Your password","1111")
				if(check_password(passw1))
					usr << "please wait..."
					if(swipeid.credits >= 50)
						swipeid.credits -= 50
						var/obj/item/credits/CR = new /obj/item/credits(src.loc)
						CR.nominal = 50
						usr << "transaction completed"
					else
						usr << "erorr x[rand(1000,9999)]"
			if(href_list["action"] == "g10")
				var/passw1 = input("Type your password.","Your password","1111")
				if(check_password(passw1))
					usr << "please wait..."
					if(swipeid.credits >= 10)
						swipeid.credits -= 10
						usr << "transaction completed"
						var/obj/item/credits/CR = new /obj/item/credits(src.loc)
						CR.nominal = 10
					else
						usr << "erorr x[rand(1000,9999)]"