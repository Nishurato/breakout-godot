extends Area2D

@export var speed = 450
var no_direction_movement = [false, false] # You can't move left or right


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_player_control(delta)

func _player_control(delta: float):
	if position.x < 62:
		no_direction_movement[0] = true
	elif position.x > 1217:
		no_direction_movement[1] = true
		
	if Input.is_action_pressed("player_left") and !no_direction_movement[0]:
		position.x -= speed * delta
		no_direction_movement[1] = false
	elif Input.is_action_pressed("player_right") and !no_direction_movement[1]:
		position.x += speed * delta
		no_direction_movement[0] = false


func _on_body_entered(body: Node2D) -> void:
	var ball = get_parent().get_node("Ball")
	if body.name == "Ball":
		var ball_and_paddle_x_diff = ball.position.x - position.x  
		ball.direction.y *= -1
		if ball_and_paddle_x_diff < 0:
			ball.direction.x = -1
		else:
			ball.direction.x = 1
		
		get_parent().get_node("BounceSounds").get_child(randi_range(0, 7)).play()
