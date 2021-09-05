extends RigidBody2D

export var connected_to: NodePath
onready var groove_joint: GrooveJoint2D = $GrooveJoint2D

func snake_init_groove_joint_setup():
	set_groove_joint_for_body_segment(get_node(connected_to).get_path())

func set_groove_joint_for_body_segment(trailing_body_segment: NodePath):
	groove_joint.set_node_a(self.get_path())
	groove_joint.set_node_b(trailing_body_segment)
