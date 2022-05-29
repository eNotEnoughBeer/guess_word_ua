import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/view_model/view_model.dart';

class LetterKeyData extends ChangeNotifier {
  final String? text;
  final IconData iconData;
  final ValueSetter<String>? onTextInput;
  final VoidCallback? onPressed;
  final int flex;
  late Color color;
  LetterKeyData({
    this.text,
    this.iconData = Icons.add,
    this.onTextInput,
    this.onPressed,
    this.flex = 1,
    this.color = unusedColor,
  });

  LetterKeyData copyWith({
    String? text,
    ValueSetter<String>? onTextInput,
    VoidCallback? onPressed,
    int? flex,
    Color? color,
  }) {
    return LetterKeyData(
      text: text ?? this.text,
      onTextInput: onTextInput ?? this.onTextInput,
      onPressed: onPressed ?? this.onPressed,
      flex: flex ?? this.flex,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LetterKeyData &&
        other.text == text &&
        other.onTextInput == onTextInput &&
        other.onPressed == onPressed &&
        other.flex == flex &&
        other.color == color;
  }

  @override
  int get hashCode =>
      text.hashCode ^
      flex.hashCode ^
      color.hashCode ^
      onTextInput.hashCode ^
      onPressed.hashCode;
}

class KeyboardModel extends ChangeNotifier {
  final Color color;
  late final _keyboardTotal = <LetterKeyData>[];
  List<LetterKeyData> get keyboard => _keyboardTotal;

  final ValueSetter<String>? onTextInput;
  final VoidCallback? onBackspacePressed;
  final VoidCallback? onEnterPressed;
  KeyboardModel({
    this.color = backgroundColor,
    this.onTextInput,
    this.onBackspacePressed,
    this.onEnterPressed,
  }) {
    _initKeyboard();
  }

  void _textInputHandler(String text) => onTextInput?.call(text);
  void _backspaceHandler() => onBackspacePressed?.call();
  void _enterHandler() => onEnterPressed?.call();
  void _initKeyboard() {
    _keyboardTotal
        .add(LetterKeyData(text: 'Й', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Ц', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'У', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'К', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Е', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Н', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Г', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Ґ', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Ш', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Щ', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'З', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Х', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Ф', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'І', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Ї', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'В', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'А', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'П', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Р', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'О', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Л', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Д', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Ж', onTextInput: _textInputHandler));
    _keyboardTotal
        .add(LetterKeyData(text: 'Є', onTextInput: _textInputHandler));
    _keyboardTotal.add(LetterKeyData(
        iconData: Icons.backspace_outlined,
        onPressed: _backspaceHandler,
        flex: 3));
    _keyboardTotal
        .add(LetterKeyData(text: 'Я', onTextInput: _textInputHandler, flex: 2));
    _keyboardTotal
        .add(LetterKeyData(text: 'Ч', onTextInput: _textInputHandler, flex: 2));
    _keyboardTotal
        .add(LetterKeyData(text: 'С', onTextInput: _textInputHandler, flex: 2));
    _keyboardTotal
        .add(LetterKeyData(text: 'М', onTextInput: _textInputHandler, flex: 2));
    _keyboardTotal
        .add(LetterKeyData(text: 'И', onTextInput: _textInputHandler, flex: 2));
    _keyboardTotal
        .add(LetterKeyData(text: 'Т', onTextInput: _textInputHandler, flex: 2));
    _keyboardTotal
        .add(LetterKeyData(text: 'Ь', onTextInput: _textInputHandler, flex: 2));
    _keyboardTotal
        .add(LetterKeyData(text: 'Б', onTextInput: _textInputHandler, flex: 2));
    _keyboardTotal
        .add(LetterKeyData(text: 'Ю', onTextInput: _textInputHandler, flex: 2));
    _keyboardTotal.add(LetterKeyData(
        iconData: Icons.subdirectory_arrow_left,
        onPressed: _enterHandler,
        flex: 3));
  }

  void resetKeyboard() {
    for (int i = 0; i < _keyboardTotal.length; i++) {
      if (_keyboardTotal[i].color != unusedColor) {
        _keyboardTotal[i].color = unusedColor;
        _keyboardTotal[i].notifyListeners();
      }
    }
  }

  void redrawColors(List<LetterByUsage> currentWord) {
    for (var e in currentWord) {
      var index =
          _keyboardTotal.indexWhere((element) => element.text == e.char);
      if (index == -1) continue;
      if (e.status == LetterStatus.useless) {
        if (_keyboardTotal[index].color != unusedColor) continue;
        _keyboardTotal[index].color = absentColor;
      } else {
        _keyboardTotal[index].color = presentOnCorrectPositionColor;
      }
      _keyboardTotal[index].notifyListeners();
    }
    notifyListeners();
  }
}
