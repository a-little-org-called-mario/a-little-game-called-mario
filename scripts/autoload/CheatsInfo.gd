extends Node

#If you want the name of a cheat, check the "Cheats Name" exported variables
#on the button nodes on the CheatsScreen scene.
var enabled_cheats = []
#I would've made this a dictionary instead, but I decided I was too lazy for that.
var is_cheating = false
#Technically you don't need this as you can just put enabled_cheats as a boolean, but I made a variable for simplicity.
var code_entered = false
#This is here to prevent TitleMenuButtons from changing the scene when the Konami code was just entered.
#It gets changed to true once the code is put in, and back to false once CheatsScreen is loaded.

func toggle_cheat(name) -> void:
	if enabled_cheats.has(name):
		enabled_cheats.erase(name)
	else:
		enabled_cheats.append(name)

	is_cheating = enabled_cheats
