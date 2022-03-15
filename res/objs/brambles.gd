extends Spatial
const Player = preload("res://assets/scripts/Player.gd")
func _ready():
	pass


func _on_Brambles_body_entered(body):
	var b := body as Player
	if not b:
		return
	if body.name == "Player0" or body.name == "Player1":
		print(b.velocity.y)
		if b.velocity.y < -10:
			b.hp = 0
		
