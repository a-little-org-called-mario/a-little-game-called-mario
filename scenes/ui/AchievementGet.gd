extends RichTextLabel

export(float, 1, 15, 0.05) var show_time_sec: float = 3.25

var coinsSinceStartingLevel := 0
var totalShots := 0
var currentLevel := 0

# A dictionary mapping the level number to the level achievements.
# The global array contains level agnostic achievements.
var achievements := {
	global = []
}
# A dictionary containing the completed achievements as keys.
var completed : Dictionary

const FileUtils = preload("res://scripts/FileUtils.gd")


func _ready():
	EventBus.connect("shot", self, "_on_shot")
	EventBus.connect("coin_collected", self, "_on_coin_collected")
	EventBus.connect("level_completed", self, "_on_level_completed")
	get_achievements()


func _on_coin_collected(data):
	var value := 1
	if data and data.value:
		value = data.value
	coinsSinceStartingLevel += value
	check_achievements()


func _on_shot():
	totalShots += 1
	check_achievements()


# Load the achievements from the Achievements folder.
func get_achievements():
	for file in FileUtils.list_dir("res://achievements/level"):
		var level := int(file.get_file())
		achievements[level] = []
		for achievement in FileUtils.list_dir(file):
			achievements[level].append(load(achievement))
	for file in FileUtils.list_dir("res://achievements/global"):
		achievements.global.append(load(file))


# Check if any achievement are completed.
func check_achievements():
	# We check global and level-specific achievements.
	var to_check : Array = (achievements.global +
			achievements.get(currentLevel, []))
	for achievement in to_check:
		if achievement in completed:
			# We already completed this achievement.
			continue
		var is_completed := false
		match achievement.get_script():
			CoinsAchievement:
				is_completed = coinsSinceStartingLevel >= achievement.coinsRequired
			ShootAchievement:
				is_completed = totalShots >= achievement.shotsRequired
		if is_completed:
			# Mark the achievement as completed.
			completed[achievement] = true
			show_completion_message(achievement)


func show_completion_message(achievement: Achievement):
	append_bbcode(
		"[rainbow][center]"
		+ tr("ACHIEVEMENT UNLOCKED: %s") % tr(achievement.description)
		+ "[/center][/rainbow]"
	)
	show_and_clear_text_after_seconds(show_time_sec)


func show_and_clear_text_after_seconds(time_sec):
	self.show()
	yield(get_tree().create_timer(time_sec), "timeout")
	self.clear()
	self.hide()


func _on_level_completed(_data):
	coinsSinceStartingLevel = 0
	currentLevel += 1
	check_achievements()
