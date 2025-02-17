extends Area2D

var restore_amount: int = 35

func _on_body_entered(body):
	body.restore_hunger(restore_amount)
