proc/printhint(var/texthint, var/itime, var/mob/O)
	var/icon/hinttheme1 = new('screen1.dmi',icon_state = "hint")
	var/icon/hinttheme2 = new('screen1.dmi',icon_state = "hint2")
	var/body = {"
	<html>
	  <style type="text/css">
		img{
			position: relative;
			left: -5;
			top:0;
		}

		font{
			position: absolute;
			left: 10;
		}


	  </style>
	<body>
	<h2>[texthint]</h2>
	</body>
	</html>"}
	if(O && O.client)
		O << browse(hinttheme1,"texthint")
		O << browse(hinttheme2,"texthint2")
		O << browse(body,"window=hint;size=170x170;titlebar=0")
		sleep(itime)
		O << browse(null,"window=hint")