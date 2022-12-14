extends Node

var cam : MainCamera = null


func apply_camera_shake(percentage:float, time:float = 0.25)->void:
	if cam == null || is_instance_valid(cam) == false:
		var cams = get_tree().get_nodes_in_group("camera")
		if (cams.size() > 0):
			cam = cams[0]
		else:
			print_debug("Error!!: There is no camera in level")
			return
	
	cam.apply_shake(percentage, time)
	
