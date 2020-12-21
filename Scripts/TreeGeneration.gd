extends MeshInstance

export var tree_height = 5.0
export var tree_max_radius = 2.0

signal tree_updated(height, aabb)


func _ready():
	set_tree_mesh()


func generate_tree():
	randomize()
	
	var tree : ArrayMesh
	var st = SurfaceTool.new()
	
	# Randomize Tree Properties
	var sides = rand_range(32, 64)
	var level = 0
	
	tree_height = rand_range(2, 10)
	tree_max_radius = rand_range(1, 5)
	
	# Start generation
	while level < tree_height:
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		
		for i in range(sides + 1):
			
			# Randomize generation possibility
			if randi() & 1:
				
				# Center
				st.add_uv(Vector2(rand_range(0, 1), 1))
				st.add_vertex(Vector3(0, level + rand_range(-0.2, 0.2), 0))
				
				# Random Offset
				var new_level = level + rand_range(-0.5, 0.5)
				var radius = lerp(tree_max_radius, 0.1, level / tree_height) + rand_range(-0.2, 0.2)
				
				# Two points
				var x1 = radius * sin((2 * PI * i) / sides)
				var y1 = radius * cos((2 * PI * i) / sides)
				var x2 = radius * sin((2 * PI * (i + 1)) / sides)
				var y2 = radius * cos((2 * PI * (i + 1)) / sides)
				
				st.add_uv(Vector2(0, 0))
				st.add_vertex(Vector3(x1, new_level, y1))
				
				st.add_uv(Vector2(1, 0))
				st.add_vertex(Vector3(x2, new_level, y2))
			
		st.index()
		st.generate_normals()
		
		tree = st.commit(tree)
		
		level += rand_range(0.01, 0.2)
	
	return tree


func set_tree_mesh():
	set_mesh(generate_tree())
	emit_signal("tree_updated", tree_height, get_aabb())
	
	# Set stem height
	$Stem.set_scale(Vector3(1, tree_height, 1))


func _on_Generate_pressed():
	set_tree_mesh()
	
