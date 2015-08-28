extends Node2D
var cell_size = 80
#HUMAN PANZER

# Propriedades
export var moves = 4 #numero de moves
export var hp = 5
export var atk = 3 #Attack
export var ran = 3 #Range of Attack

var current_player
var next_player

var active
var coordinates
var currentMoves
var currentRange
var options = 0
var tile
var coord = []
var pathFind
var target = []
#--------------------------------------------------------------------------------	
#********
#getters and setters
func get_moves():
	return moves
	pass
	
func get_atk():
	return atk
	pass
	
func get_ran():
	return ran
	pass

func get_hp():
	return hp
	pass

	
	
func set_hp(var newhp):
	hp = newhp
	pass
#--------------------------------------------------------------------------------	
#Funcoes para SONS
func play_selection_sound():
	var sound = randi() % 13 #GERA UM VALOR DE 0 A 12 PARA AS VOZES
	if(sound==1):
		get_node("../Sound/Human_voices").play("Human1")
	elif(sound==2):
		get_node("../Sound/Human_voices").play("Human3")
	elif(sound==3):
		get_node("../Sound/Human_voices").play("Human4")
	elif(sound==4):
		get_node("../Sound/Human_voices").play("Human5")
	elif(sound==5):
		get_node("../Sound/Human_voices").play("Human6")
	elif(sound==6):
		get_node("../Sound/Human_voices").play("Human7")
	elif(sound==7):
		get_node("../Sound/Human_voices").play("Human8")
	elif(sound==8):
		get_node("../Sound/Human_voices").play("Human9")
	elif(sound==9):
		get_node("../Sound/Human_voices").play("Tank1") #PARA PANZER
	elif(sound==10):
		get_node("../Sound/Human_voices").play("Tank2")
	elif(sound==11):
		get_node("../Sound/Human_voices").play("Tank3")
#--------------------------------------------------------------------------------	
#********
#Funcoes para atividade de unidades
#func finish_action():	

func set_active():
	active = true
	currentMoves = moves
	currentRange = ran
	#print("INTIAL RNG: ", currentRange)	
	coordinates = get_pos()/80
	print("Ready for deployment!")
	set_process(true)
	set_process_input(true)
	
	#------------------
	#Pega o jogador atual e o proximo	
	current_player = get_node("../").get_currentPlayer()
	if (current_player == "player1"):
		next_player = "../player2"
	else :
		next_player = "../player1"
	print("NEXT PLAYER:  ", next_player)
	#------------------
#	print("INTIAL RANGE: ", currentRange)
	target_preview(coordinates.x,coordinates.y, currentRange)
	walk_preview(coordinates.x,coordinates.y, currentMoves)
	play_selection_sound()
	update()
	pass

func deactivate():

	currentMoves = 0
	#walk_preview(coordinates.x,coordinates.y, currentMoves)
	update()# Apaga os quadardinhos
	print("shutting down...")
	active = false
	set_process(false)
	set_process_input(false)
	#Limpa os vetores de coordenadas e targets

	coord.clear()
	target.clear()
	
	pass

func is_active():
	if (active):
		return true
	else:
		return false
	pass


#**************************
#FUNCOES DE READY, PROCESSING E INPUT
func _ready():
	active = false
	set_process_input(false)
	pass

func _process(delta):
	
	coordinates = get_pos()/80
	
	if(currentMoves - terrain(coordinates.x,coordinates.y) < 0 or currentMoves == 0):
		print("Out of moves")
		deactivate()
		
		get_node("../").currentPlayer_finish_action()
