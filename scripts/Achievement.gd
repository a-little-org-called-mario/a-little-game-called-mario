extends Resource
class_name Achievement

"""@wiki
An achievement the player can aquire by doing certain tasks.

## Adding Achievements to the Game

### Using Existing Achievement Types

If you just want to add an achievement of a type that is already there,
for example "collect a number of coins", create a new resource in the
`res://achievements/global` or `res://achievements/level/LEVEL_NUMBER` folder.

Make sure to add the description to the localization file.

### Adding A New Achievement Type

To create a new type of achievement, add a new script that extends the
`Achievement` class:

```gdscript
extends Achievement
class_name PressStartAchievement

export(int) var keyToPress
```

Then add the logic to check if the achievement is met in `AchievementGet.gd`:

```gdscript
func check_achievements():
				   ...
		match achievement.get_script():
			PressStartAchievement:
				is_completed = Input.is_action_pressed(achievement.keyToPress)
```

Now you can create new resources with this type as described in
"Using Existing Achievement Types"
"""

export(String, MULTILINE) var description
