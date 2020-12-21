extends Spatial


var input_speed = Vector2.ZERO
var sensitivity = 0.01
var friction = 0.9

var touched = false

var target_translation = Vector3.ZERO


func _unhandled_input(event):
	if event is InputEventScreenDrag:
		input_speed = event.relative * sensitivity
		
	if event is InputEventScreenTouch:
		touched = event.is_pressed()


func _process(delta):
	# Auto rotate X
	if sign(input_speed.x) >= 0:
		rotate_object_local(Vector3.DOWN, max(0.01, input_speed.x))
	else:
		rotate_object_local(Vector3.DOWN, min(-0.01, input_speed.x))
	
	# Limit Camera Y
	#rotate_object_local(Vector3.LEFT, input_speed.y)
	#rotation_degrees.x = clamp(rotation_degrees.x, -60, 0)
	#print(rotation_degrees.x)
	
	# Add friction when not touched
	if not touched:
		input_speed *= friction
	
	#print(input_speed)
	
	# Smooth change camera
	var t = 0
	if get_translation().distance_to(target_translation) >= 0.01:
		t += delta * 3
		translation = translation.linear_interpolate(target_translation, t)


func _on_GenerateMesh_tree_updated(height, aabb):
	target_translation = Vector3(0, height/2, 0)
	
	$Camera.set_translation(Vector3(0, 0, aabb.get_longest_axis_size()))
	#print(aabb.get_longest_axis_size())
