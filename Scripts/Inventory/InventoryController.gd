# --- SETUP ---
# create an area 2d with a collision shape for player pickup range and supply it to pickupArea
# supply the players node to playerNode
# supply players camera or main camera to the camera var


extends Node

var TestItemClass = ResourceLoader.load("res://Items/ItemClass/Item-TestItem.gd")
var Item = ResourceLoader.load("res://Scripts/Inventory/Item.gd")

var pickupArea 
var playerNode

var selectedItem = 0
var itemslotPic = preload("res://Assets/Image/item_slot.png")

var scaleSpriteAmount = 1.5
var camera

# SlotPadding [Horizontal, Vertical]
var slotPadding = [25, 5];

var amountOfSlots
var slots = []
var itemsHeld = []


func _init(slotsCount=5, startingItems=[]):
	amountOfSlots = slotsCount
	itemsHeld = startingItems
	

func _ready():
	# --- Camera Stuff ---
	camera = get_node("/root/World/PlayerCamera")
	var viewSize = camera.get_viewport().size
	
	# --- Slot Init ---
	for i in range(amountOfSlots):
		slots.append(Sprite.new())
		slots[i].scale = Vector2(scaleSpriteAmount,scaleSpriteAmount)
		slots[i].position = Vector2(camera.get_camera_screen_center().x - (amountOfSlots/2*((itemslotPic.get_width()*scaleSpriteAmount)+slotPadding[0])),(camera.get_camera_screen_center().y - viewSize.y/2))
		slots[i].texture = itemslotPic
		self.add_child(slots[i])
	
	# --- Debug addItem's ---
	#addItem(ResourceLoader.load("res://Items/ItemClass/Item-RoboLol.gd"))
	addItem(TestItemClass)
		
func _process(delta):
	# Calculate center of Inventory
	var viewSize = camera.get_viewport().size
	var offsetposition = Vector2(camera.get_camera_screen_center().x - (amountOfSlots/2*((itemslotPic.get_width()*scaleSpriteAmount)+slotPadding[0])),(camera.get_camera_screen_center().y - viewSize.y/2))
	
	# --- Debug for function testing ---
	# if Input.is_key_pressed(KEY_F):
	# 	addItem(debug)
	# if Input.is_key_pressed(KEY_G):
	# 	removeItem("TestItem")
	# if Input.is_key_pressed(KEY_H):
	# 	removeItem(0)
	# if Input.is_key_pressed(KEY_L):
	#	pickupItem()
		 
	for i in range(amountOfSlots):
		slots[i].position = Vector2(offsetposition.x + (((itemslotPic.get_width()*scaleSpriteAmount)+slotPadding[0])*i), offsetposition.y + (itemslotPic.get_height()*scaleSpriteAmount)/2 + slotPadding[1])
		if itemsHeld.size() > i:
			if itemsHeld[i] != null:
				if itemsHeld[i].get_parent() != self:
					add_child(itemsHeld[i])
				itemsHeld[i].itemSprite.position = slots[i].position
				itemsHeld[i].itemSprite.scale = Vector2(scaleSpriteAmount, scaleSpriteAmount)

func pickupItem():
	if pickupArea.get_overlapping_areas() == null:
		return
	if pickupArea.get_overlapping_areas().size() == 0:
		return
	
	var _distances = []
	var _Items = []
	for _Item in pickupArea.get_overlapping_areas():
		if _Item.get_parent().get_type() == "Item":
			if _Item.get_parent().get_parent() != self:
				_Items.append(_Item.get_parent())
				_distances.append(abs(sqrt(pow((_Item.get_parent().position.x - playerNode.position.x), 2) + pow((_Item.get_parent().position.y - playerNode.position.y), 2))))

	var _currentSmallest
	var _smallestIndex
	for i in range(_distances.size()):
		if _currentSmallest == null:
			_currentSmallest = _distances[i]
		if _distances[i] < _currentSmallest:
			_currentSmallest = _distances[i]
			_smallestIndex = i;
	
	for _Item in range(_Items.size()):
		if _distances[_Item] == _currentSmallest:
			for _ItemHeld in itemsHeld:
				if _ItemHeld.itemName == _Items[_Item].itemName:
					print("Item already held in slot, can't pickup another")
					return 
			addItem(_Items[_Item].get_script())
			_Items[_Item].free()

	
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

func selectItem(item=null):
	if item == null:
		print("Item selection is empty!")
		return
	elif typeof(item) == TYPE_INT:
		if item >= itemsHeld.size():
			print("ERROR: Index selected is out of bounds (selectItem)")
			return
		selectedItem = item
	
	

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
