extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	$AnimationPlayer.play("new_animation")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Assets/Scenes/level_one.tscn")

func _on_quit_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
