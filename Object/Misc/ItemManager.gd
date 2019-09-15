extends Node

enum ItemType {HAT, SCARF, PATTERN, JETPACK, LAST}
enum Payment {COIN, FISH, LAST}

class UpgradeItem:
	var item_name : String
	var item_level : int
	var item_price : int

class ShopItem:
	var item_id : int
	var item_name : String
	var item_type = ItemType.LAST
	var item_price : int
	var item_payment = Payment.LAST
	var item_buyed : bool
	var item_using : bool
	var item_color
	var item_color_modify : bool
