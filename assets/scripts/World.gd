extends Spatial

const chunk_size = 64
const chunk_amount = 12
var noise
var city_noise
var tree_noise
var turnip_noise
var mountain_nois
var mountain_noise
var chunks = {}
var unready_chunks = {}
var thread
func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 6
	noise.period = 360
	randomize()
	city_noise = OpenSimplexNoise.new()
	city_noise.seed = randi()
	city_noise.octaves = 6
	city_noise.period = 180
	randomize()
	tree_noise = OpenSimplexNoise.new()
	tree_noise.seed = randi()
	tree_noise.octaves = 6
	tree_noise.period = 180
	randomize()
	turnip_noise = OpenSimplexNoise.new()
	turnip_noise.seed = randi()
	turnip_noise.octaves = 6
	turnip_noise.period = 180
	randomize()
	mountain_noise = OpenSimplexNoise.new()
	mountain_noise.seed = randi()
	mountain_noise.octaves = 1
	mountain_noise.period = 540
	thread = Thread.new()

	
func add_chunk(x,z):
	var key = str(x) + "," + str(z)
	if chunks.has(key) or unready_chunks.has(key):
		return
	if not thread.is_active():
		thread.start(self, "load_chunk", [thread,x,z])
		unready_chunks[key] = 1
func load_chunk(arr):
	var thread = arr[0]
	var x = arr[1]
	var z = arr[2]
	var chunk = Chunk.new(noise, tree_noise, city_noise, mountain_noise, turnip_noise, x*chunk_size, z*chunk_size, chunk_size)
	chunk.translation = Vector3(x*chunk_size, 0, z*chunk_size)
	call_deferred("load_done", chunk, thread)
func load_done(chunk,thread):
	add_child(chunk)
	var key = str(chunk.x / chunk_size) + "," + str(chunk.z / chunk_size)
	chunks[key] = chunk
	unready_chunks.erase(key)
	thread.wait_to_finish()
func get_chunk(x,z):
	var key = str(x) + "," + str(z)
	if chunks.has(key):
		return chunks.get(key)
	return null
func _process(delta):
	update_chunks()
	clean_up_chunks()
	reset_chunks()
func update_chunks():
	var player_translation = $Player.translation
	var p_x = int(player_translation.x) / chunk_size
	var p_z = int(player_translation.z) / chunk_size
	for x in range(p_x - chunk_amount  * 0.5, p_x + chunk_amount * 0.5):
		for z in range(p_z - chunk_amount * 0.5, p_z + chunk_amount * 0.5):
			add_chunk(x, z)
			var chunk = get_chunk(x,z)
			if chunk != null:
				chunk.should_remove = false
	pass
func clean_up_chunks():
	for key in chunks:
		var chunk = chunks[key]
		if chunk.should_remove:
			chunk.queue_free()
			chunks.erase(key)
func reset_chunks():
	for key in chunks:
		chunks[key].should_remove = true
