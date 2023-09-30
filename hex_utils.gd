extends Node

func oddr_to_axial(coords: Vector2) -> Vector3:
	var q = coords.x - (coords.y - (int(coords.y)&1))/2
	var r = coords.y
	return Vector3(q,r,-q-r);
