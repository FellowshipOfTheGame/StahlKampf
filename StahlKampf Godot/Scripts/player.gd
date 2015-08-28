	
extends Node2D

var units = [] 
var cell_size = 80

var currentCP #COMMNAD / CONTROL POINTS
var totalCP = 4 #SUBJECT TO CHANGE

var activeUnit
var playing # Se o jogador esta jogando ou não
var unitSelected = false

var aux = 0


#--------------------------------------------------------------------------------	
#********
#Funcoes para unidades

func add_unit(var u):
	units.append(u)
	pass
	
func rem_unit(var dead):

	for i in range (units.size()):
		if(dead == units[i]):
			get_node(dead).queue_free()
#			units.remove(i)
	pass
	
func get_units_size():
	return units.size()
	pass

func get_unit_in_pos(var posX, var posY):#Retorna o path de uma unidade, se existente na posição fornecida, argumentos em TILEs
	posX = int(posX) #A posição fornecida já foi divida por 80, mas não foi transformada em inteiro
	posY = int(posY)

	#print("Entrou em get_unit_in_pos, com a pos ", posX, "X ", posY, "Y")
	
	for i in range(units.size()):
	#	print("Entrou no for units.size()")
		if(get_node(units[i])!= null):
			var unit_pos = get_node(units[i]).get_pos()
			
			if(posX==int(unit_pos.x/80) and posY==int(unit_pos.y/80)): #Esta na posicao
				return units[i]

	return "N/A"
	pass

#********
#Funcoes para comeco e fim de turno
func finish_current_action(): #desativa a unidade atual , SUBTRAI COMMAND POINTS
	#if(get_node(activeUnit)!=null):
	#	get_node(activeUnit).deactivate()
	set_process_input(true) 
	unitSelected = false
	
	if(currentCP!=0): #Não mostra CP negativo no HUD
		currentCP -= 1
	
	var info = str("", currentCP)
	get_node("../UI/cp_info").set_text(info)
	
	
func start_turn():
	playing = true
	set_process(true)
	set_process_input(true)
	currentCP = totalCP #Novo turno, restabelecer Command Points
	var info = str("", currentCP)
	get_node("../UI/cp_info").set_text(info)
	
	pass
	
func end_turn():
	
	if(unitSelected == true):
		finish_current_action()
	playing = false
	set_process(false)	
	set_process_input(false)
	
	pass
	
func is_playing():
	if (playing):
		return true
	else:
		return false
	pass

#********
#HUD
	
	
	
func show_terrain_info(var posX, var posY): #Recebe posição em TILES como argumento, seta a label de informações do terreno
	var tile = get_node("../TileMap").get_cell(posX,posY) #Dá informações do terreno / unidade
	
	if(tile == 0): #Grama
		get_node("../UI/terrain_info").set_text("Grass\n\nCost: 2 points(tank)\n1 point (infantry)")
	elif(tile>0 && tile<50): #Estrada
		get_node("../UI/terrain_info").set_text("Pavement\n\nCost: 1 point to move")	
	elif (tile == 50 or tile==51 or tile==52): #Árvores
		get_node("../UI/terrain_info").set_text("Tree(s)\n\nCost: 3 points to move")
	elif (tile == -1): #Fora do mapa
		get_node("../UI/terrain_info").set_text("Out of bounds,\nno quittin', soldier!")
	elif(tile>52 && tile<59):  #Edifícios 1
		get_node("../UI/terrain_info").set_text("Buildings\n\nCannot be crossed")
	elif(tile>60 && tile<70):  #Edifícios 2
		get_node("../UI/terrain_info").set_text("Buildings\n\nCannot be crossed")
	elif(tile>69 && tile<81):  #Rio
		get_node("../UI/terrain_info").set_text("River\n\nCannot be crossed")
	elif(tile==59):
		get_node("../UI/terrain_info").set_text("Human HQ\n\nIf captured,\nWermacht loses")
	elif(tile==60):
		get_node("../UI/terrain_info").set_text("Robot HQ\n\nIf captured,\nLegiertem loses")
	else:
		get_node("../UI/terrain_info").set_text("")
	pass
func show_unit_info(var posX, var posY): #Recebe posição em TILES como argumento, seta a label de informações do terreno

	var player1_unit = get_node("../player1").get_unit_in_pos(posX, posY)
	var player2_unit = get_node("../player2").get_unit_in_pos(posX, posY)
	
	var hp
	var atk
	var ran
	var moves

	if(player1_unit != "N/A"):
		hp = get_node(player1_unit).get_hp()
		atk = get_node(player1_unit).get_atk()
		ran = get_node(player1_unit).get_ran()
		moves = get_node(player1_unit).get_moves()
		var info = str("HP: ",hp,"\nATK: ", atk, "\nRANGE: ", ran, "\nMOVES: ", moves)
		get_node("../UI/unit_info").set_text(info)	
		
	elif(player2_unit != "N/A"):
		hp = get_node(player2_unit).get_hp()
		atk = get_node(player2_unit).get_atk()
		ran = get_node(player2_unit).get_ran()
		moves = get_node(player2_unit).get_moves()
		var info = str("HP: ",hp,"\nATK: ", atk, "\nRANGE: ", ran, "\nMOVES: ", moves)
		get_node("../UI/unit_info").set_text(info)
		
	else:
		get_node("../UI/unit_info").set_text("")	
#********
#INPUT E PROCESSING

func _input(ev):

		
	if (ev.type==InputEvent.MOUSE_MOTION):	#Mover cursor junto do mouse
		# ITALO ESTEVE AQUI HU3
		var position = get_node("../cam").get_pos()
		var posX = int((ev.pos.x + position.x - 400)/cell_size)
		var posY = int((ev.pos.y + position.y - 300)/cell_size)
		var cursorX = int(ev.pos.x / cell_size)
		var cursorY = int(ev.pos.y / cell_size)
		get_node("../UI/Control/Cursor").set_pos(Vector2(cursorX*80,cursorY*80))
		
		show_terrain_info(posX, posY)
		show_unit_info(posX, posY)
		
	if(ev.type==InputEvent.MOUSE_BUTTON and !ev.is_pressed()): #Selecionar a unidade, ela esta no mesmo tile clicado
		var position = get_node("../cam").get_pos()
		var posX = int((ev.pos.x + position.x - 400)/cell_size)
		var posY = int((ev.pos.y + position.y - 300)/cell_size)
		var i = 0
		#print("Mouse Click/Unclick at: ",posX, " ", posY)
		var tileID = get_node("../TileMap").get_cell(posX,posY)
		print("tile" + str (tileID))
		

		for i in range(units.size()):
			activeUnit = units[i]
			
			if(get_node(activeUnit) != null):
			
				var unit_pos = get_node(activeUnit).get_pos()
				
				if(posX==int(unit_pos.x/cell_size) and posY==int(unit_pos.y/cell_size) and unitSelected == false): #Esta na posicao e nao ha outra unidade selecionada
					unitSelected = true
					
					get_node(activeUnit).set_active()
					#get_node("../Control").hide()
					#set_process_input(false) #Ativa a unidade e desativa input do player
					break
		

func _process(delta):

	if(currentCP < 1): #Verificacao de fim de turno
		print("End of Turn")
		end_turn()
	

func _ready():
	end_turn()
	pass
