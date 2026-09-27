extends Area2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	var ball = get_node("/root/Game/Ball")
	var game = get_node("/root/Game")
	
	if has_node("/root/Game/Ball"):
		var ball_x_check = ball.position.x - position.x
		var ball_y_check = ball.position.y - position.y
	
		if body.name == "Ball":
			if ball_y_check > 23:
				ball.direction.y = 0.5
			elif ball_y_check < -23:
				ball.direction.y = -0.5
			else:
				if ball_x_check > 50:
					ball.direction.x = 1
				elif ball_x_check < -50:
					ball.direction.x = -1
		
			game.score += 4
			ball.speed += 5
			get_node("/root/Game/BounceSounds").get_child(randi_range(0, 7)).play()
			queue_free()
