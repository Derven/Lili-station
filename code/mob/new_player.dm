/mob/New()
	..()
	Move(pick(landmarks))

/mob/Login()
	..()
	brat << "<h1>Здраствуйte, товариsch! Экипаж космического крейсера \"Аврора\" желает вам удачного полета</h1>"
	create_hud(usr.client)