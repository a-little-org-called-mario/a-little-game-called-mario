class_name SMParser

# note(jamspoon): this can & should be refactored some day. this is a mess

var track_file: String
var chart: SMChart

static func parse (file: String) -> SMChart:
	var parser = load("res://scenes/DDR/SMParser.gd").new(file)
	return parser._parse()

func _init (file: String):
	track_file = file
	chart = SMChart.new()

func _parse () -> SMChart:
	var f: File = File.new()
	f.open(track_file, File.READ)

	var index: int = 0
	var head_data: bool = true
	var line: String 
	while !f.eof_reached():        
		if head_data:
			line = f.get_line().strip_edges()

			# if empty, we've reached the end of the head section
			if 0 == len(line):
				head_data = false
				line = ""
				continue
			# if this head tag is multiline
			while !line.ends_with(";"):
				line += f.get_line().strip_edges()

			# we should have a nice and happy line by now
			parse_head(line)
		else:
			line += f.get_line().strip_edges() + "\n"

	f.close()

	parse_charts(line)

	return chart

func parse_head (line: String):
	var split = line.split(":", true, 1)
	var tag: String = split[0].trim_prefix("#")
	var value: String = split[1].trim_suffix(";")
	match split[0].substr(1):
		"TITLE": chart.title = value
		"SUBTITLE": chart.subtitle = value
		"ARTIST": chart.artist = value
		"TITLETRANSLIT": chart.title_translit = value
		"SUBTITLETRANSLIT": chart.subtitle_translit = value
		"ARTISTTRANSLIT": chart.artist_translit = value
		"GENRE": chart.genre = value
		"CREDIT": chart.credit = value
		"LYRICSPATH":
			chart.lyrics = value
		"CDTITLE":
			chart.cd_title = value
		"OFFSET":
			chart.offset = float(value)
		"SAMPLESTART":
			chart.sample_start = float(value)
		"SAMPLELENGTH":
			chart.sample_length = float(value)
		"SELECTABLE":
			chart.selectable = "YES" == value
		"BPMS":
			var bpms = value.split(",")
			for i in range(bpms.size()):
				var s = bpms[i].split("=")
				chart.bpm.push_back(Vector2(float(s[0]),float(s[1])))
		"STOPS":
			if 0 < len(value): 
				var stops = value.split(",")
				for i in range(stops.size()):
					var s = stops[i].split("=",false,1)
					chart.stops.append(Vector2(float(s[0]),float(s[1])))

		# note(jamspoon): right now these are expecting the .sm file music / image paths to
		#                 be absolute paths (i.e. res://....)
		#			      there may be a more elegant way to handle this & work in relative paths
		"BANNER":
			if 0 < len(value) && ResourceLoader.exists(value):
				chart.banner = ResourceLoader.load(value, "Texture")
		"BACKGROUND":
			if 0 < len(value) && ResourceLoader.exists(value):
				chart.background = ResourceLoader.load(value, "Texture")
		"MUSIC":
			if 0 < len(value) && ResourceLoader.exists(value):
				chart.music = ResourceLoader.load(value, "AudioStream")
	return

func parse_charts (chart_data: String):
	for c in range(chart_data.count("\n\n")):
		var data = chart_data.split("\n\n")[c].split(":",true)
		var list: SMChartList = SMChartList.new()

		# data[0] is an unimportant "#NOTES:" tag, so we will ignore!
		list.chart_type = data[1].strip_edges()
		list.description = data[2].strip_edges()
		list.difficulty = data[3].strip_edges()
		list.meter = int(data[4].strip_edges())

		var groove = data[5].strip_edges().split(",")
		for g in range(groove.size()):
			list.groove_radar.append(float(groove[g]))

		# note(jamspoon): so from here, i'm exporting actual note data the same way TrackParser.gd does:
		# as an array of { "tick": int, "pose": String }s. hopefully that should make it pretty
		# easy to plug and play with the current ddr system?
		var measures = data[6].split(",")
		var curr_offset: int = chart.offset * 1000 # offset, in millisec
		var bpm: float = chart.bpm[0].y
		for m in range(measures.size()):
			var measure: String = measures[m].trim_prefix("\n")

			# first, calculate the millisecond length of an individual note

			# because .sm files support multiple bpms per song, make sure that we're calculating based on the right one
			if 1 == chart.bpm.size(): bpm = chart.bpm[0].y
			else:
				for b in range(chart.bpm.size()):
					if curr_offset / 1000 <= chart.bpm[b].x:
						bpm = chart.bpm[b - 1].y
						break
			var note_count: int = measure.count("\n") # how many notes are in this "measure"
			var note_length: int = 240000 / (note_count * bpm) # there are always 4 beats in a measure, and we want to convert from minutes to millisec
			
			# second, iterate over each note in the measure and add to list
			# note(jamspoon): right NOW, DDR only has standard notes implemented
			#				  if there comes a day when other sm notes are added, might be wise
			#                 to turn this into a match statement instead of an if

			for n in range(note_count):
				var note: String = measure.split("\n")[n].strip_edges()

				# if this is a double chart
				if 8 == len(note):
					if '0' != note[0]: list.left_notes.append( { "tick": curr_offset, "pose": "left" } )
					if '0' != note[1]: list.left_notes.append( { "tick": curr_offset, "pose": "down" } )
					if '0' != note[2]: list.left_notes.append( { "tick": curr_offset, "pose": "up" } )
					if '0' != note[3]: list.left_notes.append( { "tick": curr_offset, "pose": "right" } )
					if '0' != note[4]: list.right_notes.append( { "tick": curr_offset, "pose": "left" } )
					if '0' != note[5]: list.right_notes.append( { "tick": curr_offset, "pose": "down" } )
					if '0' != note[6]: list.right_notes.append( { "tick": curr_offset, "pose": "up" } )
					if '0' != note[7]: list.right_notes.append( { "tick": curr_offset, "pose": "right" } )

				# if this is a single chart
				# note(jamspoon): putting single player charts in the right track, since it's the non-lawrence track
				else:
					if '0' != note[0]: list.right_notes.append( { "tick": curr_offset, "pose": "left" } )
					if '0' != note[1]: list.right_notes.append( { "tick": curr_offset, "pose": "down" } )
					if '0' != note[2]: list.right_notes.append( { "tick": curr_offset, "pose": "up" } )
					if '0' != note[3]: list.right_notes.append( { "tick": curr_offset, "pose": "right" } )

				# add the current note length to the offset after each note
				curr_offset += note_length
		
		chart.chart_lists.push_back(list)
	return
