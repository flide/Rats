extends Node2D

onready var head: KinematicBody2D = $head
onready var tail: RigidBody2D = $tail

export var bodySegment: PackedScene
export var snakeSpeed: int = 100
var velocity: Vector2 = Vector2(snakeSpeed,0)
const ROTATION_STEP: int = 90
var rotating: bool = false

onready var secondLastSegment = $body/firstSegment
onready var lastSegment = $body/lastSegment

func _ready():
	secondLastSegment.snake_init_groove_joint_setup();
	lastSegment.snake_init_groove_joint_setup();

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
		var targetRotation = head.rotation_degrees + (rotationMultiplier * ROTATION_STEP)
		head.rotateHeadTo(targetRotation)
		rotating = true

	velocity = head.move_and_slide(velocity)


func _onHeadMovementCompleted():
	rotating = false
	

func food_eaten():
	pass
	# var new_segment = bodySegment.instance()
	# var new_groove_joint = GrooveJoint2D.new()
	
	# $body.add_child(new_segment)
	# new_segment.add_child(new_groove_joint)
	
	# new_groove_joint.set_node_a(new_segment.get_path())
	# new_groove_joint.set_node_b(lastSegment.get_path())
	# print(secondLastSegment.get_path().get_name(5), '..')
	# var groove_joint = get_node(secondLastSegment.get_path().get_name()+'/GrooveJoint2D')
	# secondLastSegment.get_path()
	# groove_joint.set_node_a(new_segment.get_path())
	
	
	
