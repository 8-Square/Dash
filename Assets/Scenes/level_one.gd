extends Node2D

@onready var player_death = $DeathUI
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DeathUI.visible = false
	player.connect("died", Callable(self, "on_player_death"))
	player.connect("level_complete", Callable(self, "on_level_complete"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_death and Input.is_action_just_pressed("Restart"):
		restart_level()

func on_player_death():
	player_death.visible = true
	$AnimationPlayer.play("death")
	
func restart_level():
	$AnimationPlayer.play("restart")
	player.reset_player()
	await $AnimationPlayer.animation_finished
	player_death.visible = false

func on_level_complete():
	player_death.visible = true
	$AnimationPlayer.play("level_complete")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Assets/Scenes/level_two.tscn")
