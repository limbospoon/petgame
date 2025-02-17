extends Label

@onready var dog_ref = get_node("%Dog")
# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(dog_ref.get_current_health())
	
func _on_dog_on_health_changed():
	text = str(dog_ref.get_current_health())
