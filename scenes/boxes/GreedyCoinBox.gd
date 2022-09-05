# It will emit coin unless you reached limit
tool
extends "res://scripts/boxes/CoinBox.gd"


export(int) var player_coin_limit = 5 setget set_player_coin_limit


var inventory = preload("res://scripts/resources/PlayerInventory.tres")


func bounce(body: KinematicBody2D):
	if body is Player:
		if inventory.coins < player_coin_limit:
			bounce_count += 1
			.bounce(body)
		else:
			$AnimationPlayer.play("limit_reached")


func set_player_coin_limit(value: int):
	player_coin_limit = value
	$Sprite/LimitLabel.text = str(value)
