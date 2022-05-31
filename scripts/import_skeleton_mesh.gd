tool
extends EditorScenePostImport

func post_import(scene):
	scene = scene as Spatial
	
	for mesh in scene.get_child(0).get_child(0).get_children():
		mesh.create_trimesh_collision()
	
	return scene
