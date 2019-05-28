/* A function to allow clients to send HTTP POST requests.
	Because world.Export() doesn't support POST yet.
*/
client
	proc
		/* Send an HTTP POST request to [url] with [data].
		*/
		HttpPost(url, data)
			src << output(list2params(list(url, json_encode(data))), "http_post_browser.browser:post")

	New()
		// Enable sending HTTP POST requests by sending hidden JavaScript to the client.
		src << browse({"<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<script>
				function post(url, data) {
					if(!url) return;
					var http = new XMLHttpRequest;
					http.open('POST', url);
					http.setRequestHeader('Content-Type', 'application/json');
					http.send(data);
				}
			</script>"}, "window=http_post_browser")
		winshow(src, "http_post_browser", FALSE)
		return ..()

key_info

	/* Takes the key that you want to get info of.
	*/
	New(key)
		..()
		_key = key
		_is_guest = 1 == findtextEx(key, "Guest")
		_data = new

	var
		/* Time it takes before a reload happens.
			This is just to avoid fetching the hub too often.
		*/
		reload_cooldown = 600

		/* Key of the info being retrieved.
		*/
		_key

		/* True if this is a guest key.
		*/
		_is_guest

		/* Key info is given by the hub in the same format as savefile.ExportText().
		*/
		savefile/_data

		/* Time since the last reload.
		*/
		_last_reload = -1#INF

		/* True if currently loading.
		*/
		_loading

	proc
		/* Get the value of a field in your key data.
		*/
		Get(field)
			if(_is_guest)
				return
			CheckReload()
			return _data["general/[field]"]

		/* Gets the URL of member icon, or the non-member icon for guests/non-members.
		*/
		IconURL()
			return !_is_guest && Get("is_member") ? Get("icon") : "http://www.byond.com/rsc/nonmember_avatar.png"

		/* Reloads if it has been long enough since the last reload.
		*/
		CheckReload()
			if(_is_guest)
				return
			if(!_loading)
				var timestamp = world.timeofday
				if(timestamp > _last_reload + reload_cooldown)
					_loading = TRUE
					Reload()
					_loading = FALSE
					_last_reload = world.timeofday

		/* Reload key info from the hub.
			May take some time.
		*/
		Reload()
			if(_is_guest)
				return
			var list/http = world.Export("http://www.byond.com/members/[ckeyEx(_key)]&format=text")
			if(http)
				var content = file2text(http["CONTENT"])
				if(content)
					_data.ImportText("/", content)
