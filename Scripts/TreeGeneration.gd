extends MeshInstance

var tree_height = 5.0
var tree_max_radius = 2.0

export var tree_radius_offsets = 0.2
export var tree_center_offsets = 0.2
export var tree_leaves_offsets = 0.5
export var tree_level_max_increment = 0.2

signal tree_updated(height, aabb)


func _ready():
	set_tree_mesh()


func generate_tree():
	randomize()
	
	var tree : ArrayMesh
	var st = SurfaceTool.new()
	
	# Randomize Tree Properties
	var sides = rand_range(32, 64)
	
	tree_height = rand_range(2, 10)
	tree_max_radius = rand_range(1, 4)
	
	var level = 0
	
	# Start generation
	while level < tree_height:
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		
		for i in range(sides + 1):
			
			# Randomize generation possibility
			if randi() & 1:
				
				# Center vertex
				st.add_uv(Vector2(rand_range(0, 1), 1))
				st.add_vertex(Vector3(0, level + rand_range(-tree_center_offsets, tree_center_offsets), 0))
				
				# Random Offset
				var new_level = level + rand_range(-tree_leaves_offsets, tree_leaves_offsets)
				var radius = lerp(tree_max_radius, 0.1, level / tree_height) + rand_range(-tree_radius_offsets, tree_radius_offsets)
				
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
		
		level += rand_range(0.01, tree_level_max_increment)
	
	
	return tree


func set_tree_mesh():
	set_mesh(generate_tree())
	emit_signal("tree_updated", tree_height, get_aabb())
	
	# Create stem
	var stem = CylinderMesh.new()
	stem.set_top_radius(0.01)
	stem.set_bottom_radius(0.1)
	stem.set_height(tree_height * 2)
	stem.set_radial_segments(4)
	stem.set_rings(16)
	
	$Stem.set_mesh(stem)
	
	# Create Collisions
	create_convex_collision()
	
	# Animation
	$AnimationPlayer.play("spawn")


func _on_Generate_pressed():
	set_tree_mesh()
	
