# --- SETUP ---
# create an area 2d with a collision shape for player pickup range and supply it to pickupArea
# supply the players node to playerNode
# supply players camera or main camera to the camera var

# Inventory Controller handles its own UI

extends Node

var TestItemClass = ResourceLoader.load("res://Items/ItemClass/Item-TestItem.gd")
var Item = ResourceLoader.load("res://Scripts/Inventory/Item.gd")

var pickupArea 
var playerNode
var playerHeld

var currentEvent

var selectedItem = 0
var itemslotPic = preload("res://Assets/Image/item_slot.png")

var scaleSpriteAmount = 1.5
var camera

# SlotPadding [Horizontal, Vertical]
var slotPadding = [25, 5];

var amountOfSlots
var slots = []
var itemsHeld = []

var mousePos 
var mouseAngle

func _init(slotsCount=5, startingItems=[]):
	amountOfSlots = slotsCount
	itemsHeld = startingItems

func _input(event):
	currentEvent = event

func _ready():
	playerHeld = get_node("/root/World/HeldItem")

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
	#addItem(TestItemClass)
	#addItem(ResourceLoader.load("res://Items/ItemClass/Item-ShotgunMain.gd"))
		
func _process(delta):
	# Calculate center of Inventory
	var viewSize = camera.get_viewport().size
	var offsetposition = Vector2(camera.get_camera_screen_center().x - (amountOfSlots/2*((itemslotPic.get_width()*scaleSpriteAmount)+slotPadding[0])),(camera.get_camera_screen_center().y - viewSize.y/2))
	
	# Calculate look Angle for items
	mousePos = camera.get_viewport().get_mouse_position() - viewSize/2
	var heldSprite = playerHeld.get_child(0)

	if mousePos.x != 0:
		mouseAngle = atan2(mousePos.y, mousePos.x) + PI/2
		playerHeld.rotation = mouseAngle 

	# --- HeldItem handling (flipping sprite, selecting sprite) ---
	if itemsHeld.size() > 0:
		if itemsHeld[selectedItem] != null:
			# When cooling down rotate item in hand
			if itemsHeld[selectedItem].itemCooldown && itemsHeld[selectedItem].itemRotateOnCool:
				itemsHeld[selectedItem].itemTempRotation += deg2rad(360*2)*delta
				heldSprite.rotation = itemsHeld[selectedItem].itemRotationOffset + itemsHeld[selectedItem].itemTempRotation
			else:
				itemsHeld[selectedItem].itemTempRotation = 0
				heldSprite.rotation = itemsHeld[selectedItem].itemRotationOffset
			
			# Does item require a spriteflip?
			if itemsHeld[selectedItem].itemRequiresFlipV:
				if rad2deg(mouseAngle) > 180 || rad2deg(mouseAngle) < 0:
					heldSprite.flip_v = true;
				else:
					heldSprite.flip_v = false;

			# If the sprite doesn't match the selected item
			if heldSprite.texture != itemsHeld[selectedItem].itemPic:
				heldSprite.texture = itemsHeld[selectedItem].itemPic
		else:
			heldSprite.texture = null;
	else:
		heldSprite.texture = null;

	# --- Debug for function testing ---
	if(Input.is_mouse_button_pressed(BUTTON_LEFT) && itemsHeld.size() > 0):
		if(itemsHeld[selectedItem] != null):
			itemsHeld[selectedItem].useItem(self)

	if Input.is_key_pressed(KEY_F):
		selectItem(2)
	if Input.is_key_pressed(KEY_G):
		removeItem("TestItem")
	if Input.is_key_pressed(KEY_H):
		addItem(ResourceLoader.load("res://Items/ItemClass/Item-ShotgunMain.gd"))
	if Input.is_key_pressed(KEY_L):
		pickupItem()
		 
	for i in range(amountOfSlots):
		slots[i].position = Vector2(offsetposition.x + (((itemslotPic.get_width()*scaleSpriteAmount)+slotPadding[0])*i), offsetposition.y + (itemslotPic.get_height()*scaleSpriteAmount)/2 + slotPadding[1])
		slots[i].scale = Vector2(scaleSpriteAmount, scaleSpriteAmount)
		if itemsHeld.size() > i:
			if itemsHeld[i] != null:
				if itemsHeld[i].get_parent() != self:
					add_child(itemsHeld[i])
			
				itemsHeld[i].itemSprite.position = slots[i].position

				if i != selectedItem:
					itemsHeld[i].itemSprite.scale = Vector2(scaleSpriteAmount, scaleSpriteAmount)
				else:
					slots[i].scale = Vector2(scaleSpriteAmount*1.25, scaleSpriteAmount*1.25)
					itemsHeld[i].itemSprite.scale = Vector2(scaleSpriteAmount*1.25, scaleSpriteAmount*1.25)

func pickupItem():
	if(pickupArea == null):
		print("ERROR: no pickup area assigned!")
		return
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
		if item >= itemsHeld.size() || item < 0:
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
					selectItem(selectedItem-1)
							
	elif typeof(item) == TYPE_INT:
		if item >= itemsHeld.size() || itemsHeld.size() == 0:
			print("ERROR: That index doesn't exist")
		elif itemsHeld[item] == null:
			print("ERROR: No item exists in that slot")
		else:
			itemsHeld[item].free()
			itemsHeld.remove(item)
			selectItem(selectedItem-1)
	
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
