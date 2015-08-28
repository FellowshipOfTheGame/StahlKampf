
extends CanvasLayer

# member variables here, example:
# var a=2
var cell_size = 80


func _end_action():
	get_node("../").currentPlayer_finish_action()#Reativa o processing do jogador atual

func _end_turn():
	get_node("../").currentPlayer_end_turn()#Reativa o processing do jogador atual
	

func _input(ev):

	"""	
	if (ev.type==InputEvent.MOUSE_MOTION):	#Mover cursor junto do mouse
		var posX = int(ev.pos.x/cell_size)
		var posY = int(ev.pos.y/cell_size)
		#get_node("../Control/Cursor").set_pos(Vector2(posX*80,posY*80))
		var tile = get_node("../TileMap").get_cell(posX,posY)
		get_node("terrain_info").set_text("yoyoy")
"""

func _ready():
	get_node("end_action").connect("pressed",self,"_end_action")
	get_node("end_turn").connect("pressed",self,"_end_turn")
	pass


