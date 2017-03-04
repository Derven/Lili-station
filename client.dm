client
	script="<style>\
	body { \
		font-family: 'Verdana', 'sans-serif'; \
	} \
	\
	.lobby {\
		font-family: 'Verdana', 'sans-serif';\
		color: \"#30302D\";\
	}\
	\
	.miniheader {\
		font-family: 'Verdana', 'sans-serif';\
		background-color: \"#200772\";\
		color: \"#FFDE40\";\
		height: 300px;\
		width: 300px;\
	}\
	\
	miniheader:link{\
		color: \"#FFDE40\";\
	}</style>"
	var/run_intent = 2
	var/speeding = 0

	proc/switch_rintent()
		if(run_intent == 4)
			run_intent = 2
			return
		if(run_intent == 2)
			run_intent = 4
			return

	Move()
		if(speeding <= 0)
			speeding = 1
			..()
			sleep(run_intent)
			speeding = 0
		else
			return
