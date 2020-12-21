extends Spatial

var elapsed_time = 0    
var start
var speed
var start_time
var direction

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			start = event.position
			start_time = elapsed_time
		else:
			direction = event.position - start
			speed = (direction.length())/(elapsed_time - start_time)
			direction = direction.normalized()
			print(direction, speed)

func _process(delta):
	elapsed_time += delta
