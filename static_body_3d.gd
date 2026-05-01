extends StaticBody3D

func _ready():
	var mesh_instance = $"pool table/Cube"
	var shape = mesh_instance.mesh.create_trimesh_shape()
	var collision = CollisionShape3D.new()
	collision.shape = shape
	collision.transform = mesh_instance.global_transform
	add_child(collision)
