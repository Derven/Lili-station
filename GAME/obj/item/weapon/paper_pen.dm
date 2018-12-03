/obj/item/weapon/paper
	var/info
	name = "Paper"
	icon = 'paper.dmi'
	icon_state = "paper"

	attack_self()
		usr << browse(info,"window=paper")

/obj/item/weapon/pen
	var
		text_bold
		text_italic
		text_underline
		text_break
		text_color
		text_size
	name = "Pen"
	icon = 'paper.dmi'
	icon_state = "pen"


/obj/item/weapon/paper/New()

	..()
	src.pixel_y = rand(-8, 8)
	src.pixel_x = rand(-9, 9)
	return

/obj/item/weapon/pen/proc/formatText(var/s)
	if (text_size < 2 || text_size > 7)
		text_size = 3
	if (!(text_color))
		text_color = "#000000"

	var/textToAddHeader = ""
	var/textToAddFooter = ""

	if (text_color && text_size)
		textToAddHeader = "<font size=[text_size] color=[text_color]>"
		textToAddFooter = "</font>"

	if (text_bold == 1)
		textToAddHeader = "[textToAddHeader]<b>"
		textToAddFooter = "</b>[textToAddFooter]"

	if (text_underline == 1)
		textToAddHeader = "[textToAddHeader]<u>"
		textToAddFooter = "</u>[textToAddFooter]"

	if (text_italic == 1)
		textToAddHeader = "[textToAddHeader]<i>"
		textToAddFooter = "</i>[textToAddFooter]"

	if (text_break == 1)
		textToAddFooter = "[textToAddFooter]<br>"

	var/r = "[textToAddHeader][s][textToAddFooter]"
	return r

/obj/item/weapon/paper/attackby(var/obj/item/weapon/P)
	..()

	if (istype(P, /obj/item/weapon/pen))
		var/obj/item/weapon/pen/PEN = P

		var/t = input("What text do you wish to add?", text("[]", src.name)) as message
		t = text("[PEN.formatText(t)]")
		/*
		t = copytext(sanitize(t),1,MAX_MESSAGE_LEN)
		t = dd_replacetext(t, "\n", "<BR>")
		t = dd_replacetext(t, "\[b\]", "<B>")
		t = dd_replacetext(t, "\[/b\]", "</B>")
		t = dd_replacetext(t, "\[i\]", "<I>")
		t = dd_replacetext(t, "\[/i\]", "</I>")
		t = dd_replacetext(t, "\[u\]", "<U>")
		t = dd_replacetext(t, "\[/u\]", "</U>")
		t = dd_replacetext(t, "\[sign\]", text("<font face=vivaldi>[]</font>", user.real_name))
		*/
		t = text("<font face=calligrapher>[]</font>", t)

		src.info += fix1103(t)
	return