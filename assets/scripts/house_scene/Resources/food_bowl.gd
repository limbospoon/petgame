extends DogResource

# Called when the node enters the scene tree for the first time.
func _ready():
	restore_amount = 10

func _on_body_entered(body):
	print("Entered")
	var dog_ref: Dog = body
	_restore(dog_ref)
	
func _restore(dog: Dog):
	super(dog)
	if dog and current_capacity > 0:
		dog.restore_hunger(restore_amount)
		current_capacity -= decrease_capacity
		print(current_capacity)
	else:
		print("bowl empty")
