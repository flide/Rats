extends KinematicBody2D

export var snake_speed: int = 200
var velocity: Vector2 = Vector2(snake_speed,0)
var rotate_head_by: int = 90

var sprite: Sprite

func _ready():
	sprite = $Sprite

func _physics_process(delta):

	var x_direction = sign(velocity.x)
	var y_direction = sign(velocity.y)
	var rotationMultiplier = 0

	if x_direction !=0:
		y_direction = sign(Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
		if y_direction != 0:
			rotationMultiplier = x_direction * y_direction
			x_direction = 0
		
	elif y_direction !=0:
		x_direction = sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
		if x_direction != 0:
			rotationMultiplier = x_direction * y_direction * -1
			y_direction = 0

	velocity = Vector2(x_direction * snake_speed, y_direction * snake_speed)
	#sprite.rotation = rotationMultiplier * rotate_head_by
	sprite.rotate(rotationMultiplier * rotate_head_by * PI/180)

	velocity = move_and_slide(velocity)
