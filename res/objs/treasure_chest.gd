extends Area
signal artifacts_collected
const ROTATE_SPEED = 3.14*2
func _ready():
	pass

func _physics_process(delta):
	rotate_y(ROTATE_SPEED * delta)
func _on_Artifact_body_entered(body):
	if body.name == "Player0" or body.name == "Player1":
		emit_signal("artifact_collected")
		$Timer.start()
		$AnimationPlayer.play("PickupAnimation")

func _on_Timer_timeout():
	emit_signal("artifacts_collected")
	queue_free()


