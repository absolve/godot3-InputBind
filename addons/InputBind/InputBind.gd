extends Node

#事件类型
const EVENT_TYPE=[ 'KEYBOARD', 'MOUSE', 'JOY_BUTTON', 'JOY_AXIS']

#设备id
const DEVICE_ID_LIST=['DEVICE all',
'DEVICE 0','DEVICE 1','DEVICE 2','DEVICE 3',
'DEVICE 4','DEVICE 5','DEVICE 6','DEVICE 7']

#鼠标按钮
const MOUSE_BTN_NAME=["Left Button","Right Button",
"Middle Button","Wheel Up Button","Wheel Down Button",
"Wheel Left Button","Wheel Right Button","X Button 1",
"X Button 2"]

#手柄按钮
const JOY_BTN_NAME=["DualShock Cross, Xbox A, Nintendo B",
"DualShock Circle, Xbox B, Nintendo A","DualShock Square, Xbox X, Nintendo Y",
"DualShock Triangle, Xbox Y, Nintendo X","L, L1",
"R, R1","L2","R2","L3","R3","Select, DualShock Share, Nintendo -",
"Start, DualShock Options, Nintendo +","D-Pad Up",
"D-Pad Down","D-Pad Left","D-Pad Right","Home, DualShock PS, Guide",
"Xbox Share, PS5 Microphone, Nintendo Capture","Xbox Paddle 1",
"Xbox Paddle 2","Xbox Paddle 3","Xbox Paddle 4","PS4/5 Touchpad",]

#摇杆轴
const JOY_AXIS_NAME=["(Left Stick Left)","(Left Stick Right)",
"(Left Stick Up)","(Left Stick Down)","(Right Stick Left)",
"(Right Stick Right)","(Right Stick Up)","(Right Stick Down)","","","","","",
"(L2)","","(R2)","","","",""]


#保存配置文件
var configFile="testInputEvent.ini"

#信号
signal addEvent
signal setEvent
signal removeEvent

#数据格式{"id":"ui_home","name":"back menu","tip":"tip":"tip ......"}
#id是action name代表游戏中的功能 tip是提示
var actions=[{'id':'move_up','name':"move_up",'tip':"tip..."},
{'id':'move_down','name':"move_down",'tip':"tip..."},
{'id':'move_left','name':"move_left",'tip':"tip..."},
{'id':'move_right','name':"move_right",'tip':"tip..."}]

func _ready():
#	var a=InputMap.get_actions()
#	print(a)
#	for i in a:
#		actions.append(i)
	loadConfig()
	pass

#载入配置文件
func loadConfig():
	var cfg = ConfigFile.new()
	var err = cfg.load(OS.get_executable_path().get_base_dir()+"/"+configFile)
	if err != OK:
		printerr('Failure:',err)
		newConfigFile()
	else:
		for i in cfg.get_sections():
			if i=='Actions':
				var input=parse_json(cfg.get_value(i,'Input'))
				print(input)
				if input:
					setActionEvent(input)
				
#保存配置					
func saveConfig():
	var cfg = ConfigFile.new()
	var data:Dictionary = {}
	for i in actions:#将事件保存到文件里面
		var event=InputMap.get_action_list(i.id)
		data[i.id]=[]
		for z in event:
			var button_data:Dictionary = {}
			if z is InputEventKey:
				button_data["eventtype"] = "InputEventKey"
				button_data["scancode"] = z.scancode
			elif z is InputEventJoypadButton:
				button_data["eventtype"] = "InputEventJoypadButton"
				button_data["device"] = z.device
				button_data["button_index"] = z.button_index
			elif z is InputEventJoypadMotion:
				button_data["eventtype"] = "InputEventJoypadMotion"
				button_data["device"] = z.device
				button_data["axis"] = z.axis
				button_data["axis_value"] = z.axis_value
			elif z is InputEventMouseButton:
				button_data["eventtype"] = "InputEventMouseButton"
				button_data["device"] = z.device
				button_data["button_index"] = z.button_index
			data[i.id].push_back(button_data)
	cfg.set_value("Actions","Input",to_json(data))
	cfg.save(OS.get_executable_path().get_base_dir()+"/"+configFile)		
			
			
#设置一个新的配置文件
func newConfigFile():
	var config = ConfigFile.new()
	config.set_value("Actions","Input",'')
	config.save(OS.get_executable_path().get_base_dir()+"/"+configFile)
	pass

#设置动作的事件
func setActionEvent(data):
	for i in actions:
		if !data.has(i.id):
			continue
		var event=data[i.id]
		var eventList=[]
		for z in event:
			var NewEvent:InputEvent
			if z.eventtype == "InputEventKey":
				NewEvent = InputEventKey.new()
				NewEvent.scancode = z.scancode
			elif z.eventtype == "InputEventJoypadButton":
				NewEvent = InputEventJoypadButton.new()
				NewEvent.device = z.device
				NewEvent.button_index = z.button_index
			elif z.eventtype=='InputEventJoypadMotion':
				NewEvent = InputEventJoypadMotion.new()
				NewEvent.device = z.device
				NewEvent.axis = z.axis
				NewEvent.axis_value = z.axis_value
			elif z.eventtype=='InputEventMouseButton':
				NewEvent = InputEventMouseButton.new()
				NewEvent.device = z.device
				NewEvent.button_index = z.button_index
			eventList.append(NewEvent)
		InputMap.action_erase_events(i.id)	
		for e in eventList:
			InputMap.action_add_event(i.id,e)	
			
