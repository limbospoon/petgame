extends Label

@onready var dog_ref = get_node("%Dog")

func _ready():
	text = str(dog_ref.get_current_hunger())
	
func _on_dog_on_hunger_changed():
	text = str(dog_ref.get_current_hunger())
	
