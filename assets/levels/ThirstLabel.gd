extends Label


func _ready():
	pass
func _process(delta):
	if PlayerStore.thirst < 10:
		self.text = "Dying to thirst"
	if PlayerStore.thirst > 10 and PlayerStore.thirst <= 25:
		self.text = "Very thirsty"
	if PlayerStore.thirst > 25 and PlayerStore.thirst <= 50:
		self.text = "Thirsty"
	if PlayerStore.thirst > 50 and PlayerStore.thirst <= 75:
		self.text = "Full"
	if PlayerStore.thirst > 75 and PlayerStore.thirst <= 100:
		self.text = "Very full"
