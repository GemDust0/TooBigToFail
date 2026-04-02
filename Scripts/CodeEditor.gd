extends TileMapLayer

var wrongLetterCol: String = Color(1, 0, 0).to_html()
var wrongWhitespaceCol: String = Color(1, 0.0, 0.0, 0.3).to_html()
var untypedCol: String = Color(1, 1, 1, 0.3).to_html()

@onready var previewNode: RichTextLabel = $Preview
@onready var initialText: String = tabs_to_spaces(previewNode.text)
@onready var inputNode: CodeEdit = $Input

func _ready() -> void: # func _process(delta: float) -> void:
	inputNode.grab_focus()

func tabs_to_spaces(text: String) -> String:
	var newText: String = text
	var lines: PackedStringArray = text.split("\n")
	var line_offset: int = 0
	for line_index in range(lines.size()):
		var offset: int = 0
		for index in range(lines[line_index].length()):
			if lines[line_index].substr(index, 1) == "\t":
				var actualIndex: int = index + offset + line_offset
				var offsetIndex: int = index + offset
				newText = newText.substr(0, actualIndex) + " ".repeat(4-(offsetIndex%4)) + newText.substr(actualIndex + 1)
				offset += 3-(offsetIndex%4)
		line_offset += newText.split("\n")[line_index].length() + 1
	return newText

func _on_input_text_changed() -> void:
	previewNode.clear()
	previewNode.append_text("[color=#%s]" % untypedCol)
	var input_text: String = tabs_to_spaces(inputNode.text)
	var line_indices: Array[int] = [0]
	var line_lengths: Array[int] = []
	for line in initialText.split("\n"):
		line_indices.append(line_indices.back() + line.length() + 1)
		line_lengths.append(line.length() + 1)
	line_indices.pop_back()
	var lines: PackedStringArray = input_text.split("\n")
	for line_index in range(lines.size()):
		if line_index < line_indices.size():
			for index in range(lines[line_index].length()):
				var actualIndex: int = line_indices[line_index] + index
				var curChar: String = initialText.substr(actualIndex, 1)
				var curInputChar: String = lines[line_index].substr(index, 1)
				if curChar == "\n":
					break
				if curInputChar != " ":
					if curInputChar != curChar:
						previewNode.append_text("[color=#%s]" % wrongLetterCol + curInputChar + "[color=#%s]" % untypedCol)
					else:
						#inputWrongs.append_text(" ")
						previewNode.append_text(" ")
				else:
					if curInputChar != curChar:
						previewNode.append_text("[color=#%s]" % wrongWhitespaceCol + curChar + "[color=#%s]" % untypedCol)
					else:
						previewNode.append_text(curChar)
			if lines[line_index].length() < line_lengths[line_index]:
				previewNode.append_text(initialText.substr(line_indices[line_index] + lines[line_index].length(), line_lengths[line_index] - lines[line_index].length()))
			else:
				previewNode.append_text("\n")
	
	if lines.size() < line_indices.size():
		previewNode.append_text(initialText.substr(line_indices[lines.size()]))
