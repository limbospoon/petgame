extends Label

func _ready():
	text = str($"../Dog"._hunger_stats["CurrentHunger"])
	
func _on_dog_on_hunger_changed():
	text = str($"../Dog"._hunger_stats["CurrentHunger"])
