extends Node2D


var cell_size = 80
var HQWx = 0
var HQWy = 2
var HQLx = 0
var HQLy = 4
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
		
		# ITALO ESTEVE AQUI HU3
		# Tentativa de fazer o mouse considerar deslocamento da câmera para localizar
		var position = get_node("cam").get_pos()
		posY = posY + position.y - 300 
		posX = posX + position.x - 400 #PEGA A POSICAO INICIAL RELATIVA DA CAMERA
		
		print("Mouse Click/Unclick at: ",posX, " ", posY)
		var tileID = get_node("TileMap").get_cell(posX,posY)
		print("tile" + str (tileID))
		
	
	# ITALO ESTEVE AQUI HU3
	if(Input.is_action_pressed("move_cam_up") && !ev.is_echo()):
		var campos = get_node("cam").get_pos()
		var limit = get_node("cam").get_limit(MARGIN_TOP)
		var cur_limit = campos.y - 300
		if(cur_limit > limit):
			campos.y = campos.y - 80
			get_node("cam").set_pos(campos)
		
	if(Input.is_action_pressed("move_cam_left") && !ev.is_echo()):
		var campos = get_node("cam").get_pos()
		var limit = get_node("cam").get_limit(MARGIN_LEFT)
		var cur_limit = campos.x - 400
		if(cur_limit > limit):
			campos.x = campos.x - 80
			get_node("cam").set_pos(campos)
		
	if(Input.is_action_pressed("move_cam_down") && !ev.is_echo()):
		var campos = get_node("cam").get_pos()
		var limit = get_node("cam").get_limit(MARGIN_BOTTOM)
		var cur_limit = campos.y + 300
		if(cur_limit < limit):
			campos.y = campos.y + 80
			get_node("cam").set_pos(campos)
		
	if(Input.is_action_pressed("move_cam_right") && !ev.is_echo()):
		var campos = get_node("cam").get_pos()
		var limit = get_node("cam").get_limit(MARGIN_RIGHT)
		var cur_limit = campos.x + 400
		if(cur_limit < limit):
			campos.x = campos.x + 80
			get_node("cam").set_pos(campos)


#-----------------------------------------------------------------------------

func game_over_check():
	

	if(get_node("player1").get_unit_in_pos(HQLx, HQLy) != "N/A"): #Unidade humana na base robot
		print("Well, GG.")
		get_node("UI/end_game_info").set_text("HUMANITY IS VICTORIOUS")
		set_process(false)
		set_process_input(false)
		#OS.delay_msec(5000)
		get_tree().change_scene("res://Menu.scn")
		pass
	elif(get_node("player2").get_unit_in_pos(HQWx, HQWy) != "N/A"): #Unidade humana na base robot
		print("Well, GG.")
		get_node("UI/end_game_info").set_text("THE ROBOTS ARE VICTORIOUS")
		set_process(false)
		set_process_input(false)
		#OS.delay_msec(5000)
		get_tree().change_scene("res://Menu.scn")
		pass
	
	pass

func _process(delta):


	currentPlayer = players[aux]
	#print("", get_node(currentPlayer).is_playing())
	if(get_node(currentPlayer).is_playing() == false): #jogador atual finalizou seu turno
		aux = aux+1
		if(aux >= players.size()):
			aux = 0
		currentPlayer = players[aux]
		
		if(currentPlayer == "player1"):
			get_node("UI/cp_info/humans_turn").set("visibility/visible", true)
			get_node("UI/cp_info/robots_turn").set("visibility/visible", false)
		else:
			get_node("UI/cp_info/robots_turn").set("visibility/visible", true)
			get_node("UI/cp_info/humans_turn").set("visibility/visible", false)
	#	print("player " ,aux+1)
		get_node(currentPlayer).start_turn()
	
	game_over_check()


	
func _ready():

	set_process_input(true)
	set_process(true)
	
	#Inicialização dos vetor de players
	players.insert(0, "player1")
	players.insert(1, "player2")
	
	#Inicialização dos vetores de unidades de cada player

	get_node("player1").add_unit("../Mark")
	get_node("player1").add_unit("../Klaus")
	get_node("player1").add_unit("../Bismarck")
	get_node("player1").add_unit("../Beth")
	get_node("player1").add_unit("../Marder")
	
	get_node("player2").add_unit("../Unit_0001")
	get_node("player2").add_unit("../Unit_0010")
	get_node("player2").add_unit("../Unit_0011")
	get_node("player2").add_unit("../Unit_0100")
	get_node("player2").add_unit("../Unit_0101")
	
	get_node(players[0]).start_turn() #primeiro player comeca jogando
	currentPlayer = "player1" #primeiro player comeca jogando
	
	pass