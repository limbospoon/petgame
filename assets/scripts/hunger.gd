extends Label

func _ready():
	text = str($"../Dog"._hunger_stats["CurrentHunger"])
	
func _on_dog_on_health_changed():
	text = str($"../Dog"._hunger_stats["CurrentHunger"])
