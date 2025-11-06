class_name Player
extends CharacterBody2D

signal died
signal level_complete

@export var level_start_pos : Node2D

@onready var tilemap = $"../LevelLayout"
@onready var colorrect = $"../DeathUI/ColorRect"

const SPEED = 550
var can_control = true

func action_name() -> String:
	if Input.is_action_just_pressed("Up"):
		return "Up"
	elif Input.is_action_just_pressed("Down"):
		return "Down"
	elif Input.is_action_just_pressed("Left"):
		return "Left"
	elif Input.is_action_just_pressed("Right"):
		return "Right"
	return ""
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Restart"):
		await get_tree().create_timer(0.4).timeout
		reset_player()
		return
	
	if not can_control:
		velocity = Vector2.ZERO
		move_and_slide()
		return 
	
	if velocity == Vector2.ZERO:
		var action = action_name()

		match action:
			"Down":
				velocity = Vector2.DOWN * SPEED
			"Up":
				velocity = Vector2.UP * SPEED
			"Right":
				velocity = Vector2.RIGHT * SPEED
			"Left":
				velocity = Vector2.LEFT * SPEED
		
		#await get_tree().create_timer(3.0).timeout 
		#if velocity == Vector2.ZERO:
			#fail_move()
	
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_normal().x != 0:
			velocity.x = 0
		if collision.get_normal().y != 0:
			velocity.y = 0
	check_special()


func check_special():
	var cell: Vector2i = tilemap.local_to_map(tilemap.to_local(global_position))
	var tile_data: TileData = tilemap.get_cell_tile_data(cell)
	if tile_data:
		if tile_data.get_custom_data("Trap") and can_control:
			can_control = false
			print("TOUCHING")
			emit_signal("died")
		if tile_data.get_custom_data("Checkpoint") and can_control:
			can_control = false
			emit_signal("level_complete")

#func fail_move():
	#print("FAILED TO MOVE IN TIME")
	


func reset_player() -> void:
	global_position = level_start_pos.global_position
	velocity = Vector2.ZERO
	can_control = true
	print("Player Has Been Reset")
