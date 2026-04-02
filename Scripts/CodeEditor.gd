extends TileMapLayer

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
	var input_text: String = tabs_to_spaces(inputNode.text)
	var line_indices: Array[int] = [0]
	for line in initialText.split("\n"):
		line_indices.append(line_indices.back() + line.length())
	line_indices.pop_back()
	var lines: PackedStringArray = input_text.split("\n")
	for line_index in range(lines.size()):
		if line_index < line_indices.size():
			for index in range(lines[line_index].length()):
				var actualIndex: int = line_indices[line_index] + index + line_index
				var curChar: String = initialText.substr(actualIndex, 1)
				if curChar == "\n":
					break
				previewNode.text = previewNode.text.substr(0, actualIndex) + " " + initialText.substr(actualIndex + 1)
