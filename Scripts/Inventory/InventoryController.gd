# --- SETUP ---
# create an area 2d with a collision shape for player pickup range and supply it to pickupArea
# supply the players node to playerNode
# supply players camera or main camera to the camera var

# Inventory Controller handles its own UI

extends Node

var TestItemClass = ResourceLoader.load("res://Items/ItemClass/Item-TestItem.gd")
var Item = ResourceLoader.load("res://Scripts/Inventory/Item.gd")

var UI_ZINDEX = 500;
var pickupArea 
var playerNode
var playerHeld

var currentEvent

var selectedItem = 0
var itemslotPic = preload("res://Assets/Image/item_slot.png")

var scaleSpriteAmount = 1.5
var camera

var heldSprite

# SlotPadding [Horizontal, Vertical]
var slotPadding = [5, 2];

var amountOfSlots
var slots = []
var itemsHeld = []

var mousePos 
var mouseAngle


func _init(slotsCount=5, startingItems=[]):
	amountOfSlots = slotsCount
	itemsHeld = startingItems

# This will be handled by playerController script eventually, for testing purposes it exists here
func _input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed() && itemsHeld.size() > 0:
		if(itemsHeld[selectedItem] != null):
			itemsHeld[selectedItem].useItem(self)

	if event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_DOWN && event.is_pressed():
		if selectedItem > 0:
			selectItem(selectedItem-1)
		else:
			selectItem(itemsHeld.size()-1)

	if event is InputEventMouseButton && event.button_index == BUTTON_WHEEL_UP && event.is_pressed():
		if selectedItem < amountOfSlots-1:
			selectItem(selectedItem+1)
		else:
			selectItem(0)	
		
	if event is InputEventKey && event.scancode == KEY_P && event.is_pressed():
		addItem(ResourceLoader.load("res://Items/ItemClass/Item-ShotgunMain.gd"))
		
	if event is InputEventKey && event.scancode == KEY_O && event.is_pressed():
		removeItem(selectedItem)

func _ready():
	playerNode = get_node("/root/World/Player")
	playerHeld = get_node("/root/World/Player/HeldItem")

	# --- Camera Stuff ---
	camera = get_node("/root/World/PlayerCamera")
	var viewSize = camera.get_viewport().size

	# Grab the itemHeld Sprite
	heldSprite = playerHeld.get_child(0)

	# --- Slot Init ---
	for i in range(amountOfSlots):
		slots.append(Sprite.new())
		slots[i].scale = Vector2(scaleSpriteAmount,scaleSpriteAmount)
		var itemSlotWidth = (itemslotPic.get_width()*scaleSpriteAmount)
		var itemSlotHeight = (camera.get_camera_screen_center().y - viewSize.y/2)+(slotPadding[1]*scaleSpriteAmount)

		var paddingCalcWidth = amountOfSlots/2*(itemSlotWidth+(slotPadding[0]*scaleSpriteAmount))
		slots[i].position = Vector2(camera.get_camera_screen_center().x - paddingCalcWidth,itemSlotHeight * camera.zoom.y)
		slots[i].texture = itemslotPic
		self.add_child(slots[i])
		
