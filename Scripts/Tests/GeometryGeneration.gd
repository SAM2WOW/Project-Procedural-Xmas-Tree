extends ImmediateGeometry


export var sides : float = 12
export var radius : float = 2


func _process(delta):
	# Clean up before drawing.
	clear()

	# Begin draw.
	begin(Mesh.PRIMITIVE_TRIANGLE_FAN)

	for i in range(sides):
		# Calculate UV seperately
		var uv_x = sin((2 * PI * i) / sides)
		var uv_y = cos((2 * PI * i) / sides)
		
		set_uv(Vector2(uv_x, uv_y))
		
		# Calculate point
		var x = radius * sin((2 * PI * i) / sides)
		var y = radius * cos((2 * PI * i) / sides)
		
		add_vertex(Vector3(x, 0, y))
		
	# End drawing.
	end()
