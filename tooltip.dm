proc
	Show_Window(client/C, var/texthint)
		if(!(C))return
		var
			mob/M = C.mob
		winshow(M,"tooltip")
		M << output("<FONT SIZE = \"-2\">[texthint]</FONT>","output1")
		spawn(30) winshow(M, "tooltip",0)