func _input(ev):

	if(ev.type==InputEvent.MOUSE_BUTTON and !ev.is_pressed()):
		
		if (ev.button_index == 1): #MOUSE ESQUERDO, ANDAR
			var position = get_node("../cam").get_pos()
			var posX = int((ev.pos.x + position.x - 400)/cell_size)
			var posY = int((ev.pos.y + position.y - 300)/cell_size)
			print("Mouse Click/Unclick at: ",posX, " ", posY)		
			#print(str(coord[i]))
			for i in range(coord.size()):
				if(posX==int(coord[i].x) and posY==int(coord[i].y)): #Clicou numa posição que a unidade pode se mover 
					#currentMoves -= pathFinding(posX, posY)
					var unit_pos = Vector2(int(coord[i].x)*80+32, int(coord[i].y)*80+32)
					set_pos(unit_pos)
					coordinates = get_pos()/80
					
					coord.clear()
					#walk_preview(coordinates.x,coordinates.y, currentMoves)
					
					target.clear()
					#target_preview(coordinates.x, coordinates.y, currentRange)
					currentMoves=0
					update()
					break
					
		if (ev.button_index == 2 and !ev.is_pressed()): #MOUSE DIREITO, ATACAR
			var position = get_node("../cam").get_pos()
			var posX = int((ev.pos.x + position.x - 400)/cell_size)
			var posY = int((ev.pos.y + position.y - 300)/cell_size)
		#	print("Mouse Click/Unclick at: ",posX, " ", posY)
			for i in range(target.size()):
				var tx = int(get_node(target[i]).get_pos().x/80)
				var ty = int(get_node(target[i]).get_pos().y/80)
				
				if(posX == tx and posY == ty and currentMoves >0): #Clicou em um alvo atacável
					currentMoves = 0
					attack(target[i]) #A unidade atacada recebe o dano do atacante

#**************************
#FUNCOES DE PATHFINDING E WALKPREVIEW

func terrain(x, y):
	var tile = get_node("../TileMap").get_cell(x,y)
	#print("Terrain: ",tile)
	if (tile == 0 ): #Grama
		return 2
	elif (tile == 50 or tile==51 or tile==52): #Árvores
		return 3
	elif (tile == -1): #Fora do mapa
		return 1000
	elif(tile>52 && tile<59):  #Edifícios 1
		return 1000
	elif(tile>60 && tile<69):  #Edifícios 2
		return 1000
	elif(tile>68 && tile<81):  #Rio
		return 1000
	else:	#ruas
		return 1
	pass

func pathFinding(iDest, jDest):
	pathFind = 0
	path(iDest, jDest, int(get_pos().x/80), int(get_pos().y/80), 0)
	return pathFind*-1

func path(iDest, jDest, i,j, totalMoves):
	i = int(i)
	j = int(j)
	var vetor = vetor
	if(i == iDest and j == jDest):
		#print("Aqui")
		#print("Total: ",totalMoves," pathFind: ", pathFind)
		if(totalMoves < pathFind):
			pathFind = totalMoves
	else:
		totalMoves-=terrain(i,j)
		if(iDest-i < 0): #left
			path(iDest, jDest, i-1, j, totalMoves)
		if(iDest-i > 0): #right
			path(iDest, jDest, i+1, j, totalMoves)
		if(jDest-j < 0): #up
			path(iDest, jDest, i, j-1, totalMoves)
		if(jDest-j > 0):#down
			path(iDest, jDest, i, j+1, totalMoves)

func walk_preview(i, j, remainMoves):
	var newPosX = float( i )#EM TILE
	var newPosY = float( j )#EM TILE
	var newPos = Vector2(newPosX, newPosY)
	var diferent = true
	
	if(coord.size() != 0):
		for i in range(coord.size()):
			if(coord[i].x==newPosX and coord[i].y==newPosY):
				diferent = false

	if(terrain(i,j)==1000):
		diferent = false
	
	if(diferent):
		coord.append(newPos)
	
	if(remainMoves - terrain(i,j) >= 0 && remainMoves > 0):
		remainMoves -= terrain(i,j)
		#left
		walk_preview(i-1, j, remainMoves)
		#right
		walk_preview(i+1, j, remainMoves)
		#up
		walk_preview(i, j-1, remainMoves)
		#down
		walk_preview(i, j+1, remainMoves)
		
	if(coord.size() != 0):
		for i in range(coord.size()):
			if(coord[i].x==newPosX and coord[i].y==newPosY):
				diferent = false
	
	if(diferent):
		coord.append(newPos)

