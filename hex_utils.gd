extends Node

func oddr_to_axial(coords: Vector2) -> Vector3:
	var q = coords.x - (coords.y - (int(coords.y)&1))/2
	var r = coords.y
	return Vector3(q,r,-q-r);

func get_neighbors(hex_loc: Vector2, offset_array : Array[Array]) -> Array[Node2D]:
	"Get all the neighbors for a hex"
	var neighbors : Array[Node2D] = []
	var oddr_direction_differences = [
	# even rows 
	[[+1,  0], [ 0, -1], [-1, -1], 
	 [-1,  0], [-1, +1], [ 0, +1]],
	# odd rows
	[[+1,  0], [+1, -1], [ 0, -1], 
	 [-1,  0], [ 0, +1], [+1, +1]]]
	
	var parity = int(hex_loc.y) & 1
	for direction in range(6):
		var diff = Vector2(oddr_direction_differences[parity][direction][0],oddr_direction_differences[parity][direction][1])
		var neighbor_coord = hex_loc + diff
		if neighbor_coord[0] >= 0 and neighbor_coord[1] >= 0 and neighbor_coord[0] < offset_array.size() and neighbor_coord[1] < offset_array[0].size():
			neighbors.append(offset_array[neighbor_coord.x][neighbor_coord.y]);
	
	return neighbors

func find_path(start_loc: Vector2, goal_loc: Vector2, offset_array: Array[Array]) -> Array[Vector2]:
	"""
	Plot a path from start_loc to goal_loc
	"""
	
	# Depth-first Search
	var frontier : Array[Vector2] = []
	# A -> B is stored as came_from[b] = a
	var came_from : Dictionary = {}
	came_from[start_loc] = null;
	
	frontier.push_back(start_loc)
	while not frontier.is_empty():
		var current : Vector2 = frontier.pop_front()
		for next in get_neighbors(current, offset_array):
			if next.coords not in came_from.keys() and next.hex_resource.passable:
				frontier.push_back(next.coords)
				came_from[next.coords] = current
	
	# If there is no path
	if !came_from.has(goal_loc):
		return [];
		
	var current : Vector2 = goal_loc
	var path : Array[Vector2] = []
	while current != start_loc:
		path.append(current)
		current = came_from[current]
	path.append(start_loc)
	path.reverse();
	
	return path
	
