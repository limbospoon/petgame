class_name DogState extends State

const IDLE = "Idle"
const WALKING = "Walking"

var dog: Dog

func _ready():
	await  owner.ready
	dog = owner as Dog
	assert(dog != null, "The DogState must be used in the dog scene")
