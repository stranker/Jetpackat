extends Node2D

export (Array, PackedScene) var objects_scene_list
export var objects_number : int

func _ready():
	create_objects()
	pass

func create_objects():
	if !objects_scene_list.empty():
		for object_scene in objects_scene_list:
			for i in range(objects_number):
				var object = object_scene.instance()
				call_deferred('add_child',object)
				object.call_deferred('set_active',false)
				object.call_deferred('set_global_position',Vector2.ONE * -999)
				object.connect('dispose',self,'return_object')
	pass

func get_object_by_name(obj_name : String):
	var object = null
	var children_list = get_children()
	children_list.shuffle()
	for obj in children_list:
		if obj.name.find(obj_name) >= 0 and !obj.activated:
			object = obj
			break
	return object

func return_object(obj):
	obj.get_parent().call_deferred('remove_child',obj)
	obj.set_active(false)
	obj.call_deferred('set_global_position',Vector2(-900,-900))
	call_deferred('add_child',obj)
