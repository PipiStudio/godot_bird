extends Node2D

@onready var start_button = $CanvasLayer/VBoxContainer/StartButton
@onready var config = ConfigFile.new()
@onready var option_button = $CanvasLayer/VBoxContainer/OptionButton
@onready var high_score_lable = $CanvasLayer/VBoxContainer/HighScore

func start_game():
	get_tree().change_scene_to_file("res://scns/world.tscn")

func _on_start_button_pressed() -> void:
	start_game()

func _ready() -> void:
	var path = "user://config.cfg"
	
	# 尝试加载配置
	var err = config.load(path)
	
	if err != OK:
		# 文件不存在或读取失败 → 创建默认配置
		print("配置文件不存在，创建默认配置...")
		
		config.set_value("Game", "skill", 0)  # 先设置默认值
		config.set_value("Game", "high_score", 0)

		err = config.save(path)  # 再保存
		if err == OK:
			print("默认配置已创建并保存")
		else:
			print("❌ 保存失败！错误码：", err)
	else:
		print("配置已加载")

	# 现在确保 config 里有数据了，可以读取 skill
	var current_skill = config.get_value("Game", "skill", 0)
	high_score_lable.text = "当前最高分:" + str(config.get_value("Game", "high_score", 0))
	option_button.selected = int(current_skill)
	print("当前 skill 等级：", current_skill)
	print(config.get_value("Game","high_score"))

func _on_option_button_item_selected(index: int) -> void:
	config.set_value("Game", "skill", index)
	var err = config.save("user://config.cfg")
	if err == OK:
		print("技能等级已保存：", index)
	else:
		print("保存失败：", err)
