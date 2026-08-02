extends Node3D

@export var cameras : Array[Camera3D]

var active_camera = 0

func _input(delta):
	if Input.is_action_pressed("switch_camera"):
		if active_camera < cameras.size()-1:
			cameras[active_camera].current = false
			cameras[active_camera+1].current = true
			active_camera += 1
		else:
			cameras[-1].current = false
			cameras[0].current = true
			active_camera = 0
		pass
		print(active_camera)
