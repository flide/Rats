extends Node2D

onready var head: KinematicBody2D = $head
onready var tail: RigidBody2D = $tail

export var snakeSpeed: int = 100
var velocity: Vector2 = Vector2(snakeSpeed,0)
const ROTATION_STEP: int = 90
onready var targetRotation: float = head.rotation_degrees
var rotating: bool = false
export var speedOfRotation: float = 4

func _physics_process(delta):

	var x_direction = sign(velocity.x)
	var y_direction = sign(velocity.y)
	var rotationMultiplier = 0

	if x_direction !=0 and !rotating:
		y_direction = sign(Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
		if y_direction != 0:
			rotationMultiplier = x_direction * y_direction
			x_direction = 0
		
	elif y_direction !=0 and !rotating:
		x_direction = sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
		if x_direction != 0:
			rotationMultiplier = x_direction * y_direction * -1
			y_direction = 0

	velocity = Vector2(x_direction * snakeSpeed, y_direction * snakeSpeed)
	
	if !rotating and rotationMultiplier != 0 :
		targetRotation = head.rotation_degrees + (rotationMultiplier * ROTATION_STEP)
		rotating = true
		#print("Target rotation set to : ", targetRotation)

	if rotating and head.rotation_degrees != targetRotation:
		var rotateBy = lerp(head.rotation_degrees, targetRotation, delta*speedOfRotation)
		head.rotate(deg2rad(rotateBy-head.rotation_degrees))
		#print("diffence remaining : ",head.rotation_degrees, " ", targetRotation, " ", abs(abs(head.rotation_degrees) - abs(targetRotation)) )
	if rotating and abs(abs(head.rotation_degrees) - abs(targetRotation)) < 5 :
		head.rotate(deg2rad(targetRotation-head.rotation_degrees))
		targetRotation = head.rotation_degrees
		rotating = false
		#print("head stabalized", head.rotation_degrees,",", targetRotation)
	velocity = head.move_and_slide(velocity)
