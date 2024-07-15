extends MarginContainer
@onready var TextEd = $MarginContainer/TextEdit
@onready var Text = $MarginContainer/MarginContainer/RichTextLabel


func _ready():
	var textedit = TextEdit

func _on_text_edit_text_changed():
	Text.set_text(TextEd.text)


func _on_text_edit_caret_changed():
	print(TextEd.get_selected_text())
	%Caret.position = TextEd.get_caret_draw_pos() + Vector2(19, 36)


func _on_button_pressed():
	print("Text ",Text.text.find(TextEd.text))
