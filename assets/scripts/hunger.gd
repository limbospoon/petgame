extends Label

func _ready():
	text = str($"../../../Dog".get_current_hunger())
	
func _on_dog_on_hunger_changed():
	text = str($"../../../Dog".get_current_hunger())
	
