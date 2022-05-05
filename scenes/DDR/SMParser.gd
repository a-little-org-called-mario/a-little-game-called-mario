class_name SMParser

var track_file: String
var track_dir: String

static func parse (sm_path: String) -> SMChart:
	var parser = load("res://scenes/DDR/_SMParser.gd").new(sm_path)
	return parser._parse()

func _init (file: String):
	track_file = file
	track_dir = file.trim_suffix(file.split("/")[-1])

func _parse () -> SMChart:
	var chart: SMChart = SMChart.new()

	var f: File = File.new()
	f.open(track_file, File.READ)

	var data: String
	var in_header: bool = true

	while !f.eof_reached():
		if in_header:
			# If we're in the header tag,
			# go line-by-line and apply metadata appropriately

			data = f.get_line().strip_edges()

			# Due to how .sm files are formatted, an empty line
			# indicates that we've reached the end of the header
			if 0 == len(data):
				in_header = false
				continue

			# If this specific header tag is multiline,
			# keep appending until we hit the end of the tag
			while ';' != data[-1]:
				data += f.get_line().strip_edges()

			parse_header_tag(data, chart)
		else:
			# Since we're no longer in the header tag,
			# copy the rest of the file stream into data

			data += f.get_line().strip_edges() + "\n"

	# Parse all available chart lists
	parse_chart_lists(data, chart)

	f.close()

	return chart

func parse_header_tag (tag: String, chart: SMChart):
	var kvpair = tag.split(":", true, 1)
	var key: String = kvpair[0].trim_prefix("#")
	var value: String = kvpair[1].trim_suffix(";")
#   var rel_path: String = track_dir + value    # Commented out for now, read NOTE below for explanation

	match key:
		"TITLE":
			chart.title = value
		"SUBTITLE":
			chart.subtitle = value
		"ARTIST":
			chart.artist = value
		"TITLETRANSLIT":
			chart.title_translit = value
		"SUBTITLETRANSLIT":
			chart.subtitle_translit = value
		"ARTISTTRANSLIT":
			chart.artist_translit = value
		"GENRE":
			chart.genre = value
		"CREDIT":
			chart.credit = value
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
			if 0 < len(value):
				var pairs = value.split(",")
				for pair in len(pairs):
					var kv = pairs[pair].split("=")
					chart.bpm.push_back( { "beat": float(kv[0]), "bpm": float(kv[1]) } )
		"STOPS":
			if 0 < len(value):
				var pairs = value.split(",")
				for pair in len(pairs):
					var kv = pairs[pair].split("=")
					chart.stops.push_back( { "beat": float(kv[0]), "seconds": float(kv[1]) } )

		# NOTE(jamspoon): Right now, this parser is configured to expect absolute paths - 
		#                 Godot's runtime loading and relative paths don't really mix.
		#                 There's an alternative, though - uncomment the variable
		#                 declaration for `rel_path` above, replace the following
		#                 references to `value` with `rel_path`, and the ResourceLoader
		#                 should look instead in the same directory as the .sm file.
		#                 Ultimately, this comes down to how we want to store .sm charts:
		#                   - If we want to keep the organization structure we have now,
		#                     where audio is in its own directory, sprites in their own, etc,
		#                     then leave everything as is.
		#                   - If, for easier exporting and loading of external .sm files,
		#                     we want to put unique directories for each song in a DDR
		#                     subdirectory, organization based on file type be damned,
		#                     then make the aforementioned changes and we'll be ready to rock.
		#                 I just don't want the responsibility of making that choice lmao
		#                 so I'll leave it to everyone else.
		"BANNER":
			if 0 < len(value) && ResourceLoader.exists(value):
				chart.banner = ResourceLoader.load(value)
		"BACKGROUND":
			if 0 < len(value) && ResourceLoader.exists(value):
				chart.background = ResourceLoader.load(value)
		"MUSIC":
			if 0 < len(value) && ResourceLoader.exists(value):
				chart.music = ResourceLoader.load(value)
		_: pass
	return

func parse_chart_lists (all_lists: String, chart: SMChart):
	for c in all_lists.count("\n\n"):
		var data = all_lists.split("\n\n")[c].split(":",true)
		var list: SMChartList = SMChartList.new()

		# Handle non-note data first

		# data[0] is unimportant formatting, so we can just ignore!
		list.chart_type = data[1].strip_edges()
		list.description = data[2].strip_edges()
		list.difficulty = data[3].strip_edges()
		list.meter = int(data[4].strip_edges())

		var grooves = data[5].strip_edges().split(",")
		for g in len(grooves):
			list.groove_radar.push_back(float(grooves[g]))

		# Handle note data
		# We're exporting note data here identically to how TrackParser.gd does

		var measures = data[6].split(",")
		var bpm: float = chart.bpm[0].bpm
		var tick: int = int(chart.offset * 1000) # converting to millisec
		for m in len(measures):
			var measure: String = measures[m].trim_prefix("\n")
			
			# First, let's calculate how long, in milliseconds, a note currently is

			# Because .sm files suport multiple BPMs per song,
			# make sure we're calculating based on the current one.
			if 1 == len(chart.bpm): bpm = chart.bpm[0].bpm
			else:
				for b in len(chart.bpm):
					# We're reverse searching through this array,
					# looking for the first beat we're ahead of.
					if tick / 1000 > chart.bpm[-b - 1].beat:
						bpm = chart.bpm[-b - 1].bpm
						break

			var note_count: int = measure.count("\n")           # How many notes are in this measure
			var note_length: int = 240000 / (bpm * note_count)  # There are always 4 beats in a measure, and we're converting from
																# beats-per-minute to beats-per-millisecond

			# Second, let's iterate over each note in the measure and add it to the list.
			# NOTE(jamspoon): Right now, Little Mario's DDR mode only has standard,
			#                 press notes implemented. If there comes a day when other
			#                 note types are added to this game, it'll be necessary to
			#                 replace these `if '0' !=` statements with match statements.
			for n in note_count:
				var note: String = measure.split("\n")[n].strip_edges()

				# Double chart
				if 8 == len(note):
					if '0' != note[0]: list.left_notes.append( { "tick": tick, "pose": "left" } )
					if '0' != note[1]: list.left_notes.append( { "tick": tick, "pose": "down" } )
					if '0' != note[2]: list.left_notes.append( { "tick": tick, "pose": "up" } )
					if '0' != note[3]: list.left_notes.append( { "tick": tick, "pose": "right" } )
					if '0' != note[4]: list.right_notes.append( { "tick": tick, "pose": "left" } )
					if '0' != note[5]: list.right_notes.append( { "tick": tick, "pose": "down" } )
					if '0' != note[6]: list.right_notes.append( { "tick": tick, "pose": "up" } )
					if '0' != note[7]: list.right_notes.append( { "tick": tick, "pose": "right" } )

				# Single chart
				# NOTE(jamspoon): I'm putting single notes in the right track list, since
				#                 that's traditonally the Little Mario DDR player track.
				elif 4 == len(note):
					if '0' != note[0]: list.right_notes.append( { "tick": tick, "pose": "left" } )
					if '0' != note[1]: list.right_notes.append( { "tick": tick, "pose": "down" } )
					if '0' != note[2]: list.right_notes.append( { "tick": tick, "pose": "up" } )
					if '0' != note[3]: list.right_notes.append( { "tick": tick, "pose": "right" } )

				# Apply the current note length to the running tick after each note
				tick += note_length

		chart.chart_lists.push_back(list)
	return
