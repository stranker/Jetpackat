extends Node

enum ItemType {HAT, SCARF, PATTERN, JETPACK, SKIN, LAST}
enum Payment {COIN, FISH, LAST}
enum UpgradeType {CURRENCY, CHIP, LAST}

var itemTypeToString = {0:"Hat", 1:"Scarf", 2:"Pattern", 3:"Jetpack", 4:"Skin", 5:"Last"}

class UpgradeItem:
	var item_type : int
	var item_name : String
	var item_level : int
	var item_price_per_level : Dictionary
	
	func create_upgrade_item(item_type, item_name, item_level, item_price_per_level):
		self.item_type = int(item_type)
		self.item_name = str(item_name)
		self.item_level = int(item_level)
		self.item_price_per_level = item_price_per_level
		pass
	
	func get_next_level_info():
		var info = null
		if self.has_next_level():
			info = item_price_per_level[str(item_level + 1)]
		return info
	
	func upgrade_item():
		if self.has_next_level():
			item_level += 1
		pass
		
	func has_next_level():
		return item_price_per_level.keys().has(str(item_level + 1))


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
var upgrade_items : Array = []

var res_data_path = 'res://Data/'
var user_data_path = 'user://Saves/'


func load_data_from(dir : String):
	var raw_items_list : Dictionary = try_load_file_data(dir + 'ItemShopData.dat')
	var raw_items_equipped : Dictionary = try_load_file_data(dir + 'EquippedItemsData.dat')
	var raw_upgrade_items : Dictionary = try_load_file_data(dir + 'UpgradeItemsData.dat')
	create_shop_item(raw_items_list)
	create_equipped_items(raw_items_equipped)
	create_upgrade_item(raw_upgrade_items)
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

func create_upgrade_item(dict : Dictionary):
	for item_id in dict.keys():
		var upgrade_item = UpgradeItem.new()
		upgrade_item.create_upgrade_item(item_id, dict[item_id]['name'], dict[item_id]['level'],dict[item_id]['price_per_level'])
		upgrade_items.append(upgrade_item)
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
	save_data_to_file(user_data_path, 'ItemShopData.dat', items_list, 'shop_item_to_dictionary')
	save_data_to_file(user_data_path, 'EquippedItemsData.dat', items_equipped,'equipped_item_to_dictionary')
	save_data_to_file(user_data_path, 'UpgradeItemsData.dat', upgrade_items, 'upgrade_item_to_dictionary')
	pass

func save_data_to_file(dir : String, file_name : String, data, method):
	var file = File.new()
	file.open(dir + file_name,File.WRITE)
	if !items_equipped.empty():
		file.store_line(to_json(call(method,data)))
	file.call_deferred('close')
	pass

func shop_item_to_dictionary( data_list : Array):
	var data : Dictionary = {}
	for item in data_list:
		var item_raw_data : Dictionary = {}
		item_raw_data['name'] = item.item_name
		item_raw_data['buyed'] = item.item_buyed
		item_raw_data['color'] = item.item_color
		item_raw_data['payment'] = item.item_payment
		item_raw_data['price'] = item.item_price
		item_raw_data['type'] = item.item_type
		item_raw_data['image_location'] = item.item_image_location
		if !data.has(itemTypeToString.get(item.item_type)):
			data[itemTypeToString.get(item.item_type)] = {}
		data[itemTypeToString.get(item.item_type)][item.item_id] = item_raw_data
	return data

func equipped_item_to_dictionary( data_list : Array):
	var data : Dictionary = {}
	for item in data_list:
		data[item.item_type] = item.item_id
	return data

func upgrade_item_to_dictionary( data_list : Array):
	var data : Dictionary = {}
	for upgrade_item in data_list:
		var upgrade_item_raw_data : Dictionary = {}
		upgrade_item_raw_data['name'] = upgrade_item.item_name
		upgrade_item_raw_data['level'] = upgrade_item.item_level
		upgrade_item_raw_data['price_per_level'] = upgrade_item.item_price_per_level
		data[upgrade_item.item_type] = upgrade_item_raw_data
	return data

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

func set_skin_color(color):
	var skin = get_item_by_type_id(ItemType.SKIN,0)
	skin.set_color(color)
	pass

func get_upgrade_item_by_type(type : int):
	var item = null
	for upgrade_item in upgrade_items:
		if upgrade_item.item_type == type:
			item = upgrade_item
			break
	return item
