extends Control

onready var pattern_btn = $BackPanel/HBC/PlayerPanel/PatternButton
onready var jetpack_btn = $BackPanel/HBC/PlayerPanel/JetpackButton
onready var skin_btn = $BackPanel/HBC/PlayerPanel/SkinButton
onready var hat_btn = $BackPanel/HBC/PlayerPanel/HatButton
onready var scarf_btn = $BackPanel/HBC/PlayerPanel/ScarfButton
onready var color_picker = $BackPanel/CustomColor
onready var item_page_grid = $BackPanel/HBC/PanelItems/ItemPageGrid
onready var player_panel = $BackPanel/HBC/PlayerPanel
onready var item_list = $BackPanel/HBC/PanelItems/ItemPageGrid/VBC/Grid

var current_item_panel

signal on_show_confirmation_panel(item, panel_ref)
signal closed

func _ready():
	update_equipment()
	_on_HatButton_on_clicked(hat_btn)
	$BackPanel.visible = false
	pass

func start():
	$Anim.play("Enter")
	pass

func update_equipment():
	if !ItemManager.items_equipped.empty():
		for item_equipped in ItemManager.items_equipped:
			set_item_on_player(item_equipped)
	pass

func set_item_on_player(item_equipped):
	var item = ItemManager.get_item_by_type_id(int(item_equipped.item_type),int(item_equipped.item_id))
	if item.item_type == ItemManager.ItemType.SKIN:
		skin_btn.self_modulate = item.item_color
	elif item.item_type == ItemManager.ItemType.JETPACK:
		jetpack_btn.set_textures(load(item.item_image_location))
	else:
		var player_item = skin_btn.get_node(ItemManager.itemTypeToString[item.item_type])
		player_item.texture = load(item.item_image_location)
		if item.has_color():
			player_item.self_modulate = item.item_color
		player_item.show()
	pass

func _on_PatternButton_on_clicked(self_ref):
	on_item_type_selected(ItemManager.ItemType.PATTERN, self_ref)
	pass # Replace with function body.


func _on_JetpackButton_on_clicked(self_ref):
	on_item_type_selected(ItemManager.ItemType.JETPACK, self_ref)
	pass # Replace with function body.


func _on_SkinButton_on_clicked(self_ref):
	on_item_type_selected(ItemManager.ItemType.SKIN, self_ref)
	pass # Replace with function body.


func _on_HatButton_on_clicked(self_ref):
	on_item_type_selected(ItemManager.ItemType.HAT, self_ref)
	pass # Replace with function body.


func _on_ScarfButton_on_clicked(self_ref):
	on_item_type_selected(ItemManager.ItemType.SCARF, self_ref)
	pass # Replace with function body.

func on_item_type_selected( type , btn_ref):
	if type != ItemManager.ItemType.SKIN:
		var items : Array = ItemManager.get_items_by_type(type)
		if !items.empty():
			create_panels(items)
	else:
		current_item_panel = "SKIN"
		open_color_picker(current_item_panel)
	unclick_other_buttons(btn_ref)
	#$ButtonClick.play()
	pass

func unclick_other_buttons(current_button):
	for button in player_panel.get_children():
		if button is TextureButton:
			if button != current_button:
				button.unclick_button()
	pass

func create_panels(data : Array):
	item_page_grid.create_shop_items(data)
	pass

func open_color_picker(item_panel):
	color_picker.show()
	current_item_panel = item_panel
	pass

func equip_item(item):
	update_equipment()
	enable_used_items(item)
	pass

func enable_used_items(item):
	for i in item_list.get_children():
		if i.item != item:
			i.enable_use_button(true)
	pass

func _on_CustomColor_value_changed(c):
	if current_item_panel:
		if typeof(current_item_panel) != TYPE_STRING:
			current_item_panel.set_item_color(c)
		else:
			set_skin_color(c)
	pass # Replace with function body.

func change_color_item(item):
	skin_btn.get_node(ItemManager.itemTypeToString.get(item.item_type)).self_modulate = item.item_color
	pass

func set_skin_color(color):
	skin_btn.self_modulate = color
	ItemManager.set_skin_color(color)
	pass

func unequip_item(item):
	skin_btn.get_node(ItemManager.itemTypeToString.get(item.item_type)).texture = null
	pass

func equip_default_jetpack():
	for i in item_list.get_children():
		if i.item.item_type == ItemManager.ItemType.JETPACK and i.item.item_name == 'Green':
			i.equip_item()
			break
	pass

func item_preview(item_type,item_texture):
	for i in item_list.get_children():
		i.unequip_item()
	if item_type == ItemManager.ItemType.JETPACK:
		jetpack_btn.set_textures(item_texture)
	else:
		skin_btn.get_node(ItemManager.itemTypeToString.get(item_type)).texture = item_texture
		skin_btn.get_node(ItemManager.itemTypeToString.get(item_type)).self_modulate = 'ffffff'
	pass

func show_shop_confirmation(item, panel_ref):
	emit_signal("on_show_confirmation_panel", item, panel_ref)
	pass


func _on_CloseButton_button_down():
	$Anim.play_backwards("Enter")
	emit_signal("closed")
	pass # Replace with function body.
