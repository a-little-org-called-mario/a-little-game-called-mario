extends RichTextLabel

var coinsSinceStartingLevel := 0
var currentLevel = 0

onready var coin_counter = preload("res://scripts/CoinCounter.tres")


func _ready():
	coin_counter.connect("coin_amount_changed", self, "_on_coin_amount_changed")
	EventBus.connect("level_completed", self, "_on_level_completed")


func _on_coin_amount_changed(_total, difference):
	if difference > 0:
		coinsSinceStartingLevel += difference
		print("checking coin achievements")
		get_achievements()


func get_achievements():
	print("getting achievements")
	var dir = Directory.new()
	if (dir.open("res://Achievements")) == OK:
		if dir.open("res://Achievements/Level" + str(currentLevel)) == OK:
			#We are now in the folder for the achievements in this level.
			dir.list_dir_begin()
			var file_name = dir.get_next()
			print(file_name)
			while file_name != "":
				if !dir.current_is_dir():
					var current = load(
						"res://Achievements/Level" + str(currentLevel) + "/" + file_name
					)
					#We now have a reference to the achievement. Check if its the right kind
					if current is Achievement:
						if current is CoinsAchievement:
							#This is a coins achievement in this level. Do we have the right number of coins?
							if coinsSinceStartingLevel == current.coinsRequired:
								print("this is a coins achievement")
								self.append_bbcode(
									(
										"[rainbow][center]"
										+ current.description
										+ "[/center][/rainbow]"
									)
								)
								clear_text_after_seconds()
				file_name = dir.get_next()
		else:
			print("That level's folder does not exist in achievements")
	else:
		print("the requested directory does not exist")


func clear_text_after_seconds():
	var t = Timer.new()
	t.set_wait_time(3.25)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	self.clear()


func _on_level_completed(data):
	coinsSinceStartingLevel = 0
	currentLevel += 1
