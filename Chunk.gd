extends Spatial
class_name Chunk
var mesh_instance
var noise
var city_noise
var tree_noise
var x
var z
var chunk_size
var should_remove = true
var tree = load("res://assets/objects/Spruce.tscn")
func _init(noise, tree_noise, city_noise, x, z, chunk_size):
	self.noise = noise
	self.city_noise = city_noise
	self.tree_noise = tree_noise
	self.x = x
	self.z = z
	self.chunk_size = chunk_size
func _ready():
	generate_chunk() # Replace with function body.
	generate_water()
func generate_chunk():
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(chunk_size, chunk_size)
	plane_mesh.subdivide_depth = chunk_size * 0.5
	plane_mesh.subdivide_width = chunk_size * 0.5
	plane_mesh.material = preload("res://assets/materials/terrain.material")
	var surface_tool = SurfaceTool.new()
	var data_tool = MeshDataTool.new()
	surface_tool.create_from(plane_mesh, 0)
	var array_plane = surface_tool.commit()
	var error = data_tool.create_from_surface(array_plane, 0)
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		vertex.y = noise.get_noise_3d(vertex.x + x, vertex.y, vertex.z + z) * 80
		data_tool.set_vertex(i, vertex)
	for s in range(array_plane.get_surface_count()):
		array_plane.surface_remove(s)
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane,0)
	surface_tool.generate_normals()
	mesh_instance = MeshInstance.new()
	mesh_instance.mesh = surface_tool.commit()
	mesh_instance.create_trimesh_collision()
	mesh_instance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_ON
	add_child(mesh_instance)
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		vertex.y = noise.get_noise_3d(vertex.x + x, vertex.y, vertex.z + z) * 80
		randomize()
		var rand = rand_range(0,512)
		if vertex.y > 15:
			if rand > 1 and rand < 2:
				var scene_instance = tree.instance()
				scene_instance.set_name("Tree")
				scene_instance.translation.x = vertex.x
				scene_instance.translation.y = vertex.y
				scene_instance.translation.z = vertex.z
				add_child(scene_instance)
func generate_water():
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(chunk_size, chunk_size)
	plane_mesh.material = preload("res://assets/materials/water.material")
	var mesh_instance = MeshInstance.new()
	mesh_instance.mesh = plane_mesh
	add_child(mesh_instance)