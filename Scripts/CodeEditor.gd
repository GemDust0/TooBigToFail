class_name CodeEditor extends TileMapLayer

var wrongLetterCol: String = Color(1, 0, 0).to_html()
var wrongWhitespaceCol: String = Color(1, 0.0, 0.0, 0.3).to_html()
var untypedCol: String = Color(1, 1, 1, 0.3).to_html()
var prevText: String = ""
var prevColumn: int = 0
var isFocused: bool

@onready var previewNode: RichTextLabel = $Preview
@onready var initialText: String = tabs_to_spaces(previewNode.text)
@onready var inputNode: CodeEdit = $Preview/Input

func _ready() -> void:
	focus()
	inputNode.size.x += inputNode.position.x + 5

func focus() -> void:
	isFocused = true
	inputNode.grab_focus()

func defocus() -> void:
	isFocused = false;
	inputNode.release_focus()

func tabs_to_spaces(text: String) -> String:
	var newText: String = text
	var lines: PackedStringArray = text.split("\n")
	var line_offset: int = 0
	for line_index: int in range(lines.size()):
		var offset: int = 0
		for index: int in range(lines[line_index].length()):
			if lines[line_index].substr(index, 1) == "\t":
				var actualIndex: int = index + offset + line_offset
				var offsetIndex: int = index + offset
				newText = newText.substr(0, actualIndex) + " ".repeat(4-(offsetIndex%4)) + newText.substr(actualIndex + 1)
				offset += 3-(offsetIndex%4)
		line_offset += newText.split("\n")[line_index].length() + 1
	return newText

func _on_input_text_changed() -> void:
	@warning_ignore("int_as_enum_without_cast")
	if (previewNode.get_theme_font("font").get_string_size(inputNode.text.split("\n")[inputNode.get_caret_line()], 0, -1, previewNode.get_theme_font_size("normal_font_size")).x > previewNode.size.x) or (inputNode.text.split("\n").size() > (previewNode.text.count("\n")+1)):
		var caret_line: int = inputNode.get_caret_line()
		inputNode.text = prevText
		inputNode.set_caret_line(caret_line)
		inputNode.set_caret_column(prevColumn)
		return
	
	previewNode.clear()
	previewNode.append_text("[color=#%s]" % untypedCol)
	var input_text: String = tabs_to_spaces(inputNode.text)
	var line_indices: Array[int] = [0]
	var line_lengths: Array[int] = []
	for line: String in initialText.split("\n"):
		line_indices.append(line_indices.back() + line.length() + 1)
		line_lengths.append(line.length() + 1)
	line_indices.pop_back()
	var lines: PackedStringArray = input_text.split("\n")
	for line_index: int in range(lines.size()):
		if line_index < line_indices.size():
			for index: int in range(lines[line_index].length()):
				var actualIndex: int = line_indices[line_index] + index
				var curChar: String = initialText.substr(actualIndex, 1)
				var curInputChar: String = lines[line_index].substr(index, 1)
				if curChar == "\n":
					previewNode.append_text("[color=#%s]" % wrongLetterCol + lines[line_index].substr(index) + "[color=#%s]" % untypedCol)
					break
				if curInputChar != " ":
					if curInputChar != curChar:
						previewNode.append_text("[color=#%s]" % wrongLetterCol + curInputChar + "[color=#%s]" % untypedCol)
					else:
						previewNode.append_text(curInputChar)
				else:
					if curInputChar != curChar:
						previewNode.append_text("[color=#%s]" % wrongWhitespaceCol + curChar + "[color=#%s]" % untypedCol)
					else:
						previewNode.append_text(curChar)
				@warning_ignore("int_as_enum_without_cast")
				if previewNode.get_theme_font("font").get_string_size(previewNode.get_parsed_text().substr(previewNode.get_parsed_text().rfind("\n")) + " ", 0, -1, previewNode.get_theme_font_size("normal_font_size")).x > previewNode.size.x:
					previewNode.append_text("\n")
			if lines[line_index].length() < line_lengths[line_index]:
				previewNode.append_text(initialText.substr(line_indices[line_index] + lines[line_index].length(), line_lengths[line_index] - lines[line_index].length()))
			else:
				previewNode.append_text("\n")
	
	if lines.size() < line_indices.size():
		previewNode.append_text(initialText.substr(line_indices[lines.size()]))
	prevText = inputNode.text
	prevColumn = inputNode.get_caret_column()
	previewNode.append_text("\n%f" % get_correctness())

func _on_input_caret_changed() -> void:
	prevColumn = inputNode.get_caret_column()

func change_code(new_code: String) -> void:
	prevText = ""
	prevColumn = 0
	initialText = tabs_to_spaces(new_code)
	inputNode.text = ""
	_on_input_text_changed()

func get_correctness() -> float:
	if inputNode.text.length() == 0:
		return -1.0
	var input_text: String = tabs_to_spaces(inputNode.text)
	var count: int = 0
	for index: int in range(input_text.length()):
		if input_text.substr(index, 1) == initialText.substr(index, 1):
			count += 1
	return float(count)/initialText.length()

func _on_input_focus_entered() -> void:
	print("TEST")
	if !isFocused:
		inputNode.release_focus()

func _on_input_focus_exited() -> void:
	if isFocused:
		inputNode.grab_focus()