#**************************
#FUNCOES DE TARGTET_PREVIEW E COMBATE


func sight(x, y):
	var tile = get_node("../TileMap").get_cell(x,y)
	if (tile == 0 ): #Grama
		return 1
	elif (tile == 50 or tile==51 or tile==52): #Árvores
		return 3
	elif (tile == -1): #Fora do mapa
		return 1000
	elif(tile>52 && tile<59):  #Edifícios 1
		return 1000
	elif(tile>60 && tile<69):  #Edifícios 2
		return 1000
	elif(tile>68 && tile<81):  #Rio
		return 1
	else:	#ruas
		return 1
	pass


func target_preview(i, j, remainRange):


	var newPosX = float( i ) #EM TILE
	var newPosY = float( j ) #EM TILE
	var newPos = Vector2(newPosX, newPosY) 
	var lock_on = false #Confirma se o lugar eh o alvo
	
	var enemy = get_node(next_player).get_unit_in_pos(newPosX, newPosY)
#	print("ENEMY: ", enemy)
#	print("REMAINING RANGE: ", remainRange)
	if (enemy != "N/A"):#Se houver uma unidade inimga no lugar (ou que n eh do player), lock_on sera verdade
		lock_on = true #No caso, lock_on será true
	
	
	if(target.size() != 0):
#		print ("Entrou em cond 228")
		for i in range(target.size()):
			var tx = int(get_node(target[i]).get_pos().x/80)
			var ty = int(get_node(target[i]).get_pos().y/80)
			if(tx==newPosX and ty==newPosY):
				print ("TX E TY",tx," ",ty,"newPosX E newPosY",newPosX, " ", newPosY)
				lock_on = false
				
	if(lock_on):
#		print ("Entrou em cond 235")
		target.append(enemy)			#Se, após todas as checagens, ele for true, o PATH do inimigo é adicionado ao vetor. Com o path, conseguimos alterar os stats em caso de combate
	
	if(remainRange - sight(i,j) > 0 && remainRange > 0 ):
#		print ("Entrou em cond 239")	
		remainRange -= sight(i,j)
		#left
		target_preview(i-1, j, remainRange)
		#right
		target_preview(i+1, j, remainRange)
		#up
		target_preview(i, j-1, remainRange)
		#down
		target_preview(i, j+1, remainRange)

	if(target.size() !=0): 
		for i in range(target.size()):
			var tx = int(get_node(target[i]).get_pos().x/80)
			var ty = int(get_node(target[i]).get_pos().y/80)
			if(tx==newPosX and ty==newPosY):
				print ("TX E TY",tx," ",ty,"newPosX E newPosY",newPosX, " ", newPosY)	
				lock_on = false
				
	if(lock_on):
#		print ("Entrou em cond 257")	
		target.append(enemy)

func attack(var target_path): #FUNÇÃO DE ATAQUE
	var hp = get_node(target_path).get_hp()
	hp = hp - atk 
	get_node("../Sound/War_melodies").play("Tiro tanque + explosao")
	if(get_node("../Sound/Awaits").is_playing()==false):
		get_node("../Sound/Awaits").play()
		get_node("../Sound/Smooth").stop()
	if(hp<=0):
	
		#get_node(target_path).queue_free()
		get_node(next_player).rem_unit(target_path)
		
	else:
		get_node(target_path).set_hp(hp)

#**************************
#FUNÇÃO DE DRAW

func _draw():
	if (active):
		#Desenha areas para movimento
		for i in range(coord.size()):
			draw_rect(Rect2( int(coord[i].x)*80-get_pos().x ,int(coord[i].y)*80-get_pos().y,80,80), Color(0,0,1,0.2))
			
		#Desenha alvos possíveis
		for i in range(target.size()):
			var tx = int(get_node(target[i]).get_pos().x - get_pos().x - 32) #-32 para corrigir um desvio que ocorre
			var ty = int(get_node(target[i]).get_pos().y - get_pos().y - 32)
			draw_rect(Rect2( tx ,ty , 80,80), Color(1,0,0,0.4))