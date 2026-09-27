extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		get_parent().get_node("Game").process_mode = Node.PROCESS_MODE_INHERIT
		get_node("/root/Game/Pause").stop()
		get_node("/root/Game/Unpause").play()
		queue_free()
	elif Input.is_action_just_pressed("restart"):
		get_parent().get_node("Game").process_mode = Node.PROCESS_MODE_INHERIT
		queue_free()
