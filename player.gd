extends Area2D

signal hit

@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement_direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		movement_direction += Vector2(0, -1)
	if Input.is_action_pressed("move_down"):
		movement_direction += Vector2(0, 1)
	if Input.is_action_pressed("move_right"):
		movement_direction += Vector2(1, 0)
	if Input.is_action_pressed("move_left"):
		movement_direction += Vector2(-1, 0)

	var velocity = Vector2.ZERO
	
	if movement_direction.length() > 0:
		velocity = movement_direction.normalized() * speed
		$AnimatedSprite2D.play()
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_v = false
			# See the note below about the following boolean assignment.
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif velocity.y != 0:
			$AnimatedSprite2D.animation = "up"
			$AnimatedSprite2D.flip_v = velocity.y > 0
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
