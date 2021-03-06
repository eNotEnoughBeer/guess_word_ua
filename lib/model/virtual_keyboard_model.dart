import 'package:flutter/material.dart';
import 'package:guess_word_ua/UI/colors_map.dart';
import 'package:guess_word_ua/view_model/view_model.dart';

class KeyboardKey extends ChangeNotifier {
  final String? text;
  final IconData iconData;
  final ValueSetter<String>? onTextInput;
  final VoidCallback? onPressed;
  final int flex;
  late Color color;
  KeyboardKey({
    this.text,
    IconData? iconData,
    this.onTextInput,
    this.onPressed,
    this.flex = 1,
    this.color = unusedColor,
  }) : iconData = iconData ?? Icons.add;

  KeyboardKey copyWith({
    String? text,
    ValueSetter<String>? onTextInput,
    VoidCallback? onPressed,
    int? flex,
    Color? color,
    IconData? iconData,
  }) {
    return KeyboardKey(
      text: text ?? this.text,
      onTextInput: onTextInput ?? this.onTextInput,
      onPressed: onPressed ?? this.onPressed,
      flex: flex ?? this.flex,
      color: color ?? this.color,
      iconData: iconData ?? this.iconData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KeyboardKey &&
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
  final List<KeyboardKey> _keyboard;
  List<KeyboardKey> get keyboard => _keyboard;

  final ValueSetter<String>? onTextInput;
  final VoidCallback? onBackspacePressed;
  final VoidCallback? onEnterPressed;
  KeyboardModel({
    this.color = backgroundColor,
    this.onTextInput,
    this.onBackspacePressed,
    this.onEnterPressed,
  }) : _keyboard = List<KeyboardKey>.generate(35, (index) {
          if (index == 24) {
            return standardKeyboardUA[index]
                .copyWith(onPressed: onBackspacePressed);
          } else if (index == 34) {
            return standardKeyboardUA[index]
                .copyWith(onPressed: onEnterPressed);
          } else {
            return standardKeyboardUA[index].copyWith(onTextInput: onTextInput);
          }
        }, growable: false);

  static List<KeyboardKey> standardKeyboardUA = <KeyboardKey>[
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(text: '??'),
    KeyboardKey(iconData: Icons.backspace_outlined, flex: 3),
    KeyboardKey(text: '??', flex: 2),
    KeyboardKey(text: '??', flex: 2),
    KeyboardKey(text: '??', flex: 2),
    KeyboardKey(text: '??', flex: 2),
    KeyboardKey(text: '??', flex: 2),
    KeyboardKey(text: '??', flex: 2),
    KeyboardKey(text: '??', flex: 2),
    KeyboardKey(text: '??', flex: 2),
    KeyboardKey(text: '??', flex: 2),
    KeyboardKey(iconData: Icons.subdirectory_arrow_left, flex: 3),
  ];

  void resetKeyboard() {
    for (int i = 0; i < _keyboard.length; i++) {
      if (_keyboard[i].color != unusedColor) {
        _keyboard[i].color = unusedColor;
        _keyboard[i].notifyListeners();
      }
    }
  }

  void redrawColors(List<LetterByUsage> currentWord) {
    for (var e in currentWord) {
      var index = _keyboard.indexWhere((element) => element.text == e.char);
      if (index == -1) continue;
      if (e.status == LetterStatus.useless) {
        if (_keyboard[index].color != unusedColor) continue;
        _keyboard[index].color = absentColor;
      } else {
        _keyboard[index].color = presentOnCorrectPositionColor;
      }
      _keyboard[index].notifyListeners();
    }
  }
}
