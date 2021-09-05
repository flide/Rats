extends KinematicBody2D

onready var tween: Tween = $Tween
var timeToRotate: float = .25
signal HeadRotationCompleted

func _ready():
	pass
	
func rotateHeadTo(angle: float):
	tween.interpolate_property(self, "rotation_degrees", rotation_degrees, angle, timeToRotate, Tween.TRANS_LINEAR,Tween.EASE_OUT)
	tween.start()


func _onHeadRotationCompleted():
	emit_signal("HeadRotationCompleted")