func _process(delta):
	
	var viewSize = camera.get_viewport().size
	scaleSpriteAmount = 2 * ((camera.zoom.x+camera.zoom.y)/2)
	
	# Calculate center of Inventory
	var itemSlotHeight = (camera.get_camera_screen_center().y - viewSize.y/2)+(slotPadding[1]*scaleSpriteAmount)
	var itemSlotWidth = (itemslotPic.get_width()*scaleSpriteAmount)
	var paddingCalcWidth = (amountOfSlots/2*(itemSlotWidth+(slotPadding[0]*scaleSpriteAmount*camera.zoom.x)))
	var offsetposition = Vector2(camera.get_camera_screen_center().x - paddingCalcWidth, itemSlotHeight*camera.zoom.y)
	
	# Calculate look Angle for items
	mousePos = ((camera.get_viewport().get_mouse_position() - viewSize/2)+camera.position)*camera.zoom - playerNode.position;
	
	if mousePos.x != 0:
		mouseAngle = atan2(mousePos.y, mousePos.x) + PI/2
		playerHeld.rotation = mouseAngle 
	
	if rad2deg(mouseAngle) > 180 || rad2deg(mouseAngle) < 0:
		playerNode.playerSpriteLeft = true;
	else:
		playerNode.playerSpriteLeft = false;
		

	# --- HeldItem handling (flipping sprite, selecting sprite) ---
	if itemsHeld.size() > 0:
		if itemsHeld[selectedItem] != null:
			# Setup the held Item based on the Item being held 
			heldSprite.position = Vector2(0,-(itemsHeld[selectedItem].itemPic.get_width()/2*itemsHeld[selectedItem].itemScale.x))
			heldSprite.scale = Vector2(itemsHeld[selectedItem].itemScale.x, itemsHeld[selectedItem].itemScale.y)
			
			# When cooling down rotate item in hand
			if itemsHeld[selectedItem].itemCooldown && itemsHeld[selectedItem].itemRotateOnCool:
				itemsHeld[selectedItem].itemTempRotation += deg2rad(itemsHeld[selectedItem].itemRotateOnCoolRate)*delta

				# If the Item is flipped flip rotations
				if heldSprite.flip_v:
					heldSprite.rotation = itemsHeld[selectedItem].itemRotationOffset + itemsHeld[selectedItem].itemTempRotation
				else:
					heldSprite.rotation = itemsHeld[selectedItem].itemRotationOffset - itemsHeld[selectedItem].itemTempRotation

			else:
				itemsHeld[selectedItem].itemTempRotation = 0
				heldSprite.rotation = itemsHeld[selectedItem].itemRotationOffset
			
			# Does item require a spriteflip?
			if itemsHeld[selectedItem].itemRequiresFlipV:
				if rad2deg(mouseAngle) > 180 || rad2deg(mouseAngle) < 0:
					playerNode.playerSpriteLeft = true;
					heldSprite.flip_v = true;
				else:
					playerNode.playerSpriteLeft = false;
					heldSprite.flip_v = false;

			# If the sprite doesn't match the selected item
			if heldSprite.texture != itemsHeld[selectedItem].itemPic:
				heldSprite.texture = itemsHeld[selectedItem].itemPic
		else:
			heldSprite.texture = null;
	else:
		heldSprite.texture = null;
		
		 
	for i in range(amountOfSlots):
		# Handle slot positioning, itemspicturewidth*scaling + padding*indexing to place items in the center
		slots[i].position = Vector2(offsetposition.x + (((itemslotPic.get_width()*scaleSpriteAmount)+slotPadding[0])*i), offsetposition.y + (itemslotPic.get_height()*scaleSpriteAmount)/2 + slotPadding[1])
		
		# Scaling is handled based on screen size and the independent scaling
		slots[i].scale = Vector2(scaleSpriteAmount, scaleSpriteAmount)
		
		slots[i].z_index = UI_ZINDEX
		# Guarantee that all Items are parented to the inventory
		if itemsHeld.size() > i:
			if itemsHeld[i] != null:
				if itemsHeld[i].get_parent() != self:
					add_child(itemsHeld[i])
				
				# Place items in their respective slots
				itemsHeld[i].itemSprite.position = slots[i].position
				
				itemsHeld[i].itemSprite.z_index = UI_ZINDEX

				# If the slot isn't selected Keep the scaling normal, if it is selected make it show
				if i != selectedItem:
					itemsHeld[i].itemSprite.scale = Vector2(scaleSpriteAmount, scaleSpriteAmount)
				else:
					slots[i].scale = Vector2(scaleSpriteAmount*1.25, scaleSpriteAmount*1.25)
					itemsHeld[i].itemSprite.scale = Vector2(scaleSpriteAmount*1.25, scaleSpriteAmount*1.25)

