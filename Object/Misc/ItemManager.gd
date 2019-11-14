extends Node

enum ItemType {HAT, SCARF, PATTERN, JETPACK, SKIN, LAST}
enum Payment {COIN, FISH, LAST}

var itemTypeToString = {0:"Hat", 1:"Scarf",	2:"Pattern", 3:"Jetpack", 4:"Skin", 5:"Last"}

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
	var item_type : int = ItemType.LAST
	var item_price : int
	var item_payment : int = Payment.LAST
	var item_buyed : bool
	var item_using : bool
	var item_color
	var item_image_location : String
	
	func create_shop_item(i_id, i_n, i_t, i_pr, i_pa, i_b, i_c, i_l):
		self.item_id = int(i_id)
		self.item_name = String(i_n)
		self.item_type = int(i_t)
		self.item_price = int(i_pr)
		self.item_payment = int(i_pa)
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

class EquippedItem:
	var item_type : int
	var item_id : int
	
	func create_equipped_item(it,id):
		self.item_type = int(it)
		self.item_id = int(id)
		pass

var items_list : Array = []
var items_equipped : Array = []

var res_data_path = 'res://Data/'
var user_data_path = 'user://Saves/'


func load_data_from(dir : String):
	var raw_items_list : Dictionary = try_load_file_data(dir + 'ItemShopData.dat')
	var raw_items_equipped : Dictionary = try_load_file_data(dir + 'EquippedItemsData.dat')
	create_shop_item(raw_items_list)
	create_equipped_items(raw_items_equipped)
	save_data()
	pass

func create_shop_item(dict : Dictionary):
	for item_type in dict.keys():
		for item_id in dict[item_type].keys():
			var item = ShopItem.new()
			var info : Dictionary = dict[item_type][item_id]
			item.create_shop_item(item_id,info['name'], info['type'], info['price'], info['payment'],
								info['buyed'],info['color'] if info.has('color') else null, info['image_location'])
			items_list.append(item)
	pass

func create_equipped_items(dict : Dictionary):
	for item_type in dict.keys():
		var item_equipped = EquippedItem.new()
		item_equipped.create_equipped_item(item_type, dict[item_type])
		items_equipped.append(item_equipped)
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
	if !items_list.empty():
		file.store_line(to_json(shop_item_to_dictionary(items_list)))
		file.store_line("")
	file.close()
	pass

func shop_item_to_dictionary( data_list : Array):
	var data : Dictionary = {}
	for item in data_list:
		var item_raw_data : Dictionary = {}
		item_raw_data["name"] = item.item_name
		item_raw_data["buyed"] = item.item_buyed
		item_raw_data["color"] = item.item_color
		item_raw_data["payment"] = item.item_payment
		item_raw_data["price"] = item.item_price
		item_raw_data["type"] = item.item_type
		item_raw_data["image_location"] = item.item_image_location
		if !data.has(itemTypeToString.get(item.item_type)):
			data[itemTypeToString.get(item.item_type)] = {}
		data[itemTypeToString.get(item.item_type)][item.item_id] = item_raw_data
	return data

func equipped_item_to_dictionary( data_list : Array ):
	var data : Dictionary = {}
	for item in data_list:
		data[item.item_type] = item.item_id
	return data

func save_equipped_item(dir : String):
	var file = File.new()
	file.open(dir + 'EquippedItemsData.dat',File.WRITE)
	if !items_equipped.empty():
		file.store_line(to_json(equipped_item_to_dictionary(items_equipped)))
		file.store_line("")
	file.close()
	pass

func get_equipped_items():
	var item_list : Array = []
	for item_equipped in items_equipped:
		item_list.append(get_item_by_type_id(int(item_equipped.item_type),int(item_equipped.item_id)))
	return item_list

func buy_item(item):
	item.item_buyed = true
	save_data()
	pass

func equip_item(item):
	for item_equipped in items_equipped:
		if item_equipped.item_type == item.item_type:
			items_equipped.erase(item_equipped)
			item_equipped.unreference()
	var new_item = EquippedItem.new()
	new_item.create_equipped_item(item.item_type, item.item_id)
	items_equipped.append(new_item)
	save_data()
	pass

func unequip_item(item):
	for item_equipped in items_equipped:
		if item_equipped.item_type == item.item_type:
			items_equipped.erase(item_equipped)
			item_equipped.unreference()
	save_data()
	pass

func get_items_by_type( type ):
	var items : Array = []
	for item in items_list:
		if item.item_type == type:
			items.append(item)
	return items

func get_item_by_type_id(item_type : int, id : int):
	for item in items_list:
		if item.item_type == item_type and item.item_id == id:
			return item

func get_payment_texture( payment : int ):
	match payment:
		Payment.COIN:
			return 'res://Sprites/Collectables/Coin.png'
		Payment.FISH:
			return 'res://Sprites/Collectables/Fish.png'
	pass

func change_color_item(item):
	for i in items_list:
		if i == item:
			i.item_color = item.item_color
			return

func has_item_equipped(item):
	for item_equipped in items_equipped:
		if item_equipped.item_type == item.item_type and item_equipped.item_id == item.item_id:
			return true
	return false