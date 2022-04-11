extends PlayerBugdet

func _handle_start(_dir: Vector2):
	$Mint.beginMining()


func _handle_destruction():
	$Hit.play()
	$Mint.tradeMining("usd")
	yield($MintPlayer, "minting_finished")
	pass
