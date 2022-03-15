extends Spatial
class_name Chunk
var mesh_instance
var noise
var city_noise
var tree_noise
var mountain_noise
var turnip_noise
var x
var z
var chunk_size
var should_remove = true
var tree = load("res://assets/objects/Spruce.tscn")
var small_hive_building = load("res://assets/objects/SmallAntHive.tscn")
var ant_worker = load("res://assets/objects/WorkerAnt.tscn")
var turnip = load("res://assets/objects/Turnip.tscn")
var storage = load("res://assets/objects/Vase.tscn")
func _init(noise, tree_noise, city_noise, mountain_noise, turnip_noise, x, z, chunk_size):
	self.noise = noise
	self.city_noise = city_noise
	self.tree_noise = tree_noise
	self.mountain_noise = mountain_noise
	self.turnip_noise = turnip_noise
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
		var ny = mountain_noise.get_noise_3d(vertex.x + x, vertex.y, vertex.z + z) * 270
		#vertex.y += ny
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
	mesh_instance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
	mesh_instance.name = "Ground"
	add_child(mesh_instance)
	for i in range(data_tool.get_vertex_count()):
		var vertex = data_tool.get_vertex(i)
		var ny = tree_noise.get_noise_3d(vertex.x + x, vertex.y, vertex.z + z) * 80
		randomize()
		var rand = rand_range(0,512)
		if ny > 8 and vertex.y > 0:
			if rand > 1 and rand < 2:
				var scene_instance = tree.instance()
				scene_instance.set_name("Tree")
				scene_instance.translation.x = vertex.x
				scene_instance.translation.y = vertex.y
				scene_instance.translation.z = vertex.z
				add_child(scene_instance)
		var rand2 = rand_range(0,1024)
		ny = city_noise.get_noise_3d(vertex.x + x, vertex.y, vertex.z + z) * 80
		if ny > 15 and vertex.y > 0:
			if rand2 > 1 and rand2 < 2:
				var scene_instance = small_hive_building.instance()
				scene_instance.set_name("SmallHive")
				scene_instance.translation.x = vertex.x
				scene_instance.translation.y = vertex.y + 7
				scene_instance.translation.z = vertex.z
				add_child(scene_instance)
				var rand3 = rand_range(0,1024)
				var storage_instance = storage.instance()
				storage_instance.set_name("Storage")
				storage_instance.translation.x = vertex.x + 15
				storage_instance.translation.y = vertex.y + 2
				storage_instance.translation.z = vertex.z
				add_child(storage_instance)
				var ant_instance = ant_worker.instance()
				ant_instance.set_name("WorkerAnt")
				ant_instance.translation.x = vertex.x + 20
				ant_instance.translation.y = vertex.y + 7
				ant_instance.translation.z = vertex.z
				ant_instance.storage = storage_instance
				add_child(ant_instance)
			
				var rand4 = rand_range(0,1024)
		ny = turnip_noise.get_noise_3d(vertex.x + x, vertex.y, vertex.z + z) * 80
		var rand4 = rand_range(0,32)
		if ny > 15 and vertex.y > 0:
			if rand4 > 1 and rand4 < 2:
				var turnip_instance = turnip.instance()
				turnip_instance.set_name("Turnip")
				turnip_instance.translation.x = vertex.x
				turnip_instance.translation.y = vertex.y
				turnip_instance.translation.z = vertex.z
				add_child(turnip_instance)
func generate_water():
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(chunk_size, chunk_size)
	plane_mesh.material = preload("res://assets/materials/water.material")
	var mesh_instance = MeshInstance.new()
	mesh_instance.mesh = plane_mesh
	add_child(mesh_instance)
