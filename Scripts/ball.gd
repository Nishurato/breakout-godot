extends RigidBody2D

signal destroy

var x_rng_dir = [-1, 1]
var direction = Vector2(x_rng_dir.pick_random(), 0.5)
var speed = 300


func _physics_process(delta: float) -> void:
	if linear_velocity != direction * speed:
		linear_velocity = direction * speed


func _on_destroy() -> void:
	queue_free()
