client
	verb
		say(t as text)
			if(t)
				world << "[src]: [html_encode(t)]"

	New()
		src << {"Welcome!
	Arrows/WASD to move
	Shift to run, alt to crawl
	Enter to chat
	Click a lamp to carry/drop it
	Right-click a lamp to change its color
	Drag a lamp to slide it
	Click the blue lights to toggle them
"}
		world << "[src] connected"
		return ..()
	Del()
		world << "[src] disconnected"
		return ..()