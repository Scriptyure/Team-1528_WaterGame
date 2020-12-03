extends Node

var debug = ResourceLoader.load("res://Items/ItemClass/Item-TestItem.gd")
var Item = ResourceLoader.load("res://Scripts/Inventory/Item.gd")

var selectedItem = 0
var itemslotPic = preload("res://Assets/Image/item_slot.png")

var scaleSpriteAmount = 1.5
var camera
var inventoryMidLocation = Vector2(OS.get_real_window_size().x/2, 0)

# SlotPadding [Horizontal, Vertical]
var slotPadding = [25, 5];

var amountOfSlots
var slots = []
var itemsHeld = []


func _init(slotsCount=5, startingItems=[]):
	amountOfSlots = slotsCount
	itemsHeld = startingItems
	inventoryMidLocation.y = inventoryMidLocation.y + itemslotPic.get_height()/2
	inventoryMidLocation.x -= slotsCount/2 * (itemslotPic.get_width()+slotPadding[0])
	

func _ready():
	camera = get_node("/root/World/PlayerCamera")
	for i in range(amountOfSlots):
		slots.append(Sprite.new())
		slots[i].scale = Vector2(scaleSpriteAmount,scaleSpriteAmount)
		slots[i].position = inventoryMidLocation + (Vector2((itemslotPic.get_width()*scaleSpriteAmount)+slotPadding[0], 0))*i
		slots[i].texture = itemslotPic
		self.add_child(slots[i])
	addItem(ResourceLoader.load("res://Items/ItemClass/Item-RoboLol.gd"))
	addItem(debug)
		
func _process(delta):
	# Calculate center of Inventory
	var viewSize = camera.get_viewport().size
	var offsetposition = Vector2(camera.get_camera_screen_center().x - (amountOfSlots/2*((itemslotPic.get_width()*scaleSpriteAmount)+slotPadding[0])),(camera.get_camera_screen_center().y - viewSize.y/2))
	
	# Debug for function testing
	# if Input.is_key_pressed(KEY_F):
	# 	addItem(debug)
	# if Input.is_key_pressed(KEY_G):
	# 	removeItem("TestItem")
	# if Input.is_key_pressed(KEY_H):
	# 	removeItem(0)
	
	for i in range(amountOfSlots):
		slots[i].position = Vector2(offsetposition.x + (((itemslotPic.get_width()*scaleSpriteAmount)+slotPadding[0])*i), offsetposition.y + (itemslotPic.get_height()*scaleSpriteAmount)/2 + slotPadding[1])
		if itemsHeld.size() > i:
			if itemsHeld[i] != null:
				if itemsHeld[i].get_parent() != self:
					add_child(itemsHeld[i])
				itemsHeld[i].itemSprite.position = slots[i].position
				itemsHeld[i].itemSprite.scale = Vector2(scaleSpriteAmount, scaleSpriteAmount)


func addItem(item=null):
	for i in range(itemsHeld.size()-1):
		if itemsHeld[i] == null:
			itemsHeld.remove(i)
			i = i-1
	
	if item == null:
		print("ERROR: No item specified to add")

	if item.get_type() == "Item":
		if itemsHeld.size() == amountOfSlots:
			print("Items are full! Rejecting item addition")
			return
		if itemsHeld.size() == 0:
			item = item.new()
			itemsHeld.append(item);
		elif itemsHeld[0] == null:
			item = item.new()
			itemsHeld[0] = item
		else:
			item = item.new()
			itemsHeld.append(item);

func removeItem(item=null):
	if item == null:
		print("ERROR: No item specified to remove")

	elif typeof(item) == TYPE_STRING:
		for it in itemsHeld:
			if it != null:
				if it.get("itemName") == item:
					it.free()
					for i in range(itemsHeld.size()-1):
						if itemsHeld[i] == null:
							itemsHeld.remove(i)
	
	elif typeof(item) == TYPE_INT:
		if item >= itemsHeld.size() || itemsHeld.size() == 0:
			print("ERROR: That index doesn't exist")
		elif itemsHeld[item] == null:
			print("ERROR: No item exists in that slot")
		else:
			itemsHeld[item].free()
			itemsHeld.remove(item)
	
	elif item.get_type() == "Item":
		print("ERROR: Can't remove an item type must be a name or index")
	
static func setStartingItems(startingItems):
	var processedStartingItems = null
	if typeof(startingItems) != TYPE_ARRAY:
		processedStartingItems = startingItems.new()
	else:
		processedStartingItems = []
		for i in range(startingItems.size()):
			processedStartingItems.append(startingItems[i].new())

	return processedStartingItems
