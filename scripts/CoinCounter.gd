extends Resource

signal coin_amount_changed(total, difference)

export(int) var count = 0


func add_coins(amount = 1):
	count += amount

	emit_signal("coin_amount_changed", count, amount)