func pickupItem():
	# --- Error Handling ---
	if(pickupArea == null):
		print("ERROR: no pickup area assigned!")
		return
	if pickupArea.get_overlapping_areas() == null:
		return
	if pickupArea.get_overlapping_areas().size() == 0:
		return

	# Temporary Variables for the pickup system
	var _distances = []
	var _Items = []
	
	# Check every collider to see if they are of the Item class
	for _Item in pickupArea.get_overlapping_areas():
		if _Item.get_parent().get_type() == "Item":
			if _Item.get_parent().get_parent() != self:
				_Items.append(_Item.get_parent())
				_distances.append(abs(sqrt(pow((_Item.get_parent().position.x - playerNode.position.x), 2) + pow((_Item.get_parent().position.y - playerNode.position.y), 2))))
	
	# More temporary variables to compare data
	var _currentSmallest
	var _smallestIndex

	# Check which Item detected is closest to player
	for i in range(_distances.size()):
		if _currentSmallest == null:
			_currentSmallest = _distances[i]
		if _distances[i] < _currentSmallest:
			_currentSmallest = _distances[i]
			_smallestIndex = i;
	
	# Add the closest Item
	for _Item in range(_Items.size()):
		if _distances[_Item] == _currentSmallest:
			addItem(_Items[_Item].get_script())
			_Items[_Item].free()

func addItem(item=null):
	# Remove any NULL spaces in the inventory
	for i in range(itemsHeld.size()-1):
		if itemsHeld[i] == null:
			itemsHeld.remove(i)
			i = i-1
	
	# Error Checking
	if item == null:
		print("ERROR: No item specified to add")
	
	# Add the Item to Inventory
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

# Selects an Item in the inventory by index
func selectItem(item=null):
	if item == null:
		print("Item selection is empty!")
		return

	elif typeof(item) == TYPE_INT:
		if item >= itemsHeld.size() || item < 0:
			print("ERROR: Index selected is out of bounds (selectItem)")
			selectedItem = 0
			return
		selectedItem = item
	
func removeItem(item=null):
	# Error Checking
	if item == null:
		print("ERROR: No item specified to remove")
	
	# If the Item was given by name then remove all instances of that Item
	elif typeof(item) == TYPE_STRING:
		for it in itemsHeld:
			if it != null:
				if it.get("itemName") == item:
					it.free()

					# Remove the NULL space generated by this action
					for i in range(itemsHeld.size()-1):
						if itemsHeld[i] == null:
							itemsHeld.remove(i)

							# Fix the players selection if the index selected is affected by the previous deletion
							if(selectedItem >= i):
								selectItem(selectedItem-1)
					
	# If the Item was given by index remove the Item at that index rather than all items by name
	elif typeof(item) == TYPE_INT:
		if item >= itemsHeld.size() || itemsHeld.size() == 0:
			print("ERROR: That index doesn't exist")
		elif itemsHeld[item] == null:
			print("ERROR: No item exists in that slot")
		else:
			itemsHeld[item].free()
			itemsHeld.remove(item)

			# Fix the players selection if the index selected is affected by the previous deletion
			if selectedItem >= item:
				selectItem(selectedItem-1)
			
	# This checks whether a Item class was given, for now at least there is no handling for this behavior
	elif item.get_type() == "Item":
		print("ERROR: Can't remove an item type must be a name or index")

# Function that returns an array with initialized Items for use with inventory
static func setStartingItems(startingItems):
	var processedStartingItems = null
	if typeof(startingItems) != TYPE_ARRAY:
		processedStartingItems = startingItems.new()
	else:
		processedStartingItems = []
		for i in range(startingItems.size()):
			processedStartingItems.append(startingItems[i].new())

	return processedStartingItems
