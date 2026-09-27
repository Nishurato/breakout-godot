extends Node2D

@export var ball_scene: PackedScene
@export var bricks_scene: PackedScene
var score = 0
var high_score = 0
var lives = 3
var sound_once_play = false
var is_game_over = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()
	$HUD/HiScoreLabel.text = "High Score: " + str(high_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HUD/ScoreLabel.text = str(score)
	$HUD/LivesLabel.text = "Lives: " + str(lives)
	
	if has_node("Bricks"):
		_lives_function()
		if $Bricks.get_child_count() == 0:
			$Bricks.queue_free()
	else:
		#I don't know how fix that a different way
		lives += 1
		$Ball.destroy.emit()
		_bricks_spawn()
	
	if Input.is_action_just_pressed("restart"):
		_restart_game()
	

func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("pause") and 
		!has_node("/root/PauseMenu") and 
		!is_game_over):
		process_mode = Node.PROCESS_MODE_DISABLED
		var pause = preload("res://pause_menu.tscn").instantiate()
		$Pause.play()
		$Unpause.stop()
		add_sibling(pause)

func save():
	var save_dict = {
		"high_score" : high_score,
	}
	return save_dict

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Scores")
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data
		high_score = int(node_data["high_score"])

func _lives_function():
	if !has_node("Ball") and lives > 0:
		if lives > 1:
			_ball_spawn()
		lives -= 1
	
	if lives <= 0:
		is_game_over = true
		if score > high_score:
			high_score = score
			var save_nodes = get_tree().get_nodes_in_group("Scores")
			save()
			save_game()
		$HUD/GameOverLabel.show()
		$HUD/ScoreLabel.hide()
		$HUD/LivesLabel.hide()
		$HUD/HiScoreLabel.hide()
		$HUD/HintLabel.show()
		#Do not buzz with this sound
		if !sound_once_play:
			$GameOver.play()
			sound_once_play = true

func _ball_spawn():
	var ball = ball_scene.instantiate()
	ball.position = Vector2(640, 375)
	add_child(ball)
	$Appearance.play()

func _bricks_spawn():
	var bricks = bricks_scene.instantiate()
	add_child(bricks)

func _restart_game():
	get_tree().reload_current_scene()

func _on_celling_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		$BounceSounds.get_child(randi_range(0, 7)).play()
		$Ball.direction.y *= -1

func _on_wall_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		$BounceSounds.get_child(randi_range(0, 7)).play()
		$Ball.direction.x *= -1

func _on_wall_2_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		$BounceSounds.get_child(randi_range(0, 7)).play()
		$Ball.direction.x *= -1
