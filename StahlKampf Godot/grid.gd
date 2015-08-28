
extends Node2D

#var cell_size = 80
#var units = []
#var movements 
#var activeUnit
#var aux = 0
#var playerTurn = bool("true")
#var unitSelected = false

var cell_size = 80

var players = []
var currentPlayer

var aux = 0

#--------------------------------------------------------------------------------	
#**************************
#GETTERS E SETTERS
func get_currentPlayer():
	return currentPlayer

func currentPlayer_finish_action():
	get_node(currentPlayer).finish_current_action() #REATIVA INPUT, E MOSTRA CURSOR NOVAMENTE

func currentPlayer_end_turn():
	get_node(currentPlayer).end_turn() #REATIVA INPUT, E MOSTRA CURSOR NOVAMENTE

#**************************
#INPUT PROCESSING E READY
func _input(ev):

	if (ev.type==InputEvent.MOUSE_BUTTON):
		var posX = int(ev.pos.x/cell_size)
		var posY = int(ev.pos.y/cell_size)
		print("Mouse Click/Unclick at: ",posX, " ", posY)
		var tileID = get_node("TileMap").get_cell(posX,posY)
		print("tile" + str (tileID))
		
	"""
		
	if (ev.type==InputEvent.MOUSE_MOTION):
		var posX = int(ev.pos.x/cell_size)
		var posY = int(ev.pos.y/cell_size)
		
		get_node("Control/Cursor").set_pos(Vector2(posX*80,posY*80))
		
	if(ev.type==InputEvent.MOUSE_BUTTON and !ev.is_pressed()):
		var i=units.size()-1
		var posX = int(ev.pos.x/cell_size)
		var posY = int(ev.pos.y/cell_size)
		#print("Mouse Click/Unclick at: ",posX, " ", posY)
		var tileID = get_node("TileMap").get_cell(posX,posY)
		print("tile" + str (tileID))
		#if (!unitSelected):
		while(i>=0):
			activeUnit = units[i]
			var unit_pos = get_node(activeUnit).get_pos()
			if(posX==int(unit_pos.x/80) && posY==int(unit_pos.y/80)):
				set_process_input(false)
				get_node(activeUnit).set_active()
				get_node("Control").hide()
				unitSelected = true
			i -= 1
		"""

#-----------------------------------------------------------------------------


func _process(delta):

	currentPlayer = players[aux]
	#print("", get_node(currentPlayer).is_playing())
	if(get_node(currentPlayer).is_playing() == false): #jogador atual finalizou seu turno
		aux = aux+1
		if(aux >= players.size()):
			aux = 0
		currentPlayer = players[aux]
		
		if(currentPlayer == "player1"):
			get_node("UI/player_info").set_text("HUMANITY'S TURN")
		else:
			get_node("UI/player_info").set_text("ROBOTS' TURN")
	#	print("player " ,aux+1)
		get_node(currentPlayer).start_turn()
	
	if(Input.is_action_pressed("move_cam_up")):
		var campos = get_node("cam").get_pos()
		campos.y = campos.y - 80
		get_node("cam").set_pos(campos)
		
	if(Input.is_action_pressed("move_cam_left")):
		var campos = get_node("cam").get_pos()
		campos.x = campos.x - 80
		get_node("cam").set_pos(campos)
		
	if(Input.is_action_pressed("move_cam_down")):
		var campos = get_node("cam").get_pos()
		campos.y = campos.y + 80
		get_node("cam").set_pos(campos)
		
	if(Input.is_action_pressed("move_cam_right")):
		var campos = get_node("cam").get_pos()
		campos.x = campos.x + 80
		get_node("cam").set_pos(campos)
		
	if(get_node("player1").get_units_size()==0):#HUMANOS PERDEM
		print("Well, GG.")
		#if(currentPlayer == "player1"):
		get_node("UI/end_game_info").set_text("THE ROBOTS ARE VICTORIOUS")
		
	elif(get_node("player2").get_units_size()==0):#ROBOS PERDEM
		print("Well, GG.")
		get_node("UI/end_game_info").set_text("HUMANITY IS VICTORIOUS")
		#set_process(false)
		#set_process_input(false)

	
func _ready():

	set_process_input(true)
	set_process(true)
	
	#Inicialização dos vetor de players
	players.insert(0, "player1")
	players.insert(1, "player2")
	
	#Inicialização dos vetores de unidades de cada player

	get_node("player1").add_unit("../Fritz")
	get_node("player1").add_unit("../Jerry")
	get_node("player1").add_unit("../Otto")
	get_node("player1").add_unit("../Bertha")

	get_node("player2").add_unit("../Unit_0001")
	get_node("player2").add_unit("../Unit_0010")
	get_node("player2").add_unit("../Unit_0011")
	get_node("player2").add_unit("../Unit_0100")
	
	get_node(players[0]).start_turn() #primeiro player comeca jogando
	currentPlayer = "player1" #primeiro player comeca jogando
	get_node("UI/player_info").set_text("HUMANITY'S TURN")
	
	pass