extends Node2D

onready var head: KinematicBody2D = $head
onready var second_last_segment = $body/firstSegment
onready var last_segment = $body/lastSegment
onready var tail: RigidBody2D = $tail

export var bodySegment: PackedScene
export var snakeSpeed: int = 100
var velocity: Vector2 = Vector2(snakeSpeed,0)
const ROTATION_STEP: int = 90
var rotating: bool = false

onready var in_between_segments = Array()

var x_direction = 1
var y_direction = 0

func _ready():
	second_last_segment.snake_init_groove_joint_setup();
	last_segment.snake_init_groove_joint_setup();

func _physics_process(delta):

	x_direction = sign(velocity.x)
	y_direction = sign(velocity.y)
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
		var targetRotation = head.rotation_degrees + (rotationMultiplier * ROTATION_STEP)
		head.rotateHeadTo(targetRotation)
		rotating = true

	velocity = head.move_and_slide(velocity)


func _onHeadMovementCompleted():
	rotating = false
	

func food_eaten():
	in_between_segments.append(bodySegment.instance())
	var new_segment = in_between_segments[in_between_segments.size()-1]
	#second_last_segment.find_node("GrooveJoint2D", true, false).length = 18
	print("tail current position : ", tail.position)
	last_segment.find_node("GrooveJoint2D", true, false).length = 18
	tail.position = Vector2(tail.position.x - (16 * x_direction), tail.position.y - (16 * y_direction))
	print("tail offset position : ", tail.position)
	print("last_segment current position : ", last_segment.position)
	second_last_segment.find_node("GrooveJoint2D", true, false).length = 18
	last_segment.position = Vector2(last_segment.position.x - (16 * x_direction), last_segment.position.y - (16 * y_direction))
	last_segment.find_node("GrooveJoint2D", true, false).length = 1
	print("last_segment offset position : ", last_segment.position)
	print("new_segment current position : ", new_segment.position)
	new_segment.position = Vector2(second_last_segment.position.x - (16 * x_direction), second_last_segment.position.y - (16 * y_direction))
	$body.add_child_below_node(second_last_segment, new_segment)
	second_last_segment.find_node("GrooveJoint2D", true, false).length = 1
	print("new_segment offset position : ", new_segment.position)
	second_last_segment.set_groove_joint_for_body_segment(new_segment.get_path())
	new_segment.set_groove_joint_for_body_segment(last_segment.get_path())
	#second_last_segment.find_node("GrooveJoint2D", true, false).length = 1
	print("second_last_segment : ", second_last_segment.find_node("GrooveJoint2D", true, false).rotation_degrees, second_last_segment.position)
	print("new_segment : ", new_segment.find_node("GrooveJoint2D", true, false).rotation_degrees, new_segment.position)
	second_last_segment = new_segment
	
	
	
