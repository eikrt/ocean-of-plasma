extends Label




func _ready():
	pass # Replace with function body.
func _process(delta):
	if PlayerStore.hunger < 10:
		self.text = "Starving"
	if PlayerStore.hunger > 10 and PlayerStore.hunger <= 25:
		self.text = "Very Hungry"
	if PlayerStore.hunger > 25 and PlayerStore.hunger <= 50:
		self.text = "Hungry"
	if PlayerStore.hunger > 50 and PlayerStore.hunger <= 75:
		self.text = "Full"
	if PlayerStore.hunger > 75 and PlayerStore.hunger <= 100:
		self.text = "Stuffed"
