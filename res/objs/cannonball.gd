extends KinematicBody
const Player = preload("res://assets/scripts/Player.gd")
var velocity = Vector3(0,0,0)

func _ready():
	pass
func _physics_process(delta):
	move_and_slide(velocity, Vector3.UP)

func _on_Area_body_entered(body):
	var b := body as Player
	if not b:
		return
	if body.name == "Player0" or body.name == "Player1":
		body.hp = 0
