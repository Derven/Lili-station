/mob/New()
	..()
	Move(pick(landmarks))

/mob/Login()
	..()
	brat << "<h1>Здраствуйte, товариsch! Экипаж космического корабл&#255; \"Аврора\" желает вам удачного полета</h1>"
	create_hud(usr.client)