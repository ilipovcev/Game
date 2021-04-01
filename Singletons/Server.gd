extends Node

#var ip = "25.105.171.34"
const port = 1909;
var userNick = "Unnamed";

func connectServer(ip, nick):
  var network = NetworkedMultiplayerENet.new()
  userNick = nick;

  network.create_client(ip, port)
  get_tree().set_network_peer(null)
  get_tree().set_network_peer(network)

  get_tree().change_scene("res://LoadScreen.tscn"); #Смена сцены на загрузочный экран
  network.connect("connection_succeeded", self, "_On_connection_succeeded")
  network.connect("connection_failed", self, "_On_connection_failed")


func _On_connection_succeeded():
  print("Connection suceeded")
  print("Player ", userNick, " register...")
  rpc_id(1, "RegPlayer", userNick) #Регистрация клиента на сервере
  get_tree().change_scene("res://Game.tscn") #Смена сцены на игру

#Подтверждение от сервера об успешной регистрации клиента
remote func OnRegPlayer(pl: Array):
  print("Player #", pl[0], " registered with nickname ", pl[1], ".");

#Не удалось подключиться к серверу, возврат в меню. Нужна сцена с сообщением об ошибке
func _On_connection_failed():
  get_tree().change_scene("res://StartMenu/Menu.tscn")
  print("Connection failed")

#Соообщение серверу о том, что у игрока изменилось ХП
func SetArmy(HP):
  rpc_id(1, "PlayerStatsChanged", HP)

#Соообщение серверу о том, что игрок победил
func playerWin():
  rpc_id(1, "PlayerWin")

#Сообщение о том, что игрок победил. Смена сцены на главное меню. Нужна сцена сообщения
remote func getWinner(playerName):
  print(playerName, " is winner")
  get_tree().set_network_peer(null)
  get_tree().change_scene("res://StartMenu/Menu.tscn")