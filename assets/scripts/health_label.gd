extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text = str($"../Dog".get_current_health())
	
func _on_dog_on_health_changed():
	text = str($"../Dog".get_current_health())
