extends MeshInstance


func _ready():
	
	set_mesh(generate_mesh(24, 2))


func generate_mesh(sides, radius):
	var new_mesh : ArrayMesh
	var st = SurfaceTool.new()
	
	#############
	# Generate Base
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in range(sides):
		# Calculate UV seperately
		var uv_x = sin((2 * PI * i) / sides)
		var uv_y = cos((2 * PI * i) / sides)
		
		st.add_uv(Vector2(uv_x, uv_y))
		
		st.add_normal(Vector3(0, 0, 1))
		
		var x = radius * sin((2 * PI * i) / sides)
		var y = radius * cos((2 * PI * i) / sides)
		
		st.add_vertex(Vector3(x, -2, y))
		
	st.index()
	
	new_mesh =  st.commit(new_mesh)
	
	#############
	# Generate Lid
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in range(sides):
		# Calculate UV seperately
		var uv_x = sin((2 * PI * i) / sides)
		var uv_y = cos((2 * PI * i) / sides)
		
		st.add_uv(Vector2(uv_x, uv_y))
		
		st.add_normal(Vector3(0, 0, 1))
		
		var x = radius * sin((2 * PI * i) / sides)
		var y = radius * cos((2 * PI * i) / sides)
		
		st.add_vertex(Vector3(x, 2, y))
		
	st.index()
	
	new_mesh =  st.commit(new_mesh)
	
	#############
	# Generate Loop
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in range(sides):
		# Calculate UV seperately
		var uv_x = (1 / sides) * i
		
		var x = radius * sin((2 * PI * i) / sides)
		var y = radius * cos((2 * PI * i) / sides)
		
		st.add_uv(Vector2(uv_x, 0))
		st.add_vertex(Vector3(x, -2, y))
		
		st.add_uv(Vector2(uv_x, 1))
		st.add_vertex(Vector3(x, 2, y))
		
	st.index()
	st.generate_normals()
	st.generate_tangents()
	
	new_mesh =  st.commit(new_mesh)
	
	
	return new_mesh


func generate_test_mesh():
	var st = SurfaceTool.new()

	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Prepare attributes for add_vertex.
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(0, 0))
	# Call last for each vertex, adds the above attributes.
	st.add_vertex(Vector3(-1, -1, 0))

	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1, 1, 0))

	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(1, 1, 0))

	# Create indices, indices are optional.
	st.index()

	# Commit to a mesh.
	return st.commit()
