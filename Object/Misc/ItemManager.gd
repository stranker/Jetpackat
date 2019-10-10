extends Node

enum ItemType {HAT, SCARF, PATTERN, JETPACK, SKIN, LAST}
enum Payment {COIN, FISH, LAST}

var itemTypeByString = {"Hat":ItemType.HAT, "Scarf":ItemType.SCARF, 
						"Pattern":ItemType.PATTERN, "Jetpack":ItemType.JETPACK, 
						"Skin":ItemType.SKIN, "Last":ItemType.LAST}

class UpgradeItem:
	var item_id : int
	var item_name : String
	var item_level : int
	var item_price : int
	
	func create_upgrade_item(item_id, item_name, item_level, item_price):
		self.item_id = item_id
		self.item_name = item_name
		self.item_level = item_level
		self.item_price = item_price
		pass
	
	func level_up():
		item_level += 1
		pass

class ShopItem:
	var item_id : int
	var item_name : String
	var item_type = ItemType.LAST
	var item_price : int
	var item_payment = Payment.LAST
	var item_buyed : bool
	var item_using : bool
	var item_color
	var item_image_location : String
	
	func create_shop_item(i_id, i_n, i_t, i_pr, i_pa, i_b, i_c, i_l):
		self.item_id = int(i_id)
		self.item_name = String(i_n)
		self.item_type = ItemType.get(i_t)
		self.item_price = int(i_pr)
		self.item_payment = Payment.get(i_pa)
		self.item_buyed = bool(i_b)
		self.item_color = i_c
		self.item_image_location = i_l
		pass
	
	func buy_item():
		item_buyed = true
		pass
	
	func set_using(val):
		item_using = val
		pass
	
	func has_color():
		return item_color != null
	
	func set_color(col):
		item_color = col
		pass

var item_data : Array = []
var items_equipped : Dictionary = {}

var res_data_path = 'res://Data/'
var user_data_path = 'user://Saves/'

func _ready():
	load_data()
	pass

func load_data():
	var dir = Directory.new()
	# DIDN'T SAVE ANYTHING LATER
	if !dir.dir_exists(user_data_path):
		dir.make_dir(user_data_path)
		load_data_from(res_data_path)
	else:
		load_data_from(user_data_path)
	pass

func load_data_from(dir : String):
	var raw_item_data : Dictionary = try_load_file_data(dir + 'ItemShopData.dat')
	var raw_items_equipped : Dictionary = try_load_file_data(dir + 'EquippedItemsData.dat')
	create_shop_item(raw_item_data)
	pass

func create_shop_item(dict : Dictionary):
	for item_type in dict.keys():
		for item_name in dict[item_type].keys():
			var item = ShopItem.new()
			var info : Dictionary = dict[item_type][item_name]
			item.create_shop_item(info['id'],item_name, item_type, info['price'], info['payment'],
								info['buyed'],info['color'] if info.has('color') else null, info['image_location'])
			item_data.append(item)
	pass

func try_load_file_data(res_path):
	var file = File.new()
	var output : Dictionary = {}
	if file.file_exists(res_path):
		file.open(res_path,File.READ)
		output = parse_json(file.get_as_text())
		file.close()
	return output

func save_data():
	save_item_data(user_data_path)
	save_equipped_item(user_data_path)
	pass

func save_item_data(dir : String):
	var file = File.new()
	file.open(dir + 'ItemShopData.dat',File.WRITE)
	if !item_data.empty():
		file.store_line(to_json(item_data))
		file.store_line("")
	file.close()
	pass

func save_equipped_item(dir : String):
	var file = File.new()
	file.open(dir + 'EquippedItemsData.dat',File.WRITE)
	if !items_equipped.empty():
		file.store_line(to_json(items_equipped))
		file.store_line("")
	file.close()
	pass

func get_equipped_items():
	var item_list = []
	for item_type in items_equipped.keys():
		item_list.append(get_item_by_type_id(item_type,items_equipped[item_type]))
	return item_list

func buy_item(item_type,id):
	for item in item_data:
		if item.item_id == id and item.item_type == item_type:
			item.item_buyed = true
			break
	save_data()
	pass

func equip_item(item):
	items_equipped[item.item_type] = item.id
	save_data()
	pass

func unequip_item(item):
	items_equipped.erase(item.item_type)
	save_data()
	pass

func get_item_by_type_id(item_type, id):
	for item in item_data:
		if item.type == item_type and item.id == id:
			return item